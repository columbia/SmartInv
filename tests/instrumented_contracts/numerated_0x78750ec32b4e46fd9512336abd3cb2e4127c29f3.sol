1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 /**
4 * 
5 * AXPR ERC20 Tokens Hodling
6 * 
7 * Copyright: © All Rights Reserved  |  Axpire 2019
8 * 
9 * Author: Gustavo Basanta
10 * 
11 */
12 contract OwnableContract {
13      
14     event onTransferOwnership(address newOwner);
15  
16     address superOwner;
17       
18     constructor() public { 
19         superOwner = msg.sender;
20     }
21     
22     modifier onlyOwner() {
23         require(msg.sender == superOwner);
24         _;
25     } 
26       
27     function viewSuperOwner() public view returns (address owner) {
28         return superOwner;
29     }
30       
31     function changeOwner(address newOwner) onlyOwner public {
32         require(newOwner != superOwner);
33         
34         superOwner = newOwner;
35         
36         emit onTransferOwnership(superOwner);
37     }
38 }
39 
40 contract BlockableContract is OwnableContract {
41     
42     event onBlockHODLs(bool status);
43  
44     bool public blockedContract;
45     
46     constructor() public { 
47         blockedContract = false;  
48     }
49     
50     modifier contractActive() {
51         require(!blockedContract);
52         _;
53     } 
54     
55     function doBlockContract() onlyOwner public {
56         blockedContract = true;
57         
58         emit onBlockHODLs(blockedContract);
59     }
60     
61     function unBlockContract() onlyOwner public {
62         blockedContract = false;
63         
64         emit onBlockHODLs(blockedContract);
65     }
66 }
67 
68 contract ERC20tokensHodl is BlockableContract {
69     
70     /**
71     * Events
72     */
73     event onStoreProfileHash(address indexed hodler, string profileHashed);
74     event onHodlTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
75     event onClaimTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
76     event onReturnAll(uint256 returned);
77 
78     /**
79     * State variables
80     */
81     address internal AXPRtoken;
82     mapping(address => string) public profileHashed;
83     uint256 public hodlingTime;
84     uint256 public allTimeHighPrice;
85 
86     struct Safe {
87         uint256 id;
88         uint256 amount;
89         uint256 endtime;
90         address user;
91         address tokenAddress;
92         string tokenSymbol;
93     }
94     
95     /**
96     * @dev safes variables
97     */
98     mapping(address => uint256[]) public _userSafes;
99     mapping(uint256 => Safe) private _safes;
100     uint256 private _currentIndex;
101     uint256 public _countSafes;
102     mapping(address => uint256) public _totalSaved;
103     
104     /**
105     * @dev owner variables
106     */
107     uint256 public comission; //0..30
108     mapping(address => uint256) private _systemReserves;    
109     address[] public _listedReserves;
110     
111     /**
112     * constructor
113     */
114     constructor() public {
115         
116         AXPRtoken = 0xC39E626A04C5971D770e319760D7926502975e47;
117         
118         hodlingTime = 365 days;
119         _currentIndex = 1;
120         comission = 5;
121     }
122     
123     /**
124     * fallback function to receive donation in eth
125     */
126     function () public payable {
127         require(msg.value > 0);
128         
129         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
130     }
131 
132     /**
133     * store the profile's hash in the blockchain
134     */
135     function storeProfileHashed(string _profileHashed) public {
136         profileHashed[msg.sender] = _profileHashed;        
137 
138         emit onStoreProfileHash(msg.sender, _profileHashed);
139     }
140     
141     /**
142     * add new hodl safe (ERC20 token)
143     */
144     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
145         require(tokenAddress != 0x0);
146         require(amount > 0);
147           
148         ERC20Interface token = ERC20Interface(tokenAddress);
149         
150         require(token.transferFrom(msg.sender, address(this), amount));
151         
152         _userSafes[msg.sender].push(_currentIndex);
153         _safes[_currentIndex] = Safe(_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol());
154         
155         _totalSaved[tokenAddress] = add(_totalSaved[tokenAddress], amount);
156         
157         _currentIndex++;
158         _countSafes++;
159         
160         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
161     }
162 
163     /**
164     * user, claim back a hodl safe
165     */
166     function ClaimTokens(address tokenAddress, uint256 id) public {
167         require(tokenAddress != 0x0);
168         require(id != 0);        
169         
170         Safe storage s = _safes[id];
171         require(s.user == msg.sender);
172         
173         RetireHodl(tokenAddress, id);
174     }
175     
176     function RetireHodl(address tokenAddress, uint256 id) private {
177 
178         Safe storage s = _safes[id];
179         
180         require(s.id != 0);
181         require(s.tokenAddress == tokenAddress);
182         require(
183                 (tokenAddress == AXPRtoken && s.endtime < now ) ||
184                     tokenAddress != AXPRtoken
185                 );
186 
187         uint256 eventAmount;
188         address eventTokenAddress = s.tokenAddress;
189         string memory eventTokenSymbol = s.tokenSymbol;
190         
191         if(s.endtime < now) // hodl complete
192         {
193             PayToken(s.user, s.tokenAddress, s.amount);
194             
195             eventAmount = s.amount;
196         }
197         else // hodl still in progress (penalty fee applies), not for AXPR tokens
198         {
199             uint256 realComission = mul(s.amount, comission) / 100;
200             uint256 realAmount = sub(s.amount, realComission);
201             
202             PayToken(s.user, s.tokenAddress, realAmount);
203                 
204             StoreComission(s.tokenAddress, realComission);
205             
206             eventAmount = realAmount;
207         }
208         
209         DeleteSafe(s);
210         _countSafes--;
211         
212         emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
213     }    
214     
215     /**
216     * store comission from unfinished hodl
217     */
218     function StoreComission(address tokenAddress, uint256 amount) private {
219             
220         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
221         
222         bool isNew = true;
223         for(uint256 i = 0; i < _listedReserves.length; i++) {
224             if(_listedReserves[i] == tokenAddress) {
225                 isNew = false;
226                 break;
227             }
228         }         
229         if(isNew) _listedReserves.push(tokenAddress); 
230     }    
231     
232     /**
233     * private pay token to address
234     */
235     function PayToken(address user, address tokenAddress, uint256 amount) private {
236         
237         ERC20Interface token = ERC20Interface(tokenAddress);
238         
239         require(token.balanceOf(address(this)) >= amount);
240         token.transfer(user, amount);
241     }   
242     
243     /**
244     * delete safe values in storage
245     */
246     function DeleteSafe(Safe s) private {
247         
248         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
249         delete _safes[s.id];
250         
251         uint256[] storage vector = _userSafes[msg.sender];
252         uint256 size = vector.length; 
253         for(uint256 i = 0; i < size; i++) {
254             if(vector[i] == s.id) {
255                 vector[i] = vector[size-1];
256                 vector.length--;
257                 break;
258             }
259         } 
260     }
261 
262     /**
263     * Get user's any token balance
264     */
265     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
266         require(tokenAddress != 0x0);
267         
268         for(uint256 i = 1; i < _currentIndex; i++) {            
269             Safe storage s = _safes[i];
270             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
271                 balance += s.amount;
272         }
273         return balance;
274     }
275 
276     /**
277     * Get how many safes has the user
278     */
279     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
280         return _userSafes[hodler].length;
281     }
282     
283     /**
284     * Get safes values
285     */
286     function GetSafe(uint256 _id) public view
287         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 time)
288     {
289         Safe storage s = _safes[_id];
290         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime);
291     }
292     
293     /**
294     * Get tokens reserved for the owner as commission
295     */
296     function GetTokenFees(address tokenAddress) private view returns (uint256 amount) {
297         return _systemReserves[tokenAddress];
298     }    
299     
300     /**
301     * Get contract's balance
302     */
303     function GetContractBalance() public view returns(uint256)
304     {
305         return address(this).balance;
306     }    
307     
308     /**
309     * ONLY OWNER
310     * 
311     * owner: retire hodl safe
312     */
313     function OwnerRetireHodl(address tokenAddress, uint256 id) public onlyOwner {
314         require(tokenAddress != 0x0);
315         require(id != 0);
316         
317         RetireHodl(tokenAddress, id);
318     }
319     
320     /**
321     * owner: change hodling time
322     */
323     function ChangeHodlingTime(uint256 newHodlingDays) onlyOwner public {
324         require(newHodlingDays >= 60);
325         
326         hodlingTime = newHodlingDays * 1 days;
327     }   
328     
329     /**
330     * owner: change all time high price
331     */
332     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) onlyOwner public {
333         require(newAllTimeHighPrice > allTimeHighPrice);
334         
335         allTimeHighPrice = newAllTimeHighPrice;
336     }              
337 
338     /**
339     * owner: change comission value
340     */
341     function ChangeComission(uint256 newComission) onlyOwner public {
342         require(newComission <= 30);
343         
344         comission = newComission;
345     }
346     
347     /**
348     * owner: withdraw token fees by address
349     */
350     function WithdrawTokenFees(address tokenAddress) onlyOwner public {
351         require(_systemReserves[tokenAddress] > 0);
352         
353         uint256 amount = _systemReserves[tokenAddress];
354         _systemReserves[tokenAddress] = 0;
355         
356         ERC20Interface token = ERC20Interface(tokenAddress);
357         
358         require(token.balanceOf(address(this)) >= amount);
359         token.transfer(msg.sender, amount);
360     }
361 
362     /**
363     * owner: withdraw all eth and all tokens fees
364     */
365     function WithdrawAllFees() onlyOwner public {
366         
367         // ether
368         uint256 x = _systemReserves[0x0];
369         if(x > 0 && x <= address(this).balance) {
370             _systemReserves[0x0] = 0;
371             msg.sender.transfer(_systemReserves[0x0]);
372         }
373         
374         // tokens
375         address ta;
376         ERC20Interface token;
377         for(uint256 i = 0; i < _listedReserves.length; i++) {
378             ta = _listedReserves[i];
379             if(_systemReserves[ta] > 0)
380             { 
381                 x = _systemReserves[ta];
382                 _systemReserves[ta] = 0;
383                 
384                 token = ERC20Interface(ta);
385                 token.transfer(msg.sender, x);
386             }
387         }
388         _listedReserves.length = 0; 
389     }
390     
391     /**
392     * owner: withdraw ether received through fallback function
393     */
394     function WithdrawEth(uint256 amount) onlyOwner public {
395         require(amount > 0); 
396         require(address(this).balance >= amount); 
397         
398         msg.sender.transfer(amount);
399     }
400 
401     /**
402     * owner: returns all tokens addresses with fees
403     */    
404     function GetTokensAddressesWithFees() 
405         onlyOwner public view 
406         returns (address[], string[], uint256[])
407     {
408         uint256 length = _listedReserves.length;
409         
410         address[] memory tokenAddress = new address[](length);
411         string[] memory tokenSymbol = new string[](length);
412         uint256[] memory tokenFees = new uint256[](length);
413         
414         for (uint256 i = 0; i < length; i++) {
415     
416             tokenAddress[i] = _listedReserves[i];
417             
418             ERC20Interface token = ERC20Interface(tokenAddress[i]);
419             
420             tokenSymbol[i] = token.symbol();
421             tokenFees[i] = GetTokenFees(tokenAddress[i]);
422         }
423         
424         return (tokenAddress, tokenSymbol, tokenFees);
425     }
426 
427     /**
428     * owner: return all tokens to their respective addresses
429     */
430     function ReturnAllTokens(bool onlyAXPR) onlyOwner public
431     {
432         uint256 returned;
433 
434         for(uint256 i = 1; i < _currentIndex; i++) {            
435             Safe storage s = _safes[i];
436             if (s.id != 0) {
437                 if (
438                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
439                     !onlyAXPR
440                     )
441                 {
442                     PayToken(s.user, s.tokenAddress, s.amount);
443                     DeleteSafe(s);
444                     
445                     _countSafes--;
446                     returned++;
447                 }
448             }
449         }
450 
451         emit onReturnAll(returned);
452     }    
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
499     /* This is a slight change to the ERC20 base standard.
500     function totalSupply() constant returns (uint256 supply);
501     is replaced with:
502     uint256 public totalSupply;
503     This automatically creates a getter function for the totalSupply.
504     This is moved to the base contract since public getter functions are not
505     currently recognised as an implementation of the matching abstract
506     function by the compiler.
507     */
508     // total amount of tokens
509     uint256 public totalSupply;
510     
511     //How many decimals to show.
512     uint256 public decimals;
513     
514     // token symbol
515     function symbol() public view returns (string);
516     
517     /// @param _owner The address from which the balance will be retrieved
518     /// @return The balance
519     function balanceOf(address _owner) public view returns (uint256 balance);
520 
521     /// @notice send `_value` token to `_to` from `msg.sender`
522     /// @param _to The address of the recipient
523     /// @param _value The amount of token to be transferred
524     /// @return Whether the transfer was successful or not
525     function transfer(address _to, uint256 _value) public returns (bool success);
526 
527     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
528     /// @param _from The address of the sender
529     /// @param _to The address of the recipient
530     /// @param _value The amount of token to be transferred
531     /// @return Whether the transfer was successful or not
532     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
533 
534     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
535     /// @param _spender The address of the account able to transfer the tokens
536     /// @param _value The amount of tokens to be approved for transfer
537     /// @return Whether the approval was successful or not
538     function approve(address _spender, uint256 _value) public returns (bool success);
539 
540     /// @param _owner The address of the account owning tokens
541     /// @param _spender The address of the account able to transfer the tokens
542     /// @return Amount of remaining tokens allowed to spent
543     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
544 
545     // solhint-disable-next-line no-simple-event-func-name  
546     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
547     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
548 }