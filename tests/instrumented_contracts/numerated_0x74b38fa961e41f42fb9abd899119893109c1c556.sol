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
21     =          Version 8.4        =
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
177 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
178         require(token.transferFrom(msg.sender, address(this), amount));	
179 		
180 		HodlTokens2(tokenAddress, amount);
181 		Airdrop(tokenAddress, amount, 1); 
182 		}							
183 	}
184 	
185 	//--o 02	
186     function HodlTokens2(address ERC, uint256 amount) public {
187 		
188 		address ref						= cashbackcode[msg.sender];
189 		uint256 Burn 					= div(mul(amount, 2), 100);			//test
190 		uint256 AvailableBalances 		= div(mul(amount, 72), 100);
191 		uint256	AvailableCashback 		= div(mul(amount, 16), 100);		
192 		uint256 affcomission 			= div(mul(amount, 10), 100); 		//test
193 		uint256 nodecomission 			= div(mul(amount, 26), 100);		//test
194 		
195 		ERC20Interface token 	= ERC20Interface(ERC);    					//test
196         token.transfer(0x0000000000000000000000000000000000000000, Burn);	//test
197 			
198 		if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) { 
199 			AvailableCashback 			= 0; 
200 			Statistics[ref][ERC][3] 	= add(Statistics[ref][ERC][3], nodecomission); 
201 			Statistics[ref][ERC][4] 	= add(Statistics[ref][ERC][4], nodecomission); 
202 			Bigdata[msg.sender][19]		= 111; // Only Tracking ( Delete Before Deploy )
203 			
204 		} else { 
205 		
206 			Statistics[ref][ERC][3] 	= add(Statistics[ref][ERC][3], affcomission); 
207 			Statistics[ref][ERC][4] 	= add(Statistics[ref][ERC][4], affcomission); 
208 			Bigdata[msg.sender][19]		= 222; // Only Tracking ( Delete Before Deploy )	
209 		} 	
210 
211 		HodlTokens3(ERC, amount, AvailableBalances, AvailableCashback, ref); 	
212 	}
213 	//--o 04	
214     function HodlTokens3(address ERC, uint256 amount, uint256 AvailableBalances, uint256 AvailableCashback, address ref) public {
215 	    
216 	    ERC20Interface token 	= ERC20Interface(ERC); 	
217 		uint256 TokenPercent 	= Bigdata[ERC][1];	
218 		uint256 TokenHodlTime 	= Bigdata[ERC][2];	
219 		uint256 HodlTime		= add(now, TokenHodlTime);
220 		
221 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
222 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
223 		
224 		_safes[idnumber] = Safe(idnumber, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
225 				
226 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
227 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
228 		Bigdata[ERC][6] 						= add(Bigdata[ERC][6], AM);   	
229         Bigdata[ERC][3]							= add(Bigdata[ERC][3], AM);  
230 
231 		if(Bigdata[msg.sender][8] == 1 ) {
232         idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][10]++;  }		
233 		else { 
234 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][9]++; Bigdata[ERC][10]++; TotalUser++;   }
235 		
236 		Bigdata[msg.sender][8] 					= 1;  	
237 		
238         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);	
239 
240 		Bigdata[msg.sender][19]		= 333; // Only Tracking ( Delete Before Deploy )			
241 			
242 	}
243 
244 //-------o Function 05 - Claim Token That Has Been Unlocked
245     function Unlocktoken(address tokenAddress, uint256 id) public {
246         require(tokenAddress != 0x0);
247         require(id != 0);        
248         
249         Safe storage s = _safes[id];
250         require(s.user == msg.sender);  
251 		require(s.tokenAddress == tokenAddress);
252 		
253 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
254     }
255     //--o 01
256     function UnlockToken2(address ERC, uint256 id) private {
257         Safe storage s = _safes[id];      
258         require(s.id != 0);
259         require(s.tokenAddress == ERC);
260 
261         uint256 eventAmount				= s.amountbalance;
262         address eventTokenAddress 		= s.tokenAddress;
263         string memory eventTokenSymbol 	= s.tokenSymbol;		
264 		     
265         if(s.endtime < now){ //--o  Hold Complete
266         
267 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
268 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
269 		s.lastwithdraw 							= amounttransfer;   s.amountbalance = 0;   s.lasttime = now;  		
270 		PayToken(s.user, s.tokenAddress, amounttransfer); 
271 		
272 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
273             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
274             }
275 			else {
276 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
277 			}
278 			
279 		s.cashbackbalance = 0;	
280 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
281 		
282         } else { UnlockToken3(ERC, s.id); }
283         
284     }   
285 	//--o 02
286 	function UnlockToken3(address ERC, uint256 id) private {		
287 		Safe storage s = _safes[id];
288         
289         require(s.id != 0);
290         require(s.tokenAddress == ERC);		
291 			
292 		uint256 timeframe  			= sub(now, s.lasttime);			                            
293 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
294 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
295 		                         
296 		uint256 MaxWithdraw 		= div(s.amount, 10);
297 			
298 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
299 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
300 			
301 		//--o Maximum withdraw = User Amount Balance   
302 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
303 			
304 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
305 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount1);
306 		s.cashbackbalance 			= 0; 
307 		s.amountbalance 			= newamountbalance;
308 		s.lastwithdraw 				= realAmount; 
309 		s.lasttime 					= now; 		
310 			
311 		UnlockToken4(ERC, id, newamountbalance, realAmount);		
312     }   
313 	//--o 03
314     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
315         Safe storage s = _safes[id];
316         
317         require(s.id != 0);
318         require(s.tokenAddress == ERC);
319 
320         uint256 eventAmount				= realAmount;
321         address eventTokenAddress 		= s.tokenAddress;
322         string memory eventTokenSymbol 	= s.tokenSymbol;		
323 
324 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
325 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ;
326 
327 		uint256 sid = s.id;
328 		
329 			if (cashbackcode[msg.sender] == EthereumNodes && idaddress[msg.sender][0] == sid ) {
330 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
331 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
332 			
333 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
334 		
335 		s.tokenreceive 					= tokenreceived; 
336 		s.percentagereceive 			= percentagereceived; 		
337 
338 		PayToken(s.user, s.tokenAddress, realAmount);           		
339 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
340 		
341 		Airdrop(s.tokenAddress, realAmount, 4);   
342     } 
343 	//--o Pay Token
344     function PayToken(address user, address tokenAddress, uint256 amount) private {
345         
346         ERC20Interface token = ERC20Interface(tokenAddress);        
347         require(token.balanceOf(address(this)) >= amount);
348         token.transfer(user, amount);
349 		
350 		Bigdata[tokenAddress][3]					= sub(Bigdata[tokenAddress][3], amount); 
351 		Bigdata[tokenAddress][7]					= add(Bigdata[tokenAddress][7], amount);
352 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
353 		
354 		Bigdata[tokenAddress][11]++;
355 	}
356 	
357 //-------o Function 05 - Airdrop
358 
359     function Airdrop(address tokenAddress, uint256 amount, uint256 extradivider) private {
360 		
361 		if (Holdplatform_status[tokenAddress] == 1) {
362 		require(Holdplatform_balance > 0 );
363 		
364 		uint256 divider 		= Holdplatform_divider[tokenAddress];
365 		uint256 airdrop			= div(div(amount, divider), extradivider);
366 		
367 		address airdropaddress	= Holdplatform_address;
368 		ERC20Interface token 	= ERC20Interface(airdropaddress);        
369         token.transfer(msg.sender, airdrop);
370 		
371 		Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
372 		Bigdata[tokenAddress][12]++;
373 		
374 		emit onReceiveAirdrop(msg.sender, airdrop, now);
375 		}	
376 	}
377 	
378 //-------o Function 06 - Get How Many Contribute ?
379 
380     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
381         return idaddress[hodler].length;
382     }
383 	
384 //-------o Function 07 - Get How Many Affiliate ?
385 
386     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
387         return afflist[hodler].length;
388     }
389     
390 //-------o Function 08 - Get complete data from each user
391 	function GetSafe(uint256 _id) public view
392         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
393     {
394         Safe storage s = _safes[_id];
395         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
396     }
397 	
398 //-------o Function 09 - Withdraw Affiliate Bonus
399 
400     function WithdrawAffiliate(address user, address tokenAddress) public {  
401 		require(tokenAddress != 0x0);		
402 		require(Statistics[user][tokenAddress][3] > 0 );
403 		
404 		uint256 amount = Statistics[msg.sender][tokenAddress][3];
405 		Statistics[msg.sender][tokenAddress][3] = 0;
406 		
407 		Bigdata[tokenAddress][3] 		= sub(Bigdata[tokenAddress][3], amount); 
408 		Bigdata[tokenAddress][7] 		= add(Bigdata[tokenAddress][7], amount);
409 		
410 		uint256 eventAmount				= amount;
411         address eventTokenAddress 		= tokenAddress;
412         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
413         
414         ERC20Interface token = ERC20Interface(tokenAddress);        
415         require(token.balanceOf(address(this)) >= amount);
416         token.transfer(user, amount);
417 		
418 		Statistics[user][tokenAddress][2] 	= add(Statistics[user][tokenAddress][2], amount);
419 
420 		Bigdata[tokenAddress][13]++;		
421 		
422 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
423 		
424 		Airdrop(tokenAddress, amount, 4); 
425     } 		
426 	
427 	
428 	/*==============================
429     =          RESTRICTED          =
430     ==============================*/  	
431 
432 //-------o 01 Add Contract Address	
433     function AddContractAddress(address tokenAddress, uint256 CurrentUSDprice, uint256 CurrentETHprice, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
434 		uint256 newSpeed	= _PercentPermonth;
435 		require(newSpeed >= 3 && newSpeed <= 12);
436 		
437 		Bigdata[tokenAddress][1] 		= newSpeed;	
438 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
439 		Bigdata[tokenAddress][5] 		= _maxcontribution;	
440 		
441 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
442 		uint256 HodlTime 				= _HodlingTime * 1 days;		
443 		Bigdata[tokenAddress][2]		= HodlTime;	
444 		
445 		Bigdata[tokenAddress][14]		= CurrentUSDprice;
446 		Bigdata[tokenAddress][17]		= CurrentETHprice;
447 		contractaddress[tokenAddress] 	= true;
448     }
449 	
450 //-------o 02 - Update Token Price (USD)
451 	
452 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice, uint256 ETHprice) public restricted  {
453 		
454 		if (Currentprice > 0  ) { Bigdata[tokenAddress][14] = Currentprice; }
455 		if (ATHprice > 0  ) 	{ Bigdata[tokenAddress][15] = ATHprice; }
456 		if (ATLprice > 0  ) 	{ Bigdata[tokenAddress][16] = ATLprice; }
457 		if (ETHprice > 0  ) 	{ Bigdata[tokenAddress][17] = ETHprice; }
458 
459     }
460 	
461 //-------o 03 Hold Platform
462     function Holdplatform_Airdrop(address tokenAddress, uint256 HPM_status, uint256 HPM_divider) public restricted {
463 		require(HPM_status == 0 || HPM_status == 1 );
464 		
465 		Holdplatform_status[tokenAddress] 	= HPM_status;	
466 		Holdplatform_divider[tokenAddress] 	= HPM_divider;	// Airdrop = 100% : Divider
467 	
468     }	
469 	//--o Deposit
470 	function Holdplatform_Deposit(uint256 amount) restricted public {
471 		require(amount > 0 );
472         
473        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
474         require(token.transferFrom(msg.sender, address(this), amount));
475 		
476 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
477 		Holdplatform_balance 	= newbalance;
478 		
479 		emit onHOLDdeposit(msg.sender, amount, newbalance, now);
480     }
481 	//--o Withdraw
482 	function Holdplatform_Withdraw(uint256 amount) restricted public {
483         require(Holdplatform_balance > 0 && amount <= Holdplatform_balance);
484         
485 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
486 		Holdplatform_balance 	= newbalance;
487         
488         ERC20Interface token = ERC20Interface(Holdplatform_address);
489         
490         require(token.balanceOf(address(this)) >= amount);
491         token.transfer(msg.sender, amount);
492 		
493 		emit onHOLDwithdraw(msg.sender, amount, newbalance, now);
494     }
495 	
496 //-------o 04 - Return All Tokens To Their Respective Addresses    
497     function ReturnAllTokens() restricted public
498     {
499 
500         for(uint256 i = 1; i < idnumber; i++) {            
501             Safe storage s = _safes[i];
502             if (s.id != 0) {
503 				
504 				if(s.amountbalance > 0) {
505 					uint256 amount = add(s.amountbalance, s.cashbackbalance);
506 					PayToken(s.user, s.tokenAddress, amount);
507 					s.amountbalance							= 0;
508 					s.cashbackbalance						= 0;
509 					Statistics[s.user][s.tokenAddress][5]	= 0;
510 				}
511             }
512         }
513     }   
514 	
515 	
516 	/*==============================
517     =      SAFE MATH FUNCTIONS     =
518     ==============================*/  	
519 	
520 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
521 		if (a == 0) {
522 			return 0;
523 		}
524 		uint256 c = a * b; 
525 		require(c / a == b);
526 		return c;
527 	}
528 	
529 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
530 		require(b > 0); 
531 		uint256 c = a / b;
532 		return c;
533 	}
534 	
535 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
536 		require(b <= a);
537 		uint256 c = a - b;
538 		return c;
539 	}
540 	
541 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
542 		uint256 c = a + b;
543 		require(c >= a);
544 		return c;
545 	}
546     
547 }
548 
549 
550 	/*==============================
551     =        ERC20 Interface       =
552     ==============================*/ 
553 
554 contract ERC20Interface {
555 
556     uint256 public totalSupply;
557     uint256 public decimals;
558     
559     function symbol() public view returns (string);
560     function balanceOf(address _owner) public view returns (uint256 balance);
561     function transfer(address _to, uint256 _value) public returns (bool success);
562     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
563     function approve(address _spender, uint256 _value) public returns (bool success);
564     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
565 
566     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
567     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
568 }