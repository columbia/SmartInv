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
18     function viewSuperOwner() private view returns (address owner) {
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
73     mapping(address => string) private profileHashed; 	// User Prime 
74 
75 	// * = New ** = Undeveloped
76 	
77 	// Default Setting
78 	
79 	uint256 public  hodlingTime;
80 	uint256 public 	comission;
81     uint256 public  allTimeHighPrice;
82 	uint256 public  percent 				= 3;        	// * 3% from deposit
83 	uint256 private constant affiliate 		= 12;        	// * 12% from deposit
84 	uint256 private constant cashback 		= 16;        	// * 16% from deposit
85 	uint256 private constant totalreceive 	= 88;        	// * 88% from deposit	
86     uint256 private constant seconds30days 	= 2592000;  	// *
87 	
88 	bool public speed;
89 
90     struct Safe {
91         uint256 id;
92         uint256 amount;
93         uint256 endtime;
94         address user;
95         address tokenAddress;
96 		string tokenSymbol;	
97 		uint256 amountbalance; 			// * --- > 88% from deposit
98 		uint256 cashbackbalance; 		// * --- > 16% from deposit
99 		uint256 lasttime; 				// * --- > Now
100 		uint256 percentage; 			// * --- > return tokens every month
101 		uint256 percentagereceive; 		// * --- > 0 %
102 		uint256 tokenreceive; 			// * --- > 0 Token
103 		uint256 affiliateprofit; 		// **
104 		uint256 affiliatebalance; 		// **
105 		address referrer; 				// **
106 
107     }
108     
109     //safes variables
110   
111     mapping(address => uint256[]) 	private _userSafes; 		// * --- > Useless (Private)
112     mapping(uint256 => Safe) 		private _safes; 			// Struct safe
113     uint256 						private _currentIndex; 		// Id Number
114     uint256 						public 	_countSafes; 	    // Total All User	
115     mapping(address => uint256) 	public 	_totalSaved; 		// Token Balance 
116 	
117     //dev owner variables
118     mapping(address => uint256) 	private _systemReserves;    // Token Balance Reserve
119     address[] 						public 	_listedReserves;
120     
121     //constructor
122    
123     constructor() public {
124         
125         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;
126         
127         hodlingTime 	= 365 days;
128         _currentIndex 	= 1;
129         comission 		= 5;
130     }
131     
132 	
133 // Total Function = 12	
134 	
135 // Function 01 - Fallback Function To Receive Donation In Eth
136     
137     function () public payable {
138         require(msg.value > 0);
139         
140         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
141     }
142 
143 
144 // Function 02 - Hodl Token
145 	
146     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
147         require(tokenAddress != 0x0);
148         require(amount > 0);
149 
150           
151         ERC20Interface token = ERC20Interface(tokenAddress);
152         
153         require(token.transferFrom(msg.sender, address(this), amount));
154 		
155 		    uint256 affiliatecomission 		= mul(amount, affiliate) / 100; 	// *			
156             uint256 data_amountbalance 		= sub(amount, affiliatecomission); 	// * 
157 			uint256 data_cashbackbalance 	= mul(amount, cashback) / 100; 		// *			 
158 			  		  
159 		// Insert to Database  
160 			 	  
161 		_userSafes[msg.sender].push(_currentIndex);
162 		_safes[_currentIndex] = 
163 
164 		Safe(
165 
166 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, 0, 0xA15C7Ebe1f07CaF6bFF097D8a589fb8AC49Ae5B3);
167 				
168 		
169 		// Update Token Balance, Current Index, CountSafes
170 		
171         _totalSaved[tokenAddress] = add(_totalSaved[tokenAddress], amount);        
172         _currentIndex++;
173         _countSafes++;
174         
175         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
176     }
177 	
178 	
179 // Function 03 - Withdraw Token
180 	
181     function ClaimTokens(address tokenAddress, uint256 id) public {
182         require(tokenAddress != 0x0);
183         require(id != 0);        
184         
185         Safe storage s = _safes[id];
186         require(s.user == msg.sender);
187         
188         RetireHodl(tokenAddress, id);
189     }
190     
191     function RetireHodl(address tokenAddress, uint256 id) private {
192 
193         Safe storage s = _safes[id];
194         
195         require(s.id != 0);
196         require(s.tokenAddress == tokenAddress);
197         require(
198                 (tokenAddress == AXPRtoken && s.endtime < now ) ||
199                     tokenAddress != AXPRtoken
200                 );
201 
202         uint256 eventAmount;
203         address eventTokenAddress = s.tokenAddress;
204         string memory eventTokenSymbol = s.tokenSymbol;
205         
206         if(s.endtime < now) // hodl complete
207         {
208             PayToken(s.user, s.tokenAddress, s.amountbalance);
209             
210             eventAmount = s.amountbalance;
211 		   _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
212 			
213 	    s.amountbalance = 0;
214 		
215         }
216         else // hodl still in progress (penalty fee applies), not for ABCD tokens
217         {
218 			
219 				if (speed == true) {
220 				uint256 final_speed = 6;
221 				}
222 				else {
223 				final_speed = 3;
224 				}
225 			
226 			uint256 timeframe  = now - s.lasttime;
227 			uint256 realAmount = s.amount * final_speed / 100 * timeframe / seconds30days ;
228           				
229 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	 // *  	
230             			
231 		s.amountbalance = newamountbalance;  // *
232 		s.lasttime = now;  // *
233 
234 		
235 			uint256 tokenaffiliate = mul(s.amount, affiliate) / 100 ; // * 
236 			uint256 tokenreceived = s.amount - tokenaffiliate - newamountbalance;	  // * 				
237 			uint256 percentagereceived = tokenreceived / s.amount * 100;	  // *
238 		
239 		s.tokenreceive = tokenreceived; // *
240 		s.percentagereceive = percentagereceived; // *		
241 		_totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], realAmount); // *
242 		
243 		
244 	        PayToken(s.user, s.tokenAddress, realAmount);           
245             eventAmount = realAmount;
246 				
247 		}
248         
249         emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
250     }    
251     
252 	
253 // Function 04 - Store Comission From Unfinished Hodl
254 	
255     function StoreComission(address tokenAddress, uint256 amount) private {
256             
257         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
258         
259         bool isNew = true;
260         for(uint256 i = 0; i < _listedReserves.length; i++) {
261             if(_listedReserves[i] == tokenAddress) {
262                 isNew = false;
263                 break;
264             }
265         }         
266         if(isNew) _listedReserves.push(tokenAddress); 
267     }    
268     
269 	
270 	
271 // Function 05 - Private Pay Token To Address
272     
273     function PayToken(address user, address tokenAddress, uint256 amount) private {
274         
275         ERC20Interface token = ERC20Interface(tokenAddress);
276         
277         require(token.balanceOf(address(this)) >= amount);
278         token.transfer(user, amount);
279     }   
280     
281 	
282 // Function 06 - Delete Safe Values In Storage
283     
284     function DeleteSafe(Safe s) private {
285         
286         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
287         delete _safes[s.id];
288         
289         uint256[] storage vector = _userSafes[msg.sender];
290         uint256 size = vector.length; 
291         for(uint256 i = 0; i < size; i++) {
292             if(vector[i] == s.id) {
293                 vector[i] = vector[size-1];
294                 vector.length--;
295                 break;
296             }
297         } 
298     }
299 
300 	
301 // Function 07 - Get How Many Safes Has The User
302     
303     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
304         return _userSafes[hodler].length;
305     }
306     
307 	
308 // Function 08 - Get Safes Values
309     
310 	function GetSafe(uint256 _id) public view
311         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
312     {
313         Safe storage s = _safes[_id];
314         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
315     }
316 
317 // Function 09 - Get Contract's Balance
318     
319     function GetContractBalance() public view returns(uint256)
320     {
321         return address(this).balance;
322     }   	
323 
324 	
325 // Function 10 - Get Tokens Reserved For The Owner As Commission
326     
327     function GetTokenFees(address tokenAddress) private view returns (uint256 amount) {
328         return _systemReserves[tokenAddress];
329     }    
330     
331     
332 // * --- > Useless (Private)
333 // Function 11 - Store The Profile's Hash In The Blockchain
334     
335     function storeProfileHashed(string _profileHashed) private {
336         profileHashed[msg.sender] = _profileHashed;        
337 
338         emit onStoreProfileHash(msg.sender, _profileHashed);
339     }
340     	
341 		
342 // * --- > Useless (Private)	
343 // Function 12 - Get User's Any Token Balance
344 
345     function GetHodlTokensBalance(address tokenAddress) private view returns (uint256 balance) {
346         require(tokenAddress != 0x0);
347         
348         for(uint256 i = 1; i < _currentIndex; i++) {            
349             Safe storage s = _safes[i];
350             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
351                 balance += s.amount;
352         }
353         return balance;
354     }	
355 	
356 	
357 	
358 /////// ONLY CREATOR /////// 	
359 	
360 // Total Function = 10	
361 	
362 // 01 Retire Hodl Safe
363     
364     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
365         require(tokenAddress != 0x0);
366         require(id != 0);
367         
368         RetireHodl(tokenAddress, id);
369     }
370     
371 	
372 // 02 Change Hodling Time
373     
374     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
375         require(newHodlingDays >= 60);
376         
377         hodlingTime = newHodlingDays * 1 days;
378     }   
379     
380 // 03 Change All Time High Price
381     
382     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
383         require(newAllTimeHighPrice > allTimeHighPrice);
384         
385         allTimeHighPrice = newAllTimeHighPrice;
386     }              
387 
388 	
389 // 04 Change Comission Value
390     
391     function ChangeComission(uint256 newComission) onlyOwner public {
392         require(newComission <= 30);
393         
394         comission = newComission;
395     }
396     
397 // 05 Withdraw Token Fees By Address
398     
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
411 // 06 Withdraw All Eth And All Tokens Fees
412     
413     function WithdrawAllFees() onlyOwner public {
414         
415         // ether
416         uint256 x = _systemReserves[0x0];
417         if(x > 0 && x <= address(this).balance) {
418             _systemReserves[0x0] = 0;
419             msg.sender.transfer(_systemReserves[0x0]);
420         }
421         
422         // tokens
423         address ta;
424         ERC20Interface token;
425         for(uint256 i = 0; i < _listedReserves.length; i++) {
426             ta = _listedReserves[i];
427             if(_systemReserves[ta] > 0)
428             { 
429                 x = _systemReserves[ta];
430                 _systemReserves[ta] = 0;
431                 
432                 token = ERC20Interface(ta);
433                 token.transfer(msg.sender, x);
434             }
435         }
436         _listedReserves.length = 0; 
437     }
438     
439 
440 // 07 - Withdraw Ether Received Through Fallback Function
441     
442     function WithdrawEth(uint256 amount) onlyOwner public {
443         require(amount > 0); 
444         require(address(this).balance >= amount); 
445         
446         msg.sender.transfer(amount);
447     }
448 
449 // 08 - Returns All Tokens Addresses With Fees
450         
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
476     
477     function ReturnAllTokens(bool onlyAXPR) onlyOwner public
478     {
479         uint256 returned;
480 
481         for(uint256 i = 1; i < _currentIndex; i++) {            
482             Safe storage s = _safes[i];
483             if (s.id != 0) {
484                 if (
485                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
486                     !onlyAXPR
487                     )
488                 {
489                     PayToken(s.user, s.tokenAddress, s.amountbalance);
490                     DeleteSafe(s);
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
501 // 10 - Speed Setting
502 
503     function SpeedUp() onlyOwner public {
504         speed = true;
505     }
506     
507     function SpeedDown() onlyOwner public {
508         speed = false;
509     }
510 
511 	
512 ////////////////// ~~~~~~~~~~~~~~~ ////////////////// 	
513 	
514 	
515 	
516 
517     /**
518     * SAFE MATH FUNCTIONS
519     * 
520     * @dev Multiplies two numbers, throws on overflow.
521     */
522     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
523         if (a == 0) {
524             return 0;
525         }
526         c = a * b;
527         assert(c / a == b);
528         return c;
529     }
530     
531     /**
532     * @dev Integer division of two numbers, truncating the quotient.
533     */
534     function div(uint256 a, uint256 b) internal pure returns (uint256) {
535         // assert(b > 0); // Solidity automatically throws when dividing by 0
536         // uint256 c = a / b;
537         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
538         return a / b;
539     }
540     
541     /**
542     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
543     */
544     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
545         assert(b <= a);
546         return a - b;
547     }
548     
549     /**
550     * @dev Adds two numbers, throws on overflow.
551     */
552     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
553         c = a + b;
554         assert(c >= a);
555         return c;
556     }
557     
558 }
559 
560 contract ERC20Interface {
561 
562     uint256 public totalSupply;
563     uint256 public decimals;
564     
565     function symbol() public view returns (string);
566     function balanceOf(address _owner) public view returns (uint256 balance);
567     function transfer(address _to, uint256 _value) public returns (bool success);
568     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
569     function approve(address _spender, uint256 _value) public returns (bool success);
570     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
571 
572     // solhint-disable-next-line no-simple-event-func-name  
573     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
574     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
575 }