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
22     =          Version 7.3         =
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
49 	event onAddContractAddress(address indexed contracthodler, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth, uint256 _HodlingTime);	
50 
51 	
52 	
53 	/*==============================
54     =          VARIABLES           =
55     ==============================*/   
56 
57 	address public DefaultToken;
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
81 		// Uint256
82 		
83 	uint256 private _currentIndex; 									// 01 -- > ID number ( Start from 500 )				//IDNumber
84 	uint256 public  _countSafes; 									// 02 -- > Total Smart Contract User				//TotalUser
85 	
86 		// Mapping
87 		
88 	mapping(address => address) 		public cashbackcode; 		// 01 -- > Cashback Code 					
89 	mapping(address => uint256) 		public percent; 			// 02 -- > Monthly Unlock Percentage (Default 3%)
90 	mapping(address => uint256) 		public hodlingTime; 		// 03 -- > Length of hold time in seconds
91 	mapping(address => uint256) 		public _totalSaved; 		// 04 -- > Token Balance							//TokenBalance	
92 	mapping(address => uint256) 		private EthereumVault;    	// 05 -- > Reserve Funds				
93 	mapping(address => uint256) 		public maxcontribution; 	// 06 -- > Maximum Contribution					//N	
94 	mapping(address => uint256) 		public AllContribution; 	// 07 -- > Deposit amount for all members		//N	
95 	mapping(address => uint256) 		public AllPayments; 		// 08 -- > Withdraw amount for all members		//N
96 	mapping(address => uint256) 		public token_price; 		// 09 -- > Token Price ( USD )					//N
97 	mapping(address => bool) 			public contractaddress; 	// 10 -- > Contract Address 
98 	mapping(address => bool) 			public activeuser; 			// 11 -- > Active User Status
99 	mapping(address => uint256[]) 		public _userSafes;			// 12 -- > Search ID by Address 					//IDAddress
100 	mapping(address => address[]) 		public afflist;				// 13 -- > Affiliate List by ID					//N
101 	mapping(address => string) 			public ContractSymbol; 		// 14 -- > Contract Address Symbol				//N
102 	mapping(uint256 => Safe) 			private _safes; 			// 15 -- > Struct safe database			
103 			
104 	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
105 	//3rd uint256, Category >>> 1 = LifetimeContribution, 2 = LifetimePayments, 3 = Affiliatevault, 4 = Affiliateprofit, 5 = ActiveContribution
106 	
107 	
108 		// Airdrop - Hold Platform (HPM)
109 								
110 	address public Holdplatform_address;	
111 	uint256 public Holdplatform_balance; 	
112 	mapping(address => bool) 	public Holdplatform_status;
113 	mapping(address => uint256) public Holdplatform_ratio; 	
114 	
115  
116 	
117 	/*==============================
118     =          CONSTRUCTOR         =
119     ==============================*/  	
120    
121     constructor() public {     	 	
122         _currentIndex 			= 500;
123 		Holdplatform_address	= 0x23bAdee11Bf49c40669e9b09035f048e9146213e;	//Change before deploy
124     }
125     
126 	
127 	/*==============================
128     =    AVAILABLE FOR EVERYONE    =
129     ==============================*/  
130 
131 //-------o Function 01 - Ethereum Payable
132 
133     function () public payable {    
134         if (msg.value > 0 ) { EthereumVault[0x0] = add(EthereumVault[0x0], msg.value);}		 
135     }
136 	
137 	
138 //-------o Function 02 - Cashback Code
139 
140     function CashbackCode(address _cashbackcode) public {		
141 		require(_cashbackcode != msg.sender);		
142 		if (cashbackcode[msg.sender] == 0 && activeuser[_cashbackcode] == true) { 
143 		cashbackcode[msg.sender] = _cashbackcode; }
144 		else { cashbackcode[msg.sender] = EthereumNodes; }		
145 		
146 	emit onCashbackCode(msg.sender, _cashbackcode);		
147     } 
148 	
149 //-------o Function 03 - Contribute 
150 
151 	//--o 01
152     function HodlTokens(address tokenAddress, uint256 amount) public {
153         require(tokenAddress != 0x0);
154 		require(amount > 0 && add(Statistics[msg.sender][tokenAddress][5], amount) <= maxcontribution[tokenAddress] );
155 		
156 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
157 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
158         require(token.transferFrom(msg.sender, address(this), amount));	
159 		
160 		HodlTokens2(tokenAddress, amount);}							
161 	}
162 	//--o 02	
163     function HodlTokens2(address ERC, uint256 amount) private {
164 		
165 		uint256 AvailableBalances 					= div(mul(amount, 72), 100);	
166 		
167 		if (cashbackcode[msg.sender] == 0 ) { //--o  Hold without cashback code
168 		
169 			address ref								= EthereumNodes;
170 			cashbackcode[msg.sender] 				= EthereumNodes;
171 			uint256 AvailableCashback 				= 0; 			
172 			uint256 zerocashback 					= div(mul(amount, 28), 100); 
173 			EthereumVault[ERC] 						= add(EthereumVault[ERC], zerocashback);
174 			Statistics[EthereumNodes][ERC][4]		= add(Statistics[EthereumNodes][ERC][4], zerocashback); 		
175 			
176 		} else { 	//--o  Cashback code has been activated
177 		
178 			ref										= cashbackcode[msg.sender];
179 			uint256 affcomission 					= div(mul(amount, 12), 100); 	
180 			AvailableCashback 						= div(mul(amount, 16), 100);			
181 			uint256 ReferrerContribution 			= Statistics[ref][ERC][5];		
182 			uint256 ReferralContribution			= add(Statistics[ref][ERC][5], amount);
183 			
184 			if (ReferrerContribution >= ReferralContribution) { //--o  if referrer contribution >= referral contribution
185 		
186 				Statistics[ref][ERC][3] 			= add(Statistics[ref][ERC][3], affcomission); 
187 				Statistics[ref][ERC][4] 			= add(Statistics[ref][ERC][4], affcomission); 	
188 				
189 			} else {											//--o  if referral contribution > referrer contribution
190 			
191 				uint256 Newbie 						= div(mul(ReferrerContribution, 12), 100); 			
192 				Statistics[ref][ERC][3]				= add(Statistics[ref][ERC][3], Newbie); 
193 				Statistics[ref][ERC][4] 			= add(Statistics[ref][ERC][4], Newbie); 
194 				
195 				uint256 NodeFunds 					= sub(affcomission, Newbie);	
196 				EthereumVault[ERC] 					= add(EthereumVault[ERC], NodeFunds);
197 				Statistics[EthereumNodes][ERC][4] 	= add(Statistics[EthereumNodes][ERC][4], NodeFunds); 				
198 			}
199 		} 
200 
201 		HodlTokens3(ERC, amount, AvailableBalances, AvailableCashback, ref); 	
202 	}
203 	//--o 03	
204     function HodlTokens3(address ERC, uint256 amount, uint256 AvailableBalances, uint256 AvailableCashback, address ref) private {
205 	    
206 	    ERC20Interface token 	= ERC20Interface(ERC); 	
207 		uint256 TokenPercent 	= percent[ERC];	
208 		uint256 TokenHodlTime 	= hodlingTime[ERC];	
209 		uint256 HodlTime		= add(now, TokenHodlTime);
210 		
211 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
212 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
213 		
214 		_safes[_currentIndex] = Safe(_currentIndex, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
215 				
216 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
217 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
218 		AllContribution[ERC] 					= add(AllContribution[ERC], AM);   	
219         _totalSaved[ERC] 						= add(_totalSaved[ERC], AM);  
220 		activeuser[msg.sender] 					= true;  		
221 		
222 		afflist[ref].push(msg.sender); _userSafes[msg.sender].push(_currentIndex); _currentIndex++; _countSafes++;       
223         emit onHodlTokens(msg.sender, ERC, token.symbol(), AM, HodlTime);		
224 		
225 	    HodlTokens4(ERC, amount); 	
226 	}
227 	//--o 04	
228     function HodlTokens4(address ERC, uint256 amount) private {
229 		
230 		if (Holdplatform_status[ERC] == true) {
231 		require(Holdplatform_balance > 0);
232 			
233 		uint256 Airdrop	= div(mul(Holdplatform_ratio[ERC], amount), 100000);
234 		
235 		ERC20Interface token 	= ERC20Interface(Holdplatform_address);        
236         require(token.balanceOf(address(this)) >= Airdrop);
237 
238         token.transfer(msg.sender, Airdrop);
239 		}		
240 	}
241 	
242 //-------o Function 05 - Claim Token That Has Been Unlocked
243     function ClaimTokens(address tokenAddress, uint256 id) public {
244         require(tokenAddress != 0x0);
245         require(id != 0);        
246         
247         Safe storage s = _safes[id];
248         require(s.user == msg.sender);  
249 		require(s.tokenAddress == tokenAddress);
250 		
251 		if (s.amountbalance == 0) { revert(); } else { UnlockToken1(tokenAddress, id); }
252     }
253     //--o 01
254     function UnlockToken1(address ERC, uint256 id) private {
255         Safe storage s = _safes[id];      
256         require(s.id != 0);
257         require(s.tokenAddress == ERC);
258 
259         uint256 eventAmount				= s.amountbalance;
260         address eventTokenAddress 		= s.tokenAddress;
261         string memory eventTokenSymbol 	= s.tokenSymbol;		
262 		     
263         if(s.endtime < now){ //--o  Hold Complete
264         
265 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
266 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
267 		s.lastwithdraw 							= s.amountbalance;   s.amountbalance = 0;   s.lasttime = now;  		
268 		PayToken(s.user, s.tokenAddress, amounttransfer); 
269 		
270 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
271             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
272             }
273 			else {
274 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
275 			}
276 			
277 		s.cashbackbalance = 0;	
278 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
279 		
280         } else { UnlockToken2(ERC, s.id); }
281         
282     }   
283 	//--o 02
284 	function UnlockToken2(address ERC, uint256 id) private {		
285 		Safe storage s = _safes[id];
286         
287         require(s.id != 0);
288         require(s.tokenAddress == ERC);		
289 			
290 		uint256 timeframe  			= sub(now, s.lasttime);			                            
291 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
292 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
293 		                         
294 		uint256 MaxWithdraw 		= div(s.amount, 10);
295 			
296 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
297 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
298 			
299 		//--o Maximum withdraw = User Amount Balance   
300 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
301 			
302 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
303 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount);
304 		s.amountbalance 			= 0; 
305 		s.amountbalance 			= newamountbalance;
306 		s.lastwithdraw 				= realAmount; 
307 		s.lasttime 					= now; 		
308 			
309 		UnlockToken3(ERC, id, newamountbalance, realAmount);		
310     }   
311 	//--o 03
312     function UnlockToken3(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
313         Safe storage s = _safes[id];
314         
315         require(s.id != 0);
316         require(s.tokenAddress == ERC);
317 
318         uint256 eventAmount				= realAmount;
319         address eventTokenAddress 		= s.tokenAddress;
320         string memory eventTokenSymbol 	= s.tokenSymbol;		
321 
322 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
323 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ; 	
324 		
325 			if (cashbackcode[msg.sender] == EthereumNodes || s.cashbackbalance > 0  ) {
326 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
327 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
328 			
329 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
330 		
331 		s.tokenreceive 					= tokenreceived; 
332 		s.percentagereceive 			= percentagereceived; 		
333 
334 		PayToken(s.user, s.tokenAddress, realAmount);           		
335 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
336     } 
337 	//--o Pay Token
338     function PayToken(address user, address tokenAddress, uint256 amount) private {
339         
340         ERC20Interface token = ERC20Interface(tokenAddress);        
341         require(token.balanceOf(address(this)) >= amount);
342         token.transfer(user, amount);
343 		
344 		_totalSaved[tokenAddress] 					= sub(_totalSaved[tokenAddress], amount); 
345 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
346 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
347     }  
348 	
349 //-------o Function 06 - Get How Many Contribute ?
350 
351     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
352         return _userSafes[hodler].length;
353     }
354 	
355 //-------o Function 07 - Get How Many Affiliate ?
356 
357     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
358         return afflist[hodler].length;
359     }
360     
361 //-------o Function 08 - Get complete data from each user
362 	function GetSafe(uint256 _id) public view
363         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
364     {
365         Safe storage s = _safes[_id];
366         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
367     }
368 	
369 //-------o Function 09 - Get Tokens Reserved For Ethereum Vault
370 
371     function GetTokenReserve(address tokenAddress) public view returns (uint256 amount) {
372         return EthereumVault[tokenAddress];
373     }    
374 	
375 //-------o Function 10 - Get Ethereum Contract's Balance  
376 
377     function GetContractBalance() public view returns(uint256)
378     {
379         return address(this).balance;
380     } 	
381 	
382 //-------o Function 11 - Withdraw Affiliate Bonus
383 
384     function WithdrawAffiliate(address user, address tokenAddress) public {  
385 		require(tokenAddress != 0x0);		
386 		require(Statistics[user][tokenAddress][3] > 0 );
387 		
388 		uint256 amount = Statistics[msg.sender][tokenAddress][3];
389 		Statistics[msg.sender][tokenAddress][3] = 0;
390 		
391 		_totalSaved[tokenAddress] 		= sub(_totalSaved[tokenAddress], amount); 
392 		AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], amount);
393 		
394 		uint256 eventAmount				= amount;
395         address eventTokenAddress 		= tokenAddress;
396         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
397         
398         ERC20Interface token = ERC20Interface(tokenAddress);        
399         require(token.balanceOf(address(this)) >= amount);
400         token.transfer(user, amount);
401 		
402 		Statistics[user][tokenAddress][2] 	= add(Statistics[user][tokenAddress][2], amount); 
403 		
404 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
405     } 		
406 	
407 	
408 	/*==============================
409     =          RESTRICTED          =
410     ==============================*/  	
411 
412 //-------o 01 Add Contract Address	
413     function AddContractAddress(address tokenAddress, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
414 		uint256 newSpeed	= _PercentPermonth;
415 		require(newSpeed >= 3 && newSpeed <= 12);
416 		
417 		percent[tokenAddress] 			= newSpeed;	
418 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
419 		maxcontribution[tokenAddress] 	= _maxcontribution;	
420 		
421 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
422 		uint256 HodlTime 				= _HodlingTime * 1 days;		
423 		hodlingTime[tokenAddress] 		= HodlTime;	
424 		
425 		if (DefaultToken == 0x0000000000000000000000000000000000000000) { DefaultToken = tokenAddress; } 
426 		
427 		if (tokenAddress == DefaultToken && contractstatus == false) {
428 			contractaddress[tokenAddress] 	= true;
429 		} else {         
430 			contractaddress[tokenAddress] 	= contractstatus; 
431 		}	
432 		
433 		emit onAddContractAddress(tokenAddress, contractstatus, _maxcontribution, _ContractSymbol, _PercentPermonth, HodlTime);
434     }
435 	
436 //-------o 02 - Update Token Price (USD)
437     function TokenPrice(address tokenAddress, uint256 price) public restricted  {
438         token_price[tokenAddress] = price;	
439     }
440 	
441 //-------o 03 - Withdraw Ethereum 
442     function WithdrawEth() restricted public {
443         require(address(this).balance > 0); 
444 		uint256 amount = address(this).balance;
445 		
446 		EthereumVault[0x0] = 0;   
447         msg.sender.transfer(amount);
448     }
449     
450 //-------o 04 Ethereum Nodes Fees   
451     function EthereumNodesFees(address tokenAddress) restricted public {
452         require(EthereumVault[tokenAddress] > 0);
453         
454         uint256 amount 								= EthereumVault[tokenAddress];
455 		_totalSaved[tokenAddress] 					= sub(_totalSaved[tokenAddress], amount); 
456 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
457 		Statistics[msg.sender][tokenAddress][2] 	= add(Statistics[msg.sender][tokenAddress][2], amount); 
458         EthereumVault[tokenAddress] = 0;
459 		
460         ERC20Interface token = ERC20Interface(tokenAddress);
461         
462         require(token.balanceOf(address(this)) >= amount);
463         token.transfer(msg.sender, amount);
464     }
465 	
466 //-------o 05 Hold Platform
467     function Holdplatform_Airdrop(address tokenAddress, bool HPM_status, uint256 HPM_ratio) public restricted {
468 		require(HPM_ratio <= 100000 );
469 		
470 		Holdplatform_status[tokenAddress] 	= HPM_status;	
471 		Holdplatform_ratio[tokenAddress] 	= HPM_ratio;	// 100% = 100.000
472 	
473     }	
474 	
475 	function Holdplatform_Deposit(uint256 amount) restricted public {
476 		require(amount > 0 );
477         
478        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
479         require(token.transferFrom(msg.sender, address(this), amount));
480 		
481 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
482 		Holdplatform_balance 	= newbalance;
483     }
484 	
485 	function Holdplatform_Withdraw(uint256 amount) restricted public {
486         require(Holdplatform_balance > 0);
487         
488 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
489 		Holdplatform_balance 	= newbalance;
490         
491         ERC20Interface token = ERC20Interface(Holdplatform_address);
492         
493         require(token.balanceOf(address(this)) >= amount);
494         token.transfer(msg.sender, amount);
495     }
496 	
497 //-------o 06 - Return All Tokens To Their Respective Addresses    
498     function ReturnAllTokens() restricted public
499     {
500 
501         for(uint256 i = 1; i < _currentIndex; i++) {            
502             Safe storage s = _safes[i];
503             if (s.id != 0) {
504 				
505 				if(s.amountbalance > 0) {
506 					uint256 amount = add(s.amountbalance, s.cashbackbalance);
507 					PayToken(s.user, s.tokenAddress, amount);
508 					
509 				}
510 				
511 
512                 
513             }
514         }
515 		
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