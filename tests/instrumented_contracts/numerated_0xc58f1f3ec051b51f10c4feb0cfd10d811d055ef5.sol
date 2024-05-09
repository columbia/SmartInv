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
21     =          Version 7.5         =
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
48 	event onAddContractAddress(address indexed contracthodler, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth, uint256 _HodlingTime);	
49 	
50 	event onHoldplatformsetting(address indexed Tokenairdrop, bool HPM_status, uint256 HPM_divider, uint256 HPM_ratio, uint256 datetime);	
51 	event onHoldplatformdeposit(uint256 amount, uint256 newbalance, uint256 datetime);	
52 	event onHoldplatformwithdraw(uint256 amount, uint256 newbalance, uint256 datetime);	
53 	event onReceiveAirdrop(uint256 amount, uint256 datetime);	
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
101 	mapping(uint256 => uint256) 		public TXCount; 			
102 	//1st uint256, Category >>> 1 = Total User, 2 = Total TX Hold, 3 = Total TX Unlock, 4 = Total TX Airdrop, 5 = Total TX Affiliate Withdraw
103 
104 	mapping (address => mapping (uint256 => uint256)) 	public token_price; 				
105 	//2th uint256, Category >>> 1 = Current Price, 2 = ATH Price, 3 = ATL Price		
106 			
107 	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
108 	//3rd uint256, Category >>> 1 = LifetimeContribution, 2 = LifetimePayments, 3 = Affiliatevault, 4 = Affiliateprofit, 5 = ActiveContribution
109 	
110 	
111 		// Airdrop - Hold Platform (HPM)
112 								
113 	address public Holdplatform_address;	
114 	uint256 public Holdplatform_balance; 	
115 	mapping(address => bool) 	public Holdplatform_status;
116 	mapping(address => uint256) public Holdplatform_divider; 	
117 	
118  
119 	
120 	/*==============================
121     =          CONSTRUCTOR         =
122     ==============================*/  	
123    
124     constructor() public {     	 	
125         idnumber 				= 500;
126 		Holdplatform_address	= 0x23bAdee11Bf49c40669e9b09035f048e9146213e;	//Change before deploy
127     }
128     
129 	
130 	/*==============================
131     =    AVAILABLE FOR EVERYONE    =
132     ==============================*/  
133 
134 //-------o Function 01 - Ethereum Payable
135 
136     function () public payable {    
137         revert();	 
138     }
139 	
140 	
141 //-------o Function 02 - Cashback Code
142 
143     function CashbackCode(address _cashbackcode) public {		
144 		require(_cashbackcode != msg.sender);		
145 		if (cashbackcode[msg.sender] == 0 && activeuser[_cashbackcode] >= 1) { 
146 		cashbackcode[msg.sender] = _cashbackcode; }
147 		else { cashbackcode[msg.sender] = EthereumNodes; }		
148 		
149 	emit onCashbackCode(msg.sender, _cashbackcode);		
150     } 
151 	
152 //-------o Function 03 - Contribute 
153 
154 	//--o 01
155     function Holdplatform(address tokenAddress, uint256 amount) public {
156         require(tokenAddress != 0x0);
157 		require(amount > 0 && add(Statistics[msg.sender][tokenAddress][5], amount) <= maxcontribution[tokenAddress] );
158 		
159 		if (contractaddress[tokenAddress] == false) { revert(); } else { 		
160 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
161         require(token.transferFrom(msg.sender, address(this), amount));	
162 		
163 		HodlTokens2(tokenAddress, amount);}							
164 	}
165 	
166 		//--o 02	
167     function HodlTokens2(address tokenAddress, uint256 amount) private {
168 		
169 		if (Holdplatform_status[tokenAddress] == true) {
170 		require(Holdplatform_balance > 0 );
171 		
172 		uint256 divider 		= Holdplatform_divider[tokenAddress];
173 		uint256 airdrop			= div(amount, divider);
174 		
175 		address airdropaddress			= Holdplatform_address;
176 		ERC20Interface token 	= ERC20Interface(airdropaddress);        
177         token.transfer(msg.sender, airdrop);
178 		
179 		Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
180 		TXCount[4]++;
181 	
182 		emit onReceiveAirdrop(airdrop, now);
183 		}	
184 		
185 		HodlTokens3(tokenAddress, amount);
186 	}
187 	
188 	
189 	//--o 03	
190     function HodlTokens3(address ERC, uint256 amount) private {
191 		
192 		uint256 AvailableBalances 					= div(mul(amount, 72), 100);	
193 		
194 		if (cashbackcode[msg.sender] == 0 ) { //--o  Hold without cashback code
195 		
196 			address ref								= EthereumNodes;
197 			cashbackcode[msg.sender] 				= EthereumNodes;
198 			uint256 AvailableCashback 				= 0; 			
199 			uint256 zerocashback 					= div(mul(amount, 28), 100); 
200 			Statistics[EthereumNodes][ERC][3] 		= add(Statistics[EthereumNodes][ERC][3], zerocashback);
201 			Statistics[EthereumNodes][ERC][4]		= add(Statistics[EthereumNodes][ERC][4], zerocashback); 		
202 			
203 		} else { 	//--o  Cashback code has been activated
204 		
205 			ref										= cashbackcode[msg.sender];
206 			uint256 affcomission 					= div(mul(amount, 12), 100); 	
207 			AvailableCashback 						= div(mul(amount, 16), 100);			
208 			uint256 ReferrerContribution 			= Statistics[ref][ERC][5];		
209 			uint256 ReferralContribution			= add(Statistics[ref][ERC][5], amount);
210 			
211 			if (ReferrerContribution >= ReferralContribution) { //--o  if referrer contribution >= referral contribution
212 		
213 				Statistics[ref][ERC][3] 			= add(Statistics[ref][ERC][3], affcomission); 
214 				Statistics[ref][ERC][4] 			= add(Statistics[ref][ERC][4], affcomission); 	
215 				
216 			} else {											//--o  if referral contribution > referrer contribution
217 			
218 				uint256 Newbie 						= div(mul(ReferrerContribution, 12), 100); 			
219 				Statistics[ref][ERC][3]				= add(Statistics[ref][ERC][3], Newbie); 
220 				Statistics[ref][ERC][4] 			= add(Statistics[ref][ERC][4], Newbie); 
221 				
222 				uint256 NodeFunds 					= sub(affcomission, Newbie);	
223 				Statistics[EthereumNodes][ERC][3] 	= add(Statistics[EthereumNodes][ERC][3], NodeFunds);
224 				Statistics[EthereumNodes][ERC][4] 	= add(Statistics[EthereumNodes][ERC][4], NodeFunds); 				
225 			}
226 		} 
227 
228 		HodlTokens4(ERC, amount, AvailableBalances, AvailableCashback, ref); 	
229 	}
230 	//--o 04	
231     function HodlTokens4(address ERC, uint256 amount, uint256 AvailableBalances, uint256 AvailableCashback, address ref) private {
232 	    
233 	    ERC20Interface token 	= ERC20Interface(ERC); 	
234 		uint256 TokenPercent 	= percent[ERC];	
235 		uint256 TokenHodlTime 	= hodlingTime[ERC];	
236 		uint256 HodlTime		= add(now, TokenHodlTime);
237 		
238 		uint256 AM = amount; 	uint256 AB = AvailableBalances;		uint256 AC = AvailableCashback;	
239 		amount 	= 0; AvailableBalances = 0; AvailableCashback = 0;
240 		
241 		_safes[idnumber] = Safe(idnumber, AM, HodlTime, msg.sender, ERC, token.symbol(), AB, AC, now, TokenPercent, 0, 0, 0, ref, false);	
242 				
243 		Statistics[msg.sender][ERC][1]			= add(Statistics[msg.sender][ERC][1], AM); 
244 		Statistics[msg.sender][ERC][5]  		= add(Statistics[msg.sender][ERC][5], AM); 			
245 		AllContribution[ERC] 					= add(AllContribution[ERC], AM);   	
246         TokenBalance[ERC] 						= add(TokenBalance[ERC], AM);  
247 		activeuser[msg.sender] 					= 1;  	
248 
249 		if(activeuser[msg.sender] == 1 ) {
250         idaddress[msg.sender].push(idnumber); idnumber++; TXCount[2]++;  }		
251 		else { 
252 		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; TXCount[1]++; TXCount[2]++; TotalUser++;   }
253 		
254         emit onHoldplatform(msg.sender, ERC, token.symbol(), AM, HodlTime);		
255 			
256 	}
257 
258 //-------o Function 05 - Claim Token That Has Been Unlocked
259     function ClaimTokens(address tokenAddress, uint256 id) public {
260         require(tokenAddress != 0x0);
261         require(id != 0);        
262         
263         Safe storage s = _safes[id];
264         require(s.user == msg.sender);  
265 		require(s.tokenAddress == tokenAddress);
266 		
267 		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
268     }
269     //--o 01
270     function UnlockToken2(address ERC, uint256 id) private {
271         Safe storage s = _safes[id];      
272         require(s.id != 0);
273         require(s.tokenAddress == ERC);
274 
275         uint256 eventAmount				= s.amountbalance;
276         address eventTokenAddress 		= s.tokenAddress;
277         string memory eventTokenSymbol 	= s.tokenSymbol;		
278 		     
279         if(s.endtime < now){ //--o  Hold Complete
280         
281 		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
282 		Statistics[msg.sender][ERC][5] 			= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 		
283 		s.lastwithdraw 							= s.amountbalance;   s.amountbalance = 0;   s.lasttime = now;  		
284 		PayToken(s.user, s.tokenAddress, amounttransfer); 
285 		
286 		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
287             s.tokenreceive 	= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
288             }
289 			else {
290 			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
291 			}
292 			
293 		s.cashbackbalance = 0;	
294 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
295 		
296         } else { UnlockToken3(ERC, s.id); }
297         
298     }   
299 	//--o 02
300 	function UnlockToken3(address ERC, uint256 id) private {		
301 		Safe storage s = _safes[id];
302         
303         require(s.id != 0);
304         require(s.tokenAddress == ERC);		
305 			
306 		uint256 timeframe  			= sub(now, s.lasttime);			                            
307 		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
308 							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
309 		                         
310 		uint256 MaxWithdraw 		= div(s.amount, 10);
311 			
312 		//--o Maximum withdraw before unlocked, Max 10% Accumulation
313 			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
314 			
315 		//--o Maximum withdraw = User Amount Balance   
316 			if (MaxAccumulation > s.amountbalance) { uint256 realAmount1 = s.amountbalance; } else { realAmount1 = MaxAccumulation; }
317 			
318 		uint256 realAmount			= add(s.cashbackbalance, realAmount1); 			
319 		uint256 newamountbalance 	= sub(s.amountbalance, realAmount);
320 		s.cashbackbalance 			= 0; 
321 		s.amountbalance 			= newamountbalance;
322 		s.lastwithdraw 				= realAmount; 
323 		s.lasttime 					= now; 		
324 			
325 		UnlockToken4(ERC, id, newamountbalance, realAmount);		
326     }   
327 	//--o 03
328     function UnlockToken4(address ERC, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
329         Safe storage s = _safes[id];
330         
331         require(s.id != 0);
332         require(s.tokenAddress == ERC);
333 
334         uint256 eventAmount				= realAmount;
335         address eventTokenAddress 		= s.tokenAddress;
336         string memory eventTokenSymbol 	= s.tokenSymbol;		
337 
338 		uint256 tokenaffiliate 		= div(mul(s.amount, 12), 100) ; 
339 		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ; 	
340 		
341 			if (cashbackcode[msg.sender] == EthereumNodes  ) {
342 			uint256 tokenreceived 	= sub(sub(sub(s.amount, tokenaffiliate), maxcashback), newamountbalance) ;	
343 			}else { tokenreceived 	= sub(sub(s.amount, tokenaffiliate), newamountbalance) ;}
344 			
345 		uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
346 		
347 		s.tokenreceive 					= tokenreceived; 
348 		s.percentagereceive 			= percentagereceived; 		
349 
350 		PayToken(s.user, s.tokenAddress, realAmount);           		
351 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
352     } 
353 	//--o Pay Token
354     function PayToken(address user, address tokenAddress, uint256 amount) private {
355         
356         ERC20Interface token = ERC20Interface(tokenAddress);        
357         require(token.balanceOf(address(this)) >= amount);
358         token.transfer(user, amount);
359 		
360 		TokenBalance[tokenAddress] 					= sub(TokenBalance[tokenAddress], amount); 
361 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
362 		Statistics[msg.sender][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 
363 		
364 		TXCount[3]++;
365 
366 		AirdropToken(tokenAddress, amount);   
367 	}
368 	
369 		//--o 02	
370     function AirdropToken(address tokenAddress, uint256 amount) private {
371 		
372 		if (Holdplatform_status[tokenAddress] == true) {
373 		require(Holdplatform_balance > 0 );
374 		
375 		uint256 divider 		= Holdplatform_divider[tokenAddress];
376 		uint256 airdrop			= div(div(amount, divider), 4);
377 		
378 		address airdropaddress	= Holdplatform_address;
379 		ERC20Interface token 	= ERC20Interface(airdropaddress);        
380         token.transfer(msg.sender, airdrop);
381 		
382 		Holdplatform_balance	= sub(Holdplatform_balance, airdrop);
383 		TXCount[4]++;
384 		
385 		emit onReceiveAirdrop(airdrop, now);
386 		}	
387 	}
388 	
389 //-------o Function 06 - Get How Many Contribute ?
390 
391     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
392         return idaddress[hodler].length;
393     }
394 	
395 //-------o Function 07 - Get How Many Affiliate ?
396 
397     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
398         return afflist[hodler].length;
399     }
400     
401 //-------o Function 08 - Get complete data from each user
402 	function GetSafe(uint256 _id) public view
403         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
404     {
405         Safe storage s = _safes[_id];
406         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
407     }
408 	
409 //-------o Function 09 - Withdraw Affiliate Bonus
410 
411     function WithdrawAffiliate(address user, address tokenAddress) public {  
412 		require(tokenAddress != 0x0);		
413 		require(Statistics[user][tokenAddress][3] > 0 );
414 		
415 		uint256 amount = Statistics[msg.sender][tokenAddress][3];
416 		Statistics[msg.sender][tokenAddress][3] = 0;
417 		
418 		TokenBalance[tokenAddress] 		= sub(TokenBalance[tokenAddress], amount); 
419 		AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], amount);
420 		
421 		uint256 eventAmount				= amount;
422         address eventTokenAddress 		= tokenAddress;
423         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
424         
425         ERC20Interface token = ERC20Interface(tokenAddress);        
426         require(token.balanceOf(address(this)) >= amount);
427         token.transfer(user, amount);
428 		
429 		Statistics[user][tokenAddress][2] 	= add(Statistics[user][tokenAddress][2], amount);
430 
431 		TXCount[5]++;		
432 		
433 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
434     } 		
435 	
436 	
437 	/*==============================
438     =          RESTRICTED          =
439     ==============================*/  	
440 
441 //-------o 01 Add Contract Address	
442     function AddContractAddress(address tokenAddress, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol, uint256 _PercentPermonth) public restricted {
443 		uint256 newSpeed	= _PercentPermonth;
444 		require(newSpeed >= 3 && newSpeed <= 12);
445 		
446 		percent[tokenAddress] 			= newSpeed;	
447 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
448 		maxcontribution[tokenAddress] 	= _maxcontribution;	
449 		
450 		uint256 _HodlingTime 			= mul(div(72, newSpeed), 30);
451 		uint256 HodlTime 				= _HodlingTime * 1 days;		
452 		hodlingTime[tokenAddress] 		= HodlTime;	
453 		
454 		if (DefaultToken == 0x0000000000000000000000000000000000000000) { DefaultToken = tokenAddress; } 
455 		
456 		if (tokenAddress == DefaultToken && contractstatus == false) {
457 			contractaddress[tokenAddress] 	= true;
458 		} else {         
459 			contractaddress[tokenAddress] 	= contractstatus; 
460 		}	
461 		
462 		emit onAddContractAddress(tokenAddress, contractstatus, _maxcontribution, _ContractSymbol, _PercentPermonth, HodlTime);
463     }
464 	
465 //-------o 02 - Update Token Price (USD)
466 	
467 	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ATHprice, uint256 ATLprice) public restricted  {
468 		
469 		if (Currentprice > 0  ) { token_price[tokenAddress][1] = Currentprice; }
470 		if (ATHprice > 0  ) { token_price[tokenAddress][2] = ATHprice; }
471 		if (ATLprice > 0  ) { token_price[tokenAddress][3] = ATLprice; }
472 
473     }
474 	
475 //-------o 03 Hold Platform
476     function Holdplatform_Airdrop(address tokenAddress, bool HPM_status, uint256 HPM_divider) public restricted {
477 		
478 		Holdplatform_status[tokenAddress] 	= HPM_status;	
479 		Holdplatform_divider[tokenAddress] 	= HPM_divider;	// Airdrop = 100% : Divider
480 		uint256 HPM_ratio					= div(100, HPM_divider);
481 		
482 		emit onHoldplatformsetting(tokenAddress, HPM_status, HPM_divider, HPM_ratio, now);
483 	
484     }	
485 	//--o Deposit
486 	function Holdplatform_Deposit(uint256 amount) restricted public {
487 		require(amount > 0 );
488         
489        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
490         require(token.transferFrom(msg.sender, address(this), amount));
491 		
492 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
493 		Holdplatform_balance 	= newbalance;
494 		
495 		emit onHoldplatformdeposit(amount, newbalance, now);
496     }
497 	//--o Withdraw
498 	function Holdplatform_Withdraw(uint256 amount) restricted public {
499         require(Holdplatform_balance > 0);
500         
501 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
502 		Holdplatform_balance 	= newbalance;
503         
504         ERC20Interface token = ERC20Interface(Holdplatform_address);
505         
506         require(token.balanceOf(address(this)) >= amount);
507         token.transfer(msg.sender, amount);
508 		
509 		emit onHoldplatformwithdraw(amount, newbalance, now);
510     }
511 	
512 //-------o 04 - Return All Tokens To Their Respective Addresses    
513     function ReturnAllTokens() restricted public
514     {
515 
516         for(uint256 i = 1; i < idnumber; i++) {            
517             Safe storage s = _safes[i];
518             if (s.id != 0) {
519 				
520 				if(s.amountbalance > 0) {
521 					uint256 amount = add(s.amountbalance, s.cashbackbalance);
522 					PayToken(s.user, s.tokenAddress, amount);
523 					
524 				}
525 				
526 
527                 
528             }
529         }
530 		
531     }   
532 	
533 	
534 	/*==============================
535     =      SAFE MATH FUNCTIONS     =
536     ==============================*/  	
537 	
538 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
539 		if (a == 0) {
540 			return 0;
541 		}
542 		uint256 c = a * b; 
543 		require(c / a == b);
544 		return c;
545 	}
546 	
547 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
548 		require(b > 0); 
549 		uint256 c = a / b;
550 		return c;
551 	}
552 	
553 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
554 		require(b <= a);
555 		uint256 c = a - b;
556 		return c;
557 	}
558 	
559 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
560 		uint256 c = a + b;
561 		require(c >= a);
562 		return c;
563 	}
564     
565 }
566 
567 
568 	/*==============================
569     =        ERC20 Interface       =
570     ==============================*/ 
571 
572 contract ERC20Interface {
573 
574     uint256 public totalSupply;
575     uint256 public decimals;
576     
577     function symbol() public view returns (string);
578     function balanceOf(address _owner) public view returns (uint256 balance);
579     function transfer(address _to, uint256 _value) public returns (bool success);
580     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
581     function approve(address _spender, uint256 _value) public returns (bool success);
582     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
583 
584     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
585     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
586 }