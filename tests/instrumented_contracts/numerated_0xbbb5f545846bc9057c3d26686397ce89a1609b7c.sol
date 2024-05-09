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
21 
22 /**
23  * @title Prealloc
24  * @dev Pre-alloc storage vars, to flatten gas usage in future operations.
25  */
26 library Prealloc {
27     struct UINT256 {
28         uint256 value_;
29     }
30 
31     function set(UINT256 storage i, uint256 value) internal {
32         i.value_ = ~value;
33     }
34 
35     function get(UINT256 storage i) internal constant returns (uint256) {
36         return ~i.value_;
37     }
38 }
39 
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a * b;
48     assert(a == 0 || c / a == b);
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal constant returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   function add(uint256 a, uint256 b) internal constant returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 
72 
73 // Abstract contract for the full ERC 20 Token standard
74 // https://github.com/ethereum/EIPs/issues/20
75 
76 contract Token {
77     /* This is a slight change to the ERC20 base standard.
78     function totalSupply() constant returns (uint256 supply);
79     is replaced with:
80     uint256 public totalSupply;
81     This automatically creates a getter function for the totalSupply.
82     This is moved to the base contract since public getter functions are not
83     currently recognised as an implementation of the matching abstract
84     function by the compiler.
85     */
86     /// total amount of tokens
87     uint256 public totalSupply;
88 
89     /// @param _owner The address from which the balance will be retrieved
90     /// @return The balance
91     function balanceOf(address _owner) constant returns (uint256 balance);
92 
93     /// @notice send `_value` token to `_to` from `msg.sender`
94     /// @param _to The address of the recipient
95     /// @param _value The amount of token to be transferred
96     /// @return Whether the transfer was successful or not
97     function transfer(address _to, uint256 _value) returns (bool success);
98 
99     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
100     /// @param _from The address of the sender
101     /// @param _to The address of the recipient
102     /// @param _value The amount of token to be transferred
103     /// @return Whether the transfer was successful or not
104     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
105 
106     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
107     /// @param _spender The address of the account able to transfer the tokens
108     /// @param _value The amount of wei to be approved for transfer
109     /// @return Whether the approval was successful or not
110     function approve(address _spender, uint256 _value) returns (bool success);
111 
112     /// @param _owner The address of the account owning tokens
113     /// @param _spender The address of the account able to transfer the tokens
114     /// @return Amount of remaining tokens allowed to spent
115     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
116 
117     event Transfer(address indexed _from, address indexed _to, uint256 _value);
118     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
119 }
120 
121 
122 
123 /// VEN token, ERC20 compliant
124 contract VEN is Token, Owned {
125     using SafeMath for uint256;
126 
127     string public constant name    = "VeChain Token";  //The Token's name
128     uint8 public constant decimals = 18;               //Number of decimals of the smallest unit
129     string public constant symbol  = "VEN";            //An identifier    
130 
131     struct Account {
132         uint256 balance;
133         // raw token can be transformed into balance with bonus
134         uint256 rawTokens;
135     }
136 
137     // Balances for each account
138     mapping(address => Account) accounts;
139 
140     // Owner of account approves the transfer of an amount to another account
141     mapping(address => mapping(address => uint256)) allowed;
142 
143     // every buying will update this var. 
144     // pre-alloc to make first buying cost no much more gas than subsequent
145     using Prealloc for Prealloc.UINT256;
146     Prealloc.UINT256 rawTokensSupplied;
147 
148     // bonus that can be shared by raw tokens
149     uint256 bonusOffered;
150 
151     // Constructor
152     function VEN() {
153         rawTokensSupplied.set(0);
154     }
155 
156     // Send back ether sent to me
157     function () {
158         revert();
159     }
160 
161     // If sealed, transfer is enabled and mint is disabled
162     function isSealed() constant returns (bool) {
163         return owner == 0;
164     }
165 
166     // Claim bonus by raw tokens
167     function claimBonus(address _owner) internal{      
168         require(isSealed());
169         if (accounts[_owner].rawTokens != 0) {
170             accounts[_owner].balance = balanceOf(_owner);
171             accounts[_owner].rawTokens = 0;
172         }
173     }
174 
175     // What is the balance of a particular account?
176     function balanceOf(address _owner) constant returns (uint256 balance) {
177         if (accounts[_owner].rawTokens == 0)
178             return accounts[_owner].balance;
179 
180         if (isSealed()) {
181             uint256 bonus = 
182                  accounts[_owner].rawTokens
183                 .mul(bonusOffered)
184                 .div(rawTokensSupplied.get());
185 
186             return accounts[_owner].balance
187                     .add(accounts[_owner].rawTokens)
188                     .add(bonus);
189         }
190         
191         return accounts[_owner].balance.add(accounts[_owner].rawTokens);
192     }
193 
194     // Transfer the balance from owner's account to another account
195     function transfer(address _to, uint256 _amount) returns (bool success) {
196         require(isSealed());
197 
198         // implicitly claim bonus for both sender and receiver
199         claimBonus(msg.sender);
200         claimBonus(_to);
201 
202         if (accounts[msg.sender].balance >= _amount
203             && _amount > 0
204             && accounts[_to].balance + _amount > accounts[_to].balance) {
205             accounts[msg.sender].balance -= _amount;
206             accounts[_to].balance += _amount;
207             Transfer(msg.sender, _to, _amount);
208             return true;
209         } else {
210             return false;
211         }
212     }
213 
214     // Send _value amount of tokens from address _from to address _to
215     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
216     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
217     // fees in sub-currencies; the command should fail unless the _from account has
218     // deliberately authorized the sender of the message via some mechanism; we propose
219     // these standardized APIs for approval:
220     function transferFrom(
221         address _from,
222         address _to,
223         uint256 _amount
224     ) returns (bool success) {
225         require(isSealed());
226 
227         // implicitly claim bonus for both sender and receiver
228         claimBonus(_from);
229         claimBonus(_to);
230 
231         if (accounts[_from].balance >= _amount
232             && allowed[_from][msg.sender] >= _amount
233             && _amount > 0
234             && accounts[_to].balance + _amount > accounts[_to].balance) {
235             accounts[_from].balance -= _amount;
236             allowed[_from][msg.sender] -= _amount;
237             accounts[_to].balance += _amount;
238             Transfer(_from, _to, _amount);
239             return true;
240         } else {
241             return false;
242         }
243     }
244 
245     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
246     // If this function is called again it overwrites the current allowance with _value.
247     function approve(address _spender, uint256 _amount) returns (bool success) {
248         allowed[msg.sender][_spender] = _amount;
249         Approval(msg.sender, _spender, _amount);
250         return true;
251     }
252 
253     /* Approves and then calls the receiving contract */
254     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
255         allowed[msg.sender][_spender] = _value;
256         Approval(msg.sender, _spender, _value);
257 
258         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
259         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
260         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
261         //if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
262         ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData);
263         return true;
264     }
265 
266     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
267         return allowed[_owner][_spender];
268     }
269 
270     // Mint tokens and assign to some one
271     function mint(address _owner, uint256 _amount, bool _isRaw) onlyOwner{
272         if (_isRaw) {
273             accounts[_owner].rawTokens = accounts[_owner].rawTokens.add(_amount);
274             rawTokensSupplied.set(rawTokensSupplied.get().add(_amount));
275         } else {
276             accounts[_owner].balance = accounts[_owner].balance.add(_amount);
277         }
278 
279         totalSupply = totalSupply.add(_amount);
280         Transfer(0, _owner, _amount);
281     }
282     
283     // Offer bonus to raw tokens holder
284     function offerBonus(uint256 _bonus) onlyOwner {
285         bonusOffered = bonusOffered.add(_bonus);
286     }
287 
288     // Set owner to zero address, to disable mint, and enable token transfer
289     function seal() onlyOwner {
290         setOwner(0);
291 
292         totalSupply = totalSupply.add(bonusOffered);
293         Transfer(0, address(-1), bonusOffered);
294     }
295 }
296 
297 contract ApprovalReceiver {
298     function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData);
299 }
300 
301 
302 // Contract to sell and distribute VEN tokens
303 contract VENSale is Owned{
304 
305     /// chart of stage transition 
306     ///
307     /// deploy   initialize      startTime                            endTime                 finalize
308     ///                              | <-earlyStageLasts-> |             | <- closedStageLasts -> |
309     ///  O-----------O---------------O---------------------O-------------O------------------------O------------>
310     ///     Created     Initialized           Early             Normal             Closed            Finalized
311     enum Stage {
312         NotCreated,
313         Created,
314         Initialized,
315         Early,
316         Normal,
317         Closed,
318         Finalized
319     }
320 
321     using SafeMath for uint256;
322     
323     uint256 public constant totalSupply         = (10 ** 9) * (10 ** 18); // 1 billion VEN, decimals set to 18
324 
325     uint256 constant privateSupply              = totalSupply * 9 / 100;  // 9% for private ICO
326     uint256 constant commercialPlan             = totalSupply * 23 / 100; // 23% for commercial plan
327     uint256 constant reservedForTeam            = totalSupply * 5 / 100;  // 5% for team
328     uint256 constant reservedForOperations      = totalSupply * 22 / 100; // 22 for operations
329 
330     // 59%
331     uint256 public constant nonPublicSupply     = privateSupply + commercialPlan + reservedForTeam + reservedForOperations;
332     // 41%
333     uint256 public constant publicSupply = totalSupply - nonPublicSupply;
334 
335     uint256 public officialLimit;
336     uint256 public channelsLimit;
337 
338     using Prealloc for Prealloc.UINT256;
339     Prealloc.UINT256 officialSold_; // amount of tokens officially sold out
340 
341     uint256 public channelsSold;    // amount of tokens sold out via channels
342     
343     uint256 constant venPerEth = 3500;  // normal exchange rate
344     uint256 constant venPerEthEarlyStage = venPerEth + venPerEth * 15 / 100;  // early stage has 15% reward
345    
346     VEN ven; // VEN token contract follows ERC20 standard
347 
348     address ethVault; // the account to keep received ether
349     address venVault; // the account to keep non-public offered VEN tokens
350 
351     uint public startTime; // time to start sale
352     uint public endTime;   // tiem to close sale
353     uint public earlyStageLasts; // early bird stage lasts in seconds
354 
355     bool initialized;
356     bool finalized;
357 
358     function VENSale() {
359         officialSold_.set(0);
360     }    
361 
362     /// @notice calculte exchange rate according to current stage
363     /// @return exchange rate. zero if not in sale.
364     function exchangeRate() constant returns (uint256){
365         if (stage() == Stage.Early) {
366             return venPerEthEarlyStage;
367         }
368         if (stage() == Stage.Normal) {
369             return venPerEth;
370         }
371         return 0;
372     }
373 
374     /// @notice for test purpose
375     function blockTime() constant returns (uint) {
376         return block.timestamp;
377     }
378 
379     /// @notice estimate stage
380     /// @return current stage
381     function stage() constant returns (Stage) { 
382         if (finalized) {
383             return Stage.Finalized;
384         }
385 
386         if (!initialized) {
387             // deployed but not initialized
388             return Stage.Created;
389         }
390 
391         if (blockTime() < startTime) {
392             // not started yet
393             return Stage.Initialized;
394         }
395 
396         if (officialSold_.get().add(channelsSold) >= publicSupply) {
397             // all sold out
398             return Stage.Closed;
399         }
400 
401         if (blockTime() < endTime) {
402             // in sale            
403             if (blockTime() < startTime.add(earlyStageLasts)) {
404                 // early bird stage
405                 return Stage.Early;
406             }
407             // normal stage
408             return Stage.Normal;
409         }
410 
411         // closed
412         return Stage.Closed;
413     }
414 
415     /// @notice entry to buy tokens
416     function () payable {        
417         buy();
418     }
419 
420     /// @notice entry to buy tokens
421     function buy() payable {
422         require(msg.value >= 0.01 ether);
423 
424         uint256 rate = exchangeRate();
425         // here don't need to check stage. rate is only valid when in sale
426         require(rate > 0);
427 
428         uint256 remained = officialLimit.sub(officialSold_.get());
429         uint256 requested = msg.value.mul(rate);
430         if (requested > remained) {
431             //exceed remained
432             requested = remained;
433         }
434 
435         uint256 ethCost = requested.div(rate);
436         if (requested > 0) {
437             ven.mint(msg.sender, requested, true);
438             // transfer ETH to vault
439             ethVault.transfer(ethCost);
440 
441             officialSold_.set(officialSold_.get().add(requested));
442             onSold(msg.sender, requested, ethCost);        
443         }
444 
445         uint256 toReturn = msg.value.sub(ethCost);
446         if(toReturn > 0) {
447             // return over payed ETH
448             msg.sender.transfer(toReturn);
449         }        
450     }
451 
452     /// @notice calculate tokens sold officially
453     function officialSold() constant returns (uint256) {
454         return officialSold_.get();
455     }
456 
457     /// @notice manually offer tokens to channels
458     function offerToChannels(uint256 _venAmount) onlyOwner {
459         Stage stg = stage();
460         // since the settlement may be delayed, so it's allowed in closed stage
461         require(stg == Stage.Early || stg == Stage.Normal || stg == Stage.Closed);
462 
463         channelsSold = channelsSold.add(_venAmount);
464 
465         //should not exceed limit
466         require(channelsSold <= channelsLimit);
467 
468         ven.mint(
469             venVault,
470             _venAmount,
471             true  // unsold tokens can be claimed by channels portion
472             );
473 
474         onSold(venVault, _venAmount, 0);
475     }
476 
477     /// @notice initialize to prepare for sale
478     /// @param _ven The address VEN token contract following ERC20 standard
479     /// @param _ethVault The place to store received ETH
480     /// @param _venVault The place to store non-publicly supplied VEN tokens
481     /// @param _channelsLimit The hard limit for channels sale
482     /// @param _startTime The time when sale starts
483     /// @param _endTime The time when sale ends
484     /// @param _earlyStageLasts duration of early stage
485     function initialize(
486         VEN _ven,
487         address _ethVault,
488         address _venVault,
489         uint256 _channelsLimit,
490         uint _startTime,
491         uint _endTime,
492         uint _earlyStageLasts) onlyOwner {
493         require(stage() == Stage.Created);
494 
495         // ownership of token contract should already be this
496         require(_ven.owner() == address(this));
497 
498         require(address(_ethVault) != 0);
499         require(address(_venVault) != 0);
500 
501         require(_startTime > blockTime());
502         require(_startTime.add(_earlyStageLasts) < _endTime);        
503 
504         ven = _ven;
505         
506         ethVault = _ethVault;
507         venVault = _venVault;
508 
509         channelsLimit = _channelsLimit;
510         officialLimit = publicSupply.sub(_channelsLimit);
511 
512         startTime = _startTime;
513         endTime = _endTime;
514         earlyStageLasts = _earlyStageLasts;        
515         
516         ven.mint(
517             venVault,
518             reservedForTeam.add(reservedForOperations),
519             false // team and operations reserved portion can't share unsold tokens
520         );
521 
522         ven.mint(
523             venVault,
524             privateSupply.add(commercialPlan),
525             true // private ICO and commercial plan can share unsold tokens
526         );
527 
528         initialized = true;
529         onInitialized();
530     }
531 
532     /// @notice finalize
533     function finalize() onlyOwner {
534         // only after closed stage
535         require(stage() == Stage.Closed);       
536 
537         uint256 unsold = publicSupply.sub(officialSold_.get()).sub(channelsSold);
538 
539         if (unsold > 0) {
540             // unsold VEN as bonus
541             ven.offerBonus(unsold);        
542         }
543         ven.seal();
544 
545         finalized = true;
546         onFinalized();
547     }
548 
549     event onInitialized();
550     event onFinalized();
551 
552     event onSold(address indexed buyer, uint256 venAmount, uint256 ethCost);
553 }