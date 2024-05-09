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
21     =          Version 7.8         =
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
131     function tothemoon() public payable {  
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
149 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 && activeuser[_cashbackcode] >= 1) { 
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
160 		require(amount >= 1 );
161 		uint256 holdamount	= add(Statistics[msg.sender][tokenAddress][5], amount);
162 		
163 		require(holdamount <= maxcontribution[tokenAddress] );
164 		
165 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
166 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
167         require(token.transferFrom(msg.sender, address(this), amount));	
168 		
169 		HodlTokens2(tokenAddress, amount);
170 		Airdrop(tokenAddress, amount, 1); 
171 		}							
172 	}
173 	
174 	//--o 02	
175     function HodlTokens2(address ERC, uint256 amount) private {
176 		
177 		uint256 AvailableBalances 					= div(mul(amount, 72), 100);	
178 		
179 		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 ) { //--o  Hold without cashback code
180 		
181 			address ref								= EthereumNodes;
182 			cashbackcode[msg.sender] 				= EthereumNodes;
183 			uint256 AvailableCashback 				= 0; 			
184 			uint256 zerocashback 					= div(mul(amount, 28), 100); 
185 			Statistics[EthereumNodes][ERC][3] 		= add(Statistics[EthereumNodes][ERC][3], zerocashback);
186 			Statistics[EthereumNodes][ERC][4]		= add(Statistics[EthereumNodes][ERC][4], zerocashback); 		
187 			
188 		} else { 	//--o  Cashback code has been activated
189 		
190 			ref										= cashbackcode[msg.sender];
191 			uint256 affcomission 					= div(mul(amount, 12), 100); 	
192 			AvailableCashback 						= div(mul(amount, 16), 100);			
193 			uint256 ReferrerContribution 			= Statistics[ref][ERC][5];		
194 			uint256 ReferralContribution			= add(Statistics[ref][ERC][5], amount);
195 			
196 			if (ReferrerContribution >= ReferralContribution) { //--o  if referrer contribution >= referral contribution
197 		
198 				Statistics[ref][ERC][3] 			= add(Statistics[ref][ERC][3], affcomission); 
199 				Statistics[ref][ERC][4] 			= add(Statistics[ref][ERC][4], affcomission); 	
200 				
201 			} else {											//--o  if referral contribution > referrer contribution
202 			
203 				uint256 Newbie 						= div(mul(ReferrerContribution, 12), 100); 			
204 				Statistics[ref][ERC][3]				= add(Statistics[ref][ERC][3], Newbie); 
205 				Statistics[ref][ERC][4] 			= add(Statistics[ref][ERC][4], Newbie); 
206 				
207 				uint256 NodeFunds 					= sub(affcomission, Newbie);	
208 				Statistics[EthereumNodes][ERC][3] 	= add(Statistics[EthereumNodes][ERC][3], NodeFunds);
209 				Statistics[EthereumNodes][ERC][4] 	= add(Statistics[EthereumNodes][ERC][4], NodeFunds); 				
210 			}
211 		} 
212 
213 		HodlTokens3(ERC, amount, AvailableBalances, AvailableCashback, ref); 	
214 	}
215 	//--o 04	
216     function HodlTokens3(address ERC, uint256 amount, uint256 AvailableBalances, uint256 AvailableCashback, address ref) private {
217 	    
218 	    ERC20Interface token 	= ERC20Interface(ERC); 	
219 		uint256 TokenPercent 	= percent[ERC];	
220 		uint256 TokenHodlTime 	= hodlingTime[ERC];	
221 		uint256 HodlTime		= add(now, TokenHodlTime);
222 		
223 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
224 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
225 		
226 		_safes[idnumber] = Safe(idnumber, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
227 				
228 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
229 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
230 		AllContribution[ERC] 					= add(AllContribution[ERC], AM);   	
231         TokenBalance[ERC] 						= add(TokenBalance[ERC], AM);  
232 
233 		if(activeuser[msg.sender] == 1 ) {
234         idaddress[msg.sender].push(idnumber); idnumber++; TXCount[ERC][2]++;  }		
235 		else { 
236 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; TXCount[ERC][1]++; TXCount[ERC][2]++; TotalUser++;   }
237 		
238 		activeuser[msg.sender] 					= 1;  	
239 		
240         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);		
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
269 		s.lastwithdraw 							= s.amountbalance;   s.amountbalance = 0;   s.lasttime = now;  		
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
350 		TokenBalance[tokenAddress] 					= sub(TokenBalance[tokenAddress], amount); 
351 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
352 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
353 		
354 		TXCount[tokenAddress][3]++;
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
372 		TXCount[tokenAddress][4]++;
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
407 		TokenBalance[tokenAddress] 		= sub(TokenBalance[tokenAddress], amount); 
408 		AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], amount);
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
420 		TXCount[tokenAddress][5]++;		
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
433     function AddContractAddress(address tokenAddress, uint256 Currentprice, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
434 		uint256 newSpeed	= _PercentPermonth;
435 		require(newSpeed >= 3 && newSpeed <= 12);
436 		
437 		percent[tokenAddress] 			= newSpeed;	
438 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
439 		maxcontribution[tokenAddress] 	= _maxcontribution;	
440 		
441 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
442 		uint256 HodlTime 				= _HodlingTime * 1 days;		
443 		hodlingTime[tokenAddress] 		= HodlTime;	
444 		
445 		token_price[tokenAddress][1] 	= Currentprice;
446 		contractaddress[tokenAddress] 	= true;
447 		
448 		emit onAddContractAddress(msg.sender, tokenAddress, Currentprice, _maxcontribution, _ContractSymbol, _PercentPermonth, HodlTime);
449     }
450 	
451 //-------o 02 - Update Token Price (USD)
452 	
453 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice) public restricted  {
454 		
455 		if (Currentprice > 0  ) { token_price[tokenAddress][1] = Currentprice; }
456 		if (ATHprice > 0  ) { token_price[tokenAddress][2] = ATHprice; }
457 		if (ATLprice > 0  ) { token_price[tokenAddress][3] = ATLprice; }
458 
459     }
460 	
461 //-------o 03 Hold Platform
462     function Holdplatform_Airdrop(address tokenAddress, uint256 HPM_status, uint256 HPM_divider) public restricted {
463 		require(HPM_status == 0 || HPM_status == 1 );
464 		
465 		Holdplatform_status[tokenAddress] 	= HPM_status;	
466 		Holdplatform_divider[tokenAddress] 	= HPM_divider;	// Airdrop = 100% : Divider
467 		uint256 HPM_ratio					= div(100, HPM_divider);
468 		
469 		emit onHoldplatformsetting(msg.sender, tokenAddress, HPM_status, HPM_divider, HPM_ratio, now);
470 	
471     }	
472 	//--o Deposit
473 	function Holdplatform_Deposit(uint256 amount) restricted public {
474 		require(amount > 0 );
475         
476        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
477         require(token.transferFrom(msg.sender, address(this), amount));
478 		
479 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
480 		Holdplatform_balance 	= newbalance;
481 		
482 		emit onHoldplatformdeposit(msg.sender, amount, newbalance, now);
483     }
484 	//--o Withdraw
485 	function Holdplatform_Withdraw(uint256 amount) restricted public {
486         require(Holdplatform_balance > 0 && amount <= Holdplatform_balance);
487         
488 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
489 		Holdplatform_balance 	= newbalance;
490         
491         ERC20Interface token = ERC20Interface(Holdplatform_address);
492         
493         require(token.balanceOf(address(this)) >= amount);
494         token.transfer(msg.sender, amount);
495 		
496 		emit onHoldplatformwithdraw(msg.sender, amount, newbalance, now);
497     }
498 	
499 //-------o 04 - Return All Tokens To Their Respective Addresses    
500     function ReturnAllTokens() restricted public
501     {
502 
503         for(uint256 i = 1; i < idnumber; i++) {            
504             Safe storage s = _safes[i];
505             if (s.id != 0) {
506 				
507 				if(s.amountbalance > 0) {
508 					uint256 amount = add(s.amountbalance, s.cashbackbalance);
509 					PayToken(s.user, s.tokenAddress, amount);
510 					s.amountbalance							= 0;
511 					s.cashbackbalance						= 0;
512 					Statistics[s.user][s.tokenAddress][5]	= 0;
513 				}
514             }
515         }
516     }   
517 	
518 	
519 	/*==============================
520     =      SAFE MATH FUNCTIONS     =
521     ==============================*/  	
522 	
523 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
524 		if (a == 0) {
525 			return 0;
526 		}
527 		uint256 c = a * b; 
528 		require(c / a == b);
529 		return c;
530 	}
531 	
532 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
533 		require(b > 0); 
534 		uint256 c = a / b;
535 		return c;
536 	}
537 	
538 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
539 		require(b <= a);
540 		uint256 c = a - b;
541 		return c;
542 	}
543 	
544 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
545 		uint256 c = a + b;
546 		require(c >= a);
547 		return c;
548 	}
549     
550 }
551 
552 
553 	/*==============================
554     =        ERC20 Interface       =
555     ==============================*/ 
556 
557 contract ERC20Interface {
558 
559     uint256 public totalSupply;
560     uint256 public decimals;
561     
562     function symbol() public view returns (string);
563     function balanceOf(address _owner) public view returns (uint256 balance);
564     function transfer(address _to, uint256 _value) public returns (bool success);
565     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
566     function approve(address _spender, uint256 _value) public returns (bool success);
567     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
568 
569     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
570     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
571 }