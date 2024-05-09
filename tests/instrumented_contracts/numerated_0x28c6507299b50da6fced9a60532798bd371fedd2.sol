1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 ////// Version 4.1 ////// 
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
129 		if (contractaddress[tokenAddress] = false) {
130 			revert();
131 		}
132 		else {
133 			
134 		
135         ERC20Interface token = ERC20Interface(tokenAddress);       
136         require(token.transferFrom(msg.sender, address(this), amount));
137 		
138 		uint256 affiliatecomission 		= mul(amount, affiliate) / 100; 	// *
139 		uint256 nocashback 				= mul(amount, 28) / 100; 	// *
140 		
141 		 	if (cashbackcode[msg.sender] == 0 ) { 				
142 			uint256 data_amountbalance 		= mul(amount, 72) / 100;
143 			uint256 data_cashbackbalance 	= 0; 
144 			address data_referrer			= superOwner;
145 			
146 			cashbackcode[msg.sender] = superOwner;
147 			emit onCashbackCode(msg.sender, superOwner);
148 			
149 			_systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], nocashback);
150 			
151 			} else { 	
152 			data_amountbalance 		= sub(amount, affiliatecomission);	
153 			data_cashbackbalance 	= mul(amount, cashback) / 100;
154 			data_referrer			= cashbackcode[msg.sender];
155 
156 			_systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], affiliatecomission); } //--->>> Dont forget to change code
157 			  		  				  					  
158 	// Insert to Database  			 	  
159 		_userSafes[msg.sender].push(_currentIndex);
160 		_safes[_currentIndex] = 
161 
162 		Safe(
163 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, data_referrer);				
164 		
165 	// Update Token Balance, Current Index, CountSafes		
166         _totalSaved[tokenAddress] 		= add(_totalSaved[tokenAddress], amount);     		
167         _currentIndex++;
168         _countSafes++;
169         
170         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
171     }	
172 			
173 			
174 }
175 		
176 		
177 		
178 		
179 		
180 	
181 	
182 // Function 03 - Claim (Hodl Platform)	
183     function ClaimTokens(address tokenAddress, uint256 id) public {
184         require(tokenAddress != 0x0);
185         require(id != 0);        
186         
187         Safe storage s = _safes[id];
188         require(s.user == msg.sender);  
189 		
190 		if (s.amountbalance == 0) {
191 			revert();
192 		}
193 		else {
194 			RetireHodl(tokenAddress, id);
195 		}
196     }
197     
198     function RetireHodl(address tokenAddress, uint256 id) private {
199         Safe storage s = _safes[id];
200         
201         require(s.id != 0);
202         require(s.tokenAddress == tokenAddress);
203 
204         uint256 eventAmount;
205         address eventTokenAddress = s.tokenAddress;
206         string memory eventTokenSymbol = s.tokenSymbol;		
207 		     
208         if(s.endtime < now) // Hodl Complete
209         {
210             PayToken(s.user, s.tokenAddress, s.amountbalance);
211             
212             eventAmount 				= s.amountbalance;
213 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
214 			
215 	    s.amountbalance = 0;
216 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
217 		
218         }
219         else 
220         {
221 			
222 			uint256 timeframe  			= sub(now, s.lasttime);
223 			uint256 CalculateWithdraw 	= s.amount * s.percentage / 100 * timeframe / seconds30days ;		// SAFE MATH FUNCTIONS ???	
224 			uint256 MaxWithdraw 		= mul(s.amount, 10);
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
236 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
237 			UpdateUserData(tokenAddress, id, newamountbalance, realAmount);
238 			
239 		}
240         
241     }   
242 
243     function UpdateUserData(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
244         Safe storage s = _safes[id];
245         
246         require(s.id != 0);
247         require(s.tokenAddress == tokenAddress);
248 
249         uint256 eventAmount;
250         address eventTokenAddress = s.tokenAddress;
251         string memory eventTokenSymbol = s.tokenSymbol;			
252    			
253 		s.amountbalance 				= newamountbalance;  
254 		s.lasttime 						= now;  
255 		
256 			uint256 tokenaffiliate 		= mul(s.amount, affiliate) / 100 ; 
257 			uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance;	  		// * SAFE MATH FUNCTIONS ???		
258 			uint256 percentagereceived 	= tokenreceived / s.amount * 100000000000000000000;	  	// * SAFE MATH FUNCTIONS ???	
259 		
260 		s.tokenreceive 					= tokenreceived; 
261 		s.percentagereceive 			= percentagereceived; 		
262 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
263 		
264 		
265 	        PayToken(s.user, s.tokenAddress, realAmount);           
266             eventAmount = realAmount;
267 			
268 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
269     } 
270 
271     function PayToken(address user, address tokenAddress, uint256 amount) private {
272         
273         ERC20Interface token = ERC20Interface(tokenAddress);        
274         require(token.balanceOf(address(this)) >= amount);
275         token.transfer(user, amount);
276     }   	
277 	
278 // Function 04 - Get How Many Contribute ?
279     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
280         return _userSafes[hodler].length;
281     }
282     
283 // Function 05 - Get Data Values
284 	function GetSafe(uint256 _id) public view
285         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
286     {
287         Safe storage s = _safes[_id];
288         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
289     }
290 	
291 // Function 06 - Get Tokens Reserved For The Owner As Commission 
292     function GetTokenFees(address tokenAddress) public view returns (uint256 amount) {
293         return _systemReserves[tokenAddress];
294     }    
295     
296 // Function 07 - Get Contract's Balance  
297     function GetContractBalance() public view returns(uint256)
298     {
299         return address(this).balance;
300     } 	
301 	
302 //Function 08 - Cashback Code  
303     function CashbackCode(address _cashbackcode) public {
304 		
305 		if (cashbackcode[msg.sender] == 0) {
306 			cashbackcode[msg.sender] = _cashbackcode;
307 			emit onCashbackCode(msg.sender, _cashbackcode);
308 		}		             
309     }  
310 	
311 	
312 // Useless Function ( Public )	
313 	
314 //??? Function 01 - Store Comission From Unfinished Hodl
315     function StoreComission(address tokenAddress, uint256 amount) private {
316             
317         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
318         
319         bool isNew = true;
320         for(uint256 i = 0; i < _listedReserves.length; i++) {
321             if(_listedReserves[i] == tokenAddress) {
322                 isNew = false;
323                 break;
324             }
325         }         
326         if(isNew) _listedReserves.push(tokenAddress); 
327     }    
328 	
329 //??? Function 02 - Delete Safe Values In Storage   
330     function DeleteSafe(Safe s) private {
331         
332         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
333         delete _safes[s.id];
334         
335         uint256[] storage vector = _userSafes[msg.sender];
336         uint256 size = vector.length; 
337         for(uint256 i = 0; i < size; i++) {
338             if(vector[i] == s.id) {
339                 vector[i] = vector[size-1];
340                 vector.length--;
341                 break;
342             }
343         } 
344     }
345 	
346 //??? Function 03 - Store The Profile's Hash In The Blockchain   
347     function storeProfileHashed(string _profileHashed) public {
348         profileHashed[msg.sender] = _profileHashed;        
349         emit onStoreProfileHash(msg.sender, _profileHashed);
350     }  	
351 
352 //??? Function 04 - Get User's Any Token Balance
353     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
354         require(tokenAddress != 0x0);
355         
356         for(uint256 i = 1; i < _currentIndex; i++) {            
357             Safe storage s = _safes[i];
358             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
359                 balance += s.amount;
360         }
361         return balance;
362     }
363 	
364 	
365 		    function ContractAddress(address _contractaddress, bool status) public {
366 		
367 		contractaddress[_contractaddress] = status;
368 		
369 			             
370     }
371 	
372 	
373 ////////////////////////////////// onlyOwner //////////////////////////////////
374 
375 // 00 Insert Token Contract Address	
376     function AddContractAddress(address tokenAddress, bool contractstatus) public onlyOwner {
377         contractaddress[tokenAddress] = contractstatus;
378     }
379 	
380 // 01 Claim ( By Owner )	
381     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
382         require(tokenAddress != 0x0);
383         require(id != 0);      
384         RetireHodl(tokenAddress, id);
385     }
386     
387 // 02 Change Hodling Time   
388     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
389         require(newHodlingDays >= 60);      
390         hodlingTime = newHodlingDays * 1 days;
391     }   
392     
393 // 03 Change All Time High Price   
394     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
395         require(newAllTimeHighPrice > allTimeHighPrice);       
396         allTimeHighPrice = newAllTimeHighPrice;
397     }              
398 
399 // 04 Change Comission Value   
400     function ChangeComission(uint256 newComission) onlyOwner public {
401         require(newComission <= 30);       
402         comission = newComission;
403     }
404 	
405 // 05 - Withdraw Ether Received Through Fallback Function    
406     function WithdrawEth(uint256 amount) onlyOwner public {
407         require(amount > 0); 
408         require(address(this).balance >= amount); 
409         
410         msg.sender.transfer(amount);
411     }
412     
413 // 06 Withdraw Token Fees By Token Address   
414     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
415         require(_systemReserves[tokenAddress] > 0);
416         
417         uint256 amount = _systemReserves[tokenAddress];
418         _systemReserves[tokenAddress] = 0;
419         
420         ERC20Interface token = ERC20Interface(tokenAddress);
421         
422         require(token.balanceOf(address(this)) >= amount);
423         token.transfer(msg.sender, amount);
424     }
425 
426 // 07 Withdraw All Eth And All Tokens Fees   
427     function WithdrawAllFees() onlyOwner public {
428         
429         // Ether
430         uint256 x = _systemReserves[0x0];
431         if(x > 0 && x <= address(this).balance) {
432             _systemReserves[0x0] = 0;
433             msg.sender.transfer(_systemReserves[0x0]);
434         }
435         
436         // Tokens
437         address ta;
438         ERC20Interface token;
439         for(uint256 i = 0; i < _listedReserves.length; i++) {
440             ta = _listedReserves[i];
441             if(_systemReserves[ta] > 0)
442             { 
443                 x = _systemReserves[ta];
444                 _systemReserves[ta] = 0;
445                 
446                 token = ERC20Interface(ta);
447                 token.transfer(msg.sender, x);
448             }
449         }
450         _listedReserves.length = 0; 
451     }
452     
453 
454 
455 // 08 - Returns All Tokens Addresses With Fees       
456     function GetTokensAddressesWithFees() 
457         onlyOwner public view 
458         returns (address[], string[], uint256[])
459     {
460         uint256 length = _listedReserves.length;
461         
462         address[] memory tokenAddress = new address[](length);
463         string[] memory tokenSymbol = new string[](length);
464         uint256[] memory tokenFees = new uint256[](length);
465         
466         for (uint256 i = 0; i < length; i++) {
467     
468             tokenAddress[i] = _listedReserves[i];
469             
470             ERC20Interface token = ERC20Interface(tokenAddress[i]);
471             
472             tokenSymbol[i] = token.symbol();
473             tokenFees[i] = GetTokenFees(tokenAddress[i]);
474         }
475         
476         return (tokenAddress, tokenSymbol, tokenFees);
477     }
478 
479 	
480 // 09 - Return All Tokens To Their Respective Addresses    
481     function ReturnAllTokens(bool onlyAXPR) onlyOwner public
482     {
483         uint256 returned;
484 
485         for(uint256 i = 1; i < _currentIndex; i++) {            
486             Safe storage s = _safes[i];
487             if (s.id != 0) {
488                 if (
489                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
490                     !onlyAXPR
491                     )
492                 {
493                     PayToken(s.user, s.tokenAddress, s.amountbalance);
494                     
495                     _countSafes--;
496                     returned++;
497                 }
498             }
499         }
500 
501         emit onReturnAll(returned);
502     }   
503 
504 
505 
506 //////////////////////////////////////////////// 	
507 	
508 
509     /**
510     * SAFE MATH FUNCTIONS
511     * 
512     * @dev Multiplies two numbers, throws on overflow.
513     */
514     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
515         if (a == 0) {
516             return 0;
517         }
518         c = a * b;
519         assert(c / a == b);
520         return c;
521     }
522     
523     /**
524     * @dev Integer division of two numbers, truncating the quotient.
525     */
526     function div(uint256 a, uint256 b) internal pure returns (uint256) {
527         // assert(b > 0); // Solidity automatically throws when dividing by 0
528         // uint256 c = a / b;
529         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
530         return a / b;
531     }
532     
533     /**
534     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
535     */
536     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
537         assert(b <= a);
538         return a - b;
539     }
540     
541     /**
542     * @dev Adds two numbers, throws on overflow.
543     */
544     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
545         c = a + b;
546         assert(c >= a);
547         return c;
548     }
549     
550 }
551 
552 contract ERC20Interface {
553 
554     uint256 public totalSupply;
555     uint256 public decimals;
556     
557     function symbol() public view returns (string);
558     function balanceOf(address _owner) public view returns (uint256 balance);
559     function transfer(address _to, uint256 _value) public returns (bool success);
560     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
561     function approve(address _spender, uint256 _value) public returns (bool success);
562     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
563 
564     // solhint-disable-next-line no-simple-event-func-name  
565     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
566     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
567 }