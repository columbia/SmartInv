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
21     =          Version 8.1        =
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
107 	mapping(address => uint256) private Holdplatform_status;	// [03]
108 	mapping(address => uint256) private Holdplatform_divider; 	// [04]
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
150 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 
151 		&& Bigdata[_cashbackcode][8] >= 1 && Bigdata[_cashbackcode][18] != uniquecode ) { 
152 		
153 		cashbackcode[msg.sender] = _cashbackcode; }
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
171 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
172 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
173         require(token.transferFrom(msg.sender, address(this), amount));	
174 		
175 		HodlTokens2(tokenAddress, amount);
176 		Airdrop(tokenAddress, amount, 1); 
177 		}							
178 	}
179 	
180 	//--o 02	
181     function HodlTokens2(address ERC, uint256 amount) private {
182 		
183 		uint256 AvailableBalances 					= div(mul(amount, 72), 100);	
184 		
185 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 ) { //--o  Hold without cashback code
186 		
187 			address ref								= EthereumNodes;
188 			cashbackcode[msg.sender] 				= EthereumNodes;
189 			uint256 AvailableCashback 				= 0; 			
190 			uint256 zerocashback 					= div(mul(amount, 28), 100); 
191 			Statistics[EthereumNodes][ERC][3] 		= add(Statistics[EthereumNodes][ERC][3], zerocashback);
192 			Statistics[EthereumNodes][ERC][4]		= add(Statistics[EthereumNodes][ERC][4], zerocashback); 
193 			Bigdata[msg.sender][18]					= 123456;			
194 			
195 		} else { 	//--o  Cashback code has been activated
196 		
197 			ref										= cashbackcode[msg.sender];
198 			uint256 amount2							= Statistics[ref][ERC][5];	 	
199 			AvailableCashback 						= div(mul(amount, 16), 100);			
200 
201 			uint256 affcomission_1 	= div(mul(amount, 12), 100);
202 			uint256 affcomission_2 	= div(mul(amount2, 12), 100);
203 			
204 			if (Statistics[ref][ERC][5] >= add(Statistics[msg.sender][ERC][5], amount)) { //--o  if referrer contribution >= My contribution
205 								
206 				Statistics[ref][ERC][3] = add(Statistics[ref][ERC][3], affcomission_1); 
207 				Statistics[ref][ERC][4] = add(Statistics[ref][ERC][4], affcomission_1); 	
208 			} 
209 			
210 			if (Statistics[ref][ERC][5] < add(Statistics[msg.sender][ERC][5], amount)) { //--o  if referrer contribution < My contribution
211 			
212 				Statistics[ref][ERC][3] = add(Statistics[ref][ERC][3], affcomission_2); 
213 				Statistics[ref][ERC][4] = add(Statistics[ref][ERC][4], affcomission_2); 
214 				
215 				uint256 NodeFunds 					= sub(affcomission_1, affcomission_2);	
216 				Statistics[EthereumNodes][ERC][3] 	= add(Statistics[EthereumNodes][ERC][3], NodeFunds);
217 				Statistics[EthereumNodes][ERC][4] 	= add(Statistics[EthereumNodes][ERC][4], NodeFunds); 				
218 			}
219 
220 		} 
221 
222 		HodlTokens3(ERC, amount, AvailableBalances, AvailableCashback, ref); 	
223 	}
224 	//--o 04	
225     function HodlTokens3(address ERC, uint256 amount, uint256 AvailableBalances, uint256 AvailableCashback, address ref) private {
226 	    
227 	    ERC20Interface token 	= ERC20Interface(ERC); 	
228 		uint256 TokenPercent 	= Bigdata[ERC][1];	
229 		uint256 TokenHodlTime 	= Bigdata[ERC][2];	
230 		uint256 HodlTime		= add(now, TokenHodlTime);
231 		
232 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
233 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
234 		
235 		_safes[idnumber] = Safe(idnumber, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
236 				
237 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
238 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
239 		Bigdata[ERC][6] 						= add(Bigdata[ERC][6], AM);   	
240         Bigdata[ERC][3]							= add(Bigdata[ERC][3], AM);  
241 
242 		if(Bigdata[msg.sender][8] == 1 ) {
243         idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][10]++;  }		
244 		else { 
245 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][9]++; Bigdata[ERC][10]++; TotalUser++;   }
246 		
247 		Bigdata[msg.sender][8] 					= 1;  	
248 		
249         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);		
250 			
251 	}
252 
253 //-------o Function 05 - Claim Token That Has Been Unlocked
254     function Unlocktoken(address tokenAddress, uint256 id) public {
255         require(tokenAddress != 0x0);
256         require(id != 0);        
257         
258         Safe storage s = _safes[id];
259         require(s.user == msg.sender);  
260 		require(s.tokenAddress == tokenAddress);
261 		
262 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
263     }
264     //--o 01
265     function UnlockToken2(address ERC, uint256 id) private {
266         Safe storage s = _safes[id];      
267         require(s.id != 0);
268         require(s.tokenAddress == ERC);
269 
270         uint256 eventAmount				= s.amountbalance;
271         address eventTokenAddress 		= s.tokenAddress;
272         string memory eventTokenSymbol 	= s.tokenSymbol;		
273 		     
274         if(s.endtime < now){ //--o  Hold Complete
275         
276 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
277 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
278 		s.lastwithdraw 							= amounttransfer;   s.amountbalance = 0;   s.lasttime = now;  		
279 		PayToken(s.user, s.tokenAddress, amounttransfer); 
280 		
281 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
282             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
283             }
284 			else {
285 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
286 			}
287 			
288 		s.cashbackbalance = 0;	
289 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
290 		
291         } else { UnlockToken3(ERC, s.id); }
292         
293     }   
294 	//--o 02
295 	function UnlockToken3(address ERC, uint256 id) private {		
296 		Safe storage s = _safes[id];
297         
298         require(s.id != 0);
299         require(s.tokenAddress == ERC);		
300 			
301 		uint256 timeframe  			= sub(now, s.lasttime);			                            
302 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
303 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
304 		                         
305 		uint256 MaxWithdraw 		= div(s.amount, 10);
306 			
307 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
308 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
309 			
310 		//--o Maximum withdraw = User Amount Balance   
311 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
312 			
313 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
314 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount1);
315 		s.cashbackbalance 			= 0; 
316 		s.amountbalance 			= newamountbalance;
317 		s.lastwithdraw 				= realAmount; 
318 		s.lasttime 					= now; 		
319 			
320 		UnlockToken4(ERC, id, newamountbalance, realAmount);		
321     }   
322 	//--o 03
323     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
324         Safe storage s = _safes[id];
325         
326         require(s.id != 0);
327         require(s.tokenAddress == ERC);
328 
329         uint256 eventAmount				= realAmount;
330         address eventTokenAddress 		= s.tokenAddress;
331         string memory eventTokenSymbol 	= s.tokenSymbol;		
332 
333 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
334 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ;
335 
336 		uint256 sid = s.id;
337 		
338 			if (cashbackcode[msg.sender] == EthereumNodes && idaddress[msg.sender][0] == sid ) {
339 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
340 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
341 			
342 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
343 		
344 		s.tokenreceive 					= tokenreceived; 
345 		s.percentagereceive 			= percentagereceived; 		
346 
347 		PayToken(s.user, s.tokenAddress, realAmount);           		
348 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
349 		
350 		Airdrop(s.tokenAddress, realAmount, 4);   
351     } 
352 	//--o Pay Token
353     function PayToken(address user, address tokenAddress, uint256 amount) private {
354         
355         ERC20Interface token = ERC20Interface(tokenAddress);        
356         require(token.balanceOf(address(this)) >= amount);
357         token.transfer(user, amount);
358 		
359 		Bigdata[tokenAddress][3]					= sub(Bigdata[tokenAddress][3], amount); 
360 		Bigdata[tokenAddress][7]					= add(Bigdata[tokenAddress][7], amount);
361 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
362 		
363 		Bigdata[tokenAddress][11]++;
364 	}
365 	
366 //-------o Function 05 - Airdrop
367 
368     function Airdrop(address tokenAddress, uint256 amount, uint256 extradivider) private {
369 		
370 		if (Holdplatform_status[tokenAddress] == 1) {
371 		require(Holdplatform_balance > 0 );
372 		
373 		uint256 divider 		= Holdplatform_divider[tokenAddress];
374 		uint256 airdrop			= div(div(amount, divider), extradivider);
375 		
376 		address airdropaddress	= Holdplatform_address;
377 		ERC20Interface token 	= ERC20Interface(airdropaddress);        
378         token.transfer(msg.sender, airdrop);
379 		
380 		Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
381 		Bigdata[tokenAddress][12]++;
382 		
383 		emit onReceiveAirdrop(msg.sender, airdrop, now);
384 		}	
385 	}
386 	
387 //-------o Function 06 - Get How Many Contribute ?
388 
389     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
390         return idaddress[hodler].length;
391     }
392 	
393 //-------o Function 07 - Get How Many Affiliate ?
394 
395     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
396         return afflist[hodler].length;
397     }
398     
399 //-------o Function 08 - Get complete data from each user
400 	function GetSafe(uint256 _id) public view
401         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
402     {
403         Safe storage s = _safes[_id];
404         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
405     }
406 	
407 //-------o Function 09 - Withdraw Affiliate Bonus
408 
409     function WithdrawAffiliate(address user, address tokenAddress) public {  
410 		require(tokenAddress != 0x0);		
411 		require(Statistics[user][tokenAddress][3] > 0 );
412 		
413 		uint256 amount = Statistics[msg.sender][tokenAddress][3];
414 		Statistics[msg.sender][tokenAddress][3] = 0;
415 		
416 		Bigdata[tokenAddress][3] 		= sub(Bigdata[tokenAddress][3], amount); 
417 		Bigdata[tokenAddress][7] 		= add(Bigdata[tokenAddress][7], amount);
418 		
419 		uint256 eventAmount				= amount;
420         address eventTokenAddress 		= tokenAddress;
421         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
422         
423         ERC20Interface token = ERC20Interface(tokenAddress);        
424         require(token.balanceOf(address(this)) >= amount);
425         token.transfer(user, amount);
426 		
427 		Statistics[user][tokenAddress][2] 	= add(Statistics[user][tokenAddress][2], amount);
428 
429 		Bigdata[tokenAddress][13]++;		
430 		
431 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
432 		
433 		Airdrop(tokenAddress, amount, 4); 
434     } 		
435 	
436 	
437 	/*==============================
438     =          RESTRICTED          =
439     ==============================*/  	
440 
441 //-------o 01 Add Contract Address	
442     function AddContractAddress(address tokenAddress, uint256 CurrentUSDprice, uint256 CurrentETHprice, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
443 		uint256 newSpeed	= _PercentPermonth;
444 		require(newSpeed >= 3 && newSpeed <= 12);
445 		
446 		Bigdata[tokenAddress][1] 		= newSpeed;	
447 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
448 		Bigdata[tokenAddress][5] 		= _maxcontribution;	
449 		
450 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
451 		uint256 HodlTime 				= _HodlingTime * 1 days;		
452 		Bigdata[tokenAddress][2]		= HodlTime;	
453 		
454 		Bigdata[tokenAddress][14]		= CurrentUSDprice;
455 		Bigdata[tokenAddress][17]		= CurrentETHprice;
456 		contractaddress[tokenAddress] 	= true;
457     }
458 	
459 //-------o 02 - Update Token Price (USD)
460 	
461 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice, uint256 ETHprice) public restricted  {
462 		
463 		if (Currentprice > 0  ) { Bigdata[tokenAddress][14] = Currentprice; }
464 		if (ATHprice > 0  ) 	{ Bigdata[tokenAddress][15] = ATHprice; }
465 		if (ATLprice > 0  ) 	{ Bigdata[tokenAddress][16] = ATLprice; }
466 		if (ETHprice > 0  ) 	{ Bigdata[tokenAddress][17] = ETHprice; }
467 
468     }
469 	
470 //-------o 03 Hold Platform
471     function Holdplatform_Airdrop(address tokenAddress, uint256 HPM_status, uint256 HPM_divider) public restricted {
472 		require(HPM_status == 0 || HPM_status == 1 );
473 		
474 		Holdplatform_status[tokenAddress] 	= HPM_status;	
475 		Holdplatform_divider[tokenAddress] 	= HPM_divider;	// Airdrop = 100% : Divider
476 	
477     }	
478 	//--o Deposit
479 	function Holdplatform_Deposit(uint256 amount) restricted public {
480 		require(amount > 0 );
481         
482        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
483         require(token.transferFrom(msg.sender, address(this), amount));
484 		
485 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
486 		Holdplatform_balance 	= newbalance;
487 		
488 		emit onHOLDdeposit(msg.sender, amount, newbalance, now);
489     }
490 	//--o Withdraw
491 	function Holdplatform_Withdraw(uint256 amount) restricted public {
492         require(Holdplatform_balance > 0 && amount <= Holdplatform_balance);
493         
494 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
495 		Holdplatform_balance 	= newbalance;
496         
497         ERC20Interface token = ERC20Interface(Holdplatform_address);
498         
499         require(token.balanceOf(address(this)) >= amount);
500         token.transfer(msg.sender, amount);
501 		
502 		emit onHOLDwithdraw(msg.sender, amount, newbalance, now);
503     }
504 	
505 //-------o 04 - Return All Tokens To Their Respective Addresses    
506     function ReturnAllTokens() restricted public
507     {
508 
509         for(uint256 i = 1; i < idnumber; i++) {            
510             Safe storage s = _safes[i];
511             if (s.id != 0) {
512 				
513 				if(s.amountbalance > 0) {
514 					uint256 amount = add(s.amountbalance, s.cashbackbalance);
515 					PayToken(s.user, s.tokenAddress, amount);
516 					s.amountbalance							= 0;
517 					s.cashbackbalance						= 0;
518 					Statistics[s.user][s.tokenAddress][5]	= 0;
519 				}
520             }
521         }
522     }   
523 	
524 	
525 	/*==============================
526     =      SAFE MATH FUNCTIONS     =
527     ==============================*/  	
528 	
529 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
530 		if (a == 0) {
531 			return 0;
532 		}
533 		uint256 c = a * b; 
534 		require(c / a == b);
535 		return c;
536 	}
537 	
538 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
539 		require(b > 0); 
540 		uint256 c = a / b;
541 		return c;
542 	}
543 	
544 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
545 		require(b <= a);
546 		uint256 c = a - b;
547 		return c;
548 	}
549 	
550 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
551 		uint256 c = a + b;
552 		require(c >= a);
553 		return c;
554 	}
555     
556 }
557 
558 
559 	/*==============================
560     =        ERC20 Interface       =
561     ==============================*/ 
562 
563 contract ERC20Interface {
564 
565     uint256 public totalSupply;
566     uint256 public decimals;
567     
568     function symbol() public view returns (string);
569     function balanceOf(address _owner) public view returns (uint256 balance);
570     function transfer(address _to, uint256 _value) public returns (bool success);
571     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
572     function approve(address _spender, uint256 _value) public returns (bool success);
573     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
574 
575     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
576     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
577 }