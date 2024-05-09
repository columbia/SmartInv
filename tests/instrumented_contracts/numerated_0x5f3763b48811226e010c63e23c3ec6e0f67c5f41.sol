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
22     =          Version 7.2         =
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
47 	event onClaimTokens		(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);			
48 	event onHodlTokens		(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
49 	event onClaimCashBack	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);	
50 	event onAddContractAddress(address indexed contracthodler, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth, uint256 _HodlingTime);	
51 
52 	event onUnlockedTokens(uint256 returned);	
53 	
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
83 		// Uint256
84 		
85 	uint256 private _currentIndex; 									// 01 -- > ID number ( Start from 500 )				//IDNumber
86 	uint256 public  _countSafes; 									// 02 -- > Total Smart Contract User				//TotalUser
87 	
88 		// Mapping
89 		
90 	mapping(address => bool) 			public contractaddress; 	// 01 -- > Contract Address 
91 	mapping(address => uint256) 		public percent; 			// 02 -- > Monthly Unlock Percentage (Default 3%)
92 	mapping(address => uint256) 		public hodlingTime; 		// 03 -- > Length of hold time in seconds	
93 	mapping(address => address) 		public cashbackcode; 		// 04 -- > Cashback Code 							
94 	mapping(address => uint256) 		public _totalSaved; 		// 05 -- > Token Balance				//TokenBalance		
95 	mapping(address => uint256[]) 		public _userSafes;			// 06 -- > Search ID by Address 		//IDAddress
96 	mapping(address => uint256) 		private EthereumVault;    	// 07 -- > Reserve Funds				
97 	mapping(uint256 => Safe) 			private _safes; 			// 08 -- > Struct safe database			
98 	mapping(address => uint256) 		public maxcontribution; 	// 09 -- > Maximum Contribution					//N				
99 	mapping(address => uint256) 		public AllContribution; 	// 10 -- > Deposit amount for all members		//N	
100 	mapping(address => uint256) 		public AllPayments; 		// 11 -- > Withdraw amount for all members		//N
101 	mapping(address => string) 			public ContractSymbol; 		// 12 -- > Contract Address Symbol				//N
102 	mapping(address => address[]) 		public afflist;				// 13 -- > Affiliate List by ID					//N
103 	mapping(address => uint256) 		public token_price; 		// 14 -- > Token Price ( USD )					//N
104 
105 	mapping (address => mapping (address => uint256)) public LifetimeContribution;	// 01 -- > Total Deposit Amount Based On Address & Token  //N
106 	mapping (address => mapping (address => uint256)) public LifetimePayments;		// 02 -- > Total Withdraw Amount Based On Address & Token //N	
107 	mapping (address => mapping (address => uint256)) public Affiliatevault;		// 03 -- > Affiliate Balance That Hasn't Been Withdrawn	  //N
108 	mapping (address => mapping (address => uint256)) public Affiliateprofit;		// 04 -- > The Amount Of Profit As An Affiliate			  //N
109 	mapping (address => mapping (address => uint256)) public ActiveContribution;	// 05 -- > Total Active Amount Based On Address & Token  //N
110 	
111 		// Airdrop - Hold Platform (HPM)
112 								
113 	address public Holdplatform_address;			
114 	mapping(address => bool) 	public Holdplatform_status;
115 	mapping(address => uint256) public Holdplatform_ratio; 	
116 	mapping(address => uint256) public Holdplatform_balance; 	
117  
118 	
119 	/*==============================
120     =          CONSTRUCTOR         =
121     ==============================*/  	
122    
123     constructor() public {     	 	
124         _currentIndex 	= 500;
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
135         if (msg.value > 0 ) { EthereumVault[0x0] = add(EthereumVault[0x0], msg.value);}		 
136     }
137 	
138 	
139 //-------o Function 02 - Cashback Code
140 
141     function CashbackCode(address _cashbackcode) public {		
142 		require(_cashbackcode != msg.sender);		
143 		if (cashbackcode[msg.sender] == 0) { cashbackcode[msg.sender] = _cashbackcode; emit onCashbackCode(msg.sender, _cashbackcode);}		             
144     } 
145 	
146 //-------o Function 03 - Contribute 
147 
148 	//--o 01
149     function HodlTokens(address tokenAddress, uint256 amount) public {
150         require(tokenAddress != 0x0);
151 		require(amount > 0 && add(ActiveContribution[msg.sender][tokenAddress], amount) <= maxcontribution[tokenAddress] );
152 		
153 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
154 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
155         require(token.transferFrom(msg.sender, address(this), amount));	
156 		
157 		HodlTokens2(tokenAddress, amount);}							
158 	}
159 	//--o 02	
160     function HodlTokens2(address ERC, uint256 amount) private {
161 		
162 		uint256 AvailableBalances 					= div(mul(amount, 72), 100);	
163 		
164 		if (cashbackcode[msg.sender] == 0 ) { //--o  Hold without cashback code
165 		
166 			address ref								= EthereumNodes;
167 			cashbackcode[msg.sender] 				= EthereumNodes;
168 			uint256 AvailableCashback 				= 0; 			
169 			uint256 zerocashback 					= div(mul(amount, 28), 100); 
170 			EthereumVault[ERC] 						= add(EthereumVault[ERC], zerocashback);
171 			Affiliateprofit[EthereumNodes][ERC] 	= add(Affiliateprofit[EthereumNodes][ERC], zerocashback); 		
172 			
173 			emit onCashbackCode(msg.sender, EthereumNodes);
174 			
175 		} else { 	//--o  Cashback code has been activated
176 		
177 			ref										= cashbackcode[msg.sender];
178 			uint256 affcomission 					= div(mul(amount, 12), 100); 	
179 			AvailableCashback 						= div(mul(amount, 16), 100);			
180 			uint256 ReferrerContribution 			= ActiveContribution[ref][ERC];		
181 			uint256 ReferralContribution			= add(ActiveContribution[msg.sender][ERC], amount);
182 			
183 			if (ReferrerContribution >= ReferralContribution) { //--o  if referrer contribution >= referral contribution
184 		
185 				Affiliatevault[ref][ERC] 			= add(Affiliatevault[ref][ERC], affcomission); 
186 				Affiliateprofit[ref][ERC] 			= add(Affiliateprofit[ref][ERC], affcomission); 	
187 				
188 			} else {											//--o  if referral contribution > referrer contribution
189 			
190 				uint256 Newbie 						= div(mul(ReferrerContribution, 12), 100); 			
191 				Affiliatevault[ref][ERC] 			= add(Affiliatevault[ref][ERC], Newbie); 
192 				Affiliateprofit[ref][ERC] 			= add(Affiliateprofit[ref][ERC], Newbie); 
193 				
194 				uint256 NodeFunds 					= sub(affcomission, Newbie);	
195 				EthereumVault[ERC] 					= add(EthereumVault[ERC], NodeFunds);
196 				Affiliateprofit[EthereumNodes][ERC] = add(Affiliateprofit[EthereumNodes][ERC], Newbie); 				
197 			}
198 		} 
199 
200 		HodlTokens3(ERC, amount, AvailableBalances, AvailableCashback, ref); 	
201 	}
202 	//--o 03	
203     function HodlTokens3(address ERC, uint256 amount, uint256 AvailableBalances, uint256 AvailableCashback, address ref) private {
204 	    
205 	    ERC20Interface token 	= ERC20Interface(ERC); 	
206 		uint256 TokenPercent 	= percent[ERC];	
207 		uint256 TokenHodlTime 	= hodlingTime[ERC];	
208 		uint256 HodlTime		= add(now, TokenHodlTime);
209 		
210 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
211 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
212 		
213 		_safes[_currentIndex] = Safe(_currentIndex, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
214 				
215 		LifetimeContribution[msg.sender][ERC] 	= add(LifetimeContribution[msg.sender][ERC], AM); 
216 		ActiveContribution[msg.sender][ERC] 	= add(ActiveContribution[msg.sender][ERC], AM); 			
217 		AllContribution[ERC] 					= add(AllContribution[ERC], AM);   	
218         _totalSaved[ERC] 						= add(_totalSaved[ERC], AM);    
219 		
220 		afflist[ref].push(msg.sender); _userSafes[msg.sender].push(_currentIndex); _currentIndex++; _countSafes++;       
221         emit onHodlTokens(msg.sender, ERC, token.symbol(), AM, HodlTime);		
222 		
223 	    HodlTokens4(ERC, amount); 	
224 	}
225 	//--o 04	
226     function HodlTokens4(address ERC, uint256 amount) private {
227 	    
228 		if (Holdplatform_status[ERC] == true) {
229 			
230 		uint256 Airdrop	= div(mul(Holdplatform_ratio[ERC], amount), 100000);
231 		address HPM 	= Holdplatform_address;
232 		
233 		ERC20Interface token 	= ERC20Interface(HPM);        
234         require(token.balanceOf(address(this)) >= Airdrop);
235 	    require(Holdplatform_balance[Holdplatform_address] >= Airdrop);
236 
237         token.transfer(msg.sender, Airdrop);
238 		
239 		}		
240 	}
241 	
242 //-------o Function 05 - Recontribute
243 
244     function Recontribute(uint256 id) public {
245         require(id != 0);        
246         
247         Safe storage s = _safes[id];
248 		require(s.tokenAddress != 0x0);
249         require(s.user == msg.sender);  
250 		
251 		if (s.cashbackbalance == 0) { revert(); } else {	
252 		
253 			uint256 amount				= s.cashbackbalance;
254 			s.cashbackbalance 			= 0;
255 			HodlTokens2(s.tokenAddress, amount); 
256 		}
257     }
258 	
259 //-------o Function 06 - Claim Cashback
260 
261 	function ClaimCashback(uint256 id) public {
262         require(id != 0);        
263         
264         Safe storage s = _safes[id];
265 		require(s.tokenAddress != 0x0);
266         require(s.user == msg.sender);  
267 		
268 		if (s.cashbackbalance == 0) { revert(); } else {
269 			
270 			uint256 realAmount				= s.cashbackbalance;	
271 			address eventTokenAddress 		= s.tokenAddress;
272 			string memory eventTokenSymbol 	= s.tokenSymbol;	
273 			
274 			s.cashbackbalance 				= 0;
275 			s.cashbackstatus 				= true;			
276 			PayToken(s.user, s.tokenAddress, realAmount);           		
277 			
278 			emit onClaimCashBack(msg.sender, eventTokenAddress, eventTokenSymbol, realAmount, now);
279 		}
280     }
281 	
282 	
283 //-------o Function 07 - Claim Token That Has Been Unlocked
284     function ClaimTokens(address tokenAddress, uint256 id) public {
285         require(tokenAddress != 0x0);
286         require(id != 0);        
287         
288         Safe storage s = _safes[id];
289         require(s.user == msg.sender);  
290 		require(s.tokenAddress == tokenAddress);
291 		
292 		if (s.amountbalance == 0) { revert(); } else { UnlockToken1(tokenAddress, id); }
293     }
294     //--o 01
295     function UnlockToken1(address ERC, uint256 id) private {
296         Safe storage s = _safes[id];      
297         require(s.id != 0);
298         require(s.tokenAddress == ERC);
299 
300         uint256 eventAmount				= s.amountbalance;
301         address eventTokenAddress 		= s.tokenAddress;
302         string memory eventTokenSymbol 	= s.tokenSymbol;		
303 		     
304         if(s.endtime < now){ //--o  Hold Complete
305         
306 		uint256 amounttransfer 		= add(s.amountbalance, s.cashbackbalance);      
307 		s.lastwithdraw 				= s.amountbalance;   s.amountbalance = 0;   s.lasttime = now;  		
308 		PayToken(s.user, s.tokenAddress, amounttransfer); 
309 		
310 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
311             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
312             }
313 			else {
314 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
315 			}
316 			
317 		s.cashbackbalance = 0;	
318 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
319 		
320         } else { UnlockToken2(ERC, s.id); }
321         
322     }   
323 	//--o 02
324 	function UnlockToken2(address ERC, uint256 id) private {		
325 		Safe storage s = _safes[id];
326         
327         require(s.id != 0);
328         require(s.tokenAddress == ERC);		
329 			
330 		uint256 timeframe  			= sub(now, s.lasttime);			                            
331 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
332 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
333 		                         
334 		uint256 MaxWithdraw 		= div(s.amount, 10);
335 			
336 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
337 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
338 			
339 		//--o Maximum withdraw = User Amount Balance   
340 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount = s.amountbalance; } else { realAmount = MaxAccumulation; }
341 			
342 		 			
343 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount);
344 		s.amountbalance 			= newamountbalance;
345 		s.lastwithdraw 				= realAmount; 
346 		s.lasttime 					= now; 		
347 			
348 		UnlockToken3(ERC, id, newamountbalance, realAmount);		
349     }   
350 	//--o 03
351     function UnlockToken3(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
352         Safe storage s = _safes[id];
353         
354         require(s.id != 0);
355         require(s.tokenAddress == ERC);
356 
357         uint256 eventAmount				= realAmount;
358         address eventTokenAddress 		= s.tokenAddress;
359         string memory eventTokenSymbol 	= s.tokenSymbol;		
360 
361 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
362 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ; 	
363 		
364 			if (cashbackcode[msg.sender] == EthereumNodes || s.cashbackbalance > 0  ) {
365 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
366 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
367 			
368 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
369 		
370 		s.tokenreceive 					= tokenreceived; 
371 		s.percentagereceive 			= percentagereceived; 		
372 
373 		PayToken(s.user, s.tokenAddress, realAmount);           		
374 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
375     } 
376 	//--o Pay Token
377     function PayToken(address user, address tokenAddress, uint256 amount) private {
378         
379         ERC20Interface token = ERC20Interface(tokenAddress);        
380         require(token.balanceOf(address(this)) >= amount);
381         token.transfer(user, amount);
382 		
383 		_totalSaved[tokenAddress] 					= sub(_totalSaved[tokenAddress], amount); 
384 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
385 		LifetimePayments[msg.sender][tokenAddress] 	= add(LifetimePayments[user][tokenAddress], amount); 
386     }   	
387 	
388 //-------o Function 08 - Get How Many Contribute ?
389 
390     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
391         return _userSafes[hodler].length;
392     }
393 	
394 //-------o Function 09 - Get How Many Affiliate ?
395 
396     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
397         return afflist[hodler].length;
398     }
399     
400 //-------o Function 10 - Get complete data from each user
401 	function GetSafe(uint256 _id) public view
402         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
403     {
404         Safe storage s = _safes[_id];
405         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
406     }
407 	
408 //-------o Function 11 - Get Tokens Reserved For Ethereum Vault
409 
410     function GetTokenReserve(address tokenAddress) public view returns (uint256 amount) {
411         return EthereumVault[tokenAddress];
412     }    
413 	
414 //-------o Function 12 - Get Ethereum Contract's Balance  
415 
416     function GetContractBalance() public view returns(uint256)
417     {
418         return address(this).balance;
419     } 	
420 	
421 //-------o Function 13 - Withdraw Affiliate Bonus
422 
423     function WithdrawAffiliate(address user, address tokenAddress) public {  
424 		require(tokenAddress != 0x0);		
425 		require(Affiliatevault[user][tokenAddress] > 0 );
426 		
427 		uint256 amount = Affiliatevault[msg.sender][tokenAddress];
428 		Affiliatevault[msg.sender][tokenAddress] = 0;
429 		
430 		_totalSaved[tokenAddress] 		= sub(_totalSaved[tokenAddress], amount); 
431 		AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], amount);
432 		
433 		uint256 eventAmount				= amount;
434         address eventTokenAddress 		= tokenAddress;
435         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
436         
437         ERC20Interface token = ERC20Interface(tokenAddress);        
438         require(token.balanceOf(address(this)) >= amount);
439         token.transfer(user, amount);
440 		
441 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
442     } 		
443 	
444 //-------o Function 14 - Get User's Any Token Balance
445 
446     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
447         require(tokenAddress != 0x0);
448         
449         for(uint256 i = 1; i < _currentIndex; i++) {            
450             Safe storage s = _safes[i];
451             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
452                 balance += s.amount;
453         }
454         return balance;
455     }
456 	
457 	
458 	
459 	/*==============================
460     =          RESTRICTED          =
461     ==============================*/  	
462 
463 //-------o 01 Add Contract Address	
464     function AddContractAddress(address tokenAddress, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
465 		uint256 newSpeed	= _PercentPermonth;
466 		require(newSpeed >= 3 && newSpeed <= 12);
467 		
468 		percent[tokenAddress] 			= newSpeed;	
469 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
470 		maxcontribution[tokenAddress] 	= _maxcontribution;	
471 		
472 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
473 		uint256 HodlTime 				= _HodlingTime * 1 days;		
474 		hodlingTime[tokenAddress] 		= HodlTime;	
475 		
476 		if (DefaultToken == 0x0000000000000000000000000000000000000000) { DefaultToken = tokenAddress; } 
477 		
478 		if (tokenAddress == DefaultToken && contractstatus == false) {
479 			contractaddress[tokenAddress] 	= true;
480 		} else {         
481 			contractaddress[tokenAddress] 	= contractstatus; 
482 		}	
483 		
484 		emit onAddContractAddress(tokenAddress, contractstatus, _maxcontribution, _ContractSymbol, _PercentPermonth, HodlTime);
485     }
486 	
487 //-------o 02 - Update Token Price (USD)
488     function TokenPrice(address tokenAddress, uint256 price) public restricted  {
489         token_price[tokenAddress] = price;	
490     }
491 	
492 //-------o 03 - Withdraw Ethereum 
493     function WithdrawEth() restricted public {
494         require(address(this).balance > 0); 
495 		uint256 amount = address(this).balance;
496 		
497 		EthereumVault[0x0] = 0;   
498         msg.sender.transfer(amount);
499     }
500     
501 //-------o 04 Ethereum Nodes Fees   
502     function EthereumNodesFees(address tokenAddress) restricted public {
503         require(EthereumVault[tokenAddress] > 0);
504         
505         uint256 amount = EthereumVault[tokenAddress];
506 		_totalSaved[tokenAddress] 	= sub(_totalSaved[tokenAddress], amount); 
507         EthereumVault[tokenAddress] = 0;
508         
509         ERC20Interface token = ERC20Interface(tokenAddress);
510         
511         require(token.balanceOf(address(this)) >= amount);
512         token.transfer(msg.sender, amount);
513     }
514 	
515 //-------o 05 Hold Platform
516     function Holdplatform(address HPM_address, address tokenAddress, bool HPM_status, uint256 HPM_ratio, uint256 HPM_deposit) public restricted {
517 		
518 		Holdplatform_address 				= HPM_address;	
519 		Holdplatform_status[tokenAddress] 	= HPM_status;	
520 		Holdplatform_ratio[tokenAddress] 	= HPM_ratio;	// 100% = 100.000
521 		
522 		ERC20Interface token = ERC20Interface(HPM_address);       
523         require(token.transferFrom(msg.sender, address(this), HPM_deposit));
524 		
525 		uint256 lastbalance 	= Holdplatform_balance[HPM_address];
526 		uint256 newbalance		= add(lastbalance, HPM_deposit) ;
527 		Holdplatform_balance[HPM_address] = newbalance;
528 
529     }	
530 	
531 //-------o 06 - Return All Tokens To Their Respective Addresses    
532     function ReturnAllTokens() restricted public
533     {
534 
535         for(uint256 i = 1; i < _currentIndex; i++) {            
536             Safe storage s = _safes[i];
537             if (s.id != 0) {
538 				
539 				if(s.amountbalance > 0) {
540 					
541 					PayToken(s.user, s.tokenAddress, s.amountbalance);
542 					
543 				}
544 				
545 
546                 
547             }
548         }
549 		
550     }   
551 	
552 	
553 	/*==============================
554     =      SAFE MATH FUNCTIONS     =
555     ==============================*/  	
556 	
557 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
558 		if (a == 0) {
559 			return 0;
560 		}
561 		uint256 c = a * b; 
562 		require(c / a == b);
563 		return c;
564 	}
565 	
566 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
567 		require(b > 0); 
568 		uint256 c = a / b;
569 		return c;
570 	}
571 	
572 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
573 		require(b <= a);
574 		uint256 c = a - b;
575 		return c;
576 	}
577 	
578 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
579 		uint256 c = a + b;
580 		require(c >= a);
581 		return c;
582 	}
583     
584 }
585 
586 
587 	/*==============================
588     =        ERC20 Interface       =
589     ==============================*/ 
590 
591 contract ERC20Interface {
592 
593     uint256 public totalSupply;
594     uint256 public decimals;
595     
596     function symbol() public view returns (string);
597     function balanceOf(address _owner) public view returns (uint256 balance);
598     function transfer(address _to, uint256 _value) public returns (bool success);
599     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
600     function approve(address _spender, uint256 _value) public returns (bool success);
601     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
602 
603     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
604     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
605 }