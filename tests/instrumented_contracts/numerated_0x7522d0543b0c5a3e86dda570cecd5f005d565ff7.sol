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
21     =          Version 9.3       =
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
55 	//-------o Affiliate = 12% o-------o Cashback = 16% o-------o Total Receive = 88% o-------o Without Cashback = 72% o-------o	
56 	//-------o Hold 24 Months, Unlock 3% Permonth
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
94 [1] Percent (Monthly Unlocked tokens)		[7] All Payments 				[13] Total TX Affiliate (Withdraw) 	
95 [2] Holding Time (in seconds) 				[8] Active User 				[14] Current Price (USD)	
96 [3] Token Balance 							[9] Total User 					[15] ATH Price (USD)
97 [4] Min Contribution 						[10] Total TX Hold 				[16] ATL Price (USD)			
98 [5] Max Contribution 						[11] Total TX Unlock 			[17] Current ETH Price (ETH) 		
99 [6] All Contribution 						[12] Total TX Airdrop			[18] Date Register				
100 **/
101 
102 	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
103 // Statistics = [1] LifetimeContribution [2] LifetimePayments [3] Affiliatevault [4] Affiliateprofit [5] ActiveContribution
104 	
105 // Airdrop - Hold Platform (HOLD)		
106 	address public Holdplatform_address;											// [01]
107 	uint256 public Holdplatform_balance; 											// [02]
108 	mapping(address => uint256) public Holdplatform_status;							// [03]
109 	mapping(address => mapping (uint256 => uint256)) public Holdplatform_divider; 
110 // Holdplatform_divider = [1] Lock Airdrop	[2] Unlock Airdrop	[3] Affiliate Airdrop
111 	
112 	
113 	/*==============================
114     =          CONSTRUCTOR         =
115     ==============================*/  	
116    
117     constructor() public {     	 	
118         idnumber 				= 500;
119 		Holdplatform_address	= 0x23bAdee11Bf49c40669e9b09035f048e9146213e;	//Change before deploy
120     }
121     
122 	
123 	/*==============================
124     =    AVAILABLE FOR EVERYONE    =
125     ==============================*/  
126 
127 //-------o Function 01 - Ethereum Payable
128     function () public payable {  
129 		if (msg.value == 0) {
130 			tothe_moon();
131 		} else { revert(); }
132     }
133     function tothemoon() public payable {  
134 		if (msg.value == 0) {
135 			tothe_moon();
136 		} else { revert(); }
137     }
138 	function tothe_moon() private {  
139 		for(uint256 i = 1; i < idnumber; i++) {            
140 		Safe storage s = _safes[i];
141 		
142 			// Send all unlocked tokens
143 			if (s.user == msg.sender) {
144 			Unlocktoken(s.tokenAddress, s.id);
145 			
146 				// Send all affiliate bonus
147 				if (Statistics[s.user][s.tokenAddress][3] > 0) {
148 				WithdrawAffiliate(s.user, s.tokenAddress);
149 				}
150 			}
151 		}
152     }
153 	
154 //-------o Function 02 - Cashback Code
155 
156     function CashbackCode(address _cashbackcode) public {		
157 		require(_cashbackcode != msg.sender);			
158 		
159 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 && Bigdata[_cashbackcode][8] == 1) { 
160 		cashbackcode[msg.sender] = _cashbackcode; }
161 		else { cashbackcode[msg.sender] = EthereumNodes; }		
162 		
163 	emit onCashbackCode(msg.sender, _cashbackcode);		
164     } 
165 	
166 //-------o Function 03 - Contribute 
167 
168 	//--o 01
169     function Holdplatform(address tokenAddress, uint256 amount) public {
170 		require(amount >= 1 );
171 		uint256 holdamount	= add(Statistics[msg.sender][tokenAddress][5], amount);
172 		
173 		require(holdamount <= Bigdata[tokenAddress][5] );
174 		
175 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 ) { 
176 			cashbackcode[msg.sender] 	= EthereumNodes;
177 		} 
178 		
179 		if (Bigdata[msg.sender][18] == 0) { 
180 			Bigdata[msg.sender][18] = now;
181 		} 
182 		
183 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
184 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
185         require(token.transferFrom(msg.sender, address(this), amount));	
186 		
187 		HodlTokens2(tokenAddress, amount);
188 		Airdrop(tokenAddress, amount, 1);
189 		}							
190 	}
191 	
192 	//--o 02	
193     function HodlTokens2(address ERC, uint256 amount) private {
194 		
195 		address ref						= cashbackcode[msg.sender];
196 		address ref2					= EthereumNodes;
197 		uint256 ReferrerContribution 	= Statistics[ref][ERC][5];	
198 		uint256 ReferralContribution 	= Statistics[msg.sender][ERC][5];
199 		uint256 MyContribution 			= add(ReferralContribution, amount); 
200 		
201 	  	if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) { 
202 			uint256 nodecomission 		= div(mul(amount, 28), 100);
203 			Statistics[ref][ERC][3] 	= add(Statistics[ref][ERC][3], nodecomission ); 
204 			Statistics[ref][ERC][4] 	= add(Statistics[ref][ERC][4], nodecomission );		
205 			
206 		} else { 
207 		
208 // Very complicated code, need to be checked carefully!		
209 
210 			uint256 affcomission 	= div(mul(amount, 12), 100); 
211 			
212 			if (ReferrerContribution >= MyContribution) { //--o  if referrer contribution >= My contribution
213 
214 				Statistics[ref][ERC][3] 		= add(Statistics[ref][ERC][3], affcomission); 
215 				Statistics[ref][ERC][4] 		= add(Statistics[ref][ERC][4], affcomission); 
216 
217 			} else {
218 					if (ReferrerContribution > ReferralContribution  ) { 	
219 						if (amount <= add(ReferrerContribution,ReferralContribution)  ) { 
220 						
221 						uint256 AAA				= sub(ReferrerContribution, ReferralContribution );
222 						uint256 affcomission2	= div(mul(AAA, 12), 100); 
223 						uint256 affcomission3	= sub(affcomission, affcomission2);		
224 						} else {	
225 						uint256 BBB				= sub(sub(amount, ReferrerContribution), ReferralContribution);
226 						affcomission3			= div(mul(BBB, 12), 100); 
227 						affcomission2			= sub(affcomission, affcomission3); } 
228 						
229 					} else { affcomission2	= 0; 	affcomission3	= affcomission; } 
230 // end //					
231 				Statistics[ref][ERC][3] 		= add(Statistics[ref][ERC][3], affcomission2); 
232 				Statistics[ref][ERC][4] 		= add(Statistics[ref][ERC][4], affcomission2); 	
233 	
234 				Statistics[ref2][ERC][3] 		= add(Statistics[ref2][ERC][3], affcomission3); 
235 				Statistics[ref2][ERC][4] 		= add(Statistics[ref2][ERC][4], affcomission3);	
236 			}	
237 		}
238 
239 		HodlTokens3(ERC, amount, ref); 	
240 	}
241 	//--o 04	
242     function HodlTokens3(address ERC, uint256 amount, address ref) private {
243 	    
244 		uint256 AvailableBalances 		= div(mul(amount, 72), 100);
245 		
246 		if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) 
247 		{ uint256	AvailableCashback = 0; } else { AvailableCashback = div(mul(amount, 16), 100);}
248 		
249 	    ERC20Interface token 	= ERC20Interface(ERC); 	
250 		uint256 TokenPercent 	= Bigdata[ERC][1];	
251 		uint256 TokenHodlTime 	= Bigdata[ERC][2];	
252 		uint256 HodlTime		= add(now, TokenHodlTime);
253 		
254 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
255 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
256 		
257 		_safes[idnumber] = Safe(idnumber, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
258 				
259 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
260 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
261 		Bigdata[ERC][6] 						= add(Bigdata[ERC][6], AM);   	
262         Bigdata[ERC][3]							= add(Bigdata[ERC][3], AM);  
263 
264 		if(Bigdata[msg.sender][8] == 1 ) {
265         idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][10]++;  }		
266 		else { 
267 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][9]++; Bigdata[ERC][10]++; TotalUser++;   }
268 		
269 		Bigdata[msg.sender][8] 					= 1;  	
270 		
271         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);	
272 		
273 			
274 	}
275 
276 //-------o Function 05 - Claim Token That Has Been Unlocked
277     function Unlocktoken(address tokenAddress, uint256 id) public {
278         require(tokenAddress != 0x0);
279         require(id != 0);        
280         
281         Safe storage s = _safes[id];
282         require(s.user == msg.sender);  
283 		require(s.tokenAddress == tokenAddress);
284 		
285 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
286     }
287     //--o 01
288     function UnlockToken2(address ERC, uint256 id) private {
289         Safe storage s = _safes[id];      
290         require(s.id != 0);
291         require(s.tokenAddress == ERC);
292 
293         uint256 eventAmount				= s.amountbalance;
294         address eventTokenAddress 		= s.tokenAddress;
295         string memory eventTokenSymbol 	= s.tokenSymbol;		
296 		     
297         if(s.endtime < nowtime){ //--o  Hold Complete , Now time delete before deploy
298         
299 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
300 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
301 		s.lastwithdraw 							= amounttransfer;   s.amountbalance = 0;   s.lasttime = now;  		
302 		PayToken(s.user, s.tokenAddress, amounttransfer); 
303 		
304 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
305             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
306             }
307 			else {
308 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
309 			}
310 			
311 		s.cashbackbalance = 0;	
312 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
313 		
314         } else { UnlockToken3(ERC, s.id); }
315         
316     }   
317 	//--o 02
318 	function UnlockToken3(address ERC, uint256 id) private {		
319 		Safe storage s = _safes[id];
320         
321         require(s.id != 0);
322         require(s.tokenAddress == ERC);		
323 			
324 		uint256 timeframe  			= sub(now, s.lasttime);			                            
325 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
326 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
327 		                         
328 		uint256 MaxWithdraw 		= div(s.amount, 10);
329 			
330 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
331 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
332 			
333 		//--o Maximum withdraw = User Amount Balance   
334 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
335 			
336 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
337 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount1);
338 		s.cashbackbalance 			= 0; 
339 		s.amountbalance 			= newamountbalance;
340 		s.lastwithdraw 				= realAmount; 
341 		s.lasttime 					= now; 		
342 			
343 		UnlockToken4(ERC, id, newamountbalance, realAmount);		
344     }   
345 	//--o 03
346     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
347         Safe storage s = _safes[id];
348         
349         require(s.id != 0);
350         require(s.tokenAddress == ERC);
351 
352         uint256 eventAmount				= realAmount;
353         address eventTokenAddress 		= s.tokenAddress;
354         string memory eventTokenSymbol 	= s.tokenSymbol;		
355 
356 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
357 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ;
358 
359 		uint256 sid = s.id;
360 		
361 			if (cashbackcode[msg.sender] == EthereumNodes && idaddress[msg.sender][0] == sid ) {
362 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
363 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
364 			
365 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
366 		
367 		s.tokenreceive 					= tokenreceived; 
368 		s.percentagereceive 			= percentagereceived; 		
369 
370 		PayToken(s.user, s.tokenAddress, realAmount);           		
371 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
372 		
373 		Airdrop(s.tokenAddress, realAmount, 2);   
374     } 
375 	//--o Pay Token
376     function PayToken(address user, address tokenAddress, uint256 amount) private {
377         
378         ERC20Interface token = ERC20Interface(tokenAddress);        
379         require(token.balanceOf(address(this)) >= amount);
380 		
381         uint256 Burnamount		= div(amount, 100);
382 		uint256 Transferamount	= div(mul(amount, 99), 100);
383 		
384 		token.transfer(user, Transferamount);
385 		
386         if (Burnstatus == 0) {
387 		token.transfer(user, Burnamount);
388 		
389 		} else {
390 		token.transfer(0x000000000000000000000000000000000000dEaD, Burnamount); }
391 		
392 		Bigdata[tokenAddress][3]					= sub(Bigdata[tokenAddress][3], amount); 
393 		Bigdata[tokenAddress][7]					= add(Bigdata[tokenAddress][7], amount);
394 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
395 		
396 		Bigdata[tokenAddress][11]++;
397 	}
398 	
399 //-------o Function 05 - Airdrop
400 
401     function Airdrop(address tokenAddress, uint256 amount, uint256 divfrom) private {
402 		
403 		uint256 divider			= Holdplatform_divider[tokenAddress][divfrom];
404 		
405 		if (Holdplatform_status[tokenAddress] == 1) {
406 			
407 			if (Holdplatform_balance > 0 && divider > 0) {
408 		
409 			uint256 airdrop			= div(amount, divider);
410 		
411 			address airdropaddress	= Holdplatform_address;
412 			ERC20Interface token 	= ERC20Interface(airdropaddress);        
413 			token.transfer(msg.sender, airdrop);
414 		
415 			Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
416 			Bigdata[tokenAddress][12]++;
417 		
418 			emit onReceiveAirdrop(msg.sender, airdrop, now);
419 			}
420 			
421 		}	
422 	}
423 	
424 //-------o Function 06 - Get How Many Contribute ?
425 
426     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
427         return idaddress[hodler].length;
428     }
429 	
430 //-------o Function 07 - Get How Many Affiliate ?
431 
432     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
433         return afflist[hodler].length;
434     }
435     
436 //-------o Function 08 - Get complete data from each user
437 	function GetSafe(uint256 _id) public view
438         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
439     {
440         Safe storage s = _safes[_id];
441         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
442     }
443 	
444 //-------o Function 09 - Withdraw Affiliate Bonus
445 
446     function WithdrawAffiliate(address user, address tokenAddress) public { 
447 		require(user == msg.sender); 	
448 		require(Statistics[user][tokenAddress][3] > 0 );
449 		
450 		uint256 amount = Statistics[msg.sender][tokenAddress][3];
451 		Statistics[msg.sender][tokenAddress][3] = 0;
452 		
453 		Bigdata[tokenAddress][3] 		= sub(Bigdata[tokenAddress][3], amount); 
454 		Bigdata[tokenAddress][7] 		= add(Bigdata[tokenAddress][7], amount);
455 		
456 		uint256 eventAmount				= amount;
457         address eventTokenAddress 		= tokenAddress;
458         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
459         
460         ERC20Interface token = ERC20Interface(tokenAddress);        
461         require(token.balanceOf(address(this)) >= amount);
462         token.transfer(user, amount);
463 		
464 		Statistics[user][tokenAddress][2] 	= add(Statistics[user][tokenAddress][2], amount);
465 
466 		Bigdata[tokenAddress][13]++;		
467 		
468 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
469 		
470 		Airdrop(tokenAddress, amount, 3); 
471     } 		
472 	
473 	
474 	/*==============================
475     =          RESTRICTED          =
476     ==============================*/  	
477 
478 //-------o 01 Add Contract Address	
479     function AddContractAddress(address tokenAddress, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth, uint256 Burn_status) public restricted {
480 		uint256 newSpeed	= _PercentPermonth;
481 		require(newSpeed >= 3 && newSpeed <= 12);
482 		
483 		require(_maxcontribution >= 10000000000000000000000000);
484 		
485 		Burnstatus 						= Burn_status;	
486 		Bigdata[tokenAddress][1] 		= newSpeed;	
487 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
488 		Bigdata[tokenAddress][5] 		= _maxcontribution;	
489 		
490 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
491 		uint256 HodlTime 				= _HodlingTime * 1 days;		
492 		Bigdata[tokenAddress][2]		= HodlTime;	
493 		
494 		contractaddress[tokenAddress] 	= true;
495     }
496 	
497 //-------o 02 - Update Token Price (USD)
498 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice, uint256 ETHprice) public restricted  {
499 		
500 		if (Currentprice > 0  ) { Bigdata[tokenAddress][14] = Currentprice; }
501 		if (ATHprice > 0  ) 	{ Bigdata[tokenAddress][15] = ATHprice; }
502 		if (ATLprice > 0  ) 	{ Bigdata[tokenAddress][16] = ATLprice; }
503 		if (ETHprice > 0  ) 	{ Bigdata[tokenAddress][17] = ETHprice; }
504 
505     }
506 	
507 //-------o 03 Hold Platform
508     function Holdplatform_Airdrop(address tokenAddress, uint256 HPM_status, uint256 HPM_divider1, uint256 HPM_divider2, uint256 HPM_divider3 ) public restricted {
509 		
510 		Holdplatform_status[tokenAddress] 		= HPM_status;	
511 		Holdplatform_divider[tokenAddress][1]	= HPM_divider1; // Lock Airdrop
512 		Holdplatform_divider[tokenAddress][2]	= HPM_divider2; // Unlock Airdrop
513 		Holdplatform_divider[tokenAddress][3]	= HPM_divider3; // Affiliate Airdrop
514 	
515     }	
516 	//--o Deposit
517 	function Holdplatform_Deposit(uint256 amount) restricted public {
518 		require(amount > 0 );
519         
520        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
521         require(token.transferFrom(msg.sender, address(this), amount));
522 		
523 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
524 		Holdplatform_balance 	= newbalance;
525     }
526 	//--o Withdraw
527 	function Holdplatform_Withdraw(uint256 amount) restricted public {
528         require(Holdplatform_balance > 0 && amount <= Holdplatform_balance);
529         
530 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
531 		Holdplatform_balance 	= newbalance;
532         
533         ERC20Interface token = ERC20Interface(Holdplatform_address);
534         
535         require(token.balanceOf(address(this)) >= amount);
536         token.transfer(msg.sender, amount);
537     }
538 	
539 //-------o Only test
540     function updatenowtime(uint256 _nowtime) public restricted {
541 		nowtime 	= _nowtime;	
542     }	
543 	
544 	/*==============================
545     =      SAFE MATH FUNCTIONS     =
546     ==============================*/  	
547 	
548 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
549 		if (a == 0) {
550 			return 0;
551 		}
552 		uint256 c = a * b; 
553 		require(c / a == b);
554 		return c;
555 	}
556 	
557 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
558 		require(b > 0); 
559 		uint256 c = a / b;
560 		return c;
561 	}
562 	
563 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
564 		require(b <= a);
565 		uint256 c = a - b;
566 		return c;
567 	}
568 	
569 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
570 		uint256 c = a + b;
571 		require(c >= a);
572 		return c;
573 	}
574     
575 }
576 
577 
578 	/*==============================
579     =        ERC20 Interface       =
580     ==============================*/ 
581 
582 contract ERC20Interface {
583 
584     uint256 public totalSupply;
585     uint256 public decimals;
586     
587     function symbol() public view returns (string);
588     function balanceOf(address _owner) public view returns (uint256 balance);
589     function transfer(address _to, uint256 _value) public returns (bool success);
590     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
591     function approve(address _spender, uint256 _value) public returns (bool success);
592     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
593 
594     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
595     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
596 }