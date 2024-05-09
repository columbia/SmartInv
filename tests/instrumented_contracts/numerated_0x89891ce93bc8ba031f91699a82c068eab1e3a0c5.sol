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
21     =          Version 9.0       =
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
80 	
81 	uint256 private idnumber; 										// [01] -- > ID number ( Start from 500 )				
82 	uint256 public  TotalUser; 										// [02] -- > Total Smart Contract User					
83 	mapping(address => address) 		public cashbackcode; 		// [03] -- > Cashback Code 					
84 	mapping(address => uint256[]) 		public idaddress;			// [04] -- > Search Address by ID			
85 	mapping(address => address[]) 		public afflist;				// [05] -- > Affiliate List by ID					
86 	mapping(address => string) 			public ContractSymbol; 		// [06] -- > Contract Address Symbol				
87 	mapping(uint256 => Safe) 			private _safes; 			// [07] -- > Struct safe database	
88 	mapping(address => bool) 			public contractaddress; 	// [08] -- > Contract Address 		
89 
90 	mapping (address => mapping (uint256 => uint256)) public Bigdata; 
91 	
92 /** Bigdata Mapping : 
93 [1] Percent (Monthly Unlocked tokens)		[7] All Payments 				[13] Total TX Affiliate (Withdraw) 	
94 [2] Holding Time (in seconds) 				[8] Active User 				[14] Current Price (USD)	
95 [3] Token Balance 							[9] Total User 					[15] ATH Price (USD)
96 [4] Min Contribution 						[10] Total TX Hold 				[16] ATL Price (USD)			
97 [5] Max Contribution 						[11] Total TX Unlock 			[17] Current ETH Price (ETH) 		
98 [6] All Contribution 						[12] Total TX Airdrop			[18] Data Register				
99 **/
100 
101 	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
102 // Statistics = [1] LifetimeContribution [2] LifetimePayments [3] Affiliatevault [4] Affiliateprofit [5] ActiveContribution
103 	
104 // Airdrop - Hold Platform (HOLD)		
105 	address public Holdplatform_address;											// [01]
106 	uint256 public Holdplatform_balance; 											// [02]
107 	mapping(address => uint256) public Holdplatform_status;							// [03]
108 	mapping(address => mapping (uint256 => uint256)) public Holdplatform_divider; 
109 // Holdplatform_divider = [1] Lock Airdrop	[2] Unlock Airdrop	[3] Affiliate Airdrop
110 	
111 	
112 	/*==============================
113     =          CONSTRUCTOR         =
114     ==============================*/  	
115    
116     constructor() public {     	 	
117         idnumber 				= 500;
118 		Holdplatform_address	= 0x23bAdee11Bf49c40669e9b09035f048e9146213e;	//Change before deploy
119     }
120     
121 	
122 	/*==============================
123     =    AVAILABLE FOR EVERYONE    =
124     ==============================*/  
125 
126 //-------o Function 01 - Ethereum Payable
127     function () public payable {  
128 		if (msg.value == 0) {
129 			tothe_moon();
130 		} else { revert(); }
131     }
132     function tothemoon() public payable {  
133 		if (msg.value == 0) {
134 			tothe_moon();
135 		} else { revert(); }
136     }
137 	function tothe_moon() private {  
138 		for(uint256 i = 1; i < idnumber; i++) {            
139 		Safe storage s = _safes[i];
140 		
141 			// Send all unlocked tokens
142 			if (s.user == msg.sender) {
143 			Unlocktoken(s.tokenAddress, s.id);
144 				// Send all affiliate bonus
145 				if (Statistics[s.user][s.tokenAddress][3] > 0) {
146 				WithdrawAffiliate(s.user, s.tokenAddress);
147 				}
148 			}
149 		}
150     }
151 	
152 //-------o Function 02 - Cashback Code
153 
154     function CashbackCode(address _cashbackcode) public {		
155 		require(_cashbackcode != msg.sender);			
156 		
157 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 && Bigdata[_cashbackcode][8] == 1) { 
158 		cashbackcode[msg.sender] = _cashbackcode; }
159 		else { cashbackcode[msg.sender] = EthereumNodes; }		
160 		
161 	emit onCashbackCode(msg.sender, _cashbackcode);		
162     } 
163 	
164 //-------o Function 03 - Contribute 
165 
166 	//--o 01
167     function Holdplatform(address tokenAddress, uint256 amount) public {
168 		require(amount >= 1 );
169 		uint256 holdamount	= add(Statistics[msg.sender][tokenAddress][5], amount);
170 		
171 		require(holdamount <= Bigdata[tokenAddress][5] );
172 		
173 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 ) { 
174 			cashbackcode[msg.sender] 	= EthereumNodes;
175 		} 
176 		
177 		if (Bigdata[msg.sender][18] == 0) { 
178 			Bigdata[msg.sender][18] = now;
179 		} 
180 		
181 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
182 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
183         require(token.transferFrom(msg.sender, address(this), amount));	
184 		
185 		HodlTokens2(tokenAddress, amount);
186 		Airdrop(tokenAddress, amount, 1);
187 		}							
188 	}
189 	
190 	//--o 02	
191     function HodlTokens2(address ERC, uint256 amount) public {
192 		
193 		address ref						= cashbackcode[msg.sender];
194 		address ref2					= EthereumNodes;
195 		uint256 ReferrerContribution 	= Statistics[ref][ERC][5];	
196 		uint256 ReferralContribution 	= Statistics[msg.sender][ERC][5];
197 		uint256 MyContribution 			= add(ReferralContribution, amount); 
198 		
199 	  	if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) { 
200 			uint256 nodecomission 		= div(mul(amount, 28), 100);
201 			Statistics[ref][ERC][3] 	= add(Statistics[ref][ERC][3], nodecomission ); 
202 			Statistics[ref][ERC][4] 	= add(Statistics[ref][ERC][4], nodecomission );		
203 			
204 		} else { 
205 		
206 // Very complicated code, need to be checked carefully!		
207 
208 			uint256 affcomission 	= div(mul(amount, 12), 100); 
209 			
210 			if (ReferrerContribution >= MyContribution) { //--o  if referrer contribution >= My contribution
211 
212 				Statistics[ref][ERC][3] 		= add(Statistics[ref][ERC][3], affcomission); 
213 				Statistics[ref][ERC][4] 		= add(Statistics[ref][ERC][4], affcomission); 
214 
215 			} else {
216 					if (ReferrerContribution > ReferralContribution  ) { 	
217 						if (amount <= add(ReferrerContribution,ReferralContribution)  ) { 
218 						
219 						uint256 AAA				= sub(ReferrerContribution, ReferralContribution );
220 						uint256 affcomission2	= div(mul(AAA, 12), 100); 
221 						uint256 affcomission3	= sub(affcomission, affcomission2);		
222 						} else {	
223 						uint256 BBB				= sub(sub(amount, ReferrerContribution), ReferralContribution);
224 						affcomission3			= div(mul(BBB, 12), 100); 
225 						affcomission2			= sub(affcomission, affcomission3); } 
226 						
227 					} else { affcomission2	= 0; 	affcomission3	= affcomission; } 
228 // end //					
229 				Statistics[ref][ERC][3] 		= add(Statistics[ref][ERC][3], affcomission2); 
230 				Statistics[ref][ERC][4] 		= add(Statistics[ref][ERC][4], affcomission2); 	
231 	
232 				Statistics[ref2][ERC][3] 		= add(Statistics[ref2][ERC][3], affcomission3); 
233 				Statistics[ref2][ERC][4] 		= add(Statistics[ref2][ERC][4], affcomission3);	
234 			}	
235 		}
236 
237 		HodlTokens3(ERC, amount, ref); 	
238 	}
239 	//--o 04	
240     function HodlTokens3(address ERC, uint256 amount, address ref) public {
241 	    
242 		uint256 AvailableBalances 		= div(mul(amount, 72), 100);
243 		
244 		if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) 
245 		{ uint256	AvailableCashback = 0; } else { AvailableCashback = div(mul(amount, 16), 100);}
246 		
247 	    ERC20Interface token 	= ERC20Interface(ERC); 	
248 		uint256 TokenPercent 	= Bigdata[ERC][1];	
249 		uint256 TokenHodlTime 	= Bigdata[ERC][2];	
250 		uint256 HodlTime		= add(now, TokenHodlTime);
251 		
252 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
253 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
254 		
255 		_safes[idnumber] = Safe(idnumber, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
256 				
257 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
258 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
259 		Bigdata[ERC][6] 						= add(Bigdata[ERC][6], AM);   	
260         Bigdata[ERC][3]							= add(Bigdata[ERC][3], AM);  
261 
262 		if(Bigdata[msg.sender][8] == 1 ) {
263         idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][10]++;  }		
264 		else { 
265 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][9]++; Bigdata[ERC][10]++; TotalUser++;   }
266 		
267 		Bigdata[msg.sender][8] 					= 1;  	
268 		
269         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);	
270 		
271 			
272 	}
273 
274 //-------o Function 05 - Claim Token That Has Been Unlocked
275     function Unlocktoken(address tokenAddress, uint256 id) public {
276         require(tokenAddress != 0x0);
277         require(id != 0);        
278         
279         Safe storage s = _safes[id];
280         require(s.user == msg.sender);  
281 		require(s.tokenAddress == tokenAddress);
282 		
283 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
284     }
285     //--o 01
286     function UnlockToken2(address ERC, uint256 id) private {
287         Safe storage s = _safes[id];      
288         require(s.id != 0);
289         require(s.tokenAddress == ERC);
290 
291         uint256 eventAmount				= s.amountbalance;
292         address eventTokenAddress 		= s.tokenAddress;
293         string memory eventTokenSymbol 	= s.tokenSymbol;		
294 		     
295         if(s.endtime < nowtime){ //--o  Hold Complete , Now time delete before deploy
296         
297 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
298 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
299 		s.lastwithdraw 							= amounttransfer;   s.amountbalance = 0;   s.lasttime = now;  		
300 		PayToken(s.user, s.tokenAddress, amounttransfer); 
301 		
302 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
303             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
304             }
305 			else {
306 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
307 			}
308 			
309 		s.cashbackbalance = 0;	
310 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
311 		
312         } else { UnlockToken3(ERC, s.id); }
313         
314     }   
315 	//--o 02
316 	function UnlockToken3(address ERC, uint256 id) private {		
317 		Safe storage s = _safes[id];
318         
319         require(s.id != 0);
320         require(s.tokenAddress == ERC);		
321 			
322 		uint256 timeframe  			= sub(now, s.lasttime);			                            
323 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
324 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
325 		                         
326 		uint256 MaxWithdraw 		= div(s.amount, 10);
327 			
328 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
329 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
330 			
331 		//--o Maximum withdraw = User Amount Balance   
332 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
333 			
334 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
335 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount1);
336 		s.cashbackbalance 			= 0; 
337 		s.amountbalance 			= newamountbalance;
338 		s.lastwithdraw 				= realAmount; 
339 		s.lasttime 					= now; 		
340 			
341 		UnlockToken4(ERC, id, newamountbalance, realAmount);		
342     }   
343 	//--o 03
344     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
345         Safe storage s = _safes[id];
346         
347         require(s.id != 0);
348         require(s.tokenAddress == ERC);
349 
350         uint256 eventAmount				= realAmount;
351         address eventTokenAddress 		= s.tokenAddress;
352         string memory eventTokenSymbol 	= s.tokenSymbol;		
353 
354 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
355 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ;
356 
357 		uint256 sid = s.id;
358 		
359 			if (cashbackcode[msg.sender] == EthereumNodes && idaddress[msg.sender][0] == sid ) {
360 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
361 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
362 			
363 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
364 		
365 		s.tokenreceive 					= tokenreceived; 
366 		s.percentagereceive 			= percentagereceived; 		
367 
368 		PayToken(s.user, s.tokenAddress, realAmount);           		
369 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
370 		
371 		Airdrop(s.tokenAddress, realAmount, 2);   
372     } 
373 	//--o Pay Token
374     function PayToken(address user, address tokenAddress, uint256 amount) private {
375         
376         ERC20Interface token = ERC20Interface(tokenAddress);        
377         require(token.balanceOf(address(this)) >= amount);
378         uint256 Burnamount		= div(amount, 100);
379 		uint256 Trasnferamount	= div(mul(amount, 99), 100);
380 		
381         token.transfer(user, Trasnferamount);
382 		token.transfer(address(0), Burnamount);
383 		
384 		Bigdata[tokenAddress][3]					= sub(Bigdata[tokenAddress][3], amount); 
385 		Bigdata[tokenAddress][7]					= add(Bigdata[tokenAddress][7], amount);
386 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
387 		
388 		Bigdata[tokenAddress][11]++;
389 	}
390 	
391 //-------o Function 05 - Airdrop
392 
393     function Airdrop(address tokenAddress, uint256 amount, uint256 divfrom) private {
394 		
395 		uint256 divider			= Holdplatform_divider[tokenAddress][divfrom];
396 		
397 		if (Holdplatform_status[tokenAddress] == 1) {
398 			
399 			if (Holdplatform_balance > 0 && divider > 0) {
400 		
401 			uint256 airdrop			= div(amount, divider);
402 		
403 			address airdropaddress	= Holdplatform_address;
404 			ERC20Interface token 	= ERC20Interface(airdropaddress);        
405 			token.transfer(msg.sender, airdrop);
406 		
407 			Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
408 			Bigdata[tokenAddress][12]++;
409 		
410 			emit onReceiveAirdrop(msg.sender, airdrop, now);
411 			}
412 			
413 		}	
414 	}
415 	
416 //-------o Function 06 - Get How Many Contribute ?
417 
418     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
419         return idaddress[hodler].length;
420     }
421 	
422 //-------o Function 07 - Get How Many Affiliate ?
423 
424     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
425         return afflist[hodler].length;
426     }
427     
428 //-------o Function 08 - Get complete data from each user
429 	function GetSafe(uint256 _id) public view
430         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
431     {
432         Safe storage s = _safes[_id];
433         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
434     }
435 	
436 //-------o Function 09 - Withdraw Affiliate Bonus
437 
438     function WithdrawAffiliate(address user, address tokenAddress) public {  
439 		require(tokenAddress != 0x0);		
440 		require(Statistics[user][tokenAddress][3] > 0 );
441 		
442 		uint256 amount = Statistics[msg.sender][tokenAddress][3];
443 		Statistics[msg.sender][tokenAddress][3] = 0;
444 		
445 		Bigdata[tokenAddress][3] 		= sub(Bigdata[tokenAddress][3], amount); 
446 		Bigdata[tokenAddress][7] 		= add(Bigdata[tokenAddress][7], amount);
447 		
448 		uint256 eventAmount				= amount;
449         address eventTokenAddress 		= tokenAddress;
450         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
451         
452         ERC20Interface token = ERC20Interface(tokenAddress);        
453         require(token.balanceOf(address(this)) >= amount);
454         token.transfer(user, amount);
455 		
456 		Statistics[user][tokenAddress][2] 	= add(Statistics[user][tokenAddress][2], amount);
457 
458 		Bigdata[tokenAddress][13]++;		
459 		
460 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
461 		
462 		Airdrop(tokenAddress, amount, 3); 
463     } 		
464 	
465 	
466 	/*==============================
467     =          RESTRICTED          =
468     ==============================*/  	
469 
470 //-------o 01 Add Contract Address	
471     function AddContractAddress(address tokenAddress, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
472 		uint256 newSpeed	= _PercentPermonth;
473 		require(newSpeed >= 3 && newSpeed <= 12);
474 		
475 		require(_maxcontribution >= 10000000);
476 		
477 		Bigdata[tokenAddress][1] 		= newSpeed;	
478 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
479 		Bigdata[tokenAddress][5] 		= _maxcontribution;	
480 		
481 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
482 		uint256 HodlTime 				= _HodlingTime * 1 days;		
483 		Bigdata[tokenAddress][2]		= HodlTime;	
484 		
485 		contractaddress[tokenAddress] 	= true;
486     }
487 	
488 //-------o 02 - Update Token Price (USD)
489 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice, uint256 ETHprice) public restricted  {
490 		
491 		if (Currentprice > 0  ) { Bigdata[tokenAddress][14] = Currentprice; }
492 		if (ATHprice > 0  ) 	{ Bigdata[tokenAddress][15] = ATHprice; }
493 		if (ATLprice > 0  ) 	{ Bigdata[tokenAddress][16] = ATLprice; }
494 		if (ETHprice > 0  ) 	{ Bigdata[tokenAddress][17] = ETHprice; }
495 
496     }
497 	
498 //-------o 03 Hold Platform
499     function Holdplatform_Airdrop(address tokenAddress, uint256 HPM_status, uint256 HPM_divider1, uint256 HPM_divider2, uint256 HPM_divider3 ) public restricted {
500 		
501 		Holdplatform_status[tokenAddress] 		= HPM_status;	
502 		Holdplatform_divider[tokenAddress][1]	= HPM_divider1; // Lock Airdrop
503 		Holdplatform_divider[tokenAddress][2]	= HPM_divider2; // Unlock Airdrop
504 		Holdplatform_divider[tokenAddress][3]	= HPM_divider3; // Affiliate Airdrop
505 	
506     }	
507 	//--o Deposit
508 	function Holdplatform_Deposit(uint256 amount) restricted public {
509 		require(amount > 0 );
510         
511        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
512         require(token.transferFrom(msg.sender, address(this), amount));
513 		
514 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
515 		Holdplatform_balance 	= newbalance;
516     }
517 	//--o Withdraw
518 	function Holdplatform_Withdraw(uint256 amount) restricted public {
519         require(Holdplatform_balance > 0 && amount <= Holdplatform_balance);
520         
521 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
522 		Holdplatform_balance 	= newbalance;
523         
524         ERC20Interface token = ERC20Interface(Holdplatform_address);
525         
526         require(token.balanceOf(address(this)) >= amount);
527         token.transfer(msg.sender, amount);
528     }
529 	
530 //-------o Only test
531     function updatenowtime(uint256 _nowtime) public restricted {
532 		nowtime 	= _nowtime;	
533     }	
534 	
535 	/*==============================
536     =      SAFE MATH FUNCTIONS     =
537     ==============================*/  	
538 	
539 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
540 		if (a == 0) {
541 			return 0;
542 		}
543 		uint256 c = a * b; 
544 		require(c / a == b);
545 		return c;
546 	}
547 	
548 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
549 		require(b > 0); 
550 		uint256 c = a / b;
551 		return c;
552 	}
553 	
554 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
555 		require(b <= a);
556 		uint256 c = a - b;
557 		return c;
558 	}
559 	
560 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
561 		uint256 c = a + b;
562 		require(c >= a);
563 		return c;
564 	}
565     
566 }
567 
568 
569 	/*==============================
570     =        ERC20 Interface       =
571     ==============================*/ 
572 
573 contract ERC20Interface {
574 
575     uint256 public totalSupply;
576     uint256 public decimals;
577     
578     function symbol() public view returns (string);
579     function balanceOf(address _owner) public view returns (uint256 balance);
580     function transfer(address _to, uint256 _value) public returns (bool success);
581     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
582     function approve(address _spender, uint256 _value) public returns (bool success);
583     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
584 
585     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
586     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
587 }