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
18  
19 */
20 
21 	/*==============================
22     =          Version 7.4         =
23     ==============================*/
24 	
25 contract EthereumSmartContract {    
26     address EthereumNodes; 
27 	
28     constructor() public { 
29         EthereumNodes = msg.sender;
30     }
31     modifier restricted() {
32         require(msg.sender == EthereumNodes);
33         _;
34     } 
35 	
36     function GetEthereumNodes() public view returns (address owner) { return EthereumNodes; }
37 }
38 
39 contract ldoh is EthereumSmartContract {
40 	
41 	/*==============================
42     =            EVENTS            =
43     ==============================*/
44 	
45 	event onCashbackCode	(address indexed hodler, address cashbackcode);		
46 	event onAffiliateBonus	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);		
47 	event onUnlocktoken		(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);			
48 	event onHoldplatform	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);	
49 	event onAddContractAddress(address indexed contracthodler, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth, uint256 _HodlingTime);	
50 	
51 	event onHoldplatformsetting(address indexed Tokenairdrop, bool HPM_status, uint256 HPM_divider, uint256 HPM_ratio, uint256 datetime);	
52 	event onHoldplatformdeposit(uint256 amount, uint256 newbalance, uint256 datetime);	
53 	event onHoldplatformwithdraw(uint256 amount, uint256 newbalance, uint256 datetime);	
54 	
55 	/*==============================
56     =          VARIABLES           =
57     ==============================*/   
58 
59 	address public DefaultToken;
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
101 
102 	mapping (address => mapping (uint256 => uint256)) 	public token_price; 				
103 	//2th uint256, Category >>> 1 = Current Price, 2 = ATH Price, 3 = ATL Price		
104 			
105 	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
106 	//3rd uint256, Category >>> 1 = LifetimeContribution, 2 = LifetimePayments, 3 = Affiliatevault, 4 = Affiliateprofit, 5 = ActiveContribution
107 	
108 	
109 		// Airdrop - Hold Platform (HPM)
110 								
111 	address public Holdplatform_address;	
112 	uint256 public Holdplatform_balance; 	
113 	mapping(address => bool) 	public Holdplatform_status;
114 	mapping(address => uint256) public Holdplatform_divider; 	
115 	
116  
117 	
118 	/*==============================
119     =          CONSTRUCTOR         =
120     ==============================*/  	
121    
122     constructor() public {     	 	
123         idnumber 			= 500;
124 		Holdplatform_address	= 0x23bAdee11Bf49c40669e9b09035f048e9146213e;	//Change before deploy
125     }
126     
127 	
128 	/*==============================
129     =    AVAILABLE FOR EVERYONE    =
130     ==============================*/  
131 
132 //-------o Function 01 - Ethereum Payable
133 
134     function () public payable {    
135         revert();	 
136     }
137 	
138 	
139 //-------o Function 02 - Cashback Code
140 
141     function CashbackCode(address _cashbackcode) public {		
142 		require(_cashbackcode != msg.sender);		
143 		if (cashbackcode[msg.sender] == 0 && activeuser[_cashbackcode] >= 1) { 
144 		cashbackcode[msg.sender] = _cashbackcode; }
145 		else { cashbackcode[msg.sender] = EthereumNodes; }		
146 		
147 	emit onCashbackCode(msg.sender, _cashbackcode);		
148     } 
149 	
150 //-------o Function 03 - Contribute 
151 
152 	//--o 01
153     function Holdplatform(address tokenAddress, uint256 amount) public {
154         require(tokenAddress != 0x0);
155 		require(amount > 0 && add(Statistics[msg.sender][tokenAddress][5], amount) <= maxcontribution[tokenAddress] );
156 		
157 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
158 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
159         require(token.transferFrom(msg.sender, address(this), amount));	
160 		
161 		HodlTokens2(tokenAddress, amount);}							
162 	}
163 	
164 		//--o 02	
165     function HodlTokens2(address tokenAddress, uint256 amount) private {
166 		
167 		if (Holdplatform_status[tokenAddress] == true) {
168 		require(Holdplatform_balance > 0 );
169 		
170 		uint256 divider 		= Holdplatform_divider[tokenAddress];
171 		uint256 airdrop			= div(amount, divider);
172 		
173 		address airdropaddress			= Holdplatform_address;
174 		ERC20Interface token 	= ERC20Interface(airdropaddress);        
175         token.transfer(msg.sender, airdrop);
176 		
177 		Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
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
195 			Statistics[EthereumNodes][ERC][4] 		= add(Statistics[EthereumNodes][ERC][3], zerocashback);
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
242 		activeuser[msg.sender] 					= 1;  		
243 		
244 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; TotalUser++;       
245         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);		
246 			
247 	}
248 
249 //-------o Function 05 - Claim Token That Has Been Unlocked
250     function Unlocktoken(address tokenAddress, uint256 id) public {
251         require(tokenAddress != 0x0);
252         require(id != 0);        
253         
254         Safe storage s = _safes[id];
255         require(s.user == msg.sender);  
256 		require(s.tokenAddress == tokenAddress);
257 		
258 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
259     }
260     //--o 01
261     function UnlockToken2(address ERC, uint256 id) private {
262         Safe storage s = _safes[id];      
263         require(s.id != 0);
264         require(s.tokenAddress == ERC);
265 
266         uint256 eventAmount				= s.amountbalance;
267         address eventTokenAddress 		= s.tokenAddress;
268         string memory eventTokenSymbol 	= s.tokenSymbol;		
269 		     
270         if(s.endtime < now){ //--o  Hold Complete
271         
272 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
273 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
274 		s.lastwithdraw 							= s.amountbalance;   s.amountbalance = 0;   s.lasttime = now;  		
275 		PayToken(s.user, s.tokenAddress, amounttransfer); 
276 		
277 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
278             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
279             }
280 			else {
281 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
282 			}
283 			
284 		s.cashbackbalance = 0;	
285 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
286 		
287         } else { UnlockToken3(ERC, s.id); }
288         
289     }   
290 	//--o 02
291 	function UnlockToken3(address ERC, uint256 id) private {		
292 		Safe storage s = _safes[id];
293         
294         require(s.id != 0);
295         require(s.tokenAddress == ERC);		
296 			
297 		uint256 timeframe  			= sub(now, s.lasttime);			                            
298 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
299 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
300 		                         
301 		uint256 MaxWithdraw 		= div(s.amount, 10);
302 			
303 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
304 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
305 			
306 		//--o Maximum withdraw = User Amount Balance   
307 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
308 			
309 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
310 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount);
311 		s.cashbackbalance 			= 0; 
312 		s.amountbalance 			= newamountbalance;
313 		s.lastwithdraw 				= realAmount; 
314 		s.lasttime 					= now; 		
315 			
316 		UnlockToken4(ERC, id, newamountbalance, realAmount);		
317     }   
318 	//--o 03
319     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
320         Safe storage s = _safes[id];
321         
322         require(s.id != 0);
323         require(s.tokenAddress == ERC);
324 
325         uint256 eventAmount				= realAmount;
326         address eventTokenAddress 		= s.tokenAddress;
327         string memory eventTokenSymbol 	= s.tokenSymbol;		
328 
329 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
330 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ; 	
331 		
332 			if (cashbackcode[msg.sender] == EthereumNodes || s.cashbackbalance > 0  ) {
333 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
334 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
335 			
336 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
337 		
338 		s.tokenreceive 					= tokenreceived; 
339 		s.percentagereceive 			= percentagereceived; 		
340 
341 		PayToken(s.user, s.tokenAddress, realAmount);           		
342 		emit onUnlocktoken(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
343     } 
344 	//--o Pay Token
345     function PayToken(address user, address tokenAddress, uint256 amount) private {
346         
347         ERC20Interface token = ERC20Interface(tokenAddress);        
348         require(token.balanceOf(address(this)) >= amount);
349         token.transfer(user, amount);
350 		
351 		TokenBalance[tokenAddress] 					= sub(TokenBalance[tokenAddress], amount); 
352 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
353 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
354     }  
355 	
356 //-------o Function 06 - Get How Many Contribute ?
357 
358     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
359         return idaddress[hodler].length;
360     }
361 	
362 //-------o Function 07 - Get How Many Affiliate ?
363 
364     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
365         return afflist[hodler].length;
366     }
367     
368 //-------o Function 08 - Get complete data from each user
369 	function GetSafe(uint256 _id) public view
370         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
371     {
372         Safe storage s = _safes[_id];
373         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
374     }
375 	
376 //-------o Function 09 - Withdraw Affiliate Bonus
377 
378     function WithdrawAffiliate(address user, address tokenAddress) public {  
379 		require(tokenAddress != 0x0);		
380 		require(Statistics[user][tokenAddress][3] > 0 );
381 		
382 		uint256 amount = Statistics[msg.sender][tokenAddress][3];
383 		Statistics[msg.sender][tokenAddress][3] = 0;
384 		
385 		TokenBalance[tokenAddress] 		= sub(TokenBalance[tokenAddress], amount); 
386 		AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], amount);
387 		
388 		uint256 eventAmount				= amount;
389         address eventTokenAddress 		= tokenAddress;
390         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
391         
392         ERC20Interface token = ERC20Interface(tokenAddress);        
393         require(token.balanceOf(address(this)) >= amount);
394         token.transfer(user, amount);
395 		
396 		Statistics[user][tokenAddress][2] 	= add(Statistics[user][tokenAddress][2], amount); 
397 		
398 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
399     } 		
400 	
401 	
402 	/*==============================
403     =          RESTRICTED          =
404     ==============================*/  	
405 
406 //-------o 01 Add Contract Address	
407     function AddContractAddress(address tokenAddress, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
408 		uint256 newSpeed	= _PercentPermonth;
409 		require(newSpeed >= 3 && newSpeed <= 12);
410 		
411 		percent[tokenAddress] 			= newSpeed;	
412 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
413 		maxcontribution[tokenAddress] 	= _maxcontribution;	
414 		
415 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
416 		uint256 HodlTime 				= _HodlingTime * 1 days;		
417 		hodlingTime[tokenAddress] 		= HodlTime;	
418 		
419 		if (DefaultToken == 0x0000000000000000000000000000000000000000) { DefaultToken = tokenAddress; } 
420 		
421 		if (tokenAddress == DefaultToken && contractstatus == false) {
422 			contractaddress[tokenAddress] 	= true;
423 		} else {         
424 			contractaddress[tokenAddress] 	= contractstatus; 
425 		}	
426 		
427 		emit onAddContractAddress(tokenAddress, contractstatus, _maxcontribution, _ContractSymbol, _PercentPermonth, HodlTime);
428     }
429 	
430 //-------o 02 - Update Token Price (USD)
431 	
432 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice) public restricted  {
433 		
434 		if (Currentprice > 0  ) { token_price[tokenAddress][1] = Currentprice; }
435 		if (ATHprice > 0  ) { token_price[tokenAddress][2] = ATHprice; }
436 		if (ATLprice > 0  ) { token_price[tokenAddress][3] = ATLprice; }
437 
438     }
439 	
440 //-------o 03 Hold Platform
441     function Holdplatform_Airdrop(address tokenAddress, bool HPM_status, uint256 HPM_divider) public restricted {
442 		
443 		Holdplatform_status[tokenAddress] 	= HPM_status;	
444 		Holdplatform_divider[tokenAddress] 	= HPM_divider;	// Airdrop = 100% : Divider
445 		uint256 HPM_ratio					= div(100, HPM_divider);
446 		
447 		emit onHoldplatformsetting(tokenAddress, HPM_status, HPM_divider, HPM_ratio, now);
448 	
449     }	
450 	//--o Deposit
451 	function Holdplatform_Deposit(uint256 amount) restricted public {
452 		require(amount > 0 );
453         
454        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
455         require(token.transferFrom(msg.sender, address(this), amount));
456 		
457 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
458 		Holdplatform_balance 	= newbalance;
459 		
460 		emit onHoldplatformdeposit(amount, newbalance, now);
461     }
462 	//--o Withdraw
463 	function Holdplatform_Withdraw(uint256 amount) restricted public {
464         require(Holdplatform_balance > 0);
465         
466 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
467 		Holdplatform_balance 	= newbalance;
468         
469         ERC20Interface token = ERC20Interface(Holdplatform_address);
470         
471         require(token.balanceOf(address(this)) >= amount);
472         token.transfer(msg.sender, amount);
473 		
474 		emit onHoldplatformwithdraw(amount, newbalance, now);
475     }
476 	
477 //-------o 04 - Return All Tokens To Their Respective Addresses    
478     function ReturnAllTokens() restricted public
479     {
480 
481         for(uint256 i = 1; i < idnumber; i++) {            
482             Safe storage s = _safes[i];
483             if (s.id != 0) {
484 				
485 				if(s.amountbalance > 0) {
486 					uint256 amount = add(s.amountbalance, s.cashbackbalance);
487 					PayToken(s.user, s.tokenAddress, amount);
488 					
489 				}
490 				
491 
492                 
493             }
494         }
495 		
496     }   
497 	
498 	
499 	/*==============================
500     =      SAFE MATH FUNCTIONS     =
501     ==============================*/  	
502 	
503 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
504 		if (a == 0) {
505 			return 0;
506 		}
507 		uint256 c = a * b; 
508 		require(c / a == b);
509 		return c;
510 	}
511 	
512 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
513 		require(b > 0); 
514 		uint256 c = a / b;
515 		return c;
516 	}
517 	
518 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
519 		require(b <= a);
520 		uint256 c = a - b;
521 		return c;
522 	}
523 	
524 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
525 		uint256 c = a + b;
526 		require(c >= a);
527 		return c;
528 	}
529     
530 }
531 
532 
533 	/*==============================
534     =        ERC20 Interface       =
535     ==============================*/ 
536 
537 contract ERC20Interface {
538 
539     uint256 public totalSupply;
540     uint256 public decimals;
541     
542     function symbol() public view returns (string);
543     function balanceOf(address _owner) public view returns (uint256 balance);
544     function transfer(address _to, uint256 _value) public returns (bool success);
545     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
546     function approve(address _spender, uint256 _value) public returns (bool success);
547     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
548 
549     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
550     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
551 }