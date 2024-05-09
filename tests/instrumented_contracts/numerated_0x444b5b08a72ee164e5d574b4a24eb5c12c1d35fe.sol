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
21     =          Version 8.5        =
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
89 
90 	mapping (address => mapping (uint256 => uint256)) public Bigdata; 
91 	
92 /** Bigdata Mapping : 
93 [1] Percent (Monthly Unlocked tokens)		[7] All Payments 				[13] Total TX Affiliate (Withdraw) 	
94 [2] Holding Time (in seconds) 				[8] Active User 				[14] Current Price (USD)	
95 [3] Token Balance 							[9] Total User 					[15] ATH Price (USD)
96 [4] Min Contribution 						[10] Total TX Hold 				[16] ATL Price (USD)			
97 [5] Max Contribution 						[11] Total TX Unlock 			[17] Current ETH Price (ETH) 		
98 [6] All Contribution 						[12] Total TX Airdrop			[18] Unique Code							
99 **/
100 
101 	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
102 // Statistics = [1] LifetimeContribution [2] LifetimePayments [3] Affiliatevault [4] Affiliateprofit [5] ActiveContribution
103 	
104 // Airdrop - Hold Platform (HOLD)		
105 	address public Holdplatform_address;						// [01]
106 	uint256 public Holdplatform_balance; 						// [02]
107 	mapping(address => uint256) public Holdplatform_status;		// [03]
108 	mapping(address => uint256) public Holdplatform_divider; 	// [04]
109 	
110 	
111 	/*==============================
112     =          CONSTRUCTOR         =
113     ==============================*/  	
114    
115     constructor() public {     	 	
116         idnumber 				= 500;
117 		Holdplatform_address	= 0x23bAdee11Bf49c40669e9b09035f048e9146213e;	//Change before deploy
118     }
119     
120 	
121 	/*==============================
122     =    AVAILABLE FOR EVERYONE    =
123     ==============================*/  
124 
125 //-------o Function 01 - Ethereum Payable
126     function () public payable {  
127 		if (msg.value == 0) {
128 			tothe_moon();
129 		} else { revert(); }
130     }
131     function tothemoon() public payable {  
132 		if (msg.value == 0) {
133 			tothe_moon();
134 		} else { revert(); }
135     }
136 	function tothe_moon() private {  
137 		for(uint256 i = 1; i < idnumber; i++) {            
138 		Safe storage s = _safes[i];
139 			if (s.user == msg.sender) {
140 			Unlocktoken(s.tokenAddress, s.id);
141 			}
142 		}
143     }
144 	
145 //-------o Function 02 - Cashback Code
146 
147     function CashbackCode(address _cashbackcode, uint256 uniquecode) public {		
148 		require(_cashbackcode != msg.sender);			
149 		
150 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 && Bigdata[_cashbackcode][8] == 1 && Bigdata[_cashbackcode][18] != uniquecode ) { 
151 		
152 		cashbackcode[msg.sender] = _cashbackcode; }
153 		
154 		else { cashbackcode[msg.sender] = EthereumNodes; }	
155 
156 		if (Bigdata[msg.sender][18] == 0 ) { 
157 		Bigdata[msg.sender][18]	= uniquecode; }
158 		
159 	emit onCashbackCode(msg.sender, _cashbackcode);		
160     } 
161 	
162 //-------o Function 03 - Contribute 
163 
164 	//--o 01
165     function Holdplatform(address tokenAddress, uint256 amount) public {
166 		require(amount >= 1 );
167 		uint256 holdamount	= add(Statistics[msg.sender][tokenAddress][5], amount);
168 		
169 		require(holdamount <= Bigdata[tokenAddress][5] );
170 		
171 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 ) { 
172 			cashbackcode[msg.sender] 	= EthereumNodes;
173 			Bigdata[msg.sender][18]		= 123456;	
174 		} 
175 		
176 		if (contractaddress[tokenAddress] == false) { revert(); } else { 
177 
178 		uint256 Finalamount 			= div(mul(amount, 98), 100);	
179 		uint256 Burn 					= div(mul(amount, 2), 100);	
180 		address Burnaddress				= 0x0000000000000000000000000000000000000000;
181 		
182 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
183         require(token.transferFrom(msg.sender, address(this), Finalamount));	
184 		require(token.transferFrom(msg.sender, Burnaddress, Burn));	
185 		
186 		HodlTokens2(tokenAddress, amount);
187 		Airdrop(tokenAddress, amount, 1); 
188 		}							
189 	}
190 	
191 	//--o 02	
192     function HodlTokens2(address ERC, uint256 amount) public {
193 		
194 		address ref						= cashbackcode[msg.sender];
195 		uint256 AvailableBalances 		= div(mul(amount, 72), 100);
196 		uint256	AvailableCashback 		= div(mul(amount, 16), 100);		
197 		uint256 affcomission 			= div(mul(amount, 10), 100); 		//test
198 		uint256 nodecomission 			= div(mul(amount, 26), 100);		//test
199 			
200 		if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) { 
201 			AvailableCashback 			= 0; 
202 			Statistics[ref][ERC][3] 	= add(Statistics[ref][ERC][3], nodecomission); 
203 			Statistics[ref][ERC][4] 	= add(Statistics[ref][ERC][4], nodecomission); 
204 			Bigdata[msg.sender][19]		= 111; // Only Tracking ( Delete Before Deploy )
205 			
206 		} else { 
207 		
208 			Statistics[ref][ERC][3] 	= add(Statistics[ref][ERC][3], affcomission); 
209 			Statistics[ref][ERC][4] 	= add(Statistics[ref][ERC][4], affcomission); 
210 			Bigdata[msg.sender][19]		= 222; // Only Tracking ( Delete Before Deploy )	
211 		} 	
212 
213 		HodlTokens3(ERC, amount, AvailableBalances, AvailableCashback, ref); 	
214 	}
215 	//--o 04	
216     function HodlTokens3(address ERC, uint256 amount, uint256 AvailableBalances, uint256 AvailableCashback, address ref) public {
217 	    
218 	    ERC20Interface token 	= ERC20Interface(ERC); 	
219 		uint256 TokenPercent 	= Bigdata[ERC][1];	
220 		uint256 TokenHodlTime 	= Bigdata[ERC][2];	
221 		uint256 HodlTime		= add(now, TokenHodlTime);
222 		
223 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
224 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
225 		
226 		_safes[idnumber] = Safe(idnumber, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
227 				
228 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
229 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
230 		Bigdata[ERC][6] 						= add(Bigdata[ERC][6], AM);   	
231         Bigdata[ERC][3]							= add(Bigdata[ERC][3], AM);  
232 
233 		if(Bigdata[msg.sender][8] == 1 ) {
234         idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][10]++;  }		
235 		else { 
236 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][9]++; Bigdata[ERC][10]++; TotalUser++;   }
237 		
238 		Bigdata[msg.sender][8] 					= 1;  	
239 		
240         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);	
241 
242 		Bigdata[msg.sender][19]		= 333; // Only Tracking ( Delete Before Deploy )			
243 			
244 	}
245 
246 //-------o Function 05 - Claim Token That Has Been Unlocked
247     function Unlocktoken(address tokenAddress, uint256 id) public {
248         require(tokenAddress != 0x0);
249         require(id != 0);        
250         
251         Safe storage s = _safes[id];
252         require(s.user == msg.sender);  
253 		require(s.tokenAddress == tokenAddress);
254 		
255 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
256     }
257     //--o 01
258     function UnlockToken2(address ERC, uint256 id) private {
259         Safe storage s = _safes[id];      
260         require(s.id != 0);
261         require(s.tokenAddress == ERC);
262 
263         uint256 eventAmount				= s.amountbalance;
264         address eventTokenAddress 		= s.tokenAddress;
265         string memory eventTokenSymbol 	= s.tokenSymbol;		
266 		     
267         if(s.endtime < now){ //--o  Hold Complete
268         
269 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
270 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
271 		s.lastwithdraw 							= amounttransfer;   s.amountbalance = 0;   s.lasttime = now;  		
272 		PayToken(s.user, s.tokenAddress, amounttransfer); 
273 		
274 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
275             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
276             }
277 			else {
278 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
279 			}
280 			
281 		s.cashbackbalance = 0;	
282 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
283 		
284         } else { UnlockToken3(ERC, s.id); }
285         
286     }   
287 	//--o 02
288 	function UnlockToken3(address ERC, uint256 id) private {		
289 		Safe storage s = _safes[id];
290         
291         require(s.id != 0);
292         require(s.tokenAddress == ERC);		
293 			
294 		uint256 timeframe  			= sub(now, s.lasttime);			                            
295 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
296 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
297 		                         
298 		uint256 MaxWithdraw 		= div(s.amount, 10);
299 			
300 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
301 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
302 			
303 		//--o Maximum withdraw = User Amount Balance   
304 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
305 			
306 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
307 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount1);
308 		s.cashbackbalance 			= 0; 
309 		s.amountbalance 			= newamountbalance;
310 		s.lastwithdraw 				= realAmount; 
311 		s.lasttime 					= now; 		
312 			
313 		UnlockToken4(ERC, id, newamountbalance, realAmount);		
314     }   
315 	//--o 03
316     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
317         Safe storage s = _safes[id];
318         
319         require(s.id != 0);
320         require(s.tokenAddress == ERC);
321 
322         uint256 eventAmount				= realAmount;
323         address eventTokenAddress 		= s.tokenAddress;
324         string memory eventTokenSymbol 	= s.tokenSymbol;		
325 
326 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
327 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ;
328 
329 		uint256 sid = s.id;
330 		
331 			if (cashbackcode[msg.sender] == EthereumNodes && idaddress[msg.sender][0] == sid ) {
332 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
333 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
334 			
335 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
336 		
337 		s.tokenreceive 					= tokenreceived; 
338 		s.percentagereceive 			= percentagereceived; 		
339 
340 		PayToken(s.user, s.tokenAddress, realAmount);           		
341 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
342 		
343 		Airdrop(s.tokenAddress, realAmount, 4);   
344     } 
345 	//--o Pay Token
346     function PayToken(address user, address tokenAddress, uint256 amount) private {
347         
348         ERC20Interface token = ERC20Interface(tokenAddress);        
349         require(token.balanceOf(address(this)) >= amount);
350         token.transfer(user, amount);
351 		
352 		Bigdata[tokenAddress][3]					= sub(Bigdata[tokenAddress][3], amount); 
353 		Bigdata[tokenAddress][7]					= add(Bigdata[tokenAddress][7], amount);
354 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
355 		
356 		Bigdata[tokenAddress][11]++;
357 	}
358 	
359 //-------o Function 05 - Airdrop
360 
361     function Airdrop(address tokenAddress, uint256 amount, uint256 extradivider) private {
362 		
363 		if (Holdplatform_status[tokenAddress] == 1) {
364 		require(Holdplatform_balance > 0 );
365 		
366 		uint256 divider 		= Holdplatform_divider[tokenAddress];
367 		uint256 airdrop			= div(div(amount, divider), extradivider);
368 		
369 		address airdropaddress	= Holdplatform_address;
370 		ERC20Interface token 	= ERC20Interface(airdropaddress);        
371         token.transfer(msg.sender, airdrop);
372 		
373 		Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
374 		Bigdata[tokenAddress][12]++;
375 		
376 		emit onReceiveAirdrop(msg.sender, airdrop, now);
377 		}	
378 	}
379 	
380 //-------o Function 06 - Get How Many Contribute ?
381 
382     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
383         return idaddress[hodler].length;
384     }
385 	
386 //-------o Function 07 - Get How Many Affiliate ?
387 
388     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
389         return afflist[hodler].length;
390     }
391     
392 //-------o Function 08 - Get complete data from each user
393 	function GetSafe(uint256 _id) public view
394         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
395     {
396         Safe storage s = _safes[_id];
397         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
398     }
399 	
400 //-------o Function 09 - Withdraw Affiliate Bonus
401 
402     function WithdrawAffiliate(address user, address tokenAddress) public {  
403 		require(tokenAddress != 0x0);		
404 		require(Statistics[user][tokenAddress][3] > 0 );
405 		
406 		uint256 amount = Statistics[msg.sender][tokenAddress][3];
407 		Statistics[msg.sender][tokenAddress][3] = 0;
408 		
409 		Bigdata[tokenAddress][3] 		= sub(Bigdata[tokenAddress][3], amount); 
410 		Bigdata[tokenAddress][7] 		= add(Bigdata[tokenAddress][7], amount);
411 		
412 		uint256 eventAmount				= amount;
413         address eventTokenAddress 		= tokenAddress;
414         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
415         
416         ERC20Interface token = ERC20Interface(tokenAddress);        
417         require(token.balanceOf(address(this)) >= amount);
418         token.transfer(user, amount);
419 		
420 		Statistics[user][tokenAddress][2] 	= add(Statistics[user][tokenAddress][2], amount);
421 
422 		Bigdata[tokenAddress][13]++;		
423 		
424 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
425 		
426 		Airdrop(tokenAddress, amount, 4); 
427     } 		
428 	
429 	
430 	/*==============================
431     =          RESTRICTED          =
432     ==============================*/  	
433 
434 //-------o 01 Add Contract Address	
435     function AddContractAddress(address tokenAddress, uint256 CurrentUSDprice, uint256 CurrentETHprice, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
436 		uint256 newSpeed	= _PercentPermonth;
437 		require(newSpeed >= 3 && newSpeed <= 12);
438 		
439 		Bigdata[tokenAddress][1] 		= newSpeed;	
440 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
441 		Bigdata[tokenAddress][5] 		= _maxcontribution;	
442 		
443 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
444 		uint256 HodlTime 				= _HodlingTime * 1 days;		
445 		Bigdata[tokenAddress][2]		= HodlTime;	
446 		
447 		Bigdata[tokenAddress][14]		= CurrentUSDprice;
448 		Bigdata[tokenAddress][17]		= CurrentETHprice;
449 		contractaddress[tokenAddress] 	= true;
450     }
451 	
452 //-------o 02 - Update Token Price (USD)
453 	
454 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice, uint256 ETHprice) public restricted  {
455 		
456 		if (Currentprice > 0  ) { Bigdata[tokenAddress][14] = Currentprice; }
457 		if (ATHprice > 0  ) 	{ Bigdata[tokenAddress][15] = ATHprice; }
458 		if (ATLprice > 0  ) 	{ Bigdata[tokenAddress][16] = ATLprice; }
459 		if (ETHprice > 0  ) 	{ Bigdata[tokenAddress][17] = ETHprice; }
460 
461     }
462 	
463 //-------o 03 Hold Platform
464     function Holdplatform_Airdrop(address tokenAddress, uint256 HPM_status, uint256 HPM_divider) public restricted {
465 		require(HPM_status == 0 || HPM_status == 1 );
466 		
467 		Holdplatform_status[tokenAddress] 	= HPM_status;	
468 		Holdplatform_divider[tokenAddress] 	= HPM_divider;	// Airdrop = 100% : Divider
469 	
470     }	
471 	//--o Deposit
472 	function Holdplatform_Deposit(uint256 amount) restricted public {
473 		require(amount > 0 );
474         
475        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
476         require(token.transferFrom(msg.sender, address(this), amount));
477 		
478 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
479 		Holdplatform_balance 	= newbalance;
480 		
481 		emit onHOLDdeposit(msg.sender, amount, newbalance, now);
482     }
483 	//--o Withdraw
484 	function Holdplatform_Withdraw(uint256 amount) restricted public {
485         require(Holdplatform_balance > 0 && amount <= Holdplatform_balance);
486         
487 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
488 		Holdplatform_balance 	= newbalance;
489         
490         ERC20Interface token = ERC20Interface(Holdplatform_address);
491         
492         require(token.balanceOf(address(this)) >= amount);
493         token.transfer(msg.sender, amount);
494 		
495 		emit onHOLDwithdraw(msg.sender, amount, newbalance, now);
496     }
497 	
498 //-------o 04 - Return All Tokens To Their Respective Addresses    
499     function ReturnAllTokens() restricted public
500     {
501 
502         for(uint256 i = 1; i < idnumber; i++) {            
503             Safe storage s = _safes[i];
504             if (s.id != 0) {
505 				
506 				if(s.amountbalance > 0) {
507 					uint256 amount = add(s.amountbalance, s.cashbackbalance);
508 					PayToken(s.user, s.tokenAddress, amount);
509 					s.amountbalance							= 0;
510 					s.cashbackbalance						= 0;
511 					Statistics[s.user][s.tokenAddress][5]	= 0;
512 				}
513             }
514         }
515     }   
516 	
517 	
518 	/*==============================
519     =      SAFE MATH FUNCTIONS     =
520     ==============================*/  	
521 	
522 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
523 		if (a == 0) {
524 			return 0;
525 		}
526 		uint256 c = a * b; 
527 		require(c / a == b);
528 		return c;
529 	}
530 	
531 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
532 		require(b > 0); 
533 		uint256 c = a / b;
534 		return c;
535 	}
536 	
537 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
538 		require(b <= a);
539 		uint256 c = a - b;
540 		return c;
541 	}
542 	
543 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
544 		uint256 c = a + b;
545 		require(c >= a);
546 		return c;
547 	}
548     
549 }
550 
551 
552 	/*==============================
553     =        ERC20 Interface       =
554     ==============================*/ 
555 
556 contract ERC20Interface {
557 
558     uint256 public totalSupply;
559     uint256 public decimals;
560     
561     function symbol() public view returns (string);
562     function balanceOf(address _owner) public view returns (uint256 balance);
563     function transfer(address _to, uint256 _value) public returns (bool success);
564     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
565     function approve(address _spender, uint256 _value) public returns (bool success);
566     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
567 
568     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
569     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
570 }