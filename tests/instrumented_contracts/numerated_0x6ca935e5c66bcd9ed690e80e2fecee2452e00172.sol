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
18 */
19 
20 	/*==============================
21     =          Version 7.6         =
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
46 	event onClaimTokens		(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);			
47 	event onHoldplatform	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);	
48 	event onAddContractAddress(address indexed hodler, address indexed contracthodler, uint256 Currentprice, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth, uint256 _HodlingTime);	
49 	
50 	event onHoldplatformsetting(address indexed hodler, address indexed Tokenairdrop, bool HPM_status, uint256 HPM_divider, uint256 HPM_ratio, uint256 datetime);	
51 	event onHoldplatformdeposit(address indexed hodler, uint256 amount, uint256 newbalance, uint256 datetime);	
52 	event onHoldplatformwithdraw(address indexed hodler, uint256 amount, uint256 newbalance, uint256 datetime);	
53 	event onReceiveAirdrop(address indexed hodler, uint256 amount, uint256 datetime);	
54 	
55 	/*==============================
56     =          VARIABLES           =
57     ==============================*/   
58 
59 	//-------o Affiliate = 12% o-------o Cashback = 16% o-------o Total Receive = 88% o-------o Without Cashback = 72% o-------o	
60 	
61 	// Struct Database
62 
63     struct Safe {
64         uint256 id;						// 01 -- > Registration Number
65         uint256 amount;					// 02 -- > Total amount of contribution to this transaction
66         uint256 endtime;				// 03 -- > The Expiration Of A Hold Platform Based On Unix Time
67         address user;					// 04 -- > The ETH address that you are using
68         address tokenAddress;			// 05 -- > The Token Contract Address That You Are Using
69 		string  tokenSymbol;			// 06 -- > The Token Symbol That You Are Using
70 		uint256 amountbalance; 			// 07 -- > 88% from Contribution / 72% Without Cashback
71 		uint256 cashbackbalance; 		// 08 -- > 16% from Contribution / 0% Without Cashback
72 		uint256 lasttime; 				// 09 -- > The Last Time You Withdraw Based On Unix Time
73 		uint256 percentage; 			// 10 -- > The percentage of tokens that are unlocked every month ( Default = 3% )
74 		uint256 percentagereceive; 		// 11 -- > The Percentage You Have Received
75 		uint256 tokenreceive; 			// 12 -- > The Number Of Tokens You Have Received
76 		uint256 lastwithdraw; 			// 13 -- > The Last Amount You Withdraw
77 		address referrer; 				// 14 -- > Your ETH referrer address
78 		bool 	cashbackstatus; 		// 15 -- > Cashback Status
79     }
80 	
81 	uint256 private idnumber; 										// 01 -- > ID number ( Start from 500 )				
82 	uint256 public  TotalUser; 										// 02 -- > Total Smart Contract User				
83 		
84 	mapping(address => address) 		public cashbackcode; 		// 03 -- > Cashback Code 					
85 	mapping(address => uint256[]) 		public idaddress;			// 04 -- > Search Address by ID			
86 	mapping(address => address[]) 		public afflist;				// 05 -- > Affiliate List by ID					
87 	mapping(address => string) 			public ContractSymbol; 		// 06 -- > Contract Address Symbol				
88 	mapping(uint256 => Safe) 			private _safes; 			// 07 -- > Struct safe database	
89 	mapping(address => bool) 			public contractaddress; 	// 08 -- > Contract Address 	
90 	
91 	mapping(address => uint256) 		public percent; 			// 09 -- > Monthly Unlock Percentage (Default 3%)
92 	mapping(address => uint256) 		public hodlingTime; 		// 10 -- > Length of hold time in seconds
93 	mapping(address => uint256) 		public TokenBalance; 		// 11 -- > Token Balance							
94 	mapping(address => uint256) 		public maxcontribution; 	// 12 -- > Maximum Contribution					
95 	mapping(address => uint256) 		public AllContribution; 	// 13 -- > Deposit amount for all members		
96 	mapping(address => uint256) 		public AllPayments; 		// 14 -- > Withdraw amount for all members		
97 	mapping(address => uint256) 		public activeuser; 			// 15 -- > Active User Status
98 	
99 	mapping(uint256 => uint256) 		public TXCount; 			
100 	//1st uint256, Category >>> 1 = Total User, 2 = Total TX Hold, 3 = Total TX Unlock, 4 = Total TX Airdrop, 5 = Total TX Affiliate Withdraw
101 
102 	mapping (address => mapping (uint256 => uint256)) 	public token_price; 				
103 	//2th uint256, Category >>> 1 = Current Price, 2 = ATH Price, 3 = ATL Price		
104 			
105 	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
106 	//3rd uint256, Category >>> 1 = LifetimeContribution, 2 = LifetimePayments, 3 = Affiliatevault, 4 = Affiliateprofit, 5 = ActiveContribution
107 	
108 		// Airdrop - Hold Platform (HPM)
109 								
110 	address public Holdplatform_address;	
111 	uint256 public Holdplatform_balance; 	
112 	mapping(address => bool) 	public Holdplatform_status;
113 	mapping(address => uint256) public Holdplatform_divider; 	
114 	
115 	/*==============================
116     =          CONSTRUCTOR         =
117     ==============================*/  	
118    
119     constructor() public {     	 	
120         idnumber 				= 500;
121 		Holdplatform_address	= 0x23bAdee11Bf49c40669e9b09035f048e9146213e;	//Change before deploy
122     }
123     
124 	
125 	/*==============================
126     =    AVAILABLE FOR EVERYONE    =
127     ==============================*/  
128 
129 //-------o Function 01 - Ethereum Payable
130 
131     function () public payable {    
132         revert();	 
133     }
134 	
135 	
136 //-------o Function 02 - Cashback Code
137 
138     function CashbackCode(address _cashbackcode) public {		
139 		require(_cashbackcode != msg.sender);		
140 		if (cashbackcode[msg.sender] == 0 && activeuser[_cashbackcode] >= 1) { 
141 		cashbackcode[msg.sender] = _cashbackcode; }
142 		else { cashbackcode[msg.sender] = EthereumNodes; }		
143 		
144 	emit onCashbackCode(msg.sender, _cashbackcode);		
145     } 
146 	
147 //-------o Function 03 - Contribute 
148 
149 	//--o 01
150     function Holdplatform(address tokenAddress, uint256 amount) public {
151         require(tokenAddress != 0x0);
152 		require(amount > 0 && add(Statistics[msg.sender][tokenAddress][5], amount) <= maxcontribution[tokenAddress] );
153 		
154 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
155 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
156         require(token.transferFrom(msg.sender, address(this), amount));	
157 		
158 		HodlTokens2(tokenAddress, amount);}							
159 	}
160 	
161 		//--o 02	
162     function HodlTokens2(address tokenAddress, uint256 amount) private {
163 		
164 		if (Holdplatform_status[tokenAddress] == true) {
165 		require(Holdplatform_balance > 0 );
166 		
167 		uint256 divider 		= Holdplatform_divider[tokenAddress];
168 		uint256 airdrop			= div(amount, divider);
169 		
170 		address airdropaddress	= Holdplatform_address;
171 		ERC20Interface token 	= ERC20Interface(airdropaddress);        
172         token.transfer(msg.sender, airdrop);
173 		
174 		Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
175 		TXCount[4]++;
176 	
177 		emit onReceiveAirdrop(msg.sender, airdrop, now);
178 		}	
179 		
180 		HodlTokens3(tokenAddress, amount);
181 	}
182 	
183 	
184 	//--o 03	
185     function HodlTokens3(address ERC, uint256 amount) private {
186 		
187 		uint256 AvailableBalances 					= div(mul(amount, 72), 100);	
188 		
189 		if (cashbackcode[msg.sender] == 0 ) { //--o  Hold without cashback code
190 		
191 			address ref								= EthereumNodes;
192 			cashbackcode[msg.sender] 				= EthereumNodes;
193 			uint256 AvailableCashback 				= 0; 			
194 			uint256 zerocashback 					= div(mul(amount, 28), 100); 
195 			Statistics[EthereumNodes][ERC][3] 		= add(Statistics[EthereumNodes][ERC][3], zerocashback);
196 			Statistics[EthereumNodes][ERC][4]		= add(Statistics[EthereumNodes][ERC][4], zerocashback); 		
197 			
198 		} else { 	//--o  Cashback code has been activated
199 		
200 			ref										= cashbackcode[msg.sender];
201 			uint256 affcomission 					= div(mul(amount, 12), 100); 	
202 			AvailableCashback 						= div(mul(amount, 16), 100);			
203 			uint256 ReferrerContribution 			= Statistics[ref][ERC][5];		
204 			uint256 ReferralContribution			= add(Statistics[ref][ERC][5], amount);
205 			
206 			if (ReferrerContribution >= ReferralContribution) { //--o  if referrer contribution >= referral contribution
207 		
208 				Statistics[ref][ERC][3] 			= add(Statistics[ref][ERC][3], affcomission); 
209 				Statistics[ref][ERC][4] 			= add(Statistics[ref][ERC][4], affcomission); 	
210 				
211 			} else {											//--o  if referral contribution > referrer contribution
212 			
213 				uint256 Newbie 						= div(mul(ReferrerContribution, 12), 100); 			
214 				Statistics[ref][ERC][3]				= add(Statistics[ref][ERC][3], Newbie); 
215 				Statistics[ref][ERC][4] 			= add(Statistics[ref][ERC][4], Newbie); 
216 				
217 				uint256 NodeFunds 					= sub(affcomission, Newbie);	
218 				Statistics[EthereumNodes][ERC][3] 	= add(Statistics[EthereumNodes][ERC][3], NodeFunds);
219 				Statistics[EthereumNodes][ERC][4] 	= add(Statistics[EthereumNodes][ERC][4], NodeFunds); 				
220 			}
221 		} 
222 
223 		HodlTokens4(ERC, amount, AvailableBalances, AvailableCashback, ref); 	
224 	}
225 	//--o 04	
226     function HodlTokens4(address ERC, uint256 amount, uint256 AvailableBalances, uint256 AvailableCashback, address ref) private {
227 	    
228 	    ERC20Interface token 	= ERC20Interface(ERC); 	
229 		uint256 TokenPercent 	= percent[ERC];	
230 		uint256 TokenHodlTime 	= hodlingTime[ERC];	
231 		uint256 HodlTime		= add(now, TokenHodlTime);
232 		
233 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
234 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
235 		
236 		_safes[idnumber] = Safe(idnumber, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
237 				
238 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
239 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
240 		AllContribution[ERC] 					= add(AllContribution[ERC], AM);   	
241         TokenBalance[ERC] 						= add(TokenBalance[ERC], AM);  
242 
243 		if(activeuser[msg.sender] == 1 ) {
244         idaddress[msg.sender].push(idnumber); idnumber++; TXCount[2]++;  }		
245 		else { 
246 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; TXCount[1]++; TXCount[2]++; TotalUser++;   }
247 		
248 		activeuser[msg.sender] 					= 1;  	
249 		
250         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);		
251 			
252 	}
253 
254 //-------o Function 05 - Claim Token That Has Been Unlocked
255     function ClaimTokens(address tokenAddress, uint256 id) public {
256         require(tokenAddress != 0x0);
257         require(id != 0);        
258         
259         Safe storage s = _safes[id];
260         require(s.user == msg.sender);  
261 		require(s.tokenAddress == tokenAddress);
262 		
263 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
264     }
265     //--o 01
266     function UnlockToken2(address ERC, uint256 id) private {
267         Safe storage s = _safes[id];      
268         require(s.id != 0);
269         require(s.tokenAddress == ERC);
270 
271         uint256 eventAmount				= s.amountbalance;
272         address eventTokenAddress 		= s.tokenAddress;
273         string memory eventTokenSymbol 	= s.tokenSymbol;		
274 		     
275         if(s.endtime < now){ //--o  Hold Complete
276         
277 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
278 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
279 		s.lastwithdraw 							= s.amountbalance;   s.amountbalance = 0;   s.lasttime = now;  		
280 		PayToken(s.user, s.tokenAddress, amounttransfer); 
281 		
282 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
283             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
284             }
285 			else {
286 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
287 			}
288 			
289 		s.cashbackbalance = 0;	
290 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
291 		
292         } else { UnlockToken3(ERC, s.id); }
293         
294     }   
295 	//--o 02
296 	function UnlockToken3(address ERC, uint256 id) private {		
297 		Safe storage s = _safes[id];
298         
299         require(s.id != 0);
300         require(s.tokenAddress == ERC);		
301 			
302 		uint256 timeframe  			= sub(now, s.lasttime);			                            
303 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
304 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
305 		                         
306 		uint256 MaxWithdraw 		= div(s.amount, 10);
307 			
308 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
309 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
310 			
311 		//--o Maximum withdraw = User Amount Balance   
312 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
313 			
314 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
315 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount1);
316 		s.cashbackbalance 			= 0; 
317 		s.amountbalance 			= newamountbalance;
318 		s.lastwithdraw 				= realAmount; 
319 		s.lasttime 					= now; 		
320 			
321 		UnlockToken4(ERC, id, newamountbalance, realAmount);		
322     }   
323 	//--o 03
324     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
325         Safe storage s = _safes[id];
326         
327         require(s.id != 0);
328         require(s.tokenAddress == ERC);
329 
330         uint256 eventAmount				= realAmount;
331         address eventTokenAddress 		= s.tokenAddress;
332         string memory eventTokenSymbol 	= s.tokenSymbol;		
333 
334 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
335 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ; 	
336 		
337 			if (cashbackcode[msg.sender] == EthereumNodes  ) {
338 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
339 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
340 			
341 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
342 		
343 		s.tokenreceive 					= tokenreceived; 
344 		s.percentagereceive 			= percentagereceived; 		
345 
346 		PayToken(s.user, s.tokenAddress, realAmount);           		
347 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
348     } 
349 	//--o Pay Token
350     function PayToken(address user, address tokenAddress, uint256 amount) private {
351         
352         ERC20Interface token = ERC20Interface(tokenAddress);        
353         require(token.balanceOf(address(this)) >= amount);
354         token.transfer(user, amount);
355 		
356 		TokenBalance[tokenAddress] 					= sub(TokenBalance[tokenAddress], amount); 
357 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
358 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
359 		
360 		TXCount[3]++;
361 
362 		Airdrop(tokenAddress, amount);   
363 	}
364 	
365 //-------o Function 05 - Airdrop
366 
367     function Airdrop(address tokenAddress, uint256 amount) private {
368 		
369 		if (Holdplatform_status[tokenAddress] == true) {
370 		require(Holdplatform_balance > 0 );
371 		
372 		uint256 divider 		= Holdplatform_divider[tokenAddress];
373 		uint256 airdrop			= div(div(amount, divider), 4);
374 		
375 		address airdropaddress	= Holdplatform_address;
376 		ERC20Interface token 	= ERC20Interface(airdropaddress);        
377         token.transfer(msg.sender, airdrop);
378 		
379 		Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
380 		TXCount[4]++;
381 		
382 		emit onReceiveAirdrop(msg.sender, airdrop, now);
383 		}	
384 	}
385 	
386 //-------o Function 06 - Get How Many Contribute ?
387 
388     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
389         return idaddress[hodler].length;
390     }
391 	
392 //-------o Function 07 - Get How Many Affiliate ?
393 
394     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
395         return afflist[hodler].length;
396     }
397     
398 //-------o Function 08 - Get complete data from each user
399 	function GetSafe(uint256 _id) public view
400         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
401     {
402         Safe storage s = _safes[_id];
403         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
404     }
405 	
406 //-------o Function 09 - Withdraw Affiliate Bonus
407 
408     function WithdrawAffiliate(address user, address tokenAddress) public {  
409 		require(tokenAddress != 0x0);		
410 		require(Statistics[user][tokenAddress][3] > 0 );
411 		
412 		uint256 amount = Statistics[msg.sender][tokenAddress][3];
413 		Statistics[msg.sender][tokenAddress][3] = 0;
414 		
415 		TokenBalance[tokenAddress] 		= sub(TokenBalance[tokenAddress], amount); 
416 		AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], amount);
417 		
418 		uint256 eventAmount				= amount;
419         address eventTokenAddress 		= tokenAddress;
420         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
421         
422         ERC20Interface token = ERC20Interface(tokenAddress);        
423         require(token.balanceOf(address(this)) >= amount);
424         token.transfer(user, amount);
425 		
426 		Statistics[user][tokenAddress][2] 	= add(Statistics[user][tokenAddress][2], amount);
427 
428 		TXCount[5]++;		
429 		
430 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
431     } 		
432 	
433 	
434 	/*==============================
435     =          RESTRICTED          =
436     ==============================*/  	
437 
438 //-------o 01 Add Contract Address	
439     function AddContractAddress(address tokenAddress, uint256 Currentprice, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
440 		uint256 newSpeed	= _PercentPermonth;
441 		require(newSpeed >= 3 && newSpeed <= 12);
442 		
443 		percent[tokenAddress] 			= newSpeed;	
444 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
445 		maxcontribution[tokenAddress] 	= _maxcontribution;	
446 		
447 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
448 		uint256 HodlTime 				= _HodlingTime * 1 days;		
449 		hodlingTime[tokenAddress] 		= HodlTime;	
450 		
451 		token_price[tokenAddress][1] 	= Currentprice;
452 		contractaddress[tokenAddress] 	= true;
453 		
454 		emit onAddContractAddress(msg.sender, tokenAddress, Currentprice, _maxcontribution, _ContractSymbol, _PercentPermonth, HodlTime);
455     }
456 	
457 //-------o 02 - Update Token Price (USD)
458 	
459 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice) public restricted  {
460 		
461 		if (Currentprice > 0  ) { token_price[tokenAddress][1] = Currentprice; }
462 		if (ATHprice > 0  ) { token_price[tokenAddress][2] = ATHprice; }
463 		if (ATLprice > 0  ) { token_price[tokenAddress][3] = ATLprice; }
464 
465     }
466 	
467 //-------o 03 Hold Platform
468     function Holdplatform_Airdrop(address tokenAddress, bool HPM_status, uint256 HPM_divider) public restricted {
469 		
470 		Holdplatform_status[tokenAddress] 	= HPM_status;	
471 		Holdplatform_divider[tokenAddress] 	= HPM_divider;	// Airdrop = 100% : Divider
472 		uint256 HPM_ratio					= div(100, HPM_divider);
473 		
474 		emit onHoldplatformsetting(msg.sender, tokenAddress, HPM_status, HPM_divider, HPM_ratio, now);
475 	
476     }	
477 	//--o Deposit
478 	function Holdplatform_Deposit(uint256 amount) restricted public {
479 		require(amount > 0 );
480         
481        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
482         require(token.transferFrom(msg.sender, address(this), amount));
483 		
484 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
485 		Holdplatform_balance 	= newbalance;
486 		
487 		emit onHoldplatformdeposit(msg.sender, amount, newbalance, now);
488     }
489 	//--o Withdraw
490 	function Holdplatform_Withdraw(uint256 amount) restricted public {
491         require(Holdplatform_balance > 0);
492         
493 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
494 		Holdplatform_balance 	= newbalance;
495         
496         ERC20Interface token = ERC20Interface(Holdplatform_address);
497         
498         require(token.balanceOf(address(this)) >= amount);
499         token.transfer(msg.sender, amount);
500 		
501 		emit onHoldplatformwithdraw(msg.sender, amount, newbalance, now);
502     }
503 	
504 //-------o 04 - Return All Tokens To Their Respective Addresses    
505     function ReturnAllTokens() restricted public
506     {
507 
508         for(uint256 i = 1; i < idnumber; i++) {            
509             Safe storage s = _safes[i];
510             if (s.id != 0) {
511 				
512 				if(s.amountbalance > 0) {
513 					uint256 amount = add(s.amountbalance, s.cashbackbalance);
514 					PayToken(s.user, s.tokenAddress, amount);
515 					
516 				}
517 				
518 
519                 
520             }
521         }
522 		
523     }   
524 	
525 	
526 	/*==============================
527     =      SAFE MATH FUNCTIONS     =
528     ==============================*/  	
529 	
530 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
531 		if (a == 0) {
532 			return 0;
533 		}
534 		uint256 c = a * b; 
535 		require(c / a == b);
536 		return c;
537 	}
538 	
539 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
540 		require(b > 0); 
541 		uint256 c = a / b;
542 		return c;
543 	}
544 	
545 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
546 		require(b <= a);
547 		uint256 c = a - b;
548 		return c;
549 	}
550 	
551 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
552 		uint256 c = a + b;
553 		require(c >= a);
554 		return c;
555 	}
556     
557 }
558 
559 
560 	/*==============================
561     =        ERC20 Interface       =
562     ==============================*/ 
563 
564 contract ERC20Interface {
565 
566     uint256 public totalSupply;
567     uint256 public decimals;
568     
569     function symbol() public view returns (string);
570     function balanceOf(address _owner) public view returns (uint256 balance);
571     function transfer(address _to, uint256 _value) public returns (bool success);
572     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
573     function approve(address _spender, uint256 _value) public returns (bool success);
574     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
575 
576     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
577     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
578 }