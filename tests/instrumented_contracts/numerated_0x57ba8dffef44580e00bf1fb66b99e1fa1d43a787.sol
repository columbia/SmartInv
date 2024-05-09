1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 ////// Version 4.2 ////// 
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
129 		if (contractaddress[tokenAddress] == false) {
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
177 // Function 03 - Claim (Hodl Platform)	
178     function ClaimTokens(address tokenAddress, uint256 id) public {
179         require(tokenAddress != 0x0);
180         require(id != 0);        
181         
182         Safe storage s = _safes[id];
183         require(s.user == msg.sender);  
184 		
185 		if (s.amountbalance == 0) {
186 			revert();
187 		}
188 		else {
189 			RetireHodl(tokenAddress, id);
190 		}
191     }
192     
193     function RetireHodl(address tokenAddress, uint256 id) private {
194         Safe storage s = _safes[id];
195         
196         require(s.id != 0);
197         require(s.tokenAddress == tokenAddress);
198 
199         uint256 eventAmount;
200         address eventTokenAddress = s.tokenAddress;
201         string memory eventTokenSymbol = s.tokenSymbol;		
202 		     
203         if(s.endtime < now) // Hodl Complete
204         {
205             PayToken(s.user, s.tokenAddress, s.amountbalance);
206             
207             eventAmount 				= s.amountbalance;
208 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
209 			
210 	    s.amountbalance = 0;
211 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
212 		
213         }
214         else 
215         {
216 			
217 			uint256 timeframe  			= sub(now, s.lasttime);
218 			uint256 CalculateWithdraw 	= s.amount * s.percentage / 100 * timeframe / seconds30days ;		// SAFE MATH FUNCTIONS ???	
219 			uint256 MaxWithdraw 		= mul(s.amount, 10);
220 			
221 			// Maximum withdraw before unlocked, Max 10% Accumulation
222 			if (CalculateWithdraw > MaxWithdraw) { 				
223 			uint256 MaxAccumulation = MaxWithdraw; 
224 			} else { MaxAccumulation = CalculateWithdraw; }
225 			
226 			// Maximum withdraw = User Amount Balance   
227 			if (MaxAccumulation > s.amountbalance) { 			     	
228 			uint256 realAmount = s.amountbalance; 
229 			} else { realAmount = MaxAccumulation; }
230 			   				
231 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
232 			UpdateUserData(tokenAddress, id, newamountbalance, realAmount);
233 			
234 		}
235         
236     }   
237 
238     function UpdateUserData(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
239         Safe storage s = _safes[id];
240         
241         require(s.id != 0);
242         require(s.tokenAddress == tokenAddress);
243 
244         uint256 eventAmount;
245         address eventTokenAddress = s.tokenAddress;
246         string memory eventTokenSymbol = s.tokenSymbol;			
247    			
248 		s.amountbalance 				= newamountbalance;  
249 		s.lasttime 						= now;  
250 		
251 			uint256 tokenaffiliate 		= mul(s.amount, affiliate) / 100 ; 
252 			uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance;	  		// * SAFE MATH FUNCTIONS ???		
253 			uint256 percentagereceived 	= tokenreceived / s.amount * 100000000000000000000;	  	// * SAFE MATH FUNCTIONS ???	
254 		
255 		s.tokenreceive 					= tokenreceived; 
256 		s.percentagereceive 			= percentagereceived; 		
257 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
258 		
259 		
260 	        PayToken(s.user, s.tokenAddress, realAmount);           
261             eventAmount = realAmount;
262 			
263 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
264     } 
265 
266     function PayToken(address user, address tokenAddress, uint256 amount) private {
267         
268         ERC20Interface token = ERC20Interface(tokenAddress);        
269         require(token.balanceOf(address(this)) >= amount);
270         token.transfer(user, amount);
271     }   	
272 	
273 // Function 04 - Get How Many Contribute ?
274     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
275         return _userSafes[hodler].length;
276     }
277     
278 // Function 05 - Get Data Values
279 	function GetSafe(uint256 _id) public view
280         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
281     {
282         Safe storage s = _safes[_id];
283         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
284     }
285 	
286 // Function 06 - Get Tokens Reserved For The Owner As Commission 
287     function GetTokenFees(address tokenAddress) public view returns (uint256 amount) {
288         return _systemReserves[tokenAddress];
289     }    
290     
291 // Function 07 - Get Contract's Balance  
292     function GetContractBalance() public view returns(uint256)
293     {
294         return address(this).balance;
295     } 	
296 	
297 //Function 08 - Cashback Code  
298     function CashbackCode(address _cashbackcode) public {
299 		
300 		if (cashbackcode[msg.sender] == 0) {
301 			cashbackcode[msg.sender] = _cashbackcode;
302 			emit onCashbackCode(msg.sender, _cashbackcode);
303 		}		             
304     }  
305 	
306 	
307 // Useless Function ( Public )	
308 	
309 //??? Function 01 - Store Comission From Unfinished Hodl
310     function StoreComission(address tokenAddress, uint256 amount) private {
311             
312         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
313         
314         bool isNew = true;
315         for(uint256 i = 0; i < _listedReserves.length; i++) {
316             if(_listedReserves[i] == tokenAddress) {
317                 isNew = false;
318                 break;
319             }
320         }         
321         if(isNew) _listedReserves.push(tokenAddress); 
322     }    
323 	
324 //??? Function 02 - Delete Safe Values In Storage   
325     function DeleteSafe(Safe s) private {
326         
327         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
328         delete _safes[s.id];
329         
330         uint256[] storage vector = _userSafes[msg.sender];
331         uint256 size = vector.length; 
332         for(uint256 i = 0; i < size; i++) {
333             if(vector[i] == s.id) {
334                 vector[i] = vector[size-1];
335                 vector.length--;
336                 break;
337             }
338         } 
339     }
340 	
341 //??? Function 03 - Store The Profile's Hash In The Blockchain   
342     function storeProfileHashed(string _profileHashed) public {
343         profileHashed[msg.sender] = _profileHashed;        
344         emit onStoreProfileHash(msg.sender, _profileHashed);
345     }  	
346 
347 //??? Function 04 - Get User's Any Token Balance
348     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
349         require(tokenAddress != 0x0);
350         
351         for(uint256 i = 1; i < _currentIndex; i++) {            
352             Safe storage s = _safes[i];
353             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
354                 balance += s.amount;
355         }
356         return balance;
357     }
358 	
359 	
360 		    function ContractAddress(address _contractaddress, bool status) public {
361 		
362 		contractaddress[_contractaddress] = status;
363 		
364 			             
365     }
366 	
367 	
368 ////////////////////////////////// onlyOwner //////////////////////////////////
369 
370 // 00 Insert Token Contract Address	
371     function AddContractAddress(address tokenAddress, bool contractstatus) public onlyOwner {
372         contractaddress[tokenAddress] = contractstatus;
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
500 
501 //////////////////////////////////////////////// 	
502 	
503 
504     /**
505     * SAFE MATH FUNCTIONS
506     * 
507     * @dev Multiplies two numbers, throws on overflow.
508     */
509     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
510         if (a == 0) {
511             return 0;
512         }
513         c = a * b;
514         assert(c / a == b);
515         return c;
516     }
517     
518     /**
519     * @dev Integer division of two numbers, truncating the quotient.
520     */
521     function div(uint256 a, uint256 b) internal pure returns (uint256) {
522         // assert(b > 0); // Solidity automatically throws when dividing by 0
523         // uint256 c = a / b;
524         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
525         return a / b;
526     }
527     
528     /**
529     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
530     */
531     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
532         assert(b <= a);
533         return a - b;
534     }
535     
536     /**
537     * @dev Adds two numbers, throws on overflow.
538     */
539     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
540         c = a + b;
541         assert(c >= a);
542         return c;
543     }
544     
545 }
546 
547 contract ERC20Interface {
548 
549     uint256 public totalSupply;
550     uint256 public decimals;
551     
552     function symbol() public view returns (string);
553     function balanceOf(address _owner) public view returns (uint256 balance);
554     function transfer(address _to, uint256 _value) public returns (bool success);
555     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
556     function approve(address _spender, uint256 _value) public returns (bool success);
557     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
558 
559     // solhint-disable-next-line no-simple-event-func-name  
560     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
561     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
562 }