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
74     mapping(address => string) public profileHashed;
75     uint256 public hodlingTime;
76     uint256 public allTimeHighPrice;
77 
78     struct Safe {
79         uint256 id;
80         uint256 amount;
81         uint256 endtime;
82         address user;
83         address tokenAddress;
84         string tokenSymbol;
85     }
86     
87     /**
88     * @dev safes variables
89     */
90     mapping(address => uint256[]) public _userSafes;
91     mapping(uint256 => Safe) private _safes;
92     uint256 private _currentIndex;
93     uint256 public _countSafes;
94     mapping(address => uint256) public _totalSaved;
95     
96     /**
97     * @dev owner variables
98     */
99     uint256 public comission; //0..30
100     mapping(address => uint256) private _systemReserves;    
101     address[] public _listedReserves;
102     
103     /**
104     * constructor
105     */
106     constructor() public {
107         
108         AXPRtoken = 0xC39E626A04C5971D770e319760D7926502975e47;
109         
110         hodlingTime = 365 days;
111         _currentIndex = 1;
112         comission = 5;
113     }
114     
115     /**
116     * fallback function to receive donation in eth
117     */
118     function () public payable {
119         require(msg.value > 0);
120         
121         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
122     }
123 
124     /**
125     * store the profile's hash in the blockchain
126     */
127     function storeProfileHashed(string _profileHashed) public {
128         profileHashed[msg.sender] = _profileHashed;        
129 
130         emit onStoreProfileHash(msg.sender, _profileHashed);
131     }
132     
133     /**
134     * add new hodl safe (ERC20 token)
135     */
136     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
137         require(tokenAddress != 0x0);
138         require(amount > 0);
139           
140         ERC20Interface token = ERC20Interface(tokenAddress);
141         
142         require(token.transferFrom(msg.sender, address(this), amount));
143         
144         _userSafes[msg.sender].push(_currentIndex);
145         _safes[_currentIndex] = Safe(_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol());
146         
147         _totalSaved[tokenAddress] = add(_totalSaved[tokenAddress], amount);
148         
149         _currentIndex++;
150         _countSafes++;
151         
152         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
153     }
154 
155     /**
156     * user, claim back a hodl safe
157     */
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
183         if(s.endtime < now) // hodl complete
184         {
185             PayToken(s.user, s.tokenAddress, s.amount);
186             
187             eventAmount = s.amount;
188         }
189         else // hodl still in progress (penalty fee applies), not for AXPR tokens
190         {
191             uint256 realComission = mul(s.amount, comission) / 100;
192             uint256 realAmount = sub(s.amount, realComission);
193             
194             PayToken(s.user, s.tokenAddress, realAmount);
195                 
196             StoreComission(s.tokenAddress, realComission);
197             
198             eventAmount = realAmount;
199         }
200         
201         DeleteSafe(s);
202         _countSafes--;
203         
204         emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
205     }    
206     
207     /**
208     * store comission from unfinished hodl
209     */
210     function StoreComission(address tokenAddress, uint256 amount) private {
211             
212         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
213         
214         bool isNew = true;
215         for(uint256 i = 0; i < _listedReserves.length; i++) {
216             if(_listedReserves[i] == tokenAddress) {
217                 isNew = false;
218                 break;
219             }
220         }         
221         if(isNew) _listedReserves.push(tokenAddress); 
222     }    
223     
224     /**
225     * private pay token to address
226     */
227     function PayToken(address user, address tokenAddress, uint256 amount) private {
228         
229         ERC20Interface token = ERC20Interface(tokenAddress);
230         
231         require(token.balanceOf(address(this)) >= amount);
232         token.transfer(user, amount);
233     }   
234     
235     /**
236     * delete safe values in storage
237     */
238     function DeleteSafe(Safe s) private {
239         
240         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
241         delete _safes[s.id];
242         
243         uint256[] storage vector = _userSafes[msg.sender];
244         uint256 size = vector.length; 
245         for(uint256 i = 0; i < size; i++) {
246             if(vector[i] == s.id) {
247                 vector[i] = vector[size-1];
248                 vector.length--;
249                 break;
250             }
251         } 
252     }
253 
254     /**
255     * Get user's any token balance
256     */
257     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
258         require(tokenAddress != 0x0);
259         
260         for(uint256 i = 1; i < _currentIndex; i++) {            
261             Safe storage s = _safes[i];
262             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
263                 balance += s.amount;
264         }
265         return balance;
266     }
267 
268     /**
269     * Get how many safes has the user
270     */
271     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
272         return _userSafes[hodler].length;
273     }
274     
275     /**
276     * Get safes values
277     */
278     function GetSafe(uint256 _id) public view
279         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 time)
280     {
281         Safe storage s = _safes[_id];
282         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime);
283     }
284     
285     /**
286     * Get tokens reserved for the owner as commission
287     */
288     function GetTokenFees(address tokenAddress) private view returns (uint256 amount) {
289         return _systemReserves[tokenAddress];
290     }    
291     
292     /**
293     * Get contract's balance
294     */
295     function GetContractBalance() public view returns(uint256)
296     {
297         return address(this).balance;
298     }    
299     
300     /**
301     * ONLY OWNER
302     * 
303     * owner: retire hodl safe
304     */
305     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
306         require(tokenAddress != 0x0);
307         require(id != 0);
308         
309         RetireHodl(tokenAddress, id);
310     }
311     
312     /**
313     * owner: change hodling time
314     */
315     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
316         require(newHodlingDays >= 60);
317         
318         hodlingTime = newHodlingDays * 1 days;
319     }   
320     
321     /**
322     * owner: change all time high price
323     */
324     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
325         require(newAllTimeHighPrice > allTimeHighPrice);
326         
327         allTimeHighPrice = newAllTimeHighPrice;
328     }              
329 
330     /**
331     * owner: change comission value
332     */
333     function ChangeComission(uint256 newComission) onlyOwner public {
334         require(newComission <= 30);
335         
336         comission = newComission;
337     }
338     
339     /**
340     * owner: withdraw token fees by address
341     */
342     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
343         require(_systemReserves[tokenAddress] > 0);
344         
345         uint256 amount = _systemReserves[tokenAddress];
346         _systemReserves[tokenAddress] = 0;
347         
348         ERC20Interface token = ERC20Interface(tokenAddress);
349         
350         require(token.balanceOf(address(this)) >= amount);
351         token.transfer(msg.sender, amount);
352     }
353 
354     /**
355     * owner: withdraw all eth and all tokens fees
356     */
357     function WithdrawAllFees() onlyOwner public {
358         
359         // ether
360         uint256 x = _systemReserves[0x0];
361         if(x > 0 && x <= address(this).balance) {
362             _systemReserves[0x0] = 0;
363             msg.sender.transfer(_systemReserves[0x0]);
364         }
365         
366         // tokens
367         address ta;
368         ERC20Interface token;
369         for(uint256 i = 0; i < _listedReserves.length; i++) {
370             ta = _listedReserves[i];
371             if(_systemReserves[ta] > 0)
372             { 
373                 x = _systemReserves[ta];
374                 _systemReserves[ta] = 0;
375                 
376                 token = ERC20Interface(ta);
377                 token.transfer(msg.sender, x);
378             }
379         }
380         _listedReserves.length = 0; 
381     }
382     
383     /**
384     * owner: withdraw ether received through fallback function
385     */
386     function WithdrawEth(uint256 amount) onlyOwner public {
387         require(amount > 0); 
388         require(address(this).balance >= amount); 
389         
390         msg.sender.transfer(amount);
391     }
392 
393     /**
394     * owner: returns all tokens addresses with fees
395     */    
396     function GetTokensAddressesWithFees() 
397         onlyOwner public view 
398         returns (address[], string[], uint256[])
399     {
400         uint256 length = _listedReserves.length;
401         
402         address[] memory tokenAddress = new address[](length);
403         string[] memory tokenSymbol = new string[](length);
404         uint256[] memory tokenFees = new uint256[](length);
405         
406         for (uint256 i = 0; i < length; i++) {
407     
408             tokenAddress[i] = _listedReserves[i];
409             
410             ERC20Interface token = ERC20Interface(tokenAddress[i]);
411             
412             tokenSymbol[i] = token.symbol();
413             tokenFees[i] = GetTokenFees(tokenAddress[i]);
414         }
415         
416         return (tokenAddress, tokenSymbol, tokenFees);
417     }
418 
419     /**
420     * owner: return all tokens to their respective addresses
421     */
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
434                     PayToken(s.user, s.tokenAddress, s.amount);
435                     DeleteSafe(s);
436                     
437                     _countSafes--;
438                     returned++;
439                 }
440             }
441         }
442 
443         emit onReturnAll(returned);
444     }    
445 
446 
447     /**
448     * SAFE MATH FUNCTIONS
449     * 
450     * @dev Multiplies two numbers, throws on overflow.
451     */
452     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
453         if (a == 0) {
454             return 0;
455         }
456         c = a * b;
457         assert(c / a == b);
458         return c;
459     }
460     
461     /**
462     * @dev Integer division of two numbers, truncating the quotient.
463     */
464     function div(uint256 a, uint256 b) internal pure returns (uint256) {
465         // assert(b > 0); // Solidity automatically throws when dividing by 0
466         // uint256 c = a / b;
467         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
468         return a / b;
469     }
470     
471     /**
472     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
473     */
474     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
475         assert(b <= a);
476         return a - b;
477     }
478     
479     /**
480     * @dev Adds two numbers, throws on overflow.
481     */
482     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
483         c = a + b;
484         assert(c >= a);
485         return c;
486     }
487     
488 }
489 
490 contract ERC20Interface {
491     /* This is a slight change to the ERC20 base standard.
492     function totalSupply() constant returns (uint256 supply);
493     is replaced with:
494     uint256 public totalSupply;
495     This automatically creates a getter function for the totalSupply.
496     This is moved to the base contract since public getter functions are not
497     currently recognised as an implementation of the matching abstract
498     function by the compiler.
499     */
500     // total amount of tokens
501     uint256 public totalSupply;
502     
503     //How many decimals to show.
504     uint256 public decimals;
505     
506     // token symbol
507     function symbol() public view returns (string);
508     
509     /// @param _owner The address from which the balance will be retrieved
510     /// @return The balance
511     function balanceOf(address _owner) public view returns (uint256 balance);
512 
513     /// @notice send `_value` token to `_to` from `msg.sender`
514     /// @param _to The address of the recipient
515     /// @param _value The amount of token to be transferred
516     /// @return Whether the transfer was successful or not
517     function transfer(address _to, uint256 _value) public returns (bool success);
518 
519     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
520     /// @param _from The address of the sender
521     /// @param _to The address of the recipient
522     /// @param _value The amount of token to be transferred
523     /// @return Whether the transfer was successful or not
524     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
525 
526     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
527     /// @param _spender The address of the account able to transfer the tokens
528     /// @param _value The amount of tokens to be approved for transfer
529     /// @return Whether the approval was successful or not
530     function approve(address _spender, uint256 _value) public returns (bool success);
531 
532     /// @param _owner The address of the account owning tokens
533     /// @param _spender The address of the account able to transfer the tokens
534     /// @return Amount of remaining tokens allowed to spent
535     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
536 
537     // solhint-disable-next-line no-simple-event-func-name  
538     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
539     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
540 }