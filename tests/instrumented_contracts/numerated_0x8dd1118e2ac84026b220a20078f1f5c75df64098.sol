1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 ////// Version 5.0 ////// 
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
58 	event onAddContractAddress(address indexed contracthodler, bool contractstatus);    
59 	event onCashbackCode(address indexed hodler, address cashbackcode);
60     event onStoreProfileHash(address indexed hodler, string profileHashed);
61     event onHodlTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
62     event onClaimTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
63     event onReturnAll(uint256 returned);
64 	
65     // Variables // * = New ** = Undeveloped	
66     address internal AXPRtoken;
67     mapping(address => string) 	public profileHashed; 		// User Prime 
68 	mapping(address => address) public cashbackcode; 		// Cashback Code 
69 	mapping(address => bool) 	public contractaddress; 	// Contract Address
70 	
71 	// Default Setting
72 	uint256 public 	percent 				= 1200;        	// * Percent Permonth ( Only Test = 1200% )
73 	uint256 private constant affiliate 		= 12;        	// * 12% from deposit
74 	uint256 private constant cashback 		= 16;        	// * 16% from deposit
75 	uint256 private constant nocashback 	= 28;        	// * 12% + 16% = 28% from deposit
76 	uint256 private constant totalreceive 	= 88;        	// * 88% from deposit	
77     uint256 private constant seconds30days 	= 2592000;  	// *
78 
79     struct Safe {
80         uint256 id;
81         uint256 amount;
82         uint256 endtime;
83         address user;
84         address tokenAddress;
85 		string  tokenSymbol;	
86 		uint256 amountbalance; 			// * --- > 88% from deposit
87 		uint256 cashbackbalance; 		// * --- > 16% from deposit
88 		uint256 lasttime; 				// * --- > Last Withdraw (Time)
89 		uint256 percentage; 			// * --- > return tokens every month
90 		uint256 percentagereceive; 		// * --- > 0 %
91 		uint256 tokenreceive; 			// * --- > 0 Token
92 		uint256 affiliatebalance; 		// ** --->>> Dont forget to develop
93 		address referrer; 				// *
94 
95     }
96     
97 	mapping(address => uint256[]) 	public 	_userSafes;			// ?????
98     mapping(address => uint256) 	public 	_totalSaved; 		// Token Balance
99 	mapping(uint256 => Safe) 		private _safes; 			// Struct safe database
100     uint256 						private _currentIndex; 		// Sequential number ( Start from 500 )
101 	uint256 						public _countSafes; 		// Total Smart Contract User
102 	uint256 						public hodlingTime;			
103     uint256 						public allTimeHighPrice;
104     uint256 						public comission;
105 	
106     mapping(address => uint256) 	private _systemReserves;    // Token Balance ( Reserve )
107     address[] 						public _listedReserves;		// ?????
108     
109     //Constructor
110    
111     constructor() public {
112         
113         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;        
114         hodlingTime 	= 730 days;
115         _currentIndex 	= 500;
116         comission 		= 12;
117     }
118     
119 	
120 // Function 01 - Fallback Function To Receive Donation In Eth
121     function () public payable {
122         require(msg.value > 0);       
123         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
124     }
125 	
126 // Function 02 - Contribute (Hodl Platform)
127     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
128         require(tokenAddress != 0x0);
129         require(amount > 0);
130 		
131 		if (contractaddress[tokenAddress] == false) {
132 			revert();
133 		}
134 		else {
135 			
136 		
137         ERC20Interface token = ERC20Interface(tokenAddress);       
138         require(token.transferFrom(msg.sender, address(this), amount));
139 		
140 		uint256 affiliatecomission 		= div(mul(amount, affiliate), 100); 	// amount * affiliate / 100
141 		uint256 no_cashback 			= div(mul(amount, nocashback), 100); 	// amount * 28 / 100
142 		
143 		 	if (cashbackcode[msg.sender] == 0 ) { 				
144 			uint256 data_amountbalance 		= div(mul(amount, 72), 100);		// amount * 72 / 100
145 			uint256 data_cashbackbalance 	= 0; 
146 			address data_referrer			= superOwner;
147 			
148 			cashbackcode[msg.sender] = superOwner;
149 			emit onCashbackCode(msg.sender, superOwner);
150 			
151 			_systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], no_cashback);
152 			
153 			} else { 	
154 			data_amountbalance 		= sub(amount, affiliatecomission);			// amount - affiliatecomission
155 			data_cashbackbalance 	= div(mul(amount, cashback), 100);			// amount * cashback / 100
156 			data_referrer			= cashbackcode[msg.sender];
157 
158 			_systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], affiliatecomission); } //--->>> Dont forget to develop
159 			  		  				  					  
160 	// Insert to Database  			 	  
161 		_userSafes[msg.sender].push(_currentIndex);
162 		_safes[_currentIndex] = 
163 
164 		Safe(
165 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, data_referrer);				
166 		
167 	// Update Token Balance, Current Index, CountSafes		
168         _totalSaved[tokenAddress] 		= add(_totalSaved[tokenAddress], amount);     		
169         _currentIndex++;
170         _countSafes++;
171         
172         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
173     }	
174 			
175 			
176 }
177 		
178 	
179 // Function 03 - Claim (Hodl Platform)	
180     function ClaimTokens(address tokenAddress, uint256 id) public {
181         require(tokenAddress != 0x0);
182         require(id != 0);        
183         
184         Safe storage s = _safes[id];
185         require(s.user == msg.sender);  
186 		
187 		if (s.amountbalance == 0) {
188 			revert();
189 		}
190 		else {
191 			RetireHodl(tokenAddress, id);
192 		}
193     }
194     
195     function RetireHodl(address tokenAddress, uint256 id) private {
196         Safe storage s = _safes[id];
197         
198         require(s.id != 0);
199         require(s.tokenAddress == tokenAddress);
200 
201         uint256 eventAmount;
202         address eventTokenAddress = s.tokenAddress;
203         string memory eventTokenSymbol = s.tokenSymbol;		
204 		     
205         if(s.endtime < now) // Hodl Complete
206         {
207             PayToken(s.user, s.tokenAddress, s.amountbalance);
208             
209             eventAmount 				= s.amountbalance;
210 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
211 			
212 		s.amountbalance = 0;
213 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
214 		
215         }
216         else 
217         {
218 			
219 			uint256 timeframe  			= sub(now, s.lasttime);			                            
220 		//1 uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), seconds30days); 
221 			uint256 CalculateWithdraw   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
222 		                         
223 			uint256 MaxWithdraw 		= div(s.amount, 10);
224 			
225 			// Maximum withdraw before unlocked, Max 10% Accumulation
226 			if (CalculateWithdraw > MaxWithdraw) { 				
227 			uint256 MaxAccumulation = MaxWithdraw; 
228 			} else { MaxAccumulation = CalculateWithdraw; }
229 			
230 			// Maximum withdraw = User Amount Balance   
231 			if (MaxAccumulation > s.amountbalance) { 			     	
232 			uint256 realAmount = s.amountbalance; 
233 			} else { realAmount = MaxAccumulation; }
234 			  				
235 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
236 			UpdateUserData(tokenAddress, id, newamountbalance, realAmount);
237 			
238 		}
239         
240     }   
241 
242     function UpdateUserData(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
243         Safe storage s = _safes[id];
244         
245         require(s.id != 0);
246         require(s.tokenAddress == tokenAddress);
247 
248         uint256 eventAmount;
249         address eventTokenAddress = s.tokenAddress;
250         string memory eventTokenSymbol = s.tokenSymbol;			
251    			
252 		s.amountbalance 				= newamountbalance;  
253 		s.lasttime 						= now;  
254 		
255 			uint256 tokenaffiliate 		= div(mul(s.amount, affiliate), 100) ; 
256 			uint256 maxcashback 		= div(mul(s.amount, cashback), 100) ; 		
257 		//2 uint256 tokenreceived 		= add(sub(sub(sub(s.amount, tokenaffiliate), newamountbalance), maxcashback), s.cashbackbalance ) ;		
258 			uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance - maxcashback + s.cashbackbalance ;
259 			
260 			// Cashback = 100 - 12 - 88 - 16 + 16 = 0 ----> No_Cashback 	= 100 - 12 - 72 - 16 + 0 = 1
261 
262 			uint256 percentagereceived 	= mul(div(tokenreceived, s.amount), 100000000000000000000) ; 	
263 		
264 		s.tokenreceive 					= tokenreceived; 
265 		s.percentagereceive 			= percentagereceived; 		
266 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
267 		
268 		
269 	        PayToken(s.user, s.tokenAddress, realAmount);           		
270             eventAmount = realAmount;
271 			
272 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
273     } 
274 
275     function PayToken(address user, address tokenAddress, uint256 amount) private {
276         
277         ERC20Interface token = ERC20Interface(tokenAddress);        
278         require(token.balanceOf(address(this)) >= amount);
279         token.transfer(user, amount);
280     }   	
281 	
282 // Function 04 - Get How Many Contribute ?
283     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
284         return _userSafes[hodler].length;
285     }
286     
287 // Function 05 - Get Data Values
288 	function GetSafe(uint256 _id) public view
289         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
290     {
291         Safe storage s = _safes[_id];
292         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
293     }
294 	
295 // Function 06 - Get Tokens Reserved For The Owner As Commission 
296     function GetTokenFees(address tokenAddress) public view returns (uint256 amount) {
297         return _systemReserves[tokenAddress];
298     }    
299     
300 // Function 07 - Get Contract's Balance  
301     function GetContractBalance() public view returns(uint256)
302     {
303         return address(this).balance;
304     } 	
305 	
306 //Function 08 - Cashback Code  
307     function CashbackCode(address _cashbackcode) public {
308 		
309 		if (cashbackcode[msg.sender] == 0) {
310 			cashbackcode[msg.sender] = _cashbackcode;
311 			emit onCashbackCode(msg.sender, _cashbackcode);
312 		}		             
313     }  
314 	
315 	
316 // Useless Function ( Public )	
317 	
318 //??? Function 01 - Store Comission From Unfinished Hodl
319     function StoreComission(address tokenAddress, uint256 amount) private {
320             
321         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
322         
323         bool isNew = true;
324         for(uint256 i = 0; i < _listedReserves.length; i++) {
325             if(_listedReserves[i] == tokenAddress) {
326                 isNew = false;
327                 break;
328             }
329         }         
330         if(isNew) _listedReserves.push(tokenAddress); 
331     }    
332 	
333 //??? Function 02 - Delete Safe Values In Storage   
334     function DeleteSafe(Safe s) private {
335         
336         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
337         delete _safes[s.id];
338         
339         uint256[] storage vector = _userSafes[msg.sender];
340         uint256 size = vector.length; 
341         for(uint256 i = 0; i < size; i++) {
342             if(vector[i] == s.id) {
343                 vector[i] = vector[size-1];
344                 vector.length--;
345                 break;
346             }
347         } 
348     }
349 	
350 //??? Function 03 - Store The Profile's Hash In The Blockchain   
351     function storeProfileHashed(string _profileHashed) public {
352         profileHashed[msg.sender] = _profileHashed;        
353         emit onStoreProfileHash(msg.sender, _profileHashed);
354     }  	
355 
356 //??? Function 04 - Get User's Any Token Balance
357     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
358         require(tokenAddress != 0x0);
359         
360         for(uint256 i = 1; i < _currentIndex; i++) {            
361             Safe storage s = _safes[i];
362             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
363                 balance += s.amount;
364         }
365         return balance;
366     }
367 	
368 
369 ////////////////////////////////// onlyOwner //////////////////////////////////
370 
371 // 00 Insert Token Contract Address	
372     function AddContractAddress(address tokenAddress, bool contractstatus) public onlyOwner {
373         contractaddress[tokenAddress] = contractstatus;
374 		emit onAddContractAddress(tokenAddress, contractstatus);
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