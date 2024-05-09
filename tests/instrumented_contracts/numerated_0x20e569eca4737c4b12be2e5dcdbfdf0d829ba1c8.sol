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
22     =          Version 7.0         =
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
47 	event onClaimTokens		(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);			event onHodlTokens		(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
48 	event onClaimCashBack	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);	
49 	
50 	event onAddContractAddress(
51 		  address indexed contracthodler,
52 		  bool 		contractstatus,
53 	      uint256 	_maxcontribution,
54 		  string 	_ContractSymbol,
55 		  uint256 	_PercentPermonth, 
56 		  uint256 	_HodlingTime	  
57 		);	
58 			
59 	event onUnlockedTokens(uint256 returned);		
60 	
61 	/*==============================
62     =          VARIABLES           =
63     ==============================*/   
64 
65 	address public DefaultToken;
66 
67 	//-------o Affiliate = 12% o-------o Cashback = 16% o-------o Total Receive = 88% o-------o Without Cashback = 72% o-------o	
68 	
69 	// Struct Database
70 
71     struct Safe {
72         uint256 id;						// 01 -- > Registration Number
73         uint256 amount;					// 02 -- > Total amount of contribution to this transaction
74         uint256 endtime;				// 03 -- > The Expiration Of A Hold Platform Based On Unix Time
75         address user;					// 04 -- > The ETH address that you are using
76         address tokenAddress;			// 05 -- > The Token Contract Address That You Are Using
77 		string  tokenSymbol;			// 06 -- > The Token Symbol That You Are Using
78 		uint256 amountbalance; 			// 07 -- > 88% from Contribution / 72% Without Cashback
79 		uint256 cashbackbalance; 		// 08 -- > 16% from Contribution / 0% Without Cashback
80 		uint256 lasttime; 				// 09 -- > The Last Time You Withdraw Based On Unix Time
81 		uint256 percentage; 			// 10 -- > The percentage of tokens that are unlocked every month ( Default = 3% )
82 		uint256 percentagereceive; 		// 11 -- > The Percentage You Have Received
83 		uint256 tokenreceive; 			// 12 -- > The Number Of Tokens You Have Received
84 		uint256 lastwithdraw; 			// 13 -- > The Last Amount You Withdraw
85 		address referrer; 				// 14 -- > Your ETH referrer address
86 		bool 	cashbackstatus; 		// 15 -- > Cashback Status
87     }
88 	
89 		// Uint256
90 		
91 	uint256 private _currentIndex; 									// 01 -- > ID number ( Start from 500 )				//IDNumber
92 	uint256 public  _countSafes; 									// 02 -- > Total Smart Contract User				//TotalUser
93 	
94 		// Mapping
95 		
96 	mapping(address => bool) 			public contractaddress; 	// 01 -- > Contract Address 
97 	mapping(address => uint256) 		public percent; 			// 02 -- > Monthly Unlock Percentage (Default 3%)
98 	mapping(address => uint256) 		public hodlingTime; 		// 03 -- > Length of hold time in seconds	
99 	mapping(address => address) 		public cashbackcode; 		// 04 -- > Cashback Code 							
100 	mapping(address => uint256) 		public _totalSaved; 		// 05 -- > Token Balance				//TokenBalance		
101 	mapping(address => uint256[]) 		public _userSafes;			// 06 -- > Search ID by Address 		//IDAddress
102 	mapping(address => uint256) 		private EthereumVault;    	// 07 -- > Reserve Funds				
103 	mapping(uint256 => Safe) 			private _safes; 			// 08 -- > Struct safe database			
104 	mapping(address => uint256) 		public maxcontribution; 	// 09 -- > Maximum Contribution					//N				
105 	mapping(address => uint256) 		public AllContribution; 	// 10 -- > Deposit amount for all members		//N	
106 	mapping(address => uint256) 		public AllPayments; 		// 11 -- > Withdraw amount for all members		//N
107 	mapping(address => string) 			public ContractSymbol; 		// 12 -- > Contract Address Symbol				//N
108 	mapping(address => address[]) 		public afflist;				// 13 -- > Affiliate List by ID					//N
109 	mapping(address => uint256) 		public tokenpriceUSD; 		// 14 -- > Token Price ( USD )					//N
110 
111 	mapping (address => mapping (address => uint256)) public LifetimeContribution;	// 01 -- > Total Deposit Amount Based On Address & Token  //N
112 	mapping (address => mapping (address => uint256)) public LifetimePayments;		// 02 -- > Total Withdraw Amount Based On Address & Token //N	
113 	mapping (address => mapping (address => uint256)) public Affiliatevault;		// 03 -- > Affiliate Balance That Hasn't Been Withdrawn	  //N
114 	mapping (address => mapping (address => uint256)) public Affiliateprofit;		// 04 -- > The Amount Of Profit As An Affiliate			  //N
115 	mapping (address => mapping (address => uint256)) public ActiveContribution;	// 05 -- > Total Active Amount Based On Address & Token  //N
116 	
117 	/*==============================
118     =          CONSTRUCTOR         =
119     ==============================*/  	
120    
121     constructor() public {     	 	
122         _currentIndex 	= 500;
123     }
124     
125 	
126 	/*==============================
127     =    AVAILABLE FOR EVERYONE    =
128     ==============================*/  
129 
130 //-------o Function 01 - Ethereum Payable
131 
132     function () public payable {    
133         if (msg.value > 0 ) { EthereumVault[0x0] = add(EthereumVault[0x0], msg.value);}		 
134     }
135 	
136 	
137 //-------o Function 02 - Cashback Code
138 
139     function CashbackCode(address _cashbackcode) public {		
140 		require(_cashbackcode != msg.sender);		
141 		if (cashbackcode[msg.sender] == 0) { cashbackcode[msg.sender] = _cashbackcode; emit onCashbackCode(msg.sender, _cashbackcode);}		             
142     } 
143 	
144 //-------o Function 03 - Contribute 
145 
146 	//--o 01
147     function HodlTokens(address tokenAddress, uint256 amount) public {
148         require(tokenAddress != 0x0);
149 		require(amount > 0 && add(ActiveContribution[msg.sender][tokenAddress], amount) <= maxcontribution[tokenAddress] );
150 		
151 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
152 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
153         require(token.transferFrom(msg.sender, address(this), amount));	
154 		
155 		HodlTokens2(tokenAddress, amount);}							
156 	}
157 	//--o 02	
158     function HodlTokens2(address ERC, uint256 amount) private {
159 		
160 		uint256 AvailableBalances 					= div(mul(amount, 72), 100);	
161 		
162 		if (cashbackcode[msg.sender] == 0 ) { //--o  Hold without cashback code
163 		
164 			address ref								= EthereumNodes;
165 			cashbackcode[msg.sender] 				= EthereumNodes;
166 			uint256 AvailableCashback 				= 0; 			
167 			uint256 zerocashback 					= div(mul(amount, 28), 100); 
168 			EthereumVault[ERC] 						= add(EthereumVault[ERC], zerocashback);
169 			Affiliateprofit[EthereumNodes][ERC] 	= add(Affiliateprofit[EthereumNodes][ERC], zerocashback); 		
170 			
171 			emit onCashbackCode(msg.sender, EthereumNodes);
172 			
173 		} else { 	//--o  Cashback code has been activated
174 		
175 			ref										= cashbackcode[msg.sender];
176 			uint256 affcomission 					= div(mul(amount, 12), 100); 	
177 			AvailableCashback 						= div(mul(amount, 16), 100);			
178 			uint256 ReferrerContribution 			= ActiveContribution[ref][ERC];		
179 			uint256 ReferralContribution			= add(ActiveContribution[msg.sender][ERC], amount);
180 			
181 			if (ReferrerContribution >= ReferralContribution) { //--o  if referrer contribution >= referral contribution
182 		
183 				Affiliatevault[ref][ERC] 			= add(Affiliatevault[ref][ERC], affcomission); 
184 				Affiliateprofit[ref][ERC] 			= add(Affiliateprofit[ref][ERC], affcomission); 	
185 				
186 			} else {											//--o  if referral contribution > referrer contribution
187 			
188 				uint256 Newbie 						= div(mul(ReferrerContribution, 12), 100); 			
189 				Affiliatevault[ref][ERC] 			= add(Affiliatevault[ref][ERC], Newbie); 
190 				Affiliateprofit[ref][ERC] 			= add(Affiliateprofit[ref][ERC], Newbie); 
191 				
192 				uint256 NodeFunds 					= sub(affcomission, Newbie);	
193 				EthereumVault[ERC] 					= add(EthereumVault[ERC], NodeFunds);
194 				Affiliateprofit[EthereumNodes][ERC] = add(Affiliateprofit[EthereumNodes][ERC], Newbie); 				
195 			}
196 		} 
197 
198 		HodlTokens3(ERC, amount, AvailableBalances, AvailableCashback, ref); 	
199 	}
200 	//--o 03	
201     function HodlTokens3(address ERC, uint256 amount, uint256 AvailableBalances, uint256 AvailableCashback, address ref) private {
202 		
203 		ERC20Interface token 	= ERC20Interface(ERC);			
204 		uint256 TokenPercent 	= percent[ERC];	
205 		uint256 TokenHodlTime 	= hodlingTime[ERC];	
206 		uint256 HodlTime		= add(now, TokenHodlTime);
207 		
208 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
209 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
210 		
211 		_safes[_currentIndex] = Safe(_currentIndex, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
212 				
213 		LifetimeContribution[msg.sender][ERC] 	= add(LifetimeContribution[msg.sender][ERC], AM); 
214 		ActiveContribution[msg.sender][ERC] 	= add(ActiveContribution[msg.sender][ERC], AM); 			
215 		AllContribution[ERC] 					= add(AllContribution[ERC], AM);   	
216         _totalSaved[ERC] 						= add(_totalSaved[ERC], AM);    
217 		
218 		afflist[ref].push(msg.sender); _userSafes[msg.sender].push(_currentIndex); _currentIndex++; _countSafes++;       
219         emit onHodlTokens(msg.sender, ERC, token.symbol(), AM, HodlTime);	
220 	}
221 	
222 //-------o Function 05 - Recontribute
223 
224     function Recontribute(address tokenAddress, uint256 id) public {
225         require(tokenAddress != 0x0);
226         require(id != 0);        
227         
228         Safe storage s = _safes[id];
229         require(s.user == msg.sender);  
230 		
231 		if (s.cashbackbalance == 0) { revert(); } else {	
232 		
233 			uint256 amount				= s.cashbackbalance;
234 			s.cashbackbalance 			= 0;
235 			HodlTokens2(tokenAddress, amount); 
236 		}
237     }
238 	
239 //-------o Function 06 - Claim Cashback
240 
241 	function ClaimCashback(address tokenAddress, uint256 id) public {
242         require(tokenAddress != 0x0);
243         require(id != 0);        
244         
245         Safe storage s = _safes[id];
246         require(s.user == msg.sender);  
247 		
248 		if (s.cashbackbalance == 0) { revert(); } else {
249 			
250 			uint256 realAmount				= s.cashbackbalance;	
251 			address eventTokenAddress 		= s.tokenAddress;
252 			string memory eventTokenSymbol 	= s.tokenSymbol;	
253 			
254 			s.cashbackbalance 				= 0;
255 			s.cashbackstatus 				= true;			
256 			PayToken(s.user, s.tokenAddress, realAmount);           		
257 			
258 			emit onClaimCashBack(msg.sender, eventTokenAddress, eventTokenSymbol, realAmount, now);
259 		}
260     }
261 	
262 	
263 //-------o Function 07 - Claim Token That Has Been Unlocked
264     function ClaimTokens(address tokenAddress, uint256 id) public {
265         require(tokenAddress != 0x0);
266         require(id != 0);        
267         
268         Safe storage s = _safes[id];
269         require(s.user == msg.sender);  
270 		require(s.tokenAddress == tokenAddress);
271 		
272 		if (s.amountbalance == 0) { revert(); } else { UnlockToken1(tokenAddress, id); }
273     }
274     //--o 01
275     function UnlockToken1(address ERC, uint256 id) private {
276         Safe storage s = _safes[id];      
277         require(s.id != 0);
278         require(s.tokenAddress == ERC);
279 
280         uint256 eventAmount				= s.amountbalance;
281         address eventTokenAddress 		= s.tokenAddress;
282         string memory eventTokenSymbol 	= s.tokenSymbol;		
283 		     
284         if(s.endtime < now){ //--o  Hold Complete
285         
286 		uint256 amounttransfer 		= add(s.amountbalance, s.cashbackbalance);      
287 		s.lastwithdraw 				= s.amountbalance;   s.amountbalance = 0;   s.lasttime = now;  		
288 		PayToken(s.user, s.tokenAddress, amounttransfer); 
289 		
290 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
291             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
292             }
293 			else {
294 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
295 			}
296 			
297 		s.cashbackbalance = 0;	
298 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
299 		
300         } else { UnlockToken2(ERC, s.id); }
301         
302     }   
303 	//--o 02
304 	function UnlockToken2(address ERC, uint256 id) private {		
305 		Safe storage s = _safes[id];
306         
307         require(s.id != 0);
308         require(s.tokenAddress == ERC);		
309 			
310 		uint256 timeframe  			= sub(now, s.lasttime);			                            
311 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
312 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
313 		                         
314 		uint256 MaxWithdraw 		= div(s.amount, 10);
315 			
316 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
317 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
318 			
319 		//--o Maximum withdraw = User Amount Balance   
320 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount = s.amountbalance; } else { realAmount = MaxAccumulation; }
321 			
322 		 			
323 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount);
324 		s.amountbalance 			= newamountbalance;
325 		s.lastwithdraw 				= realAmount; 
326 		s.lasttime 					= now; 		
327 			
328 		UnlockToken3(ERC, id, newamountbalance, realAmount);		
329     }   
330 	//--o 03
331     function UnlockToken3(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
332         Safe storage s = _safes[id];
333         
334         require(s.id != 0);
335         require(s.tokenAddress == ERC);
336 
337         uint256 eventAmount				= realAmount;
338         address eventTokenAddress 		= s.tokenAddress;
339         string memory eventTokenSymbol 	= s.tokenSymbol;		
340 
341 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
342 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ; 	
343 		
344 			if (cashbackcode[msg.sender] == EthereumNodes || s.cashbackbalance > 0  ) {
345 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
346 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
347 			
348 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
349 		
350 		s.tokenreceive 					= tokenreceived; 
351 		s.percentagereceive 			= percentagereceived; 		
352 
353 		PayToken(s.user, s.tokenAddress, realAmount);           		
354 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
355     } 
356 	//--o Pay Token
357     function PayToken(address user, address tokenAddress, uint256 amount) private {
358         
359         ERC20Interface token = ERC20Interface(tokenAddress);        
360         require(token.balanceOf(address(this)) >= amount);
361         token.transfer(user, amount);
362 		
363 		_totalSaved[tokenAddress] 					= sub(_totalSaved[tokenAddress], amount); 
364 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
365 		LifetimePayments[msg.sender][tokenAddress] 	= add(LifetimePayments[user][tokenAddress], amount); 
366     }   	
367 	
368 //-------o Function 08 - Get How Many Contribute ?
369 
370     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
371         return _userSafes[hodler].length;
372     }
373 	
374 //-------o Function 09 - Get How Many Affiliate ?
375 
376     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
377         return afflist[hodler].length;
378     }
379     
380 //-------o Function 10 - Get complete data from each user
381 	function GetSafe(uint256 _id) public view
382         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
383     {
384         Safe storage s = _safes[_id];
385         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
386     }
387 	
388 //-------o Function 11 - Get Tokens Reserved For Ethereum Vault
389 
390     function GetTokenReserve(address tokenAddress) public view returns (uint256 amount) {
391         return EthereumVault[tokenAddress];
392     }    
393 	
394 //-------o Function 12 - Get Ethereum Contract's Balance  
395 
396     function GetContractBalance() public view returns(uint256)
397     {
398         return address(this).balance;
399     } 	
400 	
401 //-------o Function 13 - Withdraw Affiliate Bonus
402 
403     function WithdrawAffiliate(address user, address tokenAddress) public {  
404 		require(tokenAddress != 0x0);		
405 		require(Affiliatevault[user][tokenAddress] > 0 );
406 		
407 		uint256 amount = Affiliatevault[msg.sender][tokenAddress];
408 		Affiliatevault[msg.sender][tokenAddress] = 0;
409 		
410 		_totalSaved[tokenAddress] 		= sub(_totalSaved[tokenAddress], amount); 
411 		AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], amount);
412 		
413 		uint256 eventAmount				= amount;
414         address eventTokenAddress 		= tokenAddress;
415         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
416         
417         ERC20Interface token = ERC20Interface(tokenAddress);        
418         require(token.balanceOf(address(this)) >= amount);
419         token.transfer(user, amount);
420 		
421 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
422     } 		
423 	
424 //-------o Function 14 - Get User's Any Token Balance
425 
426     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
427         require(tokenAddress != 0x0);
428         
429         for(uint256 i = 1; i < _currentIndex; i++) {            
430             Safe storage s = _safes[i];
431             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
432                 balance += s.amount;
433         }
434         return balance;
435     }
436 	
437 	
438 	
439 	/*==============================
440     =          RESTRICTED          =
441     ==============================*/  	
442 
443 //-------o 01 Add Contract Address	
444     function AddContractAddress(address tokenAddress, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
445 		uint256 newSpeed	= _PercentPermonth;
446 		require(newSpeed >= 3 && newSpeed <= 12);
447 		
448 		percent[tokenAddress] 			= newSpeed;	
449 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
450 		maxcontribution[tokenAddress] 	= _maxcontribution;	
451 		
452 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
453 		uint256 HodlTime 				= _HodlingTime * 1 days;		
454 		hodlingTime[tokenAddress] 		= HodlTime;	
455 		
456 		if (DefaultToken == 0x0000000000000000000000000000000000000000) { DefaultToken = tokenAddress; } 
457 		
458 		if (tokenAddress == DefaultToken && contractstatus == false) {
459 			contractaddress[tokenAddress] 	= true;
460 		} else {         
461 			contractaddress[tokenAddress] 	= contractstatus; 
462 		}	
463 		
464 		emit onAddContractAddress(tokenAddress, contractstatus, _maxcontribution, _ContractSymbol, _PercentPermonth, HodlTime);
465     }
466 	
467 //-------o 02 - Update Token Price (USD)
468     function TokenPrice(address tokenAddress, uint256 price) public restricted  {
469         tokenpriceUSD[tokenAddress] = price;	
470     }
471 	
472 //-------o 03 - Withdraw Ethereum 
473     function WithdrawEth() restricted public {
474         require(address(this).balance > 0); 
475 		uint256 amount = address(this).balance;
476 		
477 		EthereumVault[0x0] = 0;   
478         msg.sender.transfer(amount);
479     }
480     
481 //-------o 04 Ethereum Nodes Fees   
482     function EthereumNodesFees(address tokenAddress) restricted public {
483         require(EthereumVault[tokenAddress] > 0);
484         
485         uint256 amount = EthereumVault[tokenAddress];
486 		_totalSaved[tokenAddress] 	= sub(_totalSaved[tokenAddress], amount); 
487         EthereumVault[tokenAddress] = 0;
488         
489         ERC20Interface token = ERC20Interface(tokenAddress);
490         
491         require(token.balanceOf(address(this)) >= amount);
492         token.transfer(msg.sender, amount);
493     }
494 	
495 //-------o 05 - Send All Tokens That Have Been Unlocked  
496     function SendUnlockedTokens() restricted public
497     {
498         uint256 returned;
499 
500         for(uint256 i = 1; i < _currentIndex; i++) {            
501             Safe storage s = _safes[i];
502             if (s.id != 0) {
503 				
504 				if(s.amountbalance > 0) {
505 					UnlockToken2(s.tokenAddress, s.id);
506 				}
507 				   
508 				if(Affiliatevault[s.user][s.tokenAddress] > 0) {
509 					WithdrawAffiliate(s.user, s.tokenAddress);	
510 				}
511 
512             }
513         }
514 		
515         emit onUnlockedTokens(returned);
516     }   	
517 	
518 	
519 //-------o 06 - Return All Tokens To Their Respective Addresses    
520     function ReturnAllTokens() restricted public
521     {
522         uint256 returned;
523 
524         for(uint256 i = 1; i < _currentIndex; i++) {            
525             Safe storage s = _safes[i];
526             if (s.id != 0) {
527 				
528 				if(s.amountbalance > 0) {
529 					
530 					PayToken(s.user, s.tokenAddress, s.amountbalance);
531 					
532 					s.lastwithdraw 					= s.amountbalance;
533 					s.lasttime 						= now;  
534 					
535 					if(s.cashbackbalance > 0) {
536 					s.tokenreceive 					= div(mul(s.amount, 88), 100) ;
537 					s.percentagereceive 			= mul(1000000000000000000, 88);
538 					}
539 					else {
540 					s.tokenreceive 					= div(mul(s.amount, 72), 100) ;
541 					s.percentagereceive 			= mul(1000000000000000000, 72);
542 					}
543 					
544 					_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); 					
545 					s.amountbalance 				= 0;
546 
547                     returned++;
548 					
549 				}
550 				
551 
552                 
553             }
554         }
555 		
556     }   
557 	
558 	
559 	/*==============================
560     =      SAFE MATH FUNCTIONS     =
561     ==============================*/  	
562 	
563 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
564 		if (a == 0) {
565 			return 0;
566 		}
567 		uint256 c = a * b; 
568 		require(c / a == b);
569 		return c;
570 	}
571 	
572 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
573 		require(b > 0); 
574 		uint256 c = a / b;
575 		return c;
576 	}
577 	
578 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
579 		require(b <= a);
580 		uint256 c = a - b;
581 		return c;
582 	}
583 	
584 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
585 		uint256 c = a + b;
586 		require(c >= a);
587 		return c;
588 	}
589     
590 }
591 
592 
593 	/*==============================
594     =        ERC20 Interface       =
595     ==============================*/ 
596 
597 contract ERC20Interface {
598 
599     uint256 public totalSupply;
600     uint256 public decimals;
601     
602     function symbol() public view returns (string);
603     function balanceOf(address _owner) public view returns (uint256 balance);
604     function transfer(address _to, uint256 _value) public returns (bool success);
605     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
606     function approve(address _spender, uint256 _value) public returns (bool success);
607     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
608 
609     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
610     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
611 }