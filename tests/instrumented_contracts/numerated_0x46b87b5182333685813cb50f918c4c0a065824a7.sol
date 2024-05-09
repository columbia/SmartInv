1 pragma solidity ^0.4.25;
2 
3 ////// Version 6.1 ////// 
4 
5 // Contract 01
6 contract EthereumSmartContract {    
7 	address oooooo; 
8 	
9     constructor() public { 
10         oooooo = msg.sender;
11     }
12     modifier restricted() {
13         require(msg.sender == oooooo);
14         _;
15     } 
16 	
17     function ooooooo() public view returns (address ooooo) {
18         return oooooo;
19     }
20       
21 }
22 
23 // Contract 02
24 contract ldoh is EthereumSmartContract {
25 	
26 	
27 	// Event
28 	event onAddContractAddress(address indexed contracthodler, bool contractstatus, uint256 _maxcontribution);    
29 	event onCashbackCode(address indexed hodler, address cashbackcode);
30     event onHodlTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
31     event onClaimTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);	
32     event onReturnAll(uint256 returned);
33 	
34     // Variables 	
35     address internal ABCDtoken;
36 	
37 	// Struct Database
38 
39     struct Safe {
40         uint256 id;						// 01 -- > Registration Number
41         uint256 amount;					// 02 -- > Total amount of contribution to this transaction
42         uint256 endtime;				// 03 -- > The Expiration Of A Hold Platform Based On Unix Time
43         address user;					// 04 -- > The ETH address that you are using
44         address tokenAddress;			// 05 -- > The Token Contract Address That You Are Using
45 		string  tokenSymbol;			// 06 -- > The Token Symbol That You Are Using
46 		uint256 amountbalance; 			// 07 -- > 88% from Contribution / 72% Without Cashback
47 		uint256 cashbackbalance; 		// 08 -- > 16% from Contribution
48 		uint256 lasttime; 				// 09 -- > The Last Time You Withdraw Based On Unix Time
49 		uint256 percentage; 			// 10 -- > The percentage of tokens that are unlocked every month ( Default = 3% )
50 		uint256 percentagereceive; 		// 11 -- > The Percentage You Have Received
51 		uint256 tokenreceive; 			// 12 -- > The Number Of Tokens You Have Received
52 		uint256 lastwithdraw; 			// 13 -- > The Last Amount You Withdraw
53 		address referrer; 				// 14 -- > Your ETH referrer address
54 
55     }
56 	
57 		
58 	// Uint256
59 	
60 	uint256 public 	percent 				= 3;        	// 01 -- > Monthly Unlock Percentage
61 	uint256 private constant affiliate 		= 12;        	// 02 -- > Affiliate Bonus = 12% Of Total Contributions
62 	uint256 private constant cashback 		= 16;        	// 03 -- > Cashback Bonus = 16% Of Total Contributions
63 	uint256 private constant nocashback 	= 28;        	// 04 -- > Total % loss amount if you don't get cashback
64 	uint256 private constant totalreceive 	= 88;        	// 05 -- > The total amount you will receive
65     uint256 private constant seconds30days 	= 2592000;  	// 06 -- > Number Of Seconds In One Month
66 	uint256 private IDNumber; 								// 07 -- > ID number ( Start from 500 )
67 	uint256 public  TotalUser; 								// 08 -- > Total Smart Contract User
68 	uint256 public  hodlingTime;							// 09 -- > Length of hold time in seconds
69 	
70 	// Mapping
71 	
72 	mapping(address => bool) 		public contractaddress; 	// 01 -- > Contract Address
73 	mapping(address => uint256) 	public maxcontribution; 	// 02 -- > Maximum Contribution
74 	mapping(address => address) 	public cashbackcode; 		// 03 -- > Cashback Code 
75 	mapping(address => uint256) 	public TokenBalance; 		// 04 -- > Token Balance
76 	mapping(address => uint256) 	public AllContribution; 	// 05 -- > Deposit amount for all members
77 	mapping(address => uint256) 	public AllPayments; 		// 06 -- > Withdraw amount for all members
78 	mapping(address => uint256[]) 	public IDAddress;			// 07 -- > Search ID by Address
79 	mapping(uint256 => Safe) 		private _safes; 			// 08 -- > Struct safe database
80 	mapping(address => uint256) 	private EthereumVault;    	// 09 -- > Reserve Funds
81 	
82 	// Double Mapping
83 
84 	mapping (address => mapping (address => uint256)) public LifetimeContribution;		// 01 -- > Total Deposit Amount Based On Address And Token
85 	mapping (address => mapping (address => uint256)) public Affiliatevault;			// 02 -- > Affiliate Balance That Hasn't Been Withdrawn
86 	mapping (address => mapping (address => uint256)) public Affiliateprofit;			// 03 -- > The Amount Of Profit As An Affiliate
87     
88 	// Miscellaneous
89 	
90 	address[] public _listedReserves;		// ?????
91 
92     //Constructor
93    
94     constructor() public {
95         
96         ABCDtoken 		= 0x8b70a0697F4C2F12De6B65904df0fC8e61547f46;        
97         hodlingTime 	= 730 days;
98         IDNumber 		= 500;
99     }
100 	
101 	
102 ////////////////////////////////// Function //////////////////////////////////
103 
104 	
105 // Function 01 - Fallback Function To Receive Donation In Eth
106     function () public payable {
107         require(msg.value > 0);       
108         EthereumVault[0x0] = add(EthereumVault[0x0], msg.value);
109     }
110 	
111 // Function 02 - Contribute (Hodl Platform)
112     function HodlTokens(address tokenAddress, uint256 amount) public {
113         require(tokenAddress != 0x0);
114         require(amount > 0 && amount <= maxcontribution[tokenAddress] );
115 		
116 		if (contractaddress[tokenAddress] == false) {
117 			revert();
118 		}
119 		else {
120 			
121 		
122         ERC20Interface token = ERC20Interface(tokenAddress);       
123         require(token.transferFrom(msg.sender, address(this), amount));
124 		
125 		uint256 affiliatecomission 			= div(mul(amount, affiliate), 100); 	
126 		uint256 WithoutCashback 			= div(mul(amount, nocashback), 100); 	
127 		
128 		 	if (cashbackcode[msg.sender] == 0 ) { 	
129 			
130 			uint256 data_amountbalance 		= div(mul(amount, 72), 100);		
131 			uint256 data_cashbackbalance 	= 0; 
132 			address data_referrer			= oooooo;
133 			
134 			cashbackcode[msg.sender] = oooooo;
135 			emit onCashbackCode(msg.sender, oooooo);
136 			
137 			EthereumVault[tokenAddress] 	= add(EthereumVault[tokenAddress], WithoutCashback);
138 			
139 			
140 			} else { 	
141 			
142 			data_referrer					= cashbackcode[msg.sender];			
143 			data_amountbalance 				= sub(amount, affiliatecomission);			
144 			data_cashbackbalance 			= div(mul(amount, cashback), 100);	
145 			uint256 referrer_contribution 	= LifetimeContribution[data_referrer][tokenAddress];
146 			
147 			
148 				if (referrer_contribution >= amount) {
149 		
150 					Affiliatevault[data_referrer][tokenAddress] 	= add(Affiliatevault[data_referrer][tokenAddress], affiliatecomission); 
151 					Affiliateprofit[data_referrer][tokenAddress] 	= add(Affiliateprofit[data_referrer][tokenAddress], affiliatecomission); 
152 					
153 				} else {
154 					
155 					uint256 Newbie 	= div(mul(referrer_contribution, affiliate), 100); 
156 					
157 					Affiliatevault[data_referrer][tokenAddress] 	= add(Affiliatevault[data_referrer][tokenAddress], Newbie); 
158 					Affiliateprofit[data_referrer][tokenAddress] 	= add(Affiliateprofit[data_referrer][tokenAddress], Newbie); 
159 					
160 					uint256 data_unusedfunds 		= sub(affiliatecomission, Newbie);	
161 					EthereumVault[tokenAddress] 	= add(EthereumVault[tokenAddress], data_unusedfunds);
162 					
163 				}
164 			
165 			} 			
166 			  		  				  					  
167 	// Insert to Database  			 	  
168 		IDAddress[msg.sender].push(IDNumber);
169 		_safes[IDNumber] = 
170 
171 		Safe(
172 		IDNumber, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, data_referrer);	
173 
174 		LifetimeContribution[msg.sender][tokenAddress] = add(LifetimeContribution[msg.sender][tokenAddress], amount); 		
175 		
176 	// Update Token Balance, ID Number, Total User	
177 	
178 		AllContribution[tokenAddress] 	= add(AllContribution[tokenAddress], amount);    
179         TokenBalance[tokenAddress] 		= add(TokenBalance[tokenAddress], amount);     		
180         IDNumber++;
181         TotalUser++;
182         
183         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
184     }	
185 			
186 			
187 }
188 		
189 	
190 // Function 03 - Claim Tokens
191     function ClaimTokens(address tokenAddress, uint256 id) public {
192         require(tokenAddress != 0x0);
193         require(id != 0);        
194         
195         Safe storage s = _safes[id];
196         require(s.user == msg.sender);  
197 		
198 		if (s.amountbalance == 0) {
199 			revert();
200 		}
201 		else {
202 			RetireHodl(tokenAddress, id);
203 		}
204     }
205     
206     function RetireHodl(address tokenAddress, uint256 id) private {
207         Safe storage s = _safes[id];
208         
209         require(s.id != 0);
210         require(s.tokenAddress == tokenAddress);
211 
212         uint256 eventAmount;
213         address eventTokenAddress = s.tokenAddress;
214         string memory eventTokenSymbol = s.tokenSymbol;		
215 		     
216         if(s.endtime < now) // Hodl Complete
217         {
218             PayToken(s.user, s.tokenAddress, s.amountbalance);
219             
220             eventAmount 					= s.amountbalance;
221 			TokenBalance[s.tokenAddress] 	= sub(TokenBalance[s.tokenAddress], s.amountbalance); 
222 			AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], s.amountbalance);
223 		
224 			s.lastwithdraw 					= s.amountbalance;
225 			s.amountbalance 				= 0;
226 			s.lasttime 						= now;  
227 			s.tokenreceive 					= div(mul(s.amount, totalreceive), 100) ;
228 			s.percentagereceive 			= mul(mul(88, 100), 100000000000000000000) ;
229 		
230 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
231 		
232         }
233         else 
234         {
235 			
236 			uint256 timeframe  			= sub(now, s.lasttime);			                            
237 			uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), seconds30days); 
238 		//	uint256 CalculateWithdraw   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
239 		                         
240 			uint256 MaxWithdraw 		= div(s.amount, 10);
241 			
242 			// Maximum withdraw before unlocked, Max 10% Accumulation
243 			if (CalculateWithdraw > MaxWithdraw) { 				
244 			uint256 MaxAccumulation = MaxWithdraw; 
245 			} else { MaxAccumulation = CalculateWithdraw; }
246 			
247 			// Maximum withdraw = User Amount Balance   
248 			if (MaxAccumulation > s.amountbalance) { 			     	
249 			uint256 realAmount = s.amountbalance; 
250 			} else { realAmount = MaxAccumulation; }
251 			
252 			s.lastwithdraw = realAmount;  			
253 			
254 			AllPayments[tokenAddress] 	= add(AllPayments[tokenAddress], realAmount);
255 			
256 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
257 			UpdateUserData(tokenAddress, id, newamountbalance, realAmount);
258 			
259 		}
260         
261     }   
262 
263     function UpdateUserData(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
264         Safe storage s = _safes[id];
265         
266         require(s.id != 0);
267         require(s.tokenAddress == tokenAddress);
268 
269         uint256 eventAmount;
270         address eventTokenAddress = s.tokenAddress;
271         string memory eventTokenSymbol = s.tokenSymbol;			
272    			
273 		s.amountbalance 				= newamountbalance;  
274 		s.lasttime 						= now;  
275 		
276 			uint256 tokenaffiliate 		= div(mul(s.amount, affiliate), 100) ; 
277 			uint256 maxcashback 		= div(mul(s.amount, cashback), 100) ; 		
278 			uint256 tokenreceived 		= sub(add(sub(sub(s.amount, tokenaffiliate), newamountbalance), s.cashbackbalance), maxcashback) ;		
279 		//	uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance + s.cashbackbalance - maxcashback ;
280 			
281 			// Cashback = 100 - 12 - 88 + 16 - 16 = 0 ----> WithoutCashback 	= 100 - 12 - 72 + 0 - 16 = 1
282 
283 			uint256 percentagereceived 	= mul(div(tokenreceived, s.amount), 100000000000000000000) ; 	
284 		
285 		s.tokenreceive 					= tokenreceived; 
286 		s.percentagereceive 			= percentagereceived; 		
287 		TokenBalance[s.tokenAddress] 	= sub(TokenBalance[s.tokenAddress], realAmount); 
288 		
289 		
290 	        PayToken(s.user, s.tokenAddress, realAmount);           		
291             eventAmount = realAmount;
292 			
293 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
294     } 
295 
296     function PayToken(address user, address tokenAddress, uint256 amount) private {
297         
298         ERC20Interface token = ERC20Interface(tokenAddress);        
299         require(token.balanceOf(address(this)) >= amount);
300         token.transfer(user, amount);
301     }   	
302 	
303 // Function 04 - Get How Many Contribute ?
304     function TotalContribution(address hodler) public view returns (uint256 length) {
305         return IDAddress[hodler].length;
306     }
307     
308 // Function 05 - Get Data Values
309 	function GetSafe(uint256 _id) public view
310         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
311     {
312         Safe storage s = _safes[_id];
313         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
314     }
315 	
316 // Function 06 - Get Tokens Reserved 
317     function GetTokenFees(address tokenAddress) public view returns (uint256 amount) {
318         return EthereumVault[tokenAddress];
319     }    
320     
321 // Function 07 - Cashback Code  
322     function CashbackCode(address _cashbackcode) public {
323         require(_cashbackcode != msg.sender);
324 		
325 		if (cashbackcode[msg.sender] == 0) {
326 			cashbackcode[msg.sender] = _cashbackcode;
327 			emit onCashbackCode(msg.sender, _cashbackcode);
328 		}		             
329     }  
330 	
331 // Function 08 - Withdraw Affiliate Bonus
332     function WithdrawAffiliate(address user, address tokenAddress) public {  
333 		require(tokenAddress != 0x0);
334 		require(user == msg.sender);
335   
336 		
337 		uint256 amount = Affiliatevault[msg.sender][tokenAddress];
338 		Affiliatevault[msg.sender][tokenAddress] = 0;
339         
340         ERC20Interface token = ERC20Interface(tokenAddress);        
341         require(token.balanceOf(address(this)) >= amount);
342         token.transfer(user, amount);
343 		
344 		
345     } 	
346 	
347 
348 ////////////////////////////////// restricted //////////////////////////////////
349 
350 // 01 - Add Contract Address	
351     function AddContractAddress(address tokenAddress, bool contractstatus, uint256 _maxcontribution) public restricted {
352         contractaddress[tokenAddress] = contractstatus;
353 		maxcontribution[tokenAddress] = _maxcontribution;
354 		
355 		emit onAddContractAddress(tokenAddress, contractstatus, _maxcontribution);
356     }
357 	
358 // 02 - Add Maximum Contribution	
359     function AddMaxContribution(address tokenAddress, uint256 _maxcontribution) public restricted {
360         maxcontribution[tokenAddress] = _maxcontribution;	
361     }
362 	
363 // 03 - Add Retire Hodl	
364     function AddRetireHodl(address tokenAddress, uint256 id) public restricted {
365         require(tokenAddress != 0x0);
366         require(id != 0);      
367         RetireHodl(tokenAddress, id);
368     }
369     
370 // 04 - Change Hodling Time   
371     function ChangeHodlingTime(uint256 newHodlingDays) restricted public {
372         require(newHodlingDays >= 180);      
373         hodlingTime = newHodlingDays * 1 days;
374     }               
375 
376 // 05 - Change Speed Distribution 
377     function ChangeSpeedDistribution(uint256 newSpeed) restricted public {
378         require(newSpeed <= 12);       
379 		percent = newSpeed;
380     }
381 	
382 // 06 - Withdraw Ethereum Received Through Fallback Function    
383     function WithdrawEth(uint256 amount) restricted public {
384         require(amount > 0); 
385         require(address(this).balance >= amount); 
386         
387         msg.sender.transfer(amount);
388     }
389     
390 // 07 - Withdraw Token Fees
391     function WithdrawTokenFees(address tokenAddress) restricted public {
392         require(EthereumVault[tokenAddress] > 0);
393         
394         uint256 amount = EthereumVault[tokenAddress];
395         EthereumVault[tokenAddress] = 0;
396         
397         ERC20Interface token = ERC20Interface(tokenAddress);
398         
399         require(token.balanceOf(address(this)) >= amount);
400         token.transfer(msg.sender, amount);
401     }
402 
403 	
404 // 08 - Return All Tokens To Their Respective Addresses    
405     function ReturnAllTokens(bool onlyABCD) restricted public
406     {
407         uint256 returned;
408 
409         for(uint256 i = 1; i < IDNumber; i++) {            
410             Safe storage s = _safes[i];
411             if (s.id != 0) {
412                 if (
413                     (onlyABCD && s.tokenAddress == ABCDtoken) ||
414                     !onlyABCD
415                     )
416                 {
417                     PayToken(s.user, s.tokenAddress, s.amountbalance);
418 					
419 					s.lastwithdraw 					= s.amountbalance;
420 					s.amountbalance 				= 0;
421 					s.lasttime 						= now;  
422 					s.tokenreceive 					= div(mul(s.amount, totalreceive), 100) ;
423 					s.percentagereceive 			= mul(mul(88, 100), 100000000000000000000) ;
424 					
425 					AllPayments[s.tokenAddress] 		= add(AllPayments[s.tokenAddress], s.amountbalance);
426 					
427 					TokenBalance[s.tokenAddress] 	= 0; 
428                     
429                     TotalUser--;
430                     returned++;
431                 }
432             }
433         }
434 
435         emit onReturnAll(returned);
436     }   
437 
438 	
439 
440     // SAFE MATH FUNCTIONS //
441 	
442 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
443 		if (a == 0) {
444 			return 0;
445 		}
446 
447 		uint256 c = a * b; 
448 		require(c / a == b);
449 		return c;
450 	}
451 	
452 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
453 		require(b > 0); 
454 		uint256 c = a / b;
455 		return c;
456 	}
457 	
458 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
459 		require(b <= a);
460 		uint256 c = a - b;
461 		return c;
462 	}
463 	
464 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
465 		uint256 c = a + b;
466 		require(c >= a);
467 		return c;
468 	}
469     
470 }
471 
472 contract ERC20Interface {
473 
474     uint256 public totalSupply;
475     uint256 public decimals;
476     
477     function symbol() public view returns (string);
478     function balanceOf(address _owner) public view returns (uint256 balance);
479     function transfer(address _to, uint256 _value) public returns (bool success);
480     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
481     function approve(address _spender, uint256 _value) public returns (bool success);
482     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
483 
484     // solhint-disable-next-line no-simple-event-func-name  
485     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
486     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
487 }