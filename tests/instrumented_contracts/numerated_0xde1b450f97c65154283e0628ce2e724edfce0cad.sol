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
68 
69 	
70 	// Default Setting
71 	
72 	uint256 public hodlingTime;
73     uint256 public allTimeHighPrice;
74 	uint256 public percent 						= 300;        	// * Only test 300% Permonth
75 	uint256 private constant affiliate 			= 12;        	// * 12% from deposit
76 	uint256 private constant cashback 			= 16;        	// * 16% from deposit
77 	uint256 private constant totalreceive 		= 88;        	// * 88% from deposit	
78     uint256 private constant seconds30days 		= 2592000;  	// *
79 
80     struct Safe {
81         uint256 id;
82         uint256 amount;
83         uint256 endtime;
84         address user;
85         address tokenAddress;
86 		string tokenSymbol;	
87 		uint256 amountbalance; 							// * --- > 88% from deposit
88 		uint256 cashbackbalance; 						// * --- > 16% from deposit
89 		uint256 lasttime; 								// * --- > Now
90 		uint256 percentage; 							// * --- > return tokens every month
91 		uint256 percentagereceive; 						// * --- > 0 %
92 		uint256 tokenreceive; 							// * --- > 0 Token
93 		uint256 affiliatebalance; 						// **
94 		address referrer; 								// **
95 
96     }
97     
98     //Safes Variables
99   
100     mapping(address => uint256[]) 	public 	_userSafes;
101     mapping(uint256 => Safe) 		private _safes; 			// = Struct safe
102     uint256 						private _currentIndex; 		// Id Number
103     uint256 						public 	_countSafes; 		// Total User
104     mapping(address => uint256) 	public 	_totalSaved; 		// ERC20 Token Balance count
105     
106     //Dev Owner Variables
107 
108     uint256 					public comission;
109     mapping(address => uint256) private _systemReserves;    	// Token Balance Reserve
110     address[] 					public _listedReserves;
111     
112     //Constructor
113    
114     constructor() public {
115         
116         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;        
117         hodlingTime 	= 730 days;
118         _currentIndex 	= 500;
119         comission 		= 5;
120     }
121     
122 	
123 // Function 01 - Fallback Function To Receive Donation In Eth
124     function () public payable {
125         require(msg.value > 0);       
126         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
127     }
128 	
129 // Function 02 - Hodl ERC20 Token	
130     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
131         require(tokenAddress != 0x0);
132         require(amount > 0);
133 		
134         ERC20Interface token = ERC20Interface(tokenAddress);       
135         require(token.transferFrom(msg.sender, address(this), amount));
136 		
137 		    uint256 affiliatecomission = mul(amount, affiliate) / 100; // *			
138             uint256 data_amountbalance = sub(amount, affiliatecomission); // * 
139 			uint256 data_cashbackbalance = mul(amount, cashback) / 100; // *			 
140 			  		  				  					  
141 		// Insert to Database  			 	  
142 		_userSafes[msg.sender].push(_currentIndex);
143 		_safes[_currentIndex] = 
144 
145 		Safe(
146 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, 0xA15C7Ebe1f07CaF6bFF097D8a589fb8AC49Ae5B3);				
147 		
148 		// Update Token Balance, Current Index, CountSafes		
149         _totalSaved[tokenAddress] = add(_totalSaved[tokenAddress], amount);        
150         _currentIndex++;
151         _countSafes++;
152         
153         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
154     }
155 	
156 	
157 // Function 03 - Withdraw Token	
158     function ClaimTokens(address tokenAddress, uint256 id) public {
159         require(tokenAddress != 0x0);
160         require(id != 0);        
161         
162         Safe storage s = _safes[id];
163         require(s.user == msg.sender);
164         
165         RetireHodl(tokenAddress, id);
166     }
167     
168     function RetireHodl(address tokenAddress, uint256 id) private {
169 
170         Safe storage s = _safes[id];
171         
172         require(s.id != 0);
173         require(s.tokenAddress == tokenAddress);
174         require(
175                 (tokenAddress == AXPRtoken && s.endtime < now ) ||
176                     tokenAddress != AXPRtoken
177                 );
178 
179         uint256 eventAmount;
180         address eventTokenAddress = s.tokenAddress;
181         string memory eventTokenSymbol = s.tokenSymbol;
182 		
183 if(s.amountbalance == 0) { revert(); 		
184         
185         if(s.endtime < now) // Hodl Complete
186         {
187             PayToken(s.user, s.tokenAddress, s.amountbalance);
188             
189             eventAmount 				= s.amountbalance;
190 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
191 			
192 	    s.amountbalance = 0;
193 		
194         }
195         else 
196         {
197 			
198 			uint256 timeframe  			= now - s.lasttime;
199 			uint256 maxtimeframe 		= timeframe / seconds30days;
200 			
201 			if (maxtimeframe >= 3) { 	// Max 3 x 2592000 Seconds = 3 Month
202 			uint256 timeframeaccumulation = 3; 
203 			}
204 			else {
205 			timeframeaccumulation = maxtimeframe; 
206 			}
207 			
208 			uint256 calcwithdrawamount 	= s.amount * s.percentage / 100 * timeframeaccumulation ;  
209 
210 			if (calcwithdrawamount >= s.amountbalance) {
211 			uint256 withdrawamount = s.amountbalance; 
212 			}
213 			else {
214 			withdrawamount = calcwithdrawamount; 
215 			}
216 			
217 			uint256 newamountbalance 	= sub(s.amountbalance, withdrawamount);	 	
218             			
219 		s.amountbalance 				= newamountbalance;  
220 		s.lasttime 						= now;  
221 		
222 			uint256 tokenaffiliate 		= mul(s.amount, affiliate) / 100 ; 
223 			uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance;	  				
224 			uint256 percentagereceived 	= tokenreceived / s.amount * 100000000000000000000;	  
225 		
226 		s.tokenreceive 					= tokenreceived; 
227 		s.percentagereceive 			= percentagereceived; 	
228 		
229 	        PayToken(s.user, s.tokenAddress, withdrawamount); 
230 			
231             eventAmount = withdrawamount;
232 			_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], withdrawamount); 		
233 		}
234 		
235 }
236         
237         emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
238     }    
239       
240     function PayToken(address user, address tokenAddress, uint256 amount) private {
241         
242         ERC20Interface token = ERC20Interface(tokenAddress);
243         
244         require(token.balanceOf(address(this)) >= amount);
245         token.transfer(user, amount);
246     }   	
247 	
248 //??? Function 04 - Store Comission From Unfinished Hodl
249     function StoreComission(address tokenAddress, uint256 amount) private {
250             
251         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
252         
253         bool isNew = true;
254         for(uint256 i = 0; i < _listedReserves.length; i++) {
255             if(_listedReserves[i] == tokenAddress) {
256                 isNew = false;
257                 break;
258             }
259         }         
260         if(isNew) _listedReserves.push(tokenAddress); 
261     }    
262 	
263 //??? Function 05 - Delete Safe Values In Storage   
264     function DeleteSafe(Safe s) private {
265         
266         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
267         delete _safes[s.id];
268         
269         uint256[] storage vector = _userSafes[msg.sender];
270         uint256 size = vector.length; 
271         for(uint256 i = 0; i < size; i++) {
272             if(vector[i] == s.id) {
273                 vector[i] = vector[size-1];
274                 vector.length--;
275                 break;
276             }
277         } 
278     }
279 	
280 //??? Function 06 - Store The Profile's Hash In The Blockchain   
281     function storeProfileHashed(string _profileHashed) public {
282         profileHashed[msg.sender] = _profileHashed;        
283         emit onStoreProfileHash(msg.sender, _profileHashed);
284     }  	
285 
286 //??? Function 07 - Get User's Any Token Balance
287     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
288         require(tokenAddress != 0x0);
289         
290         for(uint256 i = 1; i < _currentIndex; i++) {            
291             Safe storage s = _safes[i];
292             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
293                 balance += s.amount;
294         }
295         return balance;
296     }
297 
298 // Function 08 - Get How Many Safes Has The User  
299     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
300         return _userSafes[hodler].length;
301     }
302     
303 // Function 09 - Get Safes Values
304 	function GetSafe(uint256 _id) public view
305         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
306     {
307         Safe storage s = _safes[_id];
308         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
309     }
310 	
311 // Function 10 - Get Tokens Reserved For The Owner As Commission 
312     function GetTokenFees(address tokenAddress) private view returns (uint256 amount) {
313         return _systemReserves[tokenAddress];
314     }    
315     
316 // Function 11 - Get Contract's Balance  
317     function GetContractBalance() public view returns(uint256)
318     {
319         return address(this).balance;
320     } 
321 
322 // Function 12 - Available For Withdrawal
323 	function AvailableForWithdrawal(uint256 _id) public view
324         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 amountbalance, uint256 lastwithdraw, uint256 availableforwithdrawal)
325     {
326         Safe storage s = _safes[_id];
327 		
328 			uint256 timeframe  			= now - s.lasttime;
329 			uint256 maxtimeframe 		= timeframe / seconds30days;
330 			
331 			if (maxtimeframe >= 3) { 	// Max 3 x 2592000 Seconds = 3 Month
332 			uint256 timeframeaccumulation = 3; 
333 			}
334 			else {
335 			timeframeaccumulation = maxtimeframe; 
336 			}
337 			
338 			uint256 calcwithdrawamount 	= s.amount * s.percentage / 100 * timeframeaccumulation ;  
339 
340 			if (calcwithdrawamount >= s.amountbalance) {
341 			uint256 withdrawamount = s.amountbalance; 
342 			}
343 			else {
344 			withdrawamount = calcwithdrawamount; 
345 			}
346 		
347         return(s.id, s.user, s.tokenAddress, s.amount, s.amountbalance, s.lasttime, withdrawamount);
348     }
349 	
350     
351 	
352 ////////////////////////////////// onlyOwner //////////////////////////////////
353 
354 	
355 // 01 Retire Hodl Safe   
356     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
357         require(tokenAddress != 0x0);
358         require(id != 0);      
359         RetireHodl(tokenAddress, id);
360     }
361     
362 // 02 Change Hodling Time   
363     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
364         require(newHodlingDays >= 60);      
365         hodlingTime = newHodlingDays * 1 days;
366     }   
367     
368 // 03 Change All Time High Price   
369     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
370         require(newAllTimeHighPrice > allTimeHighPrice);       
371         allTimeHighPrice = newAllTimeHighPrice;
372     }              
373 
374 // 04 Change Comission Value   
375     function ChangeComission(uint256 newComission) onlyOwner public {
376         require(newComission <= 30);       
377         comission = newComission;
378     }
379     
380 // 05 Withdraw Token Fees By Address   
381     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
382         require(_systemReserves[tokenAddress] > 0);
383         
384         uint256 amount = _systemReserves[tokenAddress];
385         _systemReserves[tokenAddress] = 0;
386         
387         ERC20Interface token = ERC20Interface(tokenAddress);
388         
389         require(token.balanceOf(address(this)) >= amount);
390         token.transfer(msg.sender, amount);
391     }
392 
393 // 06 Withdraw All Eth And All Tokens Fees   
394     function WithdrawAllFees() onlyOwner public {
395         
396         // Ether
397         uint256 x = _systemReserves[0x0];
398         if(x > 0 && x <= address(this).balance) {
399             _systemReserves[0x0] = 0;
400             msg.sender.transfer(_systemReserves[0x0]);
401         }
402         
403         // Tokens
404         address ta;
405         ERC20Interface token;
406         for(uint256 i = 0; i < _listedReserves.length; i++) {
407             ta = _listedReserves[i];
408             if(_systemReserves[ta] > 0)
409             { 
410                 x = _systemReserves[ta];
411                 _systemReserves[ta] = 0;
412                 
413                 token = ERC20Interface(ta);
414                 token.transfer(msg.sender, x);
415             }
416         }
417         _listedReserves.length = 0; 
418     }
419     
420 
421 // 07 - Withdraw Ether Received Through Fallback Function    
422     function WithdrawEth(uint256 amount) onlyOwner public {
423         require(amount > 0); 
424         require(address(this).balance >= amount); 
425         
426         msg.sender.transfer(amount);
427     }
428 
429 // 08 - Returns All Tokens Addresses With Fees       
430     function GetTokensAddressesWithFees() 
431         onlyOwner public view 
432         returns (address[], string[], uint256[])
433     {
434         uint256 length = _listedReserves.length;
435         
436         address[] memory tokenAddress = new address[](length);
437         string[] memory tokenSymbol = new string[](length);
438         uint256[] memory tokenFees = new uint256[](length);
439         
440         for (uint256 i = 0; i < length; i++) {
441     
442             tokenAddress[i] = _listedReserves[i];
443             
444             ERC20Interface token = ERC20Interface(tokenAddress[i]);
445             
446             tokenSymbol[i] = token.symbol();
447             tokenFees[i] = GetTokenFees(tokenAddress[i]);
448         }
449         
450         return (tokenAddress, tokenSymbol, tokenFees);
451     }
452 
453 	
454 // 09 - Return All Tokens To Their Respective Addresses    
455     function ReturnAllTokens(bool onlyAXPR) onlyOwner public
456     {
457         uint256 returned;
458 
459         for(uint256 i = 1; i < _currentIndex; i++) {            
460             Safe storage s = _safes[i];
461             if (s.id != 0) {
462                 if (
463                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
464                     !onlyAXPR
465                     )
466                 {
467                     PayToken(s.user, s.tokenAddress, s.amountbalance);
468                     DeleteSafe(s);
469                     
470                     _countSafes--;
471                     returned++;
472                 }
473             }
474         }
475 
476         emit onReturnAll(returned);
477     }    
478 
479 	
480 //////////////////////////////////////////////// 	
481 	
482 
483     /**
484     * SAFE MATH FUNCTIONS
485     * 
486     * @dev Multiplies two numbers, throws on overflow.
487     */
488     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
489         if (a == 0) {
490             return 0;
491         }
492         c = a * b;
493         assert(c / a == b);
494         return c;
495     }
496     
497     /**
498     * @dev Integer division of two numbers, truncating the quotient.
499     */
500     function div(uint256 a, uint256 b) internal pure returns (uint256) {
501         // assert(b > 0); // Solidity automatically throws when dividing by 0
502         // uint256 c = a / b;
503         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
504         return a / b;
505     }
506     
507     /**
508     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
509     */
510     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
511         assert(b <= a);
512         return a - b;
513     }
514     
515     /**
516     * @dev Adds two numbers, throws on overflow.
517     */
518     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
519         c = a + b;
520         assert(c >= a);
521         return c;
522     }
523     
524 }
525 
526 contract ERC20Interface {
527 
528     uint256 public totalSupply;
529     uint256 public decimals;
530     
531     function symbol() public view returns (string);
532     function balanceOf(address _owner) public view returns (uint256 balance);
533     function transfer(address _to, uint256 _value) public returns (bool success);
534     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
535     function approve(address _spender, uint256 _value) public returns (bool success);
536     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
537 
538     // solhint-disable-next-line no-simple-event-func-name  
539     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
540     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
541 }