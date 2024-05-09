1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 // Contract 01
5 
6 contract OwnableContract {    
7     event onTransferOwnership(address newOwner);
8 	address superOwner; 
9 	
10     constructor() public { 
11         superOwner = msg.sender;
12     }
13     modifier onlyOwner() {
14         require(msg.sender == superOwner);
15         _;
16     } 
17 	
18     function viewSuperOwner() public view returns (address owner) {
19         return superOwner;
20     }
21       
22     function changeOwner(address newOwner) onlyOwner public {
23         require(newOwner != superOwner);
24         
25         superOwner = newOwner;
26         
27         emit onTransferOwnership(superOwner);
28     }
29 }
30 
31 // Contract 02
32 
33 contract BlockableContract is OwnableContract {
34     
35     event onBlockHODLs(bool status);
36  
37     bool public blockedContract;
38     
39     constructor() public { 
40         blockedContract = false;  
41     }
42     
43     modifier contractActive() {
44         require(!blockedContract);
45         _;
46     } 
47     
48     function doBlockContract() onlyOwner public {
49         blockedContract = true;
50         
51         emit onBlockHODLs(blockedContract);
52     }
53     
54     function unBlockContract() onlyOwner public {
55         blockedContract = false;
56         
57         emit onBlockHODLs(blockedContract);
58     }
59 }
60 
61 // Contract 03
62 
63 contract ldoh is BlockableContract {
64     
65     event onStoreProfileHash(address indexed hodler, string profileHashed);
66     event onHodlTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
67     event onClaimTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
68     event onReturnAll(uint256 returned);
69 
70     // Variables //
71 	
72     address internal AXPRtoken;
73     mapping(address => string) public profileHashed; // User Prime 
74 
75 	// * = New ** = Undeveloped
76 	
77 	// Default Setting
78 	
79 	uint256 public hodlingTime;
80     uint256 public allTimeHighPrice;
81 	uint256 public percent = 300;        				// * Only test 300% Permonth
82 	uint256 private constant affiliate = 12;        	// * 12% from deposit
83 	uint256 private constant cashback = 16;        		// * 16% from deposit
84 	uint256 private constant totalreceive = 88;        	// * 88% from deposit	
85     uint256 private constant seconds30days = 2592000;  	// *
86 
87     struct Safe {
88         uint256 id;
89         uint256 amount;
90         uint256 endtime;
91         address user;
92         address tokenAddress;
93 		string tokenSymbol;	
94 		uint256 amountbalance; 			// * --- > 88% from deposit
95 		uint256 cashbackbalance; 		// * --- > 16% from deposit
96 		uint256 lasttime; 				// * --- > Now
97 		uint256 percentage; 			// * --- > return tokens every month
98 		uint256 percentagereceive; 		// * --- > 0 %
99 		uint256 tokenreceive; 			// * --- > 0 Token
100 		uint256 affiliatebalance; 		// **
101 		address referrer; 				// **
102 
103     }
104     
105     //safes variables
106   
107     mapping(address => uint256[]) 	public _userSafes;
108     mapping(uint256 => Safe) 		private _safes; 		// = Struct safe
109 	
110     uint256 private _currentIndex; 							// Id Number
111     uint256 public _countSafes; 							// Total User
112 	
113     mapping(address => uint256) public _totalSaved; 		// Token Balance count
114     
115     //dev owner variables
116 
117     uint256 public comission;
118     mapping(address => uint256) private _systemReserves;    // Token Balance Reserve
119     address[] public _listedReserves;
120     
121     //constructor
122    
123     constructor() public {
124         
125         AXPRtoken = 0xC39E626A04C5971D770e319760D7926502975e47;
126         
127         hodlingTime = 365 days;
128         _currentIndex = 1;
129         comission = 5;
130     }
131     
132 	
133 // Function 01 - fallback function to receive donation in eth
134     
135     function () public payable {
136         require(msg.value > 0);
137         
138         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
139     }
140 
141 	
142 	
143 // Function 02 - store the profile's hash in the blockchain
144     
145     function storeProfileHashed(string _profileHashed) public {
146         profileHashed[msg.sender] = _profileHashed;        
147 
148         emit onStoreProfileHash(msg.sender, _profileHashed);
149     }
150     
151 	
152 // Function 03 - Hodl Token
153 	
154     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
155         require(tokenAddress != 0x0);
156         require(amount > 0);
157 
158           
159         ERC20Interface token = ERC20Interface(tokenAddress);
160         
161         require(token.transferFrom(msg.sender, address(this), amount));
162 		
163 		    uint256 affiliatecomission = mul(amount, affiliate) / 100; // *			
164             uint256 data_amountbalance = sub(amount, affiliatecomission); // * 
165 			uint256 data_cashbackbalance = mul(amount, cashback) / 100; // *			 
166 			  		  
167 		// Insert to Database  
168 			 	  
169 		_userSafes[msg.sender].push(_currentIndex);
170 		_safes[_currentIndex] = 
171 
172 		Safe(
173 
174 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0,0xA15C7Ebe1f07CaF6bFF097D8a589fb8AC49Ae5B3);
175 				
176 		
177 		// Update Token Balance, Current Index, CountSafes
178 		
179         _totalSaved[tokenAddress] = add(_totalSaved[tokenAddress], amount);        
180         _currentIndex++;
181         _countSafes++;
182         
183         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
184     }
185 	
186 	
187 // Function 04 - Withdraw Token
188 	
189     function ClaimTokens(address tokenAddress, uint256 id) public {
190         require(tokenAddress != 0x0);
191         require(id != 0);        
192         
193         Safe storage s = _safes[id];
194         require(s.user == msg.sender);
195         
196         RetireHodl(tokenAddress, id);
197     }
198     
199     function RetireHodl(address tokenAddress, uint256 id) private {
200 
201         Safe storage s = _safes[id];
202         
203         require(s.id != 0);
204         require(s.tokenAddress == tokenAddress);
205         require(
206                 (tokenAddress == AXPRtoken && s.endtime < now ) ||
207                     tokenAddress != AXPRtoken
208                 );
209 
210         uint256 eventAmount;
211         address eventTokenAddress = s.tokenAddress;
212         string memory eventTokenSymbol = s.tokenSymbol;
213         
214         if(s.endtime < now) // hodl complete
215         {
216             PayToken(s.user, s.tokenAddress, s.amountbalance);
217             
218             eventAmount = s.amountbalance;
219 		   _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
220 			
221 	    DeleteSafe(s);
222         _countSafes--;
223 		
224         }
225         else // hodl still in progress (penalty fee applies), not for AXPR tokens
226         {
227 			
228 			uint256 timeframe  = now - s.lasttime;
229 			uint256 realAmount = s.amount * s.percentage / 100 * timeframe / seconds30days ;
230           				
231 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	 // *  	
232             			
233 		s.amountbalance = newamountbalance;  // *
234 		s.lasttime = now;  // *
235 
236 		
237 			uint256 tokenaffiliate = mul(s.amount, affiliate) / 100 ; // * 
238 			uint256 tokenreceived = s.amount - tokenaffiliate - newamountbalance;	  // * 				
239 			uint256 percentagereceived = tokenreceived / s.amount * 100;	  // *
240 		
241 		s.tokenreceive = tokenreceived; // *
242 		s.percentagereceive = percentagereceived; // *		
243 		_totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], realAmount); // *
244 		
245 		
246 	        PayToken(s.user, s.tokenAddress, realAmount);           
247             eventAmount = realAmount;
248 				
249 		}
250         
251         emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
252     }    
253     
254 	
255 // Function 05 - store comission from unfinished hodl
256 	
257     function StoreComission(address tokenAddress, uint256 amount) private {
258             
259         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
260         
261         bool isNew = true;
262         for(uint256 i = 0; i < _listedReserves.length; i++) {
263             if(_listedReserves[i] == tokenAddress) {
264                 isNew = false;
265                 break;
266             }
267         }         
268         if(isNew) _listedReserves.push(tokenAddress); 
269     }    
270     
271 	
272 	
273 // Function 06 - private pay token to address
274     
275     function PayToken(address user, address tokenAddress, uint256 amount) private {
276         
277         ERC20Interface token = ERC20Interface(tokenAddress);
278         
279         require(token.balanceOf(address(this)) >= amount);
280         token.transfer(user, amount);
281     }   
282     
283 	
284 // Function 07 - delete safe values in storage
285     
286     function DeleteSafe(Safe s) private {
287         
288         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
289         delete _safes[s.id];
290         
291         uint256[] storage vector = _userSafes[msg.sender];
292         uint256 size = vector.length; 
293         for(uint256 i = 0; i < size; i++) {
294             if(vector[i] == s.id) {
295                 vector[i] = vector[size-1];
296                 vector.length--;
297                 break;
298             }
299         } 
300     }
301 
302 	
303 // Function 08 - Get user's any token balance
304 
305     
306     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
307         require(tokenAddress != 0x0);
308         
309         for(uint256 i = 1; i < _currentIndex; i++) {            
310             Safe storage s = _safes[i];
311             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
312                 balance += s.amount;
313         }
314         return balance;
315     }
316 
317 // Function 09 - Get how many safes has the user
318     
319     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
320         return _userSafes[hodler].length;
321     }
322     
323 	
324 // Function 10 - Get safes values
325     
326 	function GetSafe(uint256 _id) public view
327         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokengereceive, address referrer)
328     {
329         Safe storage s = _safes[_id];
330         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
331     }
332 
333 	
334 // Function 11 - Get tokens reserved for the owner as commission
335     
336     function GetTokenFees(address tokenAddress) private view returns (uint256 amount) {
337         return _systemReserves[tokenAddress];
338     }    
339     
340 // Function 12 - Get contract's balance
341     
342     function GetContractBalance() public view returns(uint256)
343     {
344         return address(this).balance;
345     }    
346     
347 	
348 /////// ONLY CREATOR /////// 	
349 	
350 	
351 // 01 retire hodl safe
352     
353     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
354         require(tokenAddress != 0x0);
355         require(id != 0);
356         
357         RetireHodl(tokenAddress, id);
358     }
359     
360 	
361 // 02 change hodling time
362     
363     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
364         require(newHodlingDays >= 60);
365         
366         hodlingTime = newHodlingDays * 1 days;
367     }   
368     
369 // 03 Change all time high price
370     
371     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
372         require(newAllTimeHighPrice > allTimeHighPrice);
373         
374         allTimeHighPrice = newAllTimeHighPrice;
375     }              
376 
377 	
378 // 04 Change comission value
379     
380     function ChangeComission(uint256 newComission) onlyOwner public {
381         require(newComission <= 30);
382         
383         comission = newComission;
384     }
385     
386 // 05 Withdraw token fees by address
387     
388     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
389         require(_systemReserves[tokenAddress] > 0);
390         
391         uint256 amount = _systemReserves[tokenAddress];
392         _systemReserves[tokenAddress] = 0;
393         
394         ERC20Interface token = ERC20Interface(tokenAddress);
395         
396         require(token.balanceOf(address(this)) >= amount);
397         token.transfer(msg.sender, amount);
398     }
399 
400 // 06 Withdraw all eth and all tokens fees
401     
402     function WithdrawAllFees() onlyOwner public {
403         
404         // ether
405         uint256 x = _systemReserves[0x0];
406         if(x > 0 && x <= address(this).balance) {
407             _systemReserves[0x0] = 0;
408             msg.sender.transfer(_systemReserves[0x0]);
409         }
410         
411         // tokens
412         address ta;
413         ERC20Interface token;
414         for(uint256 i = 0; i < _listedReserves.length; i++) {
415             ta = _listedReserves[i];
416             if(_systemReserves[ta] > 0)
417             { 
418                 x = _systemReserves[ta];
419                 _systemReserves[ta] = 0;
420                 
421                 token = ERC20Interface(ta);
422                 token.transfer(msg.sender, x);
423             }
424         }
425         _listedReserves.length = 0; 
426     }
427     
428 
429 // 07 - Withdraw ether received through fallback function
430     
431     function WithdrawEth(uint256 amount) onlyOwner public {
432         require(amount > 0); 
433         require(address(this).balance >= amount); 
434         
435         msg.sender.transfer(amount);
436     }
437 
438 // 08 - Returns all tokens addresses with fees
439         
440     function GetTokensAddressesWithFees() 
441         onlyOwner public view 
442         returns (address[], string[], uint256[])
443     {
444         uint256 length = _listedReserves.length;
445         
446         address[] memory tokenAddress = new address[](length);
447         string[] memory tokenSymbol = new string[](length);
448         uint256[] memory tokenFees = new uint256[](length);
449         
450         for (uint256 i = 0; i < length; i++) {
451     
452             tokenAddress[i] = _listedReserves[i];
453             
454             ERC20Interface token = ERC20Interface(tokenAddress[i]);
455             
456             tokenSymbol[i] = token.symbol();
457             tokenFees[i] = GetTokenFees(tokenAddress[i]);
458         }
459         
460         return (tokenAddress, tokenSymbol, tokenFees);
461     }
462 
463 	
464 // 09 - Return all tokens to their respective addresses
465     
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
478                     PayToken(s.user, s.tokenAddress, s.amount);
479                     DeleteSafe(s);
480                     
481                     _countSafes--;
482                     returned++;
483                 }
484             }
485         }
486 
487         emit onReturnAll(returned);
488     }    
489 
490 	
491 	
492 ////////////////// ~~~~~~~~~~~~~~~ ////////////////// 	
493 	
494 	
495 	
496 
497     /**
498     * SAFE MATH FUNCTIONS
499     * 
500     * @dev Multiplies two numbers, throws on overflow.
501     */
502     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
503         if (a == 0) {
504             return 0;
505         }
506         c = a * b;
507         assert(c / a == b);
508         return c;
509     }
510     
511     /**
512     * @dev Integer division of two numbers, truncating the quotient.
513     */
514     function div(uint256 a, uint256 b) internal pure returns (uint256) {
515         // assert(b > 0); // Solidity automatically throws when dividing by 0
516         // uint256 c = a / b;
517         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
518         return a / b;
519     }
520     
521     /**
522     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
523     */
524     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
525         assert(b <= a);
526         return a - b;
527     }
528     
529     /**
530     * @dev Adds two numbers, throws on overflow.
531     */
532     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
533         c = a + b;
534         assert(c >= a);
535         return c;
536     }
537     
538 }
539 
540 contract ERC20Interface {
541 
542     uint256 public totalSupply;
543     uint256 public decimals;
544     
545     function symbol() public view returns (string);
546     function balanceOf(address _owner) public view returns (uint256 balance);
547     function transfer(address _to, uint256 _value) public returns (bool success);
548     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
549     function approve(address _spender, uint256 _value) public returns (bool success);
550     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
551 
552     // solhint-disable-next-line no-simple-event-func-name  
553     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
554     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
555 }