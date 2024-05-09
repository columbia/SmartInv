1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4 
5     address public owner;
6 
7     function Owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function setOwner(address _newOwner) onlyOwner {
17         owner = _newOwner;
18     }
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal constant returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal constant returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 
50   function toUINT112(uint256 a) internal constant returns(uint112) {
51     assert(uint112(a) == a);
52     return uint112(a);
53   }
54 
55   function toUINT120(uint256 a) internal constant returns(uint120) {
56     assert(uint120(a) == a);
57     return uint120(a);
58   }
59 
60   function toUINT128(uint256 a) internal constant returns(uint128) {
61     assert(uint128(a) == a);
62     return uint128(a);
63   }
64 }
65 
66 
67 // Abstract contract for the full ERC 20 Token standard
68 // https://github.com/ethereum/EIPs/issues/20
69 
70 contract Token {
71     /* This is a slight change to the ERC20 base standard.
72     function totalSupply() constant returns (uint256 supply);
73     is replaced with:
74     uint256 public totalSupply;
75     This automatically creates a getter function for the totalSupply.
76     This is moved to the base contract since public getter functions are not
77     currently recognised as an implementation of the matching abstract
78     function by the compiler.
79     */
80     /// total amount of tokens
81     //uint256 public totalSupply;
82     function totalSupply() constant returns (uint256 supply);
83 
84     /// @param _owner The address from which the balance will be retrieved
85     /// @return The balance
86     function balanceOf(address _owner) constant returns (uint256 balance);
87 
88     /// @notice send `_value` token to `_to` from `msg.sender`
89     /// @param _to The address of the recipient
90     /// @param _value The amount of token to be transferred
91     /// @return Whether the transfer was successful or not
92     function transfer(address _to, uint256 _value) returns (bool success);
93 
94     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
95     /// @param _from The address of the sender
96     /// @param _to The address of the recipient
97     /// @param _value The amount of token to be transferred
98     /// @return Whether the transfer was successful or not
99     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
100 
101     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
102     /// @param _spender The address of the account able to transfer the tokens
103     /// @param _value The amount of wei to be approved for transfer
104     /// @return Whether the approval was successful or not
105     function approve(address _spender, uint256 _value) returns (bool success);
106 
107     /// @param _owner The address of the account owning tokens
108     /// @param _spender The address of the account able to transfer the tokens
109     /// @return Amount of remaining tokens allowed to spent
110     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
111 
112     event Transfer(address indexed _from, address indexed _to, uint256 _value);
113     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
114 }
115 
116 
117 /// VEN token, ERC20 compliant
118 contract VEN is Token, Owned {
119     using SafeMath for uint256;
120 
121     string public constant name    = "VeChain Token";  //The Token's name
122     uint8 public constant decimals = 18;               //Number of decimals of the smallest unit
123     string public constant symbol  = "VEN";            //An identifier    
124 
125     // packed to 256bit to save gas usage.
126     struct Supplies {
127         // uint128's max value is about 3e38.
128         // it's enough to present amount of tokens
129         uint128 total;
130         uint128 rawTokens;
131     }
132 
133     Supplies supplies;
134 
135     // Packed to 256bit to save gas usage.    
136     struct Account {
137         // uint112's max value is about 5e33.
138         // it's enough to present amount of tokens
139         uint112 balance;
140 
141         // raw token can be transformed into balance with bonus        
142         uint112 rawTokens;
143 
144         // safe to store timestamp
145         uint32 lastMintedTimestamp;
146     }
147 
148     // Balances for each account
149     mapping(address => Account) accounts;
150 
151     // Owner of account approves the transfer of an amount to another account
152     mapping(address => mapping(address => uint256)) allowed;
153 
154     // bonus that can be shared by raw tokens
155     uint256 bonusOffered;
156 
157     // Constructor
158     function VEN() {
159     }
160 
161     function totalSupply() constant returns (uint256 supply){
162         return supplies.total;
163     }
164 
165     // Send back ether sent to me
166     function () {
167         revert();
168     }
169 
170     // If sealed, transfer is enabled and mint is disabled
171     function isSealed() constant returns (bool) {
172         return owner == 0;
173     }
174 
175     function lastMintedTimestamp(address _owner) constant returns(uint32) {
176         return accounts[_owner].lastMintedTimestamp;
177     }
178 
179     // Claim bonus by raw tokens
180     function claimBonus(address _owner) internal{      
181         require(isSealed());
182         if (accounts[_owner].rawTokens != 0) {
183             uint256 realBalance = balanceOf(_owner);
184             uint256 bonus = realBalance
185                 .sub(accounts[_owner].balance)
186                 .sub(accounts[_owner].rawTokens);
187 
188             accounts[_owner].balance = realBalance.toUINT112();
189             accounts[_owner].rawTokens = 0;
190             if(bonus > 0){
191                 Transfer(this, _owner, bonus);
192             }
193         }
194     }
195 
196     // What is the balance of a particular account?
197     function balanceOf(address _owner) constant returns (uint256 balance) {
198         if (accounts[_owner].rawTokens == 0)
199             return accounts[_owner].balance;
200 
201         if (bonusOffered > 0) {
202             uint256 bonus = bonusOffered
203                  .mul(accounts[_owner].rawTokens)
204                  .div(supplies.rawTokens);
205 
206             return bonus.add(accounts[_owner].balance)
207                     .add(accounts[_owner].rawTokens);
208         }
209         
210         return uint256(accounts[_owner].balance)
211             .add(accounts[_owner].rawTokens);
212     }
213 
214     // Transfer the balance from owner's account to another account
215     function transfer(address _to, uint256 _amount) returns (bool success) {
216         require(isSealed());
217 
218         // implicitly claim bonus for both sender and receiver
219         claimBonus(msg.sender);
220         claimBonus(_to);
221 
222         // according to VEN's total supply, never overflow here
223         if (accounts[msg.sender].balance >= _amount
224             && _amount > 0) {            
225             accounts[msg.sender].balance -= uint112(_amount);
226             accounts[_to].balance = _amount.add(accounts[_to].balance).toUINT112();
227             Transfer(msg.sender, _to, _amount);
228             return true;
229         } else {
230             return false;
231         }
232     }
233 
234     // Send _value amount of tokens from address _from to address _to
235     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
236     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
237     // fees in sub-currencies; the command should fail unless the _from account has
238     // deliberately authorized the sender of the message via some mechanism; we propose
239     // these standardized APIs for approval:
240     function transferFrom(
241         address _from,
242         address _to,
243         uint256 _amount
244     ) returns (bool success) {
245         require(isSealed());
246 
247         // implicitly claim bonus for both sender and receiver
248         claimBonus(_from);
249         claimBonus(_to);
250 
251         // according to VEN's total supply, never overflow here
252         if (accounts[_from].balance >= _amount
253             && allowed[_from][msg.sender] >= _amount
254             && _amount > 0) {
255             accounts[_from].balance -= uint112(_amount);
256             allowed[_from][msg.sender] -= _amount;
257             accounts[_to].balance = _amount.add(accounts[_to].balance).toUINT112();
258             Transfer(_from, _to, _amount);
259             return true;
260         } else {
261             return false;
262         }
263     }
264 
265     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
266     // If this function is called again it overwrites the current allowance with _value.
267     function approve(address _spender, uint256 _amount) returns (bool success) {
268         allowed[msg.sender][_spender] = _amount;
269         Approval(msg.sender, _spender, _amount);
270         return true;
271     }
272 
273     /* Approves and then calls the receiving contract */
274     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
275         allowed[msg.sender][_spender] = _value;
276         Approval(msg.sender, _spender, _value);
277 
278         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
279         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
280         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
281         //if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
282         ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData);
283         return true;
284     }
285 
286     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
287         return allowed[_owner][_spender];
288     }
289 
290     // Mint tokens and assign to some one
291     function mint(address _owner, uint256 _amount, bool _isRaw, uint32 timestamp) onlyOwner{
292         if (_isRaw) {
293             accounts[_owner].rawTokens = _amount.add(accounts[_owner].rawTokens).toUINT112();
294             supplies.rawTokens = _amount.add(supplies.rawTokens).toUINT128();
295         } else {
296             accounts[_owner].balance = _amount.add(accounts[_owner].balance).toUINT112();
297         }
298 
299         accounts[_owner].lastMintedTimestamp = timestamp;
300 
301         supplies.total = _amount.add(supplies.total).toUINT128();
302         Transfer(0, _owner, _amount);
303     }
304     
305     // Offer bonus to raw tokens holder
306     function offerBonus(uint256 _bonus) onlyOwner { 
307         bonusOffered = bonusOffered.add(_bonus);
308         supplies.total = _bonus.add(supplies.total).toUINT128();
309         Transfer(0, this, _bonus);
310     }
311 
312     // Set owner to zero address, to disable mint, and enable token transfer
313     function seal() onlyOwner {
314         setOwner(0);
315     }
316 }
317 
318 contract ApprovalReceiver {
319     function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData);
320 }
321 
322 
323 // Contract to sell and distribute VEN tokens
324 contract VENSale is Owned{
325 
326     /// chart of stage transition 
327     ///
328     /// deploy   initialize      startTime                            endTime                 finalize
329     ///                              | <-earlyStageLasts-> |             | <- closedStageLasts -> |
330     ///  O-----------O---------------O---------------------O-------------O------------------------O------------>
331     ///     Created     Initialized           Early             Normal             Closed            Finalized
332     enum Stage {
333         NotCreated,
334         Created,
335         Initialized,
336         Early,
337         Normal,
338         Closed,
339         Finalized
340     }
341 
342     using SafeMath for uint256;
343     
344     uint256 public constant totalSupply         = (10 ** 9) * (10 ** 18); // 1 billion VEN, decimals set to 18
345 
346     uint256 constant privateSupply              = totalSupply * 9 / 100;  // 9% for private ICO
347     uint256 constant commercialPlan             = totalSupply * 23 / 100; // 23% for commercial plan
348     uint256 constant reservedForTeam            = totalSupply * 5 / 100;  // 5% for team
349     uint256 constant reservedForOperations      = totalSupply * 22 / 100; // 22 for operations
350 
351     // 59%
352     uint256 public constant nonPublicSupply     = privateSupply + commercialPlan + reservedForTeam + reservedForOperations;
353     // 41%
354     uint256 public constant publicSupply = totalSupply - nonPublicSupply;
355 
356 
357     uint256 public constant officialLimit = 64371825 * (10 ** 18);
358     uint256 public constant channelsLimit = publicSupply - officialLimit;
359 
360     // packed to 256bit
361     struct SoldOut {
362         uint16 placeholder; // placeholder to make struct pre-alloced
363 
364         // amount of tokens officially sold out.
365         // max value of 120bit is about 1e36, it's enough for token amount
366         uint120 official; 
367 
368         uint120 channels; // amount of tokens sold out via channels
369     }
370 
371     SoldOut soldOut;
372     
373     uint256 constant venPerEth = 3500;  // normal exchange rate
374     uint256 constant venPerEthEarlyStage = venPerEth + venPerEth * 15 / 100;  // early stage has 15% reward
375 
376     uint constant minBuyInterval = 30 minutes; // each account can buy once in 30 minutes
377     uint constant maxBuyEthAmount = 30 ether;
378    
379     VEN ven; // VEN token contract follows ERC20 standard
380 
381     address ethVault; // the account to keep received ether
382     address venVault; // the account to keep non-public offered VEN tokens
383 
384     uint public constant startTime = 1503057600; // time to start sale
385     uint public constant endTime = 1504180800;   // tiem to close sale
386     uint public constant earlyStageLasts = 3 days; // early bird stage lasts in seconds
387 
388     bool initialized;
389     bool finalized;
390 
391     function VENSale() {
392         soldOut.placeholder = 1;
393     }    
394 
395     /// @notice calculte exchange rate according to current stage
396     /// @return exchange rate. zero if not in sale.
397     function exchangeRate() constant returns (uint256){
398         if (stage() == Stage.Early) {
399             return venPerEthEarlyStage;
400         }
401         if (stage() == Stage.Normal) {
402             return venPerEth;
403         }
404         return 0;
405     }
406 
407     /// @notice for test purpose
408     function blockTime() constant returns (uint32) {
409         return uint32(block.timestamp);
410     }
411 
412     /// @notice estimate stage
413     /// @return current stage
414     function stage() constant returns (Stage) { 
415         if (finalized) {
416             return Stage.Finalized;
417         }
418 
419         if (!initialized) {
420             // deployed but not initialized
421             return Stage.Created;
422         }
423 
424         if (blockTime() < startTime) {
425             // not started yet
426             return Stage.Initialized;
427         }
428 
429         if (uint256(soldOut.official).add(soldOut.channels) >= publicSupply) {
430             // all sold out
431             return Stage.Closed;
432         }
433 
434         if (blockTime() < endTime) {
435             // in sale            
436             if (blockTime() < startTime.add(earlyStageLasts)) {
437                 // early bird stage
438                 return Stage.Early;
439             }
440             // normal stage
441             return Stage.Normal;
442         }
443 
444         // closed
445         return Stage.Closed;
446     }
447 
448     function isContract(address _addr) constant internal returns(bool) {
449         uint size;
450         if (_addr == 0) return false;
451         assembly {
452             size := extcodesize(_addr)
453         }
454         return size > 0;
455     }
456 
457     /// @notice entry to buy tokens
458     function () payable {        
459         buy();
460     }
461 
462     /// @notice entry to buy tokens
463     function buy() payable {
464         // reject contract buyer to avoid breaking interval limit
465         require(!isContract(msg.sender));
466         require(msg.value >= 0.01 ether);
467 
468         uint256 rate = exchangeRate();
469         // here don't need to check stage. rate is only valid when in sale
470         require(rate > 0);
471         // each account is allowed once in minBuyInterval
472         require(blockTime() >= ven.lastMintedTimestamp(msg.sender) + minBuyInterval);
473 
474         uint256 requested;
475         // and limited to maxBuyEthAmount
476         if (msg.value > maxBuyEthAmount) {
477             requested = maxBuyEthAmount.mul(rate);
478         } else {
479             requested = msg.value.mul(rate);
480         }
481 
482         uint256 remained = officialLimit.sub(soldOut.official);
483         if (requested > remained) {
484             //exceed remained
485             requested = remained;
486         }
487 
488         uint256 ethCost = requested.div(rate);
489         if (requested > 0) {
490             ven.mint(msg.sender, requested, true, blockTime());
491             // transfer ETH to vault
492             ethVault.transfer(ethCost);
493 
494             soldOut.official = requested.add(soldOut.official).toUINT120();
495             onSold(msg.sender, requested, ethCost);        
496         }
497 
498         uint256 toReturn = msg.value.sub(ethCost);
499         if(toReturn > 0) {
500             // return over payed ETH
501             msg.sender.transfer(toReturn);
502         }        
503     }
504 
505     /// @notice returns tokens sold officially
506     function officialSold() constant returns (uint256) {
507         return soldOut.official;
508     }
509 
510     /// @notice returns tokens sold via channels
511     function channelsSold() constant returns (uint256) {
512         return soldOut.channels;
513     } 
514 
515     /// @notice manually offer tokens to channel
516     function offerToChannel(address _channelAccount, uint256 _venAmount) onlyOwner {
517         Stage stg = stage();
518         // since the settlement may be delayed, so it's allowed in closed stage
519         require(stg == Stage.Early || stg == Stage.Normal || stg == Stage.Closed);
520 
521         soldOut.channels = _venAmount.add(soldOut.channels).toUINT120();
522 
523         //should not exceed limit
524         require(soldOut.channels <= channelsLimit);
525 
526         ven.mint(
527             _channelAccount,
528             _venAmount,
529             true,  // unsold tokens can be claimed by channels portion
530             blockTime()
531             );
532 
533         onSold(_channelAccount, _venAmount, 0);
534     }
535 
536     /// @notice initialize to prepare for sale
537     /// @param _ven The address VEN token contract following ERC20 standard
538     /// @param _ethVault The place to store received ETH
539     /// @param _venVault The place to store non-publicly supplied VEN tokens
540     function initialize(
541         VEN _ven,
542         address _ethVault,
543         address _venVault) onlyOwner {
544         require(stage() == Stage.Created);
545 
546         // ownership of token contract should already be this
547         require(_ven.owner() == address(this));
548 
549         require(address(_ethVault) != 0);
550         require(address(_venVault) != 0);      
551 
552         ven = _ven;
553         
554         ethVault = _ethVault;
555         venVault = _venVault;    
556         
557         ven.mint(
558             venVault,
559             reservedForTeam.add(reservedForOperations),
560             false, // team and operations reserved portion can't share unsold tokens
561             blockTime()
562         );
563 
564         ven.mint(
565             venVault,
566             privateSupply.add(commercialPlan),
567             true, // private ICO and commercial plan can share unsold tokens
568             blockTime()
569         );
570 
571         initialized = true;
572         onInitialized();
573     }
574 
575     /// @notice finalize
576     function finalize() onlyOwner {
577         // only after closed stage
578         require(stage() == Stage.Closed);       
579 
580         uint256 unsold = publicSupply.sub(soldOut.official).sub(soldOut.channels);
581 
582         if (unsold > 0) {
583             // unsold VEN as bonus
584             ven.offerBonus(unsold);        
585         }
586         ven.seal();
587 
588         finalized = true;
589         onFinalized();
590     }
591 
592     event onInitialized();
593     event onFinalized();
594 
595     event onSold(address indexed buyer, uint256 venAmount, uint256 ethCost);
596 }