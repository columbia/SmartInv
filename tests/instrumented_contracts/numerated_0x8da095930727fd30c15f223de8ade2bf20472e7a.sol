1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 // Version 1.1
5 // Contract 01
6 
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
19     function viewSuperOwner() private view returns (address owner) {
20         return superOwner;
21     }
22       
23     function changeOwner(address newOwner) onlyOwner public {
24         require(newOwner != superOwner);
25         
26         superOwner = newOwner;
27         
28         emit onTransferOwnership(superOwner);
29     }
30 }
31 
32 // Contract 02
33 
34 contract BlockableContract is OwnableContract {
35     
36     event onBlockHODLs(bool status);
37  
38     bool public blockedContract;
39     
40     constructor() public { 
41         blockedContract = false;  
42     }
43     
44     modifier contractActive() {
45         require(!blockedContract);
46         _;
47     } 
48     
49     function doBlockContract() onlyOwner public {
50         blockedContract = true;
51         
52         emit onBlockHODLs(blockedContract);
53     }
54     
55     function unBlockContract() onlyOwner public {
56         blockedContract = false;
57         
58         emit onBlockHODLs(blockedContract);
59     }
60 }
61 
62 // Contract 03
63 
64 contract ldoh is BlockableContract {
65     
66 event onStoreProfileHash(address indexed hodler, string profileHashed);
67 event onHodlTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
68 event onClaimTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
69 event onReturnAll(uint256 returned);
70 
71     // Variables //
72 	
73     address internal AXPRtoken;
74     mapping(address => string) public profileHashed; 		// User Prime 
75 
76 	// * = New ** = Undeveloped
77 	
78 	// Default Setting
79 	
80 	uint256 public  hodlingTime;
81 	uint256 public 	comission;
82     uint256 public  allTimeHighPrice;
83 	uint256 public  percent 				= 3;        	// * 3% from deposit
84 	uint256 private constant affiliate 		= 12;        	// * 12% from deposit
85 	uint256 private constant cashback 		= 16;        	// * 16% from deposit
86 	uint256 private constant totalreceive 	= 88;        	// * 88% from deposit	
87     uint256 private constant seconds30days 	= 2592000;  	// *
88 	
89 	bool public speed;
90 
91     struct Safe {
92         uint256 id;
93         uint256 amount;
94         uint256 endtime;
95         address user;
96         address tokenAddress;
97 		string tokenSymbol;	
98 		uint256 amountbalance; 			// * --- > 88% from deposit
99 		uint256 cashbackbalance; 		// * --- > 16% from deposit
100 		uint256 lasttime; 				// * --- > Now
101 		uint256 percentage; 			// * --- > return tokens every month
102 		uint256 percentagereceive; 		// * --- > 0 %
103 		uint256 tokenreceive; 			// * --- > 0 Token
104 		uint256 affiliateprofit; 		// **
105 		uint256 affiliatebalance; 		// **
106 		address referrer; 				// **
107 
108     }
109     
110     //safes variables
111   
112     mapping(address => uint256[]) 	public _userSafes; 		// * --- > Useless (Private)
113     mapping(uint256 => Safe) 		private _safes; 			// Struct safe
114     uint256 						private _currentIndex; 		// Id Number
115     uint256 						public 	_countSafes; 	    // Total All User	
116     mapping(address => uint256) 	public 	_totalSaved; 		// Token Balance 
117 	
118     //dev owner variables
119     mapping(address => uint256) 	private _systemReserves;    // Token Balance Reserve
120     address[] 						public 	_listedReserves;
121     
122     //constructor
123    
124     constructor() public {
125         
126         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;
127         speed 			= false;
128         hodlingTime 	= 730 days;
129         _currentIndex 	= 1;
130         comission 		= 5;
131     }
132     
133 	
134 // Total Function = 12	
135 	
136 // Function 01 - Fallback Function To Receive Donation In Eth
137     
138     function () public payable {
139         require(msg.value > 0);
140         
141         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
142     }
143 
144 
145 // Function 02 - Hodl Token
146 	
147     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
148         require(tokenAddress != 0x0);
149         require(amount > 0);
150 
151           
152         ERC20Interface token = ERC20Interface(tokenAddress);
153         
154         require(token.transferFrom(msg.sender, address(this), amount));
155 		
156 		    uint256 affiliatecomission 		= mul(amount, affiliate) / 100; 	// *			
157             uint256 data_amountbalance 		= sub(amount, affiliatecomission); 	// * 
158 			uint256 data_cashbackbalance 	= mul(amount, cashback) / 100; 		// *			 
159 			  		  
160 		// Insert to Database  
161 			 	  
162 		_userSafes[msg.sender].push(_currentIndex);
163 		_safes[_currentIndex] = 
164 
165 		Safe(
166 
167 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, 0, 0xA15C7Ebe1f07CaF6bFF097D8a589fb8AC49Ae5B3);
168 				
169 		
170 		// Update Token Balance, Current Index, CountSafes
171 		
172         _totalSaved[tokenAddress] = add(_totalSaved[tokenAddress], amount);        
173         _currentIndex++;
174         _countSafes++;
175         
176         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
177     }
178 	
179 	
180 // Function 03 - Withdraw Token
181 	
182     function ClaimTokens(address tokenAddress, uint256 id) public {
183         require(tokenAddress != 0x0);
184         require(id != 0);        
185         
186         Safe storage s = _safes[id];
187         require(s.user == msg.sender);
188         
189         RetireHodl(tokenAddress, id);
190     }
191     
192     function RetireHodl(address tokenAddress, uint256 id) private {
193 
194         Safe storage s = _safes[id];
195         
196         require(s.id != 0);
197         require(s.tokenAddress == tokenAddress);
198         require(
199                 (tokenAddress == AXPRtoken && s.endtime < now ) ||
200                     tokenAddress != AXPRtoken
201                 );
202 
203         uint256 eventAmount;
204         address eventTokenAddress = s.tokenAddress;
205         string memory eventTokenSymbol = s.tokenSymbol;
206         
207         if(s.endtime < now) // hodl complete
208         {
209             PayToken(s.user, s.tokenAddress, s.amountbalance);
210             
211             eventAmount = s.amountbalance;
212 		   _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
213 			
214 	    s.amountbalance = 0;
215 		
216         }
217         else // hodl still in progress (penalty fee applies), not for ABCD tokens
218         {
219 			
220 				if (speed == true) {
221 				uint256 final_speed = 6;
222 				}
223 				else {
224 				final_speed = 3;
225 				}
226 			
227 			uint256 timeframe  = now - s.lasttime;
228 			uint256 realAmount = s.amount * final_speed / 100 * timeframe / seconds30days ;
229           				
230 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	 // *  	
231             			
232 		s.amountbalance = newamountbalance;  // *
233 		s.lasttime = now;  // *
234 
235 		
236 			uint256 tokenaffiliate = mul(s.amount, affiliate) / 100 ; // * 
237 			uint256 tokenreceived = s.amount - tokenaffiliate - newamountbalance;	  // * 				
238 			uint256 percentagereceived = tokenreceived / s.amount * 100;	  // *
239 		
240 		s.tokenreceive = tokenreceived; // *
241 		s.percentagereceive = percentagereceived; // *		
242 		_totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], realAmount); // *
243 		
244 		
245 	        PayToken(s.user, s.tokenAddress, realAmount);           
246             eventAmount = realAmount;
247 				
248 		}
249         
250         emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
251     }    
252     
253 	
254 // Function 04 - Store Comission From Unfinished Hodl
255 	
256     function StoreComission(address tokenAddress, uint256 amount) private {
257             
258         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
259         
260         bool isNew = true;
261         for(uint256 i = 0; i < _listedReserves.length; i++) {
262             if(_listedReserves[i] == tokenAddress) {
263                 isNew = false;
264                 break;
265             }
266         }         
267         if(isNew) _listedReserves.push(tokenAddress); 
268     }    
269     
270 	
271 	
272 // Function 05 - Private Pay Token To Address
273     
274     function PayToken(address user, address tokenAddress, uint256 amount) private {
275         
276         ERC20Interface token = ERC20Interface(tokenAddress);
277         
278         require(token.balanceOf(address(this)) >= amount);
279         token.transfer(user, amount);
280     }   
281     
282 	
283 // Function 06 - Delete Safe Values In Storage
284     
285     function DeleteSafe(Safe s) private {
286         
287         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
288         delete _safes[s.id];
289         
290         uint256[] storage vector = _userSafes[msg.sender];
291         uint256 size = vector.length; 
292         for(uint256 i = 0; i < size; i++) {
293             if(vector[i] == s.id) {
294                 vector[i] = vector[size-1];
295                 vector.length--;
296                 break;
297             }
298         } 
299     }
300 
301 	
302 // Function 07 - Get How Many Safes Has The User
303     
304     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
305         return _userSafes[hodler].length;
306     }
307     
308 	
309 // Function 08 - Get Safes Values
310     
311 	function GetSafe(uint256 _id) public view
312         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
313     {
314         Safe storage s = _safes[_id];
315         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
316     }
317 
318 // Function 09 - Get Contract's Balance
319     
320     function GetContractBalance() public view returns(uint256)
321     {
322         return address(this).balance;
323     }   	
324 
325 	
326 // Function 10 - Get Tokens Reserved For The Owner As Commission
327     
328     function GetTokenFees(address tokenAddress) private view returns (uint256 amount) {
329         return _systemReserves[tokenAddress];
330     }    
331     
332     
333 // * --- > Useless (Private)
334 // Function 11 - Store The Profile's Hash In The Blockchain
335     
336     function storeProfileHashed(string _profileHashed) private {
337         profileHashed[msg.sender] = _profileHashed;        
338 
339         emit onStoreProfileHash(msg.sender, _profileHashed);
340     }
341     	
342 		
343 // * --- > Useless (Private)	
344 // Function 12 - Get User's Any Token Balance
345 
346     function GetHodlTokensBalance(address tokenAddress) private view returns (uint256 balance) {
347         require(tokenAddress != 0x0);
348         
349         for(uint256 i = 1; i < _currentIndex; i++) {            
350             Safe storage s = _safes[i];
351             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
352                 balance += s.amount;
353         }
354         return balance;
355     }	
356 	
357 	
358 	
359 /////// ONLY CREATOR /////// 	
360 	
361 // Total Function = 10	
362 	
363 // 01 Retire Hodl Safe
364     
365     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
366         require(tokenAddress != 0x0);
367         require(id != 0);
368         
369         RetireHodl(tokenAddress, id);
370     }
371     
372 	
373 // 02 Change Hodling Time
374     
375     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
376         require(newHodlingDays >= 60);
377         
378         hodlingTime = newHodlingDays * 1 days;
379     }   
380     
381 // 03 Change All Time High Price
382     
383     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
384         require(newAllTimeHighPrice > allTimeHighPrice);
385         
386         allTimeHighPrice = newAllTimeHighPrice;
387     }              
388 
389 	
390 // 04 Change Comission Value
391     
392     function ChangeComission(uint256 newComission) onlyOwner public {
393         require(newComission <= 30);
394         
395         comission = newComission;
396     }
397     
398 // 05 Withdraw Token Fees By Address
399     
400     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
401         require(_systemReserves[tokenAddress] > 0);
402         
403         uint256 amount = _systemReserves[tokenAddress];
404         _systemReserves[tokenAddress] = 0;
405         
406         ERC20Interface token = ERC20Interface(tokenAddress);
407         
408         require(token.balanceOf(address(this)) >= amount);
409         token.transfer(msg.sender, amount);
410     }
411 
412 // 06 Withdraw All Eth And All Tokens Fees
413     
414     function WithdrawAllFees() onlyOwner public {
415         
416         // ether
417         uint256 x = _systemReserves[0x0];
418         if(x > 0 && x <= address(this).balance) {
419             _systemReserves[0x0] = 0;
420             msg.sender.transfer(_systemReserves[0x0]);
421         }
422         
423         // tokens
424         address ta;
425         ERC20Interface token;
426         for(uint256 i = 0; i < _listedReserves.length; i++) {
427             ta = _listedReserves[i];
428             if(_systemReserves[ta] > 0)
429             { 
430                 x = _systemReserves[ta];
431                 _systemReserves[ta] = 0;
432                 
433                 token = ERC20Interface(ta);
434                 token.transfer(msg.sender, x);
435             }
436         }
437         _listedReserves.length = 0; 
438     }
439     
440 
441 // 07 - Withdraw Ether Received Through Fallback Function
442     
443     function WithdrawEth(uint256 amount) onlyOwner public {
444         require(amount > 0); 
445         require(address(this).balance >= amount); 
446         
447         msg.sender.transfer(amount);
448     }
449 
450 // 08 - Returns All Tokens Addresses With Fees
451         
452     function GetTokensAddressesWithFees() 
453         onlyOwner public view 
454         returns (address[], string[], uint256[])
455     {
456         uint256 length = _listedReserves.length;
457         
458         address[] memory tokenAddress = new address[](length);
459         string[] memory tokenSymbol = new string[](length);
460         uint256[] memory tokenFees = new uint256[](length);
461         
462         for (uint256 i = 0; i < length; i++) {
463     
464             tokenAddress[i] = _listedReserves[i];
465             
466             ERC20Interface token = ERC20Interface(tokenAddress[i]);
467             
468             tokenSymbol[i] = token.symbol();
469             tokenFees[i] = GetTokenFees(tokenAddress[i]);
470         }
471         
472         return (tokenAddress, tokenSymbol, tokenFees);
473     }
474 
475 	
476 // 09 - Return All Tokens To Their Respective Addresses
477     
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
491                     DeleteSafe(s);
492                     
493                     _countSafes--;
494                     returned++;
495                 }
496             }
497         }
498 
499         emit onReturnAll(returned);
500     }    
501 	
502 // 10 - Speed Setting
503 
504     function SpeedUp() onlyOwner public {
505         speed = true;
506     }
507     
508     function SpeedDown() onlyOwner public {
509         speed = false;
510     }
511 
512 	
513 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~// 	
514 	
515 	
516 	
517 
518     /**
519     * SAFE MATH FUNCTIONS
520     * 
521     * @dev Multiplies two numbers, throws on overflow.
522     */
523     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
524         if (a == 0) {
525             return 0;
526         }
527         c = a * b;
528         assert(c / a == b);
529         return c;
530     }
531     
532     /**
533     * @dev Integer division of two numbers, truncating the quotient.
534     */
535     function div(uint256 a, uint256 b) internal pure returns (uint256) {
536         // assert(b > 0); // Solidity automatically throws when dividing by 0
537         // uint256 c = a / b;
538         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
539         return a / b;
540     }
541     
542     /**
543     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
544     */
545     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
546         assert(b <= a);
547         return a - b;
548     }
549     
550     /**
551     * @dev Adds two numbers, throws on overflow.
552     */
553     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
554         c = a + b;
555         assert(c >= a);
556         return c;
557     }
558     
559 }
560 
561 contract ERC20Interface {
562 
563     uint256 public totalSupply;
564     uint256 public decimals;
565     
566     function symbol() public view returns (string);
567     function balanceOf(address _owner) public view returns (uint256 balance);
568     function transfer(address _to, uint256 _value) public returns (bool success);
569     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
570     function approve(address _spender, uint256 _value) public returns (bool success);
571     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
572 
573     // solhint-disable-next-line no-simple-event-func-name  
574     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
575     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
576 }