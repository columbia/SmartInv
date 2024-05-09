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
192 			uint256 timeframe  				= now - s.lasttime;
193 			uint256 maxtimeframe 			= timeframe / seconds30days;
194 			
195 			if (maxtimeframe >= 3) { 					// Max (3 x 2592000 Seconds = 3 Month)
196 			uint256 timeframeaccumulation = 3; 
197 			}
198 			else {
199 			timeframeaccumulation = maxtimeframe; 
200 			}
201 			
202 			uint256 withdrawamount 		= s.amount * s.percentage / 100 * timeframeaccumulation ;  			
203 			uint256 newamountbalance 	= sub(s.amountbalance, withdrawamount);	 	
204             			
205 		s.amountbalance 				= newamountbalance;  
206 		s.lasttime 						= now;  
207 		
208 			uint256 tokenaffiliate 		= mul(s.amount, affiliate) / 100 ; 
209 			uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance;	  				
210 			uint256 percentagereceived 	= tokenreceived / s.amount * 100000000000000000000;	  
211 		
212 		s.tokenreceive 					= tokenreceived; 
213 		s.percentagereceive 			= percentagereceived; 	
214 		
215 	        PayToken(s.user, s.tokenAddress, withdrawamount); 
216 			
217             eventAmount = withdrawamount;
218 			_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], withdrawamount); 		
219 		}
220         
221         emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
222     }    
223       
224     function PayToken(address user, address tokenAddress, uint256 amount) private {
225         
226         ERC20Interface token = ERC20Interface(tokenAddress);        
227         require(token.balanceOf(address(this)) >= amount);
228         token.transfer(user, amount);
229     }   	
230 	
231 //??? Function 04 - Store Comission From Unfinished Hodl
232     function StoreComission(address tokenAddress, uint256 amount) private {
233             
234         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
235         
236         bool isNew = true;
237         for(uint256 i = 0; i < _listedReserves.length; i++) {
238             if(_listedReserves[i] == tokenAddress) {
239                 isNew = false;
240                 break;
241             }
242         }         
243         if(isNew) _listedReserves.push(tokenAddress); 
244     }    
245 	
246 //??? Function 05 - Delete Safe Values In Storage   
247     function DeleteSafe(Safe s) private {
248         
249         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
250         delete _safes[s.id];
251         
252         uint256[] storage vector = _userSafes[msg.sender];
253         uint256 size = vector.length; 
254         for(uint256 i = 0; i < size; i++) {
255             if(vector[i] == s.id) {
256                 vector[i] = vector[size-1];
257                 vector.length--;
258                 break;
259             }
260         } 
261     }
262 	
263 //??? Function 06 - Store The Profile's Hash In The Blockchain   
264     function storeProfileHashed(string _profileHashed) public {
265         profileHashed[msg.sender] = _profileHashed;        
266         emit onStoreProfileHash(msg.sender, _profileHashed);
267     }  	
268 
269 //??? Function 07 - Get User's Any Token Balance
270     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
271         require(tokenAddress != 0x0);
272         
273         for(uint256 i = 1; i < _currentIndex; i++) {            
274             Safe storage s = _safes[i];
275             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
276                 balance += s.amount;
277         }
278         return balance;
279     }
280 
281 // Function 08 - Get How Many Safes Has The User  
282     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
283         return _userSafes[hodler].length;
284     }
285     
286 // Function 09 - Get Safes Values
287 	function GetSafe(uint256 _id) public view
288         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
289     {
290         Safe storage s = _safes[_id];
291         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
292     }
293 	
294 // Function 10 - Get Tokens Reserved For The Owner As Commission 
295     function GetTokenFees(address tokenAddress) private view returns (uint256 amount) {
296         return _systemReserves[tokenAddress];
297     }    
298     
299 // Function 11 - Get Contract's Balance  
300     function GetContractBalance() public view returns(uint256)
301     {
302         return address(this).balance;
303     } 
304 
305 // Function 12 - Available For Withdrawal
306 	function AvailableForWithdrawal(uint256 _id) public view
307         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 amountbalance, uint256 lastwithdraw, uint256 timeframe, uint256 maxtimeframe, uint256 availableforwithdrawal)
308     {
309         Safe storage s = _safes[_id];
310 					
311 			if (maxtimeframe >= 3) { 	// Max 3 x 2592000 Seconds = 3 Month
312 			uint256 timeframeaccumulation = 3; 
313 			}
314 			else {
315 			timeframeaccumulation = maxtimeframe; 
316 			}
317 			
318 			uint256 withdrawamount 		= s.amount * s.percentage / 100 * timeframeaccumulation ; 
319 		
320         return(s.id, s.user, s.tokenAddress, s.amount, s.amountbalance, s.lasttime, timeframe, maxtimeframe, withdrawamount);
321     }
322 	
323     
324 	
325 ////////////////////////////////// onlyOwner //////////////////////////////////
326 
327 	
328 // 01 Retire Hodl Safe   
329     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
330         require(tokenAddress != 0x0);
331         require(id != 0);      
332         RetireHodl(tokenAddress, id);
333     }
334     
335 // 02 Change Hodling Time   
336     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
337         require(newHodlingDays >= 60);      
338         hodlingTime = newHodlingDays * 1 days;
339     }   
340     
341 // 03 Change All Time High Price   
342     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
343         require(newAllTimeHighPrice > allTimeHighPrice);       
344         allTimeHighPrice = newAllTimeHighPrice;
345     }              
346 
347 // 04 Change Comission Value   
348     function ChangeComission(uint256 newComission) onlyOwner public {
349         require(newComission <= 30);       
350         comission = newComission;
351     }
352     
353 // 05 Withdraw Token Fees By Address   
354     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
355         require(_systemReserves[tokenAddress] > 0);
356         
357         uint256 amount = _systemReserves[tokenAddress];
358         _systemReserves[tokenAddress] = 0;
359         
360         ERC20Interface token = ERC20Interface(tokenAddress);
361         
362         require(token.balanceOf(address(this)) >= amount);
363         token.transfer(msg.sender, amount);
364     }
365 
366 // 06 Withdraw All Eth And All Tokens Fees   
367     function WithdrawAllFees() onlyOwner public {
368         
369         // Ether
370         uint256 x = _systemReserves[0x0];
371         if(x > 0 && x <= address(this).balance) {
372             _systemReserves[0x0] = 0;
373             msg.sender.transfer(_systemReserves[0x0]);
374         }
375         
376         // Tokens
377         address ta;
378         ERC20Interface token;
379         for(uint256 i = 0; i < _listedReserves.length; i++) {
380             ta = _listedReserves[i];
381             if(_systemReserves[ta] > 0)
382             { 
383                 x = _systemReserves[ta];
384                 _systemReserves[ta] = 0;
385                 
386                 token = ERC20Interface(ta);
387                 token.transfer(msg.sender, x);
388             }
389         }
390         _listedReserves.length = 0; 
391     }
392     
393 
394 // 07 - Withdraw Ether Received Through Fallback Function    
395     function WithdrawEth(uint256 amount) onlyOwner public {
396         require(amount > 0); 
397         require(address(this).balance >= amount); 
398         
399         msg.sender.transfer(amount);
400     }
401 
402 // 08 - Returns All Tokens Addresses With Fees       
403     function GetTokensAddressesWithFees() 
404         onlyOwner public view 
405         returns (address[], string[], uint256[])
406     {
407         uint256 length = _listedReserves.length;
408         
409         address[] memory tokenAddress = new address[](length);
410         string[] memory tokenSymbol = new string[](length);
411         uint256[] memory tokenFees = new uint256[](length);
412         
413         for (uint256 i = 0; i < length; i++) {
414     
415             tokenAddress[i] = _listedReserves[i];
416             
417             ERC20Interface token = ERC20Interface(tokenAddress[i]);
418             
419             tokenSymbol[i] = token.symbol();
420             tokenFees[i] = GetTokenFees(tokenAddress[i]);
421         }
422         
423         return (tokenAddress, tokenSymbol, tokenFees);
424     }
425 
426 	
427 // 09 - Return All Tokens To Their Respective Addresses    
428     function ReturnAllTokens(bool onlyAXPR) onlyOwner public
429     {
430         uint256 returned;
431 
432         for(uint256 i = 1; i < _currentIndex; i++) {            
433             Safe storage s = _safes[i];
434             if (s.id != 0) {
435                 if (
436                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
437                     !onlyAXPR
438                     )
439                 {
440                     PayToken(s.user, s.tokenAddress, s.amountbalance);
441                     
442                     _countSafes--;
443                     returned++;
444                 }
445             }
446         }
447 
448         emit onReturnAll(returned);
449     }    
450 
451 	
452 //////////////////////////////////////////////// 	
453 	
454 
455     /**
456     * SAFE MATH FUNCTIONS
457     * 
458     * @dev Multiplies two numbers, throws on overflow.
459     */
460     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
461         if (a == 0) {
462             return 0;
463         }
464         c = a * b;
465         assert(c / a == b);
466         return c;
467     }
468     
469     /**
470     * @dev Integer division of two numbers, truncating the quotient.
471     */
472     function div(uint256 a, uint256 b) internal pure returns (uint256) {
473         // assert(b > 0); // Solidity automatically throws when dividing by 0
474         // uint256 c = a / b;
475         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
476         return a / b;
477     }
478     
479     /**
480     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
481     */
482     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
483         assert(b <= a);
484         return a - b;
485     }
486     
487     /**
488     * @dev Adds two numbers, throws on overflow.
489     */
490     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
491         c = a + b;
492         assert(c >= a);
493         return c;
494     }
495     
496 }
497 
498 contract ERC20Interface {
499 
500     uint256 public totalSupply;
501     uint256 public decimals;
502     
503     function symbol() public view returns (string);
504     function balanceOf(address _owner) public view returns (uint256 balance);
505     function transfer(address _to, uint256 _value) public returns (bool success);
506     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
507     function approve(address _spender, uint256 _value) public returns (bool success);
508     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
509 
510     // solhint-disable-next-line no-simple-event-func-name  
511     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
512     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
513 }