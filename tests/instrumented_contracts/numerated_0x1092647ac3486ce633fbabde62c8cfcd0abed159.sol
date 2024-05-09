1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 contract OwnableContract {
5      
6     event onTransferOwnership(address newOwner);
7  
8     address superOwner;
9       
10     constructor() public { 
11         superOwner = msg.sender;
12     }
13     
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
25         
26         superOwner = newOwner;
27         
28         emit onTransferOwnership(superOwner);
29     }
30 }
31 
32 contract BlockableContract is OwnableContract {
33     
34     event onBlockHODLs(bool status);
35  
36     bool public blockedContract;
37     
38     constructor() public { 
39         blockedContract = false;  
40     }
41     
42     modifier contractActive() {
43         require(!blockedContract);
44         _;
45     } 
46     
47     function doBlockContract() onlyOwner public {
48         blockedContract = true;
49         
50         emit onBlockHODLs(blockedContract);
51     }
52     
53     function unBlockContract() onlyOwner public {
54         blockedContract = false;
55         
56         emit onBlockHODLs(blockedContract);
57     }
58 }
59 
60 contract ldoh is BlockableContract {
61     
62     /**
63     * Events
64     */
65     event onStoreProfileHash(address indexed hodler, string profileHashed);
66     event onHodlTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
67     event onClaimTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
68     event onReturnAll(uint256 returned);
69 
70     /**
71     * State variables
72     */
73     address internal AXPRtoken;
74     mapping(address => string) public profileHashed; // User Profile
75     uint256 public hodlingTime;
76     uint256 public allTimeHighPrice;
77 	uint256 private constant percent = 300;        // new 3.0%
78 	uint256 private constant affiliate = 12;        // new 
79     uint256 private constant seconds30days = 2592000;        // new 
80 
81     struct Safe {
82         uint256 id;
83         uint256 amount;
84 		uint256 amountbalance; //new
85 		uint256 lasttime; //new
86         uint256 endtime;
87         address user;
88         address tokenAddress;
89         string tokenSymbol;
90     }
91     
92     /**
93     * @dev safes variables
94     */
95     mapping(address => uint256[]) public _userSafes;
96     mapping(uint256 => Safe) private _safes; // = Struct safe
97 	
98     uint256 private _currentIndex; // Id Number
99     uint256 public _countSafes; // Total User
100 	
101     mapping(address => uint256) public _totalSaved; // Token Balance count
102     
103     /**
104     * @dev owner variables
105     */
106     uint256 public comission; //0..30
107     mapping(address => uint256) private _systemReserves;    // Token Balance Reserve
108     address[] public _listedReserves;
109     
110     /**
111     * constructor
112     */
113     constructor() public {
114         
115         AXPRtoken = 0xC39E626A04C5971D770e319760D7926502975e47;
116         
117         hodlingTime = 365 days;
118         _currentIndex = 1;
119         comission = 5;
120     }
121     
122     /**
123     * fallback function to receive donation in eth
124     */
125     function () public payable {
126         require(msg.value > 0);
127         
128         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
129     }
130 
131     /**
132     * store the profile's hash in the blockchain
133     */
134     function storeProfileHashed(string _profileHashed) public {
135         profileHashed[msg.sender] = _profileHashed;        
136 
137         emit onStoreProfileHash(msg.sender, _profileHashed);
138     }
139     
140     /**
141     * add new hodl safe (ERC20 token)
142     */
143     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
144         require(tokenAddress != 0x0);
145         require(amount > 0);
146           
147         ERC20Interface token = ERC20Interface(tokenAddress);
148         
149         require(token.transferFrom(msg.sender, address(this), amount));
150 		
151 		    uint256 affiliatecomission = mul(amount, affiliate) / 100; // new 
152             uint256 amountbalance = sub(amount, affiliatecomission); // new 
153 		      
154         _userSafes[msg.sender].push(_currentIndex);
155         _safes[_currentIndex] = Safe(_currentIndex, amount, amountbalance, now, now + hodlingTime, msg.sender, tokenAddress, token.symbol()); //new
156         
157         _totalSaved[tokenAddress] = add(_totalSaved[tokenAddress], amount);
158         
159         _currentIndex++;
160         _countSafes++;
161         
162         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
163     }
164 
165     /**
166     * user, claim back a hodl safe
167     */
168     function ClaimTokens(address tokenAddress, uint256 id) public {
169         require(tokenAddress != 0x0);
170         require(id != 0);        
171         
172         Safe storage s = _safes[id];
173         require(s.user == msg.sender);
174         
175         RetireHodl(tokenAddress, id);
176     }
177     
178     function RetireHodl(address tokenAddress, uint256 id) private {
179 
180         Safe storage s = _safes[id];
181         
182         require(s.id != 0);
183         require(s.tokenAddress == tokenAddress);
184         require(
185                 (tokenAddress == AXPRtoken && s.endtime < now ) ||
186                     tokenAddress != AXPRtoken
187                 );
188 
189         uint256 eventAmount;
190         address eventTokenAddress = s.tokenAddress;
191         string memory eventTokenSymbol = s.tokenSymbol;
192         
193         if(s.endtime < now) // hodl complete
194         {
195             PayToken(s.user, s.tokenAddress, s.amount);
196             
197             eventAmount = s.amount;
198         }
199         else // hodl still in progress (penalty fee applies), not for AXPR tokens
200         {
201 					
202 			uint256 timeframe = sub(now, s.lasttime);			// new 
203 			uint256 prewithdraw = mul(s.amount, percent) / 100; // new 
204 			uint256 realAmount = mul(prewithdraw, timeframe) / seconds30days; // new 
205 			
206 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	 // new 
207             
208             PayToken(s.user, s.tokenAddress, realAmount);
209                 
210 
211             
212             eventAmount = realAmount;
213         }
214 		
215         s.amountbalance = newamountbalance;  // new 
216 
217         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount); // new 
218 
219         
220         emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
221     }    
222     
223     /**
224     * store comission from unfinished hodl
225     */
226     function StoreComission(address tokenAddress, uint256 amount) private {
227             
228         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
229         
230         bool isNew = true;
231         for(uint256 i = 0; i < _listedReserves.length; i++) {
232             if(_listedReserves[i] == tokenAddress) {
233                 isNew = false;
234                 break;
235             }
236         }         
237         if(isNew) _listedReserves.push(tokenAddress); 
238     }    
239     
240     /**
241     * private pay token to address
242     */
243     function PayToken(address user, address tokenAddress, uint256 amount) private {
244         
245         ERC20Interface token = ERC20Interface(tokenAddress);
246         
247         require(token.balanceOf(address(this)) >= amount);
248         token.transfer(user, amount);
249     }   
250     
251     /**
252     * delete safe values in storage
253     */
254     function DeleteSafe(Safe s) private {
255         
256         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
257         delete _safes[s.id];
258         
259         uint256[] storage vector = _userSafes[msg.sender];
260         uint256 size = vector.length; 
261         for(uint256 i = 0; i < size; i++) {
262             if(vector[i] == s.id) {
263                 vector[i] = vector[size-1];
264                 vector.length--;
265                 break;
266             }
267         } 
268     }
269 
270     /**
271     * Get user's any token balance
272     */
273     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
274         require(tokenAddress != 0x0);
275         
276         for(uint256 i = 1; i < _currentIndex; i++) {            
277             Safe storage s = _safes[i];
278             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
279                 balance += s.amount;
280         }
281         return balance;
282     }
283 
284     /**
285     * Get how many safes has the user
286     */
287     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
288         return _userSafes[hodler].length;
289     }
290     
291     /**
292     * Get safes values
293     */
294     function GetSafe(uint256 _id) public view
295         returns (uint256 id, address user, uint256 amountbalance, uint256 lastime, address tokenAddress, uint256 amount, uint256 time)
296     {
297         Safe storage s = _safes[_id];
298         return(s.id, s.user, s.amountbalance, s.lasttime, s.tokenAddress, s.amount, s.endtime);
299     }
300     
301     /**
302     * Get tokens reserved for the owner as commission
303     */
304     function GetTokenFees(address tokenAddress) private view returns (uint256 amount) {
305         return _systemReserves[tokenAddress];
306     }    
307     
308     /**
309     * Get contract's balance
310     */
311     function GetContractBalance() public view returns(uint256)
312     {
313         return address(this).balance;
314     }    
315     
316     /**
317     * ONLY OWNER
318     * 
319     * owner: retire hodl safe
320     */
321     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
322         require(tokenAddress != 0x0);
323         require(id != 0);
324         
325         RetireHodl(tokenAddress, id);
326     }
327     
328     /**
329     * owner: change hodling time
330     */
331     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
332         require(newHodlingDays >= 60);
333         
334         hodlingTime = newHodlingDays * 1 days;
335     }   
336     
337     /**
338     * owner: change all time high price
339     */
340     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
341         require(newAllTimeHighPrice > allTimeHighPrice);
342         
343         allTimeHighPrice = newAllTimeHighPrice;
344     }              
345 
346     /**
347     * owner: change comission value
348     */
349     function ChangeComission(uint256 newComission) onlyOwner public {
350         require(newComission <= 30);
351         
352         comission = newComission;
353     }
354     
355     /**
356     * owner: withdraw token fees by address
357     */
358     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
359         require(_systemReserves[tokenAddress] > 0);
360         
361         uint256 amount = _systemReserves[tokenAddress];
362         _systemReserves[tokenAddress] = 0;
363         
364         ERC20Interface token = ERC20Interface(tokenAddress);
365         
366         require(token.balanceOf(address(this)) >= amount);
367         token.transfer(msg.sender, amount);
368     }
369 
370     /**
371     * owner: withdraw all eth and all tokens fees
372     */
373     function WithdrawAllFees() onlyOwner public {
374         
375         // ether
376         uint256 x = _systemReserves[0x0];
377         if(x > 0 && x <= address(this).balance) {
378             _systemReserves[0x0] = 0;
379             msg.sender.transfer(_systemReserves[0x0]);
380         }
381         
382         // tokens
383         address ta;
384         ERC20Interface token;
385         for(uint256 i = 0; i < _listedReserves.length; i++) {
386             ta = _listedReserves[i];
387             if(_systemReserves[ta] > 0)
388             { 
389                 x = _systemReserves[ta];
390                 _systemReserves[ta] = 0;
391                 
392                 token = ERC20Interface(ta);
393                 token.transfer(msg.sender, x);
394             }
395         }
396         _listedReserves.length = 0; 
397     }
398     
399     /**
400     * owner: withdraw ether received through fallback function
401     */
402     function WithdrawEth(uint256 amount) onlyOwner public {
403         require(amount > 0); 
404         require(address(this).balance >= amount); 
405         
406         msg.sender.transfer(amount);
407     }
408 
409     /**
410     * owner: returns all tokens addresses with fees
411     */    
412     function GetTokensAddressesWithFees() 
413         onlyOwner public view 
414         returns (address[], string[], uint256[])
415     {
416         uint256 length = _listedReserves.length;
417         
418         address[] memory tokenAddress = new address[](length);
419         string[] memory tokenSymbol = new string[](length);
420         uint256[] memory tokenFees = new uint256[](length);
421         
422         for (uint256 i = 0; i < length; i++) {
423     
424             tokenAddress[i] = _listedReserves[i];
425             
426             ERC20Interface token = ERC20Interface(tokenAddress[i]);
427             
428             tokenSymbol[i] = token.symbol();
429             tokenFees[i] = GetTokenFees(tokenAddress[i]);
430         }
431         
432         return (tokenAddress, tokenSymbol, tokenFees);
433     }
434 
435     /**
436     * owner: return all tokens to their respective addresses
437     */
438     function ReturnAllTokens(bool onlyAXPR) onlyOwner public
439     {
440         uint256 returned;
441 
442         for(uint256 i = 1; i < _currentIndex; i++) {            
443             Safe storage s = _safes[i];
444             if (s.id != 0) {
445                 if (
446                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
447                     !onlyAXPR
448                     )
449                 {
450                     PayToken(s.user, s.tokenAddress, s.amount);
451                     DeleteSafe(s);
452                     
453                     _countSafes--;
454                     returned++;
455                 }
456             }
457         }
458 
459         emit onReturnAll(returned);
460     }    
461 
462 
463     /**
464     * SAFE MATH FUNCTIONS
465     * 
466     * @dev Multiplies two numbers, throws on overflow.
467     */
468     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
469         if (a == 0) {
470             return 0;
471         }
472         c = a * b;
473         assert(c / a == b);
474         return c;
475     }
476     
477     /**
478     * @dev Integer division of two numbers, truncating the quotient.
479     */
480     function div(uint256 a, uint256 b) internal pure returns (uint256) {
481         // assert(b > 0); // Solidity automatically throws when dividing by 0
482         // uint256 c = a / b;
483         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
484         return a / b;
485     }
486     
487     /**
488     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
489     */
490     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
491         assert(b <= a);
492         return a - b;
493     }
494     
495     /**
496     * @dev Adds two numbers, throws on overflow.
497     */
498     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
499         c = a + b;
500         assert(c >= a);
501         return c;
502     }
503     
504 }
505 
506 contract ERC20Interface {
507     /* This is a slight change to the ERC20 base standard.
508     function totalSupply() constant returns (uint256 supply);
509     is replaced with:
510     uint256 public totalSupply;
511     This automatically creates a getter function for the totalSupply.
512     This is moved to the base contract since public getter functions are not
513     currently recognised as an implementation of the matching abstract
514     function by the compiler.
515     */
516     // total amount of tokens
517     uint256 public totalSupply;
518     
519     //How many decimals to show.
520     uint256 public decimals;
521     
522     // token symbol
523     function symbol() public view returns (string);
524     
525     /// @param _owner The address from which the balance will be retrieved
526     /// @return The balance
527     function balanceOf(address _owner) public view returns (uint256 balance);
528 
529     /// @notice send `_value` token to `_to` from `msg.sender`
530     /// @param _to The address of the recipient
531     /// @param _value The amount of token to be transferred
532     /// @return Whether the transfer was successful or not
533     function transfer(address _to, uint256 _value) public returns (bool success);
534 
535     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
536     /// @param _from The address of the sender
537     /// @param _to The address of the recipient
538     /// @param _value The amount of token to be transferred
539     /// @return Whether the transfer was successful or not
540     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
541 
542     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
543     /// @param _spender The address of the account able to transfer the tokens
544     /// @param _value The amount of tokens to be approved for transfer
545     /// @return Whether the approval was successful or not
546     function approve(address _spender, uint256 _value) public returns (bool success);
547 
548     /// @param _owner The address of the account owning tokens
549     /// @param _spender The address of the account able to transfer the tokens
550     /// @return Amount of remaining tokens allowed to spent
551     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
552 
553     // solhint-disable-next-line no-simple-event-func-name  
554     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
555     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
556 }