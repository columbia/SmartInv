1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 ////// Version 4.9 ////// 
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
220 			uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), seconds30days); // SAFE MATH FUNCTIONS
221 			                         // = s.amount * s.percentage / 100 * timeframe / seconds30days				                         
222 			uint256 MaxWithdraw 		= div(s.amount, 10);
223 			
224 			// Maximum withdraw before unlocked, Max 10% Accumulation
225 			if (CalculateWithdraw > MaxWithdraw) { 				
226 			uint256 MaxAccumulation = MaxWithdraw; 
227 			} else { MaxAccumulation = CalculateWithdraw; }
228 			
229 			// Maximum withdraw = User Amount Balance   
230 			if (MaxAccumulation > s.amountbalance) { 			     	
231 			uint256 realAmount = s.amountbalance; 
232 			} else { realAmount = MaxAccumulation; }
233 			  				
234 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
235 			UpdateUserData(tokenAddress, id, newamountbalance, realAmount);
236 			
237 		}
238         
239     }   
240 
241     function UpdateUserData(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
242         Safe storage s = _safes[id];
243         
244         require(s.id != 0);
245         require(s.tokenAddress == tokenAddress);
246 
247         uint256 eventAmount;
248         address eventTokenAddress = s.tokenAddress;
249         string memory eventTokenSymbol = s.tokenSymbol;			
250    			
251 		s.amountbalance 				= newamountbalance;  
252 		s.lasttime 						= now;  
253 		
254 			uint256 tokenaffiliate 		= div(mul(s.amount, affiliate), 100) ; 
255 			uint256 maxcashback 		= div(mul(s.amount, cashback), 100) ; 
256 			uint256 tokenreceived 		= add(sub(sub(sub(s.amount, tokenaffiliate), newamountbalance), maxcashback), s.cashbackbalance ) ;		
257 			
258 			// Cashback = 100 - 12 - 88 - 16 + 16 = 0 ----> No_Cashback 	= 100 - 12 - 72 - 16 + 0 = 1
259 
260 			uint256 percentagereceived 	= mul(div(tokenreceived, s.amount), 100000000000000000000) ; 	
261 		
262 		s.tokenreceive 					= tokenreceived; 
263 		s.percentagereceive 			= percentagereceived; 		
264 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
265 		
266 		
267 	        PayToken(s.user, s.tokenAddress, realAmount);           		
268             eventAmount = realAmount;
269 			
270 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
271     } 
272 
273     function PayToken(address user, address tokenAddress, uint256 amount) private {
274         
275         ERC20Interface token = ERC20Interface(tokenAddress);        
276         require(token.balanceOf(address(this)) >= amount);
277         token.transfer(user, amount);
278     }   	
279 	
280 // Function 04 - Get How Many Contribute ?
281     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
282         return _userSafes[hodler].length;
283     }
284     
285 // Function 05 - Get Data Values
286 	function GetSafe(uint256 _id) public view
287         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
288     {
289         Safe storage s = _safes[_id];
290         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
291     }
292 	
293 // Function 06 - Get Tokens Reserved For The Owner As Commission 
294     function GetTokenFees(address tokenAddress) public view returns (uint256 amount) {
295         return _systemReserves[tokenAddress];
296     }    
297     
298 // Function 07 - Get Contract's Balance  
299     function GetContractBalance() public view returns(uint256)
300     {
301         return address(this).balance;
302     } 	
303 	
304 //Function 08 - Cashback Code  
305     function CashbackCode(address _cashbackcode) public {
306 		
307 		if (cashbackcode[msg.sender] == 0) {
308 			cashbackcode[msg.sender] = _cashbackcode;
309 			emit onCashbackCode(msg.sender, _cashbackcode);
310 		}		             
311     }  
312 	
313 	
314 // Useless Function ( Public )	
315 	
316 //??? Function 01 - Store Comission From Unfinished Hodl
317     function StoreComission(address tokenAddress, uint256 amount) private {
318             
319         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
320         
321         bool isNew = true;
322         for(uint256 i = 0; i < _listedReserves.length; i++) {
323             if(_listedReserves[i] == tokenAddress) {
324                 isNew = false;
325                 break;
326             }
327         }         
328         if(isNew) _listedReserves.push(tokenAddress); 
329     }    
330 	
331 //??? Function 02 - Delete Safe Values In Storage   
332     function DeleteSafe(Safe s) private {
333         
334         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
335         delete _safes[s.id];
336         
337         uint256[] storage vector = _userSafes[msg.sender];
338         uint256 size = vector.length; 
339         for(uint256 i = 0; i < size; i++) {
340             if(vector[i] == s.id) {
341                 vector[i] = vector[size-1];
342                 vector.length--;
343                 break;
344             }
345         } 
346     }
347 	
348 //??? Function 03 - Store The Profile's Hash In The Blockchain   
349     function storeProfileHashed(string _profileHashed) public {
350         profileHashed[msg.sender] = _profileHashed;        
351         emit onStoreProfileHash(msg.sender, _profileHashed);
352     }  	
353 
354 //??? Function 04 - Get User's Any Token Balance
355     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
356         require(tokenAddress != 0x0);
357         
358         for(uint256 i = 1; i < _currentIndex; i++) {            
359             Safe storage s = _safes[i];
360             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
361                 balance += s.amount;
362         }
363         return balance;
364     }
365 	
366 
367 ////////////////////////////////// onlyOwner //////////////////////////////////
368 
369 // 00 Insert Token Contract Address	
370     function AddContractAddress(address tokenAddress, bool contractstatus) public onlyOwner {
371         contractaddress[tokenAddress] = contractstatus;
372 		emit onAddContractAddress(tokenAddress, contractstatus);
373     }
374 	
375 // 01 Claim ( By Owner )	
376     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
377         require(tokenAddress != 0x0);
378         require(id != 0);      
379         RetireHodl(tokenAddress, id);
380     }
381     
382 // 02 Change Hodling Time   
383     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
384         require(newHodlingDays >= 60);      
385         hodlingTime = newHodlingDays * 1 days;
386     }   
387     
388 // 03 Change All Time High Price   
389     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
390         require(newAllTimeHighPrice > allTimeHighPrice);       
391         allTimeHighPrice = newAllTimeHighPrice;
392     }              
393 
394 // 04 Change Comission Value   
395     function ChangeComission(uint256 newComission) onlyOwner public {
396         require(newComission <= 30);       
397         comission = newComission;
398     }
399 	
400 // 05 - Withdraw Ether Received Through Fallback Function    
401     function WithdrawEth(uint256 amount) onlyOwner public {
402         require(amount > 0); 
403         require(address(this).balance >= amount); 
404         
405         msg.sender.transfer(amount);
406     }
407     
408 // 06 Withdraw Token Fees By Token Address   
409     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
410         require(_systemReserves[tokenAddress] > 0);
411         
412         uint256 amount = _systemReserves[tokenAddress];
413         _systemReserves[tokenAddress] = 0;
414         
415         ERC20Interface token = ERC20Interface(tokenAddress);
416         
417         require(token.balanceOf(address(this)) >= amount);
418         token.transfer(msg.sender, amount);
419     }
420 
421 // 07 Withdraw All Eth And All Tokens Fees   
422     function WithdrawAllFees() onlyOwner public {
423         
424         // Ether
425         uint256 x = _systemReserves[0x0];
426         if(x > 0 && x <= address(this).balance) {
427             _systemReserves[0x0] = 0;
428             msg.sender.transfer(_systemReserves[0x0]);
429         }
430         
431         // Tokens
432         address ta;
433         ERC20Interface token;
434         for(uint256 i = 0; i < _listedReserves.length; i++) {
435             ta = _listedReserves[i];
436             if(_systemReserves[ta] > 0)
437             { 
438                 x = _systemReserves[ta];
439                 _systemReserves[ta] = 0;
440                 
441                 token = ERC20Interface(ta);
442                 token.transfer(msg.sender, x);
443             }
444         }
445         _listedReserves.length = 0; 
446     }
447     
448 
449 
450 // 08 - Returns All Tokens Addresses With Fees       
451     function GetTokensAddressesWithFees() 
452         onlyOwner public view 
453         returns (address[], string[], uint256[])
454     {
455         uint256 length = _listedReserves.length;
456         
457         address[] memory tokenAddress = new address[](length);
458         string[] memory tokenSymbol = new string[](length);
459         uint256[] memory tokenFees = new uint256[](length);
460         
461         for (uint256 i = 0; i < length; i++) {
462     
463             tokenAddress[i] = _listedReserves[i];
464             
465             ERC20Interface token = ERC20Interface(tokenAddress[i]);
466             
467             tokenSymbol[i] = token.symbol();
468             tokenFees[i] = GetTokenFees(tokenAddress[i]);
469         }
470         
471         return (tokenAddress, tokenSymbol, tokenFees);
472     }
473 
474 	
475 // 09 - Return All Tokens To Their Respective Addresses    
476     function ReturnAllTokens(bool onlyAXPR) onlyOwner public
477     {
478         uint256 returned;
479 
480         for(uint256 i = 1; i < _currentIndex; i++) {            
481             Safe storage s = _safes[i];
482             if (s.id != 0) {
483                 if (
484                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
485                     !onlyAXPR
486                     )
487                 {
488                     PayToken(s.user, s.tokenAddress, s.amountbalance);
489                     
490                     _countSafes--;
491                     returned++;
492                 }
493             }
494         }
495 
496         emit onReturnAll(returned);
497     }   
498 
499 
500 //////////////////////////////////////////////// 	
501 	
502 
503     /**
504     * SAFE MATH FUNCTIONS
505     * 
506     * @dev Multiplies two numbers, throws on overflow.
507     */
508     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
509         if (a == 0) {
510             return 0;
511         }
512         c = a * b;
513         assert(c / a == b);
514         return c;
515     }
516     
517     /**
518     * @dev Integer division of two numbers, truncating the quotient.
519     */
520     function div(uint256 a, uint256 b) internal pure returns (uint256) {
521         // assert(b > 0); // Solidity automatically throws when dividing by 0
522         // uint256 c = a / b;
523         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
524         return a / b;
525     }
526     
527     /**
528     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
529     */
530     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
531         assert(b <= a);
532         return a - b;
533     }
534     
535     /**
536     * @dev Adds two numbers, throws on overflow.
537     */
538     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
539         c = a + b;
540         assert(c >= a);
541         return c;
542     }
543     
544 }
545 
546 contract ERC20Interface {
547 
548     uint256 public totalSupply;
549     uint256 public decimals;
550     
551     function symbol() public view returns (string);
552     function balanceOf(address _owner) public view returns (uint256 balance);
553     function transfer(address _to, uint256 _value) public returns (bool success);
554     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
555     function approve(address _spender, uint256 _value) public returns (bool success);
556     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
557 
558     // solhint-disable-next-line no-simple-event-func-name  
559     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
560     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
561 }