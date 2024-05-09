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
1473 contract Competition is CompetitionInterface, DSMath, DBC, Owned {
1474 
1475     // TYPES
1476 
1477     struct Registrant {
1478         address fund; // Address of the Melon fund
1479         address registrant; // Manager and registrant of the fund
1480         bool hasSigned; // Whether initial requirements passed and Registrant signed Terms and Conditions;
1481         uint buyinQuantity; // Quantity of buyinAsset spent
1482         uint payoutQuantity; // Quantity of payoutAsset received as prize
1483         bool isRewarded; // Is the Registrant rewarded yet
1484     }
1485 
1486     struct RegistrantId {
1487         uint id; // Actual Registrant Id
1488         bool exists; // Used to check if the mapping exists
1489     }
1490 
1491     // FIELDS
1492 
1493     // Constant fields
1494     // Competition terms and conditions as displayed on https://ipfs.io/ipfs/QmXuUfPi6xeYfuMwpVAughm7GjGUjkbEojhNR8DJqVBBxc
1495     // IPFS hash encoded using http://lenschulwitz.com/base58
1496     bytes public constant TERMS_AND_CONDITIONS = hex"1220B9C6706EE79792E49C633E9CB95D98E9104FB9B25D1F3D46FCC6519108251992";
1497     uint public MELON_BASE_UNIT = 10 ** 18;
1498     // Constructor fields
1499     address public custodian; // Address of the custodian which holds the funds sent
1500     uint public startTime; // Competition start time in seconds (Temporarily Set)
1501     uint public endTime; // Competition end time in seconds
1502     uint public payoutRate; // Fixed MLN - Ether conversion rate
1503     uint public bonusRate; // Bonus multiplier
1504     uint public totalMaxBuyin; // Limit amount of deposit to participate in competition (Valued in Ether)
1505     uint public currentTotalBuyin; // Total buyin till now
1506     uint public maxRegistrants; // Limit number of participate in competition
1507     uint public prizeMoneyAsset; // Equivalent to payoutAsset
1508     uint public prizeMoneyQuantity; // Total prize money pool
1509     address public MELON_ASSET; // Adresss of Melon asset contract
1510     ERC20Interface public MELON_CONTRACT; // Melon as ERC20 contract
1511     address public COMPETITION_VERSION; // Version contract address
1512 
1513     // Methods fields
1514     Registrant[] public registrants; // List of all registrants, can be externally accessed
1515     mapping (address => address) public registeredFundToRegistrants; // For fund address indexed accessing of registrant addresses
1516     mapping(address => RegistrantId) public registrantToRegistrantIds; // For registrant address indexed accessing of registrant ids
1517     mapping(address => uint) public whitelistantToMaxBuyin; // For registrant address to respective max buyIn cap (Valued in Ether)
1518 
1519     //EVENTS
1520 
1521     event Register(uint withId, address fund, address manager);
1522 
1523     // METHODS
1524 
1525     // CONSTRUCTOR
1526 
1527     function Competition(
1528         address ofMelonAsset,
1529         address ofCompetitionVersion,
1530         address ofCustodian,
1531         uint ofStartTime,
1532         uint ofEndTime,
1533         uint ofPayoutRate,
1534         uint ofTotalMaxBuyin,
1535         uint ofMaxRegistrants
1536     ) {
1537         MELON_ASSET = ofMelonAsset;
1538         MELON_CONTRACT = ERC20Interface(MELON_ASSET);
1539         COMPETITION_VERSION = ofCompetitionVersion;
1540         custodian = ofCustodian;
1541         startTime = ofStartTime;
1542         endTime = ofEndTime;
1543         payoutRate = ofPayoutRate;
1544         totalMaxBuyin = ofTotalMaxBuyin;
1545         maxRegistrants = ofMaxRegistrants;
1546     }
1547 
1548     // PRE, POST, INVARIANT CONDITIONS
1549 
1550     /// @dev Proofs that terms and conditions have been read and understood
1551     /// @param byManager Address of the fund manager, as used in the ipfs-frontend
1552     /// @param v ellipitc curve parameter v
1553     /// @param r ellipitc curve parameter r
1554     /// @param s ellipitc curve parameter s
1555     /// @return Whether or not terms and conditions have been read and understood
1556     function termsAndConditionsAreSigned(address byManager, uint8 v, bytes32 r, bytes32 s) view returns (bool) {
1557         return ecrecover(
1558             // Parity does prepend \x19Ethereum Signed Message:\n{len(message)} before signing.
1559             //  Signature order has also been changed in 1.6.7 and upcoming 1.7.x,
1560             //  it will return rsv (same as geth; where v is [27, 28]).
1561             // Note that if you are using ecrecover, v will be either "00" or "01".
1562             //  As a result, in order to use this value, you will have to parse it to an
1563             //  integer and then add 27. This will result in either a 27 or a 28.
1564             //  https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethsign
1565             keccak256("\x19Ethereum Signed Message:\n34", TERMS_AND_CONDITIONS),
1566             v,
1567             r,
1568             s
1569         ) == byManager; // Has sender signed TERMS_AND_CONDITIONS
1570     }
1571 
1572     /// @dev Whether message sender is KYC verified through CERTIFIER
1573     /// @param x Address to be checked for KYC verification
1574     function isWhitelisted(address x) view returns (bool) { return whitelistantToMaxBuyin[x] > 0; }
1575 
1576     /// @dev Whether the competition is on-going
1577     function isCompetitionActive() view returns (bool) { return now >= startTime && now < endTime; }
1578 
1579     // CONSTANT METHODS
1580 
1581     function getMelonAsset() view returns (address) { return MELON_ASSET; }
1582 
1583     /// @return Get RegistrantId from registrant address
1584     function getRegistrantId(address x) view returns (uint) { return registrantToRegistrantIds[x].id; }
1585 
1586     /// @return Address of the fund registered by the registrant address
1587     function getRegistrantFund(address x) view returns (address) { return registrants[getRegistrantId(x)].fund; }
1588 
1589     /// @return Get time to end of the competition
1590     function getTimeTillEnd() view returns (uint) {
1591         if (now > endTime) {
1592             return 0;
1593         }
1594         return sub(endTime, now);
1595     }
1596 
1597     /// @return Get value of MLN amount in Ether
1598     function getEtherValue(uint amount) view returns (uint) {
1599         address feedAddress = Version(COMPETITION_VERSION).CANONICAL_PRICEFEED();
1600         var (isRecent, price, ) = CanonicalPriceFeed(feedAddress).getPriceInfo(MELON_ASSET);
1601         if (!isRecent) {
1602             revert();
1603         }
1604         return mul(price, amount) / 10 ** 18;
1605     }
1606 
1607     /// @return Calculated payout in MLN with bonus for payin in Ether
1608     function calculatePayout(uint payin) view returns (uint payoutQuantity) {
1609         payoutQuantity = mul(payin, payoutRate) / 10 ** 18;
1610     }
1611 
1612     /**
1613     @notice Returns an array of fund addresses and an associated array of whether competing and whether disqualified
1614     @return {
1615       "fundAddrs": "Array of addresses of Melon Funds",
1616       "fundRegistrants": "Array of addresses of Melon fund managers, as used in the ipfs-frontend",
1617     }
1618     */
1619     function getCompetitionStatusOfRegistrants()
1620         view
1621         returns(
1622             address[],
1623             address[],
1624             bool[]
1625         )
1626     {
1627         address[] memory fundAddrs = new address[](registrants.length);
1628         address[] memory fundRegistrants = new address[](registrants.length);
1629         bool[] memory isRewarded = new bool[](registrants.length);
1630 
1631         for (uint i = 0; i < registrants.length; i++) {
1632             fundAddrs[i] = registrants[i].fund;
1633             fundRegistrants[i] = registrants[i].registrant;
1634             isRewarded[i] = registrants[i].isRewarded;
1635         }
1636         return (fundAddrs, fundRegistrants, isRewarded);
1637     }
1638 
1639     // NON-CONSTANT METHODS
1640 
1641     /// @notice Register to take part in the competition
1642     /// @dev Check if the fund address is actually from the Competition Version
1643     /// @param fund Address of the Melon fund
1644     /// @param v ellipitc curve parameter v
1645     /// @param r ellipitc curve parameter r
1646     /// @param s ellipitc curve parameter s
1647     function registerForCompetition(
1648         address fund,
1649         uint8 v,
1650         bytes32 r,
1651         bytes32 s
1652     )
1653         payable
1654         pre_cond(isCompetitionActive() && !Version(COMPETITION_VERSION).isShutDown())
1655         pre_cond(termsAndConditionsAreSigned(msg.sender, v, r, s) && isWhitelisted(msg.sender))
1656     {
1657         require(registeredFundToRegistrants[fund] == address(0) && registrantToRegistrantIds[msg.sender].exists == false);
1658         require(add(currentTotalBuyin, msg.value) <= totalMaxBuyin && registrants.length < maxRegistrants);
1659         require(msg.value <= whitelistantToMaxBuyin[msg.sender]);
1660         require(Version(COMPETITION_VERSION).getFundByManager(msg.sender) == fund);
1661 
1662         // Calculate Payout Quantity, invest the quantity in registrant's fund
1663         uint payoutQuantity = calculatePayout(msg.value);
1664         registeredFundToRegistrants[fund] = msg.sender;
1665         registrantToRegistrantIds[msg.sender] = RegistrantId({id: registrants.length, exists: true});
1666         currentTotalBuyin = add(currentTotalBuyin, msg.value);
1667         FundInterface fundContract = FundInterface(fund);
1668         MELON_CONTRACT.approve(fund, payoutQuantity);
1669 
1670         // Give payoutRequest MLN in return for msg.value
1671         fundContract.requestInvestment(payoutQuantity, getEtherValue(payoutQuantity), MELON_ASSET);
1672         fundContract.executeRequest(fundContract.getLastRequestId());
1673         custodian.transfer(msg.value);
1674 
1675         // Emit Register event
1676         emit Register(registrants.length, fund, msg.sender);
1677 
1678         registrants.push(Registrant({
1679             fund: fund,
1680             registrant: msg.sender,
1681             hasSigned: true,
1682             buyinQuantity: msg.value,
1683             payoutQuantity: payoutQuantity,
1684             isRewarded: false
1685         }));
1686     }
1687 
1688     /// @notice Add batch addresses to whitelist with set maxBuyinQuantity
1689     /// @dev Only the owner can call this function
1690     /// @param maxBuyinQuantity Quantity of payoutAsset received as prize
1691     /// @param whitelistants Performance of Melon fund at competition endTime; Can be changed for any other comparison metric
1692     function batchAddToWhitelist(
1693         uint maxBuyinQuantity,
1694         address[] whitelistants
1695     )
1696         pre_cond(isOwner())
1697         pre_cond(now < endTime)
1698     {
1699         for (uint i = 0; i < whitelistants.length; ++i) {
1700             whitelistantToMaxBuyin[whitelistants[i]] = maxBuyinQuantity;
1701         }
1702     }
1703 
1704     /// @notice Withdraw MLN
1705     /// @dev Only the owner can call this function
1706     function withdrawMln(address to, uint amount)
1707         pre_cond(isOwner())
1708     {
1709         MELON_CONTRACT.transfer(to, amount);
1710     }
1711 
1712     /// @notice Claim Reward
1713     function claimReward()
1714         pre_cond(getRegistrantFund(msg.sender) != address(0))
1715     {
1716         require(block.timestamp >= endTime || Version(COMPETITION_VERSION).isShutDown());
1717         Registrant registrant  = registrants[getRegistrantId(msg.sender)];
1718         require(registrant.isRewarded == false);
1719         registrant.isRewarded = true;
1720         // Is this safe to assume this or should we transfer all the balance instead?
1721         uint balance = AssetInterface(registrant.fund).balanceOf(address(this));
1722         require(AssetInterface(registrant.fund).transfer(registrant.registrant, balance));
1723 
1724         // Emit ClaimedReward event
1725         emit ClaimReward(msg.sender, registrant.fund, balance);
1726     }
1727 }
1728 
1729 contract CompetitionCompliance is ComplianceInterface, DBC, Owned {
1730 
1731     address public competitionAddress;
1732 
1733     // CONSTRUCTOR
1734 
1735     /// @dev Constructor
1736     /// @param ofCompetition Address of the competition contract
1737     function CompetitionCompliance(address ofCompetition) public {
1738         competitionAddress = ofCompetition;
1739     }
1740 
1741     // PUBLIC VIEW METHODS
1742 
1743     /// @notice Checks whether investment is permitted for a participant
1744     /// @param ofParticipant Address requesting to invest in a Melon fund
1745     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
1746     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
1747     /// @return Whether identity is eligible to invest in a Melon fund.
1748     function isInvestmentPermitted(
1749         address ofParticipant,
1750         uint256 giveQuantity,
1751         uint256 shareQuantity
1752     )
1753         view
1754         returns (bool)
1755     {
1756         return competitionAddress == ofParticipant;
1757     }
1758 
1759     /// @notice Checks whether redemption is permitted for a participant
1760     /// @param ofParticipant Address requesting to redeem from a Melon fund
1761     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
1762     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
1763     /// @return isEligible Whether identity is eligible to redeem from a Melon fund.
1764     function isRedemptionPermitted(
1765         address ofParticipant,
1766         uint256 shareQuantity,
1767         uint256 receiveQuantity
1768     )
1769         view
1770         returns (bool)
1771     {
1772         return competitionAddress == ofParticipant;
1773     }
1774 
1775     /// @notice Checks whether an address is whitelisted in the competition contract and competition is active
1776     /// @param x Address
1777     /// @return Whether the address is whitelisted
1778     function isCompetitionAllowed(
1779         address x
1780     )
1781         view
1782         returns (bool)
1783     {
1784         return CompetitionInterface(competitionAddress).isWhitelisted(x) && CompetitionInterface(competitionAddress).isCompetitionActive();
1785     }
1786 
1787 
1788     // PUBLIC METHODS
1789 
1790     /// @notice Changes the competition address
1791     /// @param ofCompetition Address of the competition contract
1792     function changeCompetitionAddress(
1793         address ofCompetition
1794     )
1795         pre_cond(isOwner())
1796     {
1797         competitionAddress = ofCompetition;
1798     }
1799 
1800 }
1801 
1802 interface GenericExchangeInterface {
1803 
1804     // EVENTS
1805 
1806     event OrderUpdated(uint id);
1807 
1808     // METHODS
1809     // EXTERNAL METHODS
1810 
1811     function makeOrder(
1812         address onExchange,
1813         address sellAsset,
1814         address buyAsset,
1815         uint sellQuantity,
1816         uint buyQuantity
1817     ) external returns (uint);
1818     function takeOrder(address onExchange, uint id, uint quantity) external returns (bool);
1819     function cancelOrder(address onExchange, uint id) external returns (bool);
1820 
1821 
1822     // PUBLIC METHODS
1823     // PUBLIC VIEW METHODS
1824 
1825     function isApproveOnly() view returns (bool);
1826     function getLastOrderId(address onExchange) view returns (uint);
1827     function isActive(address onExchange, uint id) view returns (bool);
1828     function getOwner(address onExchange, uint id) view returns (address);
1829     function getOrder(address onExchange, uint id) view returns (address, address, uint, uint);
1830     function getTimestamp(address onExchange, uint id) view returns (uint);
1831 
1832 }
1833 
1834 contract CanonicalRegistrar is DSThing, DBC {
1835 
1836     // TYPES
1837 
1838     struct Asset {
1839         bool exists; // True if asset is registered here
1840         bytes32 name; // Human-readable name of the Asset as in ERC223 token standard
1841         bytes8 symbol; // Human-readable symbol of the Asset as in ERC223 token standard
1842         uint decimals; // Decimal, order of magnitude of precision, of the Asset as in ERC223 token standard
1843         string url; // URL for additional information of Asset
1844         string ipfsHash; // Same as url but for ipfs
1845         address breakIn; // Break in contract on destination chain
1846         address breakOut; // Break out contract on this chain; A way to leave
1847         uint[] standards; // compliance with standards like ERC20, ERC223, ERC777, etc. (the uint is the standard number)
1848         bytes4[] functionSignatures; // Whitelisted function signatures that can be called using `useExternalFunction` in Fund contract. Note: Adhere to a naming convention for `Fund<->Asset` as much as possible. I.e. name same concepts with the same functionSignature.
1849         uint price; // Price of asset quoted against `QUOTE_ASSET` * 10 ** decimals
1850         uint timestamp; // Timestamp of last price update of this asset
1851     }
1852 
1853     struct Exchange {
1854         bool exists;
1855         address adapter; // adapter contract for this exchange
1856         // One-time note: takesCustody is inverse case of isApproveOnly
1857         bool takesCustody; // True in case of exchange implementation which requires  are approved when an order is made instead of transfer
1858         bytes4[] functionSignatures; // Whitelisted function signatures that can be called using `useExternalFunction` in Fund contract. Note: Adhere to a naming convention for `Fund<->ExchangeAdapter` as much as possible. I.e. name same concepts with the same functionSignature.
1859     }
1860     // TODO: populate each field here
1861     // TODO: add whitelistFunction function
1862 
1863     // FIELDS
1864 
1865     // Methods fields
1866     mapping (address => Asset) public assetInformation;
1867     address[] public registeredAssets;
1868 
1869     mapping (address => Exchange) public exchangeInformation;
1870     address[] public registeredExchanges;
1871 
1872     // METHODS
1873 
1874     // PUBLIC METHODS
1875 
1876     /// @notice Registers an Asset information entry
1877     /// @dev Pre: Only registrar owner should be able to register
1878     /// @dev Post: Address ofAsset is registered
1879     /// @param ofAsset Address of asset to be registered
1880     /// @param inputName Human-readable name of the Asset as in ERC223 token standard
1881     /// @param inputSymbol Human-readable symbol of the Asset as in ERC223 token standard
1882     /// @param inputDecimals Human-readable symbol of the Asset as in ERC223 token standard
1883     /// @param inputUrl Url for extended information of the asset
1884     /// @param inputIpfsHash Same as url but for ipfs
1885     /// @param breakInBreakOut Address of break in and break out contracts on destination chain
1886     /// @param inputStandards Integers of EIP standards this asset adheres to
1887     /// @param inputFunctionSignatures Function signatures for whitelisted asset functions
1888     function registerAsset(
1889         address ofAsset,
1890         bytes32 inputName,
1891         bytes8 inputSymbol,
1892         uint inputDecimals,
1893         string inputUrl,
1894         string inputIpfsHash,
1895         address[2] breakInBreakOut,
1896         uint[] inputStandards,
1897         bytes4[] inputFunctionSignatures
1898     )
1899         auth
1900         pre_cond(!assetInformation[ofAsset].exists)
1901     {
1902         assetInformation[ofAsset].exists = true;
1903         registeredAssets.push(ofAsset);
1904         updateAsset(
1905             ofAsset,
1906             inputName,
1907             inputSymbol,
1908             inputDecimals,
1909             inputUrl,
1910             inputIpfsHash,
1911             breakInBreakOut,
1912             inputStandards,
1913             inputFunctionSignatures
1914         );
1915         assert(assetInformation[ofAsset].exists);
1916     }
1917 
1918     /// @notice Register an exchange information entry
1919     /// @dev Pre: Only registrar owner should be able to register
1920     /// @dev Post: Address ofExchange is registered
1921     /// @param ofExchange Address of the exchange
1922     /// @param ofExchangeAdapter Address of exchange adapter for this exchange
1923     /// @param inputTakesCustody Whether this exchange takes custody of tokens before trading
1924     /// @param inputFunctionSignatures Function signatures for whitelisted exchange functions
1925     function registerExchange(
1926         address ofExchange,
1927         address ofExchangeAdapter,
1928         bool inputTakesCustody,
1929         bytes4[] inputFunctionSignatures
1930     )
1931         auth
1932         pre_cond(!exchangeInformation[ofExchange].exists)
1933     {
1934         exchangeInformation[ofExchange].exists = true;
1935         registeredExchanges.push(ofExchange);
1936         updateExchange(
1937             ofExchange,
1938             ofExchangeAdapter,
1939             inputTakesCustody,
1940             inputFunctionSignatures
1941         );
1942         assert(exchangeInformation[ofExchange].exists);
1943     }
1944 
1945     /// @notice Updates description information of a registered Asset
1946     /// @dev Pre: Owner can change an existing entry
1947     /// @dev Post: Changed Name, Symbol, URL and/or IPFSHash
1948     /// @param ofAsset Address of the asset to be updated
1949     /// @param inputName Human-readable name of the Asset as in ERC223 token standard
1950     /// @param inputSymbol Human-readable symbol of the Asset as in ERC223 token standard
1951     /// @param inputUrl Url for extended information of the asset
1952     /// @param inputIpfsHash Same as url but for ipfs
1953     function updateAsset(
1954         address ofAsset,
1955         bytes32 inputName,
1956         bytes8 inputSymbol,
1957         uint inputDecimals,
1958         string inputUrl,
1959         string inputIpfsHash,
1960         address[2] ofBreakInBreakOut,
1961         uint[] inputStandards,
1962         bytes4[] inputFunctionSignatures
1963     )
1964         auth
1965         pre_cond(assetInformation[ofAsset].exists)
1966     {
1967         Asset asset = assetInformation[ofAsset];
1968         asset.name = inputName;
1969         asset.symbol = inputSymbol;
1970         asset.decimals = inputDecimals;
1971         asset.url = inputUrl;
1972         asset.ipfsHash = inputIpfsHash;
1973         asset.breakIn = ofBreakInBreakOut[0];
1974         asset.breakOut = ofBreakInBreakOut[1];
1975         asset.standards = inputStandards;
1976         asset.functionSignatures = inputFunctionSignatures;
1977     }
1978 
1979     function updateExchange(
1980         address ofExchange,
1981         address ofExchangeAdapter,
1982         bool inputTakesCustody,
1983         bytes4[] inputFunctionSignatures
1984     )
1985         auth
1986         pre_cond(exchangeInformation[ofExchange].exists)
1987     {
1988         Exchange exchange = exchangeInformation[ofExchange];
1989         exchange.adapter = ofExchangeAdapter;
1990         exchange.takesCustody = inputTakesCustody;
1991         exchange.functionSignatures = inputFunctionSignatures;
1992     }
1993 
1994     // TODO: check max size of array before remaking this becomes untenable
1995     /// @notice Deletes an existing entry
1996     /// @dev Owner can delete an existing entry
1997     /// @param ofAsset address for which specific information is requested
1998     function removeAsset(
1999         address ofAsset,
2000         uint assetIndex
2001     )
2002         auth
2003         pre_cond(assetInformation[ofAsset].exists)
2004     {
2005         require(registeredAssets[assetIndex] == ofAsset);
2006         delete assetInformation[ofAsset]; // Sets exists boolean to false
2007         delete registeredAssets[assetIndex];
2008         for (uint i = assetIndex; i < registeredAssets.length-1; i++) {
2009             registeredAssets[i] = registeredAssets[i+1];
2010         }
2011         registeredAssets.length--;
2012         assert(!assetInformation[ofAsset].exists);
2013     }
2014 
2015     /// @notice Deletes an existing entry
2016     /// @dev Owner can delete an existing entry
2017     /// @param ofExchange address for which specific information is requested
2018     /// @param exchangeIndex index of the exchange in array
2019     function removeExchange(
2020         address ofExchange,
2021         uint exchangeIndex
2022     )
2023         auth
2024         pre_cond(exchangeInformation[ofExchange].exists)
2025     {
2026         require(registeredExchanges[exchangeIndex] == ofExchange);
2027         delete exchangeInformation[ofExchange];
2028         delete registeredExchanges[exchangeIndex];
2029         for (uint i = exchangeIndex; i < registeredExchanges.length-1; i++) {
2030             registeredExchanges[i] = registeredExchanges[i+1];
2031         }
2032         registeredExchanges.length--;
2033         assert(!exchangeInformation[ofExchange].exists);
2034     }
2035 
2036     // PUBLIC VIEW METHODS
2037 
2038     // get asset specific information
2039     function getName(address ofAsset) view returns (bytes32) { return assetInformation[ofAsset].name; }
2040     function getSymbol(address ofAsset) view returns (bytes8) { return assetInformation[ofAsset].symbol; }
2041     function getDecimals(address ofAsset) view returns (uint) { return assetInformation[ofAsset].decimals; }
2042     function assetIsRegistered(address ofAsset) view returns (bool) { return assetInformation[ofAsset].exists; }
2043     function getRegisteredAssets() view returns (address[]) { return registeredAssets; }
2044     function assetMethodIsAllowed(
2045         address ofAsset, bytes4 querySignature
2046     )
2047         returns (bool)
2048     {
2049         bytes4[] memory signatures = assetInformation[ofAsset].functionSignatures;
2050         for (uint i = 0; i < signatures.length; i++) {
2051             if (signatures[i] == querySignature) {
2052                 return true;
2053             }
2054         }
2055         return false;
2056     }
2057 
2058     // get exchange-specific information
2059     function exchangeIsRegistered(address ofExchange) view returns (bool) { return exchangeInformation[ofExchange].exists; }
2060     function getRegisteredExchanges() view returns (address[]) { return registeredExchanges; }
2061     function getExchangeInformation(address ofExchange)
2062         view
2063         returns (address, bool)
2064     {
2065         Exchange exchange = exchangeInformation[ofExchange];
2066         return (
2067             exchange.adapter,
2068             exchange.takesCustody
2069         );
2070     }
2071     function getExchangeFunctionSignatures(address ofExchange)
2072         view
2073         returns (bytes4[])
2074     {
2075         return exchangeInformation[ofExchange].functionSignatures;
2076     }
2077     function exchangeMethodIsAllowed(
2078         address ofExchange, bytes4 querySignature
2079     )
2080         returns (bool)
2081     {
2082         bytes4[] memory signatures = exchangeInformation[ofExchange].functionSignatures;
2083         for (uint i = 0; i < signatures.length; i++) {
2084             if (signatures[i] == querySignature) {
2085                 return true;
2086             }
2087         }
2088         return false;
2089     }
2090 }
2091 
2092 interface SimplePriceFeedInterface {
2093 
2094     // EVENTS
2095 
2096     event PriceUpdated(bytes32 hash);
2097 
2098     // PUBLIC METHODS
2099 
2100     function update(address[] ofAssets, uint[] newPrices) external;
2101 
2102     // PUBLIC VIEW METHODS
2103 
2104     // Get price feed operation specific information
2105     function getQuoteAsset() view returns (address);
2106     function getLastUpdateId() view returns (uint);
2107     // Get asset specific information as updated in price feed
2108     function getPrice(address ofAsset) view returns (uint price, uint timestamp);
2109     function getPrices(address[] ofAssets) view returns (uint[] prices, uint[] timestamps);
2110 }
2111 
2112 contract SimplePriceFeed is SimplePriceFeedInterface, DSThing, DBC {
2113 
2114     // TYPES
2115     struct Data {
2116         uint price;
2117         uint timestamp;
2118     }
2119 
2120     // FIELDS
2121     mapping(address => Data) public assetsToPrices;
2122 
2123     // Constructor fields
2124     address public QUOTE_ASSET; // Asset of a portfolio against which all other assets are priced
2125 
2126     // Contract-level variables
2127     uint public updateId;        // Update counter for this pricefeed; used as a check during investment
2128     CanonicalRegistrar public registrar;
2129     CanonicalPriceFeed public superFeed;
2130 
2131     // METHODS
2132 
2133     // CONSTRUCTOR
2134 
2135     /// @param ofQuoteAsset Address of quote asset
2136     /// @param ofRegistrar Address of canonical registrar
2137     /// @param ofSuperFeed Address of superfeed
2138     function SimplePriceFeed(
2139         address ofRegistrar,
2140         address ofQuoteAsset,
2141         address ofSuperFeed
2142     ) {
2143         registrar = CanonicalRegistrar(ofRegistrar);
2144         QUOTE_ASSET = ofQuoteAsset;
2145         superFeed = CanonicalPriceFeed(ofSuperFeed);
2146     }
2147 
2148     // EXTERNAL METHODS
2149 
2150     /// @dev Only Owner; Same sized input arrays
2151     /// @dev Updates price of asset relative to QUOTE_ASSET
2152     /** Ex:
2153      *  Let QUOTE_ASSET == MLN (base units), let asset == EUR-T,
2154      *  let Value of 1 EUR-T := 1 EUR == 0.080456789 MLN, hence price 0.080456789 MLN / EUR-T
2155      *  and let EUR-T decimals == 8.
2156      *  Input would be: information[EUR-T].price = 8045678 [MLN/ (EUR-T * 10**8)]
2157      */
2158     /// @param ofAssets list of asset addresses
2159     /// @param newPrices list of prices for each of the assets
2160     function update(address[] ofAssets, uint[] newPrices)
2161         external
2162         auth
2163     {
2164         _updatePrices(ofAssets, newPrices);
2165     }
2166 
2167     // PUBLIC VIEW METHODS
2168 
2169     // Get pricefeed specific information
2170     function getQuoteAsset() view returns (address) { return QUOTE_ASSET; }
2171     function getLastUpdateId() view returns (uint) { return updateId; }
2172 
2173     /**
2174     @notice Gets price of an asset multiplied by ten to the power of assetDecimals
2175     @dev Asset has been registered
2176     @param ofAsset Asset for which price should be returned
2177     @return {
2178       "price": "Price formatting: mul(exchangePrice, 10 ** decimal), to avoid floating numbers",
2179       "timestamp": "When the asset's price was updated"
2180     }
2181     */
2182     function getPrice(address ofAsset)
2183         view
2184         returns (uint price, uint timestamp)
2185     {
2186         Data data = assetsToPrices[ofAsset];
2187         return (data.price, data.timestamp);
2188     }
2189 
2190     /**
2191     @notice Price of a registered asset in format (bool areRecent, uint[] prices, uint[] decimals)
2192     @dev Convention for price formatting: mul(price, 10 ** decimal), to avoid floating numbers
2193     @param ofAssets Assets for which prices should be returned
2194     @return {
2195         "prices":       "Array of prices",
2196         "timestamps":   "Array of timestamps",
2197     }
2198     */
2199     function getPrices(address[] ofAssets)
2200         view
2201         returns (uint[], uint[])
2202     {
2203         uint[] memory prices = new uint[](ofAssets.length);
2204         uint[] memory timestamps = new uint[](ofAssets.length);
2205         for (uint i; i < ofAssets.length; i++) {
2206             var (price, timestamp) = getPrice(ofAssets[i]);
2207             prices[i] = price;
2208             timestamps[i] = timestamp;
2209         }
2210         return (prices, timestamps);
2211     }
2212 
2213     // INTERNAL METHODS
2214 
2215     /// @dev Internal so that feeds inheriting this one are not obligated to have an exposed update(...) method, but can still perform updates
2216     function _updatePrices(address[] ofAssets, uint[] newPrices)
2217         internal
2218         pre_cond(ofAssets.length == newPrices.length)
2219     {
2220         updateId++;
2221         for (uint i = 0; i < ofAssets.length; ++i) {
2222             require(registrar.assetIsRegistered(ofAssets[i]));
2223             require(assetsToPrices[ofAssets[i]].timestamp != now); // prevent two updates in one block
2224             assetsToPrices[ofAssets[i]].timestamp = now;
2225             assetsToPrices[ofAssets[i]].price = newPrices[i];
2226         }
2227         emit PriceUpdated(keccak256(ofAssets, newPrices));
2228     }
2229 }
2230 
2231 contract StakingPriceFeed is SimplePriceFeed {
2232 
2233     OperatorStaking public stakingContract;
2234     AssetInterface public stakingToken;
2235 
2236     // CONSTRUCTOR
2237 
2238     /// @param ofQuoteAsset Address of quote asset
2239     /// @param ofRegistrar Address of canonical registrar
2240     /// @param ofSuperFeed Address of superfeed
2241     function StakingPriceFeed(
2242         address ofRegistrar,
2243         address ofQuoteAsset,
2244         address ofSuperFeed
2245     )
2246         SimplePriceFeed(ofRegistrar, ofQuoteAsset, ofSuperFeed)
2247     {
2248         stakingContract = OperatorStaking(ofSuperFeed); // canonical feed *is* staking contract
2249         stakingToken = AssetInterface(stakingContract.stakingToken());
2250     }
2251 
2252     // EXTERNAL METHODS
2253 
2254     /// @param amount Number of tokens to stake for this feed
2255     /// @param data Data may be needed for some future applications (can be empty for now)
2256     function depositStake(uint amount, bytes data)
2257         external
2258         auth
2259     {
2260         require(stakingToken.transferFrom(msg.sender, address(this), amount));
2261         require(stakingToken.approve(stakingContract, amount));
2262         stakingContract.stake(amount, data);
2263     }
2264 
2265     /// @param amount Number of tokens to unstake for this feed
2266     /// @param data Data may be needed for some future applications (can be empty for now)
2267     function unstake(uint amount, bytes data) {
2268         stakingContract.unstake(amount, data);
2269     }
2270 
2271     function withdrawStake()
2272         external
2273         auth
2274     {
2275         uint amountToWithdraw = stakingContract.stakeToWithdraw(address(this));
2276         stakingContract.withdrawStake();
2277         require(stakingToken.transfer(msg.sender, amountToWithdraw));
2278     }
2279 }
2280 
2281 interface RiskMgmtInterface {
2282 
2283     // METHODS
2284     // PUBLIC VIEW METHODS
2285 
2286     /// @notice Checks if the makeOrder price is reasonable and not manipulative
2287     /// @param orderPrice Price of Order
2288     /// @param referencePrice Reference price obtained through PriceFeed contract
2289     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
2290     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
2291     /// @param sellQuantity Quantity of sellAsset to be sold
2292     /// @param buyQuantity Quantity of buyAsset to be bought
2293     /// @return If makeOrder is permitted
2294     function isMakePermitted(
2295         uint orderPrice,
2296         uint referencePrice,
2297         address sellAsset,
2298         address buyAsset,
2299         uint sellQuantity,
2300         uint buyQuantity
2301     ) view returns (bool);
2302 
2303     /// @notice Checks if the takeOrder price is reasonable and not manipulative
2304     /// @param orderPrice Price of Order
2305     /// @param referencePrice Reference price obtained through PriceFeed contract
2306     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
2307     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
2308     /// @param sellQuantity Quantity of sellAsset to be sold
2309     /// @param buyQuantity Quantity of buyAsset to be bought
2310     /// @return If takeOrder is permitted
2311     function isTakePermitted(
2312         uint orderPrice,
2313         uint referencePrice,
2314         address sellAsset,
2315         address buyAsset,
2316         uint sellQuantity,
2317         uint buyQuantity
2318     ) view returns (bool);
2319 }
2320 
2321 contract OperatorStaking is DBC {
2322 
2323     // EVENTS
2324 
2325     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
2326     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
2327     event StakeBurned(address indexed user, uint256 amount, bytes data);
2328 
2329     // TYPES
2330 
2331     struct StakeData {
2332         uint amount;
2333         address staker;
2334     }
2335 
2336     // Circular linked list
2337     struct Node {
2338         StakeData data;
2339         uint prev;
2340         uint next;
2341     }
2342 
2343     // FIELDS
2344 
2345     // INTERNAL FIELDS
2346     Node[] internal stakeNodes; // Sorted circular linked list nodes containing stake data (Built on top https://programtheblockchain.com/posts/2018/03/30/storage-patterns-doubly-linked-list/)
2347 
2348     // PUBLIC FIELDS
2349     uint public minimumStake;
2350     uint public numOperators;
2351     uint public withdrawalDelay;
2352     mapping (address => bool) public isRanked;
2353     mapping (address => uint) public latestUnstakeTime;
2354     mapping (address => uint) public stakeToWithdraw;
2355     mapping (address => uint) public stakedAmounts;
2356     uint public numStakers; // Current number of stakers (Needed because of array holes)
2357     AssetInterface public stakingToken;
2358 
2359     // TODO: consider renaming "operator" depending on how this is implemented
2360     //  (i.e. is pricefeed staking itself?)
2361     function OperatorStaking(
2362         AssetInterface _stakingToken,
2363         uint _minimumStake,
2364         uint _numOperators,
2365         uint _withdrawalDelay
2366     )
2367         public
2368     {
2369         require(address(_stakingToken) != address(0));
2370         stakingToken = _stakingToken;
2371         minimumStake = _minimumStake;
2372         numOperators = _numOperators;
2373         withdrawalDelay = _withdrawalDelay;
2374         StakeData memory temp = StakeData({ amount: 0, staker: address(0) });
2375         stakeNodes.push(Node(temp, 0, 0));
2376     }
2377 
2378     // METHODS : STAKING
2379 
2380     function stake(
2381         uint amount,
2382         bytes data
2383     )
2384         public
2385         pre_cond(amount >= minimumStake)
2386     {
2387         uint tailNodeId = stakeNodes[0].prev;
2388         stakedAmounts[msg.sender] += amount;
2389         updateStakerRanking(msg.sender);
2390         require(stakingToken.transferFrom(msg.sender, address(this), amount));
2391     }
2392 
2393     function unstake(
2394         uint amount,
2395         bytes data
2396     )
2397         public
2398     {
2399         uint preStake = stakedAmounts[msg.sender];
2400         uint postStake = preStake - amount;
2401         require(postStake >= minimumStake || postStake == 0);
2402         require(stakedAmounts[msg.sender] >= amount);
2403         latestUnstakeTime[msg.sender] = block.timestamp;
2404         stakedAmounts[msg.sender] -= amount;
2405         stakeToWithdraw[msg.sender] += amount;
2406         updateStakerRanking(msg.sender);
2407         emit Unstaked(msg.sender, amount, stakedAmounts[msg.sender], data);
2408     }
2409 
2410     function withdrawStake()
2411         public
2412         pre_cond(stakeToWithdraw[msg.sender] > 0)
2413         pre_cond(block.timestamp >= latestUnstakeTime[msg.sender] + withdrawalDelay)
2414     {
2415         uint amount = stakeToWithdraw[msg.sender];
2416         stakeToWithdraw[msg.sender] = 0;
2417         require(stakingToken.transfer(msg.sender, amount));
2418     }
2419 
2420     // VIEW FUNCTIONS
2421 
2422     function isValidNode(uint id) view returns (bool) {
2423         // 0 is a sentinel and therefore invalid.
2424         // A valid node is the head or has a previous node.
2425         return id != 0 && (id == stakeNodes[0].next || stakeNodes[id].prev != 0);
2426     }
2427 
2428     function searchNode(address staker) view returns (uint) {
2429         uint current = stakeNodes[0].next;
2430         while (isValidNode(current)) {
2431             if (staker == stakeNodes[current].data.staker) {
2432                 return current;
2433             }
2434             current = stakeNodes[current].next;
2435         }
2436         return 0;
2437     }
2438 
2439     function isOperator(address user) view returns (bool) {
2440         address[] memory operators = getOperators();
2441         for (uint i; i < operators.length; i++) {
2442             if (operators[i] == user) {
2443                 return true;
2444             }
2445         }
2446         return false;
2447     }
2448 
2449     function getOperators()
2450         view
2451         returns (address[])
2452     {
2453         uint arrLength = (numOperators > numStakers) ?
2454             numStakers :
2455             numOperators;
2456         address[] memory operators = new address[](arrLength);
2457         uint current = stakeNodes[0].next;
2458         for (uint i; i < arrLength; i++) {
2459             operators[i] = stakeNodes[current].data.staker;
2460             current = stakeNodes[current].next;
2461         }
2462         return operators;
2463     }
2464 
2465     function getStakersAndAmounts()
2466         view
2467         returns (address[], uint[])
2468     {
2469         address[] memory stakers = new address[](numStakers);
2470         uint[] memory amounts = new uint[](numStakers);
2471         uint current = stakeNodes[0].next;
2472         for (uint i; i < numStakers; i++) {
2473             stakers[i] = stakeNodes[current].data.staker;
2474             amounts[i] = stakeNodes[current].data.amount;
2475             current = stakeNodes[current].next;
2476         }
2477         return (stakers, amounts);
2478     }
2479 
2480     function totalStakedFor(address user)
2481         view
2482         returns (uint)
2483     {
2484         return stakedAmounts[user];
2485     }
2486 
2487     // INTERNAL METHODS
2488 
2489     // DOUBLY-LINKED LIST
2490 
2491     function insertNodeSorted(uint amount, address staker) internal returns (uint) {
2492         uint current = stakeNodes[0].next;
2493         if (current == 0) return insertNodeAfter(0, amount, staker);
2494         while (isValidNode(current)) {
2495             if (amount > stakeNodes[current].data.amount) {
2496                 break;
2497             }
2498             current = stakeNodes[current].next;
2499         }
2500         return insertNodeBefore(current, amount, staker);
2501     }
2502 
2503     function insertNodeAfter(uint id, uint amount, address staker) internal returns (uint newID) {
2504 
2505         // 0 is allowed here to insert at the beginning.
2506         require(id == 0 || isValidNode(id));
2507 
2508         Node storage node = stakeNodes[id];
2509 
2510         stakeNodes.push(Node({
2511             data: StakeData(amount, staker),
2512             prev: id,
2513             next: node.next
2514         }));
2515 
2516         newID = stakeNodes.length - 1;
2517 
2518         stakeNodes[node.next].prev = newID;
2519         node.next = newID;
2520         numStakers++;
2521     }
2522 
2523     function insertNodeBefore(uint id, uint amount, address staker) internal returns (uint) {
2524         return insertNodeAfter(stakeNodes[id].prev, amount, staker);
2525     }
2526 
2527     function removeNode(uint id) internal {
2528         require(isValidNode(id));
2529 
2530         Node storage node = stakeNodes[id];
2531 
2532         stakeNodes[node.next].prev = node.prev;
2533         stakeNodes[node.prev].next = node.next;
2534 
2535         delete stakeNodes[id];
2536         numStakers--;
2537     }
2538 
2539     // UPDATING OPERATORS
2540 
2541     function updateStakerRanking(address _staker) internal {
2542         uint newStakedAmount = stakedAmounts[_staker];
2543         if (newStakedAmount == 0) {
2544             isRanked[_staker] = false;
2545             removeStakerFromArray(_staker);
2546         } else if (isRanked[_staker]) {
2547             removeStakerFromArray(_staker);
2548             insertNodeSorted(newStakedAmount, _staker);
2549         } else {
2550             isRanked[_staker] = true;
2551             insertNodeSorted(newStakedAmount, _staker);
2552         }
2553     }
2554 
2555     function removeStakerFromArray(address _staker) internal {
2556         uint id = searchNode(_staker);
2557         require(id > 0);
2558         removeNode(id);
2559     }
2560 
2561 }
2562 
2563 contract CanonicalPriceFeed is OperatorStaking, SimplePriceFeed, CanonicalRegistrar {
2564 
2565     // EVENTS
2566     event SetupPriceFeed(address ofPriceFeed);
2567 
2568     struct HistoricalPrices {
2569         address[] assets;
2570         uint[] prices;
2571         uint timestamp;
2572     }
2573 
2574     // FIELDS
2575     bool public updatesAreAllowed = true;
2576     uint public minimumPriceCount = 1;
2577     uint public VALIDITY;
2578     uint public INTERVAL;
2579     mapping (address => bool) public isStakingFeed; // If the Staking Feed has been created through this contract
2580     HistoricalPrices[] public priceHistory;
2581 
2582     // METHODS
2583 
2584     // CONSTRUCTOR
2585 
2586     /// @dev Define and register a quote asset against which all prices are measured/based against
2587     /// @param ofStakingAsset Address of staking asset (may or may not be quoteAsset)
2588     /// @param ofQuoteAsset Address of quote asset
2589     /// @param quoteAssetName Name of quote asset
2590     /// @param quoteAssetSymbol Symbol for quote asset
2591     /// @param quoteAssetDecimals Decimal places for quote asset
2592     /// @param quoteAssetUrl URL related to quote asset
2593     /// @param quoteAssetIpfsHash IPFS hash associated with quote asset
2594     /// @param quoteAssetBreakInBreakOut Break-in/break-out for quote asset on destination chain
2595     /// @param quoteAssetStandards EIP standards quote asset adheres to
2596     /// @param quoteAssetFunctionSignatures Whitelisted functions of quote asset contract
2597     // /// @param interval Number of seconds between pricefeed updates (this interval is not enforced on-chain, but should be followed by the datafeed maintainer)
2598     // /// @param validity Number of seconds that datafeed update information is valid for
2599     /// @param ofGovernance Address of contract governing the Canonical PriceFeed
2600     function CanonicalPriceFeed(
2601         address ofStakingAsset,
2602         address ofQuoteAsset, // Inital entry in asset registrar contract is Melon (QUOTE_ASSET)
2603         bytes32 quoteAssetName,
2604         bytes8 quoteAssetSymbol,
2605         uint quoteAssetDecimals,
2606         string quoteAssetUrl,
2607         string quoteAssetIpfsHash,
2608         address[2] quoteAssetBreakInBreakOut,
2609         uint[] quoteAssetStandards,
2610         bytes4[] quoteAssetFunctionSignatures,
2611         uint[2] updateInfo, // interval, validity
2612         uint[3] stakingInfo, // minStake, numOperators, unstakeDelay
2613         address ofGovernance
2614     )
2615         OperatorStaking(
2616             AssetInterface(ofStakingAsset), stakingInfo[0], stakingInfo[1], stakingInfo[2]
2617         )
2618         SimplePriceFeed(address(this), ofQuoteAsset, address(0))
2619     {
2620         registerAsset(
2621             ofQuoteAsset,
2622             quoteAssetName,
2623             quoteAssetSymbol,
2624             quoteAssetDecimals,
2625             quoteAssetUrl,
2626             quoteAssetIpfsHash,
2627             quoteAssetBreakInBreakOut,
2628             quoteAssetStandards,
2629             quoteAssetFunctionSignatures
2630         );
2631         INTERVAL = updateInfo[0];
2632         VALIDITY = updateInfo[1];
2633         setOwner(ofGovernance);
2634     }
2635 
2636     // EXTERNAL METHODS
2637 
2638     /// @notice Create a new StakingPriceFeed
2639     function setupStakingPriceFeed() external {
2640         address ofStakingPriceFeed = new StakingPriceFeed(
2641             address(this),
2642             stakingToken,
2643             address(this)
2644         );
2645         isStakingFeed[ofStakingPriceFeed] = true;
2646         StakingPriceFeed(ofStakingPriceFeed).setOwner(msg.sender);
2647         emit SetupPriceFeed(ofStakingPriceFeed);
2648     }
2649 
2650     /// @dev override inherited update function to prevent manual update from authority
2651     function update() external { revert(); }
2652 
2653     /// @dev Burn state for a pricefeed operator
2654     /// @param user Address of pricefeed operator to burn the stake from
2655     function burnStake(address user)
2656         external
2657         auth
2658     {
2659         uint totalToBurn = add(stakedAmounts[user], stakeToWithdraw[user]);
2660         stakedAmounts[user] = 0;
2661         stakeToWithdraw[user] = 0;
2662         updateStakerRanking(user);
2663         emit StakeBurned(user, totalToBurn, "");
2664     }
2665 
2666     // PUBLIC METHODS
2667 
2668     // STAKING
2669 
2670     function stake(
2671         uint amount,
2672         bytes data
2673     )
2674         public
2675         pre_cond(isStakingFeed[msg.sender])
2676     {
2677         OperatorStaking.stake(amount, data);
2678     }
2679 
2680     // function stakeFor(
2681     //     address user,
2682     //     uint amount,
2683     //     bytes data
2684     // )
2685     //     public
2686     //     pre_cond(isStakingFeed[user])
2687     // {
2688 
2689     //     OperatorStaking.stakeFor(user, amount, data);
2690     // }
2691 
2692     // AGGREGATION
2693 
2694     /// @dev Only Owner; Same sized input arrays
2695     /// @dev Updates price of asset relative to QUOTE_ASSET
2696     /** Ex:
2697      *  Let QUOTE_ASSET == MLN (base units), let asset == EUR-T,
2698      *  let Value of 1 EUR-T := 1 EUR == 0.080456789 MLN, hence price 0.080456789 MLN / EUR-T
2699      *  and let EUR-T decimals == 8.
2700      *  Input would be: information[EUR-T].price = 8045678 [MLN/ (EUR-T * 10**8)]
2701      */
2702     /// @param ofAssets list of asset addresses
2703     function collectAndUpdate(address[] ofAssets)
2704         public
2705         auth
2706         pre_cond(updatesAreAllowed)
2707     {
2708         uint[] memory newPrices = pricesToCommit(ofAssets);
2709         priceHistory.push(
2710             HistoricalPrices({assets: ofAssets, prices: newPrices, timestamp: block.timestamp})
2711         );
2712         _updatePrices(ofAssets, newPrices);
2713     }
2714 
2715     function pricesToCommit(address[] ofAssets)
2716         view
2717         returns (uint[])
2718     {
2719         address[] memory operators = getOperators();
2720         uint[] memory newPrices = new uint[](ofAssets.length);
2721         for (uint i = 0; i < ofAssets.length; i++) {
2722             uint[] memory assetPrices = new uint[](operators.length);
2723             for (uint j = 0; j < operators.length; j++) {
2724                 SimplePriceFeed feed = SimplePriceFeed(operators[j]);
2725                 var (price, timestamp) = feed.assetsToPrices(ofAssets[i]);
2726                 if (now > add(timestamp, VALIDITY)) {
2727                     continue; // leaves a zero in the array (dealt with later)
2728                 }
2729                 assetPrices[j] = price;
2730             }
2731             newPrices[i] = medianize(assetPrices);
2732         }
2733         return newPrices;
2734     }
2735 
2736     /// @dev from MakerDao medianizer contract
2737     function medianize(uint[] unsorted)
2738         view
2739         returns (uint)
2740     {
2741         uint numValidEntries;
2742         for (uint i = 0; i < unsorted.length; i++) {
2743             if (unsorted[i] != 0) {
2744                 numValidEntries++;
2745             }
2746         }
2747         if (numValidEntries < minimumPriceCount) {
2748             revert();
2749         }
2750         uint counter;
2751         uint[] memory out = new uint[](numValidEntries);
2752         for (uint j = 0; j < unsorted.length; j++) {
2753             uint item = unsorted[j];
2754             if (item != 0) {    // skip zero (invalid) entries
2755                 if (counter == 0 || item >= out[counter - 1]) {
2756                     out[counter] = item;  // item is larger than last in array (we are home)
2757                 } else {
2758                     uint k = 0;
2759                     while (item >= out[k]) {
2760                         k++;  // get to where element belongs (between smaller and larger items)
2761                     }
2762                     for (uint l = counter; l > k; l--) {
2763                         out[l] = out[l - 1];    // bump larger elements rightward to leave slot
2764                     }
2765                     out[k] = item;
2766                 }
2767                 counter++;
2768             }
2769         }
2770 
2771         uint value;
2772         if (counter % 2 == 0) {
2773             uint value1 = uint(out[(counter / 2) - 1]);
2774             uint value2 = uint(out[(counter / 2)]);
2775             value = add(value1, value2) / 2;
2776         } else {
2777             value = out[(counter - 1) / 2];
2778         }
2779         return value;
2780     }
2781 
2782     function setMinimumPriceCount(uint newCount) auth { minimumPriceCount = newCount; }
2783     function enableUpdates() auth { updatesAreAllowed = true; }
2784     function disableUpdates() auth { updatesAreAllowed = false; }
2785 
2786     // PUBLIC VIEW METHODS
2787 
2788     // FEED INFORMATION
2789 
2790     function getQuoteAsset() view returns (address) { return QUOTE_ASSET; }
2791     function getInterval() view returns (uint) { return INTERVAL; }
2792     function getValidity() view returns (uint) { return VALIDITY; }
2793     function getLastUpdateId() view returns (uint) { return updateId; }
2794 
2795     // PRICES
2796 
2797     /// @notice Whether price of asset has been updated less than VALIDITY seconds ago
2798     /// @param ofAsset Asset in registrar
2799     /// @return isRecent Price information ofAsset is recent
2800     function hasRecentPrice(address ofAsset)
2801         view
2802         pre_cond(assetIsRegistered(ofAsset))
2803         returns (bool isRecent)
2804     {
2805         var ( , timestamp) = getPrice(ofAsset);
2806         return (sub(now, timestamp) <= VALIDITY);
2807     }
2808 
2809     /// @notice Whether prices of assets have been updated less than VALIDITY seconds ago
2810     /// @param ofAssets All assets in registrar
2811     /// @return isRecent Price information ofAssets array is recent
2812     function hasRecentPrices(address[] ofAssets)
2813         view
2814         returns (bool areRecent)
2815     {
2816         for (uint i; i < ofAssets.length; i++) {
2817             if (!hasRecentPrice(ofAssets[i])) {
2818                 return false;
2819             }
2820         }
2821         return true;
2822     }
2823 
2824     function getPriceInfo(address ofAsset)
2825         view
2826         returns (bool isRecent, uint price, uint assetDecimals)
2827     {
2828         isRecent = hasRecentPrice(ofAsset);
2829         (price, ) = getPrice(ofAsset);
2830         assetDecimals = getDecimals(ofAsset);
2831     }
2832 
2833     /**
2834     @notice Gets inverted price of an asset
2835     @dev Asset has been initialised and its price is non-zero
2836     @dev Existing price ofAssets quoted in QUOTE_ASSET (convention)
2837     @param ofAsset Asset for which inverted price should be return
2838     @return {
2839         "isRecent": "Whether the price is fresh, given VALIDITY interval",
2840         "invertedPrice": "Price based (instead of quoted) against QUOTE_ASSET",
2841         "assetDecimals": "Decimal places for this asset"
2842     }
2843     */
2844     function getInvertedPriceInfo(address ofAsset)
2845         view
2846         returns (bool isRecent, uint invertedPrice, uint assetDecimals)
2847     {
2848         uint inputPrice;
2849         // inputPrice quoted in QUOTE_ASSET and multiplied by 10 ** assetDecimal
2850         (isRecent, inputPrice, assetDecimals) = getPriceInfo(ofAsset);
2851 
2852         // outputPrice based in QUOTE_ASSET and multiplied by 10 ** quoteDecimal
2853         uint quoteDecimals = getDecimals(QUOTE_ASSET);
2854 
2855         return (
2856             isRecent,
2857             mul(10 ** uint(quoteDecimals), 10 ** uint(assetDecimals)) / inputPrice,
2858             quoteDecimals   // TODO: check on this; shouldn't it be assetDecimals?
2859         );
2860     }
2861 
2862     /**
2863     @notice Gets reference price of an asset pair
2864     @dev One of the address is equal to quote asset
2865     @dev either ofBase == QUOTE_ASSET or ofQuote == QUOTE_ASSET
2866     @param ofBase Address of base asset
2867     @param ofQuote Address of quote asset
2868     @return {
2869         "isRecent": "Whether the price is fresh, given VALIDITY interval",
2870         "referencePrice": "Reference price",
2871         "decimal": "Decimal places for this asset"
2872     }
2873     */
2874     function getReferencePriceInfo(address ofBase, address ofQuote)
2875         view
2876         returns (bool isRecent, uint referencePrice, uint decimal)
2877     {
2878         if (getQuoteAsset() == ofQuote) {
2879             (isRecent, referencePrice, decimal) = getPriceInfo(ofBase);
2880         } else if (getQuoteAsset() == ofBase) {
2881             (isRecent, referencePrice, decimal) = getInvertedPriceInfo(ofQuote);
2882         } else {
2883             revert(); // no suitable reference price available
2884         }
2885     }
2886 
2887     /// @notice Gets price of Order
2888     /// @param sellAsset Address of the asset to be sold
2889     /// @param buyAsset Address of the asset to be bought
2890     /// @param sellQuantity Quantity in base units being sold of sellAsset
2891     /// @param buyQuantity Quantity in base units being bought of buyAsset
2892     /// @return orderPrice Price as determined by an order
2893     function getOrderPriceInfo(
2894         address sellAsset,
2895         address buyAsset,
2896         uint sellQuantity,
2897         uint buyQuantity
2898     )
2899         view
2900         returns (uint orderPrice)
2901     {
2902         return mul(buyQuantity, 10 ** uint(getDecimals(sellAsset))) / sellQuantity;
2903     }
2904 
2905     /// @notice Checks whether data exists for a given asset pair
2906     /// @dev Prices are only upated against QUOTE_ASSET
2907     /// @param sellAsset Asset for which check to be done if data exists
2908     /// @param buyAsset Asset for which check to be done if data exists
2909     /// @return Whether assets exist for given asset pair
2910     function existsPriceOnAssetPair(address sellAsset, address buyAsset)
2911         view
2912         returns (bool isExistent)
2913     {
2914         return
2915             hasRecentPrice(sellAsset) && // Is tradable asset (TODO cleaner) and datafeed delivering data
2916             hasRecentPrice(buyAsset) && // Is tradable asset (TODO cleaner) and datafeed delivering data
2917             (buyAsset == QUOTE_ASSET || sellAsset == QUOTE_ASSET) && // One asset must be QUOTE_ASSET
2918             (buyAsset != QUOTE_ASSET || sellAsset != QUOTE_ASSET); // Pair must consists of diffrent assets
2919     }
2920 
2921     /// @return Sparse array of addresses of owned pricefeeds
2922     function getPriceFeedsByOwner(address _owner)
2923         view
2924         returns(address[])
2925     {
2926         address[] memory ofPriceFeeds = new address[](numStakers);
2927         if (numStakers == 0) return ofPriceFeeds;
2928         uint current = stakeNodes[0].next;
2929         for (uint i; i < numStakers; i++) {
2930             StakingPriceFeed stakingFeed = StakingPriceFeed(stakeNodes[current].data.staker);
2931             if (stakingFeed.owner() == _owner) {
2932                 ofPriceFeeds[i] = address(stakingFeed);
2933             }
2934             current = stakeNodes[current].next;
2935         }
2936         return ofPriceFeeds;
2937     }
2938 
2939     function getHistoryLength() returns (uint) { return priceHistory.length; }
2940 
2941     function getHistoryAt(uint id) returns (address[], uint[], uint) {
2942         address[] memory assets = priceHistory[id].assets;
2943         uint[] memory prices = priceHistory[id].prices;
2944         uint timestamp = priceHistory[id].timestamp;
2945         return (assets, prices, timestamp);
2946     }
2947 }
2948 
2949 interface VersionInterface {
2950 
2951     // EVENTS
2952 
2953     event FundUpdated(uint id);
2954 
2955     // PUBLIC METHODS
2956 
2957     function shutDown() external;
2958 
2959     function setupFund(
2960         bytes32 ofFundName,
2961         address ofQuoteAsset,
2962         uint ofManagementFee,
2963         uint ofPerformanceFee,
2964         address ofCompliance,
2965         address ofRiskMgmt,
2966         address[] ofExchanges,
2967         address[] ofDefaultAssets,
2968         uint8 v,
2969         bytes32 r,
2970         bytes32 s
2971     );
2972     function shutDownFund(address ofFund);
2973 
2974     // PUBLIC VIEW METHODS
2975 
2976     function getNativeAsset() view returns (address);
2977     function getFundById(uint withId) view returns (address);
2978     function getLastFundId() view returns (uint);
2979     function getFundByManager(address ofManager) view returns (address);
2980     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed);
2981 
2982 }
2983 
2984 contract Version is DBC, Owned, VersionInterface {
2985     // FIELDS
2986 
2987     bytes32 public constant TERMS_AND_CONDITIONS = 0xD35EBA0B0FF284A240D50F43381D8A1E00F19FBFDBF5162224335251A7D6D154; // Hashed terms and conditions as displayed on IPFS, decoded from base 58
2988 
2989     // Constructor fields
2990     string public VERSION_NUMBER; // SemVer of Melon protocol version
2991     address public MELON_ASSET; // Address of Melon asset contract
2992     address public NATIVE_ASSET; // Address of Fixed quote asset
2993     address public GOVERNANCE; // Address of Melon protocol governance contract
2994     address public CANONICAL_PRICEFEED; // Address of the canonical pricefeed
2995 
2996     // Methods fields
2997     bool public isShutDown; // Governance feature, if yes than setupFund gets blocked and shutDownFund gets opened
2998     address public COMPLIANCE; // restrict to Competition compliance module for this version
2999     address[] public listOfFunds; // A complete list of fund addresses created using this version
3000     mapping (address => address) public managerToFunds; // Links manager address to fund address created using this version
3001 
3002     // EVENTS
3003 
3004     event FundUpdated(address ofFund);
3005 
3006     // METHODS
3007 
3008     // CONSTRUCTOR
3009 
3010     /// @param versionNumber SemVer of Melon protocol version
3011     /// @param ofGovernance Address of Melon governance contract
3012     /// @param ofMelonAsset Address of Melon asset contract
3013     function Version(
3014         string versionNumber,
3015         address ofGovernance,
3016         address ofMelonAsset,
3017         address ofNativeAsset,
3018         address ofCanonicalPriceFeed,
3019         address ofCompetitionCompliance
3020     ) {
3021         VERSION_NUMBER = versionNumber;
3022         GOVERNANCE = ofGovernance;
3023         MELON_ASSET = ofMelonAsset;
3024         NATIVE_ASSET = ofNativeAsset;
3025         CANONICAL_PRICEFEED = ofCanonicalPriceFeed;
3026         COMPLIANCE = ofCompetitionCompliance;
3027     }
3028 
3029     // EXTERNAL METHODS
3030 
3031     function shutDown() external pre_cond(msg.sender == GOVERNANCE) { isShutDown = true; }
3032 
3033     // PUBLIC METHODS
3034 
3035     /// @param ofFundName human-readable descriptive name (not necessarily unique)
3036     /// @param ofQuoteAsset Asset against which performance fee is measured against
3037     /// @param ofManagementFee A time based fee, given in a number which is divided by 10 ** 15
3038     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 10 ** 15
3039     /// @param ofCompliance Address of participation module
3040     /// @param ofRiskMgmt Address of risk management module
3041     /// @param ofExchanges Addresses of exchange on which this fund can trade
3042     /// @param ofDefaultAssets Enable invest/redeem with these assets (quote asset already enabled)
3043     /// @param v ellipitc curve parameter v
3044     /// @param r ellipitc curve parameter r
3045     /// @param s ellipitc curve parameter s
3046     function setupFund(
3047         bytes32 ofFundName,
3048         address ofQuoteAsset,
3049         uint ofManagementFee,
3050         uint ofPerformanceFee,
3051         address ofCompliance,
3052         address ofRiskMgmt,
3053         address[] ofExchanges,
3054         address[] ofDefaultAssets,
3055         uint8 v,
3056         bytes32 r,
3057         bytes32 s
3058     ) {
3059         require(!isShutDown);
3060         require(termsAndConditionsAreSigned(v, r, s));
3061         require(CompetitionCompliance(COMPLIANCE).isCompetitionAllowed(msg.sender));
3062         require(managerToFunds[msg.sender] == address(0)); // Add limitation for simpler migration process of shutting down and setting up fund
3063         address[] memory melonAsDefaultAsset = new address[](1);
3064         melonAsDefaultAsset[0] = MELON_ASSET; // Melon asset should be in default assets
3065         address ofFund = new Fund(
3066             msg.sender,
3067             ofFundName,
3068             NATIVE_ASSET,
3069             0,
3070             0,
3071             COMPLIANCE,
3072             ofRiskMgmt,
3073             CANONICAL_PRICEFEED,
3074             ofExchanges,
3075             melonAsDefaultAsset
3076         );
3077         listOfFunds.push(ofFund);
3078         managerToFunds[msg.sender] = ofFund;
3079         emit FundUpdated(ofFund);
3080     }
3081 
3082     /// @dev Dereference Fund and shut it down
3083     /// @param ofFund Address of the fund to be shut down
3084     function shutDownFund(address ofFund)
3085         pre_cond(isShutDown || managerToFunds[msg.sender] == ofFund)
3086     {
3087         Fund fund = Fund(ofFund);
3088         delete managerToFunds[msg.sender];
3089         fund.shutDown();
3090         emit FundUpdated(ofFund);
3091     }
3092 
3093     // PUBLIC VIEW METHODS
3094 
3095     /// @dev Proof that terms and conditions have been read and understood
3096     /// @param v ellipitc curve parameter v
3097     /// @param r ellipitc curve parameter r
3098     /// @param s ellipitc curve parameter s
3099     /// @return signed Whether or not terms and conditions have been read and understood
3100     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed) {
3101         return ecrecover(
3102             // Parity does prepend \x19Ethereum Signed Message:\n{len(message)} before signing.
3103             //  Signature order has also been changed in 1.6.7 and upcoming 1.7.x,
3104             //  it will return rsv (same as geth; where v is [27, 28]).
3105             // Note that if you are using ecrecover, v will be either "00" or "01".
3106             //  As a result, in order to use this value, you will have to parse it to an
3107             //  integer and then add 27. This will result in either a 27 or a 28.
3108             //  https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethsign
3109             keccak256("\x19Ethereum Signed Message:\n32", TERMS_AND_CONDITIONS),
3110             v,
3111             r,
3112             s
3113         ) == msg.sender; // Has sender signed TERMS_AND_CONDITIONS
3114     }
3115 
3116     function getNativeAsset() view returns (address) { return NATIVE_ASSET; }
3117     function getFundById(uint withId) view returns (address) { return listOfFunds[withId]; }
3118     function getLastFundId() view returns (uint) { return listOfFunds.length - 1; }
3119     function getFundByManager(address ofManager) view returns (address) { return managerToFunds[ofManager]; }
3120 }