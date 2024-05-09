1 pragma solidity ^0.4.13;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     function DSAuth() public {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 contract DSExec {
58     function tryExec( address target, bytes calldata, uint value)
59              internal
60              returns (bool call_ret)
61     {
62         return target.call.value(value)(calldata);
63     }
64     function exec( address target, bytes calldata, uint value)
65              internal
66     {
67         if(!tryExec(target, calldata, value)) {
68             revert();
69         }
70     }
71 
72     // Convenience aliases
73     function exec( address t, bytes c )
74         internal
75     {
76         exec(t, c, 0);
77     }
78     function exec( address t, uint256 v )
79         internal
80     {
81         bytes memory c; exec(t, c, v);
82     }
83     function tryExec( address t, bytes c )
84         internal
85         returns (bool)
86     {
87         return tryExec(t, c, 0);
88     }
89     function tryExec( address t, uint256 v )
90         internal
91         returns (bool)
92     {
93         bytes memory c; return tryExec(t, c, v);
94     }
95 }
96 
97 contract DSNote {
98     event LogNote(
99         bytes4   indexed  sig,
100         address  indexed  guy,
101         bytes32  indexed  foo,
102         bytes32  indexed  bar,
103         uint              wad,
104         bytes             fax
105     ) anonymous;
106 
107     modifier note {
108         bytes32 foo;
109         bytes32 bar;
110 
111         assembly {
112             foo := calldataload(4)
113             bar := calldataload(36)
114         }
115 
116         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
117 
118         _;
119     }
120 }
121 
122 contract DSGroup is DSExec, DSNote {
123     address[]  public  members;
124     uint       public  quorum;
125     uint       public  window;
126     uint       public  actionCount;
127 
128     mapping (uint => Action)                     public  actions;
129     mapping (uint => mapping (address => bool))  public  confirmedBy;
130     mapping (address => bool)                    public  isMember;
131 
132     // Legacy events
133     event Proposed   (uint id, bytes calldata);
134     event Confirmed  (uint id, address member);
135     event Triggered  (uint id);
136 
137     struct Action {
138         address  target;
139         bytes    calldata;
140         uint     value;
141 
142         uint     confirmations;
143         uint     deadline;
144         bool     triggered;
145     }
146 
147     function DSGroup(
148         address[]  members_,
149         uint       quorum_,
150         uint       window_
151     ) {
152         members  = members_;
153         quorum   = quorum_;
154         window   = window_;
155 
156         for (uint i = 0; i < members.length; i++) {
157             isMember[members[i]] = true;
158         }
159     }
160 
161     function memberCount() constant returns (uint) {
162         return members.length;
163     }
164 
165     function target(uint id) constant returns (address) {
166         return actions[id].target;
167     }
168     function calldata(uint id) constant returns (bytes) {
169         return actions[id].calldata;
170     }
171     function value(uint id) constant returns (uint) {
172         return actions[id].value;
173     }
174 
175     function confirmations(uint id) constant returns (uint) {
176         return actions[id].confirmations;
177     }
178     function deadline(uint id) constant returns (uint) {
179         return actions[id].deadline;
180     }
181     function triggered(uint id) constant returns (bool) {
182         return actions[id].triggered;
183     }
184 
185     function confirmed(uint id) constant returns (bool) {
186         return confirmations(id) >= quorum;
187     }
188     function expired(uint id) constant returns (bool) {
189         return now > deadline(id);
190     }
191 
192     function deposit() note payable {
193     }
194 
195     function propose(
196         address  target,
197         bytes    calldata,
198         uint     value
199     ) onlyMembers note returns (uint id) {
200         id = ++actionCount;
201 
202         actions[id].target    = target;
203         actions[id].calldata  = calldata;
204         actions[id].value     = value;
205         actions[id].deadline  = now + window;
206 
207         Proposed(id, calldata);
208     }
209 
210     function confirm(uint id) onlyMembers onlyActive(id) note {
211         assert(!confirmedBy[id][msg.sender]);
212 
213         confirmedBy[id][msg.sender] = true;
214         actions[id].confirmations++;
215 
216         Confirmed(id, msg.sender);
217     }
218 
219     function trigger(uint id) onlyMembers onlyActive(id) note {
220         assert(confirmed(id));
221 
222         actions[id].triggered = true;
223         exec(actions[id].target, actions[id].calldata, actions[id].value);
224 
225         Triggered(id);
226     }
227 
228     modifier onlyMembers {
229         assert(isMember[msg.sender]);
230         _;
231     }
232 
233     modifier onlyActive(uint id) {
234         assert(!expired(id));
235         assert(!triggered(id));
236         _;
237     }
238 
239     //------------------------------------------------------------------
240     // Legacy functions
241     //------------------------------------------------------------------
242 
243     function getInfo() constant returns (
244         uint  quorum_,
245         uint  memberCount,
246         uint  window_,
247         uint  actionCount_
248     ) {
249         return (quorum, members.length, window, actionCount);
250     }
251 
252     function getActionStatus(uint id) constant returns (
253         uint     confirmations,
254         uint     deadline,
255         bool     triggered,
256         address  target,
257         uint     value
258     ) {
259         return (
260             actions[id].confirmations,
261             actions[id].deadline,
262             actions[id].triggered,
263             actions[id].target,
264             actions[id].value
265         );
266     }
267 }
268 
269 contract DSGroupFactory is DSNote {
270     mapping (address => bool)  public  isGroup;
271 
272     function newGroup(
273         address[]  members,
274         uint       quorum,
275         uint       window
276     ) note returns (DSGroup group) {
277         group = new DSGroup(members, quorum, window);
278         isGroup[group] = true;
279     }
280 }
281 
282 contract DSMath {
283     function add(uint x, uint y) internal pure returns (uint z) {
284         require((z = x + y) >= x);
285     }
286     function sub(uint x, uint y) internal pure returns (uint z) {
287         require((z = x - y) <= x);
288     }
289     function mul(uint x, uint y) internal pure returns (uint z) {
290         require(y == 0 || (z = x * y) / y == x);
291     }
292 
293     function min(uint x, uint y) internal pure returns (uint z) {
294         return x <= y ? x : y;
295     }
296     function max(uint x, uint y) internal pure returns (uint z) {
297         return x >= y ? x : y;
298     }
299     function imin(int x, int y) internal pure returns (int z) {
300         return x <= y ? x : y;
301     }
302     function imax(int x, int y) internal pure returns (int z) {
303         return x >= y ? x : y;
304     }
305 
306     uint constant WAD = 10 ** 18;
307     uint constant RAY = 10 ** 27;
308 
309     function wmul(uint x, uint y) internal pure returns (uint z) {
310         z = add(mul(x, y), WAD / 2) / WAD;
311     }
312     function rmul(uint x, uint y) internal pure returns (uint z) {
313         z = add(mul(x, y), RAY / 2) / RAY;
314     }
315     function wdiv(uint x, uint y) internal pure returns (uint z) {
316         z = add(mul(x, WAD), y / 2) / y;
317     }
318     function rdiv(uint x, uint y) internal pure returns (uint z) {
319         z = add(mul(x, RAY), y / 2) / y;
320     }
321 
322     // This famous algorithm is called "exponentiation by squaring"
323     // and calculates x^n with x as fixed-point and n as regular unsigned.
324     //
325     // It's O(log n), instead of O(n) for naive repeated multiplication.
326     //
327     // These facts are why it works:
328     //
329     //  If n is even, then x^n = (x^2)^(n/2).
330     //  If n is odd,  then x^n = x * x^(n-1),
331     //   and applying the equation for even x gives
332     //    x^n = x * (x^2)^((n-1) / 2).
333     //
334     //  Also, EVM division is flooring and
335     //    floor[(n-1) / 2] = floor[n / 2].
336     //
337     function rpow(uint x, uint n) internal pure returns (uint z) {
338         z = n % 2 != 0 ? x : RAY;
339 
340         for (n /= 2; n != 0; n /= 2) {
341             x = rmul(x, x);
342 
343             if (n % 2 != 0) {
344                 z = rmul(z, x);
345             }
346         }
347     }
348 }
349 
350 contract DSThing is DSAuth, DSNote, DSMath {
351 
352     function S(string s) internal pure returns (bytes4) {
353         return bytes4(keccak256(s));
354     }
355 
356 }
357 
358 contract WETH9_ {
359     string public name     = "Wrapped Ether";
360     string public symbol   = "WETH";
361     uint8  public decimals = 18;
362 
363     event  Approval(address indexed src, address indexed guy, uint wad);
364     event  Transfer(address indexed src, address indexed dst, uint wad);
365     event  Deposit(address indexed dst, uint wad);
366     event  Withdrawal(address indexed src, uint wad);
367 
368     mapping (address => uint)                       public  balanceOf;
369     mapping (address => mapping (address => uint))  public  allowance;
370 
371     function() public payable {
372         deposit();
373     }
374     function deposit() public payable {
375         balanceOf[msg.sender] += msg.value;
376         Deposit(msg.sender, msg.value);
377     }
378     function withdraw(uint wad) public {
379         require(balanceOf[msg.sender] >= wad);
380         balanceOf[msg.sender] -= wad;
381         msg.sender.transfer(wad);
382         Withdrawal(msg.sender, wad);
383     }
384 
385     function totalSupply() public view returns (uint) {
386         return this.balance;
387     }
388 
389     function approve(address guy, uint wad) public returns (bool) {
390         allowance[msg.sender][guy] = wad;
391         Approval(msg.sender, guy, wad);
392         return true;
393     }
394 
395     function transfer(address dst, uint wad) public returns (bool) {
396         return transferFrom(msg.sender, dst, wad);
397     }
398 
399     function transferFrom(address src, address dst, uint wad)
400         public
401         returns (bool)
402     {
403         require(balanceOf[src] >= wad);
404 
405         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
406             require(allowance[src][msg.sender] >= wad);
407             allowance[src][msg.sender] -= wad;
408         }
409 
410         balanceOf[src] -= wad;
411         balanceOf[dst] += wad;
412 
413         Transfer(src, dst, wad);
414 
415         return true;
416     }
417 }
418 
419 interface FundInterface {
420 
421     // EVENTS
422 
423     event PortfolioContent(address[] assets, uint[] holdings, uint[] prices);
424     event RequestUpdated(uint id);
425     event Redeemed(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
426     event FeesConverted(uint atTimestamp, uint shareQuantityConverted, uint unclaimed);
427     event CalculationUpdate(uint atTimestamp, uint managementFee, uint performanceFee, uint nav, uint sharePrice, uint totalSupply);
428     event ErrorMessage(string errorMessage);
429 
430     // EXTERNAL METHODS
431     // Compliance by Investor
432     function requestInvestment(uint giveQuantity, uint shareQuantity, address investmentAsset) external;
433     function executeRequest(uint requestId) external;
434     function cancelRequest(uint requestId) external;
435     function redeemAllOwnedAssets(uint shareQuantity) external returns (bool);
436     // Administration by Manager
437     function enableInvestment(address[] ofAssets) external;
438     function disableInvestment(address[] ofAssets) external;
439     function shutDown() external;
440 
441     // PUBLIC METHODS
442     function emergencyRedeem(uint shareQuantity, address[] requestedAssets) public returns (bool success);
443     function calcSharePriceAndAllocateFees() public returns (uint);
444 
445 
446     // PUBLIC VIEW METHODS
447     // Get general information
448     function getModules() view returns (address, address, address);
449     function getLastRequestId() view returns (uint);
450     function getManager() view returns (address);
451 
452     // Get accounting information
453     function performCalculations() view returns (uint, uint, uint, uint, uint, uint, uint);
454     function calcSharePrice() view returns (uint);
455 }
456 
457 interface AssetInterface {
458     /*
459      * Implements ERC 20 standard.
460      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
461      * https://github.com/ethereum/EIPs/issues/20
462      *
463      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
464      *  https://github.com/ethereum/EIPs/issues/223
465      */
466 
467     // Events
468     event Approval(address indexed _owner, address indexed _spender, uint _value);
469 
470     // There is no ERC223 compatible Transfer event, with `_data` included.
471 
472     //ERC 223
473     // PUBLIC METHODS
474     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
475 
476     // ERC 20
477     // PUBLIC METHODS
478     function transfer(address _to, uint _value) public returns (bool success);
479     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
480     function approve(address _spender, uint _value) public returns (bool success);
481     // PUBLIC VIEW METHODS
482     function balanceOf(address _owner) view public returns (uint balance);
483     function allowance(address _owner, address _spender) public view returns (uint remaining);
484 }
485 
486 contract ERC20Interface {
487     function totalSupply() public constant returns (uint);
488     function balanceOf(address tokenOwner) public constant returns (uint balance);
489     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
490     function transfer(address to, uint tokens) public returns (bool success);
491     function approve(address spender, uint tokens) public returns (bool success);
492     function transferFrom(address from, address to, uint tokens) public returns (bool success);
493 
494     event Transfer(address indexed from, address indexed to, uint tokens);
495     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
496 }
497 
498 contract Asset is DSMath, ERC20Interface {
499 
500     // DATA STRUCTURES
501 
502     mapping (address => uint) balances;
503     mapping (address => mapping (address => uint)) allowed;
504     uint public _totalSupply;
505 
506     // PUBLIC METHODS
507 
508     /**
509      * @notice Send `_value` tokens to `_to` from `msg.sender`
510      * @dev Transfers sender's tokens to a given address
511      * @dev Similar to transfer(address, uint, bytes), but without _data parameter
512      * @param _to Address of token receiver
513      * @param _value Number of tokens to transfer
514      * @return Returns success of function call
515      */
516     function transfer(address _to, uint _value)
517         public
518         returns (bool success)
519     {
520         require(balances[msg.sender] >= _value); // sanity checks
521         require(balances[_to] + _value >= balances[_to]);
522 
523         balances[msg.sender] = sub(balances[msg.sender], _value);
524         balances[_to] = add(balances[_to], _value);
525         emit Transfer(msg.sender, _to, _value);
526         return true;
527     }
528     /// @notice Transfer `_value` tokens from `_from` to `_to` if `msg.sender` is allowed.
529     /// @notice Restriction: An account can only use this function to send to itself
530     /// @dev Allows for an approved third party to transfer tokens from one
531     /// address to another. Returns success.
532     /// @param _from Address from where tokens are withdrawn.
533     /// @param _to Address to where tokens are sent.
534     /// @param _value Number of tokens to transfer.
535     /// @return Returns success of function call.
536     function transferFrom(address _from, address _to, uint _value)
537         public
538         returns (bool)
539     {
540         require(_from != address(0));
541         require(_to != address(0));
542         require(_to != address(this));
543         require(balances[_from] >= _value);
544         require(allowed[_from][msg.sender] >= _value);
545         require(balances[_to] + _value >= balances[_to]);
546         // require(_to == msg.sender); // can only use transferFrom to send to self
547 
548         balances[_to] += _value;
549         balances[_from] -= _value;
550         allowed[_from][msg.sender] -= _value;
551 
552         emit Transfer(_from, _to, _value);
553         return true;
554     }
555 
556     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
557     /// @dev Sets approved amount of tokens for spender. Returns success.
558     /// @param _spender Address of allowed account.
559     /// @param _value Number of approved tokens.
560     /// @return Returns success of function call.
561     function approve(address _spender, uint _value) public returns (bool) {
562         require(_spender != address(0));
563 
564         allowed[msg.sender][_spender] = _value;
565         emit Approval(msg.sender, _spender, _value);
566         return true;
567     }
568 
569     // PUBLIC VIEW METHODS
570 
571     /// @dev Returns number of allowed tokens that a spender can transfer on
572     /// behalf of a token owner.
573     /// @param _owner Address of token owner.
574     /// @param _spender Address of token spender.
575     /// @return Returns remaining allowance for spender.
576     function allowance(address _owner, address _spender)
577         constant
578         public
579         returns (uint)
580     {
581         return allowed[_owner][_spender];
582     }
583 
584     /// @dev Returns number of tokens owned by the given address.
585     /// @param _owner Address of token owner.
586     /// @return Returns balance of owner.
587     function balanceOf(address _owner) constant public returns (uint) {
588         return balances[_owner];
589     }
590 
591     function totalSupply() view public returns (uint) {
592         return _totalSupply;
593     }
594 }
595 
596 interface SharesInterface {
597 
598     event Created(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
599     event Annihilated(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
600 
601     // VIEW METHODS
602 
603     function getName() view returns (bytes32);
604     function getSymbol() view returns (bytes8);
605     function getDecimals() view returns (uint);
606     function getCreationTime() view returns (uint);
607     function toSmallestShareUnit(uint quantity) view returns (uint);
608     function toWholeShareUnit(uint quantity) view returns (uint);
609 
610 }
611 
612 contract Shares is SharesInterface, Asset {
613 
614     // FIELDS
615 
616     // Constructor fields
617     bytes32 public name;
618     bytes8 public symbol;
619     uint public decimal;
620     uint public creationTime;
621 
622     // METHODS
623 
624     // CONSTRUCTOR
625 
626     /// @param _name Name these shares
627     /// @param _symbol Symbol of shares
628     /// @param _decimal Amount of decimals sharePrice is denominated in, defined to be equal as deciamls in REFERENCE_ASSET contract
629     /// @param _creationTime Timestamp of share creation
630     function Shares(bytes32 _name, bytes8 _symbol, uint _decimal, uint _creationTime) {
631         name = _name;
632         symbol = _symbol;
633         decimal = _decimal;
634         creationTime = _creationTime;
635     }
636 
637     // PUBLIC METHODS
638 
639     /**
640      * @notice Send `_value` tokens to `_to` from `msg.sender`
641      * @dev Transfers sender's tokens to a given address
642      * @dev Similar to transfer(address, uint, bytes), but without _data parameter
643      * @param _to Address of token receiver
644      * @param _value Number of tokens to transfer
645      * @return Returns success of function call
646      */
647     function transfer(address _to, uint _value)
648         public
649         returns (bool success)
650     {
651         require(balances[msg.sender] >= _value); // sanity checks
652         require(balances[_to] + _value >= balances[_to]);
653 
654         balances[msg.sender] = sub(balances[msg.sender], _value);
655         balances[_to] = add(balances[_to], _value);
656         emit Transfer(msg.sender, _to, _value);
657         return true;
658     }
659 
660     // PUBLIC VIEW METHODS
661 
662     function getName() view returns (bytes32) { return name; }
663     function getSymbol() view returns (bytes8) { return symbol; }
664     function getDecimals() view returns (uint) { return decimal; }
665     function getCreationTime() view returns (uint) { return creationTime; }
666     function toSmallestShareUnit(uint quantity) view returns (uint) { return mul(quantity, 10 ** getDecimals()); }
667     function toWholeShareUnit(uint quantity) view returns (uint) { return quantity / (10 ** getDecimals()); }
668 
669     // INTERNAL METHODS
670 
671     /// @param recipient Address the new shares should be sent to
672     /// @param shareQuantity Number of shares to be created
673     function createShares(address recipient, uint shareQuantity) internal {
674         _totalSupply = add(_totalSupply, shareQuantity);
675         balances[recipient] = add(balances[recipient], shareQuantity);
676         emit Created(msg.sender, now, shareQuantity);
677         emit Transfer(address(0), recipient, shareQuantity);
678     }
679 
680     /// @param recipient Address the new shares should be taken from when destroyed
681     /// @param shareQuantity Number of shares to be annihilated
682     function annihilateShares(address recipient, uint shareQuantity) internal {
683         _totalSupply = sub(_totalSupply, shareQuantity);
684         balances[recipient] = sub(balances[recipient], shareQuantity);
685         emit Annihilated(msg.sender, now, shareQuantity);
686         emit Transfer(recipient, address(0), shareQuantity);
687     }
688 }
689 
690 interface CompetitionInterface {
691 
692     // EVENTS
693 
694     event Register(uint withId, address fund, address manager);
695     event ClaimReward(address registrant, address fund, uint shares);
696 
697     // PRE, POST, INVARIANT CONDITIONS
698 
699     function termsAndConditionsAreSigned(address byManager, uint8 v, bytes32 r, bytes32 s) view returns (bool);
700     function isWhitelisted(address x) view returns (bool);
701     function isCompetitionActive() view returns (bool);
702 
703     // CONSTANT METHODS
704 
705     function getMelonAsset() view returns (address);
706     function getRegistrantId(address x) view returns (uint);
707     function getRegistrantFund(address x) view returns (address);
708     function getCompetitionStatusOfRegistrants() view returns (address[], address[], bool[]);
709     function getTimeTillEnd() view returns (uint);
710     function getEtherValue(uint amount) view returns (uint);
711     function calculatePayout(uint payin) view returns (uint);
712 
713     // PUBLIC METHODS
714 
715     function registerForCompetition(address fund, uint8 v, bytes32 r, bytes32 s) payable;
716     function batchAddToWhitelist(uint maxBuyinQuantity, address[] whitelistants);
717     function withdrawMln(address to, uint amount);
718     function claimReward();
719 
720 }
721 
722 interface ComplianceInterface {
723 
724     // PUBLIC VIEW METHODS
725 
726     /// @notice Checks whether investment is permitted for a participant
727     /// @param ofParticipant Address requesting to invest in a Melon fund
728     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
729     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
730     /// @return Whether identity is eligible to invest in a Melon fund.
731     function isInvestmentPermitted(
732         address ofParticipant,
733         uint256 giveQuantity,
734         uint256 shareQuantity
735     ) view returns (bool);
736 
737     /// @notice Checks whether redemption is permitted for a participant
738     /// @param ofParticipant Address requesting to redeem from a Melon fund
739     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
740     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
741     /// @return Whether identity is eligible to redeem from a Melon fund.
742     function isRedemptionPermitted(
743         address ofParticipant,
744         uint256 shareQuantity,
745         uint256 receiveQuantity
746     ) view returns (bool);
747 }
748 
749 contract DBC {
750 
751     // MODIFIERS
752 
753     modifier pre_cond(bool condition) {
754         require(condition);
755         _;
756     }
757 
758     modifier post_cond(bool condition) {
759         _;
760         assert(condition);
761     }
762 
763     modifier invariant(bool condition) {
764         require(condition);
765         _;
766         assert(condition);
767     }
768 }
769 
770 contract Owned is DBC {
771 
772     // FIELDS
773 
774     address public owner;
775 
776     // NON-CONSTANT METHODS
777 
778     function Owned() { owner = msg.sender; }
779 
780     function changeOwner(address ofNewOwner) pre_cond(isOwner()) { owner = ofNewOwner; }
781 
782     // PRE, POST, INVARIANT CONDITIONS
783 
784     function isOwner() internal returns (bool) { return msg.sender == owner; }
785 
786 }
787 
788 contract Fund is DSMath, DBC, Owned, Shares, FundInterface {
789 
790     event OrderUpdated(address exchange, bytes32 orderId, UpdateType updateType);
791 
792     // TYPES
793 
794     struct Modules { // Describes all modular parts, standardised through an interface
795         CanonicalPriceFeed pricefeed; // Provides all external data
796         ComplianceInterface compliance; // Boolean functions regarding invest/redeem
797         RiskMgmtInterface riskmgmt; // Boolean functions regarding make/take orders
798     }
799 
800     struct Calculations { // List of internal calculations
801         uint gav; // Gross asset value
802         uint managementFee; // Time based fee
803         uint performanceFee; // Performance based fee measured against QUOTE_ASSET
804         uint unclaimedFees; // Fees not yet allocated to the fund manager
805         uint nav; // Net asset value
806         uint highWaterMark; // A record of best all-time fund performance
807         uint totalSupply; // Total supply of shares
808         uint timestamp; // Time when calculations are performed in seconds
809     }
810 
811     enum UpdateType { make, take, cancel }
812     enum RequestStatus { active, cancelled, executed }
813     struct Request { // Describes and logs whenever asset enter and leave fund due to Participants
814         address participant; // Participant in Melon fund requesting investment or redemption
815         RequestStatus status; // Enum: active, cancelled, executed; Status of request
816         address requestAsset; // Address of the asset being requested
817         uint shareQuantity; // Quantity of Melon fund shares
818         uint giveQuantity; // Quantity in Melon asset to give to Melon fund to receive shareQuantity
819         uint receiveQuantity; // Quantity in Melon asset to receive from Melon fund for given shareQuantity
820         uint timestamp;     // Time of request creation in seconds
821         uint atUpdateId;    // Pricefeed updateId when this request was created
822     }
823 
824     struct Exchange {
825         address exchange;
826         address exchangeAdapter;
827         bool takesCustody;  // exchange takes custody before making order
828     }
829 
830     struct OpenMakeOrder {
831         uint id; // Order Id from exchange
832         uint expiresAt; // Timestamp when the order expires
833     }
834 
835     struct Order { // Describes an order event (make or take order)
836         address exchangeAddress; // address of the exchange this order is on
837         bytes32 orderId; // Id as returned from exchange
838         UpdateType updateType; // Enum: make, take (cancel should be ignored)
839         address makerAsset; // Order maker's asset
840         address takerAsset; // Order taker's asset
841         uint makerQuantity; // Quantity of makerAsset to be traded
842         uint takerQuantity; // Quantity of takerAsset to be traded
843         uint timestamp; // Time of order creation in seconds
844         uint fillTakerQuantity; // Quantity of takerAsset to be filled
845     }
846 
847     // FIELDS
848 
849     // Constant fields
850     uint public constant MAX_FUND_ASSETS = 20; // Max ownable assets by the fund supported by gas limits
851     uint public constant ORDER_EXPIRATION_TIME = 86400; // Make order expiration time (1 day)
852     // Constructor fields
853     uint public MANAGEMENT_FEE_RATE; // Fee rate in QUOTE_ASSET per managed seconds in WAD
854     uint public PERFORMANCE_FEE_RATE; // Fee rate in QUOTE_ASSET per delta improvement in WAD
855     address public VERSION; // Address of Version contract
856     Asset public QUOTE_ASSET; // QUOTE asset as ERC20 contract
857     // Methods fields
858     Modules public modules; // Struct which holds all the initialised module instances
859     Exchange[] public exchanges; // Array containing exchanges this fund supports
860     Calculations public atLastUnclaimedFeeAllocation; // Calculation results at last allocateUnclaimedFees() call
861     Order[] public orders;  // append-only list of makes/takes from this fund
862     mapping (address => mapping(address => OpenMakeOrder)) public exchangesToOpenMakeOrders; // exchangeIndex to: asset to open make orders
863     bool public isShutDown; // Security feature, if yes than investing, managing, allocateUnclaimedFees gets blocked
864     Request[] public requests; // All the requests this fund received from participants
865     mapping (address => bool) public isInvestAllowed; // If false, fund rejects investments from the key asset
866     address[] public ownedAssets; // List of all assets owned by the fund or for which the fund has open make orders
867     mapping (address => bool) public isInAssetList; // Mapping from asset to whether the asset exists in ownedAssets
868     mapping (address => bool) public isInOpenMakeOrder; // Mapping from asset to whether the asset is in a open make order as buy asset
869 
870     // METHODS
871 
872     // CONSTRUCTOR
873 
874     /// @dev Should only be called via Version.setupFund(..)
875     /// @param withName human-readable descriptive name (not necessarily unique)
876     /// @param ofQuoteAsset Asset against which mgmt and performance fee is measured against and which can be used to invest using this single asset
877     /// @param ofManagementFee A time based fee expressed, given in a number which is divided by 1 WAD
878     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 1 WAD
879     /// @param ofCompliance Address of compliance module
880     /// @param ofRiskMgmt Address of risk management module
881     /// @param ofPriceFeed Address of price feed module
882     /// @param ofExchanges Addresses of exchange on which this fund can trade
883     /// @param ofDefaultAssets Addresses of assets to enable invest for (quote asset is already enabled)
884     /// @return Deployed Fund with manager set as ofManager
885     function Fund(
886         address ofManager,
887         bytes32 withName,
888         address ofQuoteAsset,
889         uint ofManagementFee,
890         uint ofPerformanceFee,
891         address ofCompliance,
892         address ofRiskMgmt,
893         address ofPriceFeed,
894         address[] ofExchanges,
895         address[] ofDefaultAssets
896     )
897         Shares(withName, "MLNF", 18, now)
898     {
899         require(ofManagementFee < 10 ** 18); // Require management fee to be less than 100 percent
900         require(ofPerformanceFee < 10 ** 18); // Require performance fee to be less than 100 percent
901         isInvestAllowed[ofQuoteAsset] = true;
902         owner = ofManager;
903         MANAGEMENT_FEE_RATE = ofManagementFee; // 1 percent is expressed as 0.01 * 10 ** 18
904         PERFORMANCE_FEE_RATE = ofPerformanceFee; // 1 percent is expressed as 0.01 * 10 ** 18
905         VERSION = msg.sender;
906         modules.compliance = ComplianceInterface(ofCompliance);
907         modules.riskmgmt = RiskMgmtInterface(ofRiskMgmt);
908         modules.pricefeed = CanonicalPriceFeed(ofPriceFeed);
909         // Bridged to Melon exchange interface by exchangeAdapter library
910         for (uint i = 0; i < ofExchanges.length; ++i) {
911             require(modules.pricefeed.exchangeIsRegistered(ofExchanges[i]));
912             var (ofExchangeAdapter, takesCustody, ) = modules.pricefeed.getExchangeInformation(ofExchanges[i]);
913             exchanges.push(Exchange({
914                 exchange: ofExchanges[i],
915                 exchangeAdapter: ofExchangeAdapter,
916                 takesCustody: takesCustody
917             }));
918         }
919         QUOTE_ASSET = Asset(ofQuoteAsset);
920         // Quote Asset always in owned assets list
921         ownedAssets.push(ofQuoteAsset);
922         isInAssetList[ofQuoteAsset] = true;
923         require(address(QUOTE_ASSET) == modules.pricefeed.getQuoteAsset()); // Sanity check
924         for (uint j = 0; j < ofDefaultAssets.length; j++) {
925             require(modules.pricefeed.assetIsRegistered(ofDefaultAssets[j]));
926             isInvestAllowed[ofDefaultAssets[j]] = true;
927         }
928         atLastUnclaimedFeeAllocation = Calculations({
929             gav: 0,
930             managementFee: 0,
931             performanceFee: 0,
932             unclaimedFees: 0,
933             nav: 0,
934             highWaterMark: 10 ** getDecimals(),
935             totalSupply: _totalSupply,
936             timestamp: now
937         });
938     }
939 
940     // EXTERNAL METHODS
941 
942     // EXTERNAL : ADMINISTRATION
943 
944     /// @notice Enable investment in specified assets
945     /// @param ofAssets Array of assets to enable investment in
946     function enableInvestment(address[] ofAssets)
947         external
948         pre_cond(isOwner())
949     {
950         for (uint i = 0; i < ofAssets.length; ++i) {
951             require(modules.pricefeed.assetIsRegistered(ofAssets[i]));
952             isInvestAllowed[ofAssets[i]] = true;
953         }
954     }
955 
956     /// @notice Disable investment in specified assets
957     /// @param ofAssets Array of assets to disable investment in
958     function disableInvestment(address[] ofAssets)
959         external
960         pre_cond(isOwner())
961     {
962         for (uint i = 0; i < ofAssets.length; ++i) {
963             isInvestAllowed[ofAssets[i]] = false;
964         }
965     }
966 
967     function shutDown() external pre_cond(msg.sender == VERSION) { isShutDown = true; }
968 
969     // EXTERNAL : PARTICIPATION
970 
971     /// @notice Give melon tokens to receive shares of this fund
972     /// @dev Recommended to give some leeway in prices to account for possibly slightly changing prices
973     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
974     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
975     /// @param investmentAsset Address of asset to invest in
976     function requestInvestment(
977         uint giveQuantity,
978         uint shareQuantity,
979         address investmentAsset
980     )
981         external
982         pre_cond(!isShutDown)
983         pre_cond(isInvestAllowed[investmentAsset]) // investment using investmentAsset has not been deactivated by the Manager
984         pre_cond(modules.compliance.isInvestmentPermitted(msg.sender, giveQuantity, shareQuantity))    // Compliance Module: Investment permitted
985     {
986         requests.push(Request({
987             participant: msg.sender,
988             status: RequestStatus.active,
989             requestAsset: investmentAsset,
990             shareQuantity: shareQuantity,
991             giveQuantity: giveQuantity,
992             receiveQuantity: shareQuantity,
993             timestamp: now,
994             atUpdateId: modules.pricefeed.getLastUpdateId()
995         }));
996 
997         emit RequestUpdated(getLastRequestId());
998     }
999 
1000     /// @notice Executes active investment and redemption requests, in a way that minimises information advantages of investor
1001     /// @dev Distributes melon and shares according to the request
1002     /// @param id Index of request to be executed
1003     /// @dev Active investment or redemption request executed
1004     function executeRequest(uint id)
1005         external
1006         pre_cond(!isShutDown)
1007         pre_cond(requests[id].status == RequestStatus.active)
1008         pre_cond(
1009             _totalSupply == 0 ||
1010             (
1011                 now >= add(requests[id].timestamp, modules.pricefeed.getInterval()) &&
1012                 modules.pricefeed.getLastUpdateId() >= add(requests[id].atUpdateId, 2)
1013             )
1014         )   // PriceFeed Module: Wait at least one interval time and two updates before continuing (unless it is the first investment)
1015 
1016     {
1017         Request request = requests[id];
1018         var (isRecent, , ) =
1019             modules.pricefeed.getPriceInfo(address(request.requestAsset));
1020         require(isRecent);
1021 
1022         // sharePrice quoted in QUOTE_ASSET and multiplied by 10 ** fundDecimals
1023         uint costQuantity = toWholeShareUnit(mul(request.shareQuantity, calcSharePriceAndAllocateFees())); // By definition quoteDecimals == fundDecimals
1024         if (request.requestAsset != address(QUOTE_ASSET)) {
1025             var (isPriceRecent, invertedRequestAssetPrice, requestAssetDecimal) = modules.pricefeed.getInvertedPriceInfo(request.requestAsset);
1026             if (!isPriceRecent) {
1027                 revert();
1028             }
1029             costQuantity = mul(costQuantity, invertedRequestAssetPrice) / 10 ** requestAssetDecimal;
1030         }
1031 
1032         if (
1033             isInvestAllowed[request.requestAsset] &&
1034             costQuantity <= request.giveQuantity
1035         ) {
1036             request.status = RequestStatus.executed;
1037             require(AssetInterface(request.requestAsset).transferFrom(request.participant, address(this), costQuantity)); // Allocate Value
1038             createShares(request.participant, request.shareQuantity); // Accounting
1039             if (!isInAssetList[request.requestAsset]) {
1040                 ownedAssets.push(request.requestAsset);
1041                 isInAssetList[request.requestAsset] = true;
1042             }
1043         } else {
1044             revert(); // Invalid Request or invalid giveQuantity / receiveQuantity
1045         }
1046     }
1047 
1048     /// @notice Cancels active investment and redemption requests
1049     /// @param id Index of request to be executed
1050     function cancelRequest(uint id)
1051         external
1052         pre_cond(requests[id].status == RequestStatus.active) // Request is active
1053         pre_cond(requests[id].participant == msg.sender || isShutDown) // Either request creator or fund is shut down
1054     {
1055         requests[id].status = RequestStatus.cancelled;
1056     }
1057 
1058     /// @notice Redeems by allocating an ownership percentage of each asset to the participant
1059     /// @dev Independent of running price feed!
1060     /// @param shareQuantity Number of shares owned by the participant, which the participant would like to redeem for individual assets
1061     /// @return Whether all assets sent to shareholder or not
1062     function redeemAllOwnedAssets(uint shareQuantity)
1063         external
1064         returns (bool success)
1065     {
1066         return emergencyRedeem(shareQuantity, ownedAssets);
1067     }
1068 
1069     // EXTERNAL : MANAGING
1070 
1071     /// @notice Universal method for calling exchange functions through adapters
1072     /// @notice See adapter contracts for parameters needed for each exchange
1073     /// @param exchangeIndex Index of the exchange in the "exchanges" array
1074     /// @param method Signature of the adapter method to call (as per ABI spec)
1075     /// @param orderAddresses [0] Order maker
1076     /// @param orderAddresses [1] Order taker
1077     /// @param orderAddresses [2] Order maker asset
1078     /// @param orderAddresses [3] Order taker asset
1079     /// @param orderAddresses [4] Fee recipient
1080     /// @param orderValues [0] Maker token quantity
1081     /// @param orderValues [1] Taker token quantity
1082     /// @param orderValues [2] Maker fee
1083     /// @param orderValues [3] Taker fee
1084     /// @param orderValues [4] Timestamp (seconds)
1085     /// @param orderValues [5] Salt/nonce
1086     /// @param orderValues [6] Fill amount: amount of taker token to be traded
1087     /// @param orderValues [7] Dexy signature mode
1088     /// @param identifier Order identifier
1089     /// @param v ECDSA recovery id
1090     /// @param r ECDSA signature output r
1091     /// @param s ECDSA signature output s
1092     function callOnExchange(
1093         uint exchangeIndex,
1094         bytes4 method,
1095         address[5] orderAddresses,
1096         uint[8] orderValues,
1097         bytes32 identifier,
1098         uint8 v,
1099         bytes32 r,
1100         bytes32 s
1101     )
1102         external
1103     {
1104         require(modules.pricefeed.exchangeMethodIsAllowed(
1105             exchanges[exchangeIndex].exchange, method
1106         ));
1107         require((exchanges[exchangeIndex].exchangeAdapter).delegatecall(
1108             method, exchanges[exchangeIndex].exchange,
1109             orderAddresses, orderValues, identifier, v, r, s
1110         ));
1111     }
1112 
1113     function addOpenMakeOrder(
1114         address ofExchange,
1115         address ofSellAsset,
1116         uint orderId
1117     )
1118         pre_cond(msg.sender == address(this))
1119     {
1120         isInOpenMakeOrder[ofSellAsset] = true;
1121         exchangesToOpenMakeOrders[ofExchange][ofSellAsset].id = orderId;
1122         exchangesToOpenMakeOrders[ofExchange][ofSellAsset].expiresAt = add(now, ORDER_EXPIRATION_TIME);
1123     }
1124 
1125     function removeOpenMakeOrder(
1126         address ofExchange,
1127         address ofSellAsset
1128     )
1129         pre_cond(msg.sender == address(this))
1130     {
1131         delete exchangesToOpenMakeOrders[ofExchange][ofSellAsset];
1132     }
1133 
1134     function orderUpdateHook(
1135         address ofExchange,
1136         bytes32 orderId,
1137         UpdateType updateType,
1138         address[2] orderAddresses, // makerAsset, takerAsset
1139         uint[3] orderValues        // makerQuantity, takerQuantity, fillTakerQuantity (take only)
1140     )
1141         pre_cond(msg.sender == address(this))
1142     {
1143         // only save make/take
1144         if (updateType == UpdateType.make || updateType == UpdateType.take) {
1145             orders.push(Order({
1146                 exchangeAddress: ofExchange,
1147                 orderId: orderId,
1148                 updateType: updateType,
1149                 makerAsset: orderAddresses[0],
1150                 takerAsset: orderAddresses[1],
1151                 makerQuantity: orderValues[0],
1152                 takerQuantity: orderValues[1],
1153                 timestamp: block.timestamp,
1154                 fillTakerQuantity: orderValues[2]
1155             }));
1156         }
1157         emit OrderUpdated(ofExchange, orderId, updateType);
1158     }
1159 
1160     // PUBLIC METHODS
1161 
1162     // PUBLIC METHODS : ACCOUNTING
1163 
1164     /// @notice Calculates gross asset value of the fund
1165     /// @dev Decimals in assets must be equal to decimals in PriceFeed for all entries in AssetRegistrar
1166     /// @dev Assumes that module.pricefeed.getPriceInfo(..) returns recent prices
1167     /// @return gav Gross asset value quoted in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1168     function calcGav() returns (uint gav) {
1169         // prices quoted in QUOTE_ASSET and multiplied by 10 ** assetDecimal
1170         uint[] memory allAssetHoldings = new uint[](ownedAssets.length);
1171         uint[] memory allAssetPrices = new uint[](ownedAssets.length);
1172         address[] memory tempOwnedAssets;
1173         tempOwnedAssets = ownedAssets;
1174         delete ownedAssets;
1175         for (uint i = 0; i < tempOwnedAssets.length; ++i) {
1176             address ofAsset = tempOwnedAssets[i];
1177             // assetHoldings formatting: mul(exchangeHoldings, 10 ** assetDecimal)
1178             uint assetHoldings = add(
1179                 uint(AssetInterface(ofAsset).balanceOf(address(this))), // asset base units held by fund
1180                 quantityHeldInCustodyOfExchange(ofAsset)
1181             );
1182             // assetPrice formatting: mul(exchangePrice, 10 ** assetDecimal)
1183             var (isRecent, assetPrice, assetDecimals) = modules.pricefeed.getPriceInfo(ofAsset);
1184             if (!isRecent) {
1185                 revert();
1186             }
1187             allAssetHoldings[i] = assetHoldings;
1188             allAssetPrices[i] = assetPrice;
1189             // gav as sum of mul(assetHoldings, assetPrice) with formatting: mul(mul(exchangeHoldings, exchangePrice), 10 ** shareDecimals)
1190             gav = add(gav, mul(assetHoldings, assetPrice) / (10 ** uint256(assetDecimals)));   // Sum up product of asset holdings of this vault and asset prices
1191             if (assetHoldings != 0 || ofAsset == address(QUOTE_ASSET) || isInOpenMakeOrder[ofAsset]) { // Check if asset holdings is not zero or is address(QUOTE_ASSET) or in open make order
1192                 ownedAssets.push(ofAsset);
1193             } else {
1194                 isInAssetList[ofAsset] = false; // Remove from ownedAssets if asset holdings are zero
1195             }
1196         }
1197         emit PortfolioContent(tempOwnedAssets, allAssetHoldings, allAssetPrices);
1198     }
1199 
1200     /// @notice Add an asset to the list that this fund owns
1201     function addAssetToOwnedAssets (address ofAsset)
1202         public
1203         pre_cond(isOwner() || msg.sender == address(this))
1204     {
1205         isInOpenMakeOrder[ofAsset] = true;
1206         if (!isInAssetList[ofAsset]) {
1207             ownedAssets.push(ofAsset);
1208             isInAssetList[ofAsset] = true;
1209         }
1210     }
1211 
1212     /**
1213     @notice Calculates unclaimed fees of the fund manager
1214     @param gav Gross asset value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1215     @return {
1216       "managementFees": "A time (seconds) based fee in QUOTE_ASSET and multiplied by 10 ** shareDecimals",
1217       "performanceFees": "A performance (rise of sharePrice measured in QUOTE_ASSET) based fee in QUOTE_ASSET and multiplied by 10 ** shareDecimals",
1218       "unclaimedfees": "The sum of both managementfee and performancefee in QUOTE_ASSET and multiplied by 10 ** shareDecimals"
1219     }
1220     */
1221     function calcUnclaimedFees(uint gav)
1222         view
1223         returns (
1224             uint managementFee,
1225             uint performanceFee,
1226             uint unclaimedFees)
1227     {
1228         // Management fee calculation
1229         uint timePassed = sub(now, atLastUnclaimedFeeAllocation.timestamp);
1230         uint gavPercentage = mul(timePassed, gav) / (1 years);
1231         managementFee = wmul(gavPercentage, MANAGEMENT_FEE_RATE);
1232 
1233         // Performance fee calculation
1234         // Handle potential division through zero by defining a default value
1235         uint valuePerShareExclMgmtFees = _totalSupply > 0 ? calcValuePerShare(sub(gav, managementFee), _totalSupply) : toSmallestShareUnit(1);
1236         if (valuePerShareExclMgmtFees > atLastUnclaimedFeeAllocation.highWaterMark) {
1237             uint gainInSharePrice = sub(valuePerShareExclMgmtFees, atLastUnclaimedFeeAllocation.highWaterMark);
1238             uint investmentProfits = wmul(gainInSharePrice, _totalSupply);
1239             performanceFee = wmul(investmentProfits, PERFORMANCE_FEE_RATE);
1240         }
1241 
1242         // Sum of all FEES
1243         unclaimedFees = add(managementFee, performanceFee);
1244     }
1245 
1246     /// @notice Calculates the Net asset value of this fund
1247     /// @param gav Gross asset value of this fund in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1248     /// @param unclaimedFees The sum of both managementFee and performanceFee in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1249     /// @return nav Net asset value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1250     function calcNav(uint gav, uint unclaimedFees)
1251         view
1252         returns (uint nav)
1253     {
1254         nav = sub(gav, unclaimedFees);
1255     }
1256 
1257     /// @notice Calculates the share price of the fund
1258     /// @dev Convention for valuePerShare (== sharePrice) formatting: mul(totalValue / numShares, 10 ** decimal), to avoid floating numbers
1259     /// @dev Non-zero share supply; value denominated in [base unit of melonAsset]
1260     /// @param totalValue the total value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1261     /// @param numShares the number of shares multiplied by 10 ** shareDecimals
1262     /// @return valuePerShare Share price denominated in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1263     function calcValuePerShare(uint totalValue, uint numShares)
1264         view
1265         pre_cond(numShares > 0)
1266         returns (uint valuePerShare)
1267     {
1268         valuePerShare = toSmallestShareUnit(totalValue) / numShares;
1269     }
1270 
1271     /**
1272     @notice Calculates essential fund metrics
1273     @return {
1274       "gav": "Gross asset value of this fund denominated in [base unit of melonAsset]",
1275       "managementFee": "A time (seconds) based fee",
1276       "performanceFee": "A performance (rise of sharePrice measured in QUOTE_ASSET) based fee",
1277       "unclaimedFees": "The sum of both managementFee and performanceFee denominated in [base unit of melonAsset]",
1278       "feesShareQuantity": "The number of shares to be given as fees to the manager",
1279       "nav": "Net asset value denominated in [base unit of melonAsset]",
1280       "sharePrice": "Share price denominated in [base unit of melonAsset]"
1281     }
1282     */
1283     function performCalculations()
1284         view
1285         returns (
1286             uint gav,
1287             uint managementFee,
1288             uint performanceFee,
1289             uint unclaimedFees,
1290             uint feesShareQuantity,
1291             uint nav,
1292             uint sharePrice
1293         )
1294     {
1295         gav = calcGav(); // Reflects value independent of fees
1296         (managementFee, performanceFee, unclaimedFees) = calcUnclaimedFees(gav);
1297         nav = calcNav(gav, unclaimedFees);
1298 
1299         // The value of unclaimedFees measured in shares of this fund at current value
1300         feesShareQuantity = (gav == 0) ? 0 : mul(_totalSupply, unclaimedFees) / gav;
1301         // The total share supply including the value of unclaimedFees, measured in shares of this fund
1302         uint totalSupplyAccountingForFees = add(_totalSupply, feesShareQuantity);
1303         sharePrice = _totalSupply > 0 ? calcValuePerShare(gav, totalSupplyAccountingForFees) : toSmallestShareUnit(1); // Handle potential division through zero by defining a default value
1304     }
1305 
1306     /// @notice Converts unclaimed fees of the manager into fund shares
1307     /// @return sharePrice Share price denominated in [base unit of melonAsset]
1308     function calcSharePriceAndAllocateFees() public returns (uint)
1309     {
1310         var (
1311             gav,
1312             managementFee,
1313             performanceFee,
1314             unclaimedFees,
1315             feesShareQuantity,
1316             nav,
1317             sharePrice
1318         ) = performCalculations();
1319 
1320         createShares(owner, feesShareQuantity); // Updates _totalSupply by creating shares allocated to manager
1321 
1322         // Update Calculations
1323         uint highWaterMark = atLastUnclaimedFeeAllocation.highWaterMark >= sharePrice ? atLastUnclaimedFeeAllocation.highWaterMark : sharePrice;
1324         atLastUnclaimedFeeAllocation = Calculations({
1325             gav: gav,
1326             managementFee: managementFee,
1327             performanceFee: performanceFee,
1328             unclaimedFees: unclaimedFees,
1329             nav: nav,
1330             highWaterMark: highWaterMark,
1331             totalSupply: _totalSupply,
1332             timestamp: now
1333         });
1334 
1335         emit FeesConverted(now, feesShareQuantity, unclaimedFees);
1336         emit CalculationUpdate(now, managementFee, performanceFee, nav, sharePrice, _totalSupply);
1337 
1338         return sharePrice;
1339     }
1340 
1341     // PUBLIC : REDEEMING
1342 
1343     /// @notice Redeems by allocating an ownership percentage only of requestedAssets to the participant
1344     /// @dev This works, but with loops, so only up to a certain number of assets (right now the max is 4)
1345     /// @dev Independent of running price feed! Note: if requestedAssets != ownedAssets then participant misses out on some owned value
1346     /// @param shareQuantity Number of shares owned by the participant, which the participant would like to redeem for a slice of assets
1347     /// @param requestedAssets List of addresses that consitute a subset of ownedAssets.
1348     /// @return Whether all assets sent to shareholder or not
1349     function emergencyRedeem(uint shareQuantity, address[] requestedAssets)
1350         public
1351         pre_cond(balances[msg.sender] >= shareQuantity)  // sender owns enough shares
1352         returns (bool)
1353     {
1354         address ofAsset;
1355         uint[] memory ownershipQuantities = new uint[](requestedAssets.length);
1356         address[] memory redeemedAssets = new address[](requestedAssets.length);
1357 
1358         // Check whether enough assets held by fund
1359         for (uint i = 0; i < requestedAssets.length; ++i) {
1360             ofAsset = requestedAssets[i];
1361             require(isInAssetList[ofAsset]);
1362             for (uint j = 0; j < redeemedAssets.length; j++) {
1363                 if (ofAsset == redeemedAssets[j]) {
1364                     revert();
1365                 }
1366             }
1367             redeemedAssets[i] = ofAsset;
1368             uint assetHoldings = add(
1369                 uint(AssetInterface(ofAsset).balanceOf(address(this))),
1370                 quantityHeldInCustodyOfExchange(ofAsset)
1371             );
1372 
1373             if (assetHoldings == 0) continue;
1374 
1375             // participant's ownership percentage of asset holdings
1376             ownershipQuantities[i] = mul(assetHoldings, shareQuantity) / _totalSupply;
1377 
1378             // CRITICAL ERR: Not enough fund asset balance for owed ownershipQuantitiy, eg in case of unreturned asset quantity at address(exchanges[i].exchange) address
1379             if (uint(AssetInterface(ofAsset).balanceOf(address(this))) < ownershipQuantities[i]) {
1380                 isShutDown = true;
1381                 emit ErrorMessage("CRITICAL ERR: Not enough assetHoldings for owed ownershipQuantitiy");
1382                 return false;
1383             }
1384         }
1385 
1386         // Annihilate shares before external calls to prevent reentrancy
1387         annihilateShares(msg.sender, shareQuantity);
1388 
1389         // Transfer ownershipQuantity of Assets
1390         for (uint k = 0; k < requestedAssets.length; ++k) {
1391             // Failed to send owed ownershipQuantity from fund to participant
1392             ofAsset = requestedAssets[k];
1393             if (ownershipQuantities[k] == 0) {
1394                 continue;
1395             } else if (!AssetInterface(ofAsset).transfer(msg.sender, ownershipQuantities[k])) {
1396                 revert();
1397             }
1398         }
1399         emit Redeemed(msg.sender, now, shareQuantity);
1400         return true;
1401     }
1402 
1403     // PUBLIC : FEES
1404 
1405     /// @dev Quantity of asset held in exchange according to associated order id
1406     /// @param ofAsset Address of asset
1407     /// @return Quantity of input asset held in exchange
1408     function quantityHeldInCustodyOfExchange(address ofAsset) returns (uint) {
1409         uint totalSellQuantity;     // quantity in custody across exchanges
1410         uint totalSellQuantityInApprove; // quantity of asset in approve (allowance) but not custody of exchange
1411         for (uint i; i < exchanges.length; i++) {
1412             if (exchangesToOpenMakeOrders[exchanges[i].exchange][ofAsset].id == 0) {
1413                 continue;
1414             }
1415             var (sellAsset, , sellQuantity, ) = GenericExchangeInterface(exchanges[i].exchangeAdapter).getOrder(exchanges[i].exchange, exchangesToOpenMakeOrders[exchanges[i].exchange][ofAsset].id);
1416             if (sellQuantity == 0) {    // remove id if remaining sell quantity zero (closed)
1417                 delete exchangesToOpenMakeOrders[exchanges[i].exchange][ofAsset];
1418             }
1419             totalSellQuantity = add(totalSellQuantity, sellQuantity);
1420             if (!exchanges[i].takesCustody) {
1421                 totalSellQuantityInApprove += sellQuantity;
1422             }
1423         }
1424         if (totalSellQuantity == 0) {
1425             isInOpenMakeOrder[sellAsset] = false;
1426         }
1427         return sub(totalSellQuantity, totalSellQuantityInApprove); // Since quantity in approve is not actually in custody
1428     }
1429 
1430     // PUBLIC VIEW METHODS
1431 
1432     /// @notice Calculates sharePrice denominated in [base unit of melonAsset]
1433     /// @return sharePrice Share price denominated in [base unit of melonAsset]
1434     function calcSharePrice() view returns (uint sharePrice) {
1435         (, , , , , sharePrice) = performCalculations();
1436         return sharePrice;
1437     }
1438 
1439     function getModules() view returns (address, address, address) {
1440         return (
1441             address(modules.pricefeed),
1442             address(modules.compliance),
1443             address(modules.riskmgmt)
1444         );
1445     }
1446 
1447     function getLastRequestId() view returns (uint) { return requests.length - 1; }
1448     function getLastOrderIndex() view returns (uint) { return orders.length - 1; }
1449     function getManager() view returns (address) { return owner; }
1450     function getOwnedAssetsLength() view returns (uint) { return ownedAssets.length; }
1451     function getExchangeInfo() view returns (address[], address[], bool[]) {
1452         address[] memory ofExchanges = new address[](exchanges.length);
1453         address[] memory ofAdapters = new address[](exchanges.length);
1454         bool[] memory takesCustody = new bool[](exchanges.length);
1455         for (uint i = 0; i < exchanges.length; i++) {
1456             ofExchanges[i] = exchanges[i].exchange;
1457             ofAdapters[i] = exchanges[i].exchangeAdapter;
1458             takesCustody[i] = exchanges[i].takesCustody;
1459         }
1460         return (ofExchanges, ofAdapters, takesCustody);
1461     }
1462     function orderExpired(address ofExchange, address ofAsset) view returns (bool) {
1463         uint expiryTime = exchangesToOpenMakeOrders[ofExchange][ofAsset].expiresAt;
1464         require(expiryTime > 0);
1465         return block.timestamp >= expiryTime;
1466     }
1467     function getOpenOrderInfo(address ofExchange, address ofAsset) view returns (uint, uint) {
1468         OpenMakeOrder order = exchangesToOpenMakeOrders[ofExchange][ofAsset];
1469         return (order.id, order.expiresAt);
1470     }
1471 }
1472 
1473 contract CompetitionCompliance is ComplianceInterface, DBC, Owned {
1474 
1475     address public competitionAddress;
1476 
1477     // CONSTRUCTOR
1478 
1479     /// @dev Constructor
1480     /// @param ofCompetition Address of the competition contract
1481     function CompetitionCompliance(address ofCompetition) public {
1482         competitionAddress = ofCompetition;
1483     }
1484 
1485     // PUBLIC VIEW METHODS
1486 
1487     /// @notice Checks whether investment is permitted for a participant
1488     /// @param ofParticipant Address requesting to invest in a Melon fund
1489     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
1490     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
1491     /// @return Whether identity is eligible to invest in a Melon fund.
1492     function isInvestmentPermitted(
1493         address ofParticipant,
1494         uint256 giveQuantity,
1495         uint256 shareQuantity
1496     )
1497         view
1498         returns (bool)
1499     {
1500         return competitionAddress == ofParticipant;
1501     }
1502 
1503     /// @notice Checks whether redemption is permitted for a participant
1504     /// @param ofParticipant Address requesting to redeem from a Melon fund
1505     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
1506     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
1507     /// @return isEligible Whether identity is eligible to redeem from a Melon fund.
1508     function isRedemptionPermitted(
1509         address ofParticipant,
1510         uint256 shareQuantity,
1511         uint256 receiveQuantity
1512     )
1513         view
1514         returns (bool)
1515     {
1516         return competitionAddress == ofParticipant;
1517     }
1518 
1519     /// @notice Checks whether an address is whitelisted in the competition contract and competition is active
1520     /// @param x Address
1521     /// @return Whether the address is whitelisted
1522     function isCompetitionAllowed(
1523         address x
1524     )
1525         view
1526         returns (bool)
1527     {
1528         return CompetitionInterface(competitionAddress).isWhitelisted(x) && CompetitionInterface(competitionAddress).isCompetitionActive();
1529     }
1530 
1531 
1532     // PUBLIC METHODS
1533 
1534     /// @notice Changes the competition address
1535     /// @param ofCompetition Address of the competition contract
1536     function changeCompetitionAddress(
1537         address ofCompetition
1538     )
1539         pre_cond(isOwner())
1540     {
1541         competitionAddress = ofCompetition;
1542     }
1543 
1544 }
1545 
1546 interface GenericExchangeInterface {
1547 
1548     // EVENTS
1549 
1550     event OrderUpdated(uint id);
1551 
1552     // METHODS
1553     // EXTERNAL METHODS
1554 
1555     function makeOrder(
1556         address onExchange,
1557         address sellAsset,
1558         address buyAsset,
1559         uint sellQuantity,
1560         uint buyQuantity
1561     ) external returns (uint);
1562     function takeOrder(address onExchange, uint id, uint quantity) external returns (bool);
1563     function cancelOrder(address onExchange, uint id) external returns (bool);
1564 
1565 
1566     // PUBLIC METHODS
1567     // PUBLIC VIEW METHODS
1568 
1569     function isApproveOnly() view returns (bool);
1570     function getLastOrderId(address onExchange) view returns (uint);
1571     function isActive(address onExchange, uint id) view returns (bool);
1572     function getOwner(address onExchange, uint id) view returns (address);
1573     function getOrder(address onExchange, uint id) view returns (address, address, uint, uint);
1574     function getTimestamp(address onExchange, uint id) view returns (uint);
1575 
1576 }
1577 
1578 contract CanonicalRegistrar is DSThing, DBC {
1579 
1580     // TYPES
1581 
1582     struct Asset {
1583         bool exists; // True if asset is registered here
1584         bytes32 name; // Human-readable name of the Asset as in ERC223 token standard
1585         bytes8 symbol; // Human-readable symbol of the Asset as in ERC223 token standard
1586         uint decimals; // Decimal, order of magnitude of precision, of the Asset as in ERC223 token standard
1587         string url; // URL for additional information of Asset
1588         string ipfsHash; // Same as url but for ipfs
1589         address breakIn; // Break in contract on destination chain
1590         address breakOut; // Break out contract on this chain; A way to leave
1591         uint[] standards; // compliance with standards like ERC20, ERC223, ERC777, etc. (the uint is the standard number)
1592         bytes4[] functionSignatures; // Whitelisted function signatures that can be called using `useExternalFunction` in Fund contract. Note: Adhere to a naming convention for `Fund<->Asset` as much as possible. I.e. name same concepts with the same functionSignature.
1593         uint price; // Price of asset quoted against `QUOTE_ASSET` * 10 ** decimals
1594         uint timestamp; // Timestamp of last price update of this asset
1595     }
1596 
1597     struct Exchange {
1598         bool exists;
1599         address adapter; // adapter contract for this exchange
1600         // One-time note: takesCustody is inverse case of isApproveOnly
1601         bool takesCustody; // True in case of exchange implementation which requires  are approved when an order is made instead of transfer
1602         bytes4[] functionSignatures; // Whitelisted function signatures that can be called using `useExternalFunction` in Fund contract. Note: Adhere to a naming convention for `Fund<->ExchangeAdapter` as much as possible. I.e. name same concepts with the same functionSignature.
1603     }
1604     // TODO: populate each field here
1605     // TODO: add whitelistFunction function
1606 
1607     // FIELDS
1608 
1609     // Methods fields
1610     mapping (address => Asset) public assetInformation;
1611     address[] public registeredAssets;
1612 
1613     mapping (address => Exchange) public exchangeInformation;
1614     address[] public registeredExchanges;
1615 
1616     // METHODS
1617 
1618     // PUBLIC METHODS
1619 
1620     /// @notice Registers an Asset information entry
1621     /// @dev Pre: Only registrar owner should be able to register
1622     /// @dev Post: Address ofAsset is registered
1623     /// @param ofAsset Address of asset to be registered
1624     /// @param inputName Human-readable name of the Asset as in ERC223 token standard
1625     /// @param inputSymbol Human-readable symbol of the Asset as in ERC223 token standard
1626     /// @param inputDecimals Human-readable symbol of the Asset as in ERC223 token standard
1627     /// @param inputUrl Url for extended information of the asset
1628     /// @param inputIpfsHash Same as url but for ipfs
1629     /// @param breakInBreakOut Address of break in and break out contracts on destination chain
1630     /// @param inputStandards Integers of EIP standards this asset adheres to
1631     /// @param inputFunctionSignatures Function signatures for whitelisted asset functions
1632     function registerAsset(
1633         address ofAsset,
1634         bytes32 inputName,
1635         bytes8 inputSymbol,
1636         uint inputDecimals,
1637         string inputUrl,
1638         string inputIpfsHash,
1639         address[2] breakInBreakOut,
1640         uint[] inputStandards,
1641         bytes4[] inputFunctionSignatures
1642     )
1643         auth
1644         pre_cond(!assetInformation[ofAsset].exists)
1645     {
1646         assetInformation[ofAsset].exists = true;
1647         registeredAssets.push(ofAsset);
1648         updateAsset(
1649             ofAsset,
1650             inputName,
1651             inputSymbol,
1652             inputDecimals,
1653             inputUrl,
1654             inputIpfsHash,
1655             breakInBreakOut,
1656             inputStandards,
1657             inputFunctionSignatures
1658         );
1659         assert(assetInformation[ofAsset].exists);
1660     }
1661 
1662     /// @notice Register an exchange information entry
1663     /// @dev Pre: Only registrar owner should be able to register
1664     /// @dev Post: Address ofExchange is registered
1665     /// @param ofExchange Address of the exchange
1666     /// @param ofExchangeAdapter Address of exchange adapter for this exchange
1667     /// @param inputTakesCustody Whether this exchange takes custody of tokens before trading
1668     /// @param inputFunctionSignatures Function signatures for whitelisted exchange functions
1669     function registerExchange(
1670         address ofExchange,
1671         address ofExchangeAdapter,
1672         bool inputTakesCustody,
1673         bytes4[] inputFunctionSignatures
1674     )
1675         auth
1676         pre_cond(!exchangeInformation[ofExchange].exists)
1677     {
1678         exchangeInformation[ofExchange].exists = true;
1679         registeredExchanges.push(ofExchange);
1680         updateExchange(
1681             ofExchange,
1682             ofExchangeAdapter,
1683             inputTakesCustody,
1684             inputFunctionSignatures
1685         );
1686         assert(exchangeInformation[ofExchange].exists);
1687     }
1688 
1689     /// @notice Updates description information of a registered Asset
1690     /// @dev Pre: Owner can change an existing entry
1691     /// @dev Post: Changed Name, Symbol, URL and/or IPFSHash
1692     /// @param ofAsset Address of the asset to be updated
1693     /// @param inputName Human-readable name of the Asset as in ERC223 token standard
1694     /// @param inputSymbol Human-readable symbol of the Asset as in ERC223 token standard
1695     /// @param inputUrl Url for extended information of the asset
1696     /// @param inputIpfsHash Same as url but for ipfs
1697     function updateAsset(
1698         address ofAsset,
1699         bytes32 inputName,
1700         bytes8 inputSymbol,
1701         uint inputDecimals,
1702         string inputUrl,
1703         string inputIpfsHash,
1704         address[2] ofBreakInBreakOut,
1705         uint[] inputStandards,
1706         bytes4[] inputFunctionSignatures
1707     )
1708         auth
1709         pre_cond(assetInformation[ofAsset].exists)
1710     {
1711         Asset asset = assetInformation[ofAsset];
1712         asset.name = inputName;
1713         asset.symbol = inputSymbol;
1714         asset.decimals = inputDecimals;
1715         asset.url = inputUrl;
1716         asset.ipfsHash = inputIpfsHash;
1717         asset.breakIn = ofBreakInBreakOut[0];
1718         asset.breakOut = ofBreakInBreakOut[1];
1719         asset.standards = inputStandards;
1720         asset.functionSignatures = inputFunctionSignatures;
1721     }
1722 
1723     function updateExchange(
1724         address ofExchange,
1725         address ofExchangeAdapter,
1726         bool inputTakesCustody,
1727         bytes4[] inputFunctionSignatures
1728     )
1729         auth
1730         pre_cond(exchangeInformation[ofExchange].exists)
1731     {
1732         Exchange exchange = exchangeInformation[ofExchange];
1733         exchange.adapter = ofExchangeAdapter;
1734         exchange.takesCustody = inputTakesCustody;
1735         exchange.functionSignatures = inputFunctionSignatures;
1736     }
1737 
1738     // TODO: check max size of array before remaking this becomes untenable
1739     /// @notice Deletes an existing entry
1740     /// @dev Owner can delete an existing entry
1741     /// @param ofAsset address for which specific information is requested
1742     function removeAsset(
1743         address ofAsset,
1744         uint assetIndex
1745     )
1746         auth
1747         pre_cond(assetInformation[ofAsset].exists)
1748     {
1749         require(registeredAssets[assetIndex] == ofAsset);
1750         delete assetInformation[ofAsset]; // Sets exists boolean to false
1751         delete registeredAssets[assetIndex];
1752         for (uint i = assetIndex; i < registeredAssets.length-1; i++) {
1753             registeredAssets[i] = registeredAssets[i+1];
1754         }
1755         registeredAssets.length--;
1756         assert(!assetInformation[ofAsset].exists);
1757     }
1758 
1759     /// @notice Deletes an existing entry
1760     /// @dev Owner can delete an existing entry
1761     /// @param ofExchange address for which specific information is requested
1762     /// @param exchangeIndex index of the exchange in array
1763     function removeExchange(
1764         address ofExchange,
1765         uint exchangeIndex
1766     )
1767         auth
1768         pre_cond(exchangeInformation[ofExchange].exists)
1769     {
1770         require(registeredExchanges[exchangeIndex] == ofExchange);
1771         delete exchangeInformation[ofExchange];
1772         delete registeredExchanges[exchangeIndex];
1773         for (uint i = exchangeIndex; i < registeredExchanges.length-1; i++) {
1774             registeredExchanges[i] = registeredExchanges[i+1];
1775         }
1776         registeredExchanges.length--;
1777         assert(!exchangeInformation[ofExchange].exists);
1778     }
1779 
1780     // PUBLIC VIEW METHODS
1781 
1782     // get asset specific information
1783     function getName(address ofAsset) view returns (bytes32) { return assetInformation[ofAsset].name; }
1784     function getSymbol(address ofAsset) view returns (bytes8) { return assetInformation[ofAsset].symbol; }
1785     function getDecimals(address ofAsset) view returns (uint) { return assetInformation[ofAsset].decimals; }
1786     function assetIsRegistered(address ofAsset) view returns (bool) { return assetInformation[ofAsset].exists; }
1787     function getRegisteredAssets() view returns (address[]) { return registeredAssets; }
1788     function assetMethodIsAllowed(
1789         address ofAsset, bytes4 querySignature
1790     )
1791         returns (bool)
1792     {
1793         bytes4[] memory signatures = assetInformation[ofAsset].functionSignatures;
1794         for (uint i = 0; i < signatures.length; i++) {
1795             if (signatures[i] == querySignature) {
1796                 return true;
1797             }
1798         }
1799         return false;
1800     }
1801 
1802     // get exchange-specific information
1803     function exchangeIsRegistered(address ofExchange) view returns (bool) { return exchangeInformation[ofExchange].exists; }
1804     function getRegisteredExchanges() view returns (address[]) { return registeredExchanges; }
1805     function getExchangeInformation(address ofExchange)
1806         view
1807         returns (address, bool)
1808     {
1809         Exchange exchange = exchangeInformation[ofExchange];
1810         return (
1811             exchange.adapter,
1812             exchange.takesCustody
1813         );
1814     }
1815     function getExchangeFunctionSignatures(address ofExchange)
1816         view
1817         returns (bytes4[])
1818     {
1819         return exchangeInformation[ofExchange].functionSignatures;
1820     }
1821     function exchangeMethodIsAllowed(
1822         address ofExchange, bytes4 querySignature
1823     )
1824         returns (bool)
1825     {
1826         bytes4[] memory signatures = exchangeInformation[ofExchange].functionSignatures;
1827         for (uint i = 0; i < signatures.length; i++) {
1828             if (signatures[i] == querySignature) {
1829                 return true;
1830             }
1831         }
1832         return false;
1833     }
1834 }
1835 
1836 interface SimplePriceFeedInterface {
1837 
1838     // EVENTS
1839 
1840     event PriceUpdated(bytes32 hash);
1841 
1842     // PUBLIC METHODS
1843 
1844     function update(address[] ofAssets, uint[] newPrices) external;
1845 
1846     // PUBLIC VIEW METHODS
1847 
1848     // Get price feed operation specific information
1849     function getQuoteAsset() view returns (address);
1850     function getLastUpdateId() view returns (uint);
1851     // Get asset specific information as updated in price feed
1852     function getPrice(address ofAsset) view returns (uint price, uint timestamp);
1853     function getPrices(address[] ofAssets) view returns (uint[] prices, uint[] timestamps);
1854 }
1855 
1856 contract SimplePriceFeed is SimplePriceFeedInterface, DSThing, DBC {
1857 
1858     // TYPES
1859     struct Data {
1860         uint price;
1861         uint timestamp;
1862     }
1863 
1864     // FIELDS
1865     mapping(address => Data) public assetsToPrices;
1866 
1867     // Constructor fields
1868     address public QUOTE_ASSET; // Asset of a portfolio against which all other assets are priced
1869 
1870     // Contract-level variables
1871     uint public updateId;        // Update counter for this pricefeed; used as a check during investment
1872     CanonicalRegistrar public registrar;
1873     CanonicalPriceFeed public superFeed;
1874 
1875     // METHODS
1876 
1877     // CONSTRUCTOR
1878 
1879     /// @param ofQuoteAsset Address of quote asset
1880     /// @param ofRegistrar Address of canonical registrar
1881     /// @param ofSuperFeed Address of superfeed
1882     function SimplePriceFeed(
1883         address ofRegistrar,
1884         address ofQuoteAsset,
1885         address ofSuperFeed
1886     ) {
1887         registrar = CanonicalRegistrar(ofRegistrar);
1888         QUOTE_ASSET = ofQuoteAsset;
1889         superFeed = CanonicalPriceFeed(ofSuperFeed);
1890     }
1891 
1892     // EXTERNAL METHODS
1893 
1894     /// @dev Only Owner; Same sized input arrays
1895     /// @dev Updates price of asset relative to QUOTE_ASSET
1896     /** Ex:
1897      *  Let QUOTE_ASSET == MLN (base units), let asset == EUR-T,
1898      *  let Value of 1 EUR-T := 1 EUR == 0.080456789 MLN, hence price 0.080456789 MLN / EUR-T
1899      *  and let EUR-T decimals == 8.
1900      *  Input would be: information[EUR-T].price = 8045678 [MLN/ (EUR-T * 10**8)]
1901      */
1902     /// @param ofAssets list of asset addresses
1903     /// @param newPrices list of prices for each of the assets
1904     function update(address[] ofAssets, uint[] newPrices)
1905         external
1906         auth
1907     {
1908         _updatePrices(ofAssets, newPrices);
1909     }
1910 
1911     // PUBLIC VIEW METHODS
1912 
1913     // Get pricefeed specific information
1914     function getQuoteAsset() view returns (address) { return QUOTE_ASSET; }
1915     function getLastUpdateId() view returns (uint) { return updateId; }
1916 
1917     /**
1918     @notice Gets price of an asset multiplied by ten to the power of assetDecimals
1919     @dev Asset has been registered
1920     @param ofAsset Asset for which price should be returned
1921     @return {
1922       "price": "Price formatting: mul(exchangePrice, 10 ** decimal), to avoid floating numbers",
1923       "timestamp": "When the asset's price was updated"
1924     }
1925     */
1926     function getPrice(address ofAsset)
1927         view
1928         returns (uint price, uint timestamp)
1929     {
1930         Data data = assetsToPrices[ofAsset];
1931         return (data.price, data.timestamp);
1932     }
1933 
1934     /**
1935     @notice Price of a registered asset in format (bool areRecent, uint[] prices, uint[] decimals)
1936     @dev Convention for price formatting: mul(price, 10 ** decimal), to avoid floating numbers
1937     @param ofAssets Assets for which prices should be returned
1938     @return {
1939         "prices":       "Array of prices",
1940         "timestamps":   "Array of timestamps",
1941     }
1942     */
1943     function getPrices(address[] ofAssets)
1944         view
1945         returns (uint[], uint[])
1946     {
1947         uint[] memory prices = new uint[](ofAssets.length);
1948         uint[] memory timestamps = new uint[](ofAssets.length);
1949         for (uint i; i < ofAssets.length; i++) {
1950             var (price, timestamp) = getPrice(ofAssets[i]);
1951             prices[i] = price;
1952             timestamps[i] = timestamp;
1953         }
1954         return (prices, timestamps);
1955     }
1956 
1957     // INTERNAL METHODS
1958 
1959     /// @dev Internal so that feeds inheriting this one are not obligated to have an exposed update(...) method, but can still perform updates
1960     function _updatePrices(address[] ofAssets, uint[] newPrices)
1961         internal
1962         pre_cond(ofAssets.length == newPrices.length)
1963     {
1964         updateId++;
1965         for (uint i = 0; i < ofAssets.length; ++i) {
1966             require(registrar.assetIsRegistered(ofAssets[i]));
1967             require(assetsToPrices[ofAssets[i]].timestamp != now); // prevent two updates in one block
1968             assetsToPrices[ofAssets[i]].timestamp = now;
1969             assetsToPrices[ofAssets[i]].price = newPrices[i];
1970         }
1971         emit PriceUpdated(keccak256(ofAssets, newPrices));
1972     }
1973 }
1974 
1975 contract StakingPriceFeed is SimplePriceFeed {
1976 
1977     OperatorStaking public stakingContract;
1978     AssetInterface public stakingToken;
1979 
1980     // CONSTRUCTOR
1981 
1982     /// @param ofQuoteAsset Address of quote asset
1983     /// @param ofRegistrar Address of canonical registrar
1984     /// @param ofSuperFeed Address of superfeed
1985     function StakingPriceFeed(
1986         address ofRegistrar,
1987         address ofQuoteAsset,
1988         address ofSuperFeed
1989     )
1990         SimplePriceFeed(ofRegistrar, ofQuoteAsset, ofSuperFeed)
1991     {
1992         stakingContract = OperatorStaking(ofSuperFeed); // canonical feed *is* staking contract
1993         stakingToken = AssetInterface(stakingContract.stakingToken());
1994     }
1995 
1996     // EXTERNAL METHODS
1997 
1998     /// @param amount Number of tokens to stake for this feed
1999     /// @param data Data may be needed for some future applications (can be empty for now)
2000     function depositStake(uint amount, bytes data)
2001         external
2002         auth
2003     {
2004         require(stakingToken.transferFrom(msg.sender, address(this), amount));
2005         require(stakingToken.approve(stakingContract, amount));
2006         stakingContract.stake(amount, data);
2007     }
2008 
2009     /// @param amount Number of tokens to unstake for this feed
2010     /// @param data Data may be needed for some future applications (can be empty for now)
2011     function unstake(uint amount, bytes data) {
2012         stakingContract.unstake(amount, data);
2013     }
2014 
2015     function withdrawStake()
2016         external
2017         auth
2018     {
2019         uint amountToWithdraw = stakingContract.stakeToWithdraw(address(this));
2020         stakingContract.withdrawStake();
2021         require(stakingToken.transfer(msg.sender, amountToWithdraw));
2022     }
2023 }
2024 
2025 interface RiskMgmtInterface {
2026 
2027     // METHODS
2028     // PUBLIC VIEW METHODS
2029 
2030     /// @notice Checks if the makeOrder price is reasonable and not manipulative
2031     /// @param orderPrice Price of Order
2032     /// @param referencePrice Reference price obtained through PriceFeed contract
2033     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
2034     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
2035     /// @param sellQuantity Quantity of sellAsset to be sold
2036     /// @param buyQuantity Quantity of buyAsset to be bought
2037     /// @return If makeOrder is permitted
2038     function isMakePermitted(
2039         uint orderPrice,
2040         uint referencePrice,
2041         address sellAsset,
2042         address buyAsset,
2043         uint sellQuantity,
2044         uint buyQuantity
2045     ) view returns (bool);
2046 
2047     /// @notice Checks if the takeOrder price is reasonable and not manipulative
2048     /// @param orderPrice Price of Order
2049     /// @param referencePrice Reference price obtained through PriceFeed contract
2050     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
2051     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
2052     /// @param sellQuantity Quantity of sellAsset to be sold
2053     /// @param buyQuantity Quantity of buyAsset to be bought
2054     /// @return If takeOrder is permitted
2055     function isTakePermitted(
2056         uint orderPrice,
2057         uint referencePrice,
2058         address sellAsset,
2059         address buyAsset,
2060         uint sellQuantity,
2061         uint buyQuantity
2062     ) view returns (bool);
2063 }
2064 
2065 contract OperatorStaking is DBC {
2066 
2067     // EVENTS
2068 
2069     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
2070     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
2071     event StakeBurned(address indexed user, uint256 amount, bytes data);
2072 
2073     // TYPES
2074 
2075     struct StakeData {
2076         uint amount;
2077         address staker;
2078     }
2079 
2080     // Circular linked list
2081     struct Node {
2082         StakeData data;
2083         uint prev;
2084         uint next;
2085     }
2086 
2087     // FIELDS
2088 
2089     // INTERNAL FIELDS
2090     Node[] internal stakeNodes; // Sorted circular linked list nodes containing stake data (Built on top https://programtheblockchain.com/posts/2018/03/30/storage-patterns-doubly-linked-list/)
2091 
2092     // PUBLIC FIELDS
2093     uint public minimumStake;
2094     uint public numOperators;
2095     uint public withdrawalDelay;
2096     mapping (address => bool) public isRanked;
2097     mapping (address => uint) public latestUnstakeTime;
2098     mapping (address => uint) public stakeToWithdraw;
2099     mapping (address => uint) public stakedAmounts;
2100     uint public numStakers; // Current number of stakers (Needed because of array holes)
2101     AssetInterface public stakingToken;
2102 
2103     // TODO: consider renaming "operator" depending on how this is implemented
2104     //  (i.e. is pricefeed staking itself?)
2105     function OperatorStaking(
2106         AssetInterface _stakingToken,
2107         uint _minimumStake,
2108         uint _numOperators,
2109         uint _withdrawalDelay
2110     )
2111         public
2112     {
2113         require(address(_stakingToken) != address(0));
2114         stakingToken = _stakingToken;
2115         minimumStake = _minimumStake;
2116         numOperators = _numOperators;
2117         withdrawalDelay = _withdrawalDelay;
2118         StakeData memory temp = StakeData({ amount: 0, staker: address(0) });
2119         stakeNodes.push(Node(temp, 0, 0));
2120     }
2121 
2122     // METHODS : STAKING
2123 
2124     function stake(
2125         uint amount,
2126         bytes data
2127     )
2128         public
2129         pre_cond(amount >= minimumStake)
2130     {
2131         uint tailNodeId = stakeNodes[0].prev;
2132         stakedAmounts[msg.sender] += amount;
2133         updateStakerRanking(msg.sender);
2134         require(stakingToken.transferFrom(msg.sender, address(this), amount));
2135     }
2136 
2137     function unstake(
2138         uint amount,
2139         bytes data
2140     )
2141         public
2142     {
2143         uint preStake = stakedAmounts[msg.sender];
2144         uint postStake = preStake - amount;
2145         require(postStake >= minimumStake || postStake == 0);
2146         require(stakedAmounts[msg.sender] >= amount);
2147         latestUnstakeTime[msg.sender] = block.timestamp;
2148         stakedAmounts[msg.sender] -= amount;
2149         stakeToWithdraw[msg.sender] += amount;
2150         updateStakerRanking(msg.sender);
2151         emit Unstaked(msg.sender, amount, stakedAmounts[msg.sender], data);
2152     }
2153 
2154     function withdrawStake()
2155         public
2156         pre_cond(stakeToWithdraw[msg.sender] > 0)
2157         pre_cond(block.timestamp >= latestUnstakeTime[msg.sender] + withdrawalDelay)
2158     {
2159         uint amount = stakeToWithdraw[msg.sender];
2160         stakeToWithdraw[msg.sender] = 0;
2161         require(stakingToken.transfer(msg.sender, amount));
2162     }
2163 
2164     // VIEW FUNCTIONS
2165 
2166     function isValidNode(uint id) view returns (bool) {
2167         // 0 is a sentinel and therefore invalid.
2168         // A valid node is the head or has a previous node.
2169         return id != 0 && (id == stakeNodes[0].next || stakeNodes[id].prev != 0);
2170     }
2171 
2172     function searchNode(address staker) view returns (uint) {
2173         uint current = stakeNodes[0].next;
2174         while (isValidNode(current)) {
2175             if (staker == stakeNodes[current].data.staker) {
2176                 return current;
2177             }
2178             current = stakeNodes[current].next;
2179         }
2180         return 0;
2181     }
2182 
2183     function isOperator(address user) view returns (bool) {
2184         address[] memory operators = getOperators();
2185         for (uint i; i < operators.length; i++) {
2186             if (operators[i] == user) {
2187                 return true;
2188             }
2189         }
2190         return false;
2191     }
2192 
2193     function getOperators()
2194         view
2195         returns (address[])
2196     {
2197         uint arrLength = (numOperators > numStakers) ?
2198             numStakers :
2199             numOperators;
2200         address[] memory operators = new address[](arrLength);
2201         uint current = stakeNodes[0].next;
2202         for (uint i; i < arrLength; i++) {
2203             operators[i] = stakeNodes[current].data.staker;
2204             current = stakeNodes[current].next;
2205         }
2206         return operators;
2207     }
2208 
2209     function getStakersAndAmounts()
2210         view
2211         returns (address[], uint[])
2212     {
2213         address[] memory stakers = new address[](numStakers);
2214         uint[] memory amounts = new uint[](numStakers);
2215         uint current = stakeNodes[0].next;
2216         for (uint i; i < numStakers; i++) {
2217             stakers[i] = stakeNodes[current].data.staker;
2218             amounts[i] = stakeNodes[current].data.amount;
2219             current = stakeNodes[current].next;
2220         }
2221         return (stakers, amounts);
2222     }
2223 
2224     function totalStakedFor(address user)
2225         view
2226         returns (uint)
2227     {
2228         return stakedAmounts[user];
2229     }
2230 
2231     // INTERNAL METHODS
2232 
2233     // DOUBLY-LINKED LIST
2234 
2235     function insertNodeSorted(uint amount, address staker) internal returns (uint) {
2236         uint current = stakeNodes[0].next;
2237         if (current == 0) return insertNodeAfter(0, amount, staker);
2238         while (isValidNode(current)) {
2239             if (amount > stakeNodes[current].data.amount) {
2240                 break;
2241             }
2242             current = stakeNodes[current].next;
2243         }
2244         return insertNodeBefore(current, amount, staker);
2245     }
2246 
2247     function insertNodeAfter(uint id, uint amount, address staker) internal returns (uint newID) {
2248 
2249         // 0 is allowed here to insert at the beginning.
2250         require(id == 0 || isValidNode(id));
2251 
2252         Node storage node = stakeNodes[id];
2253 
2254         stakeNodes.push(Node({
2255             data: StakeData(amount, staker),
2256             prev: id,
2257             next: node.next
2258         }));
2259 
2260         newID = stakeNodes.length - 1;
2261 
2262         stakeNodes[node.next].prev = newID;
2263         node.next = newID;
2264         numStakers++;
2265     }
2266 
2267     function insertNodeBefore(uint id, uint amount, address staker) internal returns (uint) {
2268         return insertNodeAfter(stakeNodes[id].prev, amount, staker);
2269     }
2270 
2271     function removeNode(uint id) internal {
2272         require(isValidNode(id));
2273 
2274         Node storage node = stakeNodes[id];
2275 
2276         stakeNodes[node.next].prev = node.prev;
2277         stakeNodes[node.prev].next = node.next;
2278 
2279         delete stakeNodes[id];
2280         numStakers--;
2281     }
2282 
2283     // UPDATING OPERATORS
2284 
2285     function updateStakerRanking(address _staker) internal {
2286         uint newStakedAmount = stakedAmounts[_staker];
2287         if (newStakedAmount == 0) {
2288             isRanked[_staker] = false;
2289             removeStakerFromArray(_staker);
2290         } else if (isRanked[_staker]) {
2291             removeStakerFromArray(_staker);
2292             insertNodeSorted(newStakedAmount, _staker);
2293         } else {
2294             isRanked[_staker] = true;
2295             insertNodeSorted(newStakedAmount, _staker);
2296         }
2297     }
2298 
2299     function removeStakerFromArray(address _staker) internal {
2300         uint id = searchNode(_staker);
2301         require(id > 0);
2302         removeNode(id);
2303     }
2304 
2305 }
2306 
2307 contract CanonicalPriceFeed is OperatorStaking, SimplePriceFeed, CanonicalRegistrar {
2308 
2309     // EVENTS
2310     event SetupPriceFeed(address ofPriceFeed);
2311 
2312     struct HistoricalPrices {
2313         address[] assets;
2314         uint[] prices;
2315         uint timestamp;
2316     }
2317 
2318     // FIELDS
2319     bool public updatesAreAllowed = true;
2320     uint public minimumPriceCount = 1;
2321     uint public VALIDITY;
2322     uint public INTERVAL;
2323     mapping (address => bool) public isStakingFeed; // If the Staking Feed has been created through this contract
2324     HistoricalPrices[] public priceHistory;
2325 
2326     // METHODS
2327 
2328     // CONSTRUCTOR
2329 
2330     /// @dev Define and register a quote asset against which all prices are measured/based against
2331     /// @param ofStakingAsset Address of staking asset (may or may not be quoteAsset)
2332     /// @param ofQuoteAsset Address of quote asset
2333     /// @param quoteAssetName Name of quote asset
2334     /// @param quoteAssetSymbol Symbol for quote asset
2335     /// @param quoteAssetDecimals Decimal places for quote asset
2336     /// @param quoteAssetUrl URL related to quote asset
2337     /// @param quoteAssetIpfsHash IPFS hash associated with quote asset
2338     /// @param quoteAssetBreakInBreakOut Break-in/break-out for quote asset on destination chain
2339     /// @param quoteAssetStandards EIP standards quote asset adheres to
2340     /// @param quoteAssetFunctionSignatures Whitelisted functions of quote asset contract
2341     // /// @param interval Number of seconds between pricefeed updates (this interval is not enforced on-chain, but should be followed by the datafeed maintainer)
2342     // /// @param validity Number of seconds that datafeed update information is valid for
2343     /// @param ofGovernance Address of contract governing the Canonical PriceFeed
2344     function CanonicalPriceFeed(
2345         address ofStakingAsset,
2346         address ofQuoteAsset, // Inital entry in asset registrar contract is Melon (QUOTE_ASSET)
2347         bytes32 quoteAssetName,
2348         bytes8 quoteAssetSymbol,
2349         uint quoteAssetDecimals,
2350         string quoteAssetUrl,
2351         string quoteAssetIpfsHash,
2352         address[2] quoteAssetBreakInBreakOut,
2353         uint[] quoteAssetStandards,
2354         bytes4[] quoteAssetFunctionSignatures,
2355         uint[2] updateInfo, // interval, validity
2356         uint[3] stakingInfo, // minStake, numOperators, unstakeDelay
2357         address ofGovernance
2358     )
2359         OperatorStaking(
2360             AssetInterface(ofStakingAsset), stakingInfo[0], stakingInfo[1], stakingInfo[2]
2361         )
2362         SimplePriceFeed(address(this), ofQuoteAsset, address(0))
2363     {
2364         registerAsset(
2365             ofQuoteAsset,
2366             quoteAssetName,
2367             quoteAssetSymbol,
2368             quoteAssetDecimals,
2369             quoteAssetUrl,
2370             quoteAssetIpfsHash,
2371             quoteAssetBreakInBreakOut,
2372             quoteAssetStandards,
2373             quoteAssetFunctionSignatures
2374         );
2375         INTERVAL = updateInfo[0];
2376         VALIDITY = updateInfo[1];
2377         setOwner(ofGovernance);
2378     }
2379 
2380     // EXTERNAL METHODS
2381 
2382     /// @notice Create a new StakingPriceFeed
2383     function setupStakingPriceFeed() external {
2384         address ofStakingPriceFeed = new StakingPriceFeed(
2385             address(this),
2386             stakingToken,
2387             address(this)
2388         );
2389         isStakingFeed[ofStakingPriceFeed] = true;
2390         StakingPriceFeed(ofStakingPriceFeed).setOwner(msg.sender);
2391         emit SetupPriceFeed(ofStakingPriceFeed);
2392     }
2393 
2394     /// @dev override inherited update function to prevent manual update from authority
2395     function update() external { revert(); }
2396 
2397     /// @dev Burn state for a pricefeed operator
2398     /// @param user Address of pricefeed operator to burn the stake from
2399     function burnStake(address user)
2400         external
2401         auth
2402     {
2403         uint totalToBurn = add(stakedAmounts[user], stakeToWithdraw[user]);
2404         stakedAmounts[user] = 0;
2405         stakeToWithdraw[user] = 0;
2406         updateStakerRanking(user);
2407         emit StakeBurned(user, totalToBurn, "");
2408     }
2409 
2410     // PUBLIC METHODS
2411 
2412     // STAKING
2413 
2414     function stake(
2415         uint amount,
2416         bytes data
2417     )
2418         public
2419         pre_cond(isStakingFeed[msg.sender])
2420     {
2421         OperatorStaking.stake(amount, data);
2422     }
2423 
2424     // function stakeFor(
2425     //     address user,
2426     //     uint amount,
2427     //     bytes data
2428     // )
2429     //     public
2430     //     pre_cond(isStakingFeed[user])
2431     // {
2432 
2433     //     OperatorStaking.stakeFor(user, amount, data);
2434     // }
2435 
2436     // AGGREGATION
2437 
2438     /// @dev Only Owner; Same sized input arrays
2439     /// @dev Updates price of asset relative to QUOTE_ASSET
2440     /** Ex:
2441      *  Let QUOTE_ASSET == MLN (base units), let asset == EUR-T,
2442      *  let Value of 1 EUR-T := 1 EUR == 0.080456789 MLN, hence price 0.080456789 MLN / EUR-T
2443      *  and let EUR-T decimals == 8.
2444      *  Input would be: information[EUR-T].price = 8045678 [MLN/ (EUR-T * 10**8)]
2445      */
2446     /// @param ofAssets list of asset addresses
2447     function collectAndUpdate(address[] ofAssets)
2448         public
2449         auth
2450         pre_cond(updatesAreAllowed)
2451     {
2452         uint[] memory newPrices = pricesToCommit(ofAssets);
2453         priceHistory.push(
2454             HistoricalPrices({assets: ofAssets, prices: newPrices, timestamp: block.timestamp})
2455         );
2456         _updatePrices(ofAssets, newPrices);
2457     }
2458 
2459     function pricesToCommit(address[] ofAssets)
2460         view
2461         returns (uint[])
2462     {
2463         address[] memory operators = getOperators();
2464         uint[] memory newPrices = new uint[](ofAssets.length);
2465         for (uint i = 0; i < ofAssets.length; i++) {
2466             uint[] memory assetPrices = new uint[](operators.length);
2467             for (uint j = 0; j < operators.length; j++) {
2468                 SimplePriceFeed feed = SimplePriceFeed(operators[j]);
2469                 var (price, timestamp) = feed.assetsToPrices(ofAssets[i]);
2470                 if (now > add(timestamp, VALIDITY)) {
2471                     continue; // leaves a zero in the array (dealt with later)
2472                 }
2473                 assetPrices[j] = price;
2474             }
2475             newPrices[i] = medianize(assetPrices);
2476         }
2477         return newPrices;
2478     }
2479 
2480     /// @dev from MakerDao medianizer contract
2481     function medianize(uint[] unsorted)
2482         view
2483         returns (uint)
2484     {
2485         uint numValidEntries;
2486         for (uint i = 0; i < unsorted.length; i++) {
2487             if (unsorted[i] != 0) {
2488                 numValidEntries++;
2489             }
2490         }
2491         if (numValidEntries < minimumPriceCount) {
2492             revert();
2493         }
2494         uint counter;
2495         uint[] memory out = new uint[](numValidEntries);
2496         for (uint j = 0; j < unsorted.length; j++) {
2497             uint item = unsorted[j];
2498             if (item != 0) {    // skip zero (invalid) entries
2499                 if (counter == 0 || item >= out[counter - 1]) {
2500                     out[counter] = item;  // item is larger than last in array (we are home)
2501                 } else {
2502                     uint k = 0;
2503                     while (item >= out[k]) {
2504                         k++;  // get to where element belongs (between smaller and larger items)
2505                     }
2506                     for (uint l = counter; l > k; l--) {
2507                         out[l] = out[l - 1];    // bump larger elements rightward to leave slot
2508                     }
2509                     out[k] = item;
2510                 }
2511                 counter++;
2512             }
2513         }
2514 
2515         uint value;
2516         if (counter % 2 == 0) {
2517             uint value1 = uint(out[(counter / 2) - 1]);
2518             uint value2 = uint(out[(counter / 2)]);
2519             value = add(value1, value2) / 2;
2520         } else {
2521             value = out[(counter - 1) / 2];
2522         }
2523         return value;
2524     }
2525 
2526     function setMinimumPriceCount(uint newCount) auth { minimumPriceCount = newCount; }
2527     function enableUpdates() auth { updatesAreAllowed = true; }
2528     function disableUpdates() auth { updatesAreAllowed = false; }
2529 
2530     // PUBLIC VIEW METHODS
2531 
2532     // FEED INFORMATION
2533 
2534     function getQuoteAsset() view returns (address) { return QUOTE_ASSET; }
2535     function getInterval() view returns (uint) { return INTERVAL; }
2536     function getValidity() view returns (uint) { return VALIDITY; }
2537     function getLastUpdateId() view returns (uint) { return updateId; }
2538 
2539     // PRICES
2540 
2541     /// @notice Whether price of asset has been updated less than VALIDITY seconds ago
2542     /// @param ofAsset Asset in registrar
2543     /// @return isRecent Price information ofAsset is recent
2544     function hasRecentPrice(address ofAsset)
2545         view
2546         pre_cond(assetIsRegistered(ofAsset))
2547         returns (bool isRecent)
2548     {
2549         var ( , timestamp) = getPrice(ofAsset);
2550         return (sub(now, timestamp) <= VALIDITY);
2551     }
2552 
2553     /// @notice Whether prices of assets have been updated less than VALIDITY seconds ago
2554     /// @param ofAssets All assets in registrar
2555     /// @return isRecent Price information ofAssets array is recent
2556     function hasRecentPrices(address[] ofAssets)
2557         view
2558         returns (bool areRecent)
2559     {
2560         for (uint i; i < ofAssets.length; i++) {
2561             if (!hasRecentPrice(ofAssets[i])) {
2562                 return false;
2563             }
2564         }
2565         return true;
2566     }
2567 
2568     function getPriceInfo(address ofAsset)
2569         view
2570         returns (bool isRecent, uint price, uint assetDecimals)
2571     {
2572         isRecent = hasRecentPrice(ofAsset);
2573         (price, ) = getPrice(ofAsset);
2574         assetDecimals = getDecimals(ofAsset);
2575     }
2576 
2577     /**
2578     @notice Gets inverted price of an asset
2579     @dev Asset has been initialised and its price is non-zero
2580     @dev Existing price ofAssets quoted in QUOTE_ASSET (convention)
2581     @param ofAsset Asset for which inverted price should be return
2582     @return {
2583         "isRecent": "Whether the price is fresh, given VALIDITY interval",
2584         "invertedPrice": "Price based (instead of quoted) against QUOTE_ASSET",
2585         "assetDecimals": "Decimal places for this asset"
2586     }
2587     */
2588     function getInvertedPriceInfo(address ofAsset)
2589         view
2590         returns (bool isRecent, uint invertedPrice, uint assetDecimals)
2591     {
2592         uint inputPrice;
2593         // inputPrice quoted in QUOTE_ASSET and multiplied by 10 ** assetDecimal
2594         (isRecent, inputPrice, assetDecimals) = getPriceInfo(ofAsset);
2595 
2596         // outputPrice based in QUOTE_ASSET and multiplied by 10 ** quoteDecimal
2597         uint quoteDecimals = getDecimals(QUOTE_ASSET);
2598 
2599         return (
2600             isRecent,
2601             mul(10 ** uint(quoteDecimals), 10 ** uint(assetDecimals)) / inputPrice,
2602             quoteDecimals   // TODO: check on this; shouldn't it be assetDecimals?
2603         );
2604     }
2605 
2606     /**
2607     @notice Gets reference price of an asset pair
2608     @dev One of the address is equal to quote asset
2609     @dev either ofBase == QUOTE_ASSET or ofQuote == QUOTE_ASSET
2610     @param ofBase Address of base asset
2611     @param ofQuote Address of quote asset
2612     @return {
2613         "isRecent": "Whether the price is fresh, given VALIDITY interval",
2614         "referencePrice": "Reference price",
2615         "decimal": "Decimal places for this asset"
2616     }
2617     */
2618     function getReferencePriceInfo(address ofBase, address ofQuote)
2619         view
2620         returns (bool isRecent, uint referencePrice, uint decimal)
2621     {
2622         if (getQuoteAsset() == ofQuote) {
2623             (isRecent, referencePrice, decimal) = getPriceInfo(ofBase);
2624         } else if (getQuoteAsset() == ofBase) {
2625             (isRecent, referencePrice, decimal) = getInvertedPriceInfo(ofQuote);
2626         } else {
2627             revert(); // no suitable reference price available
2628         }
2629     }
2630 
2631     /// @notice Gets price of Order
2632     /// @param sellAsset Address of the asset to be sold
2633     /// @param buyAsset Address of the asset to be bought
2634     /// @param sellQuantity Quantity in base units being sold of sellAsset
2635     /// @param buyQuantity Quantity in base units being bought of buyAsset
2636     /// @return orderPrice Price as determined by an order
2637     function getOrderPriceInfo(
2638         address sellAsset,
2639         address buyAsset,
2640         uint sellQuantity,
2641         uint buyQuantity
2642     )
2643         view
2644         returns (uint orderPrice)
2645     {
2646         return mul(buyQuantity, 10 ** uint(getDecimals(sellAsset))) / sellQuantity;
2647     }
2648 
2649     /// @notice Checks whether data exists for a given asset pair
2650     /// @dev Prices are only upated against QUOTE_ASSET
2651     /// @param sellAsset Asset for which check to be done if data exists
2652     /// @param buyAsset Asset for which check to be done if data exists
2653     /// @return Whether assets exist for given asset pair
2654     function existsPriceOnAssetPair(address sellAsset, address buyAsset)
2655         view
2656         returns (bool isExistent)
2657     {
2658         return
2659             hasRecentPrice(sellAsset) && // Is tradable asset (TODO cleaner) and datafeed delivering data
2660             hasRecentPrice(buyAsset) && // Is tradable asset (TODO cleaner) and datafeed delivering data
2661             (buyAsset == QUOTE_ASSET || sellAsset == QUOTE_ASSET) && // One asset must be QUOTE_ASSET
2662             (buyAsset != QUOTE_ASSET || sellAsset != QUOTE_ASSET); // Pair must consists of diffrent assets
2663     }
2664 
2665     /// @return Sparse array of addresses of owned pricefeeds
2666     function getPriceFeedsByOwner(address _owner)
2667         view
2668         returns(address[])
2669     {
2670         address[] memory ofPriceFeeds = new address[](numStakers);
2671         if (numStakers == 0) return ofPriceFeeds;
2672         uint current = stakeNodes[0].next;
2673         for (uint i; i < numStakers; i++) {
2674             StakingPriceFeed stakingFeed = StakingPriceFeed(stakeNodes[current].data.staker);
2675             if (stakingFeed.owner() == _owner) {
2676                 ofPriceFeeds[i] = address(stakingFeed);
2677             }
2678             current = stakeNodes[current].next;
2679         }
2680         return ofPriceFeeds;
2681     }
2682 
2683     function getHistoryLength() returns (uint) { return priceHistory.length; }
2684 
2685     function getHistoryAt(uint id) returns (address[], uint[], uint) {
2686         address[] memory assets = priceHistory[id].assets;
2687         uint[] memory prices = priceHistory[id].prices;
2688         uint timestamp = priceHistory[id].timestamp;
2689         return (assets, prices, timestamp);
2690     }
2691 }
2692 
2693 interface VersionInterface {
2694 
2695     // EVENTS
2696 
2697     event FundUpdated(uint id);
2698 
2699     // PUBLIC METHODS
2700 
2701     function shutDown() external;
2702 
2703     function setupFund(
2704         bytes32 ofFundName,
2705         address ofQuoteAsset,
2706         uint ofManagementFee,
2707         uint ofPerformanceFee,
2708         address ofCompliance,
2709         address ofRiskMgmt,
2710         address[] ofExchanges,
2711         address[] ofDefaultAssets,
2712         uint8 v,
2713         bytes32 r,
2714         bytes32 s
2715     );
2716     function shutDownFund(address ofFund);
2717 
2718     // PUBLIC VIEW METHODS
2719 
2720     function getNativeAsset() view returns (address);
2721     function getFundById(uint withId) view returns (address);
2722     function getLastFundId() view returns (uint);
2723     function getFundByManager(address ofManager) view returns (address);
2724     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed);
2725 
2726 }
2727 
2728 contract Version is DBC, Owned, VersionInterface {
2729     // FIELDS
2730 
2731     bytes32 public constant TERMS_AND_CONDITIONS = 0xD35EBA0B0FF284A240D50F43381D8A1E00F19FBFDBF5162224335251A7D6D154; // Hashed terms and conditions as displayed on IPFS, decoded from base 58
2732 
2733     // Constructor fields
2734     string public VERSION_NUMBER; // SemVer of Melon protocol version
2735     address public MELON_ASSET; // Address of Melon asset contract
2736     address public NATIVE_ASSET; // Address of Fixed quote asset
2737     address public GOVERNANCE; // Address of Melon protocol governance contract
2738     address public CANONICAL_PRICEFEED; // Address of the canonical pricefeed
2739 
2740     // Methods fields
2741     bool public isShutDown; // Governance feature, if yes than setupFund gets blocked and shutDownFund gets opened
2742     address public COMPLIANCE; // restrict to Competition compliance module for this version
2743     address[] public listOfFunds; // A complete list of fund addresses created using this version
2744     mapping (address => address) public managerToFunds; // Links manager address to fund address created using this version
2745 
2746     // EVENTS
2747 
2748     event FundUpdated(address ofFund);
2749 
2750     // METHODS
2751 
2752     // CONSTRUCTOR
2753 
2754     /// @param versionNumber SemVer of Melon protocol version
2755     /// @param ofGovernance Address of Melon governance contract
2756     /// @param ofMelonAsset Address of Melon asset contract
2757     function Version(
2758         string versionNumber,
2759         address ofGovernance,
2760         address ofMelonAsset,
2761         address ofNativeAsset,
2762         address ofCanonicalPriceFeed,
2763         address ofCompetitionCompliance
2764     ) {
2765         VERSION_NUMBER = versionNumber;
2766         GOVERNANCE = ofGovernance;
2767         MELON_ASSET = ofMelonAsset;
2768         NATIVE_ASSET = ofNativeAsset;
2769         CANONICAL_PRICEFEED = ofCanonicalPriceFeed;
2770         COMPLIANCE = ofCompetitionCompliance;
2771     }
2772 
2773     // EXTERNAL METHODS
2774 
2775     function shutDown() external pre_cond(msg.sender == GOVERNANCE) { isShutDown = true; }
2776 
2777     // PUBLIC METHODS
2778 
2779     /// @param ofFundName human-readable descriptive name (not necessarily unique)
2780     /// @param ofQuoteAsset Asset against which performance fee is measured against
2781     /// @param ofManagementFee A time based fee, given in a number which is divided by 10 ** 15
2782     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 10 ** 15
2783     /// @param ofCompliance Address of participation module
2784     /// @param ofRiskMgmt Address of risk management module
2785     /// @param ofExchanges Addresses of exchange on which this fund can trade
2786     /// @param ofDefaultAssets Enable invest/redeem with these assets (quote asset already enabled)
2787     /// @param v ellipitc curve parameter v
2788     /// @param r ellipitc curve parameter r
2789     /// @param s ellipitc curve parameter s
2790     function setupFund(
2791         bytes32 ofFundName,
2792         address ofQuoteAsset,
2793         uint ofManagementFee,
2794         uint ofPerformanceFee,
2795         address ofCompliance,
2796         address ofRiskMgmt,
2797         address[] ofExchanges,
2798         address[] ofDefaultAssets,
2799         uint8 v,
2800         bytes32 r,
2801         bytes32 s
2802     ) {
2803         require(!isShutDown);
2804         require(termsAndConditionsAreSigned(v, r, s));
2805         require(CompetitionCompliance(COMPLIANCE).isCompetitionAllowed(msg.sender));
2806         require(managerToFunds[msg.sender] == address(0)); // Add limitation for simpler migration process of shutting down and setting up fund
2807         address[] memory melonAsDefaultAsset = new address[](1);
2808         melonAsDefaultAsset[0] = MELON_ASSET; // Melon asset should be in default assets
2809         address ofFund = new Fund(
2810             msg.sender,
2811             ofFundName,
2812             NATIVE_ASSET,
2813             0,
2814             0,
2815             COMPLIANCE,
2816             ofRiskMgmt,
2817             CANONICAL_PRICEFEED,
2818             ofExchanges,
2819             melonAsDefaultAsset
2820         );
2821         listOfFunds.push(ofFund);
2822         managerToFunds[msg.sender] = ofFund;
2823         emit FundUpdated(ofFund);
2824     }
2825 
2826     /// @dev Dereference Fund and shut it down
2827     /// @param ofFund Address of the fund to be shut down
2828     function shutDownFund(address ofFund)
2829         pre_cond(isShutDown || managerToFunds[msg.sender] == ofFund)
2830     {
2831         Fund fund = Fund(ofFund);
2832         delete managerToFunds[msg.sender];
2833         fund.shutDown();
2834         emit FundUpdated(ofFund);
2835     }
2836 
2837     // PUBLIC VIEW METHODS
2838 
2839     /// @dev Proof that terms and conditions have been read and understood
2840     /// @param v ellipitc curve parameter v
2841     /// @param r ellipitc curve parameter r
2842     /// @param s ellipitc curve parameter s
2843     /// @return signed Whether or not terms and conditions have been read and understood
2844     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed) {
2845         return ecrecover(
2846             // Parity does prepend \x19Ethereum Signed Message:\n{len(message)} before signing.
2847             //  Signature order has also been changed in 1.6.7 and upcoming 1.7.x,
2848             //  it will return rsv (same as geth; where v is [27, 28]).
2849             // Note that if you are using ecrecover, v will be either "00" or "01".
2850             //  As a result, in order to use this value, you will have to parse it to an
2851             //  integer and then add 27. This will result in either a 27 or a 28.
2852             //  https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethsign
2853             keccak256("\x19Ethereum Signed Message:\n32", TERMS_AND_CONDITIONS),
2854             v,
2855             r,
2856             s
2857         ) == msg.sender; // Has sender signed TERMS_AND_CONDITIONS
2858     }
2859 
2860     function getNativeAsset() view returns (address) { return NATIVE_ASSET; }
2861     function getFundById(uint withId) view returns (address) { return listOfFunds[withId]; }
2862     function getLastFundId() view returns (uint) { return listOfFunds.length - 1; }
2863     function getFundByManager(address ofManager) view returns (address) { return managerToFunds[ofManager]; }
2864 }