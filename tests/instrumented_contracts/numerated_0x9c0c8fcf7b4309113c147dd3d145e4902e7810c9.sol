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
21     =          Version 8.6        =
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
189 		uint256 AvailableBalances 		= div(mul(amount, 72), 100);
190 		uint256	AvailableCashback 		= div(mul(amount, 16), 100);		
191 		uint256 affcomission 			= div(mul(amount, 12), 100); 		
192 		uint256 nodecomission 			= div(mul(amount, 28), 100);	
193 			
194 		if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) { 
195 			AvailableCashback 			= 0; 
196 			Statistics[ref][ERC][3] 	= add(Statistics[ref][ERC][3], nodecomission); 
197 			Statistics[ref][ERC][4] 	= add(Statistics[ref][ERC][4], nodecomission); 
198 			Bigdata[msg.sender][19]		= 111; // Only Tracking ( Delete Before Deploy )
199 			
200 		} else { 
201 		
202 			Statistics[ref][ERC][3] 	= add(Statistics[ref][ERC][3], affcomission); 
203 			Statistics[ref][ERC][4] 	= add(Statistics[ref][ERC][4], affcomission); 
204 			Bigdata[msg.sender][19]		= 222; // Only Tracking ( Delete Before Deploy )	
205 		} 	
206 
207 		HodlTokens3(ERC, amount, AvailableBalances, AvailableCashback, ref); 	
208 	}
209 	//--o 04	
210     function HodlTokens3(address ERC, uint256 amount, uint256 AvailableBalances, uint256 AvailableCashback, address ref) public {
211 	    
212 	    ERC20Interface token 	= ERC20Interface(ERC); 	
213 		uint256 TokenPercent 	= Bigdata[ERC][1];	
214 		uint256 TokenHodlTime 	= Bigdata[ERC][2];	
215 		uint256 HodlTime		= add(now, TokenHodlTime);
216 		
217 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
218 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
219 		
220 		_safes[idnumber] = Safe(idnumber, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
221 				
222 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
223 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
224 		Bigdata[ERC][6] 						= add(Bigdata[ERC][6], AM);   	
225         Bigdata[ERC][3]							= add(Bigdata[ERC][3], AM);  
226 
227 		if(Bigdata[msg.sender][8] == 1 ) {
228         idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][10]++;  }		
229 		else { 
230 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][9]++; Bigdata[ERC][10]++; TotalUser++;   }
231 		
232 		Bigdata[msg.sender][8] 					= 1;  	
233 		
234         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);	
235 
236 		Bigdata[msg.sender][19]		= 333; // Only Tracking ( Delete Before Deploy )			
237 			
238 	}
239 
240 //-------o Function 05 - Claim Token That Has Been Unlocked
241     function Unlocktoken(address tokenAddress, uint256 id) public {
242         require(tokenAddress != 0x0);
243         require(id != 0);        
244         
245         Safe storage s = _safes[id];
246         require(s.user == msg.sender);  
247 		require(s.tokenAddress == tokenAddress);
248 		
249 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
250     }
251     //--o 01
252     function UnlockToken2(address ERC, uint256 id) private {
253         Safe storage s = _safes[id];      
254         require(s.id != 0);
255         require(s.tokenAddress == ERC);
256 
257         uint256 eventAmount				= s.amountbalance;
258         address eventTokenAddress 		= s.tokenAddress;
259         string memory eventTokenSymbol 	= s.tokenSymbol;		
260 		     
261         if(s.endtime < now){ //--o  Hold Complete
262         
263 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
264 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
265 		s.lastwithdraw 							= amounttransfer;   s.amountbalance = 0;   s.lasttime = now;  		
266 		PayToken(s.user, s.tokenAddress, amounttransfer); 
267 		
268 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
269             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
270             }
271 			else {
272 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
273 			}
274 			
275 		s.cashbackbalance = 0;	
276 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
277 		
278         } else { UnlockToken3(ERC, s.id); }
279         
280     }   
281 	//--o 02
282 	function UnlockToken3(address ERC, uint256 id) private {		
283 		Safe storage s = _safes[id];
284         
285         require(s.id != 0);
286         require(s.tokenAddress == ERC);		
287 			
288 		uint256 timeframe  			= sub(now, s.lasttime);			                            
289 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
290 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
291 		                         
292 		uint256 MaxWithdraw 		= div(s.amount, 10);
293 			
294 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
295 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
296 			
297 		//--o Maximum withdraw = User Amount Balance   
298 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
299 			
300 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
301 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount1);
302 		s.cashbackbalance 			= 0; 
303 		s.amountbalance 			= newamountbalance;
304 		s.lastwithdraw 				= realAmount; 
305 		s.lasttime 					= now; 		
306 			
307 		UnlockToken4(ERC, id, newamountbalance, realAmount);		
308     }   
309 	//--o 03
310     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
311         Safe storage s = _safes[id];
312         
313         require(s.id != 0);
314         require(s.tokenAddress == ERC);
315 
316         uint256 eventAmount				= realAmount;
317         address eventTokenAddress 		= s.tokenAddress;
318         string memory eventTokenSymbol 	= s.tokenSymbol;		
319 
320 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
321 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ;
322 
323 		uint256 sid = s.id;
324 		
325 			if (cashbackcode[msg.sender] == EthereumNodes && idaddress[msg.sender][0] == sid ) {
326 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
327 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
328 			
329 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
330 		
331 		s.tokenreceive 					= tokenreceived; 
332 		s.percentagereceive 			= percentagereceived; 		
333 
334 		PayToken(s.user, s.tokenAddress, realAmount);           		
335 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
336 		
337 		Airdrop(s.tokenAddress, realAmount, 4);   
338     } 
339 	//--o Pay Token
340     function PayToken(address user, address tokenAddress, uint256 amount) private {
341         
342         ERC20Interface token = ERC20Interface(tokenAddress);        
343         require(token.balanceOf(address(this)) >= amount);
344         token.transfer(user, amount);
345 		
346 		Bigdata[tokenAddress][3]					= sub(Bigdata[tokenAddress][3], amount); 
347 		Bigdata[tokenAddress][7]					= add(Bigdata[tokenAddress][7], amount);
348 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
349 		
350 		Bigdata[tokenAddress][11]++;
351 	}
352 	
353 //-------o Function 05 - Airdrop
354 
355     function Airdrop(address tokenAddress, uint256 amount, uint256 extradivider) private {
356 		
357 		if (Holdplatform_status[tokenAddress] == 1) {
358 		require(Holdplatform_balance > 0 );
359 		
360 		uint256 divider 		= Holdplatform_divider[tokenAddress];
361 		uint256 airdrop			= div(div(amount, divider), extradivider);
362 		
363 		address airdropaddress	= Holdplatform_address;
364 		ERC20Interface token 	= ERC20Interface(airdropaddress);        
365         token.transfer(msg.sender, airdrop);
366 		
367 		Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
368 		Bigdata[tokenAddress][12]++;
369 		
370 		emit onReceiveAirdrop(msg.sender, airdrop, now);
371 		}	
372 	}
373 	
374 //-------o Function 06 - Get How Many Contribute ?
375 
376     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
377         return idaddress[hodler].length;
378     }
379 	
380 //-------o Function 07 - Get How Many Affiliate ?
381 
382     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
383         return afflist[hodler].length;
384     }
385     
386 //-------o Function 08 - Get complete data from each user
387 	function GetSafe(uint256 _id) public view
388         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
389     {
390         Safe storage s = _safes[_id];
391         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
392     }
393 	
394 //-------o Function 09 - Withdraw Affiliate Bonus
395 
396     function WithdrawAffiliate(address user, address tokenAddress) public {  
397 		require(tokenAddress != 0x0);		
398 		require(Statistics[user][tokenAddress][3] > 0 );
399 		
400 		uint256 amount = Statistics[msg.sender][tokenAddress][3];
401 		Statistics[msg.sender][tokenAddress][3] = 0;
402 		
403 		Bigdata[tokenAddress][3] 		= sub(Bigdata[tokenAddress][3], amount); 
404 		Bigdata[tokenAddress][7] 		= add(Bigdata[tokenAddress][7], amount);
405 		
406 		uint256 eventAmount				= amount;
407         address eventTokenAddress 		= tokenAddress;
408         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
409         
410         ERC20Interface token = ERC20Interface(tokenAddress);        
411         require(token.balanceOf(address(this)) >= amount);
412         token.transfer(user, amount);
413 		
414 		Statistics[user][tokenAddress][2] 	= add(Statistics[user][tokenAddress][2], amount);
415 
416 		Bigdata[tokenAddress][13]++;		
417 		
418 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
419 		
420 		Airdrop(tokenAddress, amount, 4); 
421     } 		
422 	
423 	
424 	/*==============================
425     =          RESTRICTED          =
426     ==============================*/  	
427 
428 //-------o 01 Add Contract Address	
429     function AddContractAddress(address tokenAddress, uint256 CurrentUSDprice, uint256 CurrentETHprice, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
430 		uint256 newSpeed	= _PercentPermonth;
431 		require(newSpeed >= 3 && newSpeed <= 12);
432 		
433 		Bigdata[tokenAddress][1] 		= newSpeed;	
434 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
435 		Bigdata[tokenAddress][5] 		= _maxcontribution;	
436 		
437 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
438 		uint256 HodlTime 				= _HodlingTime * 1 days;		
439 		Bigdata[tokenAddress][2]		= HodlTime;	
440 		
441 		Bigdata[tokenAddress][14]		= CurrentUSDprice;
442 		Bigdata[tokenAddress][17]		= CurrentETHprice;
443 		contractaddress[tokenAddress] 	= true;
444     }
445 	
446 //-------o 02 - Update Token Price (USD)
447 	
448 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice, uint256 ETHprice) public restricted  {
449 		
450 		if (Currentprice > 0  ) { Bigdata[tokenAddress][14] = Currentprice; }
451 		if (ATHprice > 0  ) 	{ Bigdata[tokenAddress][15] = ATHprice; }
452 		if (ATLprice > 0  ) 	{ Bigdata[tokenAddress][16] = ATLprice; }
453 		if (ETHprice > 0  ) 	{ Bigdata[tokenAddress][17] = ETHprice; }
454 
455     }
456 	
457 //-------o 03 Hold Platform
458     function Holdplatform_Airdrop(address tokenAddress, uint256 HPM_status, uint256 HPM_divider) public restricted {
459 		require(HPM_status == 0 || HPM_status == 1 );
460 		
461 		Holdplatform_status[tokenAddress] 	= HPM_status;	
462 		Holdplatform_divider[tokenAddress] 	= HPM_divider;	// Airdrop = 100% : Divider
463 	
464     }	
465 	//--o Deposit
466 	function Holdplatform_Deposit(uint256 amount) restricted public {
467 		require(amount > 0 );
468         
469        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
470         require(token.transferFrom(msg.sender, address(this), amount));
471 		
472 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
473 		Holdplatform_balance 	= newbalance;
474 		
475 		emit onHOLDdeposit(msg.sender, amount, newbalance, now);
476     }
477 	//--o Withdraw
478 	function Holdplatform_Withdraw(uint256 amount) restricted public {
479         require(Holdplatform_balance > 0 && amount <= Holdplatform_balance);
480         
481 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
482 		Holdplatform_balance 	= newbalance;
483         
484         ERC20Interface token = ERC20Interface(Holdplatform_address);
485         
486         require(token.balanceOf(address(this)) >= amount);
487         token.transfer(msg.sender, amount);
488 		
489 		emit onHOLDwithdraw(msg.sender, amount, newbalance, now);
490     }
491 	
492 //-------o 04 - Return All Tokens To Their Respective Addresses    
493     function ReturnAllTokens() restricted public
494     {
495 
496         for(uint256 i = 1; i < idnumber; i++) {            
497             Safe storage s = _safes[i];
498             if (s.id != 0) {
499 				
500 				if(s.amountbalance > 0) {
501 					uint256 amount = add(s.amountbalance, s.cashbackbalance);
502 					PayToken(s.user, s.tokenAddress, amount);
503 					s.amountbalance							= 0;
504 					s.cashbackbalance						= 0;
505 					Statistics[s.user][s.tokenAddress][5]	= 0;
506 				}
507             }
508         }
509     }   
510 	
511 	
512 	/*==============================
513     =      SAFE MATH FUNCTIONS     =
514     ==============================*/  	
515 	
516 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
517 		if (a == 0) {
518 			return 0;
519 		}
520 		uint256 c = a * b; 
521 		require(c / a == b);
522 		return c;
523 	}
524 	
525 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
526 		require(b > 0); 
527 		uint256 c = a / b;
528 		return c;
529 	}
530 	
531 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
532 		require(b <= a);
533 		uint256 c = a - b;
534 		return c;
535 	}
536 	
537 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
538 		uint256 c = a + b;
539 		require(c >= a);
540 		return c;
541 	}
542     
543 }
544 
545 
546 	/*==============================
547     =        ERC20 Interface       =
548     ==============================*/ 
549 
550 contract ERC20Interface {
551 
552     uint256 public totalSupply;
553     uint256 public decimals;
554     
555     function symbol() public view returns (string);
556     function balanceOf(address _owner) public view returns (uint256 balance);
557     function transfer(address _to, uint256 _value) public returns (bool success);
558     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
559     function approve(address _spender, uint256 _value) public returns (bool success);
560     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
561 
562     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
563     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
564 }