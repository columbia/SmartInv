1 pragma solidity ^0.4.25;
2 
3 /**
4 
5 
6 					.----------------.  .----------------.  .----------------.  .----------------. 
7 					| .--------------. || .--------------. || .--------------. || .--------------. |
8 					| |  ____  ____  | || |     ____     | || |   _____      | || |  ________    | |
9 					| | |_   ||   _| | || |   .'    `.   | || |  |_   _|     | || | |_   ___ `.  | |
10 					| |   | |__| |   | || |  /  .--.  \  | || |    | |       | || |   | |   `. \ | |
11 					| |   |  __  |   | || |  | |    | |  | || |    | |   _   | || |   | |    | | | |
12 					| |  _| |  | |_  | || |  \  `--'  /  | || |   _| |__/ |  | || |  _| |___.' / | |
13 					| | |____||____| | || |   `.____.'   | || |  |________|  | || | |________.'  | |
14 					| |              | || |              | || |              | || |              | |
15 					| '--------------' || '--------------' || '--------------' || '--------------' |
16 					'----------------'  '----------------'  '----------------'  '----------------' 
17 
18 **/
19 
20 	/*==============================
21     =          Version 9.5       =
22     ==============================*/
23 	
24 contract EthereumSmartContract {    
25     address EthereumNodes; 
26 	
27     constructor() public { 
28         EthereumNodes = msg.sender;
29     }
30     modifier restricted() {
31         require(msg.sender == EthereumNodes);
32         _;
33     } 
34 	
35     function GetEthereumNodes() public view returns (address owner) { return EthereumNodes; }
36 }
37 
38 contract ldoh is EthereumSmartContract {
39 	
40 	/*==============================
41     =            EVENTS            =
42     ==============================*/
43 	
44 	event onCashbackCode	(address indexed hodler, address cashbackcode);		
45 	event onAffiliateBonus	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);		
46 	event onHoldplatform	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
47 	event onUnlocktoken		(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
48 	event onReceiveAirdrop	(address indexed hodler, uint256 amount, uint256 datetime);		
49 		
50 	
51 	/*==============================
52     =          VARIABLES           =
53     ==============================*/   
54 
55 	//-------o Burn = 2% o-------o Affiliate = 10% o-------o Cashback = 16% o-------o Total Receive = 88% o-------o Without Cashback = 72%	
56 	//-------o Hold 24 Months, Unlock 0.1% Perday ( 3% Permonth )
57 	
58 	// Struct Database
59 
60     struct Safe {
61         uint256 id;						// [01] -- > Registration Number
62         uint256 amount;					// [02] -- > Total amount of contribution to this transaction
63         uint256 endtime;				// [03] -- > The Expiration Of A Hold Platform Based On Unix Time
64         address user;					// [04] -- > The ETH address that you are using
65         address tokenAddress;			// [05] -- > The Token Contract Address That You Are Using
66 		string  tokenSymbol;			// [06] -- > The Token Symbol That You Are Using
67 		uint256 amountbalance; 			// [07] -- > 88% from Contribution / 72% Without Cashback
68 		uint256 cashbackbalance; 		// [08] -- > 16% from Contribution / 0% Without Cashback
69 		uint256 lasttime; 				// [09] -- > The Last Time You Withdraw Based On Unix Time
70 		uint256 percentage; 			// [10] -- > The percentage of tokens that are unlocked every month ( Default = 3% )
71 		uint256 percentagereceive; 		// [11] -- > The Percentage You Have Received
72 		uint256 tokenreceive; 			// [12] -- > The Number Of Tokens You Have Received
73 		uint256 lastwithdraw; 			// [13] -- > The Last Amount You Withdraw
74 		address referrer; 				// [14] -- > Your ETH referrer address
75 		bool 	cashbackstatus; 		// [15] -- > Cashback Status
76     }
77 	
78 	
79 	uint256 public nowtime; //Change before deploy
80 	uint256 public Burnstatus; 
81 	
82 	uint256 private idnumber; 										// [01] -- > ID number ( Start from 500 )				
83 	uint256 public  TotalUser; 										// [02] -- > Total Smart Contract User					
84 	mapping(address => address) 		public cashbackcode; 		// [03] -- > Cashback Code 					
85 	mapping(address => uint256[]) 		public idaddress;			// [04] -- > Search Address by ID			
86 	mapping(address => address[]) 		public afflist;				// [05] -- > Affiliate List by ID					
87 	mapping(address => string) 			public ContractSymbol; 		// [06] -- > Contract Address Symbol				
88 	mapping(uint256 => Safe) 			private _safes; 			// [07] -- > Struct safe database	
89 	mapping(address => bool) 			public contractaddress; 	// [08] -- > Contract Address 		
90 
91 	mapping (address => mapping (uint256 => uint256)) public Bigdata; 
92 	
93 /** Bigdata Mapping : 
94 [1] Percent (Monthly Unlocked tokens)		[7] All Payments 				[13] Total TX Affiliate (Withdraw) 		[19] Total TX Burn
95 [2] Holding Time (in seconds) 				[8] Active User 				[14] Current Price (USD)			
96 [3] Token Balance 							[9] Total User 					[15] ATH Price (USD)
97 [4] Total Burn								[10] Total TX Hold 				[16] ATL Price (USD)	
98 [5] Max Contribution 						[11] Total TX Unlock 			[17] Current ETH Price (ETH) 		
99 [6] All Contribution 						[12] Total TX Airdrop			[18] Date Register				
100 **/
101 
102 	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
103 // Statistics = [1] LifetimeContribution [2] LifetimePayments [3] Affiliatevault [4] Affiliateprofit [5] ActiveContribution	[6] Burn 
104 	
105 	
106 // Airdrop - Hold Platform (HOLD)		
107 	address public Holdplatform_address;											// [01]
108 	uint256 public Holdplatform_balance; 											// [02]
109 	mapping(address => uint256) public Holdplatform_status;							// [03]
110 	mapping(address => mapping (uint256 => uint256)) public Holdplatform_divider; 
111 // Holdplatform_divider = [1] Lock Airdrop	[2] Unlock Airdrop	[3] Affiliate Airdrop
112 	
113 	
114 	/*==============================
115     =          CONSTRUCTOR         =
116     ==============================*/  	
117    
118     constructor() public {     	 	
119         idnumber 				= 500;
120 		Holdplatform_address	= 0x23bAdee11Bf49c40669e9b09035f048e9146213e;	//Change before deploy
121     }
122     
123 	
124 	/*==============================
125     =    AVAILABLE FOR EVERYONE    =
126     ==============================*/  
127 
128 //-------o Function 01 - Ethereum Payable
129     function () public payable {  
130 		if (msg.value == 0) {
131 			tothe_moon();
132 		} else { revert(); }
133     }
134     function tothemoon() public payable {  
135 		if (msg.value == 0) {
136 			tothe_moon();
137 		} else { revert(); }
138     }
139 	function tothe_moon() private {  
140 		for(uint256 i = 1; i < idnumber; i++) {            
141 		Safe storage s = _safes[i];
142 		
143 			// Send all unlocked tokens
144 			if (s.user == msg.sender && s.amountbalance > 0) {
145 			Unlocktoken(s.tokenAddress, s.id);
146 			
147 				// Send all affiliate bonus
148 				if (Statistics[s.user][s.tokenAddress][3] > 0) {
149 				WithdrawAffiliate(s.user, s.tokenAddress);
150 				}
151 			}
152 		}
153     }
154 	
155 //-------o Function 02 - Cashback Code
156 
157     function CashbackCode(address _cashbackcode) public {		
158 		require(_cashbackcode != msg.sender);			
159 		
160 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 && Bigdata[_cashbackcode][8] == 1) { 
161 		cashbackcode[msg.sender] = _cashbackcode; }
162 		else { cashbackcode[msg.sender] = EthereumNodes; }		
163 		
164 	emit onCashbackCode(msg.sender, _cashbackcode);		
165     } 
166 	
167 //-------o Function 03 - Contribute 
168 
169 	//--o 01
170     function Holdplatform(address tokenAddress, uint256 amount) public {
171 		require(amount >= 1 );
172 		require(add(Statistics[msg.sender][tokenAddress][5], amount) <= Bigdata[tokenAddress][5] );
173 		
174 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 ) { 
175 			cashbackcode[msg.sender] 	= EthereumNodes;
176 		} 
177 		
178 		if (Bigdata[msg.sender][18] == 0) { 
179 			Bigdata[msg.sender][18] = now;
180 		} 
181 		
182 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
183 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
184         require(token.transferFrom(msg.sender, address(this), amount));	
185 		
186 		HodlTokens2(tokenAddress, amount);
187 		Airdrop(msg.sender, tokenAddress, amount, 1);
188 		}							
189 	}
190 	
191 	//--o 02	
192     function HodlTokens2(address ERC, uint256 amount) private {
193 		
194 		address ref						= cashbackcode[msg.sender];
195 		uint256 ReferrerContribution 	= Statistics[ref][ERC][5];	
196 		uint256 AffiliateContribution 	= Statistics[msg.sender][ERC][5];
197 		uint256 MyContribution 			= add(AffiliateContribution, amount); 
198 		
199 	  	if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) { 
200 			uint256 nodecomission 		= div(mul(amount, 26), 100);
201 			Statistics[ref][ERC][3] 	= add(Statistics[ref][ERC][3], nodecomission ); 
202 			Statistics[ref][ERC][4] 	= add(Statistics[ref][ERC][4], nodecomission );		
203 			
204 		} else { 
205 		
206 // Very complicated code, need to be checked carefully!		
207 
208 			uint256 affcomission_one 	= div(mul(amount, 10), 100); 
209 			
210 			if (ReferrerContribution >= MyContribution) { //--o  if referrer contribution >= My contribution
211 
212 				Statistics[ref][ERC][3] 		= add(Statistics[ref][ERC][3], affcomission_one); 
213 				Statistics[ref][ERC][4] 		= add(Statistics[ref][ERC][4], affcomission_one); 
214 
215 			} else {
216 					if (ReferrerContribution > AffiliateContribution  ) { 	
217 						if (amount <= add(ReferrerContribution,AffiliateContribution)  ) { 
218 						
219 						uint256 AAA					= sub(ReferrerContribution, AffiliateContribution );
220 						uint256 affcomission_two	= div(mul(AAA, 10), 100); 
221 						uint256 affcomission_three	= sub(affcomission_one, affcomission_two);		
222 						} else {	
223 						uint256 BBB					= sub(sub(amount, ReferrerContribution), AffiliateContribution);
224 						affcomission_three			= div(mul(BBB, 10), 100); 
225 						affcomission_two			= sub(affcomission_one, affcomission_three); } 
226 						
227 					} else { affcomission_two	= 0; 	affcomission_three	= affcomission_one; } 
228 // end //					
229 				Statistics[ref][ERC][3] 		= add(Statistics[ref][ERC][3], affcomission_two); 
230 				Statistics[ref][ERC][4] 		= add(Statistics[ref][ERC][4], affcomission_two); 	
231 	
232 				Statistics[EthereumNodes][ERC][3] 		= add(Statistics[EthereumNodes][ERC][3], affcomission_three); 
233 				Statistics[EthereumNodes][ERC][4] 		= add(Statistics[EthereumNodes][ERC][4], affcomission_three);	
234 			}	
235 		}
236 
237 		HodlTokens3(ERC, amount, ref); 	
238 	}
239 	//--o 04	
240     function HodlTokens3(address ERC, uint256 amount, address ref) private {
241 	    
242 		uint256 AvailableBalances 		= div(mul(amount, 72), 100);
243 		
244 		if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) 
245 		{ uint256	AvailableCashback = 0; } else { AvailableCashback = div(mul(amount, 16), 100);}
246 		
247 	    ERC20Interface token 	= ERC20Interface(ERC); 		
248 		uint256 HodlTime		= add(now, Bigdata[ERC][2]);
249 		
250 		_safes[idnumber] = Safe(idnumber, amount, HodlTime, msg.sender, ERC, token.symbol(), AvailableBalances, AvailableCashback, now, Bigdata[ERC][1], 0, 0, 0, ref, false);	
251 				
252 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], amount); 
253 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], amount); 	
254 		
255 		uint256 Burn 							= div(mul(amount, 2), 100);
256 		Statistics[msg.sender][ERC][6]  		= add(Statistics[msg.sender][ERC][6], Burn); 			
257 		Bigdata[ERC][6] 						= add(Bigdata[ERC][6], amount);   	
258         Bigdata[ERC][3]							= add(Bigdata[ERC][3], amount);  
259 
260 		if(Bigdata[msg.sender][8] == 1 ) {
261         idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][10]++;  }		
262 		else { 
263 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][9]++; Bigdata[ERC][10]++; TotalUser++;   }
264 		
265 		Bigdata[msg.sender][8] 	= 1;  	
266         emit onHoldplatform(msg.sender, ERC, token.symbol(), amount, HodlTime);	
267 		
268 			
269 	}
270 
271 //-------o Function 05 - Claim Token That Has Been Unlocked
272     function Unlocktoken(address tokenAddress, uint256 id) public {
273         require(tokenAddress != 0x0);
274         require(id != 0);        
275         
276         Safe storage s = _safes[id];
277         require(s.user == msg.sender);  
278 		require(s.tokenAddress == tokenAddress);
279 		
280 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
281     }
282     //--o 01
283     function UnlockToken2(address ERC, uint256 id) private {
284         Safe storage s = _safes[id];      
285         require(s.tokenAddress == ERC);		
286 		     
287         if(s.endtime < nowtime){ //--o  Hold Complete , Now time delete before deploy
288         
289 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
290 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
291 		s.lastwithdraw 							= amounttransfer;   s.amountbalance = 0;   s.lasttime = now; 
292 
293  		Airdrop(s.user, s.tokenAddress, amounttransfer, 2);
294 		PayToken(s.user, s.tokenAddress, amounttransfer); 
295 		
296 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
297             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
298             }
299 			else {
300 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
301 			}
302 			
303 		s.cashbackbalance = 0;	
304 		emit onUnlocktoken(msg.sender, s.tokenAddress, s.tokenSymbol, s.amountbalance, now);
305 		
306         } else { UnlockToken3(ERC, s.id); }
307         
308     }   
309 	//--o 02
310 	function UnlockToken3(address ERC, uint256 id) private {		
311 		Safe storage s = _safes[id];
312         require(s.tokenAddress == ERC);		
313 			
314 		uint256 timeframe  			= sub(now, s.lasttime);			                            
315 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
316 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
317 		                         
318 		uint256 MaxWithdraw 		= div(s.amount, 10);
319 			
320 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
321 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
322 			
323 		//--o Maximum withdraw = User Amount Balance   
324 			if (MaxAccumulation > s.amountbalance) { uint256 lastwithdraw = s.amountbalance; } else { lastwithdraw = MaxAccumulation; }
325 			
326 		s.lastwithdraw 				= add(s.cashbackbalance, lastwithdraw); 			
327 		s.amountbalance 			= sub(s.amountbalance, lastwithdraw);
328 		s.cashbackbalance 			= 0; 
329 		s.lasttime 					= now; 		
330 			
331 		UnlockToken4(ERC, id, s.amountbalance, s.lastwithdraw );		
332     }   
333 	//--o 03
334     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
335         Safe storage s = _safes[id];
336         require(s.tokenAddress == ERC);	
337 
338 		uint256 affiliateandburn 	= div(mul(s.amount, 12), 100) ; 
339 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ;
340 
341 		uint256 firstid = s.id;
342 		
343 			if (cashbackcode[msg.sender] == EthereumNodes && idaddress[msg.sender][0] == firstid ) {
344 			uint256 tokenreceived 	= sub(sub(sub(s.amount, affiliateandburn), maxcashback), newamountbalance) ;	
345 			}else { tokenreceived 	= sub(sub(s.amount, affiliateandburn), newamountbalance) ;}
346 			
347 		s.percentagereceive 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
348 		s.tokenreceive 			= tokenreceived; 	
349 
350 		PayToken(s.user, s.tokenAddress, realAmount);           		
351 		emit onUnlocktoken(msg.sender, s.tokenAddress, s.tokenSymbol, realAmount, now);
352 		
353 		Airdrop(s.user, s.tokenAddress, realAmount, 2);   
354     } 
355 	//--o Pay Token
356     function PayToken(address user, address tokenAddress, uint256 amount) private {
357         
358         ERC20Interface token = ERC20Interface(tokenAddress);        
359         require(token.balanceOf(address(this)) >= amount);
360 		
361 		token.transfer(user, amount);
362 		
363         if (Statistics[user][tokenAddress][6] > 0) {
364 
365 		uint256 burn = Statistics[user][tokenAddress][6];
366         Statistics[user][tokenAddress][6] = 0;
367 		
368 		token.transfer(user, burn); 
369 		Bigdata[user][4]					= add(Bigdata[user][4], burn);
370 	
371 		Bigdata[tokenAddress][19]++;
372 		}
373 		
374 		Bigdata[tokenAddress][3]			= sub(Bigdata[tokenAddress][3], amount); 
375 		Bigdata[tokenAddress][7]			= add(Bigdata[tokenAddress][7], amount);
376 		Statistics[user][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
377 		
378 		Bigdata[tokenAddress][11]++;
379 		
380 	}
381 	
382 //-------o Function 05 - Airdrop
383 
384     function Airdrop(address user, address tokenAddress, uint256 amount, uint256 divfrom) private {
385 		
386 		uint256 divider			= Holdplatform_divider[tokenAddress][divfrom];
387 		
388 		if (Holdplatform_status[tokenAddress] == 1) {
389 			
390 			if (Holdplatform_balance > 0 && divider > 0) {
391 		
392 			uint256 airdrop			= div(amount, divider);
393 		
394 			address airdropaddress	= Holdplatform_address;
395 			ERC20Interface token 	= ERC20Interface(airdropaddress);        
396 			token.transfer(user, airdrop);
397 		
398 			Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
399 			Bigdata[tokenAddress][12]++;
400 		
401 			emit onReceiveAirdrop(user, airdrop, now);
402 			}
403 			
404 		}	
405 	}
406 	
407 //-------o Function 06 - Get How Many Contribute ?
408 
409     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
410         return idaddress[hodler].length;
411     }
412 	
413 //-------o Function 07 - Get How Many Affiliate ?
414 
415     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
416         return afflist[hodler].length;
417     }
418     
419 //-------o Function 08 - Get complete data from each user
420 	function GetSafe(uint256 _id) public view
421         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
422     {
423         Safe storage s = _safes[_id];
424         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
425     }
426 	
427 //-------o Function 09 - Withdraw Affiliate Bonus
428 
429     function WithdrawAffiliate(address user, address tokenAddress) public { 
430 		require(user == msg.sender); 	
431 		require(Statistics[user][tokenAddress][3] > 0 );
432 		
433 		uint256 amount 	= Statistics[msg.sender][tokenAddress][3];
434 
435         ERC20Interface token = ERC20Interface(tokenAddress);        
436         require(token.balanceOf(address(this)) >= amount);
437         token.transfer(user, amount);
438 		
439 		Bigdata[tokenAddress][3] 				= sub(Bigdata[tokenAddress][3], amount); 
440 		Bigdata[tokenAddress][7] 				= add(Bigdata[tokenAddress][7], amount);
441 		Statistics[user][tokenAddress][3] 		= 0;
442 		Statistics[user][tokenAddress][2] 		= add(Statistics[user][tokenAddress][2], amount);
443 
444 		Bigdata[tokenAddress][13]++;		
445 		emit onAffiliateBonus(msg.sender, tokenAddress, ContractSymbol[tokenAddress], amount, now);
446 		
447 		Airdrop(user, tokenAddress, amount, 3); 
448     } 		
449 	
450 	
451 	/*==============================
452     =          RESTRICTED          =
453     ==============================*/  	
454 
455 //-------o 01 Add Contract Address	
456     function AddContractAddress(address tokenAddress, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
457 		require(_PercentPermonth >= 3 && _PercentPermonth <= 12);
458 		require(_maxcontribution >= 10000000000000000000000000);
459 		
460 		Bigdata[tokenAddress][1] 		= _PercentPermonth;	
461 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
462 		Bigdata[tokenAddress][5] 		= _maxcontribution;	
463 		
464 		uint256 _HodlingTime 			= mul(div(72, _PercentPermonth), 30);
465 		uint256 HodlTime 				= _HodlingTime * 1 days;		
466 		Bigdata[tokenAddress][2]		= HodlTime;	
467 		
468 		contractaddress[tokenAddress] 	= true;
469     }
470 	
471 //-------o 02 - Update Token Price (USD)
472 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ETHprice) public restricted  {
473 		
474 		if (Currentprice > 0  ) { Bigdata[tokenAddress][14] = Currentprice; }
475 		if (ETHprice > 0  ) 	{ Bigdata[tokenAddress][17] = ETHprice; }
476 
477     }
478 	
479 //-------o 03 Hold Platform
480     function Holdplatform_Airdrop(address tokenAddress, uint256 HPM_status, uint256 HPM_divider1, uint256 HPM_divider2, uint256 HPM_divider3 ) public restricted {
481 		
482 		Holdplatform_status[tokenAddress] 		= HPM_status;	
483 		Holdplatform_divider[tokenAddress][1]	= HPM_divider1; // Lock Airdrop
484 		Holdplatform_divider[tokenAddress][2]	= HPM_divider2; // Unlock Airdrop
485 		Holdplatform_divider[tokenAddress][3]	= HPM_divider3; // Affiliate Airdrop
486 	
487     }	
488 	//--o Deposit
489 	function Holdplatform_Deposit(uint256 amount) restricted public {
490         
491        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
492         require(token.transferFrom(msg.sender, address(this), amount));
493 		
494 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
495 		Holdplatform_balance 	= newbalance;
496     }
497 	//--o Withdraw
498 	function Holdplatform_Withdraw() restricted public {
499 		ERC20Interface token = ERC20Interface(Holdplatform_address);
500         token.transfer(msg.sender, Holdplatform_balance);
501 		Holdplatform_balance = 0;
502     }
503 	
504 //-------o Only test
505     function updatenowtime(uint256 _nowtime) public restricted {
506 		nowtime 	= _nowtime;	
507     }	
508 	
509 	/*==============================
510     =      SAFE MATH FUNCTIONS     =
511     ==============================*/  	
512 	
513 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
514 		if (a == 0) {
515 			return 0;
516 		}
517 		uint256 c = a * b; 
518 		require(c / a == b);
519 		return c;
520 	}
521 	
522 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
523 		require(b > 0); 
524 		uint256 c = a / b;
525 		return c;
526 	}
527 	
528 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
529 		require(b <= a);
530 		uint256 c = a - b;
531 		return c;
532 	}
533 	
534 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
535 		uint256 c = a + b;
536 		require(c >= a);
537 		return c;
538 	}
539     
540 }
541 
542 
543 	/*==============================
544     =        ERC20 Interface       =
545     ==============================*/ 
546 
547 contract ERC20Interface {
548 
549     uint256 public totalSupply;
550     uint256 public decimals;
551     
552     function symbol() public view returns (string);
553     function balanceOf(address _owner) public view returns (uint256 balance);
554     function transfer(address _to, uint256 _value) public returns (bool success);
555     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
556     function approve(address _spender, uint256 _value) public returns (bool success);
557     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
558 
559     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
560     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
561 }