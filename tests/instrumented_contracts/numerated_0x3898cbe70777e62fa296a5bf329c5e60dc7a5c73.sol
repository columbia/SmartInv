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
21     =          Version 8.9       =
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
49 	event onHOLDdeposit		(address indexed hodler, uint256 amount, uint256 newbalance, uint256 datetime);	
50 	event onHOLDwithdraw	(address indexed hodler, uint256 amount, uint256 newbalance, uint256 datetime);	
51 		
52 	
53 	/*==============================
54     =          VARIABLES           =
55     ==============================*/   
56 
57 	//-------o Affiliate = 12% o-------o Cashback = 16% o-------o Total Receive = 88% o-------o Without Cashback = 72% o-------o	
58 	//-------o Hold 24 Months, Unlock 3% Permonth
59 	
60 	// Struct Database
61 
62     struct Safe {
63         uint256 id;						// [01] -- > Registration Number
64         uint256 amount;					// [02] -- > Total amount of contribution to this transaction
65         uint256 endtime;				// [03] -- > The Expiration Of A Hold Platform Based On Unix Time
66         address user;					// [04] -- > The ETH address that you are using
67         address tokenAddress;			// [05] -- > The Token Contract Address That You Are Using
68 		string  tokenSymbol;			// [06] -- > The Token Symbol That You Are Using
69 		uint256 amountbalance; 			// [07] -- > 88% from Contribution / 72% Without Cashback
70 		uint256 cashbackbalance; 		// [08] -- > 16% from Contribution / 0% Without Cashback
71 		uint256 lasttime; 				// [09] -- > The Last Time You Withdraw Based On Unix Time
72 		uint256 percentage; 			// [10] -- > The percentage of tokens that are unlocked every month ( Default = 3% )
73 		uint256 percentagereceive; 		// [11] -- > The Percentage You Have Received
74 		uint256 tokenreceive; 			// [12] -- > The Number Of Tokens You Have Received
75 		uint256 lastwithdraw; 			// [13] -- > The Last Amount You Withdraw
76 		address referrer; 				// [14] -- > Your ETH referrer address
77 		bool 	cashbackstatus; 		// [15] -- > Cashback Status
78     }
79 	
80 	uint256 private idnumber; 										// [01] -- > ID number ( Start from 500 )				
81 	uint256 public  TotalUser; 										// [02] -- > Total Smart Contract User					
82 	mapping(address => address) 		public cashbackcode; 		// [03] -- > Cashback Code 					
83 	mapping(address => uint256[]) 		public idaddress;			// [04] -- > Search Address by ID			
84 	mapping(address => address[]) 		public afflist;				// [05] -- > Affiliate List by ID					
85 	mapping(address => string) 			public ContractSymbol; 		// [06] -- > Contract Address Symbol				
86 	mapping(uint256 => Safe) 			private _safes; 			// [07] -- > Struct safe database	
87 	mapping(address => bool) 			public contractaddress; 	// [08] -- > Contract Address 		
88 
89 	mapping (address => mapping (uint256 => uint256)) public Bigdata; 
90 	
91 /** Bigdata Mapping : 
92 [1] Percent (Monthly Unlocked tokens)		[7] All Payments 				[13] Total TX Affiliate (Withdraw) 	
93 [2] Holding Time (in seconds) 				[8] Active User 				[14] Current Price (USD)	
94 [3] Token Balance 							[9] Total User 					[15] ATH Price (USD)
95 [4] Min Contribution 						[10] Total TX Hold 				[16] ATL Price (USD)			
96 [5] Max Contribution 						[11] Total TX Unlock 			[17] Current ETH Price (ETH) 		
97 [6] All Contribution 						[12] Total TX Airdrop			[18] Unique Code						
98 **/
99 
100 	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
101 // Statistics = [1] LifetimeContribution [2] LifetimePayments [3] Affiliatevault [4] Affiliateprofit [5] ActiveContribution
102 	
103 // Airdrop - Hold Platform (HOLD)		
104 	address public Holdplatform_address;						// [01]
105 	uint256 public Holdplatform_balance; 						// [02]
106 	mapping(address => uint256) public Holdplatform_status;		// [03]
107 	mapping(address => uint256) public Holdplatform_divider; 	// [04]
108 	
109 	
110 	/*==============================
111     =          CONSTRUCTOR         =
112     ==============================*/  	
113    
114     constructor() public {     	 	
115         idnumber 				= 500;
116 		Holdplatform_address	= 0x23bAdee11Bf49c40669e9b09035f048e9146213e;	//Change before deploy
117     }
118     
119 	
120 	/*==============================
121     =    AVAILABLE FOR EVERYONE    =
122     ==============================*/  
123 
124 //-------o Function 01 - Ethereum Payable
125     function () public payable {  
126 		if (msg.value == 0) {
127 			tothe_moon();
128 		} else { revert(); }
129     }
130     function tothemoon() public payable {  
131 		if (msg.value == 0) {
132 			tothe_moon();
133 		} else { revert(); }
134     }
135 	function tothe_moon() private {  
136 		for(uint256 i = 1; i < idnumber; i++) {            
137 		Safe storage s = _safes[i];
138 			if (s.user == msg.sender) {
139 			Unlocktoken(s.tokenAddress, s.id);
140 			}
141 		}
142     }
143 	
144 //-------o Function 02 - Cashback Code
145 
146     function CashbackCode(address _cashbackcode, uint256 uniquecode) public {		
147 		require(_cashbackcode != msg.sender);			
148 		
149 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 && Bigdata[_cashbackcode][8] == 1 && Bigdata[_cashbackcode][18] != uniquecode ) { 
150 		
151 		cashbackcode[msg.sender] = _cashbackcode; }
152 		
153 		else { cashbackcode[msg.sender] = EthereumNodes; }	
154 
155 		if (Bigdata[msg.sender][18] == 0 ) { 
156 		Bigdata[msg.sender][18]	= uniquecode; }
157 		
158 	emit onCashbackCode(msg.sender, _cashbackcode);		
159     } 
160 	
161 //-------o Function 03 - Contribute 
162 
163 	//--o 01
164     function Holdplatform(address tokenAddress, uint256 amount) public {
165 		require(amount >= 1 );
166 		uint256 holdamount	= add(Statistics[msg.sender][tokenAddress][5], amount);
167 		
168 		require(holdamount <= Bigdata[tokenAddress][5] );
169 		
170 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 ) { 
171 			cashbackcode[msg.sender] 	= EthereumNodes;
172 			Bigdata[msg.sender][18]		= 123456;	
173 		} 
174 		
175 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
176 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
177         require(token.transferFrom(msg.sender, address(this), amount));	
178 		
179 		HodlTokens2(tokenAddress, amount);
180 		Airdrop(tokenAddress, amount, 1); 
181 		}							
182 	}
183 	
184 	//--o 02	
185     function HodlTokens2(address ERC, uint256 amount) public {
186 		
187 		address ref						= cashbackcode[msg.sender];
188 		address ref2					= EthereumNodes;
189 		uint256 ReferrerContribution 	= Statistics[ref][ERC][5];	
190 		uint256 ReferralContribution 	= Statistics[msg.sender][ERC][5];
191 		uint256 MyContribution 			= add(ReferralContribution, amount); 
192 		
193 	  	if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) { 
194 			uint256 nodecomission 		= div(mul(amount, 28), 100);
195 			Statistics[ref][ERC][3] 	= add(Statistics[ref][ERC][3], nodecomission ); 
196 			Statistics[ref][ERC][4] 	= add(Statistics[ref][ERC][4], nodecomission );		
197 			
198 		} else { 
199 		
200 // Very complicated code, need to be checked carefully!		
201 
202 			uint256 affcomission 	= div(mul(amount, 12), 100); 
203 			
204 			if (ReferrerContribution >= MyContribution) { //--o  if referrer contribution >= My contribution
205 
206 				Statistics[ref][ERC][3] 		= add(Statistics[ref][ERC][3], affcomission); 
207 				Statistics[ref][ERC][4] 		= add(Statistics[ref][ERC][4], affcomission); 
208 
209 			} else {
210 					if (ReferrerContribution > ReferralContribution  ) { 	
211 						if (amount <= add(ReferrerContribution,ReferralContribution)  ) { 
212 						
213 						uint256 AAA				= sub(ReferrerContribution, ReferralContribution );
214 						uint256 affcomission2	= div(mul(AAA, 12), 100); 
215 						uint256 affcomission3	= sub(affcomission, affcomission2);		
216 						} else {	
217 						uint256 BBB				= sub(sub(amount, ReferrerContribution), ReferralContribution);
218 						affcomission3			= div(mul(BBB, 12), 100); 
219 						affcomission2			= sub(affcomission, affcomission3); } 
220 						
221 					} else { affcomission2	= 0; 	affcomission3	= affcomission; } 
222 // end //					
223 				Statistics[ref][ERC][3] 		= add(Statistics[ref][ERC][3], affcomission2); 
224 				Statistics[ref][ERC][4] 		= add(Statistics[ref][ERC][4], affcomission2); 	
225 	
226 				Statistics[ref2][ERC][3] 		= add(Statistics[ref2][ERC][3], affcomission3); 
227 				Statistics[ref2][ERC][4] 		= add(Statistics[ref2][ERC][4], affcomission3);	
228 			}	
229 		}
230 
231 		HodlTokens3(ERC, amount, ref); 	
232 	}
233 	//--o 04	
234     function HodlTokens3(address ERC, uint256 amount, address ref) public {
235 	    
236 		uint256 AvailableBalances 		= div(mul(amount, 72), 100);
237 		
238 		if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) 
239 		{ uint256	AvailableCashback = 0; } else { AvailableCashback = div(mul(amount, 16), 100);}
240 		
241 	    ERC20Interface token 	= ERC20Interface(ERC); 	
242 		uint256 TokenPercent 	= Bigdata[ERC][1];	
243 		uint256 TokenHodlTime 	= Bigdata[ERC][2];	
244 		uint256 HodlTime		= add(now, TokenHodlTime);
245 		
246 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
247 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
248 		
249 		_safes[idnumber] = Safe(idnumber, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
250 				
251 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
252 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
253 		Bigdata[ERC][6] 						= add(Bigdata[ERC][6], AM);   	
254         Bigdata[ERC][3]							= add(Bigdata[ERC][3], AM);  
255 
256 		if(Bigdata[msg.sender][8] == 1 ) {
257         idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][10]++;  }		
258 		else { 
259 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][9]++; Bigdata[ERC][10]++; TotalUser++;   }
260 		
261 		Bigdata[msg.sender][8] 					= 1;  	
262 		
263         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);	
264 		
265 			
266 	}
267 
268 //-------o Function 05 - Claim Token That Has Been Unlocked
269     function Unlocktoken(address tokenAddress, uint256 id) public {
270         require(tokenAddress != 0x0);
271         require(id != 0);        
272         
273         Safe storage s = _safes[id];
274         require(s.user == msg.sender);  
275 		require(s.tokenAddress == tokenAddress);
276 		
277 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
278     }
279     //--o 01
280     function UnlockToken2(address ERC, uint256 id) private {
281         Safe storage s = _safes[id];      
282         require(s.id != 0);
283         require(s.tokenAddress == ERC);
284 
285         uint256 eventAmount				= s.amountbalance;
286         address eventTokenAddress 		= s.tokenAddress;
287         string memory eventTokenSymbol 	= s.tokenSymbol;		
288 		     
289         if(s.endtime < now){ //--o  Hold Complete
290         
291 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
292 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
293 		s.lastwithdraw 							= amounttransfer;   s.amountbalance = 0;   s.lasttime = now;  		
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
304 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
305 		
306         } else { UnlockToken3(ERC, s.id); }
307         
308     }   
309 	//--o 02
310 	function UnlockToken3(address ERC, uint256 id) private {		
311 		Safe storage s = _safes[id];
312         
313         require(s.id != 0);
314         require(s.tokenAddress == ERC);		
315 			
316 		uint256 timeframe  			= sub(now, s.lasttime);			                            
317 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
318 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
319 		                         
320 		uint256 MaxWithdraw 		= div(s.amount, 10);
321 			
322 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
323 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
324 			
325 		//--o Maximum withdraw = User Amount Balance   
326 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
327 			
328 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
329 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount1);
330 		s.cashbackbalance 			= 0; 
331 		s.amountbalance 			= newamountbalance;
332 		s.lastwithdraw 				= realAmount; 
333 		s.lasttime 					= now; 		
334 			
335 		UnlockToken4(ERC, id, newamountbalance, realAmount);		
336     }   
337 	//--o 03
338     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
339         Safe storage s = _safes[id];
340         
341         require(s.id != 0);
342         require(s.tokenAddress == ERC);
343 
344         uint256 eventAmount				= realAmount;
345         address eventTokenAddress 		= s.tokenAddress;
346         string memory eventTokenSymbol 	= s.tokenSymbol;		
347 
348 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
349 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ;
350 
351 		uint256 sid = s.id;
352 		
353 			if (cashbackcode[msg.sender] == EthereumNodes && idaddress[msg.sender][0] == sid ) {
354 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
355 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
356 			
357 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
358 		
359 		s.tokenreceive 					= tokenreceived; 
360 		s.percentagereceive 			= percentagereceived; 		
361 
362 		PayToken(s.user, s.tokenAddress, realAmount);           		
363 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
364 		
365 		Airdrop(s.tokenAddress, realAmount, 4);   
366     } 
367 	//--o Pay Token
368     function PayToken(address user, address tokenAddress, uint256 amount) private {
369         
370         ERC20Interface token = ERC20Interface(tokenAddress);        
371         require(token.balanceOf(address(this)) >= amount);
372         token.transfer(user, amount);
373 		
374 		Bigdata[tokenAddress][3]					= sub(Bigdata[tokenAddress][3], amount); 
375 		Bigdata[tokenAddress][7]					= add(Bigdata[tokenAddress][7], amount);
376 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
377 		
378 		Bigdata[tokenAddress][11]++;
379 	}
380 	
381 //-------o Function 05 - Airdrop
382 
383     function Airdrop(address tokenAddress, uint256 amount, uint256 extradivider) private {
384 		
385 		if (Holdplatform_status[tokenAddress] == 1) {
386 		require(Holdplatform_balance > 0 );
387 		
388 		uint256 divider 		= Holdplatform_divider[tokenAddress];
389 		uint256 airdrop			= div(div(amount, divider), extradivider);
390 		
391 		address airdropaddress	= Holdplatform_address;
392 		ERC20Interface token 	= ERC20Interface(airdropaddress);        
393         token.transfer(msg.sender, airdrop);
394 		
395 		Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
396 		Bigdata[tokenAddress][12]++;
397 		
398 		emit onReceiveAirdrop(msg.sender, airdrop, now);
399 		}	
400 	}
401 	
402 //-------o Function 06 - Get How Many Contribute ?
403 
404     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
405         return idaddress[hodler].length;
406     }
407 	
408 //-------o Function 07 - Get How Many Affiliate ?
409 
410     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
411         return afflist[hodler].length;
412     }
413     
414 //-------o Function 08 - Get complete data from each user
415 	function GetSafe(uint256 _id) public view
416         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
417     {
418         Safe storage s = _safes[_id];
419         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
420     }
421 	
422 //-------o Function 09 - Withdraw Affiliate Bonus
423 
424     function WithdrawAffiliate(address user, address tokenAddress) public {  
425 		require(tokenAddress != 0x0);		
426 		require(Statistics[user][tokenAddress][3] > 0 );
427 		
428 		uint256 amount = Statistics[msg.sender][tokenAddress][3];
429 		Statistics[msg.sender][tokenAddress][3] = 0;
430 		
431 		Bigdata[tokenAddress][3] 		= sub(Bigdata[tokenAddress][3], amount); 
432 		Bigdata[tokenAddress][7] 		= add(Bigdata[tokenAddress][7], amount);
433 		
434 		uint256 eventAmount				= amount;
435         address eventTokenAddress 		= tokenAddress;
436         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
437         
438         ERC20Interface token = ERC20Interface(tokenAddress);        
439         require(token.balanceOf(address(this)) >= amount);
440         token.transfer(user, amount);
441 		
442 		Statistics[user][tokenAddress][2] 	= add(Statistics[user][tokenAddress][2], amount);
443 
444 		Bigdata[tokenAddress][13]++;		
445 		
446 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
447 		
448 		Airdrop(tokenAddress, amount, 4); 
449     } 		
450 	
451 	
452 	/*==============================
453     =          RESTRICTED          =
454     ==============================*/  	
455 
456 //-------o 01 Add Contract Address	
457     function AddContractAddress(address tokenAddress, uint256 CurrentUSDprice, uint256 CurrentETHprice, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
458 		uint256 newSpeed	= _PercentPermonth;
459 		require(newSpeed >= 3 && newSpeed <= 12);
460 		
461 		Bigdata[tokenAddress][1] 		= newSpeed;	
462 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
463 		Bigdata[tokenAddress][5] 		= _maxcontribution;	
464 		
465 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
466 		uint256 HodlTime 				= _HodlingTime * 1 days;		
467 		Bigdata[tokenAddress][2]		= HodlTime;	
468 		
469 		Bigdata[tokenAddress][14]		= CurrentUSDprice;
470 		Bigdata[tokenAddress][17]		= CurrentETHprice;
471 		contractaddress[tokenAddress] 	= true;
472     }
473 	
474 //-------o 02 - Update Token Price (USD)
475 	
476 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice, uint256 ETHprice) public restricted  {
477 		
478 		if (Currentprice > 0  ) { Bigdata[tokenAddress][14] = Currentprice; }
479 		if (ATHprice > 0  ) 	{ Bigdata[tokenAddress][15] = ATHprice; }
480 		if (ATLprice > 0  ) 	{ Bigdata[tokenAddress][16] = ATLprice; }
481 		if (ETHprice > 0  ) 	{ Bigdata[tokenAddress][17] = ETHprice; }
482 
483     }
484 	
485 //-------o 03 Hold Platform
486     function Holdplatform_Airdrop(address tokenAddress, uint256 HPM_status, uint256 HPM_divider) public restricted {
487 		require(HPM_status == 0 || HPM_status == 1 );
488 		
489 		Holdplatform_status[tokenAddress] 	= HPM_status;	
490 		Holdplatform_divider[tokenAddress] 	= HPM_divider;	// Airdrop = 100% : Divider
491 	
492     }	
493 	//--o Deposit
494 	function Holdplatform_Deposit(uint256 amount) restricted public {
495 		require(amount > 0 );
496         
497        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
498         require(token.transferFrom(msg.sender, address(this), amount));
499 		
500 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
501 		Holdplatform_balance 	= newbalance;
502 		
503 		emit onHOLDdeposit(msg.sender, amount, newbalance, now);
504     }
505 	//--o Withdraw
506 	function Holdplatform_Withdraw(uint256 amount) restricted public {
507         require(Holdplatform_balance > 0 && amount <= Holdplatform_balance);
508         
509 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
510 		Holdplatform_balance 	= newbalance;
511         
512         ERC20Interface token = ERC20Interface(Holdplatform_address);
513         
514         require(token.balanceOf(address(this)) >= amount);
515         token.transfer(msg.sender, amount);
516 		
517 		emit onHOLDwithdraw(msg.sender, amount, newbalance, now);
518     }
519 	
520 //-------o 04 - Return All Tokens To Their Respective Addresses    
521     function ReturnAllTokens() restricted public
522     {
523 
524         for(uint256 i = 1; i < idnumber; i++) {            
525             Safe storage s = _safes[i];
526             if (s.id != 0) {
527 				
528 				if(s.amountbalance > 0) {
529 					uint256 amount = add(s.amountbalance, s.cashbackbalance);
530 					PayToken(s.user, s.tokenAddress, amount);
531 					s.amountbalance							= 0;
532 					s.cashbackbalance						= 0;
533 					Statistics[s.user][s.tokenAddress][5]	= 0;
534 				}
535             }
536         }
537     }   
538 	
539 	
540 	/*==============================
541     =      SAFE MATH FUNCTIONS     =
542     ==============================*/  	
543 	
544 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
545 		if (a == 0) {
546 			return 0;
547 		}
548 		uint256 c = a * b; 
549 		require(c / a == b);
550 		return c;
551 	}
552 	
553 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
554 		require(b > 0); 
555 		uint256 c = a / b;
556 		return c;
557 	}
558 	
559 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
560 		require(b <= a);
561 		uint256 c = a - b;
562 		return c;
563 	}
564 	
565 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
566 		uint256 c = a + b;
567 		require(c >= a);
568 		return c;
569 	}
570     
571 }
572 
573 
574 	/*==============================
575     =        ERC20 Interface       =
576     ==============================*/ 
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
590     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
591     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
592 }