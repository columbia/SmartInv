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
73     mapping(address => string) public profileHashed; 	// User Prime 
74 
75 	// * = New ** = Undeveloped
76 	
77 	// Default Setting
78 	
79 	uint256 public  hodlingTime;
80 	uint256 public 	comission;
81     uint256 public  allTimeHighPrice;
82 	uint256 public  percent 				= 300;        	// * Only test 300% Permonth
83 	uint256 private constant affiliate 		= 12;        	// * 12% from deposit
84 	uint256 private constant cashback 		= 16;        	// * 16% from deposit
85 	uint256 private constant totalreceive 	= 88;        	// * 88% from deposit	
86     uint256 private constant seconds30days 	= 2592000;  	// *
87 	
88 	uint256 private constant less_speed = 3;        // 3%
89 	uint256 private constant more_speed = 6;        // 6%
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
112     mapping(address => uint256[]) 	private _userSafes; 		// * --- > Useless (Private)
113     mapping(uint256 => Safe) 		private _safes; 			// Struct safe
114     uint256 						private _currentIndex; 		// Id Number
115     uint256 						public 	_countSafes; 	    // Total All User	
116     mapping(address => uint256) 	public 	_totalSaved; 		// Token Balance 
117 	
118 	mapping(address => uint256) 	public 	ratio; 		// Create ratio
119 	
120     
121     //dev owner variables
122     mapping(address => uint256) 	private _systemReserves;    // Token Balance Reserve
123     address[] 						public 	_listedReserves;
124     
125     //constructor
126    
127     constructor() public {
128         
129         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;
130         
131         hodlingTime 	= 365 days;
132         _currentIndex 	= 1;
133         comission 		= 5;
134     }
135     
136 	
137 // Total Function = 12	
138 	
139 // Function 01 - Fallback Function To Receive Donation In Eth
140     
141     function () public payable {
142         require(msg.value > 0);
143         
144         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
145     }
146 
147 
148 // Function 02 - Hodl Token
149 	
150     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
151         require(tokenAddress != 0x0);
152         require(amount > 0);
153 
154           
155         ERC20Interface token = ERC20Interface(tokenAddress);
156         
157         require(token.transferFrom(msg.sender, address(this), amount));
158 		
159 		    uint256 affiliatecomission 		= mul(amount, affiliate) / 100; 	// *			
160             uint256 data_amountbalance 		= sub(amount, affiliatecomission); 	// * 
161 			uint256 data_cashbackbalance 	= mul(amount, cashback) / 100; 		// *			 
162 			  		  
163 		// Insert to Database  
164 			 	  
165 		_userSafes[msg.sender].push(_currentIndex);
166 		_safes[_currentIndex] = 
167 
168 		Safe(
169 
170 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, 0, 0xA15C7Ebe1f07CaF6bFF097D8a589fb8AC49Ae5B3);
171 				
172 		
173 		// Update Token Balance, Current Index, CountSafes
174 		
175         _totalSaved[tokenAddress] = add(_totalSaved[tokenAddress], amount);        
176         _currentIndex++;
177         _countSafes++;
178         
179         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
180     }
181 	
182 	
183 // Function 03 - Withdraw Token
184 	
185     function ClaimTokens(address tokenAddress, uint256 id) public {
186         require(tokenAddress != 0x0);
187         require(id != 0);        
188         
189         Safe storage s = _safes[id];
190         require(s.user == msg.sender);
191         
192         RetireHodl(tokenAddress, id);
193     }
194     
195     function RetireHodl(address tokenAddress, uint256 id) private {
196 
197         Safe storage s = _safes[id];
198         
199         require(s.id != 0);
200         require(s.tokenAddress == tokenAddress);
201         require(
202                 (tokenAddress == AXPRtoken && s.endtime < now ) ||
203                     tokenAddress != AXPRtoken
204                 );
205 
206 
207         
208         if(s.endtime < now) // Hodl Complete
209         {
210             PayToken(s.user, s.tokenAddress, s.amountbalance);
211             _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
212 			
213 		s.amountbalance = 0;
214 		
215         }
216         else // Hodl Still In Progress (Penalty Fee Applies), Not For ABCD Tokens
217         {			
218 			
219 		// Set Default % Permonth	
220 			
221 		uint256 current_perc =	s.percentage;	
222 		ERC20Interface token = ERC20Interface(s.tokenAddress);    
223 		
224 		uint256 Current_ratio = ratio[s.tokenAddress];  
225 
226 		// Step 1		
227 		if (Current_ratio < 100) { uint256 final_ratio = 2000000000000000000000000000;} else { final_ratio = Current_ratio;}
228 		// Step 2					
229 		if 	(token.balanceOf(address(this)) >= final_ratio) { current_perc = more_speed;} else { current_perc = less_speed;}
230 		// Step 3			
231 		if (current_perc >= s.percentage) { uint256 final_perc = current_perc;} else { final_perc = s.percentage;}		
232 
233 
234 			uint256 timeframe  = now - s.lasttime;												// *
235 			uint256 realAmount = s.amount * final_perc / 100 * timeframe / seconds30days ; 		// *         				
236 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	 					// *  	
237             			
238 		s.amountbalance = newamountbalance;  // *
239 		s.lasttime = now;  // *
240 
241 			uint256 tokenaffiliate 		= mul(s.amount, affiliate) / 100 ; 					// * 
242 			uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance;	  	// * 				
243 			uint256 percentagereceived 	= tokenreceived / s.amount * 100 * 1000000000000000000;	  				// *
244 		
245 		s.tokenreceive 				= tokenreceived; 										// *
246 		s.percentagereceive 		= percentagereceived; 									// *		
247 		_totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], realAmount); 		// *
248 			
249 	        PayToken(s.user, s.tokenAddress, realAmount);           
250 
251 				
252 		}
253         
254    
255     }    
256     
257 	
258 // Function 04 - Store Comission From Unfinished Hodl
259 	
260     function StoreComission(address tokenAddress, uint256 amount) private {
261             
262         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
263         
264         bool isNew = true;
265         for(uint256 i = 0; i < _listedReserves.length; i++) {
266             if(_listedReserves[i] == tokenAddress) {
267                 isNew = false;
268                 break;
269             }
270         }         
271         if(isNew) _listedReserves.push(tokenAddress); 
272     }    
273     
274 	
275 	
276 // Function 05 - Private Pay Token To Address
277     
278     function PayToken(address user, address tokenAddress, uint256 amount) private {
279         
280         ERC20Interface token = ERC20Interface(tokenAddress);
281         
282         require(token.balanceOf(address(this)) >= amount);
283         token.transfer(user, amount);
284     }   
285     
286 	
287 // Function 06 - Delete Safe Values In Storage
288     
289     function DeleteSafe(Safe s) private {
290         
291         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
292         delete _safes[s.id];
293         
294         uint256[] storage vector = _userSafes[msg.sender];
295         uint256 size = vector.length; 
296         for(uint256 i = 0; i < size; i++) {
297             if(vector[i] == s.id) {
298                 vector[i] = vector[size-1];
299                 vector.length--;
300                 break;
301             }
302         } 
303     }
304 
305 	
306 // Function 07 - Get How Many Safes Has The User
307     
308     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
309         return _userSafes[hodler].length;
310     }
311     
312 	
313 // Function 08 - Get Safes Values
314     
315 	function GetSafe(uint256 _id) public view
316         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
317     {
318         Safe storage s = _safes[_id];
319         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
320     }
321 
322 // Function 09 - Get Contract's Balance
323     
324     function GetContractBalance() public view returns(uint256)
325     {
326         return address(this).balance;
327     }   	
328 
329 	
330 // Function 10 - Get Tokens Reserved For The Owner As Commission
331     
332     function GetTokenFees(address tokenAddress) private view returns (uint256 amount) {
333         return _systemReserves[tokenAddress];
334     }    
335     
336     
337 // * --- > Useless (Private)
338 // Function 11 - Store The Profile's Hash In The Blockchain
339     
340     function storeProfileHashed(string _profileHashed) private {
341         profileHashed[msg.sender] = _profileHashed;        
342 
343         emit onStoreProfileHash(msg.sender, _profileHashed);
344     }
345     	
346 		
347 // * --- > Useless (Private)	
348 // Function 12 - Get User's Any Token Balance
349 
350     function GetHodlTokensBalance(address tokenAddress) private view returns (uint256 balance) {
351         require(tokenAddress != 0x0);
352         
353         for(uint256 i = 1; i < _currentIndex; i++) {            
354             Safe storage s = _safes[i];
355             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
356                 balance += s.amount;
357         }
358         return balance;
359     }	
360 	
361 	
362 	
363 /////// ONLY CREATOR /////// 	
364 	
365 // Total Function = 10	
366 	
367 // 01 Retire Hodl Safe
368     
369     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
370         require(tokenAddress != 0x0);
371         require(id != 0);
372         
373         RetireHodl(tokenAddress, id);
374     }
375     
376 	
377 // 02 Change Hodling Time
378     
379     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
380         require(newHodlingDays >= 60);
381         
382         hodlingTime = newHodlingDays * 1 days;
383     }   
384     
385 // 03 Change All Time High Price
386     
387     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
388         require(newAllTimeHighPrice > allTimeHighPrice);
389         
390         allTimeHighPrice = newAllTimeHighPrice;
391     }              
392 
393 	
394 // 04 Change Comission Value
395     
396     function ChangeComission(uint256 newComission) onlyOwner public {
397         require(newComission <= 30);
398         
399         comission = newComission;
400     }
401     
402 // 05 Withdraw Token Fees By Address
403     
404     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
405         require(_systemReserves[tokenAddress] > 0);
406         
407         uint256 amount = _systemReserves[tokenAddress];
408         _systemReserves[tokenAddress] = 0;
409         
410         ERC20Interface token = ERC20Interface(tokenAddress);
411         
412         require(token.balanceOf(address(this)) >= amount);
413         token.transfer(msg.sender, amount);
414     }
415 
416 // 06 Withdraw All Eth And All Tokens Fees
417     
418     function WithdrawAllFees() onlyOwner public {
419         
420         // ether
421         uint256 x = _systemReserves[0x0];
422         if(x > 0 && x <= address(this).balance) {
423             _systemReserves[0x0] = 0;
424             msg.sender.transfer(_systemReserves[0x0]);
425         }
426         
427         // tokens
428         address ta;
429         ERC20Interface token;
430         for(uint256 i = 0; i < _listedReserves.length; i++) {
431             ta = _listedReserves[i];
432             if(_systemReserves[ta] > 0)
433             { 
434                 x = _systemReserves[ta];
435                 _systemReserves[ta] = 0;
436                 
437                 token = ERC20Interface(ta);
438                 token.transfer(msg.sender, x);
439             }
440         }
441         _listedReserves.length = 0; 
442     }
443     
444 
445 // 07 - Withdraw Ether Received Through Fallback Function
446     
447     function WithdrawEth(uint256 amount) onlyOwner public {
448         require(amount > 0); 
449         require(address(this).balance >= amount); 
450         
451         msg.sender.transfer(amount);
452     }
453 
454 // 08 - Returns All Tokens Addresses With Fees
455         
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
481     
482     function ReturnAllTokens(bool onlyAXPR) onlyOwner public
483     {
484         uint256 returned;
485 
486         for(uint256 i = 1; i < _currentIndex; i++) {            
487             Safe storage s = _safes[i];
488             if (s.id != 0) {
489                 if (
490                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
491                     !onlyAXPR
492                     )
493                 {
494                     PayToken(s.user, s.tokenAddress, s.amountbalance);
495                     DeleteSafe(s);
496                     
497                     _countSafes--;
498                     returned++;
499                 }
500             }
501         }
502 
503         emit onReturnAll(returned);
504     }    
505 	
506 // 10 - Create Ratio & Update
507      
508     function CreateRatio(address tokenaddress, uint256 _ratio) onlyOwner public {
509         ratio[tokenaddress] = _ratio;        
510 
511     }	
512 
513 	
514 ////////////////// ~~~~~~~~~~~~~~~ ////////////////// 	
515 	
516 	
517 	
518 
519     /**
520     * SAFE MATH FUNCTIONS
521     * 
522     * @dev Multiplies two numbers, throws on overflow.
523     */
524     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
525         if (a == 0) {
526             return 0;
527         }
528         c = a * b;
529         assert(c / a == b);
530         return c;
531     }
532     
533     /**
534     * @dev Integer division of two numbers, truncating the quotient.
535     */
536     function div(uint256 a, uint256 b) internal pure returns (uint256) {
537         // assert(b > 0); // Solidity automatically throws when dividing by 0
538         // uint256 c = a / b;
539         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
540         return a / b;
541     }
542     
543     /**
544     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
545     */
546     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
547         assert(b <= a);
548         return a - b;
549     }
550     
551     /**
552     * @dev Adds two numbers, throws on overflow.
553     */
554     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
555         c = a + b;
556         assert(c >= a);
557         return c;
558     }
559     
560 }
561 
562 contract ERC20Interface {
563 
564     uint256 public totalSupply;
565     uint256 public decimals;
566     
567     function symbol() public view returns (string);
568     function balanceOf(address _owner) public view returns (uint256 balance);
569     function transfer(address _to, uint256 _value) public returns (bool success);
570     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
571     function approve(address _spender, uint256 _value) public returns (bool success);
572     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
573 
574     // solhint-disable-next-line no-simple-event-func-name  
575     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
576     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
577 }