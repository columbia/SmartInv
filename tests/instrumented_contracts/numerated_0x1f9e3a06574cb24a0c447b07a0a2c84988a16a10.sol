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
23     =          Version 6.8         =
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
79 		  string _ContractSymbol,
80 		  uint256 _PercentPermonth, 
81 		  uint256 _HodlingTime	  
82 		);	
83 		
84 	event onCashbackCode(
85 		  address indexed hodler,
86 		  address cashbackcode
87 		);		
88 	
89 	event onUnlockedTokens(
90 	      uint256 returned
91 		);		
92 		
93 	event onReturnAll( 
94 	      uint256 returned   	// Delete
95 		);
96 	
97 	
98 	
99 	/*==============================
100     =          VARIABLES           =
101     ==============================*/   
102 
103 	address internal DefaultToken;		
104 	
105 		// Struct Database
106 
107     struct Safe {
108         uint256 id;						// 01 -- > Registration Number
109         uint256 amount;					// 02 -- > Total amount of contribution to this transaction
110         uint256 endtime;				// 03 -- > The Expiration Of A Hold Platform Based On Unix Time
111         address user;					// 04 -- > The ETH address that you are using
112         address tokenAddress;			// 05 -- > The Token Contract Address That You Are Using
113 		string  tokenSymbol;			// 06 -- > The Token Symbol That You Are Using
114 		uint256 amountbalance; 			// 07 -- > 88% from Contribution / 72% Without Cashback
115 		uint256 cashbackbalance; 		// 08 -- > 16% from Contribution / 0% Without Cashback
116 		uint256 lasttime; 				// 09 -- > The Last Time You Withdraw Based On Unix Time
117 		uint256 percentage; 			// 10 -- > The percentage of tokens that are unlocked every month ( Default = 3% )
118 		uint256 percentagereceive; 		// 11 -- > The Percentage You Have Received
119 		uint256 tokenreceive; 			// 12 -- > The Number Of Tokens You Have Received
120 		uint256 lastwithdraw; 			// 13 -- > The Last Amount You Withdraw
121 		address referrer; 				// 14 -- > Your ETH referrer address
122     }
123 	
124 		// Uint256
125 	
126 	uint256 private constant affiliate 		= 12;        	// 01 -- > Affiliate Bonus = 12% Of Total Contributions
127 	uint256 private constant cashback 		= 16;        	// 02 -- > Cashback Bonus = 16% Of Total Contributions
128 	uint256 private constant nocashback 	= 28;        	// 03 -- > Total % loss amount if you don't get cashback
129 	uint256 private constant totalreceive 	= 88;        	// 04 -- > The total amount you will receive
130     uint256 private constant seconds30days 	= 2592000;  	// 05 -- > Number Of Seconds In One Month
131 	uint256 private _currentIndex; 							// 06 -- > ID number ( Start from 500 )							//IDNumber
132 	uint256 public  _countSafes; 							// 07 -- > Total Smart Contract User							//TotalUser
133 	
134 		// Mapping
135 		
136 	mapping(address => bool) 			public contractaddress; 	// 01 -- > Contract Address 
137 	mapping(address => uint256) 		public percent; 			// 02 -- > Monthly Unlock Percentage (Default 3%)
138 	mapping(address => uint256) 		public hodlingTime; 		// 03 -- > Length of hold time in seconds	
139 	mapping(address => address) 		public cashbackcode; 		// 04 -- > Cashback Code 							
140 	mapping(address => uint256) 		public _totalSaved; 		// 05 -- > Token Balance				//TokenBalance		
141 	mapping(address => uint256[]) 		public _userSafes;			// 06 -- > Search ID by Address 		//IDAddress
142 	mapping(address => uint256) 		private EthereumVault;    	// 07 -- > Reserve Funds				
143 	mapping(uint256 => Safe) 			private _safes; 			// 08 -- > Struct safe database			
144 	mapping(address => uint256) 		public maxcontribution; 	// 09 -- > Maximum Contribution					//N				
145 	mapping(address => uint256) 		public AllContribution; 	// 10 -- > Deposit amount for all members		//N	
146 	mapping(address => uint256) 		public AllPayments; 		// 11 -- > Withdraw amount for all members		//N
147 	mapping(address => string) 			public ContractSymbol; 		// 12 -- > Contract Address Symbol				//N
148 	mapping(address => address[]) 		public afflist;				// 13 -- > Affiliate List by ID					//N
149 	
150     	// Double Mapping
151 
152 	mapping (address => mapping (address => uint256)) public LifetimeContribution;	// 01 -- > Total Deposit Amount Based On Address & Token  //N
153 	mapping (address => mapping (address => uint256)) public LifetimePayments;		// 02 -- > Total Withdraw Amount Based On Address & Token //N	
154 	mapping (address => mapping (address => uint256)) public Affiliatevault;		// 02 -- > Affiliate Balance That Hasn't Been Withdrawn	  //N
155 	mapping (address => mapping (address => uint256)) public Affiliateprofit;		// 03 -- > The Amount Of Profit As An Affiliate			  //N
156 	
157 	
158 	// Airdrop - Send 0 ETH
159 
160 						uint256 public Send0ETH_Reward; 		
161 						address public send0ETH_tokenaddress; 	
162 						   bool public send0ETH_status = false ; 		
163 	mapping(address => uint256) public Send0ETH_Balance;
164 	
165 	/*==============================
166     =          CONSTRUCTOR         =
167     ==============================*/  	
168    
169     constructor() public {
170         	 	
171         _currentIndex 	= 500;
172     }
173     
174 	
175 	/*==============================
176     =    AVAILABLE FOR EVERYONE    =
177     ==============================*/  
178 
179 //** Function 01 - Fallback Function To Receive Donation In Eth
180     function () public payable {    
181         if (msg.value > 0 ) {
182 		   EthereumVault[0x0] = add(EthereumVault[0x0], msg.value);
183 		}		
184       
185 		/*=======================================
186 		=     Get Reward, Only if Available     =
187 		========================================*/
188 	
189         if (msg.value == 0 && send0ETH_status == true ) {
190 			address tokenaddress 	= send0ETH_tokenaddress ;
191 			
192 			require(Send0ETH_Balance[tokenaddress] > 0);
193 		
194 			ERC20Interface token = ERC20Interface(tokenaddress);        
195 			require(token.balanceOf(address(this)) >= Send0ETH_Reward);
196 			token.transfer(msg.sender, Send0ETH_Reward);
197 			
198 			Send0ETH_Balance[tokenaddress] = sub(Send0ETH_Balance[tokenaddress], Send0ETH_Reward);
199 		}	
200 		
201     }
202 	
203 	
204 //** Function 02 - Cashback Code  
205     function CashbackCode(address _cashbackcode) public {
206 		require(_cashbackcode != msg.sender);
207 		
208 		if (cashbackcode[msg.sender] == 0) {
209 			cashbackcode[msg.sender] = _cashbackcode;
210 			emit onCashbackCode(msg.sender, _cashbackcode);
211 		}		             
212     } 
213 	
214 //** Function 03 - Contribute (Hodl Platform)
215     function HodlTokens(address tokenAddress, uint256 amount) public {
216         require(tokenAddress != 0x0);
217 		require(amount > 0 && amount <= maxcontribution[tokenAddress] );
218 		
219 		if (contractaddress[tokenAddress] == false) {
220 			revert();
221 		} else { HodlTokens2(tokenAddress, amount); }							
222 	}
223 		
224     function HodlTokens2(address tokenAddress, uint256 amount) private {
225 		
226 		if (cashbackcode[msg.sender] == 0 ) { 				
227 			uint256 data_amountbalance 		= div(mul(amount, 72), 100);	
228 			uint256 data_cashbackbalance 	= 0; 
229 			address ref						= EthereumNodes;
230 			cashbackcode[msg.sender] 		= EthereumNodes;
231 			uint256 no_cashback 			= div(mul(amount, nocashback), 100); 
232 			EthereumVault[tokenAddress] 	= add(EthereumVault[tokenAddress], no_cashback);
233 			
234 			emit onCashbackCode(msg.sender, EthereumNodes);
235 			
236 		} else { 	
237 			
238 			ref								= cashbackcode[msg.sender];
239 			uint256 affcomission 			= div(mul(amount, affiliate), 100); 
240 			data_amountbalance 				= sub(amount, affcomission);			
241 			data_cashbackbalance 			= div(mul(amount, cashback), 100);			
242 			uint256 ref_contribution 		= LifetimeContribution[ref][tokenAddress];		
243 			uint256 mycontribution			= add(LifetimeContribution[msg.sender][tokenAddress], amount);
244 
245 			if (ref_contribution >= mycontribution) {
246 		
247 				Affiliatevault[ref][tokenAddress] 	= add(Affiliatevault[ref][tokenAddress], affcomission); 
248 				Affiliateprofit[ref][tokenAddress] 	= add(Affiliateprofit[ref][tokenAddress], affcomission); 
249 					
250 			} else {
251 					
252 				uint256 Newbie 	= div(mul(ref_contribution, affiliate), 100); 
253 					
254 				Affiliatevault[ref][tokenAddress] 	= add(Affiliatevault[ref][tokenAddress], Newbie); 
255 				Affiliateprofit[ref][tokenAddress] 	= add(Affiliateprofit[ref][tokenAddress], Newbie); 				
256 				uint256 data_unusedfunds 			= sub(affcomission, Newbie);	
257 				EthereumVault[tokenAddress] 		= add(EthereumVault[tokenAddress], data_unusedfunds);
258 					
259 			}
260 		} 
261 
262 	HodlTokens3(tokenAddress, amount, data_amountbalance, data_cashbackbalance, ref); 
263 	
264 	}
265 	
266     function HodlTokens3(address tokenAddress, uint256 amount, uint256 data_amountbalance, uint256 data_cashbackbalance, address ref) private {
267 		
268 		ERC20Interface token = ERC20Interface(tokenAddress);       
269         require(token.transferFrom(msg.sender, address(this), amount));
270 				
271 		uint256 TokenPercent 			= percent[tokenAddress];	
272 		uint256 TokenHodlTime 			= hodlingTime[tokenAddress];	
273 		uint256 TokenHodlTimeFinal		= add(now, TokenHodlTime);
274 		
275 		uint256 data_a1 = amount;
276 		uint256 data_d1 = data_amountbalance;
277 		uint256 data_d2 = data_cashbackbalance;
278 		
279 		amount					= 0;
280 		data_amountbalance 		= 0;
281 		data_cashbackbalance	= 0;
282 		
283 		_safes[_currentIndex] = 
284 
285 		Safe(
286 		_currentIndex, data_a1, TokenHodlTimeFinal, msg.sender, tokenAddress, token.symbol(), data_d1, data_d2, now, TokenPercent, 0, 0, 0, ref);	
287 				
288 		LifetimeContribution[msg.sender][tokenAddress] 	= add(LifetimeContribution[msg.sender][tokenAddress], data_a1); 				
289 		AllContribution[tokenAddress] 					= add(AllContribution[tokenAddress], data_a1);   	
290         _totalSaved[tokenAddress] 						= add(_totalSaved[tokenAddress], data_a1);    
291 
292 		
293 		afflist[ref].push(msg.sender);	
294 		_userSafes[msg.sender].push(_currentIndex); 
295         _currentIndex++;
296         _countSafes++;
297         
298         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), data_a1, TokenHodlTimeFinal);
299 		
300 	}
301 	
302 //** Function 04 - Claim Token That Has Been Unlocked
303     function ClaimTokens(address tokenAddress, uint256 id) public {
304         require(tokenAddress != 0x0);
305         require(id != 0);        
306         
307         Safe storage s = _safes[id];
308         require(s.user == msg.sender);  
309 		
310 		if (s.amountbalance == 0) {
311 			revert();
312 		}
313 		else {
314 			UnlockToken(tokenAddress, id);
315 		}
316     }
317     
318     function UnlockToken(address tokenAddress, uint256 id) private {
319         Safe storage s = _safes[id];
320         
321         require(s.id != 0);
322         require(s.tokenAddress == tokenAddress);
323 
324         uint256 eventAmount;
325         address eventTokenAddress = s.tokenAddress;
326         string memory eventTokenSymbol = s.tokenSymbol;		
327 		     
328         if(s.endtime < now) // Hodl Complete
329         {
330             PayToken(s.user, s.tokenAddress, s.amountbalance);
331             
332             eventAmount 				= s.amountbalance;
333 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
334 		
335 		s.lastwithdraw 		= s.amountbalance;
336 		s.amountbalance 	= 0;
337 		s.lasttime 			= now;  
338 		
339 		    if(s.cashbackbalance > 0) {
340             s.tokenreceive 					= div(mul(s.amount, 88), 100) ;
341 			s.percentagereceive 			= mul(1000000000000000000, 88);
342             }
343 			else {
344 			s.tokenreceive 					= div(mul(s.amount, 72), 100) ;
345 			s.percentagereceive 			= mul(1000000000000000000, 72);
346 			}
347 		
348 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
349 		
350         }
351         else 
352         {
353 			
354 			UpdateUserData1(s.tokenAddress, s.id);
355 				
356 		}
357         
358     }   
359 	
360 	function UpdateUserData1(address tokenAddress, uint256 id) private {
361 			
362 		Safe storage s = _safes[id];
363         
364         require(s.id != 0);
365         require(s.tokenAddress == tokenAddress);		
366 			
367 			uint256 timeframe  			= sub(now, s.lasttime);			                            
368 			uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), seconds30days); 
369 		//	uint256 CalculateWithdraw   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
370 		                         
371 			uint256 MaxWithdraw 		= div(s.amount, 10);
372 			
373 			// Maximum withdraw before unlocked, Max 10% Accumulation
374 			if (CalculateWithdraw > MaxWithdraw) { 				
375 			uint256 MaxAccumulation = MaxWithdraw; 
376 			} else { MaxAccumulation = CalculateWithdraw; }
377 			
378 			// Maximum withdraw = User Amount Balance   
379 			if (MaxAccumulation > s.amountbalance) { 			     	
380 			uint256 realAmount1 = s.amountbalance; 
381 			} else { realAmount1 = MaxAccumulation; }
382 			
383 			// Including Cashback In The First Contribution
384 			
385 			uint256 amountbalance72 = div(mul(s.amount, 72), 100);
386 			
387 			if (s.amountbalance >= amountbalance72) { 				
388 			uint256 realAmount = add(realAmount1, s.cashbackbalance); 
389 			} else { realAmount = realAmount1; }	
390 			
391 			s.lastwithdraw = realAmount;  			
392 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
393 			UpdateUserData2(tokenAddress, id, newamountbalance, realAmount);
394 					
395     }   
396 
397     function UpdateUserData2(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
398         Safe storage s = _safes[id];
399         
400         require(s.id != 0);
401         require(s.tokenAddress == tokenAddress);
402 
403         uint256 eventAmount;
404         address eventTokenAddress = s.tokenAddress;
405         string memory eventTokenSymbol = s.tokenSymbol;		
406 
407 		s.amountbalance 				= newamountbalance;  
408 		s.lasttime 						= now;  
409 		
410 			uint256 tokenaffiliate 		= div(mul(s.amount, affiliate), 100) ; 
411 			uint256 maxcashback 		= div(mul(s.amount, cashback), 100) ; 		
412 			uint256 tokenreceived 		= sub(add(sub(sub(s.amount, tokenaffiliate), newamountbalance), s.cashbackbalance), maxcashback) ;		
413 		//	uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance + s.cashbackbalance - maxcashback ;
414 			
415 			// Cashback = 100 - 12 - 88 + 16 - 16 = 0 ----> No_Cashback 	= 100 - 12 - 72 + 0 - 16 = 1
416 			
417 			uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
418 		
419 		s.tokenreceive 					= tokenreceived; 
420 		s.percentagereceive 			= percentagereceived; 		
421 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
422 		
423 		
424 	        PayToken(s.user, s.tokenAddress, realAmount);           		
425             eventAmount = realAmount;
426 			
427 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
428     } 
429 	
430 
431     function PayToken(address user, address tokenAddress, uint256 amount) private {
432 		
433 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
434 		LifetimePayments[msg.sender][tokenAddress] 	= add(LifetimePayments[user][tokenAddress], amount); 
435         
436         ERC20Interface token = ERC20Interface(tokenAddress);        
437         require(token.balanceOf(address(this)) >= amount);
438         token.transfer(user, amount);
439     }   	
440 	
441 //** Function 05 - Get How Many Contribute ?
442     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
443         return _userSafes[hodler].length;
444     }
445 	
446 	
447 //** Function 06 - Get How Many Affiliate ?
448     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
449         return afflist[hodler].length;
450     }
451     
452 	
453 //** Function 07 - Get complete data from each user
454 	function GetSafe(uint256 _id) public view
455         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
456     {
457         Safe storage s = _safes[_id];
458         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
459     }
460 	
461 	
462 //** Function 08 - Get Tokens Reserved For Ethereum Vault
463     function GetTokenReserve(address tokenAddress) public view returns (uint256 amount) {
464         return EthereumVault[tokenAddress];
465     }    
466     
467 	
468 //** Function 09 - Get Ethereum Contract's Balance  
469     function GetContractBalance() public view returns(uint256)
470     {
471         return address(this).balance;
472     } 	
473 	
474 	
475 //** Function 10 - Withdraw Affiliate Bonus
476     function WithdrawAffiliate(address user, address tokenAddress) public {  
477 		require(tokenAddress != 0x0);
478 		
479 		require(Affiliatevault[user][tokenAddress] > 0 );
480 		
481 		uint256 amount = Affiliatevault[msg.sender][tokenAddress];
482 		Affiliatevault[msg.sender][tokenAddress] = 0;
483 		
484 		_totalSaved[tokenAddress] 		= sub(_totalSaved[tokenAddress], amount); 
485 		AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], amount);
486 		
487 		uint256 eventAmount				= amount;
488         address eventTokenAddress 		= tokenAddress;
489         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
490         
491         ERC20Interface token = ERC20Interface(tokenAddress);        
492         require(token.balanceOf(address(this)) >= amount);
493         token.transfer(user, amount);
494 		
495 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
496     } 		
497 	
498 	
499 //** Function 11 - Get User's Any Token Balance
500     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
501         require(tokenAddress != 0x0);
502         
503         for(uint256 i = 1; i < _currentIndex; i++) {            
504             Safe storage s = _safes[i];
505             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
506                 balance += s.amount;
507         }
508         return balance;
509     }
510 	
511 	
512 	
513 	/*==============================
514     =          RESTRICTED          =
515     ==============================*/  	
516 
517 //** 01 Add Contract Address	
518     function AddContractAddress(address tokenAddress, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth, uint256 _HodlingTime) public restricted {
519         contractaddress[tokenAddress] 	= contractstatus;
520 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
521 		maxcontribution[tokenAddress] 	= _maxcontribution;	
522 		percent[tokenAddress] 			= _PercentPermonth;
523 		
524 		uint256 HodlTime = _HodlingTime * 1 days;	
525 		hodlingTime[tokenAddress] 		= HodlTime;
526 		
527 		if (DefaultToken == 0) {
528 			DefaultToken = tokenAddress;
529 		}
530 		
531 		if (tokenAddress == DefaultToken && contractstatus == false) {
532 			contractaddress[tokenAddress] 	= true;
533 		}	
534 		
535 		emit onAddContractAddress(tokenAddress, contractstatus, _maxcontribution, _ContractSymbol, _PercentPermonth, _HodlingTime);
536     }
537 	
538 //** 02 - Add Speed Distribution 
539     function AddSpeedDistribution(address tokenAddress, uint256 newSpeed) restricted public {
540         require(newSpeed >= 3 && newSpeed <= 12);   	// % Permonth
541 		
542 		uint256 _HodlingTime 		= mul(div(72, newSpeed), 30);
543 		uint256 HodlTime 			= _HodlingTime * 1 days;	
544 		
545 		percent[tokenAddress] 		= newSpeed;	
546 		hodlingTime[tokenAddress] 	= HodlTime;
547 		
548     }
549 	
550 //** 03 - Add Maximum Contribution	
551     function AddMaxContribution(address tokenAddress, uint256 _maxcontribution) public restricted  {
552         maxcontribution[tokenAddress] = _maxcontribution;	
553     }
554 	
555 	
556 //** 04 - Withdraw Ethereum 
557     function WithdrawEth() restricted public {
558         require(address(this).balance > 0); 
559 		uint256 amount = address(this).balance;
560 		
561 		EthereumVault[0x0] = 0;
562         
563         msg.sender.transfer(amount);
564     }
565 	
566     
567 //** 05 Ethereum Nodes Fees   
568     function EthereumNodesFees(address tokenAddress) restricted public {
569         require(EthereumVault[tokenAddress] > 0);
570         
571         uint256 amount = EthereumVault[tokenAddress];
572 		_totalSaved[tokenAddress] 	= sub(_totalSaved[tokenAddress], amount); 
573         EthereumVault[tokenAddress] = 0;
574         
575         ERC20Interface token = ERC20Interface(tokenAddress);
576         
577         require(token.balanceOf(address(this)) >= amount);
578         token.transfer(msg.sender, amount);
579     }
580 	
581 	
582 //** 06 - Send All Tokens That Have Been Unlocked  
583     function SendUnlockedTokens() restricted public
584     {
585         uint256 returned;
586 
587         for(uint256 i = 1; i < _currentIndex; i++) {            
588             Safe storage s = _safes[i];
589             if (s.id != 0) {
590 				
591 				if(s.amountbalance > 0) {
592 					UpdateUserData1(s.tokenAddress, s.id);
593 				}
594 				   
595 				if(Affiliatevault[s.user][s.tokenAddress] > 0) {
596 					WithdrawAffiliate(s.user, s.tokenAddress);	
597 				}
598 
599             }
600         }
601 		
602         emit onUnlockedTokens(returned);
603     }   	
604 	
605 	
606 //** 07 - Return All Tokens To Their Respective Addresses    
607     function ReturnAllTokens() restricted public
608     {
609         uint256 returned;
610 
611         for(uint256 i = 1; i < _currentIndex; i++) {            
612             Safe storage s = _safes[i];
613             if (s.id != 0) {
614 				
615 				if(s.amountbalance > 0) {
616 					
617 					PayToken(s.user, s.tokenAddress, s.amountbalance);
618 					
619 					s.lastwithdraw 					= s.amountbalance;
620 					s.lasttime 						= now;  
621 					
622 					if(s.cashbackbalance > 0) {
623 					s.tokenreceive 					= div(mul(s.amount, 88), 100) ;
624 					s.percentagereceive 			= mul(1000000000000000000, 88);
625 					}
626 					else {
627 					s.tokenreceive 					= div(mul(s.amount, 72), 100) ;
628 					s.percentagereceive 			= mul(1000000000000000000, 72);
629 					}
630 					
631 					_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); 					
632 					s.amountbalance 				= 0;
633 
634                     returned++;
635 					
636 				}
637 				
638 
639                 
640             }
641         }
642 		
643         emit onReturnAll(returned);
644     }   
645 	
646 	
647 	
648 	/*==============================
649     =     Airdrop - Send 0 ETH     =
650     ==============================*/ 
651 	
652 	function Send0ETH_Withdraw(address tokenAddress) restricted public {
653 		require(tokenAddress != 0x0);
654         require(Send0ETH_Balance[tokenAddress] > 0);
655         
656         uint256 amount 					= Send0ETH_Balance[tokenAddress];
657         Send0ETH_Balance[tokenAddress] 	= 0;
658         
659         ERC20Interface token = ERC20Interface(tokenAddress);
660         
661         require(token.balanceOf(address(this)) >= amount);
662         token.transfer(msg.sender, amount);
663     }
664 	
665 	function Send0ETH_Deposit(address tokenAddress, uint256 amount) restricted public {
666         
667        	ERC20Interface token = ERC20Interface(tokenAddress);       
668         require(token.transferFrom(msg.sender, address(this), amount));
669 		
670 		Send0ETH_Balance[tokenAddress] = add(Send0ETH_Balance[tokenAddress], amount) ;
671 
672     }
673 	
674 	function Send0ETH_Setting(address tokenAddress, uint256 reward, bool _status) restricted public {
675 		Send0ETH_Reward 		= reward;
676 		send0ETH_tokenaddress 	= tokenAddress;
677 		send0ETH_status 		= _status;
678     }
679 	
680 
681 	/*==============================
682     =      SAFE MATH FUNCTIONS     =
683     ==============================*/  	
684 	
685 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
686 		if (a == 0) {
687 			return 0;
688 		}
689 
690 		uint256 c = a * b; 
691 		require(c / a == b);
692 		return c;
693 	}
694 	
695 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
696 		require(b > 0); 
697 		uint256 c = a / b;
698 		return c;
699 	}
700 	
701 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
702 		require(b <= a);
703 		uint256 c = a - b;
704 		return c;
705 	}
706 	
707 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
708 		uint256 c = a + b;
709 		require(c >= a);
710 		return c;
711 	}
712     
713 }
714 
715 
716 	/*==============================
717     =        ERC20 Interface       =
718     ==============================*/ 
719 
720 contract ERC20Interface {
721 
722     uint256 public totalSupply;
723     uint256 public decimals;
724     
725     function symbol() public view returns (string);
726     function balanceOf(address _owner) public view returns (uint256 balance);
727     function transfer(address _to, uint256 _value) public returns (bool success);
728     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
729     function approve(address _spender, uint256 _value) public returns (bool success);
730     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
731 
732     // solhint-disable-next-line no-simple-event-func-name  
733     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
734     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
735 }