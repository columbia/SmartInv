1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 ////// Version 4.0 ////// 
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
66     mapping(address => string) public profileHashed; 		// User Prime 
67 	mapping(address => address) public cashbackcode; 		// Cashback Code 
68 	mapping(address => bool) public contractaddress; 		// Contract Address
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
86 		uint256 lasttime; 				// * --- > Last Withdraw
87 		uint256 percentage; 			// * --- > return tokens every month
88 		uint256 percentagereceive; 		// * --- > 0 %
89 		uint256 tokenreceive; 			// * --- > 0 Token
90 		uint256 affiliatebalance; 		// **
91 		address referrer; 				// **
92 
93     }
94     
95 	mapping(address => uint256[]) 	public 	_userSafes;			// ?????
96     mapping(address => uint256) 	public 	_totalSaved; 		// Token Balance
97 	mapping(uint256 => Safe) 		private _safes; 			// Struct safe database
98     uint256 						private _currentIndex; 		// Sequential number ( Start from 500 )
99 	uint256 						public _countSafes; 		// Total Smart Contract User
100 	uint256 						public hodlingTime;			
101     uint256 						public allTimeHighPrice;
102     uint256 						public comission;
103 	
104     mapping(address => uint256) 	private _systemReserves;    // Token Balance ( Reserve )
105     address[] 						public _listedReserves;		// ?????
106     
107     //Constructor
108    
109     constructor() public {
110         
111         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;        
112         hodlingTime 	= 730 days;
113         _currentIndex 	= 500;
114         comission 		= 12;
115     }
116     
117 	
118 // Function 01 - Fallback Function To Receive Donation In Eth
119     function () public payable {
120         require(msg.value > 0);       
121         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
122     }
123 	
124 // Function 02 - Contribute (Hodl Platform)
125     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
126         require(tokenAddress != 0x0);
127         require(amount > 0);
128 		
129 		if(contractaddress[tokenAddress] = false) { revert(); }	
130 		
131         ERC20Interface token = ERC20Interface(tokenAddress);       
132         require(token.transferFrom(msg.sender, address(this), amount));
133 		
134 		uint256 affiliatecomission 		= mul(amount, affiliate) / 100; 	// *
135 		uint256 nocashback 				= mul(amount, 28) / 100; 	// *
136 		
137 		 	if (cashbackcode[msg.sender] == 0 ) { 				
138 			uint256 data_amountbalance 		= mul(amount, 72) / 100;
139 			uint256 data_cashbackbalance 	= 0; 
140 			address data_referrer			= superOwner;
141 			
142 			cashbackcode[msg.sender] = superOwner;
143 			emit onCashbackCode(msg.sender, superOwner);
144 			
145 			_systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], nocashback);
146 			
147 			} else { 	
148 			data_amountbalance 		= sub(amount, affiliatecomission);	
149 			data_cashbackbalance 	= mul(amount, cashback) / 100;
150 			data_referrer			= cashbackcode[msg.sender];
151 
152 			_systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], affiliatecomission); } //--->>> Dont forget to change code
153 			  		  				  					  
154 	// Insert to Database  			 	  
155 		_userSafes[msg.sender].push(_currentIndex);
156 		_safes[_currentIndex] = 
157 
158 		Safe(
159 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, data_referrer);				
160 		
161 	// Update Token Balance, Current Index, CountSafes		
162         _totalSaved[tokenAddress] 		= add(_totalSaved[tokenAddress], amount);     		
163         _currentIndex++;
164         _countSafes++;
165         
166         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
167     }
168 	
169 	
170 // Function 03 - Claim (Hodl Platform)	
171     function ClaimTokens(address tokenAddress, uint256 id) public {
172         require(tokenAddress != 0x0);
173         require(id != 0);        
174         
175         Safe storage s = _safes[id];
176         require(s.user == msg.sender);  
177 
178 		if(s.amountbalance == 0) { revert(); }	
179 		
180         RetireHodl(tokenAddress, id);
181     }
182     
183     function RetireHodl(address tokenAddress, uint256 id) private {
184         Safe storage s = _safes[id];
185         
186         require(s.id != 0);
187         require(s.tokenAddress == tokenAddress);
188 
189         uint256 eventAmount;
190         address eventTokenAddress = s.tokenAddress;
191         string memory eventTokenSymbol = s.tokenSymbol;		
192 		     
193         if(s.endtime < now) // Hodl Complete
194         {
195             PayToken(s.user, s.tokenAddress, s.amountbalance);
196             
197             eventAmount 				= s.amountbalance;
198 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
199 			
200 	    s.amountbalance = 0;
201 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
202 		
203         }
204         else 
205         {
206 			
207 			uint256 timeframe  			= sub(now, s.lasttime);
208 			uint256 CalculateWithdraw 	= s.amount * s.percentage / 100 * timeframe / seconds30days ;		// SAFE MATH FUNCTIONS ???	
209 			uint256 MaxWithdraw 		= mul(s.amount, 10);
210 			
211 			// Maximum withdraw before unlocked, Max 10% Accumulation
212 			if (CalculateWithdraw > MaxWithdraw) { 				
213 			uint256 MaxAccumulation = MaxWithdraw; 
214 			} else { MaxAccumulation = CalculateWithdraw; }
215 			
216 			// Maximum withdraw = User Amount Balance   
217 			if (MaxAccumulation > s.amountbalance) { 			     	
218 			uint256 realAmount = s.amountbalance; 
219 			} else { realAmount = MaxAccumulation; }
220 			   				
221 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
222 			UpdateUserData(tokenAddress, id, newamountbalance, realAmount);
223 			
224 		}
225         
226     }   
227 
228     function UpdateUserData(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
229         Safe storage s = _safes[id];
230         
231         require(s.id != 0);
232         require(s.tokenAddress == tokenAddress);
233 
234         uint256 eventAmount;
235         address eventTokenAddress = s.tokenAddress;
236         string memory eventTokenSymbol = s.tokenSymbol;			
237    			
238 		s.amountbalance 				= newamountbalance;  
239 		s.lasttime 						= now;  
240 		
241 			uint256 tokenaffiliate 		= mul(s.amount, affiliate) / 100 ; 
242 			uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance;	  		// * SAFE MATH FUNCTIONS ???		
243 			uint256 percentagereceived 	= tokenreceived / s.amount * 100000000000000000000;	  	// * SAFE MATH FUNCTIONS ???	
244 		
245 		s.tokenreceive 					= tokenreceived; 
246 		s.percentagereceive 			= percentagereceived; 		
247 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
248 		
249 		
250 	        PayToken(s.user, s.tokenAddress, realAmount);           
251             eventAmount = realAmount;
252 			
253 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
254     } 
255 
256     function PayToken(address user, address tokenAddress, uint256 amount) private {
257         
258         ERC20Interface token = ERC20Interface(tokenAddress);        
259         require(token.balanceOf(address(this)) >= amount);
260         token.transfer(user, amount);
261     }   	
262 	
263 // Function 04 - Get How Many Contribute ?
264     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
265         return _userSafes[hodler].length;
266     }
267     
268 // Function 05 - Get Data Values
269 	function GetSafe(uint256 _id) public view
270         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
271     {
272         Safe storage s = _safes[_id];
273         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
274     }
275 	
276 // Function 06 - Get Tokens Reserved For The Owner As Commission 
277     function GetTokenFees(address tokenAddress) public view returns (uint256 amount) {
278         return _systemReserves[tokenAddress];
279     }    
280     
281 // Function 07 - Get Contract's Balance  
282     function GetContractBalance() public view returns(uint256)
283     {
284         return address(this).balance;
285     } 	
286 	
287 //Function 08 - Cashback Code  
288     function CashbackCode(address _cashbackcode) public {
289 		
290 		if (cashbackcode[msg.sender] == 0) {
291 			cashbackcode[msg.sender] = _cashbackcode;
292 			emit onCashbackCode(msg.sender, _cashbackcode);
293 		}		             
294     }  
295 	
296 	
297 // Useless Function ( Public )	
298 	
299 //??? Function 01 - Store Comission From Unfinished Hodl
300     function StoreComission(address tokenAddress, uint256 amount) private {
301             
302         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
303         
304         bool isNew = true;
305         for(uint256 i = 0; i < _listedReserves.length; i++) {
306             if(_listedReserves[i] == tokenAddress) {
307                 isNew = false;
308                 break;
309             }
310         }         
311         if(isNew) _listedReserves.push(tokenAddress); 
312     }    
313 	
314 //??? Function 02 - Delete Safe Values In Storage   
315     function DeleteSafe(Safe s) private {
316         
317         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
318         delete _safes[s.id];
319         
320         uint256[] storage vector = _userSafes[msg.sender];
321         uint256 size = vector.length; 
322         for(uint256 i = 0; i < size; i++) {
323             if(vector[i] == s.id) {
324                 vector[i] = vector[size-1];
325                 vector.length--;
326                 break;
327             }
328         } 
329     }
330 	
331 //??? Function 03 - Store The Profile's Hash In The Blockchain   
332     function storeProfileHashed(string _profileHashed) public {
333         profileHashed[msg.sender] = _profileHashed;        
334         emit onStoreProfileHash(msg.sender, _profileHashed);
335     }  	
336 
337 //??? Function 04 - Get User's Any Token Balance
338     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
339         require(tokenAddress != 0x0);
340         
341         for(uint256 i = 1; i < _currentIndex; i++) {            
342             Safe storage s = _safes[i];
343             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
344                 balance += s.amount;
345         }
346         return balance;
347     }
348 	
349 	
350 		    function ContractAddress(address _contractaddress, bool status) public {
351 		
352 		contractaddress[_contractaddress] = status;
353 		
354 			             
355     }
356 	
357 	
358 ////////////////////////////////// onlyOwner //////////////////////////////////
359 
360 // 00 Insert Token Contract Address	
361     function AddContractAddress(address tokenAddress, bool contractstatus) public onlyOwner {
362         contractaddress[tokenAddress] = contractstatus;
363     }
364 	
365 // 01 Claim ( By Owner )	
366     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
367         require(tokenAddress != 0x0);
368         require(id != 0);      
369         RetireHodl(tokenAddress, id);
370     }
371     
372 // 02 Change Hodling Time   
373     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
374         require(newHodlingDays >= 60);      
375         hodlingTime = newHodlingDays * 1 days;
376     }   
377     
378 // 03 Change All Time High Price   
379     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
380         require(newAllTimeHighPrice > allTimeHighPrice);       
381         allTimeHighPrice = newAllTimeHighPrice;
382     }              
383 
384 // 04 Change Comission Value   
385     function ChangeComission(uint256 newComission) onlyOwner public {
386         require(newComission <= 30);       
387         comission = newComission;
388     }
389 	
390 // 05 - Withdraw Ether Received Through Fallback Function    
391     function WithdrawEth(uint256 amount) onlyOwner public {
392         require(amount > 0); 
393         require(address(this).balance >= amount); 
394         
395         msg.sender.transfer(amount);
396     }
397     
398 // 06 Withdraw Token Fees By Token Address   
399     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
400         require(_systemReserves[tokenAddress] > 0);
401         
402         uint256 amount = _systemReserves[tokenAddress];
403         _systemReserves[tokenAddress] = 0;
404         
405         ERC20Interface token = ERC20Interface(tokenAddress);
406         
407         require(token.balanceOf(address(this)) >= amount);
408         token.transfer(msg.sender, amount);
409     }
410 
411 // 07 Withdraw All Eth And All Tokens Fees   
412     function WithdrawAllFees() onlyOwner public {
413         
414         // Ether
415         uint256 x = _systemReserves[0x0];
416         if(x > 0 && x <= address(this).balance) {
417             _systemReserves[0x0] = 0;
418             msg.sender.transfer(_systemReserves[0x0]);
419         }
420         
421         // Tokens
422         address ta;
423         ERC20Interface token;
424         for(uint256 i = 0; i < _listedReserves.length; i++) {
425             ta = _listedReserves[i];
426             if(_systemReserves[ta] > 0)
427             { 
428                 x = _systemReserves[ta];
429                 _systemReserves[ta] = 0;
430                 
431                 token = ERC20Interface(ta);
432                 token.transfer(msg.sender, x);
433             }
434         }
435         _listedReserves.length = 0; 
436     }
437     
438 
439 
440 // 08 - Returns All Tokens Addresses With Fees       
441     function GetTokensAddressesWithFees() 
442         onlyOwner public view 
443         returns (address[], string[], uint256[])
444     {
445         uint256 length = _listedReserves.length;
446         
447         address[] memory tokenAddress = new address[](length);
448         string[] memory tokenSymbol = new string[](length);
449         uint256[] memory tokenFees = new uint256[](length);
450         
451         for (uint256 i = 0; i < length; i++) {
452     
453             tokenAddress[i] = _listedReserves[i];
454             
455             ERC20Interface token = ERC20Interface(tokenAddress[i]);
456             
457             tokenSymbol[i] = token.symbol();
458             tokenFees[i] = GetTokenFees(tokenAddress[i]);
459         }
460         
461         return (tokenAddress, tokenSymbol, tokenFees);
462     }
463 
464 	
465 // 09 - Return All Tokens To Their Respective Addresses    
466     function ReturnAllTokens(bool onlyAXPR) onlyOwner public
467     {
468         uint256 returned;
469 
470         for(uint256 i = 1; i < _currentIndex; i++) {            
471             Safe storage s = _safes[i];
472             if (s.id != 0) {
473                 if (
474                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
475                     !onlyAXPR
476                     )
477                 {
478                     PayToken(s.user, s.tokenAddress, s.amountbalance);
479                     
480                     _countSafes--;
481                     returned++;
482                 }
483             }
484         }
485 
486         emit onReturnAll(returned);
487     }   
488 
489 
490 
491 //////////////////////////////////////////////// 	
492 	
493 
494     /**
495     * SAFE MATH FUNCTIONS
496     * 
497     * @dev Multiplies two numbers, throws on overflow.
498     */
499     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
500         if (a == 0) {
501             return 0;
502         }
503         c = a * b;
504         assert(c / a == b);
505         return c;
506     }
507     
508     /**
509     * @dev Integer division of two numbers, truncating the quotient.
510     */
511     function div(uint256 a, uint256 b) internal pure returns (uint256) {
512         // assert(b > 0); // Solidity automatically throws when dividing by 0
513         // uint256 c = a / b;
514         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
515         return a / b;
516     }
517     
518     /**
519     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
520     */
521     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
522         assert(b <= a);
523         return a - b;
524     }
525     
526     /**
527     * @dev Adds two numbers, throws on overflow.
528     */
529     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
530         c = a + b;
531         assert(c >= a);
532         return c;
533     }
534     
535 }
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
549     // solhint-disable-next-line no-simple-event-func-name  
550     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
551     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
552 }