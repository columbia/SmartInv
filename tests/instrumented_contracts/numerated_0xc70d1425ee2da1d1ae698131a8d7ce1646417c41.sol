1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 ////// Version 4.4 ////// 
5 
6 // Contract 01
7 contract OwnableContract {    
8     event onTransferOwnership(address newOwner);
9 	address superOwner; 
10 	
11     constructor() public { 
12         superOwner = msg.sender;
13     }
14     modifier onlyOwner() {
15         require(msg.sender == superOwner);
16         _;
17     } 
18 	
19     function viewSuperOwner() public view returns (address owner) {
20         return superOwner;
21     }
22       
23     function changeOwner(address newOwner) onlyOwner public {
24         require(newOwner != superOwner);       
25         superOwner = newOwner;     
26         emit onTransferOwnership(superOwner);
27     }
28 }
29 
30 // Contract 02
31 contract BlockableContract is OwnableContract {    
32     event onBlockHODLs(bool status);
33     bool public blockedContract;
34     
35     constructor() public { 
36         blockedContract = false;  
37     }
38     
39     modifier contractActive() {
40         require(!blockedContract);
41         _;
42     } 
43     
44     function doBlockContract() onlyOwner public {
45         blockedContract = true;        
46         emit onBlockHODLs(blockedContract);
47     }
48     
49     function unBlockContract() onlyOwner public {
50         blockedContract = false;        
51         emit onBlockHODLs(blockedContract);
52     }
53 }
54 
55 // Contract 03
56 contract ldoh is BlockableContract {
57     
58 	event onCashbackCode(address indexed hodler, address cashbackcode);
59     event onStoreProfileHash(address indexed hodler, string profileHashed);
60     event onHodlTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
61     event onClaimTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
62     event onReturnAll(uint256 returned);
63 	
64     // Variables // * = New ** = Undeveloped	
65     address internal AXPRtoken;
66     mapping(address => string) 	public profileHashed; 		// User Prime 
67 	mapping(address => address) public cashbackcode; 		// Cashback Code 
68 	mapping(address => bool) 	public contractaddress; 	// Contract Address
69 	
70 	// Default Setting
71 	uint256 public 	percent 				= 1200;        	// * Percent Permonth ( Only Test = 1200% )
72 	uint256 private constant affiliate 		= 12;        	// * 12% from deposit
73 	uint256 private constant cashback 		= 16;        	// * 16% from deposit
74 	uint256 private constant totalreceive 	= 88;        	// * 88% from deposit	
75     uint256 private constant seconds30days 	= 2592000;  	// *
76 
77     struct Safe {
78         uint256 id;
79         uint256 amount;
80         uint256 endtime;
81         address user;
82         address tokenAddress;
83 		string  tokenSymbol;	
84 		uint256 amountbalance; 			// * --- > 88% from deposit
85 		uint256 cashbackbalance; 		// * --- > 16% from deposit
86 		uint256 lasttime; 				// * --- > Last Withdraw (Time)
87 		uint256 percentage; 			// * --- > return tokens every month
88 		uint256 percentagereceive; 		// * --- > 0 %
89 		uint256 tokenreceive; 			// * --- > 0 Token
90 		uint256 affiliatebalance; 		// ** --->>> Dont forget to develop
91 		uint256 lastwithdraw; 			// * --- > Last Withdraw (Amount)
92 		address referrer; 				// *
93 
94     }
95     
96 	mapping(address => uint256[]) 	public 	_userSafes;			// ?????
97     mapping(address => uint256) 	public 	_totalSaved; 		// Token Balance
98 	mapping(uint256 => Safe) 		private _safes; 			// Struct safe database
99     uint256 						private _currentIndex; 		// Sequential number ( Start from 500 )
100 	uint256 						public _countSafes; 		// Total Smart Contract User
101 	uint256 						public hodlingTime;			
102     uint256 						public allTimeHighPrice;
103     uint256 						public comission;
104 	
105     mapping(address => uint256) 	private _systemReserves;    // Token Balance ( Reserve )
106     address[] 						public _listedReserves;		// ?????
107     
108     //Constructor
109    
110     constructor() public {
111         
112         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;        
113         hodlingTime 	= 730 days;
114         _currentIndex 	= 500;
115         comission 		= 12;
116     }
117     
118 	
119 // Function 01 - Fallback Function To Receive Donation In Eth
120     function () public payable {
121         require(msg.value > 0);       
122         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
123     }
124 	
125 // Function 02 - Contribute (Hodl Platform)
126     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
127         require(tokenAddress != 0x0);
128         require(amount > 0);
129 		
130 		if (contractaddress[tokenAddress] == false) {
131 			revert();
132 		}
133 		else {
134 			
135 		
136         ERC20Interface token = ERC20Interface(tokenAddress);       
137         require(token.transferFrom(msg.sender, address(this), amount));
138 		
139 		uint256 affiliatecomission 		= div(mul(amount, affiliate), 100); 	// amount * affiliate / 100
140 		uint256 nocashback 				= div(mul(amount, 28), 100); 			// amount * 28 / 100
141 		
142 		 	if (cashbackcode[msg.sender] == 0 ) { 				
143 			uint256 data_amountbalance 		= div(mul(amount, 72), 100);		// amount * 72 / 100
144 			uint256 data_cashbackbalance 	= 0; 
145 			address data_referrer			= superOwner;
146 			
147 			cashbackcode[msg.sender] = superOwner;
148 			emit onCashbackCode(msg.sender, superOwner);
149 			
150 			_systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], nocashback);
151 			
152 			} else { 	
153 			data_amountbalance 		= sub(amount, affiliatecomission);			// amount - affiliatecomission
154 			data_cashbackbalance 	= div(mul(amount, cashback), 100);			// amount * cashback / 100
155 			data_referrer			= cashbackcode[msg.sender];
156 
157 			_systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], affiliatecomission); } //--->>> Dont forget to develop
158 			  		  				  					  
159 	// Insert to Database  			 	  
160 		_userSafes[msg.sender].push(_currentIndex);
161 		_safes[_currentIndex] = 
162 
163 		Safe(
164 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, 0, data_referrer);				
165 		
166 	// Update Token Balance, Current Index, CountSafes		
167         _totalSaved[tokenAddress] 		= add(_totalSaved[tokenAddress], amount);     		
168         _currentIndex++;
169         _countSafes++;
170         
171         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
172     }	
173 			
174 			
175 }
176 		
177 	
178 // Function 03 - Claim (Hodl Platform)	
179     function ClaimTokens(address tokenAddress, uint256 id) public {
180         require(tokenAddress != 0x0);
181         require(id != 0);        
182         
183         Safe storage s = _safes[id];
184         require(s.user == msg.sender);  
185 		
186 		if (s.amountbalance == 0) {
187 			revert();
188 		}
189 		else {
190 			RetireHodl(tokenAddress, id);
191 		}
192     }
193     
194     function RetireHodl(address tokenAddress, uint256 id) private {
195         Safe storage s = _safes[id];
196         
197         require(s.id != 0);
198         require(s.tokenAddress == tokenAddress);
199 
200         uint256 eventAmount;
201         address eventTokenAddress = s.tokenAddress;
202         string memory eventTokenSymbol = s.tokenSymbol;		
203 		     
204         if(s.endtime < now) // Hodl Complete
205         {
206             PayToken(s.user, s.tokenAddress, s.amountbalance);
207             
208             eventAmount 				= s.amountbalance;
209 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
210 			
211 	    s.lastwithdraw = s.amountbalance;
212 		s.amountbalance = 0;
213 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
214 		
215         }
216         else 
217         {
218 			
219 			uint256 timeframe  			= sub(now, s.lasttime);
220 			                            // SAFE MATH FUNCTIONS
221 			uint256 CalculateWithdraw 	= mul(div(mul(s.amount, s.percentage), 100), div(timeframe, seconds30days)) ;
222 			                         // = s.amount * s.percentage / 100 * timeframe / seconds30days	
223 			                         
224 			uint256 MaxWithdraw 		= div(s.amount, 10);
225 			
226 			// Maximum withdraw before unlocked, Max 10% Accumulation
227 			if (CalculateWithdraw > MaxWithdraw) { 				
228 			uint256 MaxAccumulation = MaxWithdraw; 
229 			} else { MaxAccumulation = CalculateWithdraw; }
230 			
231 			// Maximum withdraw = User Amount Balance   
232 			if (MaxAccumulation > s.amountbalance) { 			     	
233 			uint256 realAmount = s.amountbalance; 
234 			} else { realAmount = MaxAccumulation; }
235 			
236 			s.lastwithdraw = realAmount;   				
237 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
238 			UpdateUserData(tokenAddress, id, newamountbalance, realAmount);
239 			
240 		}
241         
242     }   
243 
244     function UpdateUserData(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
245         Safe storage s = _safes[id];
246         
247         require(s.id != 0);
248         require(s.tokenAddress == tokenAddress);
249 
250         uint256 eventAmount;
251         address eventTokenAddress = s.tokenAddress;
252         string memory eventTokenSymbol = s.tokenSymbol;			
253    			
254 		s.amountbalance 				= newamountbalance;  
255 		s.lasttime 						= now;  
256 		
257 			uint256 tokenaffiliate 		= div(mul(s.amount, affiliate), 100) ; 
258 			uint256 maxcashback 		= div(mul(s.amount, cashback), 100) ; 
259 			uint256 tokenreceived 		= add(sub(sub(sub(s.amount, tokenaffiliate), newamountbalance), maxcashback), s.cashbackbalance ) ;		
260 			
261 			// Cashback = 100 - 12 - 87 - 16 + 16 = 1 ----> NoCashback 	= 100 - 12 - 71 - 16 + 0 = 1
262 
263 			uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000),  s.amount) ; 	
264 		
265 		s.tokenreceive 					= tokenreceived; 
266 		s.percentagereceive 			= percentagereceived; 		
267 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
268 		
269 		
270 	        PayToken(s.user, s.tokenAddress, s.lastwithdraw);           
271             eventAmount = realAmount;
272 			
273 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
274     } 
275 
276     function PayToken(address user, address tokenAddress, uint256 amount) private {
277         
278         ERC20Interface token = ERC20Interface(tokenAddress);        
279         require(token.balanceOf(address(this)) >= amount);
280         token.transfer(user, amount);
281     }   	
282 	
283 // Function 04 - Get How Many Contribute ?
284     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
285         return _userSafes[hodler].length;
286     }
287     
288 // Function 05 - Get Data Values
289 	function GetSafe(uint256 _id) public view
290         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
291     {
292         Safe storage s = _safes[_id];
293         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
294     }
295 	
296 // Function 06 - Get Tokens Reserved For The Owner As Commission 
297     function GetTokenFees(address tokenAddress) public view returns (uint256 amount) {
298         return _systemReserves[tokenAddress];
299     }    
300     
301 // Function 07 - Get Contract's Balance  
302     function GetContractBalance() public view returns(uint256)
303     {
304         return address(this).balance;
305     } 	
306 	
307 //Function 08 - Cashback Code  
308     function CashbackCode(address _cashbackcode) public {
309 		
310 		if (cashbackcode[msg.sender] == 0) {
311 			cashbackcode[msg.sender] = _cashbackcode;
312 			emit onCashbackCode(msg.sender, _cashbackcode);
313 		}		             
314     }  
315 	
316 	
317 // Useless Function ( Public )	
318 	
319 //??? Function 01 - Store Comission From Unfinished Hodl
320     function StoreComission(address tokenAddress, uint256 amount) private {
321             
322         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
323         
324         bool isNew = true;
325         for(uint256 i = 0; i < _listedReserves.length; i++) {
326             if(_listedReserves[i] == tokenAddress) {
327                 isNew = false;
328                 break;
329             }
330         }         
331         if(isNew) _listedReserves.push(tokenAddress); 
332     }    
333 	
334 //??? Function 02 - Delete Safe Values In Storage   
335     function DeleteSafe(Safe s) private {
336         
337         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
338         delete _safes[s.id];
339         
340         uint256[] storage vector = _userSafes[msg.sender];
341         uint256 size = vector.length; 
342         for(uint256 i = 0; i < size; i++) {
343             if(vector[i] == s.id) {
344                 vector[i] = vector[size-1];
345                 vector.length--;
346                 break;
347             }
348         } 
349     }
350 	
351 //??? Function 03 - Store The Profile's Hash In The Blockchain   
352     function storeProfileHashed(string _profileHashed) public {
353         profileHashed[msg.sender] = _profileHashed;        
354         emit onStoreProfileHash(msg.sender, _profileHashed);
355     }  	
356 
357 //??? Function 04 - Get User's Any Token Balance
358     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
359         require(tokenAddress != 0x0);
360         
361         for(uint256 i = 1; i < _currentIndex; i++) {            
362             Safe storage s = _safes[i];
363             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
364                 balance += s.amount;
365         }
366         return balance;
367     }
368 	
369 
370 ////////////////////////////////// onlyOwner //////////////////////////////////
371 
372 // 00 Insert Token Contract Address	
373     function AddContractAddress(address tokenAddress, bool contractstatus) public onlyOwner {
374         contractaddress[tokenAddress] = contractstatus;
375     }
376 	
377 // 01 Claim ( By Owner )	
378     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
379         require(tokenAddress != 0x0);
380         require(id != 0);      
381         RetireHodl(tokenAddress, id);
382     }
383     
384 // 02 Change Hodling Time   
385     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
386         require(newHodlingDays >= 60);      
387         hodlingTime = newHodlingDays * 1 days;
388     }   
389     
390 // 03 Change All Time High Price   
391     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
392         require(newAllTimeHighPrice > allTimeHighPrice);       
393         allTimeHighPrice = newAllTimeHighPrice;
394     }              
395 
396 // 04 Change Comission Value   
397     function ChangeComission(uint256 newComission) onlyOwner public {
398         require(newComission <= 30);       
399         comission = newComission;
400     }
401 	
402 // 05 - Withdraw Ether Received Through Fallback Function    
403     function WithdrawEth(uint256 amount) onlyOwner public {
404         require(amount > 0); 
405         require(address(this).balance >= amount); 
406         
407         msg.sender.transfer(amount);
408     }
409     
410 // 06 Withdraw Token Fees By Token Address   
411     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
412         require(_systemReserves[tokenAddress] > 0);
413         
414         uint256 amount = _systemReserves[tokenAddress];
415         _systemReserves[tokenAddress] = 0;
416         
417         ERC20Interface token = ERC20Interface(tokenAddress);
418         
419         require(token.balanceOf(address(this)) >= amount);
420         token.transfer(msg.sender, amount);
421     }
422 
423 // 07 Withdraw All Eth And All Tokens Fees   
424     function WithdrawAllFees() onlyOwner public {
425         
426         // Ether
427         uint256 x = _systemReserves[0x0];
428         if(x > 0 && x <= address(this).balance) {
429             _systemReserves[0x0] = 0;
430             msg.sender.transfer(_systemReserves[0x0]);
431         }
432         
433         // Tokens
434         address ta;
435         ERC20Interface token;
436         for(uint256 i = 0; i < _listedReserves.length; i++) {
437             ta = _listedReserves[i];
438             if(_systemReserves[ta] > 0)
439             { 
440                 x = _systemReserves[ta];
441                 _systemReserves[ta] = 0;
442                 
443                 token = ERC20Interface(ta);
444                 token.transfer(msg.sender, x);
445             }
446         }
447         _listedReserves.length = 0; 
448     }
449     
450 
451 
452 // 08 - Returns All Tokens Addresses With Fees       
453     function GetTokensAddressesWithFees() 
454         onlyOwner public view 
455         returns (address[], string[], uint256[])
456     {
457         uint256 length = _listedReserves.length;
458         
459         address[] memory tokenAddress = new address[](length);
460         string[] memory tokenSymbol = new string[](length);
461         uint256[] memory tokenFees = new uint256[](length);
462         
463         for (uint256 i = 0; i < length; i++) {
464     
465             tokenAddress[i] = _listedReserves[i];
466             
467             ERC20Interface token = ERC20Interface(tokenAddress[i]);
468             
469             tokenSymbol[i] = token.symbol();
470             tokenFees[i] = GetTokenFees(tokenAddress[i]);
471         }
472         
473         return (tokenAddress, tokenSymbol, tokenFees);
474     }
475 
476 	
477 // 09 - Return All Tokens To Their Respective Addresses    
478     function ReturnAllTokens(bool onlyAXPR) onlyOwner public
479     {
480         uint256 returned;
481 
482         for(uint256 i = 1; i < _currentIndex; i++) {            
483             Safe storage s = _safes[i];
484             if (s.id != 0) {
485                 if (
486                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
487                     !onlyAXPR
488                     )
489                 {
490                     PayToken(s.user, s.tokenAddress, s.amountbalance);
491                     
492                     _countSafes--;
493                     returned++;
494                 }
495             }
496         }
497 
498         emit onReturnAll(returned);
499     }   
500 
501 
502 //////////////////////////////////////////////// 	
503 	
504 
505     /**
506     * SAFE MATH FUNCTIONS
507     * 
508     * @dev Multiplies two numbers, throws on overflow.
509     */
510     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
511         if (a == 0) {
512             return 0;
513         }
514         c = a * b;
515         assert(c / a == b);
516         return c;
517     }
518     
519     /**
520     * @dev Integer division of two numbers, truncating the quotient.
521     */
522     function div(uint256 a, uint256 b) internal pure returns (uint256) {
523         // assert(b > 0); // Solidity automatically throws when dividing by 0
524         // uint256 c = a / b;
525         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
526         return a / b;
527     }
528     
529     /**
530     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
531     */
532     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
533         assert(b <= a);
534         return a - b;
535     }
536     
537     /**
538     * @dev Adds two numbers, throws on overflow.
539     */
540     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
541         c = a + b;
542         assert(c >= a);
543         return c;
544     }
545     
546 }
547 
548 contract ERC20Interface {
549 
550     uint256 public totalSupply;
551     uint256 public decimals;
552     
553     function symbol() public view returns (string);
554     function balanceOf(address _owner) public view returns (uint256 balance);
555     function transfer(address _to, uint256 _value) public returns (bool success);
556     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
557     function approve(address _spender, uint256 _value) public returns (bool success);
558     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
559 
560     // solhint-disable-next-line no-simple-event-func-name  
561     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
562     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
563 }