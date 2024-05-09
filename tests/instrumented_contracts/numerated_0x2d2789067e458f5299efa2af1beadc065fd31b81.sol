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
21     =          Version 9.2       =
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
146 
147 			}
148 		}
149     }
150 	
151 //-------o Function 02 - Cashback Code
152 
153     function CashbackCode(address _cashbackcode) public {		
154 		require(_cashbackcode != msg.sender);			
155 		
156 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 && Bigdata[_cashbackcode][8] == 1) { 
157 		cashbackcode[msg.sender] = _cashbackcode; }
158 		else { cashbackcode[msg.sender] = EthereumNodes; }		
159 		
160 	emit onCashbackCode(msg.sender, _cashbackcode);		
161     } 
162 	
163 //-------o Function 03 - Contribute 
164 
165 	//--o 01
166     function Holdplatform(address tokenAddress, uint256 amount) public {
167 		require(amount >= 1 );
168 		uint256 holdamount	= add(Statistics[msg.sender][tokenAddress][5], amount);
169 		
170 		require(holdamount <= Bigdata[tokenAddress][5] );
171 		
172 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 ) { 
173 			cashbackcode[msg.sender] 	= EthereumNodes;
174 		} 
175 		
176 		if (Bigdata[msg.sender][18] == 0) { 
177 			Bigdata[msg.sender][18] = now;
178 		} 
179 		
180 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
181 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
182         require(token.transferFrom(msg.sender, address(this), amount));	
183 		
184 		HodlTokens2(tokenAddress, amount);
185 		Airdrop(tokenAddress, amount, 1);
186 		}							
187 	}
188 	
189 	//--o 02	
190     function HodlTokens2(address ERC, uint256 amount) private {
191 		
192 		address ref						= cashbackcode[msg.sender];
193 		address ref2					= EthereumNodes;
194 		uint256 ReferrerContribution 	= Statistics[ref][ERC][5];	
195 		uint256 ReferralContribution 	= Statistics[msg.sender][ERC][5];
196 		uint256 MyContribution 			= add(ReferralContribution, amount); 
197 		
198 	  	if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) { 
199 			uint256 nodecomission 		= div(mul(amount, 28), 100);
200 			Statistics[ref][ERC][3] 	= add(Statistics[ref][ERC][3], nodecomission ); 
201 			Statistics[ref][ERC][4] 	= add(Statistics[ref][ERC][4], nodecomission );		
202 			
203 		} else { 
204 		
205 // Very complicated code, need to be checked carefully!		
206 
207 			uint256 affcomission 	= div(mul(amount, 12), 100); 
208 			
209 			if (ReferrerContribution >= MyContribution) { //--o  if referrer contribution >= My contribution
210 
211 				Statistics[ref][ERC][3] 		= add(Statistics[ref][ERC][3], affcomission); 
212 				Statistics[ref][ERC][4] 		= add(Statistics[ref][ERC][4], affcomission); 
213 
214 			} else {
215 					if (ReferrerContribution > ReferralContribution  ) { 	
216 						if (amount <= add(ReferrerContribution,ReferralContribution)  ) { 
217 						
218 						uint256 AAA				= sub(ReferrerContribution, ReferralContribution );
219 						uint256 affcomission2	= div(mul(AAA, 12), 100); 
220 						uint256 affcomission3	= sub(affcomission, affcomission2);		
221 						} else {	
222 						uint256 BBB				= sub(sub(amount, ReferrerContribution), ReferralContribution);
223 						affcomission3			= div(mul(BBB, 12), 100); 
224 						affcomission2			= sub(affcomission, affcomission3); } 
225 						
226 					} else { affcomission2	= 0; 	affcomission3	= affcomission; } 
227 // end //					
228 				Statistics[ref][ERC][3] 		= add(Statistics[ref][ERC][3], affcomission2); 
229 				Statistics[ref][ERC][4] 		= add(Statistics[ref][ERC][4], affcomission2); 	
230 	
231 				Statistics[ref2][ERC][3] 		= add(Statistics[ref2][ERC][3], affcomission3); 
232 				Statistics[ref2][ERC][4] 		= add(Statistics[ref2][ERC][4], affcomission3);	
233 			}	
234 		}
235 
236 		HodlTokens3(ERC, amount, ref); 	
237 	}
238 	//--o 04	
239     function HodlTokens3(address ERC, uint256 amount, address ref) private {
240 	    
241 		uint256 AvailableBalances 		= div(mul(amount, 72), 100);
242 		
243 		if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) 
244 		{ uint256	AvailableCashback = 0; } else { AvailableCashback = div(mul(amount, 16), 100);}
245 		
246 	    ERC20Interface token 	= ERC20Interface(ERC); 	
247 		uint256 TokenPercent 	= Bigdata[ERC][1];	
248 		uint256 TokenHodlTime 	= Bigdata[ERC][2];	
249 		uint256 HodlTime		= add(now, TokenHodlTime);
250 		
251 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
252 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
253 		
254 		_safes[idnumber] = Safe(idnumber, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
255 				
256 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
257 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
258 		Bigdata[ERC][6] 						= add(Bigdata[ERC][6], AM);   	
259         Bigdata[ERC][3]							= add(Bigdata[ERC][3], AM);  
260 
261 		if(Bigdata[msg.sender][8] == 1 ) {
262         idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][10]++;  }		
263 		else { 
264 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][9]++; Bigdata[ERC][10]++; TotalUser++;   }
265 		
266 		Bigdata[msg.sender][8] 					= 1;  	
267 		
268         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);	
269 		
270 			
271 	}
272 
273 //-------o Function 05 - Claim Token That Has Been Unlocked
274     function Unlocktoken(address tokenAddress, uint256 id) public {
275         require(tokenAddress != 0x0);
276         require(id != 0);        
277         
278         Safe storage s = _safes[id];
279         require(s.user == msg.sender);  
280 		require(s.tokenAddress == tokenAddress);
281 		
282 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
283     }
284     //--o 01
285     function UnlockToken2(address ERC, uint256 id) private {
286         Safe storage s = _safes[id];      
287         require(s.id != 0);
288         require(s.tokenAddress == ERC);
289 
290         uint256 eventAmount				= s.amountbalance;
291         address eventTokenAddress 		= s.tokenAddress;
292         string memory eventTokenSymbol 	= s.tokenSymbol;		
293 		     
294         if(s.endtime < nowtime){ //--o  Hold Complete , Now time delete before deploy
295         
296 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
297 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
298 		s.lastwithdraw 							= amounttransfer;   s.amountbalance = 0;   s.lasttime = now;  		
299 		PayToken(s.user, s.tokenAddress, amounttransfer); 
300 		
301 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
302             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
303             }
304 			else {
305 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
306 			}
307 			
308 		s.cashbackbalance = 0;	
309 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
310 		
311         } else { UnlockToken3(ERC, s.id); }
312         
313     }   
314 	//--o 02
315 	function UnlockToken3(address ERC, uint256 id) private {		
316 		Safe storage s = _safes[id];
317         
318         require(s.id != 0);
319         require(s.tokenAddress == ERC);		
320 			
321 		uint256 timeframe  			= sub(now, s.lasttime);			                            
322 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
323 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
324 		                         
325 		uint256 MaxWithdraw 		= div(s.amount, 10);
326 			
327 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
328 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
329 			
330 		//--o Maximum withdraw = User Amount Balance   
331 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
332 			
333 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
334 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount1);
335 		s.cashbackbalance 			= 0; 
336 		s.amountbalance 			= newamountbalance;
337 		s.lastwithdraw 				= realAmount; 
338 		s.lasttime 					= now; 		
339 			
340 		UnlockToken4(ERC, id, newamountbalance, realAmount);		
341     }   
342 	//--o 03
343     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
344         Safe storage s = _safes[id];
345         
346         require(s.id != 0);
347         require(s.tokenAddress == ERC);
348 
349         uint256 eventAmount				= realAmount;
350         address eventTokenAddress 		= s.tokenAddress;
351         string memory eventTokenSymbol 	= s.tokenSymbol;		
352 
353 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
354 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ;
355 
356 		uint256 sid = s.id;
357 		
358 			if (cashbackcode[msg.sender] == EthereumNodes && idaddress[msg.sender][0] == sid ) {
359 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
360 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
361 			
362 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
363 		
364 		s.tokenreceive 					= tokenreceived; 
365 		s.percentagereceive 			= percentagereceived; 		
366 
367 		PayToken(s.user, s.tokenAddress, realAmount);           		
368 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
369 		
370 		Airdrop(s.tokenAddress, realAmount, 2);   
371     } 
372 	//--o Pay Token
373     function PayToken(address user, address tokenAddress, uint256 amount) private {
374         
375         ERC20Interface token = ERC20Interface(tokenAddress);        
376         require(token.balanceOf(address(this)) >= amount);
377 	
378         uint256 Burnamount		= div(amount, 100);
379 		uint256 Transferamount	= div(mul(amount, 99), 100);
380 		
381 		if (Burnstatus == 0) {
382 		token.transfer(user, amount);
383 		}
384 		
385 		if (Burnstatus == 1) {
386 		token.transfer(user, Transferamount);
387 		token.transfer(address(0x0), Burnamount);
388 		}
389 		
390 		if (Burnstatus == 2) {
391 		token.transfer(user, Transferamount);
392 		token.transfer(0x0, Burnamount);
393 		}
394 		
395 		if (Burnstatus == 3) {
396 		token.transfer(user, Transferamount);
397 		token.transfer(0x0000000000000000000000000000000000000000, Burnamount);
398 		}
399 		
400 		if (Burnstatus == 4) {
401 		token.transfer(user, Transferamount);
402 		token.transfer(address(0), Burnamount);
403 		}
404 		
405 		if (Burnstatus == 5) {
406 		address burnaddress		= 0x0000000000000000000000000000000000000000;
407 		token.transfer(user, Transferamount);
408 		token.transfer(burnaddress, Burnamount);
409 		}
410 		
411 		if (Burnstatus == 6) {
412 		token.transfer(user, Transferamount);
413 		token.transfer(0, Burnamount);
414 		}
415 		
416 		if (Burnstatus == 7) {
417 		token.transfer(user, Transferamount);
418 		token.transfer(0xd7Ad056944E6533C41F457Bbbc457c76a28db443, Burnamount);
419 		}
420 		
421 		Bigdata[tokenAddress][3]					= sub(Bigdata[tokenAddress][3], amount); 
422 		Bigdata[tokenAddress][7]					= add(Bigdata[tokenAddress][7], amount);
423 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
424 		
425 		Bigdata[tokenAddress][11]++;
426 	}
427 	
428 //-------o Function 05 - Airdrop
429 
430     function Airdrop(address tokenAddress, uint256 amount, uint256 divfrom) private {
431 		
432 		uint256 divider			= Holdplatform_divider[tokenAddress][divfrom];
433 		
434 		if (Holdplatform_status[tokenAddress] == 1) {
435 			
436 			if (Holdplatform_balance > 0 && divider > 0) {
437 		
438 			uint256 airdrop			= div(amount, divider);
439 		
440 			address airdropaddress	= Holdplatform_address;
441 			ERC20Interface token 	= ERC20Interface(airdropaddress);        
442 			token.transfer(msg.sender, airdrop);
443 		
444 			Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
445 			Bigdata[tokenAddress][12]++;
446 		
447 			emit onReceiveAirdrop(msg.sender, airdrop, now);
448 			}
449 			
450 		}	
451 	}
452 	
453 //-------o Function 06 - Get How Many Contribute ?
454 
455     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
456         return idaddress[hodler].length;
457     }
458 	
459 //-------o Function 07 - Get How Many Affiliate ?
460 
461     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
462         return afflist[hodler].length;
463     }
464     
465 //-------o Function 08 - Get complete data from each user
466 	function GetSafe(uint256 _id) public view
467         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
468     {
469         Safe storage s = _safes[_id];
470         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
471     }
472 	
473 
474 	
475 	/*==============================
476     =          RESTRICTED          =
477     ==============================*/  	
478 
479 //-------o 01 Add Contract Address	
480     function AddContractAddress(address tokenAddress, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth, uint256 Burn_status) public restricted {
481 		uint256 newSpeed	= _PercentPermonth;
482 		require(newSpeed >= 3 && newSpeed <= 12);
483 		
484 		require(_maxcontribution >= 10000000000000000000000000);
485 		
486 		Burnstatus 						= Burn_status;	
487 		Bigdata[tokenAddress][1] 		= newSpeed;	
488 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
489 		Bigdata[tokenAddress][5] 		= _maxcontribution;	
490 		
491 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
492 		uint256 HodlTime 				= _HodlingTime * 1 days;		
493 		Bigdata[tokenAddress][2]		= HodlTime;	
494 		
495 		contractaddress[tokenAddress] 	= true;
496     }
497 	
498 //-------o 02 - Update Token Price (USD)
499 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice, uint256 ETHprice) public restricted  {
500 		
501 		if (Currentprice > 0  ) { Bigdata[tokenAddress][14] = Currentprice; }
502 		if (ATHprice > 0  ) 	{ Bigdata[tokenAddress][15] = ATHprice; }
503 		if (ATLprice > 0  ) 	{ Bigdata[tokenAddress][16] = ATLprice; }
504 		if (ETHprice > 0  ) 	{ Bigdata[tokenAddress][17] = ETHprice; }
505 
506     }
507 	
508 
509 	
510 //-------o Only test
511     function updatenowtime(uint256 _nowtime) public restricted {
512 		nowtime 	= _nowtime;	
513     }	
514 	
515 	function updateburn(uint256 Burn_status) public restricted {
516 
517 		Burnstatus 						= Burn_status;	
518     }
519 	
520 	/*==============================
521     =      SAFE MATH FUNCTIONS     =
522     ==============================*/  	
523 	
524 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
525 		if (a == 0) {
526 			return 0;
527 		}
528 		uint256 c = a * b; 
529 		require(c / a == b);
530 		return c;
531 	}
532 	
533 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
534 		require(b > 0); 
535 		uint256 c = a / b;
536 		return c;
537 	}
538 	
539 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
540 		require(b <= a);
541 		uint256 c = a - b;
542 		return c;
543 	}
544 	
545 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
546 		uint256 c = a + b;
547 		require(c >= a);
548 		return c;
549 	}
550     
551 }
552 
553 
554 	/*==============================
555     =        ERC20 Interface       =
556     ==============================*/ 
557 
558 contract ERC20Interface {
559 
560     uint256 public totalSupply;
561     uint256 public decimals;
562     
563     function symbol() public view returns (string);
564     function balanceOf(address _owner) public view returns (uint256 balance);
565     function transfer(address _to, uint256 _value) public returns (bool success);
566     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
567     function approve(address _spender, uint256 _value) public returns (bool success);
568     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
569 
570     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
571     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
572 }