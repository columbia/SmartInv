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
23  ///// Version 6.3 /////
24 
25 //// Contract 01
26 contract OwnableContract {    
27     event onTransferOwnership(address newOwner);
28 	address superOwner; 
29 	
30     constructor() public { 
31         superOwner = msg.sender;
32     }
33     modifier restricted() {
34         require(msg.sender == superOwner);
35         _;
36     } 
37 	
38     function viewSuperOwner() public view returns (address owner) {
39         return superOwner;
40     }
41       
42     function changeOwner(address newOwner) restricted public {
43         require(newOwner != superOwner);       
44         superOwner = newOwner;     
45         emit onTransferOwnership(superOwner);
46     }
47 }
48 
49 //// Contract 02
50 contract BlockableContract is OwnableContract {    
51     event onBlockHODLs(bool status);
52     bool public blockedContract;
53     
54     constructor() public { 
55         blockedContract = false;  
56     }
57     
58     modifier contractActive() {
59         require(!blockedContract);
60         _;
61     } 
62     
63     function doBlockContract() restricted public {
64         blockedContract = true;        
65         emit onBlockHODLs(blockedContract);
66     }
67     
68     function unBlockContract() restricted public {
69         blockedContract = false;        
70         emit onBlockHODLs(blockedContract);
71     }
72 }
73 
74 //// Contract 03
75 contract ldoh is BlockableContract {
76 	
77 	event onAddContractAddress(address indexed contracthodler, bool contractstatus, uint256 _maxcontribution);     
78 	event onCashbackCode(address indexed hodler, address cashbackcode);
79     event onStoreProfileHash(address indexed hodler, string profileHashed);
80     event onHodlTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
81     event onClaimTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);	
82 	event onAffiliateBonus(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
83     event onReturnAll(uint256 returned);	// Delete
84 	
85 	    // Variables 	
86     address internal AXPRtoken;			//ABCDtoken;	// Delete
87 	address internal DefaultToken;		
88 	
89 		// Struct Database
90 
91     struct Safe {
92         uint256 id;						// 01 -- > Registration Number
93         uint256 amount;					// 02 -- > Total amount of contribution to this transaction
94         uint256 endtime;				// 03 -- > The Expiration Of A Hold Platform Based On Unix Time
95         address user;					// 04 -- > The ETH address that you are using
96         address tokenAddress;			// 05 -- > The Token Contract Address That You Are Using
97 		string  tokenSymbol;			// 06 -- > The Token Symbol That You Are Using
98 		uint256 amountbalance; 			// 07 -- > 88% from Contribution / 72% Without Cashback
99 		uint256 cashbackbalance; 		// 08 -- > 16% from Contribution / 0% Without Cashback
100 		uint256 lasttime; 				// 09 -- > The Last Time You Withdraw Based On Unix Time
101 		uint256 percentage; 			// 10 -- > The percentage of tokens that are unlocked every month ( Default = 3% )
102 		uint256 percentagereceive; 		// 11 -- > The Percentage You Have Received
103 		uint256 tokenreceive; 			// 12 -- > The Number Of Tokens You Have Received
104 		uint256 lastwithdraw; 			// 13 -- > The Last Amount You Withdraw
105 		address referrer; 				// 14 -- > Your ETH referrer address
106     }
107 	
108 		// Uint256
109 	
110 	uint256 public 	percent 				= 1200;        	// 01 -- > Monthly Unlock Percentage
111 	uint256 private constant affiliate 		= 12;        	// 02 -- > Affiliate Bonus = 12% Of Total Contributions
112 	uint256 private constant cashback 		= 16;        	// 03 -- > Cashback Bonus = 16% Of Total Contributions
113 	uint256 private constant nocashback 	= 28;        	// 04 -- > Total % loss amount if you don't get cashback
114 	uint256 private constant totalreceive 	= 88;        	// 05 -- > The total amount you will receive
115     uint256 private constant seconds30days 	= 2592000;  	// 06 -- > Number Of Seconds In One Month
116 	uint256 public  hodlingTime;							// 07 -- > Length of hold time in seconds
117 	uint256 private _currentIndex; 							// 08 -- > ID number ( Start from 500 )							//IDNumber
118 	uint256 public  _countSafes; 							// 09 -- > Total Smart Contract User							//TotalUser
119 	
120 	uint256 public allTimeHighPrice;						// Delete
121     uint256 public comission;								// Delete
122 	mapping(address => string) 	public profileHashed; 		// Delete
123 	
124 		// Mapping
125 	
126 	mapping(address => bool) 			public contractaddress; 	// 01 -- > Contract Address 	
127 	mapping(address => address) 		public cashbackcode; 		// 02 -- > Cashback Code 							
128 	mapping(address => uint256) 		public _totalSaved; 		// 03 -- > Token Balance				//TokenBalance		
129 	mapping(address => uint256[]) 		public _userSafes;			// 04 -- > Search ID by Address 		//IDAddress
130 	mapping(address => uint256) 		private EthereumVault;    // 05 -- > Reserve Funds					//old = _systemReserves
131 	mapping(uint256 => Safe) 			public _safes; 				// 06 -- > Struct safe database			//Private
132 	mapping(address => uint256) 		public maxcontribution; 	// 07 -- > Maximum Contribution					//New					
133 	mapping(address => uint256) 		public AllContribution; 	// 08 -- > Deposit amount for all members		//New		
134 	mapping(address => uint256) 		public AllPayments; 		// 09 -- > Withdraw amount for all members		//New	
135 	mapping(address => string) 			public ContractSymbol; 		// 10 -- > Contract Address Symbol				//New	
136 	mapping(address => address[]) 		public refflist;			// 11 -- > Referral List by ID					//New
137 	
138     	// Double Mapping
139 
140 	mapping (address => mapping (address => uint256)) public LifetimeContribution;	// 01 -- > Total Deposit Amount Based On Address & Token  //New
141 	mapping (address => mapping (address => uint256)) public LifetimePayments;		// 02 -- > Total Withdraw Amount Based On Address & Token //New	
142 	mapping (address => mapping (address => uint256)) public Affiliatevault;		// 02 -- > Affiliate Balance That Hasn't Been Withdrawn	  //New
143 	mapping (address => mapping (address => uint256)) public Affiliateprofit;		// 03 -- > The Amount Of Profit As An Affiliate			  //New
144 	
145 	
146     address[] public _listedReserves;		// Delete
147     
148 		//Constructor
149    
150     constructor() public {
151         
152         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;  	
153 		DefaultToken	= 0xA15C7Ebe1f07CaF6bFF097D8a589fb8AC49Ae5B3;  	
154         hodlingTime 	= 730 days;
155         _currentIndex 	= 500;
156         comission 		= 3;
157     }
158     
159 	
160 	
161 ////////////////////////////////// Available For Everyone //////////////////////////////////	
162 
163 
164 	
165 //// Function 01 - Fallback Function To Receive Donation In Eth
166     function () public payable {
167         require(msg.value > 0);       
168         EthereumVault[0x0] = add(EthereumVault[0x0], msg.value);
169     }
170 	
171 	
172 //// Function 02 - Contribute (Hodl Platform)
173     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
174         require(tokenAddress != 0x0);
175 		require(amount > 0 && amount <= maxcontribution[tokenAddress] );
176 		
177 		if (contractaddress[tokenAddress] == false) {
178 			revert();
179 		}
180 		else {
181 			
182 		
183         ERC20Interface token = ERC20Interface(tokenAddress);       
184         require(token.transferFrom(msg.sender, address(this), amount));
185 		
186 		uint256 affiliatecomission 		= div(mul(amount, affiliate), 100); 	
187 		uint256 no_cashback 			= div(mul(amount, nocashback), 100); 	
188 		
189 		 	if (cashbackcode[msg.sender] == 0 ) { 				
190 			uint256 data_amountbalance 		= div(mul(amount, 72), 100);	
191 			uint256 data_cashbackbalance 	= 0; 
192 			address data_referrer			= superOwner;
193 			
194 			cashbackcode[msg.sender] = superOwner;
195 			emit onCashbackCode(msg.sender, superOwner);
196 			
197 			EthereumVault[tokenAddress] 	= add(EthereumVault[tokenAddress], no_cashback);
198 			
199 			} else { 	
200 			data_amountbalance 				= sub(amount, affiliatecomission);			
201 			data_cashbackbalance 			= div(mul(amount, cashback), 100);			
202 			data_referrer					= cashbackcode[msg.sender];
203 			uint256 referrer_contribution 	= LifetimeContribution[data_referrer][tokenAddress];
204 
205 				if (referrer_contribution >= amount) {
206 		
207 					Affiliatevault[data_referrer][tokenAddress] 	= add(Affiliatevault[data_referrer][tokenAddress], affiliatecomission); 
208 					Affiliateprofit[data_referrer][tokenAddress] 	= add(Affiliateprofit[data_referrer][tokenAddress], affiliatecomission); 
209 					
210 				} else {
211 					
212 					uint256 Newbie 	= div(mul(referrer_contribution, affiliate), 100); 
213 					
214 					Affiliatevault[data_referrer][tokenAddress] 	= add(Affiliatevault[data_referrer][tokenAddress], Newbie); 
215 					Affiliateprofit[data_referrer][tokenAddress] 	= add(Affiliateprofit[data_referrer][tokenAddress], Newbie); 
216 					
217 					uint256 data_unusedfunds 		= sub(affiliatecomission, Newbie);	
218 					EthereumVault[tokenAddress] 	= add(EthereumVault[tokenAddress], data_unusedfunds);
219 					
220 				}
221 			
222 			} 	
223 			  		  				  					  
224 	// Insert to Database  		
225 	
226 		refflist[data_referrer].push(msg.sender);	
227 		_userSafes[msg.sender].push(_currentIndex);
228 		_safes[_currentIndex] = 
229 
230 		Safe(
231 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, data_referrer);	
232 
233 		LifetimeContribution[msg.sender][tokenAddress] = add(LifetimeContribution[msg.sender][tokenAddress], amount); 		
234 		
235 	// Update AllContribution, _totalSaved, _currentIndex, _countSafes
236 		AllContribution[tokenAddress] 	= add(AllContribution[tokenAddress], amount);   	
237         _totalSaved[tokenAddress] 		= add(_totalSaved[tokenAddress], amount);     		
238         _currentIndex++;
239         _countSafes++;
240         
241         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
242     }	
243 			
244 			
245 }
246 		
247 	
248 //// Function 03 - Claim Token That Has Been Unlocked
249     function ClaimTokens(address tokenAddress, uint256 id) public {
250         require(tokenAddress != 0x0);
251         require(id != 0);        
252         
253         Safe storage s = _safes[id];
254         require(s.user == msg.sender);  
255 		
256 		if (s.amountbalance == 0) {
257 			revert();
258 		}
259 		else {
260 			RetireHodl(tokenAddress, id);
261 		}
262     }
263     
264     function RetireHodl(address tokenAddress, uint256 id) private {
265         Safe storage s = _safes[id];
266         
267         require(s.id != 0);
268         require(s.tokenAddress == tokenAddress);
269 
270         uint256 eventAmount;
271         address eventTokenAddress = s.tokenAddress;
272         string memory eventTokenSymbol = s.tokenSymbol;		
273 		     
274         if(s.endtime < now) // Hodl Complete
275         {
276             PayToken(s.user, s.tokenAddress, s.amountbalance);
277             
278             eventAmount 				= s.amountbalance;
279 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
280 		
281 		s.lastwithdraw = s.amountbalance;
282 		s.amountbalance = 0;
283 		s.lasttime 						= now;  
284 		s.tokenreceive 					= div(mul(s.amount, totalreceive), 100) ;
285 		s.percentagereceive 			= mul(mul(88, 100), 100000000000000000000) ;
286 		
287 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
288 		
289         }
290         else 
291         {
292 			
293 			uint256 timeframe  			= sub(now, s.lasttime);			                            
294 			uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), seconds30days); 
295 		//	uint256 CalculateWithdraw   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
296 		                         
297 			uint256 MaxWithdraw 		= div(s.amount, 10);
298 			
299 			// Maximum withdraw before unlocked, Max 10% Accumulation
300 			if (CalculateWithdraw > MaxWithdraw) { 				
301 			uint256 MaxAccumulation = MaxWithdraw; 
302 			} else { MaxAccumulation = CalculateWithdraw; }
303 			
304 			// Maximum withdraw = User Amount Balance   
305 			if (MaxAccumulation > s.amountbalance) { 			     	
306 			uint256 realAmount = s.amountbalance; 
307 			} else { realAmount = MaxAccumulation; }
308 			
309 			s.lastwithdraw = realAmount;  			
310 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
311 			UpdateUserData(tokenAddress, id, newamountbalance, realAmount);
312 			
313 		}
314         
315     }   
316 
317     function UpdateUserData(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
318         Safe storage s = _safes[id];
319         
320         require(s.id != 0);
321         require(s.tokenAddress == tokenAddress);
322 
323         uint256 eventAmount;
324         address eventTokenAddress = s.tokenAddress;
325         string memory eventTokenSymbol = s.tokenSymbol;			
326    			
327 		s.amountbalance 				= newamountbalance;  
328 		s.lasttime 						= now;  
329 		
330 			uint256 tokenaffiliate 		= div(mul(s.amount, affiliate), 100) ; 
331 			uint256 maxcashback 		= div(mul(s.amount, cashback), 100) ; 		
332 			uint256 tokenreceived 		= sub(add(sub(sub(s.amount, tokenaffiliate), newamountbalance), s.cashbackbalance), maxcashback) ;		
333 		//	uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance + s.cashbackbalance - maxcashback ;
334 			
335 			// Cashback = 100 - 12 - 88 + 16 - 16 = 0 ----> No_Cashback 	= 100 - 12 - 72 + 0 - 16 = 1
336 
337 			uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
338 		
339 		s.tokenreceive 					= tokenreceived; 
340 		s.percentagereceive 			= percentagereceived; 		
341 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
342 		
343 		
344 	        PayToken(s.user, s.tokenAddress, realAmount);           		
345             eventAmount = realAmount;
346 			
347 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
348     } 
349 
350     function PayToken(address user, address tokenAddress, uint256 amount) private {
351 		
352 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
353 		LifetimePayments[msg.sender][tokenAddress] = add(LifetimePayments[user][tokenAddress], amount); 
354         
355         ERC20Interface token = ERC20Interface(tokenAddress);        
356         require(token.balanceOf(address(this)) >= amount);
357         token.transfer(user, amount);
358     }   	
359 	
360 //// Function 04 - Get How Many Contribute ?
361     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
362         return _userSafes[hodler].length;
363     }
364 	
365 	
366 //// Function 05 - Get How Many Referral ?
367     function GetTotalReferral(address hodler) public view returns (uint256 length) {
368         return refflist[hodler].length;
369     }
370     
371 	
372 //// Function 06 - Get complete data from each user
373 	function GetSafe(uint256 _id) public view
374         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
375     {
376         Safe storage s = _safes[_id];
377         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
378     }
379 	
380 	
381 //// Function 07 - Get Tokens Reserved For Ethereum Vault
382     function GetTokenReserve(address tokenAddress) public view returns (uint256 amount) {
383         return EthereumVault[tokenAddress];
384     }    
385     
386 	
387 //// Function 08 - Get Ethereum Contract's Balance  
388     function GetContractBalance() public view returns(uint256)
389     {
390         return address(this).balance;
391     } 	
392 	
393 	
394 //// Function 09 - Cashback Code  
395     function CashbackCode(address _cashbackcode) public {
396 		require(_cashbackcode != msg.sender);
397 		
398 		if (cashbackcode[msg.sender] == 0) {
399 			cashbackcode[msg.sender] = _cashbackcode;
400 			emit onCashbackCode(msg.sender, _cashbackcode);
401 		}		             
402     }  
403 	
404 	
405 //// Function 10 - Withdraw Affiliate Bonus
406     function WithdrawAffiliate(address user, address tokenAddress) public {  
407 		require(tokenAddress != 0x0);
408 		require(user == msg.sender);
409 		
410 		uint256 amount = Affiliatevault[msg.sender][tokenAddress];
411 		
412 		_totalSaved[tokenAddress] 		= sub(_totalSaved[tokenAddress], amount); 
413 		AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], amount);
414 		
415 		uint256 eventAmount				= amount;
416         address eventTokenAddress 		= tokenAddress;
417         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
418 		
419 		Affiliatevault[msg.sender][tokenAddress] = 0;
420         
421         ERC20Interface token = ERC20Interface(tokenAddress);        
422         require(token.balanceOf(address(this)) >= amount);
423         token.transfer(user, amount);
424 		
425 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
426     } 		
427 	
428 	
429 //// Function 11 - Get User's Any Token Balance
430     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
431         require(tokenAddress != 0x0);
432         
433         for(uint256 i = 1; i < _currentIndex; i++) {            
434             Safe storage s = _safes[i];
435             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
436                 balance += s.amount;
437         }
438         return balance;
439     }
440 	
441 	
442 	
443 
444 ////////////////////////////////// restricted //////////////////////////////////
445 
446 //// 01 Add Contract Address	
447     function AddContractAddress(address tokenAddress, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol) public restricted {
448         contractaddress[tokenAddress] 	= contractstatus;
449 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
450 		maxcontribution[tokenAddress] 	= _maxcontribution;
451 		
452 		if (tokenAddress == DefaultToken && contractstatus == false) {
453 			contractaddress[tokenAddress] 	= true;
454 		}	
455 		
456 		emit onAddContractAddress(tokenAddress, contractstatus, _maxcontribution);
457     }
458 	
459 	
460 //// 02 - Add Maximum Contribution	
461     function AddMaxContribution(address tokenAddress, uint256 _maxcontribution) public restricted  {
462         maxcontribution[tokenAddress] = _maxcontribution;	
463     }
464 	
465 	
466 //// 03 - Add Retire Hodl	
467     function AddRetireHodl(address tokenAddress, uint256 id) public restricted {
468         require(tokenAddress != 0x0);
469         require(id != 0);      
470         RetireHodl(tokenAddress, id);
471     }
472 	
473     
474 //// 04 Change Hodling Time   
475     function ChangeHodlingTime(uint256 newHodlingDays) restricted public {
476         require(newHodlingDays >= 180);      
477         hodlingTime = newHodlingDays * 1 days;
478     }   
479 	
480 //// 05 - Change Speed Distribution 
481     function ChangeSpeedDistribution(uint256 newSpeed) restricted public {
482         require(newSpeed <= 12);   
483 		comission = newSpeed;		
484 		percent = newSpeed;
485     }
486 	
487 	
488 //// 06 - Withdraw Ethereum Received Through Fallback Function   
489     function WithdrawEth(uint256 amount) restricted public {
490         require(amount > 0); 
491         require(address(this).balance >= amount); 
492         
493         msg.sender.transfer(amount);
494     }
495 	
496     
497 //// 07 Withdraw Token Fees   
498     function WithdrawTokenFees(address tokenAddress) restricted public {
499         require(EthereumVault[tokenAddress] > 0);
500         
501         uint256 amount = EthereumVault[tokenAddress];
502 		_totalSaved[tokenAddress] 	= sub(_totalSaved[tokenAddress], amount); 
503         EthereumVault[tokenAddress] = 0;
504         
505         ERC20Interface token = ERC20Interface(tokenAddress);
506         
507         require(token.balanceOf(address(this)) >= amount);
508         token.transfer(msg.sender, amount);
509     }
510 	
511     
512 //// 08 - Return All Tokens To Their Respective Addresses    
513     function ReturnAllTokens(bool onlyAXPR) restricted public
514     {
515         uint256 returned;
516 
517         for(uint256 i = 1; i < _currentIndex; i++) {            
518             Safe storage s = _safes[i];
519             if (s.id != 0) {
520                 if (
521                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
522                     !onlyAXPR
523                     )
524                 {
525                     PayToken(s.user, s.tokenAddress, s.amountbalance);
526 					
527 					s.lastwithdraw 					= s.amountbalance;
528 					s.amountbalance 				= 0;
529 					s.lasttime 						= now;  
530 					
531 					s.percentagereceive 			= sub(add(totalreceive, s.cashbackbalance), 16); 
532 					s.tokenreceive 					= div(mul(s.amount, s.percentagereceive ), 100);		
533 
534 					_totalSaved[s.tokenAddress] 	= 0;					
535 					 
536                     _countSafes--;
537                     returned++;
538                 }
539             }
540         }
541 		
542         emit onReturnAll(returned);
543     }   
544 
545 
546     // SAFE MATH FUNCTIONS //
547 	
548 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
549 		if (a == 0) {
550 			return 0;
551 		}
552 
553 		uint256 c = a * b; 
554 		require(c / a == b);
555 		return c;
556 	}
557 	
558 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
559 		require(b > 0); 
560 		uint256 c = a / b;
561 		return c;
562 	}
563 	
564 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
565 		require(b <= a);
566 		uint256 c = a - b;
567 		return c;
568 	}
569 	
570 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
571 		uint256 c = a + b;
572 		require(c >= a);
573 		return c;
574 	}
575     
576 }
577 
578 contract ERC20Interface {
579 
580     uint256 public totalSupply;
581     uint256 public decimals;
582     
583     function symbol() public view returns (string);
584     function balanceOf(address _owner) public view returns (uint256 balance);
585     function transfer(address _to, uint256 _value) public returns (bool success);
586     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
587     function approve(address _spender, uint256 _value) public returns (bool success);
588     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
589 
590     // solhint-disable-next-line no-simple-event-func-name  
591     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
592     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
593 }