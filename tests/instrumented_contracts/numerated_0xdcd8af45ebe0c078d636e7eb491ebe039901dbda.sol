1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 ////// Version 3.1 ////// 
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
64     address internal AXPRtoken;
65     mapping(address => string) public profileHashed; 			// User Prime 
66 	
67 	// Default Setting
68 	uint256 public 	percent 				= 1200;        	// * Percent Permonth ( Only Test = 1200% )
69 	uint256 private constant affiliate 		= 12;        	// * 12% from deposit
70 	uint256 private constant cashback 		= 16;        	// * 16% from deposit
71 	uint256 private constant totalreceive 	= 88;        	// * 88% from deposit	
72     uint256 private constant seconds30days 	= 2592000;  	// *
73 
74     struct Safe {
75         uint256 id;
76         uint256 amount;
77         uint256 endtime;
78         address user;
79         address tokenAddress;
80 		string  tokenSymbol;	
81 		uint256 amountbalance; 			// * --- > 88% from deposit
82 		uint256 cashbackbalance; 		// * --- > 16% from deposit
83 		uint256 lasttime; 				// * --- > Last Withdraw
84 		uint256 percentage; 			// * --- > return tokens every month
85 		uint256 percentagereceive; 		// * --- > 0 %
86 		uint256 tokenreceive; 			// * --- > 0 Token
87 		uint256 affiliatebalance; 		// **
88 		address referrer; 				// **
89 
90     }
91     
92 	mapping(address => uint256[]) 	public 	_userSafes;			// ?????
93     mapping(address => uint256) 	public 	_totalSaved; 		// Token Balance
94 	mapping(uint256 => Safe) 		private _safes; 			// Struct safe database
95     uint256 						private _currentIndex; 		// Sequential number ( Start from 500 )
96 	uint256 						public _countSafes; 		// Total Smart Contract User
97 	uint256 						public hodlingTime;			
98     uint256 						public allTimeHighPrice;
99     uint256 						public comission;
100 	
101     mapping(address => uint256) 	private _systemReserves;    // Token Balance ( Reserve )
102     address[] 						public _listedReserves;		// ?????
103     
104     //Constructor
105    
106     constructor() public {
107         
108         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;        
109         hodlingTime 	= 730 days;
110         _currentIndex 	= 500;
111         comission 		= 12;
112     }
113     
114 	
115 // Function 01 - Fallback Function To Receive Donation In Eth
116     function () public payable {
117         require(msg.value > 0);       
118         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
119     }
120 	
121 // Function 02 - Contribute (Hodl Platform)
122     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
123         require(tokenAddress != 0x0);
124         require(amount > 0);
125 		
126         ERC20Interface token = ERC20Interface(tokenAddress);       
127         require(token.transferFrom(msg.sender, address(this), amount));
128 		
129 		    uint256 affiliatecomission 		= mul(amount, affiliate) / 100; 	// *			
130             uint256 data_amountbalance 		= sub(amount, affiliatecomission); 	// * 
131 			uint256 data_cashbackbalance 	= mul(amount, cashback) / 100; 		// *			 
132 			  		  				  					  
133 	// Insert to Database  			 	  
134 		_userSafes[msg.sender].push(_currentIndex);
135 		_safes[_currentIndex] = 
136 
137 		Safe(
138 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, superOwner);				
139 		
140 	// Update Token Balance, Current Index, CountSafes		
141         _totalSaved[tokenAddress] 		= add(_totalSaved[tokenAddress], amount);     
142         _systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], affiliatecomission);		
143         _currentIndex++;
144         _countSafes++;
145         
146         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
147     }
148 	
149 	
150 // Function 03 - Claim (Hodl Platform)	
151     function ClaimTokens(address tokenAddress, uint256 id) public {
152         require(tokenAddress != 0x0);
153         require(id != 0);        
154         
155         Safe storage s = _safes[id];
156         require(s.user == msg.sender);  
157 
158 		if(s.amountbalance == 0) { revert(); }	
159 		
160         RetireHodl(tokenAddress, id);
161     }
162     
163     function RetireHodl(address tokenAddress, uint256 id) private {
164         Safe storage s = _safes[id];
165         
166         require(s.id != 0);
167         require(s.tokenAddress == tokenAddress);
168 
169         uint256 eventAmount;
170         address eventTokenAddress = s.tokenAddress;
171         string memory eventTokenSymbol = s.tokenSymbol;		
172 		     
173         if(s.endtime < now) // Hodl Complete
174         {
175             PayToken(s.user, s.tokenAddress, s.amountbalance);
176             
177             eventAmount 				= s.amountbalance;
178 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
179 			
180 	    s.amountbalance = 0;
181 		
182         }
183         else 
184         {
185 			
186 			uint256 timeframe  			= sub(now, s.lasttime);
187 			uint256 CalculateWithdraw 	= s.amount * s.percentage / 100 * timeframe / seconds30days ;		// SAFE MATH FUNCTIONS ???	
188 			uint256 MaxWithdraw 		= mul(s.amount, 10);
189 			
190 			// Maximum withdraw before unlocked, Max 10% Accumulation
191 			if (CalculateWithdraw > MaxWithdraw) { 				
192 			uint256 MaxAccumulation = MaxWithdraw; 
193 			} else { MaxAccumulation = CalculateWithdraw; }
194 			
195 			// Maximum withdraw = User Amount Balance   
196 			if (MaxAccumulation > s.amountbalance) { 			     	
197 			uint256 realAmount = s.amountbalance; 
198 			} else { realAmount = MaxAccumulation; }
199 			   				
200 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
201 			UpdateUserData(tokenAddress, id, newamountbalance, realAmount);
202 			
203 		}
204         
205         emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
206     }   
207 
208     function UpdateUserData(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
209         Safe storage s = _safes[id];
210         
211         require(s.id != 0);
212         require(s.tokenAddress == tokenAddress);
213 
214         uint256 eventAmount;		
215    			
216 		s.amountbalance 				= newamountbalance;  
217 		s.lasttime 						= now;  
218 		
219 			uint256 tokenaffiliate 		= mul(s.amount, affiliate) / 100 ; 
220 			uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance;	  		// * SAFE MATH FUNCTIONS ???		
221 			uint256 percentagereceived 	= tokenreceived / s.amount * 100000000000000000000;	  	// * SAFE MATH FUNCTIONS ???	
222 		
223 		s.tokenreceive 					= tokenreceived; 
224 		s.percentagereceive 			= percentagereceived; 		
225 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
226 		
227 		
228 	        PayToken(s.user, s.tokenAddress, realAmount);           
229             eventAmount = realAmount;
230     } 
231 
232     function PayToken(address user, address tokenAddress, uint256 amount) private {
233         
234         ERC20Interface token = ERC20Interface(tokenAddress);        
235         require(token.balanceOf(address(this)) >= amount);
236         token.transfer(user, amount);
237     }   	
238 	
239 // Function 04 - Get How Many Contribute ?
240     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
241         return _userSafes[hodler].length;
242     }
243     
244 // Function 05 - Get Data Values
245 	function GetSafe(uint256 _id) public view
246         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
247     {
248         Safe storage s = _safes[_id];
249         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
250     }
251 	
252 // Function 06 - Get Tokens Reserved For The Owner As Commission 
253     function GetTokenFees(address tokenAddress) public view returns (uint256 amount) {
254         return _systemReserves[tokenAddress];
255     }    
256     
257 // Function 07 - Get Contract's Balance  
258     function GetContractBalance() public view returns(uint256)
259     {
260         return address(this).balance;
261     } 	
262 	
263 	
264 	
265 // Useless Function ( Public )	
266 	
267 //??? Function 01 - Store Comission From Unfinished Hodl
268     function StoreComission(address tokenAddress, uint256 amount) private {
269             
270         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
271         
272         bool isNew = true;
273         for(uint256 i = 0; i < _listedReserves.length; i++) {
274             if(_listedReserves[i] == tokenAddress) {
275                 isNew = false;
276                 break;
277             }
278         }         
279         if(isNew) _listedReserves.push(tokenAddress); 
280     }    
281 	
282 //??? Function 02 - Delete Safe Values In Storage   
283     function DeleteSafe(Safe s) private {
284         
285         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
286         delete _safes[s.id];
287         
288         uint256[] storage vector = _userSafes[msg.sender];
289         uint256 size = vector.length; 
290         for(uint256 i = 0; i < size; i++) {
291             if(vector[i] == s.id) {
292                 vector[i] = vector[size-1];
293                 vector.length--;
294                 break;
295             }
296         } 
297     }
298 	
299 //??? Function 03 - Store The Profile's Hash In The Blockchain   
300     function storeProfileHashed(string _profileHashed) public {
301         profileHashed[msg.sender] = _profileHashed;        
302         emit onStoreProfileHash(msg.sender, _profileHashed);
303     }  	
304 
305 //??? Function 04 - Get User's Any Token Balance
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
317 	
318 ////////////////////////////////// onlyOwner //////////////////////////////////
319 
320 	
321 // 01 Claim ( By Owner )	
322     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
323         require(tokenAddress != 0x0);
324         require(id != 0);      
325         RetireHodl(tokenAddress, id);
326     }
327     
328 // 02 Change Hodling Time   
329     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
330         require(newHodlingDays >= 60);      
331         hodlingTime = newHodlingDays * 1 days;
332     }   
333     
334 // 03 Change All Time High Price   
335     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
336         require(newAllTimeHighPrice > allTimeHighPrice);       
337         allTimeHighPrice = newAllTimeHighPrice;
338     }              
339 
340 // 04 Change Comission Value   
341     function ChangeComission(uint256 newComission) onlyOwner public {
342         require(newComission <= 30);       
343         comission = newComission;
344     }
345 	
346 // 05 - Withdraw Ether Received Through Fallback Function    
347     function WithdrawEth(uint256 amount) onlyOwner public {
348         require(amount > 0); 
349         require(address(this).balance >= amount); 
350         
351         msg.sender.transfer(amount);
352     }
353     
354 // 06 Withdraw Token Fees By Token Address   
355     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
356         require(_systemReserves[tokenAddress] > 0);
357         
358         uint256 amount = _systemReserves[tokenAddress];
359         _systemReserves[tokenAddress] = 0;
360         
361         ERC20Interface token = ERC20Interface(tokenAddress);
362         
363         require(token.balanceOf(address(this)) >= amount);
364         token.transfer(msg.sender, amount);
365     }
366 
367 // 07 Withdraw All Eth And All Tokens Fees   
368     function WithdrawAllFees() onlyOwner public {
369         
370         // Ether
371         uint256 x = _systemReserves[0x0];
372         if(x > 0 && x <= address(this).balance) {
373             _systemReserves[0x0] = 0;
374             msg.sender.transfer(_systemReserves[0x0]);
375         }
376         
377         // Tokens
378         address ta;
379         ERC20Interface token;
380         for(uint256 i = 0; i < _listedReserves.length; i++) {
381             ta = _listedReserves[i];
382             if(_systemReserves[ta] > 0)
383             { 
384                 x = _systemReserves[ta];
385                 _systemReserves[ta] = 0;
386                 
387                 token = ERC20Interface(ta);
388                 token.transfer(msg.sender, x);
389             }
390         }
391         _listedReserves.length = 0; 
392     }
393     
394 
395 
396 // 08 - Returns All Tokens Addresses With Fees       
397     function GetTokensAddressesWithFees() 
398         onlyOwner public view 
399         returns (address[], string[], uint256[])
400     {
401         uint256 length = _listedReserves.length;
402         
403         address[] memory tokenAddress = new address[](length);
404         string[] memory tokenSymbol = new string[](length);
405         uint256[] memory tokenFees = new uint256[](length);
406         
407         for (uint256 i = 0; i < length; i++) {
408     
409             tokenAddress[i] = _listedReserves[i];
410             
411             ERC20Interface token = ERC20Interface(tokenAddress[i]);
412             
413             tokenSymbol[i] = token.symbol();
414             tokenFees[i] = GetTokenFees(tokenAddress[i]);
415         }
416         
417         return (tokenAddress, tokenSymbol, tokenFees);
418     }
419 
420 	
421 // 09 - Return All Tokens To Their Respective Addresses    
422     function ReturnAllTokens(bool onlyAXPR) onlyOwner public
423     {
424         uint256 returned;
425 
426         for(uint256 i = 1; i < _currentIndex; i++) {            
427             Safe storage s = _safes[i];
428             if (s.id != 0) {
429                 if (
430                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
431                     !onlyAXPR
432                     )
433                 {
434                     PayToken(s.user, s.tokenAddress, s.amountbalance);
435                     
436                     _countSafes--;
437                     returned++;
438                 }
439             }
440         }
441 
442         emit onReturnAll(returned);
443     }   
444 
445 
446 
447 //////////////////////////////////////////////// 	
448 	
449 
450     /**
451     * SAFE MATH FUNCTIONS
452     * 
453     * @dev Multiplies two numbers, throws on overflow.
454     */
455     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
456         if (a == 0) {
457             return 0;
458         }
459         c = a * b;
460         assert(c / a == b);
461         return c;
462     }
463     
464     /**
465     * @dev Integer division of two numbers, truncating the quotient.
466     */
467     function div(uint256 a, uint256 b) internal pure returns (uint256) {
468         // assert(b > 0); // Solidity automatically throws when dividing by 0
469         // uint256 c = a / b;
470         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
471         return a / b;
472     }
473     
474     /**
475     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
476     */
477     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
478         assert(b <= a);
479         return a - b;
480     }
481     
482     /**
483     * @dev Adds two numbers, throws on overflow.
484     */
485     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
486         c = a + b;
487         assert(c >= a);
488         return c;
489     }
490     
491 }
492 
493 contract ERC20Interface {
494 
495     uint256 public totalSupply;
496     uint256 public decimals;
497     
498     function symbol() public view returns (string);
499     function balanceOf(address _owner) public view returns (uint256 balance);
500     function transfer(address _to, uint256 _value) public returns (bool success);
501     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
502     function approve(address _spender, uint256 _value) public returns (bool success);
503     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
504 
505     // solhint-disable-next-line no-simple-event-func-name  
506     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
507     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
508 }