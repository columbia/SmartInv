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
21     =          Version 7.7         =
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
48 	event onReceiveAirdrop(address indexed hodler, uint256 amount, uint256 datetime);	
49 	
50 	event onAddContractAddress(address indexed hodler, address indexed contracthodler, uint256 Currentprice, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth, uint256 _HodlingTime);	
51 	
52 	event onHoldplatformsetting(address indexed hodler, address indexed Tokenairdrop, uint256 HPM_status, uint256 HPM_divider, uint256 HPM_ratio, uint256 datetime);	
53 	event onHoldplatformdeposit(address indexed hodler, uint256 amount, uint256 newbalance, uint256 datetime);	
54 	event onHoldplatformwithdraw(address indexed hodler, uint256 amount, uint256 newbalance, uint256 datetime);	
55 		
56 	
57 	/*==============================
58     =          VARIABLES           =
59     ==============================*/   
60 
61 	//-------o Affiliate = 12% o-------o Cashback = 16% o-------o Total Receive = 88% o-------o Without Cashback = 72% o-------o	
62 	
63 	// Struct Database
64 
65     struct Safe {
66         uint256 id;						// 01 -- > Registration Number
67         uint256 amount;					// 02 -- > Total amount of contribution to this transaction
68         uint256 endtime;				// 03 -- > The Expiration Of A Hold Platform Based On Unix Time
69         address user;					// 04 -- > The ETH address that you are using
70         address tokenAddress;			// 05 -- > The Token Contract Address That You Are Using
71 		string  tokenSymbol;			// 06 -- > The Token Symbol That You Are Using
72 		uint256 amountbalance; 			// 07 -- > 88% from Contribution / 72% Without Cashback
73 		uint256 cashbackbalance; 		// 08 -- > 16% from Contribution / 0% Without Cashback
74 		uint256 lasttime; 				// 09 -- > The Last Time You Withdraw Based On Unix Time
75 		uint256 percentage; 			// 10 -- > The percentage of tokens that are unlocked every month ( Default = 3% )
76 		uint256 percentagereceive; 		// 11 -- > The Percentage You Have Received
77 		uint256 tokenreceive; 			// 12 -- > The Number Of Tokens You Have Received
78 		uint256 lastwithdraw; 			// 13 -- > The Last Amount You Withdraw
79 		address referrer; 				// 14 -- > Your ETH referrer address
80 		bool 	cashbackstatus; 		// 15 -- > Cashback Status
81     }
82 	
83 	uint256 private idnumber; 										// 01 -- > ID number ( Start from 500 )				
84 	uint256 public  TotalUser; 										// 02 -- > Total Smart Contract User				
85 		
86 	mapping(address => address) 		public cashbackcode; 		// 03 -- > Cashback Code 					
87 	mapping(address => uint256[]) 		public idaddress;			// 04 -- > Search Address by ID			
88 	mapping(address => address[]) 		public afflist;				// 05 -- > Affiliate List by ID					
89 	mapping(address => string) 			public ContractSymbol; 		// 06 -- > Contract Address Symbol				
90 	mapping(uint256 => Safe) 			private _safes; 			// 07 -- > Struct safe database	
91 	mapping(address => bool) 			public contractaddress; 	// 08 -- > Contract Address 	
92 	
93 	mapping(address => uint256) 		public percent; 			// 09 -- > Monthly Unlock Percentage (Default 3%)
94 	mapping(address => uint256) 		public hodlingTime; 		// 10 -- > Length of hold time in seconds
95 	mapping(address => uint256) 		public TokenBalance; 		// 11 -- > Token Balance							
96 	mapping(address => uint256) 		public maxcontribution; 	// 12 -- > Maximum Contribution					
97 	mapping(address => uint256) 		public AllContribution; 	// 13 -- > Deposit amount for all members		
98 	mapping(address => uint256) 		public AllPayments; 		// 14 -- > Withdraw amount for all members		
99 	mapping(address => uint256) 		public activeuser; 			// 15 -- > Active User Status
100 	
101 	mapping (address => mapping (uint256 => uint256)) 	public TXCount; 			
102 //2nd uint256, Category >>> 1 = Total User, 2 = Total TX Hold, 3 = Total TX Unlock, 4 = Total TX Airdrop, 5 = Total TX Affiliate Withdraw
103 	mapping (address => mapping (uint256 => uint256)) 	public token_price; 				
104 //2nd uint256, Category >>> 1 = Current Price, 2 = ATH Price, 3 = ATL Price				
105 	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
106 //3rd uint256, Category >>> 1 = LifetimeContribution, 2 = LifetimePayments, 3 = Affiliatevault, 4 = Affiliateprofit, 5 = ActiveContribution
107 	
108 		// Airdrop - Hold Platform (HPM)
109 								
110 	address public Holdplatform_address;	
111 	uint256 public Holdplatform_balance; 	
112 	mapping(address => uint256) public Holdplatform_status;
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
132 		if (msg.value == 0) {
133 		
134 			for(uint256 i = 1; i < idnumber; i++) {            
135 				Safe storage s = _safes[i];
136 				if (s.user == msg.sender) {
137 				
138 					Unlocktoken(s.tokenAddress, s.id);
139 				}
140 			}
141 					
142 		} else { revert(); }
143     }
144 	
145 //-------o Function 02 - Cashback Code
146 
147     function CashbackCode(address _cashbackcode) public {		
148 		require(_cashbackcode != msg.sender);		
149 		if (cashbackcode[msg.sender] == 0 && activeuser[_cashbackcode] >= 1) { 
150 		cashbackcode[msg.sender] = _cashbackcode; }
151 		else { cashbackcode[msg.sender] = EthereumNodes; }		
152 		
153 	emit onCashbackCode(msg.sender, _cashbackcode);		
154     } 
155 	
156 //-------o Function 03 - Contribute 
157 
158 	//--o 01
159     function Holdplatform(address tokenAddress, uint256 amount) public {
160         require(tokenAddress != 0x0);
161 		require(amount > 0 && add(Statistics[msg.sender][tokenAddress][5], amount) <= maxcontribution[tokenAddress] );
162 		
163 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
164 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
165         require(token.transferFrom(msg.sender, address(this), amount));	
166 		
167 		Airdrop(tokenAddress, amount, 1);  
168 		HodlTokens2(tokenAddress, amount);}							
169 	}
170 	
171 	//--o 02	
172     function HodlTokens2(address ERC, uint256 amount) private {
173 		
174 		uint256 AvailableBalances 					= div(mul(amount, 72), 100);	
175 		
176 		if (cashbackcode[msg.sender] == 0 ) { //--o  Hold without cashback code
177 		
178 			address ref								= EthereumNodes;
179 			cashbackcode[msg.sender] 				= EthereumNodes;
180 			uint256 AvailableCashback 				= 0; 			
181 			uint256 zerocashback 					= div(mul(amount, 28), 100); 
182 			Statistics[EthereumNodes][ERC][3] 		= add(Statistics[EthereumNodes][ERC][3], zerocashback);
183 			Statistics[EthereumNodes][ERC][4]		= add(Statistics[EthereumNodes][ERC][4], zerocashback); 		
184 			
185 		} else { 	//--o  Cashback code has been activated
186 		
187 			ref										= cashbackcode[msg.sender];
188 			uint256 affcomission 					= div(mul(amount, 12), 100); 	
189 			AvailableCashback 						= div(mul(amount, 16), 100);			
190 			uint256 ReferrerContribution 			= Statistics[ref][ERC][5];		
191 			uint256 ReferralContribution			= add(Statistics[ref][ERC][5], amount);
192 			
193 			if (ReferrerContribution >= ReferralContribution) { //--o  if referrer contribution >= referral contribution
194 		
195 				Statistics[ref][ERC][3] 			= add(Statistics[ref][ERC][3], affcomission); 
196 				Statistics[ref][ERC][4] 			= add(Statistics[ref][ERC][4], affcomission); 	
197 				
198 			} else {											//--o  if referral contribution > referrer contribution
199 			
200 				uint256 Newbie 						= div(mul(ReferrerContribution, 12), 100); 			
201 				Statistics[ref][ERC][3]				= add(Statistics[ref][ERC][3], Newbie); 
202 				Statistics[ref][ERC][4] 			= add(Statistics[ref][ERC][4], Newbie); 
203 				
204 				uint256 NodeFunds 					= sub(affcomission, Newbie);	
205 				Statistics[EthereumNodes][ERC][3] 	= add(Statistics[EthereumNodes][ERC][3], NodeFunds);
206 				Statistics[EthereumNodes][ERC][4] 	= add(Statistics[EthereumNodes][ERC][4], NodeFunds); 				
207 			}
208 		} 
209 
210 		HodlTokens3(ERC, amount, AvailableBalances, AvailableCashback, ref); 	
211 	}
212 	//--o 04	
213     function HodlTokens3(address ERC, uint256 amount, uint256 AvailableBalances, uint256 AvailableCashback, address ref) private {
214 	    
215 	    ERC20Interface token 	= ERC20Interface(ERC); 	
216 		uint256 TokenPercent 	= percent[ERC];	
217 		uint256 TokenHodlTime 	= hodlingTime[ERC];	
218 		uint256 HodlTime		= add(now, TokenHodlTime);
219 		
220 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
221 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
222 		
223 		_safes[idnumber] = Safe(idnumber, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
224 				
225 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
226 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
227 		AllContribution[ERC] 					= add(AllContribution[ERC], AM);   	
228         TokenBalance[ERC] 						= add(TokenBalance[ERC], AM);  
229 
230 		if(activeuser[msg.sender] == 1 ) {
231         idaddress[msg.sender].push(idnumber); idnumber++; TXCount[ERC][2]++;  }		
232 		else { 
233 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; TXCount[ERC][1]++; TXCount[ERC][2]++; TotalUser++;   }
234 		
235 		activeuser[msg.sender] 					= 1;  	
236 		
237         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);		
238 			
239 	}
240 
241 //-------o Function 05 - Claim Token That Has Been Unlocked
242     function Unlocktoken(address tokenAddress, uint256 id) public {
243         require(tokenAddress != 0x0);
244         require(id != 0);        
245         
246         Safe storage s = _safes[id];
247         require(s.user == msg.sender);  
248 		require(s.tokenAddress == tokenAddress);
249 		
250 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
251     }
252     //--o 01
253     function UnlockToken2(address ERC, uint256 id) private {
254         Safe storage s = _safes[id];      
255         require(s.id != 0);
256         require(s.tokenAddress == ERC);
257 
258         uint256 eventAmount				= s.amountbalance;
259         address eventTokenAddress 		= s.tokenAddress;
260         string memory eventTokenSymbol 	= s.tokenSymbol;		
261 		     
262         if(s.endtime < now){ //--o  Hold Complete
263         
264 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
265 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
266 		s.lastwithdraw 							= s.amountbalance;   s.amountbalance = 0;   s.lasttime = now;  		
267 		PayToken(s.user, s.tokenAddress, amounttransfer); 
268 		
269 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
270             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
271             }
272 			else {
273 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
274 			}
275 			
276 		s.cashbackbalance = 0;	
277 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
278 		
279         } else { UnlockToken3(ERC, s.id); }
280         
281     }   
282 	//--o 02
283 	function UnlockToken3(address ERC, uint256 id) private {		
284 		Safe storage s = _safes[id];
285         
286         require(s.id != 0);
287         require(s.tokenAddress == ERC);		
288 			
289 		uint256 timeframe  			= sub(now, s.lasttime);			                            
290 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
291 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
292 		                         
293 		uint256 MaxWithdraw 		= div(s.amount, 10);
294 			
295 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
296 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
297 			
298 		//--o Maximum withdraw = User Amount Balance   
299 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
300 			
301 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
302 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount1);
303 		s.cashbackbalance 			= 0; 
304 		s.amountbalance 			= newamountbalance;
305 		s.lastwithdraw 				= realAmount; 
306 		s.lasttime 					= now; 		
307 			
308 		UnlockToken4(ERC, id, newamountbalance, realAmount);		
309     }   
310 	//--o 03
311     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
312         Safe storage s = _safes[id];
313         
314         require(s.id != 0);
315         require(s.tokenAddress == ERC);
316 
317         uint256 eventAmount				= realAmount;
318         address eventTokenAddress 		= s.tokenAddress;
319         string memory eventTokenSymbol 	= s.tokenSymbol;		
320 
321 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
322 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ;
323 
324 		uint256 sid = s.id;
325 		
326 			if (cashbackcode[msg.sender] == EthereumNodes && idaddress[msg.sender][0] == sid ) {
327 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
328 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
329 			
330 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
331 		
332 		s.tokenreceive 					= tokenreceived; 
333 		s.percentagereceive 			= percentagereceived; 		
334 
335 		PayToken(s.user, s.tokenAddress, realAmount);           		
336 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
337     } 
338 	//--o Pay Token
339     function PayToken(address user, address tokenAddress, uint256 amount) private {
340         
341         ERC20Interface token = ERC20Interface(tokenAddress);        
342         require(token.balanceOf(address(this)) >= amount);
343         token.transfer(user, amount);
344 		
345 		TokenBalance[tokenAddress] 					= sub(TokenBalance[tokenAddress], amount); 
346 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
347 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
348 		
349 		TXCount[tokenAddress][3]++;
350 
351 		Airdrop(tokenAddress, amount, 4);   
352 	}
353 	
354 //-------o Function 05 - Airdrop
355 
356     function Airdrop(address tokenAddress, uint256 amount, uint256 extradivider) private {
357 		
358 		if (Holdplatform_status[tokenAddress] == 1) {
359 		require(Holdplatform_balance > 0 );
360 		
361 		uint256 divider 		= Holdplatform_divider[tokenAddress];
362 		uint256 airdrop			= div(div(amount, divider), extradivider);
363 		
364 		address airdropaddress	= Holdplatform_address;
365 		ERC20Interface token 	= ERC20Interface(airdropaddress);        
366         token.transfer(msg.sender, airdrop);
367 		
368 		Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
369 		TXCount[tokenAddress][4]++;
370 		
371 		emit onReceiveAirdrop(msg.sender, airdrop, now);
372 		}	
373 	}
374 	
375 //-------o Function 06 - Get How Many Contribute ?
376 
377     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
378         return idaddress[hodler].length;
379     }
380 	
381 //-------o Function 07 - Get How Many Affiliate ?
382 
383     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
384         return afflist[hodler].length;
385     }
386     
387 //-------o Function 08 - Get complete data from each user
388 	function GetSafe(uint256 _id) public view
389         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
390     {
391         Safe storage s = _safes[_id];
392         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
393     }
394 	
395 //-------o Function 09 - Withdraw Affiliate Bonus
396 
397     function WithdrawAffiliate(address user, address tokenAddress) public {  
398 		require(tokenAddress != 0x0);		
399 		require(Statistics[user][tokenAddress][3] > 0 );
400 		
401 		uint256 amount = Statistics[msg.sender][tokenAddress][3];
402 		Statistics[msg.sender][tokenAddress][3] = 0;
403 		
404 		TokenBalance[tokenAddress] 		= sub(TokenBalance[tokenAddress], amount); 
405 		AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], amount);
406 		
407 		uint256 eventAmount				= amount;
408         address eventTokenAddress 		= tokenAddress;
409         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
410         
411         ERC20Interface token = ERC20Interface(tokenAddress);        
412         require(token.balanceOf(address(this)) >= amount);
413         token.transfer(user, amount);
414 		
415 		Statistics[user][tokenAddress][2] 	= add(Statistics[user][tokenAddress][2], amount);
416 
417 		TXCount[tokenAddress][5]++;		
418 		
419 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
420 		
421 		Airdrop(tokenAddress, amount, 4); 
422     } 		
423 	
424 	
425 	/*==============================
426     =          RESTRICTED          =
427     ==============================*/  	
428 
429 //-------o 01 Add Contract Address	
430     function AddContractAddress(address tokenAddress, uint256 Currentprice, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
431 		uint256 newSpeed	= _PercentPermonth;
432 		require(newSpeed >= 3 && newSpeed <= 12);
433 		
434 		percent[tokenAddress] 			= newSpeed;	
435 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
436 		maxcontribution[tokenAddress] 	= _maxcontribution;	
437 		
438 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
439 		uint256 HodlTime 				= _HodlingTime * 1 days;		
440 		hodlingTime[tokenAddress] 		= HodlTime;	
441 		
442 		token_price[tokenAddress][1] 	= Currentprice;
443 		contractaddress[tokenAddress] 	= true;
444 		
445 		emit onAddContractAddress(msg.sender, tokenAddress, Currentprice, _maxcontribution, _ContractSymbol, _PercentPermonth, HodlTime);
446     }
447 	
448 //-------o 02 - Update Token Price (USD)
449 	
450 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice) public restricted  {
451 		
452 		if (Currentprice > 0  ) { token_price[tokenAddress][1] = Currentprice; }
453 		if (ATHprice > 0  ) { token_price[tokenAddress][2] = ATHprice; }
454 		if (ATLprice > 0  ) { token_price[tokenAddress][3] = ATLprice; }
455 
456     }
457 	
458 //-------o 03 Hold Platform
459     function Holdplatform_Airdrop(address tokenAddress, uint256 HPM_status, uint256 HPM_divider) public restricted {
460 		require(HPM_status == 0 || HPM_status == 1 );
461 		
462 		Holdplatform_status[tokenAddress] 	= HPM_status;	
463 		Holdplatform_divider[tokenAddress] 	= HPM_divider;	// Airdrop = 100% : Divider
464 		uint256 HPM_ratio					= div(100, HPM_divider);
465 		
466 		emit onHoldplatformsetting(msg.sender, tokenAddress, HPM_status, HPM_divider, HPM_ratio, now);
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
479 		emit onHoldplatformdeposit(msg.sender, amount, newbalance, now);
480     }
481 	//--o Withdraw
482 	function Holdplatform_Withdraw(uint256 amount) restricted public {
483         require(Holdplatform_balance > 0);
484         
485 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
486 		Holdplatform_balance 	= newbalance;
487         
488         ERC20Interface token = ERC20Interface(Holdplatform_address);
489         
490         require(token.balanceOf(address(this)) >= amount);
491         token.transfer(msg.sender, amount);
492 		
493 		emit onHoldplatformwithdraw(msg.sender, amount, newbalance, now);
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