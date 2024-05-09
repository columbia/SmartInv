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
21     =         LIVE VERSION         =
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
38 contract HoldPlatformDapps is EthereumSmartContract {
39 	
40 	/*==============================
41     =            EVENTS            =
42     ==============================*/
43 	
44 	// Ethereum User
45  event onCashbackCode	(address indexed hodler, address cashbackcode);		
46  event onAffiliateBonus	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 decimal, uint256 endtime);		
47  event onHoldplatform	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 decimal, uint256 endtime);
48  event onUnlocktoken	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 decimal, uint256 endtime);
49  event onUtilityfee		(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 decimal, uint256 endtime);
50  event onReceiveAirdrop	(address indexed hodler, uint256 amount, uint256 datetime);	
51 
52 	// Ethereum Nodes
53  event onAddContract	(address indexed hodler, address indexed tokenAddress, uint256 percent, string tokenSymbol, uint256 amount, uint256 endtime);
54  event onTokenPrice		(address indexed hodler, address indexed tokenAddress, uint256 Currentprice, uint256 ETHprice, uint256 ATHprice, uint256 ATLprice, uint256 ICOprice, uint256 Aprice, uint256 endtime);
55  event onHoldAirdrop	(address indexed hodler, address indexed tokenAddress, uint256 HPMstatus, uint256 d1, uint256 d2, uint256 d3,uint256 endtime);
56  event onHoldDeposit	(address indexed hodler, address indexed tokenAddress, uint256 amount, uint256 endtime);
57  event onHoldWithdraw	(address indexed hodler, address indexed tokenAddress, uint256 amount, uint256 endtime);
58  event onUtilitySetting	(address indexed hodler, address indexed tokenAddress, address indexed pwt, uint256 amount, uint256 ustatus, uint256 endtime);
59  event onUtilityStatus	(address indexed hodler, address indexed tokenAddress, uint256 ustatus, uint256 endtime);
60  event onUtilityBurn	(address indexed hodler, address indexed tokenAddress, uint256 uamount, uint256 bamount, uint256 endtime); 
61  
62 	/*==============================
63     =          Mechanism           =
64     ==============================*/   
65 
66 	//-------o Burn = 2% o-------o Affiliate = 10% o-------o Cashback = 16% o-------o Total Receive = 88% o-------o Without Cashback = 72%
67 	
68 	//-------o Hold 36 Months, Unlock 0.067% Per day >>> 2% Per month 
69 	//-------o Special Promo : Hold 24 Months, Unlock 0.1% Per day >>> 3% Permonth ( limited offer )
70 	
71 	
72 	/*==============================
73     =          VARIABLES           =
74     ==============================*/  
75 	
76 	// ---> Struct Database
77 
78     struct Safe {
79         uint256 id;						// [01] -- > Registration Number
80         uint256 amount;					// [02] -- > Total amount of contribution to this transaction
81         uint256 endtime;				// [03] -- > The Expiration Of A Hold Platform Based On Unix Time
82         address user;					// [04] -- > The ETH address you are using
83         address tokenAddress;			// [05] -- > The Token Contract Address That You Are Using
84 		string  tokenSymbol;			// [06] -- > The Token Symbol That You Are Using
85 		uint256 amountbalance; 			// [07] -- > 88% from Contribution / 72% Without Cashback
86 		uint256 cashbackbalance; 		// [08] -- > 16% from Contribution / 0% Without Cashback
87 		uint256 lasttime; 				// [09] -- > The Last Time You Withdraw Based On Unix Time
88 		uint256 percentage; 			// [10] -- > The percentage of tokens that are unlocked every month ( Default = 2% --> Promo = 3% )
89 		uint256 percentagereceive; 		// [11] -- > The Percentage You Have Received
90 		uint256 tokenreceive; 			// [12] -- > The Number Of Tokens You Have Received
91 		uint256 lastwithdraw; 			// [13] -- > The Last Amount You Withdraw
92 		address referrer; 				// [14] -- > Your ETH referrer address
93 		bool 	cashbackstatus; 		// [15] -- > Cashback Status
94 		uint256 tokendecimal; 			// [16] -- > Token Decimals
95 		uint256 startime;				// [17] -- > Registration time ( Based On Unix Time )
96     }
97 	
98 	uint256 private idnumber; 										// [01] -- > ID number ( Start from 500 )				
99 	uint256 public  TotalUser; 										// [02] -- > Total Smart Contract User (TX)					
100 	mapping(address => address) 		public cashbackcode; 		// [03] -- > Cashback Code 					
101 	mapping(address => uint256[]) 		public idaddress;			// [04] -- > Search Address by ID			
102 	mapping(address => address[]) 		public afflist;				// [05] -- > Affiliate List by ID					
103 	mapping(address => string) 			public ContractSymbol; 		// [06] -- > Contract Address Symbol				
104 	mapping(uint256 => Safe) 			private _safes; 			// [07] -- > Struct safe database	
105 	mapping(address => bool) 			public contractaddress; 	// [08] -- > Contract Address 	
106 	mapping(uint256 => uint256) 		public starttime; 			// [09] -- > Start Time by id number
107 
108 	mapping (address => mapping (uint256 => uint256)) public Bigdata; 
109 	
110 	/** Bigdata Mapping : 
111 	[1] Percent (Monthly Unlocked tokens)		[7] All Payments 				[13] Total TX Affiliate (Withdraw) 		[19] Total TX Burn
112 	[2] Holding Time (in seconds) 				[8] Active User 				[14] Current Price (USD)				[20] ICO Price (ETH)	
113 	[3] Token Balance 							[9] Total User 					[15] ATH Price (ETH)					[21] Token Decimal
114 	[4] Total Burn								[10] Total TX Hold 				[16] ATL Price (ETH)					[22] Additional Price
115 	[5] Max Contribution 						[11] Total TX Unlock 			[17] Current ETH Price (ETH) 		
116 	[6] All Contribution 						[12] Total TX Airdrop			[18] Date Register				
117 	**/
118 	
119 	// ---> Statistics Mapping	
120 	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
121 	// [1] LifetimeContribution [2] LifetimePayments [3] Affiliatevault [4] Affiliateprofit [5] ActiveContribution	[6] Burn [7] Active User 
122 	
123 	// ---> Airdrop Mapping		
124 	address public Holdplatform_address;						// [01] -- > Token contract address used for airdrop					
125 	uint256 public Holdplatform_balance; 						// [02] -- > The remaining balance, to be used for airdrop			
126 	mapping(address => uint256) public Holdplatform_status;		// [03] -- > Current airdrop status ( 0 = Disabled, 1 = Active )
127 	
128 	mapping(address => mapping (uint256 => uint256)) public Holdplatform_divider; 	
129 	// Holdplatform_divider = [1] Lock Airdrop	[2] Unlock Airdrop	[3] Affiliate Airdrop
130 
131 	// ---> Utility Mapping
132 	mapping(address => uint256) public U_status;							// [01] -- > Status for utility fee payments 
133 	mapping(address => uint256) public U_amount;							// [02] -- > The amount of utility fee that must be paid for every hold
134 	mapping(address => address) public U_paywithtoken;						// [03] -- > Tokens used to pay fees
135 	mapping(address => mapping (address => uint256)) public U_userstatus; 	// [04] -- > The status of the user has paid or not
136 	
137 	mapping(address => mapping (uint256 => uint256)) public U_statistics;
138 	// U_statistics = [1] Utility Vault [2] Utility Profit [3] Utility Burn
139 	
140 	address public Utility_address;
141 	
142 	/*==============================
143     =          CONSTRUCTOR         =
144     ==============================*/  	
145    
146     constructor() public {     	 	
147         idnumber 				= 500;
148 		Holdplatform_address	= 0x49a6123356b998EF9478C495E3D162A2F4eC4363;	
149     }
150     
151 	
152 	/*==============================
153     =    AVAILABLE FOR EVERYONE    =
154     ==============================*/  
155 
156 //-------o Function 01 - Ethereum Payable
157     function () public payable {  
158 		if (msg.value == 0) {
159 			tothe_moon();
160 		} else { revert(); }
161     }
162     function tothemoon() public payable {  
163 		if (msg.value == 0) {
164 			tothe_moon();
165 		} else { revert(); }
166     }
167 	function tothe_moon() private {  
168 		for(uint256 i = 1; i < idnumber; i++) {            
169 		Safe storage s = _safes[i];
170 		
171 			// Send all unlocked tokens
172 			if (s.user == msg.sender && s.amountbalance > 0) {
173 			Unlocktoken(s.tokenAddress, s.id);
174 			
175 				// Send all affiliate bonus
176 				if (Statistics[s.user][s.tokenAddress][3] > 0) {		// [3] Affiliatevault
177 				WithdrawAffiliate(s.user, s.tokenAddress);
178 				}
179 			}
180 		}
181     }
182 	
183 //-------o Function 02 - Cashback Code
184 
185     function CashbackCode(address _cashbackcode) public {		
186 		require(_cashbackcode != msg.sender);			
187 		
188 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 && Bigdata[_cashbackcode][8] == 1) { // [8] Active User 
189 		cashbackcode[msg.sender] = _cashbackcode; }
190 		else { cashbackcode[msg.sender] = EthereumNodes; }		
191 		
192 	emit onCashbackCode(msg.sender, _cashbackcode);		
193     } 
194 	
195 //-------o Function 03 - Contribute 
196 
197 	//--o 01
198     function Holdplatform(address tokenAddress, uint256 amount) public {
199 		require(amount >= 1 );
200 		require(add(Statistics[msg.sender][tokenAddress][5], amount) <= Bigdata[tokenAddress][5] ); 
201 		// [5] ActiveContribution && [5] Max Contribution	
202 		
203 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 ) { 
204 			cashbackcode[msg.sender] 	= EthereumNodes;
205 		} 
206 		
207 		if (Bigdata[msg.sender][18] == 0) { // [18] Date Register
208 			Bigdata[msg.sender][18] = now;
209 		} 
210 		
211 		if (contractaddress[tokenAddress] == false) { revert(); } else { 
212 		
213 			if (U_status[tokenAddress] == 2 ) {  // 0 = Disabled , 1 = Enabled, 2 = Merger with Hold
214 
215 				if (U_userstatus[msg.sender][tokenAddress] == 0 ) {
216 					
217 					uint256 Fee								= U_amount[tokenAddress];
218 					uint256 HalfFee							= div(Fee, 2);
219 					Bigdata[tokenAddress][3]				= add(Bigdata[tokenAddress][3], Fee);
220 					U_statistics[tokenAddress][1]			= add(U_statistics[tokenAddress][1], HalfFee);	// [1] Utility Vault
221 					U_statistics[tokenAddress][2]			= add(U_statistics[tokenAddress][2], HalfFee);	// [2] Utility Profit
222 					U_statistics[tokenAddress][3]			= add(U_statistics[tokenAddress][3], HalfFee);	// [3] Utility Burn
223 			
224 					uint256 totalamount						= sub(amount, Fee);
225 					U_userstatus[msg.sender][tokenAddress] 	= 1;
226 					
227 				} else { 
228 				totalamount	= amount; 
229 				U_userstatus[msg.sender][tokenAddress] 	= 1; }			
230 																									
231 			} else { 	
232 		
233 				if (U_status[tokenAddress] == 1 && U_userstatus[msg.sender][tokenAddress] == 0 ) { revert(); } 
234 				else { totalamount	= amount; }
235 				
236 			}
237 			
238 			ERC20Interface token 			= ERC20Interface(tokenAddress);       
239 			require(token.transferFrom(msg.sender, address(this), amount));	
240 		
241 			HodlTokens2(tokenAddress, totalamount);
242 			Airdrop(msg.sender, tokenAddress, totalamount, 1);		// 1 = Hold, 2 = Unhold, 3 = Affiliate Withdraw
243 			
244 		}
245 		
246 	}
247 
248 	//--o 02	
249     function HodlTokens2(address ERC, uint256 amount) private {
250 		
251 		address ref						= cashbackcode[msg.sender];
252 		uint256 ReferrerContribution 	= Statistics[ref][ERC][5];							// [5] ActiveContribution
253 		uint256 AffiliateContribution 	= Statistics[msg.sender][ERC][5];					// [5] ActiveContribution
254 		uint256 MyContribution 			= add(AffiliateContribution, amount); 
255 		
256 	  	if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) { 						// [8] Active User 
257 			uint256 nodecomission 		= div(mul(amount, 26), 100);
258 			Statistics[ref][ERC][3] 	= add(Statistics[ref][ERC][3], nodecomission ); 	// [3] Affiliatevault 
259 			Statistics[ref][ERC][4] 	= add(Statistics[ref][ERC][4], nodecomission );		// [4] Affiliateprofit 
260 			
261 		} else { 
262 			
263 			uint256 affcomission_one 	= div(mul(amount, 10), 100); 
264 			
265 			if (ReferrerContribution >= MyContribution) { //--o  if referrer contribution >= My contribution
266 
267 				Statistics[ref][ERC][3] 		= add(Statistics[ref][ERC][3], affcomission_one); 						// [3] Affiliatevault 
268 				Statistics[ref][ERC][4] 		= add(Statistics[ref][ERC][4], affcomission_one); 						// [4] Affiliateprofit 
269 
270 			} else {
271 					if (ReferrerContribution > AffiliateContribution  ) { 	
272 						if (amount <= add(ReferrerContribution,AffiliateContribution)  ) { 
273 						
274 						uint256 AAA					= sub(ReferrerContribution, AffiliateContribution );
275 						uint256 affcomission_two	= div(mul(AAA, 10), 100); 
276 						uint256 affcomission_three	= sub(affcomission_one, affcomission_two);		
277 						} else {	
278 						uint256 BBB					= sub(sub(amount, ReferrerContribution), AffiliateContribution);
279 						affcomission_three			= div(mul(BBB, 10), 100); 
280 						affcomission_two			= sub(affcomission_one, affcomission_three); } 
281 						
282 					} else { affcomission_two	= 0; 	affcomission_three	= affcomission_one; } 
283 					
284 				Statistics[ref][ERC][3] 		= add(Statistics[ref][ERC][3], affcomission_two); 						// [3] Affiliatevault 
285 				Statistics[ref][ERC][4] 		= add(Statistics[ref][ERC][4], affcomission_two); 						// [4] Affiliateprofit 
286 	
287 				Statistics[EthereumNodes][ERC][3] 		= add(Statistics[EthereumNodes][ERC][3], affcomission_three); 	// [3] Affiliatevault 
288 				Statistics[EthereumNodes][ERC][4] 		= add(Statistics[EthereumNodes][ERC][4], affcomission_three);	// [4] Affiliateprofit 
289 			}	
290 		}
291 
292 		HodlTokens3(ERC, amount, ref); 	
293 	}
294 	//--o 03	
295     function HodlTokens3(address ERC, uint256 amount, address ref) private {
296 	    
297 		uint256 AvailableBalances 		= div(mul(amount, 72), 100);
298 		
299 		if (ref == EthereumNodes && Bigdata[msg.sender][8] == 0 ) 										// [8] Active User 
300 		{ uint256	AvailableCashback = 0; } else { AvailableCashback = div(mul(amount, 16), 100);}
301 		
302 	    ERC20Interface token 	= ERC20Interface(ERC); 		
303 		uint256 HodlTime		= add(now, Bigdata[ERC][2]);											// [2] Holding Time (in seconds) 	
304 		
305 		_safes[idnumber] = Safe(idnumber, amount, HodlTime, msg.sender, ERC, token.symbol(), AvailableBalances, AvailableCashback, now, Bigdata[ERC][1], 0, 0, 0, ref, false, Bigdata[ERC][21], now);			// [1] Percent (Monthly Unlocked tokens)	
306 				
307 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], amount); 			// [1] LifetimeContribution
308 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], amount); 			// [5] ActiveContribution
309 		
310 		uint256 Burn 							= div(mul(amount, 2), 100);
311 		Statistics[msg.sender][ERC][6]  		= add(Statistics[msg.sender][ERC][6], Burn); 			// [6] Burn 	
312 		Bigdata[ERC][6] 						= add(Bigdata[ERC][6], amount);   						// [6] All Contribution 
313         Bigdata[ERC][3]							= add(Bigdata[ERC][3], amount);  						// [3] Token Balance 
314 
315 		if(Bigdata[msg.sender][8] == 1 ) {																// [8] Active User 
316 		starttime[idnumber] = now;
317         idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[ERC][10]++;  }						// [10] Total TX Hold 	
318 		else { 
319 		starttime[idnumber] = now;
320 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; 
321 		Bigdata[ERC][9]++; Bigdata[ERC][10]++; TotalUser++;   }											// [9] Total User & [10] Total TX Hold 
322 		
323 		Bigdata[msg.sender][8] 			= 1;  															// [8] Active User 
324 		Statistics[msg.sender][ERC][7]	= 1;		
325 		// [7] Active User 
326         emit onHoldplatform(msg.sender, ERC, token.symbol(), amount, Bigdata[ERC][21], HodlTime);	
327 		
328 		amount	= 0;	AvailableBalances = 0;		AvailableCashback = 0;
329 		
330 		U_userstatus[msg.sender][ERC] 		= 0; // Meaning that the utility fee has been used and returned to 0
331 		
332 	}
333 	
334 
335 //-------o Function 05 - Claim Token That Has Been Unlocked
336     function Unlocktoken(address tokenAddress, uint256 id) public {
337         require(tokenAddress != 0x0);
338         require(id != 0);        
339         
340         Safe storage s = _safes[id];
341         require(s.user == msg.sender);  
342 		require(s.tokenAddress == tokenAddress);
343 		
344 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
345     }
346     //--o 01
347     function UnlockToken2(address ERC, uint256 id) private {
348         Safe storage s = _safes[id];      
349         require(s.tokenAddress == ERC);		
350 		     
351         if(s.endtime < now){ //--o  Hold Complete 
352         
353 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
354 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 			// [5] ActiveContribution	
355 		s.lastwithdraw 							= amounttransfer;   s.amountbalance = 0;   s.lasttime = now; 
356 
357  		Airdrop(s.user, s.tokenAddress, amounttransfer, 2);		// 1 = Hold, 2 = Unhold, 3 = Affiliate Withdraw  
358 		PayToken(s.user, s.tokenAddress, amounttransfer); 
359 		
360 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
361             s.tokenreceive 		= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
362 			s.cashbackbalance 	= 0;	
363 			s.cashbackstatus 	= true ;
364             }
365 			else {
366 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
367 			}
368 	
369 		emit onUnlocktoken(msg.sender, s.tokenAddress, s.tokenSymbol, amounttransfer, Bigdata[ERC][21], now);
370 		
371         } else { UnlockToken3(ERC, s.id); }
372         
373     }   
374 	//--o 02
375 	function UnlockToken3(address ERC, uint256 id) private {		
376 		Safe storage s = _safes[id];
377         require(s.tokenAddress == ERC);		
378 			
379 		uint256 timeframe  			= sub(now, s.lasttime);			                            
380 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
381 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
382 		                         
383 		uint256 MaxWithdraw 		= div(s.amount, 10);
384 			
385 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
386 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
387 			
388 		//--o Maximum withdraw = User Amount Balance   
389 			if (MaxAccumulation > s.amountbalance) { uint256 lastwithdraw = s.amountbalance; } else { lastwithdraw = MaxAccumulation; }
390 			
391 		s.lastwithdraw 				= lastwithdraw; 			
392 		s.amountbalance 			= sub(s.amountbalance, lastwithdraw);
393 		
394 		if (s.cashbackbalance > 0) { 
395 		s.cashbackstatus 	= true ; 
396 		s.lastwithdraw 		= add(s.cashbackbalance, lastwithdraw); 
397 		} 
398 		
399 		s.cashbackbalance 			= 0; 
400 		s.lasttime 					= now; 		
401 			
402 		UnlockToken4(ERC, id, s.amountbalance, s.lastwithdraw );		
403     }   
404 	//--o 03
405     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
406         Safe storage s = _safes[id];
407         require(s.tokenAddress == ERC);	
408 
409 		uint256 affiliateandburn 	= div(mul(s.amount, 12), 100) ; 
410 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ;
411 
412 		uint256 firstid = s.id;
413 		
414 			if (cashbackcode[msg.sender] == EthereumNodes && idaddress[msg.sender][0] == firstid ) {
415 			uint256 tokenreceived 	= sub(sub(sub(s.amount, affiliateandburn), maxcashback), newamountbalance) ;	
416 			}else { tokenreceived 	= sub(sub(s.amount, affiliateandburn), newamountbalance) ;}
417 			
418 		s.percentagereceive 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
419 		s.tokenreceive 			= tokenreceived; 	
420 
421 		PayToken(s.user, s.tokenAddress, realAmount);           		
422 		emit onUnlocktoken(msg.sender, s.tokenAddress, s.tokenSymbol, realAmount, Bigdata[ERC][21], now);
423 		
424 		Airdrop(s.user, s.tokenAddress, realAmount, 2); 	// 1 = Hold, 2 = Unhold, 3 = Affiliate Withdraw  
425     } 
426 	//--o Pay Token
427     function PayToken(address user, address tokenAddress, uint256 amount) private {
428         
429         ERC20Interface token = ERC20Interface(tokenAddress);        
430         require(token.balanceOf(address(this)) >= amount);
431 		
432 		token.transfer(user, amount);
433 		uint256 burn	= 0;
434 		
435         if (Statistics[user][tokenAddress][6] > 0) {												// [6] Burn  
436 
437 		burn = Statistics[user][tokenAddress][6];													// [6] Burn  
438         Statistics[user][tokenAddress][6] = 0;														// [6] Burn  
439 		
440 		token.transfer(0x000000000000000000000000000000000000dEaD, burn); 
441 		Bigdata[tokenAddress][4]			= add(Bigdata[tokenAddress][4], burn);					// [4] Total Burn
442 		
443 		Bigdata[tokenAddress][19]++;																// [19] Total TX Burn
444 		}
445 		
446 		Bigdata[tokenAddress][3]			= sub(sub(Bigdata[tokenAddress][3], amount), burn); 	// [3] Token Balance 	
447 		Bigdata[tokenAddress][7]			= add(Bigdata[tokenAddress][7], amount);				// [7] All Payments 
448 		Statistics[user][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 		// [2] LifetimePayments
449 		
450 		Bigdata[tokenAddress][11]++;																// [11] Total TX Unlock 
451 		
452 	}
453 	
454 //-------o Function 05 - Airdrop
455 
456     function Airdrop(address user, address tokenAddress, uint256 amount, uint256 divfrom) private {
457 		
458 		uint256 divider			= Holdplatform_divider[tokenAddress][divfrom];
459 		
460 		if (Holdplatform_status[tokenAddress] == 1) {
461 			
462 			if (Holdplatform_balance > 0 && divider > 0) {
463 				
464 				if (Bigdata[tokenAddress][21] == 18 ) { uint256 airdrop			= div(amount, divider);
465 				
466 				} else { 
467 				
468 				uint256 difference 			= sub(18, Bigdata[tokenAddress][21]);
469 				uint256 decimalmultipler	= ( 10 ** difference );
470 				uint256 decimalamount		= mul(decimalmultipler, amount);
471 				
472 				airdrop = div(decimalamount, divider); 
473 				
474 				}
475 			
476 			address airdropaddress	= Holdplatform_address;
477 			ERC20Interface token 	= ERC20Interface(airdropaddress);        
478 			token.transfer(user, airdrop);
479 		
480 			Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
481 			Bigdata[tokenAddress][12]++;															// [12] Total TX Airdrop	
482 		
483 			emit onReceiveAirdrop(user, airdrop, now);
484 			}
485 			
486 		}	
487 	}
488 	
489 //-------o Function 06 - Total Contribute
490 
491     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
492         return idaddress[hodler].length;
493     }
494 	
495 //-------o Function 07 - Total Affiliate 
496 
497     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
498         return afflist[hodler].length;
499     }
500     
501 //-------o Function 08 - Get complete data from each user
502 	function GetSafe(uint256 _id) public view
503         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, uint256 tokendecimal, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
504     {
505         Safe storage s = _safes[_id];
506         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokendecimal, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
507     }
508 	
509 //-------o Function 09 - Withdraw Affiliate Bonus
510 
511     function WithdrawAffiliate(address user, address tokenAddress) public { 
512 		require(user == msg.sender); 	
513 		require(Statistics[user][tokenAddress][3] > 0 );												// [3] Affiliatevault
514 		
515 		uint256 amount 	= Statistics[msg.sender][tokenAddress][3];										// [3] Affiliatevault
516 
517         ERC20Interface token = ERC20Interface(tokenAddress);        
518         require(token.balanceOf(address(this)) >= amount);
519         token.transfer(user, amount);
520 		
521 		Bigdata[tokenAddress][3] 				= sub(Bigdata[tokenAddress][3], amount); 				// [3] Token Balance 	
522 		Bigdata[tokenAddress][7] 				= add(Bigdata[tokenAddress][7], amount);				// [7] All Payments
523 		Statistics[user][tokenAddress][3] 		= 0;													// [3] Affiliatevault
524 		Statistics[user][tokenAddress][2] 		= add(Statistics[user][tokenAddress][2], amount);		// [2] LifetimePayments
525 
526 		Bigdata[tokenAddress][13]++;																	// [13] Total TX Affiliate (Withdraw)
527 		emit onAffiliateBonus(msg.sender, tokenAddress, ContractSymbol[tokenAddress], amount, Bigdata[tokenAddress][21], now);
528 		
529 		Airdrop(user, tokenAddress, amount, 3); 	// 1 = Hold, 2 = Unhold, 3 = Affiliate Withdraw
530     } 
531 
532 	//-------o Function 10 - Utility Fee
533 
534 	function Utility_fee(address tokenAddress) public {
535 		
536 		uint256 Fee		= U_amount[tokenAddress];	
537 		address pwt 	= U_paywithtoken[tokenAddress];
538 		
539 		if (U_status[tokenAddress] == 0 || U_status[tokenAddress] == 2 || U_userstatus[msg.sender][tokenAddress] == 1  ) { revert(); } else { 
540 
541 		ERC20Interface token 			= ERC20Interface(pwt);       
542 		require(token.transferFrom(msg.sender, address(this), Fee));
543 
544 		Bigdata[pwt][3]			= add(Bigdata[pwt][3], Fee); 		
545 		
546 		uint256 utilityvault 	= U_statistics[pwt][1];				// [1] Utility Vault
547 		uint256 utilityprofit 	= U_statistics[pwt][2];				// [2] Utility Profit
548 		uint256 Burn 			= U_statistics[pwt][3];				// [3] Utility Burn
549 	
550 		uint256 percent50	= div(Fee, 2);
551 	
552 		U_statistics[pwt][1]	= add(utilityvault, percent50);		// [1] Utility Vault
553 		U_statistics[pwt][2]	= add(utilityprofit, percent50);	// [2] Utility Profit
554 		U_statistics[pwt][3]	= add(Burn, percent50);				// [3] Utility Burn
555 	
556 	
557 		U_userstatus[msg.sender][tokenAddress] 	= 1;	
558 		emit onUtilityfee(msg.sender, pwt, token.symbol(), U_amount[tokenAddress], Bigdata[tokenAddress][21], now);	
559 		
560 		}		
561 	
562 	}
563 
564 
565 	/*==============================
566     =          RESTRICTED          =
567     ==============================*/  	
568 
569 //-------o 01 - Add Contract Address	
570     function AddContractAddress(address tokenAddress, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth, uint256 _TokenDecimal) public restricted {
571 		
572 		uint256 decimalsmultipler	= ( 10 ** _TokenDecimal );
573 		uint256 maxlimit			= mul(10000000, decimalsmultipler); 	// >= 10,000,000 Token
574 		
575 		require(_maxcontribution >= maxlimit);	
576 		require(_PercentPermonth >= 2 && _PercentPermonth <= 12);
577 		
578 		Bigdata[tokenAddress][1] 		= _PercentPermonth;							// [1] Percent (Monthly Unlocked tokens)
579 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
580 		Bigdata[tokenAddress][5] 		= _maxcontribution;							// [5] Max Contribution 
581 		
582 		uint256 _HodlingTime 			= mul(div(72, _PercentPermonth), 30);
583 		uint256 HodlTime 				= _HodlingTime * 1 days;		
584 		Bigdata[tokenAddress][2]		= HodlTime;									// [2] Holding Time (in seconds) 	
585 		
586 		if (Bigdata[tokenAddress][21]  == 0  ) { Bigdata[tokenAddress][21]  = _TokenDecimal; }	// [21] Token Decimal
587 		
588 		contractaddress[tokenAddress] 	= true;
589 		
590 		emit onAddContract(msg.sender, tokenAddress, _PercentPermonth, _ContractSymbol, _maxcontribution, now);
591     }
592 	
593 //-------o 02 - Update Token Price (USD)
594 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ETHprice, uint256 ATHprice, uint256 ATLprice, uint256 ICOprice, uint256 Aprice ) public restricted  {
595 		
596 		if (Currentprice > 0  ) { Bigdata[tokenAddress][14] = Currentprice; }		// [14] Current Price (USD)
597 		if (ATHprice > 0  ) 	{ Bigdata[tokenAddress][15] = ATHprice; }			// [15] All Time High (ETH) 
598 		if (ATLprice > 0  ) 	{ Bigdata[tokenAddress][16] = ATLprice; }			// [16] All Time Low (ETH) 
599 		if (ETHprice > 0  ) 	{ Bigdata[tokenAddress][17] = ETHprice; }			// [17] Current ETH Price (ETH) 
600 		if (ICOprice > 0  ) 	{ Bigdata[tokenAddress][20] = ICOprice; }			// [20] ICO Price (ETH) 
601 		if (Aprice > 0  ) 		{ Bigdata[tokenAddress][22] = Aprice; }				// [22] Additional Price
602 			
603 		emit onTokenPrice(msg.sender, tokenAddress, Currentprice, ETHprice, ATHprice, ATLprice, ICOprice, Aprice, now);
604 
605     }
606 	
607 //-------o 03 - Hold Platform
608     function Holdplatform_Airdrop(address tokenAddress, uint256 HPM_status, uint256 HPM_divider1, uint256 HPM_divider2, uint256 HPM_divider3 ) public restricted {
609 		
610 		//require(HPM_divider1 >= 1000 && HPM_divider1 >= 1000 && HPM_divider1 >= 1000);
611 		
612 		Holdplatform_status[tokenAddress] 		= HPM_status;	
613 		Holdplatform_divider[tokenAddress][1]	= HPM_divider1; 		// [1] Hold Airdrop	
614 		Holdplatform_divider[tokenAddress][2]	= HPM_divider2; 		// [2] Unhold Airdrop
615 		Holdplatform_divider[tokenAddress][3]	= HPM_divider3; 		// [3] Affiliate Airdrop
616 		
617 		emit onHoldAirdrop(msg.sender, tokenAddress, HPM_status, HPM_divider1, HPM_divider2, HPM_divider3, now);
618 	
619     }	
620 	//--o Deposit
621 	function Holdplatform_Deposit(uint256 amount) restricted public {
622         
623        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
624         require(token.transferFrom(msg.sender, address(this), amount));
625 		
626 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
627 		Holdplatform_balance 	= newbalance;
628 		
629 		emit onHoldDeposit(msg.sender, Holdplatform_address, amount, now);
630     }
631 	//--o Withdraw
632 	function Holdplatform_Withdraw() restricted public {
633 		ERC20Interface token = ERC20Interface(Holdplatform_address);
634         token.transfer(msg.sender, Holdplatform_balance);
635 		Holdplatform_balance = 0;
636 		
637 		emit onHoldWithdraw(msg.sender, Holdplatform_address, Holdplatform_balance, now);
638     }
639 	
640 //-------o 04 - Utility Function
641 
642 	//--o Utility Address
643 	function Utility_Address(address tokenAddress) public restricted {
644 		
645 		if (Utility_address == 0x0000000000000000000000000000000000000000) {  Utility_address = tokenAddress; } else { revert(); }	
646 		
647 		// Only valid for a onetime update, cannot be changed!
648 		
649     }
650 
651 	//--o Setting
652 	function Utility_Setting(address tokenAddress, address _U_paywithtoken, uint256 _U_amount, uint256 _U_status) public restricted {
653 		
654 		uint256 decimal 			= Bigdata[_U_paywithtoken][21];
655 		uint256 decimalmultipler	= ( 10 ** decimal );
656 		uint256 maxfee				= mul(10000, decimalmultipler);	// <= 10.000 Token
657 		
658 		require(_U_amount <= maxfee ); 
659 		require(_U_status == 0 || _U_status == 1 || _U_status == 2);	// 0 = Disabled , 1 = Enabled, 2 = Merger with Hold	
660 		
661 		require(_U_paywithtoken != 0x0000000000000000000000000000000000000000); 
662 		require(_U_paywithtoken == tokenAddress || _U_paywithtoken == Utility_address); 
663 		
664 		U_paywithtoken[tokenAddress]	= _U_paywithtoken; 
665 		U_status[tokenAddress] 			= _U_status;	
666 		U_amount[tokenAddress]			= _U_amount; 	
667 
668 	emit onUtilitySetting(msg.sender, tokenAddress, _U_paywithtoken, _U_amount, _U_status, now);	
669 	
670     }
671 	//--o Status
672 	function Utility_Status(address tokenAddress, uint256 Newstatus) public restricted {
673 		require(Newstatus == 0 || Newstatus == 1 || Newstatus == 2);
674 		
675 		address upwt	= U_paywithtoken[tokenAddress];
676 		require(upwt != 0x0000000000000000000000000000000000000000);
677 		
678 		U_status[tokenAddress] = Newstatus;
679 		
680 		emit onUtilityStatus(msg.sender, tokenAddress, U_status[tokenAddress], now);
681 		
682     }
683 	//--o Burn
684 	function Utility_Burn(address tokenAddress) public restricted {
685 		
686 		if (U_statistics[tokenAddress][1] > 0 || U_statistics[tokenAddress][3] > 0) { 
687 		
688 		uint256 utilityamount 		= U_statistics[tokenAddress][1];					// [1] Utility Vault
689 		uint256 burnamount 			= U_statistics[tokenAddress][3]; 					// [3] Utility Burn
690 		
691 		uint256 fee 				= add(utilityamount, burnamount);
692 		
693 		ERC20Interface token 	= ERC20Interface(tokenAddress);      
694         require(token.balanceOf(address(this)) >= fee);
695 		
696 		Bigdata[tokenAddress][3]		= sub(Bigdata[tokenAddress][3], fee); 
697 		Bigdata[tokenAddress][7]		= add(Bigdata[tokenAddress][7], fee); 		
698 			
699 		token.transfer(EthereumNodes, utilityamount);
700 		U_statistics[tokenAddress][1] 	= 0;											// [1] Utility Vault
701 		
702 		token.transfer(0x000000000000000000000000000000000000dEaD, burnamount);
703 		Bigdata[tokenAddress][4]		= add(burnamount, Bigdata[tokenAddress][4]);	// [4] Total Burn
704 		U_statistics[tokenAddress][3] 	= 0;
705 
706 		emit onUtilityBurn(msg.sender, tokenAddress, utilityamount, burnamount, now);		
707 
708 		}
709     }
710 	
711 	
712 	/*==============================
713     =      SAFE MATH FUNCTIONS     =
714     ==============================*/  	
715 	
716 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
717 		if (a == 0) {
718 			return 0;
719 		}
720 		uint256 c = a * b; 
721 		require(c / a == b);
722 		return c;
723 	}
724 	
725 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
726 		require(b > 0); 
727 		uint256 c = a / b;
728 		return c;
729 	}
730 	
731 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
732 		require(b <= a);
733 		uint256 c = a - b;
734 		return c;
735 	}
736 	
737 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
738 		uint256 c = a + b;
739 		require(c >= a);
740 		return c;
741 	}
742     
743 }
744 
745 
746 	/*==============================
747     =        ERC20 Interface       =
748     ==============================*/ 
749 
750 contract ERC20Interface {
751 
752     uint256 public totalSupply;
753     uint256 public decimals;
754     
755     function symbol() public view returns (string);
756     function balanceOf(address _owner) public view returns (uint256 balance);
757     function transfer(address _to, uint256 _value) public returns (bool success);
758     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
759     function approve(address _spender, uint256 _value) public returns (bool success);
760     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
761 
762     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
763     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
764 }