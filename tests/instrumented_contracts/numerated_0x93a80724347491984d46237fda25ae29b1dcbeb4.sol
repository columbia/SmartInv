1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 ////// Version 2.0 ////// 
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
58     event onStoreProfileHash(address indexed hodler, string profileHashed);
59     event onHodlTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
60     event onClaimTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
61     event onReturnAll(uint256 returned);
62 	
63     // Variables // * = New ** = Undeveloped
64 	
65     address internal AXPRtoken;
66     mapping(address => string) public profileHashed; 			// User Prime 
67 	
68 	// Default Setting
69 	
70 	uint256 public hodlingTime;
71     uint256 public allTimeHighPrice;
72 	uint256 public percent 						= 600;        	// * Only test 300% Permonth
73 	uint256 private constant affiliate 			= 12;        	// * 12% from deposit
74 	uint256 private constant cashback 			= 16;        	// * 16% from deposit
75 	uint256 private constant totalreceive 		= 88;        	// * 88% from deposit	
76     uint256 private constant seconds30days 		= 2592000;  	// *
77 
78     struct Safe {
79         uint256 id;
80         uint256 amount;
81         uint256 endtime;
82         address user;
83         address tokenAddress;
84 		string  tokenSymbol;	
85 		uint256 amountbalance; 									// * --- > 88% from deposit
86 		uint256 cashbackbalance; 								// * --- > 16% from deposit
87 		uint256 lasttime; 										// * --- > Now
88 		uint256 percentage; 									// * --- > return tokens every month
89 		uint256 percentagereceive; 								// * --- > 0 %
90 		uint256 tokenreceive; 									// * --- > 0 Token
91 		uint256 affiliatebalance; 								// **
92 		address referrer; 										// **
93 
94     }
95     
96     //Safes Variables
97   
98     mapping(address => uint256[]) 	public 	_userSafes;
99     mapping(uint256 => Safe) 		private _safes; 				// = Struct safe
100     uint256 						private _currentIndex; 		// Id Number
101     uint256 						public 	_countSafes; 		// Total User
102     mapping(address => uint256) 	public 	_totalSaved; 		// ERC20 Token Balance count
103     
104     //Dev Owner Variables
105 
106     uint256 						public comission;
107     mapping(address => uint256) 	private _systemReserves;    	// Token Balance Reserve
108     address[] 						public _listedReserves;
109     
110     //Constructor
111    
112     constructor() public {
113         
114         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;        
115         hodlingTime 	= 730 days;
116         _currentIndex 	= 500;
117         comission 		= 5;
118     }
119     
120 	
121 // Function 01 - Fallback Function To Receive Donation In Eth
122     function () public payable {
123         require(msg.value > 0);       
124         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
125     }
126 	
127 // Function 02 - Hodl ERC20 Token	
128     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
129         require(tokenAddress != 0x0);
130         require(amount > 0);
131 		
132         ERC20Interface token = ERC20Interface(tokenAddress);       
133         require(token.transferFrom(msg.sender, address(this), amount));
134 		
135 		    uint256 affiliatecomission 		= mul(amount, affiliate) / 100; // *			
136             uint256 data_amountbalance 		= sub(amount, affiliatecomission); // * 
137 			uint256 data_cashbackbalance 	= mul(amount, cashback) / 100; // *			 
138 			  		  				  					  
139 	// Insert to Database  			 	  
140 		_userSafes[msg.sender].push(_currentIndex);
141 		_safes[_currentIndex] = 
142 
143 		Safe(
144 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, superOwner);				
145 		
146 	// Update Token Balance, Current Index, CountSafes		
147         _totalSaved[tokenAddress] = add(_totalSaved[tokenAddress], amount);        
148         _currentIndex++;
149         _countSafes++;
150         
151         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
152     }
153 	
154 	
155 // Function 03 - Withdraw Token	
156     function ClaimTokens(address tokenAddress, uint256 id) public {
157         require(tokenAddress != 0x0);
158         require(id != 0);        
159         
160         Safe storage s = _safes[id];
161         require(s.user == msg.sender);       
162         RetireHodl(tokenAddress, id);
163     }
164     
165     function RetireHodl(address tokenAddress, uint256 id) private {
166         Safe storage s = _safes[id];
167         
168         require(s.id != 0);
169         require(s.tokenAddress == tokenAddress);
170         require(
171                 (tokenAddress == AXPRtoken && s.endtime < now ) ||
172                     tokenAddress != AXPRtoken
173                 );
174 
175         uint256 eventAmount;
176         address eventTokenAddress = s.tokenAddress;
177         string memory eventTokenSymbol = s.tokenSymbol;		
178         
179         if(s.endtime < now) // Hodl Complete
180         {
181             PayToken(s.user, s.tokenAddress, s.amountbalance);
182             
183             eventAmount 				= s.amountbalance;
184 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
185 			
186 	    s.amountbalance = 0;
187 		
188         }
189         else 
190         {
191 			
192 			uint256 timeframe  			= now - s.lasttime;
193 			uint256 CalculateWithdraw 	= s.amount * s.percentage / 100 * timeframe / seconds30days ;			
194 			uint256 MaxWithdraw 		= s.amount / 10 ;
195 			
196 			if (CalculateWithdraw > MaxWithdraw) { 					
197 			uint256 realAmount = MaxWithdraw; 
198 			}
199 			else {
200 			realAmount = CalculateWithdraw; 
201 			}
202 			   				
203 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	 // *  	
204             			
205 		s.amountbalance 				= newamountbalance;  // *
206 		s.lasttime 						= now;  // *
207 
208 		
209 			uint256 tokenaffiliate 		= mul(s.amount, affiliate) / 100 ; // * 
210 			uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance;	  // * 				
211 			uint256 percentagereceived 	= tokenreceived / s.amount * 100;	  // *
212 		
213 		s.tokenreceive 					= tokenreceived; // *
214 		s.percentagereceive 			= percentagereceived; // *		
215 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); // *
216 		
217 		
218 	        PayToken(s.user, s.tokenAddress, realAmount);           
219             eventAmount = realAmount;
220 				
221 		}
222         
223         emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
224     }    
225       
226     function PayToken(address user, address tokenAddress, uint256 amount) private {
227         
228         ERC20Interface token = ERC20Interface(tokenAddress);        
229         require(token.balanceOf(address(this)) >= amount);
230         token.transfer(user, amount);
231     }   	
232 	
233 //??? Function 04 - Store Comission From Unfinished Hodl
234     function StoreComission(address tokenAddress, uint256 amount) private {
235             
236         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
237         
238         bool isNew = true;
239         for(uint256 i = 0; i < _listedReserves.length; i++) {
240             if(_listedReserves[i] == tokenAddress) {
241                 isNew = false;
242                 break;
243             }
244         }         
245         if(isNew) _listedReserves.push(tokenAddress); 
246     }    
247 	
248 //??? Function 05 - Delete Safe Values In Storage   
249     function DeleteSafe(Safe s) private {
250         
251         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
252         delete _safes[s.id];
253         
254         uint256[] storage vector = _userSafes[msg.sender];
255         uint256 size = vector.length; 
256         for(uint256 i = 0; i < size; i++) {
257             if(vector[i] == s.id) {
258                 vector[i] = vector[size-1];
259                 vector.length--;
260                 break;
261             }
262         } 
263     }
264 	
265 //??? Function 06 - Store The Profile's Hash In The Blockchain   
266     function storeProfileHashed(string _profileHashed) public {
267         profileHashed[msg.sender] = _profileHashed;        
268         emit onStoreProfileHash(msg.sender, _profileHashed);
269     }  	
270 
271 //??? Function 07 - Get User's Any Token Balance
272     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
273         require(tokenAddress != 0x0);
274         
275         for(uint256 i = 1; i < _currentIndex; i++) {            
276             Safe storage s = _safes[i];
277             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
278                 balance += s.amount;
279         }
280         return balance;
281     }
282 
283 // Function 08 - Get How Many Safes Has The User  
284     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
285         return _userSafes[hodler].length;
286     }
287     
288 // Function 09 - Get Safes Values
289 	function GetSafe(uint256 _id) public view
290         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
291     {
292         Safe storage s = _safes[_id];
293         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
294     }
295 	
296 // Function 10 - Get Tokens Reserved For The Owner As Commission 
297     function GetTokenFees(address tokenAddress) private view returns (uint256 amount) {
298         return _systemReserves[tokenAddress];
299     }    
300     
301 // Function 11 - Get Contract's Balance  
302     function GetContractBalance() public view returns(uint256)
303     {
304         return address(this).balance;
305     } 
306 
307 // Function 12 - Available For Withdrawal
308 	function AvailableForWithdrawal(uint256 _id) public view
309         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 amountbalance, uint256 lastwithdraw, uint256 timeframe, uint256 availableforwithdrawal)
310     {
311         Safe storage s = _safes[_id];
312 					
313 			uint256 CalculateWithdraw 	= s.amount * s.percentage / 100 * timeframe / seconds30days ;			
314 			uint256 MaxWithdraw 		= s.amount / 10 ;
315 			
316 			if (CalculateWithdraw > MaxWithdraw) { 					
317 			uint256 realAmount = MaxWithdraw; 
318 			}
319 			else {
320 			realAmount = CalculateWithdraw; 
321 			}
322 		
323         return(s.id, s.user, s.tokenAddress, s.amount, s.amountbalance, s.lasttime, timeframe, realAmount);
324     }
325 	
326     
327 	
328 ////////////////////////////////// onlyOwner //////////////////////////////////
329 
330 	
331 // 01 Retire Hodl Safe   
332     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
333         require(tokenAddress != 0x0);
334         require(id != 0);      
335         RetireHodl(tokenAddress, id);
336     }
337     
338 // 02 Change Hodling Time   
339     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
340         require(newHodlingDays >= 60);      
341         hodlingTime = newHodlingDays * 1 days;
342     }   
343     
344 // 03 Change All Time High Price   
345     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
346         require(newAllTimeHighPrice > allTimeHighPrice);       
347         allTimeHighPrice = newAllTimeHighPrice;
348     }              
349 
350 // 04 Change Comission Value   
351     function ChangeComission(uint256 newComission) onlyOwner public {
352         require(newComission <= 30);       
353         comission = newComission;
354     }
355     
356 // 05 Withdraw Token Fees By Address   
357     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
358         require(_systemReserves[tokenAddress] > 0);
359         
360         uint256 amount = _systemReserves[tokenAddress];
361         _systemReserves[tokenAddress] = 0;
362         
363         ERC20Interface token = ERC20Interface(tokenAddress);
364         
365         require(token.balanceOf(address(this)) >= amount);
366         token.transfer(msg.sender, amount);
367     }
368 
369 // 06 Withdraw All Eth And All Tokens Fees   
370     function WithdrawAllFees() onlyOwner public {
371         
372         // Ether
373         uint256 x = _systemReserves[0x0];
374         if(x > 0 && x <= address(this).balance) {
375             _systemReserves[0x0] = 0;
376             msg.sender.transfer(_systemReserves[0x0]);
377         }
378         
379         // Tokens
380         address ta;
381         ERC20Interface token;
382         for(uint256 i = 0; i < _listedReserves.length; i++) {
383             ta = _listedReserves[i];
384             if(_systemReserves[ta] > 0)
385             { 
386                 x = _systemReserves[ta];
387                 _systemReserves[ta] = 0;
388                 
389                 token = ERC20Interface(ta);
390                 token.transfer(msg.sender, x);
391             }
392         }
393         _listedReserves.length = 0; 
394     }
395     
396 
397 // 07 - Withdraw Ether Received Through Fallback Function    
398     function WithdrawEth(uint256 amount) onlyOwner public {
399         require(amount > 0); 
400         require(address(this).balance >= amount); 
401         
402         msg.sender.transfer(amount);
403     }
404 
405 // 08 - Returns All Tokens Addresses With Fees       
406     function GetTokensAddressesWithFees() 
407         onlyOwner public view 
408         returns (address[], string[], uint256[])
409     {
410         uint256 length = _listedReserves.length;
411         
412         address[] memory tokenAddress = new address[](length);
413         string[] memory tokenSymbol = new string[](length);
414         uint256[] memory tokenFees = new uint256[](length);
415         
416         for (uint256 i = 0; i < length; i++) {
417     
418             tokenAddress[i] = _listedReserves[i];
419             
420             ERC20Interface token = ERC20Interface(tokenAddress[i]);
421             
422             tokenSymbol[i] = token.symbol();
423             tokenFees[i] = GetTokenFees(tokenAddress[i]);
424         }
425         
426         return (tokenAddress, tokenSymbol, tokenFees);
427     }
428 
429 	
430 // 09 - Return All Tokens To Their Respective Addresses    
431     function ReturnAllTokens(bool onlyAXPR) onlyOwner public
432     {
433         uint256 returned;
434 
435         for(uint256 i = 1; i < _currentIndex; i++) {            
436             Safe storage s = _safes[i];
437             if (s.id != 0) {
438                 if (
439                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
440                     !onlyAXPR
441                     )
442                 {
443                     PayToken(s.user, s.tokenAddress, s.amountbalance);
444                     
445                     _countSafes--;
446                     returned++;
447                 }
448             }
449         }
450 
451         emit onReturnAll(returned);
452     }    
453 
454 	
455 //////////////////////////////////////////////// 	
456 	
457 
458     /**
459     * SAFE MATH FUNCTIONS
460     * 
461     * @dev Multiplies two numbers, throws on overflow.
462     */
463     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
464         if (a == 0) {
465             return 0;
466         }
467         c = a * b;
468         assert(c / a == b);
469         return c;
470     }
471     
472     /**
473     * @dev Integer division of two numbers, truncating the quotient.
474     */
475     function div(uint256 a, uint256 b) internal pure returns (uint256) {
476         // assert(b > 0); // Solidity automatically throws when dividing by 0
477         // uint256 c = a / b;
478         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
479         return a / b;
480     }
481     
482     /**
483     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
484     */
485     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
486         assert(b <= a);
487         return a - b;
488     }
489     
490     /**
491     * @dev Adds two numbers, throws on overflow.
492     */
493     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
494         c = a + b;
495         assert(c >= a);
496         return c;
497     }
498     
499 }
500 
501 contract ERC20Interface {
502 
503     uint256 public totalSupply;
504     uint256 public decimals;
505     
506     function symbol() public view returns (string);
507     function balanceOf(address _owner) public view returns (uint256 balance);
508     function transfer(address _to, uint256 _value) public returns (bool success);
509     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
510     function approve(address _spender, uint256 _value) public returns (bool success);
511     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
512 
513     // solhint-disable-next-line no-simple-event-func-name  
514     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
515     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
516 }