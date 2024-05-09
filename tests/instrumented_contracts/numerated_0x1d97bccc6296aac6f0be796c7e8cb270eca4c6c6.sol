1 pragma solidity ^0.4.20;
2 
3 contract Owned {
4     address public owner;
5 
6     function Owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface Token {
21     function totalSupply() constant external returns (uint256);
22     
23     function transfer(address receiver, uint amount) external returns (bool success);
24     function burn(uint256 _value) external returns (bool success);
25     function startTrading() external;
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 
62 interface TokenRecipient { 
63     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
64     
65 }
66 
67 
68 interface AquaPriceOracle {
69   function getAudCentWeiPrice() external constant returns (uint);
70   function getAquaTokenAudCentsPrice() external constant returns (uint);
71   event NewPrice(uint _audCentWeiPrice, uint _aquaTokenAudCentsPrice);
72 }
73 
74 
75 /*
76 file:   LibCLL.sol
77 ver:    0.4.0
78 updated:31-Mar-2016
79 author: Darryl Morris
80 email:  o0ragman0o AT gmail.com
81 
82 A Solidity library for implementing a data indexing regime using
83 a circular linked list.
84 
85 This library provisions lookup, navigation and key/index storage
86 functionality which can be used in conjunction with an array or mapping.
87 
88 NOTICE: This library uses internal functions only and so cannot be compiled
89 and deployed independently from its calling contract.
90 
91 This software is distributed in the hope that it will be useful,
92 but WITHOUT ANY WARRANTY; without even the implied warranty of
93 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
94 See MIT Licence for further details.
95 <https://opensource.org/licenses/MIT>.
96 */
97 
98 // LibCLL using `uint` keys
99 library LibCLLu {
100 
101     string constant public VERSION = "LibCLLu 0.4.0";
102     uint constant NULL = 0;
103     uint constant HEAD = 0;
104     bool constant PREV = false;
105     bool constant NEXT = true;
106     
107     struct CLL{
108         mapping (uint => mapping (bool => uint)) cll;
109     }
110 
111     // n: node id  d: direction  r: return node id
112 
113     // Return existential state of a node. n == HEAD returns list existence.
114     function exists(CLL storage self, uint n)
115         internal
116         constant returns (bool)
117     {
118         if (self.cll[n][PREV] != HEAD || self.cll[n][NEXT] != HEAD)
119             return true;
120         if (n == HEAD)
121             return false;
122         if (self.cll[HEAD][NEXT] == n)
123             return true;
124         return false;
125     }
126     
127     // Returns the number of elements in the list
128     function sizeOf(CLL storage self) internal constant returns (uint r) {
129         uint i = step(self, HEAD, NEXT);
130         while (i != HEAD) {
131             i = step(self, i, NEXT);
132             r++;
133         }
134         return;
135     }
136 
137     // Returns the links of a node as and array
138     function getNode(CLL storage self, uint n)
139         internal  constant returns (uint[2])
140     {
141         return [self.cll[n][PREV], self.cll[n][NEXT]];
142     }
143 
144     // Returns the link of a node `n` in direction `d`.
145     function step(CLL storage self, uint n, bool d)
146         internal  constant returns (uint)
147     {
148         return self.cll[n][d];
149     }
150 
151     // Can be used before `insert` to build an ordered list
152     // `a` an existing node to search from, e.g. HEAD.
153     // `b` value to seek
154     // `r` first node beyond `b` in direction `d`
155     function seek(CLL storage self, uint a, uint b, bool d)
156         internal  constant returns (uint r)
157     {
158         r = step(self, a, d);
159         while  ((b!=r) && ((b < r) != d)) r = self.cll[r][d];
160         return;
161     }
162 
163     // Creates a bidirectional link between two nodes on direction `d`
164     function stitch(CLL storage self, uint a, uint b, bool d) internal  {
165         self.cll[b][!d] = a;
166         self.cll[a][d] = b;
167     }
168 
169     // Insert node `b` beside existing node `a` in direction `d`.
170     function insert (CLL storage self, uint a, uint b, bool d) internal  {
171         uint c = self.cll[a][d];
172         stitch (self, a, b, d);
173         stitch (self, b, c, d);
174     }
175     
176     function remove(CLL storage self, uint n) internal returns (uint) {
177         if (n == NULL) return;
178         stitch(self, self.cll[n][PREV], self.cll[n][NEXT], NEXT);
179         delete self.cll[n][PREV];
180         delete self.cll[n][NEXT];
181         return n;
182     }
183 
184     function push(CLL storage self, uint n, bool d) internal  {
185         insert(self, HEAD, n, d);
186     }
187     
188     function pop(CLL storage self, bool d) internal returns (uint) {
189         return remove(self, step(self, HEAD, d));
190     }
191 }
192 
193 // LibCLL using `int` keys
194 library LibCLLi {
195 
196     string constant public VERSION = "LibCLLi 0.4.0";
197     int constant NULL = 0;
198     int constant HEAD = 0;
199     bool constant PREV = false;
200     bool constant NEXT = true;
201     
202     struct CLL{
203         mapping (int => mapping (bool => int)) cll;
204     }
205 
206     // n: node id  d: direction  r: return node id
207 
208     // Return existential state of a node. n == HEAD returns list existence.
209     function exists(CLL storage self, int n) internal constant returns (bool) {
210         if (self.cll[n][PREV] != HEAD || self.cll[n][NEXT] != HEAD)
211             return true;
212         if (n == HEAD)
213             return false;
214         if (self.cll[HEAD][NEXT] == n)
215             return true;
216         return false;
217     }
218     // Returns the number of elements in the list
219     function sizeOf(CLL storage self) internal constant returns (uint r) {
220         int i = step(self, HEAD, NEXT);
221         while (i != HEAD) {
222             i = step(self, i, NEXT);
223             r++;
224         }
225         return;
226     }
227 
228     // Returns the links of a node as and array
229     function getNode(CLL storage self, int n)
230         internal  constant returns (int[2])
231     {
232         return [self.cll[n][PREV], self.cll[n][NEXT]];
233     }
234 
235     // Returns the link of a node `n` in direction `d`.
236     function step(CLL storage self, int n, bool d)
237         internal  constant returns (int)
238     {
239         return self.cll[n][d];
240     }
241 
242     // Can be used before `insert` to build an ordered list
243     // `a` an existing node to search from, e.g. HEAD.
244     // `b` value to seek
245     // `r` first node beyond `b` in direction `d`
246     function seek(CLL storage self, int a, int b, bool d)
247         internal  constant returns (int r)
248     {
249         r = step(self, a, d);
250         while  ((b!=r) && ((b < r) != d)) r = self.cll[r][d];
251         return;
252     }
253 
254     // Creates a bidirectional link between two nodes on direction `d`
255     function stitch(CLL storage self, int a, int b, bool d) internal  {
256         self.cll[b][!d] = a;
257         self.cll[a][d] = b;
258     }
259 
260     // Insert node `b` beside existing node `a` in direction `d`.
261     function insert (CLL storage self, int a, int b, bool d) internal  {
262         int c = self.cll[a][d];
263         stitch (self, a, b, d);
264         stitch (self, b, c, d);
265     }
266     
267     function remove(CLL storage self, int n) internal returns (int) {
268         if (n == NULL) return;
269         stitch(self, self.cll[n][PREV], self.cll[n][NEXT], NEXT);
270         delete self.cll[n][PREV];
271         delete self.cll[n][NEXT];
272         return n;
273     }
274 
275     function push(CLL storage self, int n, bool d) internal  {
276         insert(self, HEAD, n, d);
277     }
278     
279     function pop(CLL storage self, bool d) internal returns (int) {
280         return remove(self, step(self, HEAD, d));
281     }
282 }
283 
284 // LibCLL using `address` keys
285 library LibCLLa {
286 
287     string constant public VERSION = "LibCLLa 0.4.0";
288     address constant NULL = 0;
289     address constant HEAD = 0;
290     bool constant PREV = false;
291     bool constant NEXT = true;
292     
293     struct CLL{
294         mapping (address => mapping (bool => address)) cll;
295     }
296 
297     // n: node id  d: direction  r: return node id
298 
299     // Return existential state of a node. n == HEAD returns list existence.
300     function exists(CLL storage self, address n) internal constant returns (bool) {
301         if (self.cll[n][PREV] != HEAD || self.cll[n][NEXT] != HEAD)
302             return true;
303         if (n == HEAD)
304             return false;
305         if (self.cll[HEAD][NEXT] == n)
306             return true;
307         return false;
308     }
309     // Returns the number of elements in the list
310     function sizeOf(CLL storage self) internal constant returns (uint r) {
311         address i = step(self, HEAD, NEXT);
312         while (i != HEAD) {
313             i = step(self, i, NEXT);
314             r++;
315         }
316         return;
317     }
318 
319     // Returns the links of a node as and array
320     function getNode(CLL storage self, address n)
321         internal  constant returns (address[2])
322     {
323         return [self.cll[n][PREV], self.cll[n][NEXT]];
324     }
325 
326     // Returns the link of a node `n` in direction `d`.
327     function step(CLL storage self, address n, bool d)
328         internal  constant returns (address)
329     {
330         return self.cll[n][d];
331     }
332 
333     // Can be used before `insert` to build an ordered list
334     // `a` an existing node to search from, e.g. HEAD.
335     // `b` value to seek
336     // `r` first node beyond `b` in direction `d`
337     function seek(CLL storage self, address a, address b, bool d)
338         internal  constant returns (address r)
339     {
340         r = step(self, a, d);
341         while  ((b!=r) && ((b < r) != d)) r = self.cll[r][d];
342         return;
343     }
344 
345     // Creates a bidirectional link between two nodes on direction `d`
346     function stitch(CLL storage self, address a, address b, bool d) internal  {
347         self.cll[b][!d] = a;
348         self.cll[a][d] = b;
349     }
350 
351     // Insert node `b` beside existing node `a` in direction `d`.
352     function insert (CLL storage self, address a, address b, bool d) internal  {
353         address c = self.cll[a][d];
354         stitch (self, a, b, d);
355         stitch (self, b, c, d);
356     }
357     
358     function remove(CLL storage self, address n) internal returns (address) {
359         if (n == NULL) return;
360         stitch(self, self.cll[n][PREV], self.cll[n][NEXT], NEXT);
361         delete self.cll[n][PREV];
362         delete self.cll[n][NEXT];
363         return n;
364     }
365 
366     function push(CLL storage self, address n, bool d) internal  {
367         insert(self, HEAD, n, d);
368     }
369     
370     function pop(CLL storage self, bool d) internal returns (address) {
371         return remove(self, step(self, HEAD, d));
372     }
373 }
374 
375 
376 library LibHoldings {
377     using LibCLLa for LibCLLa.CLL;
378     bool constant PREV = false;
379     bool constant NEXT = true;
380 
381     struct Holding {
382         uint totalTokens;
383         uint lockedTokens;
384         uint weiBalance;
385         uint lastRewardNumber;
386     }
387     
388     struct HoldingsSet {
389         LibCLLa.CLL keys;
390         mapping (address => Holding) holdings;
391     }
392     
393     function exists(HoldingsSet storage self, address holder) internal constant returns (bool) {
394         return self.keys.exists(holder);
395     }
396     
397     function add(HoldingsSet storage self, address holder, Holding h) internal {
398         self.keys.push(holder, PREV);
399         self.holdings[holder] = h;
400     }
401     
402     function get(HoldingsSet storage self, address holder) constant internal returns (Holding storage) {
403         require(self.keys.exists(holder));
404         return self.holdings[holder];
405     }
406     
407     function remove(HoldingsSet storage self, address holder) internal {
408         require(self.keys.exists(holder));
409         delete self.holdings[holder];
410         self.keys.remove(holder);
411     }
412     
413     function firstHolder(HoldingsSet storage self) internal constant returns (address) {
414         return self.keys.step(0x0, NEXT);
415     }
416     function nextHolder(HoldingsSet storage self, address currentHolder) internal constant returns (address) {
417         return self.keys.step(currentHolder, NEXT);
418     }
419 }
420 
421 
422 library LibRedemptions {
423     using LibCLLu for LibCLLu.CLL;
424     bool constant PREV = false;
425     bool constant NEXT = true;
426 
427     struct Redemption {
428         uint256 Id;
429         address holderAddress;
430         uint256 numberOfTokens;
431     }
432     
433     struct RedemptionsQueue {
434         uint256 redemptionRequestsCounter;
435         LibCLLu.CLL keys;
436         mapping (uint => Redemption) queue;
437     }
438     
439     function exists(RedemptionsQueue storage self, uint id) internal constant returns (bool) {
440         return self.keys.exists(id);
441     }
442     
443     function add(RedemptionsQueue storage self, address holder, uint _numberOfTokens) internal returns(uint) {
444         Redemption memory r = Redemption({
445             Id: ++self.redemptionRequestsCounter,
446             holderAddress: holder, 
447             numberOfTokens: _numberOfTokens
448         });
449         self.queue[r.Id] = r;
450         self.keys.push(r.Id, PREV);
451         return r.Id;
452     }
453     
454     function get(RedemptionsQueue storage self, uint id) internal constant returns (Redemption storage) {
455         require(self.keys.exists(id));
456         return self.queue[id];
457     }
458     
459     function remove(RedemptionsQueue storage self, uint id) internal {
460         require(self.keys.exists(id));
461         delete self.queue[id];
462         self.keys.remove(id);
463     }
464     
465     function firstRedemption(RedemptionsQueue storage self) internal constant returns (uint) {
466         return self.keys.step(0x0, NEXT);
467     }
468     function nextRedemption(RedemptionsQueue storage self, uint currentId) internal constant returns (uint) {
469         return self.keys.step(currentId, NEXT);
470     }
471 }
472 
473 
474 contract AquaToken is Owned, Token {
475     
476     //imports
477     using SafeMath for uint256;
478     using LibHoldings for LibHoldings.Holding;
479     using LibHoldings for LibHoldings.HoldingsSet;
480     using LibRedemptions for LibRedemptions.Redemption;
481     using LibRedemptions for LibRedemptions.RedemptionsQueue;
482 
483     //inner types
484     struct DistributionContext {
485         uint distributionAmount;
486         uint receivedRedemptionAmount;
487         uint redemptionAmount;
488         uint tokenPriceWei;
489         uint currentRedemptionId;
490 
491         uint totalRewardAmount;
492     }
493     
494 
495     struct WindUpContext {
496         uint totalWindUpAmount;
497         uint tokenReward;
498         uint paidReward;
499         address currenHolderAddress;
500     }
501     
502     //constants
503     bool constant PREV = false;
504     bool constant NEXT = true;
505 
506     //state    
507     enum TokenStatus {
508         OnSale,
509         Trading,
510         Distributing,
511         WindingUp
512     }
513     ///Status of the token contract
514     TokenStatus public tokenStatus;
515     
516     ///Aqua Price Oracle smart contract
517     AquaPriceOracle public priceOracle;
518     LibHoldings.HoldingsSet internal holdings;
519     uint256 internal totalSupplyOfTokens;
520     LibRedemptions.RedemptionsQueue redemptionsQueue;
521     
522     ///The whole percentage number (0-100) of the total distributable profit 
523     ///amount available for token redemption in each profit distribution round
524     uint8 public redemptionPercentageOfDistribution;
525     mapping (address => mapping (address => uint256)) internal allowances;
526 
527     uint [] internal rewards;
528 
529     DistributionContext internal distCtx;
530     WindUpContext internal windUpCtx;
531     
532 
533     //ERC-20
534     ///Triggered when tokens are transferred.
535     event Transfer(address indexed _from, address indexed _to, uint256 _value);
536     ///Triggered whenever approve(address _spender, uint256 _value) is called.
537     event Approval(address indexed _owner, address indexed _spender, uint256 _value);    
538 
539     ///Token name
540     string public name;
541     ///Token symbol
542     string public symbol;
543     ///Number of decimals
544     uint8 public decimals;
545     
546     ///Returns total supply of Aqua Tokens 
547     function totalSupply() constant external returns (uint256) {
548         return totalSupplyOfTokens;
549     }
550 
551     /// Get the token balance for address _owner
552     function balanceOf(address _owner) public constant returns (uint256 balance) {
553         if (!holdings.exists(_owner))
554             return 0;
555         LibHoldings.Holding storage h = holdings.get(_owner);
556         return h.totalTokens.sub(h.lockedTokens);
557     }
558     ///Transfer the balance from owner's account to another account
559     function transfer(address _to, uint256 _value) external returns (bool success) {
560         return _transfer(msg.sender, _to, _value);
561     }
562 
563     /// Send _value amount of tokens from address _from to address _to
564     /// The transferFrom method is used for a withdraw workflow, allowing contracts to send
565     /// tokens on your behalf, for example to "deposit" to a contract address and/or to charge
566     /// fees in sub-currencies; the command should fail unless the _from account has
567     /// deliberately authorized the sender of the message via some mechanism; 
568     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
569         require(_value <= allowances[_from][msg.sender]);     // Check allowance
570         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub( _value);
571         return _transfer(_from, _to, _value);
572     }
573     
574     /// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
575     /// If this function is called again it overwrites the current allowance with _value.    
576     function approve(address _spender, uint256 _value) public returns (bool success) {
577         if (tokenStatus == TokenStatus.OnSale) {
578             require(msg.sender == owner);
579         }
580         allowances[msg.sender][_spender] = _value;
581         Approval(msg.sender, _spender, _value);
582         return true;
583     }
584     
585     
586     /// Returns the amount that _spender is allowed to withdraw from _owner account.
587     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
588         return allowances[_owner][_spender];
589     }
590     
591     
592     //custom public interface
593     
594     ///Event is fired when holder requests to redeem their tokens
595     ///@param holder Account address of token holder requesting redemption
596     ///@param _numberOfTokens Number of tokens requested
597     ///@param _requestId ID assigned to the redemption request
598     event RequestRedemption(address holder, uint256 _numberOfTokens, uint _requestId);
599     
600     ///Event is fired when holder cancels redemption request with ID = _requestId
601     ///@param holder Account address of token holder cancelling redemption request
602     ///@param _numberOfTokens Number of tokens affected
603     ///@param _requestId ID of the redemption request that was cancelled
604     event CancelRedemptionRequest(address holder, uint256 _numberOfTokens, uint256 _requestId);
605     
606     ///Event occurs when the redemption request is redeemed. 
607     ///@param holder Account address of the token holder whose tokens were redeemed
608     ///@param _requestId The ID of the redemption request
609     ///@param _numberOfTokens The number of tokens redeemed
610     ///@param amount The redeemed amount in Wei
611     event HolderRedemption(address holder, uint _requestId, uint256 _numberOfTokens, uint amount);
612 
613     ///Event occurs when profit distribution is triggered
614     ///@param amount Total amount (in Wei) available for this profit distribution round
615     event DistributionStarted(uint amount);
616     ///Event occurs when profit distribution round completes
617     ///@param redeemedAmount Total amount (in wei) redeemed in this distribution round
618     ///@param rewardedAmount Total amount rewarded as dividends in this distribution round
619     ///@param remainingAmount Any minor remaining amount (due to rounding errors) that has been distributed back to iAqua
620     event DistributionCompleted(uint redeemedAmount, uint rewardedAmount, uint remainingAmount);
621     ///Event is triggered when token holder withdraws their balance
622     ///@param holderAddress Address of the token holder account
623     ///@param amount Amount in wei that has been withdrawn
624     ///@param hasRemainingBalance True if there is still remaining balance
625     event WithdrawBalance(address holderAddress, uint amount, bool hasRemainingBalance);
626     
627     ///Occurs when contract owner (iAqua) repeatedly calls continueDistribution to progress redemption and 
628     ///dividend payments during profit distribution round
629     ///@param _continue True if the distribution hasn’t completed as yet
630     event ContinueDistribution(bool _continue);
631 
632     ///The event is fired when wind-up procedure starts
633     ///@param amount Total amount in Wei available for final distribution among token holders
634     event WindingUpStarted(uint amount);
635     
636     ///Event is triggered when smart contract transitions into Trading state when trading and token transfers is allowed
637     event StartTrading();
638     
639     ///Event is triggered when a token holders destroys their tokens
640     ///@param from Account address of the token holder
641     ///@param numberOfTokens Number of tokens burned (permanently destroyed)
642     event Burn(address indexed from, uint256 numberOfTokens);
643 
644     /// Constructor initializes the contract
645     ///@param initialSupply Initial supply of tokens
646     ///@param tokenName Display name if the token
647     ///@param tokenSymbol Token symbol
648     ///@param decimalUnits Number of decimal points for token holding display
649     ///@param _redemptionPercentageOfDistribution The whole percentage number (0-100) of the total distributable profit amount available for token redemption in each profit distribution round 
650     function AquaToken(uint256 initialSupply, 
651             string tokenName, 
652             string tokenSymbol, 
653             uint8 decimalUnits,
654             uint8 _redemptionPercentageOfDistribution,
655             address _priceOracle
656     ) public
657     {
658         totalSupplyOfTokens = initialSupply;
659         holdings.add(msg.sender, LibHoldings.Holding({
660             totalTokens : initialSupply, 
661             lockedTokens : 0,
662             lastRewardNumber : 0,
663             weiBalance : 0 
664         }));
665 
666         name = tokenName;                         // Set the name for display purposes
667         symbol = tokenSymbol;                     // Set the symbol for display purposes
668         decimals = decimalUnits;                  // Amount of decimals for display purposes
669     
670         redemptionPercentageOfDistribution = _redemptionPercentageOfDistribution;
671     
672         priceOracle = AquaPriceOracle(_priceOracle);
673         owner = msg.sender;
674         
675         tokenStatus = TokenStatus.OnSale;
676         rewards.push(0);
677     }
678     
679     ///Called by token owner enable trading with tokens
680     function startTrading() onlyOwner external {
681         require(tokenStatus == TokenStatus.OnSale);
682         tokenStatus = TokenStatus.Trading;
683         StartTrading();
684     }
685     
686     ///Token holders can call this function to request to redeem (sell back to 
687     ///the company) part or all of their tokens
688     ///@param _numberOfTokens Number of tokens to redeem
689     ///@return Redemption request ID (required in order to cancel this redemption request)
690     function requestRedemption(uint256 _numberOfTokens) public returns (uint) {
691         require(tokenStatus == TokenStatus.Trading && _numberOfTokens > 0);
692         LibHoldings.Holding storage h = holdings.get(msg.sender);
693         require(h.totalTokens.sub( h.lockedTokens) >= _numberOfTokens);                 // Check if the sender has enough
694 
695         uint redemptionId = redemptionsQueue.add(msg.sender, _numberOfTokens);
696 
697         h.lockedTokens = h.lockedTokens.add(_numberOfTokens);
698         RequestRedemption(msg.sender, _numberOfTokens, redemptionId);
699         return redemptionId;
700     }
701     
702     ///Token holders can call this function to cancel a redemption request they 
703     ///previously submitted using requestRedemption function
704     ///@param _requestId Redemption request ID
705     function cancelRedemptionRequest(uint256 _requestId) public {
706         require(tokenStatus == TokenStatus.Trading && redemptionsQueue.exists(_requestId));
707         LibRedemptions.Redemption storage r = redemptionsQueue.get(_requestId); 
708         require(r.holderAddress == msg.sender);
709 
710         LibHoldings.Holding storage h = holdings.get(msg.sender); 
711         h.lockedTokens = h.lockedTokens.sub(r.numberOfTokens);
712         uint numberOfTokens = r.numberOfTokens;
713         redemptionsQueue.remove(_requestId);
714 
715         CancelRedemptionRequest(msg.sender, numberOfTokens,  _requestId);
716     }
717     
718     ///The function is used to enumerate redemption requests. It returns the first redemption request ID.
719     ///@return First redemption request ID
720     function firstRedemptionRequest() public constant returns (uint) {
721         return redemptionsQueue.firstRedemption();
722     }
723     
724     ///The function is used to enumerate redemption requests. It returns the 
725     ///next redemption request ID following the supplied one.
726     ///@param _currentRedemptionId Current redemption request ID
727     ///@return Next redemption request ID
728     function nextRedemptionRequest(uint _currentRedemptionId) public constant returns (uint) {
729         return redemptionsQueue.nextRedemption(_currentRedemptionId);
730     }
731     
732     ///The function returns redemption request details for the supplied redemption request ID
733     ///@param _requestId Redemption request ID
734     ///@return _holderAddress Token holder account address
735     ///@return _numberOfTokens Number of tokens requested to redeem
736     function getRedemptionRequest(uint _requestId) public constant returns 
737                 (address _holderAddress, uint256 _numberOfTokens) {
738         LibRedemptions.Redemption storage r = redemptionsQueue.get(_requestId);
739         _holderAddress = r.holderAddress;
740         _numberOfTokens = r.numberOfTokens;
741     }
742     
743     ///The function is used to enumerate token holders. It returns the first 
744     ///token holder (that the enumeration starts from)
745     ///@return Account address of the first token holder
746     function firstHolder() public constant returns (address) {
747         return holdings.firstHolder();
748     }    
749     
750     ///The function is used to enumerate token holders. It returns the address 
751     ///of the next token holder given the token holder address.
752     ///@param _currentHolder Account address of the token holder
753     ///@return Account address of the next token holder
754     function nextHolder(address _currentHolder) public constant returns (address) {
755         return holdings.nextHolder(_currentHolder);
756     }
757     
758     ///The function returns token holder details given token holder account address
759     ///@param _holder Account address of a token holder
760     ///@return totalTokens Total tokens held by this token holder
761     ///@return lockedTokens The number of tokens (out of the total held but this token holder) that are locked and await redemption to be processed
762     ///@return weiBalance Wei balance of the token holder available for withdrawal.
763     function getHolding(address _holder) public constant 
764             returns (uint totalTokens, uint lockedTokens, uint weiBalance) {
765         if (!holdings.exists(_holder)) {
766             totalTokens = 0;
767             lockedTokens = 0;
768             weiBalance = 0;
769             return;
770         }
771         LibHoldings.Holding storage h = holdings.get(_holder);
772         totalTokens = h.totalTokens;
773         lockedTokens = h.lockedTokens;
774         uint stepsMade;
775         (weiBalance, stepsMade) = calcFullWeiBalance(h, 0);
776         return;
777     }
778     
779     ///Token owner calls this function to start profit distribution round
780     function startDistribuion() onlyOwner public payable {
781         require(tokenStatus == TokenStatus.Trading);
782         tokenStatus = TokenStatus.Distributing;
783         startRedemption(msg.value);
784         DistributionStarted(msg.value);
785     } 
786     
787     ///Token owner calls this function to progress profit distribution round
788     ///@param maxNumbeOfSteps Maximum number of steps in this progression
789     ///@return False in case profit distribution round has completed
790     function continueDistribution(uint maxNumbeOfSteps) public returns (bool) {
791         require(tokenStatus == TokenStatus.Distributing);
792         if (continueRedeeming(maxNumbeOfSteps)) {
793             ContinueDistribution(true);
794             return true;
795         }
796         uint tokenReward = distCtx.totalRewardAmount.div( totalSupplyOfTokens );
797         rewards.push(tokenReward);
798         uint paidReward = tokenReward.mul(totalSupplyOfTokens);
799 
800 
801         uint unusedDistributionAmount = distCtx.totalRewardAmount.sub(paidReward);
802         if (unusedDistributionAmount > 0) {
803             if (!holdings.exists(owner)) { 
804                 holdings.add(owner, LibHoldings.Holding({
805                     totalTokens : 0, 
806                     lockedTokens : 0,
807                     lastRewardNumber : rewards.length.sub(1),
808                     weiBalance : unusedDistributionAmount 
809                 }));
810             }
811             else {
812                 LibHoldings.Holding storage ownerHolding = holdings.get(owner);
813                 ownerHolding.weiBalance = ownerHolding.weiBalance.add(unusedDistributionAmount);
814             }
815         }
816         tokenStatus = TokenStatus.Trading;
817         DistributionCompleted(distCtx.receivedRedemptionAmount.sub(distCtx.redemptionAmount), 
818                             paidReward, unusedDistributionAmount);
819         ContinueDistribution(false);
820         return false;
821     }
822 
823     ///Token holder can call this function to withdraw their balance (dividend 
824     ///and redemption payments) while limiting the number of operations (in the
825     ///extremely unlikely case  when withdrawBalance function exceeds gas limit)
826     ///@param maxSteps Maximum number of steps to take while withdrawing holder balance
827     function withdrawBalanceMaxSteps(uint maxSteps) public {
828         require(holdings.exists(msg.sender));
829         LibHoldings.Holding storage h = holdings.get(msg.sender); 
830         uint updatedBalance;
831         uint stepsMade;
832         (updatedBalance, stepsMade) = calcFullWeiBalance(h, maxSteps);
833         h.weiBalance = 0;
834         h.lastRewardNumber = h.lastRewardNumber.add(stepsMade);
835         
836         bool balanceRemainig = h.lastRewardNumber < rewards.length.sub(1);
837         if (h.totalTokens == 0 && h.weiBalance == 0) 
838             holdings.remove(msg.sender);
839 
840         msg.sender.transfer(updatedBalance);
841         
842         WithdrawBalance(msg.sender, updatedBalance, balanceRemainig);
843     }
844 
845     ///Token holder can call this function to withdraw their balance (dividend 
846     ///and redemption payments) 
847     function withdrawBalance() public {
848         withdrawBalanceMaxSteps(0);
849     }
850 
851     ///Set allowance for other address and notify
852     ///Allows _spender to spend no more than _value tokens on your behalf, and then ping the contract about it
853     ///@param _spender The address authorized to spend
854     ///@param _value the max amount they can spend
855     ///@param _extraData some extra information to send to the approved contract
856     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
857         TokenRecipient spender = TokenRecipient(_spender);
858         if (approve(_spender, _value)) {
859             spender.receiveApproval(msg.sender, _value, this, _extraData);
860             return true;
861         }
862     }
863 
864     ///Token holders can call this method to permanently destroy their tokens.
865     ///WARNING: Burned tokens cannot be recovered!
866     ///@param numberOfTokens Number of tokens to burn (permanently destroy)
867     ///@return True if operation succeeds 
868     function burn(uint256 numberOfTokens) external returns (bool success) {
869         require(holdings.exists(msg.sender));
870         if (numberOfTokens == 0) {
871             Burn(msg.sender, numberOfTokens);
872             return true;
873         }
874         LibHoldings.Holding storage fromHolding = holdings.get(msg.sender);
875         require(fromHolding.totalTokens.sub(fromHolding.lockedTokens) >= numberOfTokens);                 // Check if the sender has enough
876 
877         updateWeiBalance(fromHolding, 0);    
878         fromHolding.totalTokens = fromHolding.totalTokens.sub(numberOfTokens);                         // Subtract from the sender
879         if (fromHolding.totalTokens == 0 && fromHolding.weiBalance == 0) 
880             holdings.remove(msg.sender);
881         totalSupplyOfTokens = totalSupplyOfTokens.sub(numberOfTokens);
882 
883         Burn(msg.sender, numberOfTokens);
884         return true;
885     }
886 
887     ///Token owner to call this to initiate final distribution in case of project wind-up
888     function windUp() onlyOwner public payable {
889         require(tokenStatus == TokenStatus.Trading);
890         tokenStatus = TokenStatus.WindingUp;
891         uint totalWindUpAmount = msg.value;
892     
893         uint tokenReward = msg.value.div(totalSupplyOfTokens);
894         rewards.push(tokenReward);
895         uint paidReward = tokenReward.mul(totalSupplyOfTokens);
896 
897         uint unusedWindUpAmount = totalWindUpAmount.sub(paidReward);
898         if (unusedWindUpAmount > 0) {
899             if (!holdings.exists(owner)) { 
900                 holdings.add(owner, LibHoldings.Holding({
901                     totalTokens : 0, 
902                     lockedTokens : 0,
903                     lastRewardNumber : rewards.length.sub(1),
904                     weiBalance : unusedWindUpAmount 
905                 }));
906             }
907             else {
908                 LibHoldings.Holding storage ownerHolding = holdings.get(owner);
909                 ownerHolding.weiBalance = ownerHolding.weiBalance.add(unusedWindUpAmount);
910             }
911         }
912         WindingUpStarted(msg.value);
913     }
914     //internal functions
915     function calcFullWeiBalance(LibHoldings.Holding storage holding, uint maxSteps) internal constant 
916                     returns(uint updatedBalance, uint stepsMade) {
917         uint fromRewardIdx = holding.lastRewardNumber.add(1);
918         updatedBalance = holding.weiBalance;
919         if (fromRewardIdx == rewards.length) {
920             stepsMade = 0;
921             return;
922         }
923 
924         uint toRewardIdx;
925         if (maxSteps == 0) {
926             toRewardIdx = rewards.length.sub( 1);
927         }
928         else {
929             toRewardIdx = fromRewardIdx.add( maxSteps ).sub(1);
930             if (toRewardIdx > rewards.length.sub(1)) {
931                 toRewardIdx = rewards.length.sub(1);
932             }
933         }
934         for(uint idx = fromRewardIdx; 
935                     idx <= toRewardIdx; 
936                     idx = idx.add(1)) {
937             updatedBalance = updatedBalance.add( 
938                 rewards[idx].mul( holding.totalTokens ) 
939                 );
940         }
941         stepsMade = toRewardIdx.sub( fromRewardIdx ).add( 1 );
942         return;
943     }
944     
945     function updateWeiBalance(LibHoldings.Holding storage holding, uint maxSteps) internal 
946                 returns(uint updatedBalance, uint stepsMade) {
947         (updatedBalance, stepsMade) = calcFullWeiBalance(holding, maxSteps);
948         if (stepsMade == 0)
949             return;
950         holding.weiBalance = updatedBalance;
951         holding.lastRewardNumber = holding.lastRewardNumber.add(stepsMade);
952     }
953     
954 
955     function startRedemption(uint distributionAmount) internal {
956         distCtx.distributionAmount = distributionAmount;
957         distCtx.receivedRedemptionAmount = 
958             (distCtx.distributionAmount.mul(redemptionPercentageOfDistribution)).div(100);
959         distCtx.redemptionAmount = distCtx.receivedRedemptionAmount;
960         distCtx.tokenPriceWei = priceOracle.getAquaTokenAudCentsPrice().mul(priceOracle.getAudCentWeiPrice());
961 
962         distCtx.currentRedemptionId = redemptionsQueue.firstRedemption();
963     }
964     
965     function continueRedeeming(uint maxNumbeOfSteps) internal returns (bool) {
966         uint remainingNoSteps = maxNumbeOfSteps;
967         uint currentId = distCtx.currentRedemptionId;
968         uint redemptionAmount = distCtx.redemptionAmount;
969         uint totalRedeemedTokens = 0;
970         while(currentId != 0 && redemptionAmount > 0) {
971             if (remainingNoSteps == 0) { 
972                 distCtx.currentRedemptionId = currentId;
973                 distCtx.redemptionAmount = redemptionAmount;
974                 if (totalRedeemedTokens > 0) {
975                     totalSupplyOfTokens = totalSupplyOfTokens.sub( totalRedeemedTokens );
976                 }
977                 return true;
978             }
979             if (redemptionAmount.div(distCtx.tokenPriceWei) < 1)
980                 break;
981 
982             LibRedemptions.Redemption storage r = redemptionsQueue.get(currentId);
983             LibHoldings.Holding storage holding = holdings.get(r.holderAddress);
984             uint updatedBalance;
985             uint stepsMade;
986             (updatedBalance, stepsMade) = updateWeiBalance(holding, remainingNoSteps);
987             remainingNoSteps = remainingNoSteps.sub(stepsMade);          
988             if (remainingNoSteps == 0) { 
989                 distCtx.currentRedemptionId = currentId;
990                 distCtx.redemptionAmount = redemptionAmount;
991                 if (totalRedeemedTokens > 0) {
992                     totalSupplyOfTokens = totalSupplyOfTokens.sub(totalRedeemedTokens);
993                 }
994                 return true;
995             }
996 
997             uint holderTokensToRedeem = redemptionAmount.div(distCtx.tokenPriceWei);
998             if (holderTokensToRedeem > r.numberOfTokens)
999                 holderTokensToRedeem = r.numberOfTokens;
1000 
1001             uint holderRedemption = holderTokensToRedeem.mul(distCtx.tokenPriceWei);
1002             holding.weiBalance = holding.weiBalance.add( holderRedemption );
1003 
1004             redemptionAmount = redemptionAmount.sub( holderRedemption );
1005             
1006             r.numberOfTokens = r.numberOfTokens.sub( holderTokensToRedeem );
1007             holding.totalTokens = holding.totalTokens.sub(holderTokensToRedeem);
1008             holding.lockedTokens = holding.lockedTokens.sub(holderTokensToRedeem);
1009             totalRedeemedTokens = totalRedeemedTokens.add( holderTokensToRedeem );
1010 
1011             uint nextId = redemptionsQueue.nextRedemption(currentId);
1012             HolderRedemption(r.holderAddress, currentId, holderTokensToRedeem, holderRedemption);
1013             if (r.numberOfTokens == 0) 
1014                 redemptionsQueue.remove(currentId);
1015             currentId = nextId;
1016             remainingNoSteps = remainingNoSteps.sub(1);
1017         }
1018         distCtx.currentRedemptionId = currentId;
1019         distCtx.redemptionAmount = redemptionAmount;
1020         totalSupplyOfTokens = totalSupplyOfTokens.sub(totalRedeemedTokens);
1021         distCtx.totalRewardAmount = 
1022             distCtx.distributionAmount.sub(distCtx.receivedRedemptionAmount).add(distCtx.redemptionAmount);
1023         return false;
1024     }
1025 
1026 
1027     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
1028         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
1029         if (tokenStatus == TokenStatus.OnSale) {
1030             require(_from == owner);
1031         }
1032         if (_value == 0) {
1033             Transfer(_from, _to, _value);
1034             return true;
1035         }
1036         require(holdings.exists(_from));
1037         
1038         LibHoldings.Holding storage fromHolding = holdings.get(_from);
1039         require(fromHolding.totalTokens.sub(fromHolding.lockedTokens) >= _value);                 // Check if the sender has enough
1040         
1041         if (!holdings.exists(_to)) { 
1042             holdings.add(_to, LibHoldings.Holding({
1043                 totalTokens : _value, 
1044                 lockedTokens : 0,
1045                 lastRewardNumber : rewards.length.sub(1),
1046                 weiBalance : 0 
1047             }));
1048         }
1049         else {
1050             LibHoldings.Holding storage toHolding = holdings.get(_to);
1051             require(toHolding.totalTokens.add(_value) >= toHolding.totalTokens);  // Check for overflows
1052             
1053             updateWeiBalance(toHolding, 0);    
1054             toHolding.totalTokens = toHolding.totalTokens.add(_value);                           
1055         }
1056 
1057         updateWeiBalance(fromHolding, 0);    
1058         fromHolding.totalTokens = fromHolding.totalTokens.sub(_value);                         // Subtract from the sender
1059         if (fromHolding.totalTokens == 0 && fromHolding.weiBalance == 0) 
1060             holdings.remove(_from);
1061         Transfer(_from, _to, _value);
1062         return true;
1063     }
1064     
1065 }