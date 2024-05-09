1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 ////// Version 5.0 ////// 
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
58 	event onAddContractAddress(address indexed contracthodler, bool contractstatus);    
59 	event onCashbackCode(address indexed hodler, address cashbackcode);
60     event onStoreProfileHash(address indexed hodler, string profileHashed);
61     event onHodlTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
62     event onClaimTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
63     event onReturnAll(uint256 returned);
64 	
65     // Variables // * = New ** = Undeveloped	
66     address internal AXPRtoken;
67     mapping(address => string) 	public profileHashed; 		// User Prime 
68 	mapping(address => address) public cashbackcode; 		// Cashback Code 
69 	mapping(address => bool) 	public contractaddress; 	// Contract Address
70 	
71 	// Default Setting
72 	uint256 public 	percent 				= 1200;        	// * Percent Permonth ( Only Test = 1200% )
73 	uint256 private constant affiliate 		= 12;        	// * 12% from deposit
74 	uint256 private constant cashback 		= 16;        	// * 16% from deposit
75 	uint256 private constant nocashback 	= 28;        	// * 12% + 16% = 28% from deposit
76 	uint256 private constant totalreceive 	= 88;        	// * 88% from deposit	
77     uint256 private constant seconds30days 	= 2592000;  	// *
78 
79     struct Safe {
80         uint256 id;
81         uint256 amount;
82         uint256 endtime;
83         address user;
84         address tokenAddress;
85 		string  tokenSymbol;	
86 		uint256 amountbalance; 			// * --- > 88% from deposit
87 		uint256 cashbackbalance; 		// * --- > 16% from deposit
88 		uint256 lasttime; 				// * --- > Last Withdraw (Time)
89 		uint256 percentage; 			// * --- > return tokens every month
90 		uint256 percentagereceive; 		// * --- > 0 %
91 		uint256 tokenreceive; 			// * --- > 0 Token
92 		uint256 affiliatebalance; 		// ** --->>> Dont forget to develop
93 		uint256 lastwithdraw; 			// * --- > Last Withdraw (Amount)
94 		address referrer; 				// *
95 
96     }
97     
98 	mapping(address => uint256[]) 	public 	_userSafes;			// 0,1,2,3 ( Multiple Sequential number Data )
99     mapping(address => uint256) 	public 	_totalSaved; 		// Token Balance
100 	mapping(uint256 => Safe) 		private _safes; 			// Struct safe database
101     uint256 						private _currentIndex; 		// Sequential number ( Start from 500 )
102 	uint256 						public _countSafes; 		// Total Smart Contract User
103 	uint256 						public hodlingTime;			
104     uint256 						public allTimeHighPrice;
105     uint256 						public comission;
106 	
107     mapping(address => uint256) 	private _systemReserves;    // Token Balance ( Reserve )
108     address[] 						public _listedReserves;		// ?????
109     
110     //Constructor
111    
112     constructor() public {
113         
114         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;        
115         hodlingTime 	= 730 days;
116         _currentIndex 	= 500;
117         comission 		= 12;
118     }
119     
120 	
121 // Function 01 - Fallback Function To Receive Donation In Eth
122     function () public payable {
123         require(msg.value > 0);       
124         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
125     }
126 	
127 // Function 02 - Contribute (Hodl Platform)
128     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
129         require(tokenAddress != 0x0);
130         require(amount > 0);
131 		
132 		if (contractaddress[tokenAddress] == false) {
133 			revert();
134 		}
135 		else {
136 			
137 		
138         ERC20Interface token = ERC20Interface(tokenAddress);       
139         require(token.transferFrom(msg.sender, address(this), amount));
140 		
141 		uint256 affiliatecomission 		= div(mul(amount, affiliate), 100); 	// amount * affiliate / 100
142 		uint256 no_cashback 			= div(mul(amount, nocashback), 100); 	// amount * 28 / 100
143 		
144 		 	if (cashbackcode[msg.sender] == 0 ) { 				
145 			uint256 data_amountbalance 		= div(mul(amount, 72), 100);		// amount * 72 / 100
146 			uint256 data_cashbackbalance 	= 0; 
147 			address data_referrer			= superOwner;
148 			
149 			cashbackcode[msg.sender] = superOwner;
150 			emit onCashbackCode(msg.sender, superOwner);
151 			
152 			_systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], no_cashback);
153 			
154 			} else { 	
155 			data_amountbalance 		= sub(amount, affiliatecomission);			// amount - affiliatecomission
156 			data_cashbackbalance 	= div(mul(amount, cashback), 100);			// amount * cashback / 100
157 			data_referrer			= cashbackcode[msg.sender];
158 
159 			_systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], affiliatecomission); } //--->>> Dont forget to develop
160 			  		  				  					  
161 	// Insert to Database  			 	  
162 		_userSafes[msg.sender].push(_currentIndex);
163 		_safes[_currentIndex] = 
164 
165 		Safe(
166 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, 0, data_referrer);				
167 		
168 	// Update Token Balance, Current Index, CountSafes		
169         _totalSaved[tokenAddress] 		= add(_totalSaved[tokenAddress], amount);     		
170         _currentIndex++;
171         _countSafes++;
172         
173         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
174     }	
175 			
176 			
177 }
178 		
179 	
180 // Function 03 - Claim (Hodl Platform)	
181     function ClaimTokens(address tokenAddress, uint256 id) public {
182         require(tokenAddress != 0x0);
183         require(id != 0);        
184         
185         Safe storage s = _safes[id];
186         require(s.user == msg.sender);  
187 		
188 		if (s.amountbalance == 0) {
189 			revert();
190 		}
191 		else {
192 			RetireHodl(tokenAddress, id);
193 		}
194     }
195     
196     function RetireHodl(address tokenAddress, uint256 id) private {
197         Safe storage s = _safes[id];
198         
199         require(s.id != 0);
200         require(s.tokenAddress == tokenAddress);
201 
202         uint256 eventAmount;
203         address eventTokenAddress = s.tokenAddress;
204         string memory eventTokenSymbol = s.tokenSymbol;		
205 		     
206         if(s.endtime < now) // Hodl Complete
207         {
208             PayToken(s.user, s.tokenAddress, s.amountbalance);
209             
210             eventAmount 				= s.amountbalance;
211 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
212 		
213 		s.lastwithdraw = s.amountbalance;
214 		s.amountbalance = 0;
215 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
216 		
217         }
218         else 
219         {
220 			
221 			uint256 timeframe  			= sub(now, s.lasttime);			                            
222 			uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), seconds30days); 
223 		//	uint256 CalculateWithdraw   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
224 		                         
225 			uint256 MaxWithdraw 		= div(s.amount, 10);
226 			
227 			// Maximum withdraw before unlocked, Max 10% Accumulation
228 			if (CalculateWithdraw > MaxWithdraw) { 				
229 			uint256 MaxAccumulation = MaxWithdraw; 
230 			} else { MaxAccumulation = CalculateWithdraw; }
231 			
232 			// Maximum withdraw = User Amount Balance   
233 			if (MaxAccumulation > s.amountbalance) { 			     	
234 			uint256 realAmount = s.amountbalance; 
235 			} else { realAmount = MaxAccumulation; }
236 			
237 			s.lastwithdraw = realAmount;  			
238 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
239 			UpdateUserData(tokenAddress, id, newamountbalance, realAmount);
240 			
241 		}
242         
243     }   
244 
245     function UpdateUserData(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
246         Safe storage s = _safes[id];
247         
248         require(s.id != 0);
249         require(s.tokenAddress == tokenAddress);
250 
251         uint256 eventAmount;
252         address eventTokenAddress = s.tokenAddress;
253         string memory eventTokenSymbol = s.tokenSymbol;			
254    			
255 		s.amountbalance 				= newamountbalance;  
256 		s.lasttime 						= now;  
257 		
258 			uint256 tokenaffiliate 		= div(mul(s.amount, affiliate), 100) ; 
259 			uint256 maxcashback 		= div(mul(s.amount, cashback), 100) ; 		
260 			uint256 tokenreceived 		= sub(add(sub(sub(s.amount, tokenaffiliate), newamountbalance), s.cashbackbalance), maxcashback) ;		
261 		//	uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance + s.cashbackbalance - maxcashback ;
262 			
263 			// Cashback = 100 - 12 - 88 + 16 - 16 = 0 ----> No_Cashback 	= 100 - 12 - 72 + 0 - 16 = 1
264 
265 			uint256 percentagereceived 	= mul(div(tokenreceived, s.amount), 100000000000000000000) ; 	
266 		
267 		s.tokenreceive 					= tokenreceived; 
268 		s.percentagereceive 			= percentagereceived; 		
269 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
270 		
271 		
272 	        PayToken(s.user, s.tokenAddress, realAmount);           		
273             eventAmount = realAmount;
274 			
275 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
276     } 
277 
278     function PayToken(address user, address tokenAddress, uint256 amount) private {
279         
280         ERC20Interface token = ERC20Interface(tokenAddress);        
281         require(token.balanceOf(address(this)) >= amount);
282         token.transfer(user, amount);
283     }   	
284 	
285 // Function 04 - Get How Many Contribute ?
286     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
287         return _userSafes[hodler].length;
288     }
289     
290 // Function 05 - Get Data Values
291 	function GetSafe(uint256 _id) public view
292         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
293     {
294         Safe storage s = _safes[_id];
295         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
296     }
297 	
298 // Function 06 - Get Tokens Reserved For The Owner As Commission 
299     function GetTokenFees(address tokenAddress) public view returns (uint256 amount) {
300         return _systemReserves[tokenAddress];
301     }    
302     
303 // Function 07 - Get Contract's Balance  
304     function GetContractBalance() public view returns(uint256)
305     {
306         return address(this).balance;
307     } 	
308 	
309 //Function 08 - Cashback Code  
310     function CashbackCode(address _cashbackcode) public {
311 		
312 		if (cashbackcode[msg.sender] == 0) {
313 			cashbackcode[msg.sender] = _cashbackcode;
314 			emit onCashbackCode(msg.sender, _cashbackcode);
315 		}		             
316     }  
317 	
318 	
319 // Useless Function ( Public )	
320 	
321 //??? Function 01 - Store Comission From Unfinished Hodl
322     function StoreComission(address tokenAddress, uint256 amount) private {
323             
324         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
325         
326         bool isNew = true;
327         for(uint256 i = 0; i < _listedReserves.length; i++) {
328             if(_listedReserves[i] == tokenAddress) {
329                 isNew = false;
330                 break;
331             }
332         }         
333         if(isNew) _listedReserves.push(tokenAddress); 
334     }    
335 	
336 //??? Function 02 - Delete Safe Values In Storage   
337     function DeleteSafe(Safe s) private {
338         
339         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
340         delete _safes[s.id];
341         
342         uint256[] storage vector = _userSafes[msg.sender];
343         uint256 size = vector.length; 
344         for(uint256 i = 0; i < size; i++) {
345             if(vector[i] == s.id) {
346                 vector[i] = vector[size-1];
347                 vector.length--;
348                 break;
349             }
350         } 
351     }
352 	
353 //??? Function 03 - Store The Profile's Hash In The Blockchain   
354     function storeProfileHashed(string _profileHashed) public {
355         profileHashed[msg.sender] = _profileHashed;        
356         emit onStoreProfileHash(msg.sender, _profileHashed);
357     }  	
358 
359 //??? Function 04 - Get User's Any Token Balance
360     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
361         require(tokenAddress != 0x0);
362         
363         for(uint256 i = 1; i < _currentIndex; i++) {            
364             Safe storage s = _safes[i];
365             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
366                 balance += s.amount;
367         }
368         return balance;
369     }
370 	
371 
372 ////////////////////////////////// onlyOwner //////////////////////////////////
373 
374 // 00 Insert Token Contract Address	
375     function AddContractAddress(address tokenAddress, bool contractstatus) public onlyOwner {
376         contractaddress[tokenAddress] = contractstatus;
377 		emit onAddContractAddress(tokenAddress, contractstatus);
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
506     // SAFE MATH FUNCTIONS //
507 	
508 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
509 		if (a == 0) {
510 			return 0;
511 		}
512 
513 		uint256 c = a * b; 
514 		require(c / a == b);
515 		return c;
516 	}
517 	
518 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
519 		require(b > 0); 
520 		uint256 c = a / b;
521 		return c;
522 	}
523 	
524 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
525 		require(b <= a);
526 		uint256 c = a - b;
527 		return c;
528 	}
529 	
530 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
531 		uint256 c = a + b;
532 		require(c >= a);
533 		return c;
534 	}
535     
536 }
537 
538 contract ERC20Interface {
539 
540     uint256 public totalSupply;
541     uint256 public decimals;
542     
543     function symbol() public view returns (string);
544     function balanceOf(address _owner) public view returns (uint256 balance);
545     function transfer(address _to, uint256 _value) public returns (bool success);
546     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
547     function approve(address _spender, uint256 _value) public returns (bool success);
548     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
549 
550     // solhint-disable-next-line no-simple-event-func-name  
551     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
552     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
553 }