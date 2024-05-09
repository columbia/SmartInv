1 pragma solidity ^0.4.13;
2 
3 interface IAffiliateList {
4     /**
5      * @dev Sets the given address as an affiliate.
6      *      If the address is not currently an affiliate, startTimestamp is required
7      *      and endTimestamp is optional.
8      *      If the address is already registered as an affiliate, both values are optional.
9      * @param startTimestamp Timestamp when the address became/becomes an affiliate.
10      * @param endTimestamp Timestamp when the address will no longer be an affiliate.
11      */
12     function set(address addr, uint startTimestamp, uint endTimestamp) external;
13 
14     /**
15      * @dev Retrieves the start and end timestamps for the given address.
16      *      It is sufficient to check the start value to determine if the address
17      *      is an affiliate (start will be greater than zero).
18      */
19     function get(address addr) external view returns (uint start, uint end);
20 
21     /**
22      * @dev Returns true if the address is, was, or will be an affiliate at the given time.
23      */
24     function inListAsOf(address addr, uint time) external view returns (bool);
25 }
26 
27 contract ERC20Basic {
28     function totalSupply() public view returns (uint256);
29     function balanceOf(address who) public view returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract IInvestorList {
35     string public constant ROLE_REGD = "regd";
36     string public constant ROLE_REGCF = "regcf";
37     string public constant ROLE_REGS = "regs";
38     string public constant ROLE_UNKNOWN = "unknown";
39 
40     function inList(address addr) public view returns (bool);
41     function addAddress(address addr, string role) public;
42     function getRole(address addr) public view returns (string);
43     function hasRole(address addr, string role) public view returns (bool);
44 }
45 
46 contract Ownable {
47     address public owner;
48     address public newOwner;
49 
50     /**
51      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52      * account.
53      */
54     constructor() public {
55         owner = msg.sender;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     /**
67      * @dev Starts the 2-step process of changing ownership. The new owner
68      * must then call `acceptOwnership()`.
69      */
70     function changeOwner(address _newOwner) public onlyOwner {
71         newOwner = _newOwner;
72     }
73 
74     /**
75      * @dev Completes the process of transferring ownership to a new owner.
76      */
77     function acceptOwnership() public {
78         if (msg.sender == newOwner) {
79             owner = newOwner;
80             newOwner = 0;
81         }
82     }
83 
84 }
85 
86 contract AffiliateList is Ownable, IAffiliateList {
87     event AffiliateAdded(address addr, uint startTimestamp, uint endTimestamp);
88     event AffiliateUpdated(address addr, uint startTimestamp, uint endTimestamp);
89 
90     mapping (address => uint) public affiliateStart;
91     mapping (address => uint) public affiliateEnd;
92 
93     function set(address addr, uint startTimestamp, uint endTimestamp) public onlyOwner {
94         require(addr != address(0));
95 
96         uint existingStart = affiliateStart[addr];
97 
98         if(existingStart == 0) {
99             // this is a new address
100 
101             require(startTimestamp != 0);
102             affiliateStart[addr] = startTimestamp;
103 
104             if(endTimestamp != 0) {
105                 require(endTimestamp > startTimestamp);
106                 affiliateEnd[addr] = endTimestamp;
107             }
108 
109             emit AffiliateAdded(addr, startTimestamp, endTimestamp);
110         }
111         else {
112             // this address was previously registered
113 
114             if(startTimestamp == 0) {
115                 // don't update the start timestamp
116 
117                 if(endTimestamp == 0) {
118                     affiliateStart[addr] = 0;
119                     affiliateEnd[addr] = 0;
120                 }
121                 else {
122                     require(endTimestamp > existingStart);
123                 }
124             }
125             else {
126                 // update the start timestamp
127                 affiliateStart[addr] = startTimestamp;
128 
129                 if(endTimestamp != 0) {
130                     require(endTimestamp > startTimestamp);
131                 }
132             }
133             affiliateEnd[addr] = endTimestamp;
134 
135             emit AffiliateUpdated(addr, startTimestamp, endTimestamp);
136         }
137     }
138 
139     function get(address addr) public view returns (uint start, uint end) {
140         return (affiliateStart[addr], affiliateEnd[addr]);
141     }
142 
143     function inListAsOf(address addr, uint time) public view returns (bool) {
144         uint start;
145         uint end;
146         (start, end) = get(addr);
147         if(start == 0) {
148             return false;
149         }
150         if(time < start) {
151             return false;
152         }
153         if(end != 0 && time >= end) {
154             return false;
155         }
156         return true;
157     }
158 }
159 
160 contract InvestorList is Ownable, IInvestorList {
161     event AddressAdded(address addr, string role);
162     event AddressRemoved(address addr, string role);
163 
164     mapping (address => string) internal investorList;
165 
166     /**
167      * @dev Throws if called by any account that's not investorListed.
168      * @param role string
169      */
170     modifier validRole(string role) {
171         require(
172             keccak256(bytes(role)) == keccak256(bytes(ROLE_REGD)) ||
173             keccak256(bytes(role)) == keccak256(bytes(ROLE_REGCF)) ||
174             keccak256(bytes(role)) == keccak256(bytes(ROLE_REGS)) ||
175             keccak256(bytes(role)) == keccak256(bytes(ROLE_UNKNOWN))
176         );
177         _;
178     }
179 
180     /**
181      * @dev Getter to determine if address is in investorList.
182      * @param addr address
183      * @return true if the address was added to the investorList, false if the address was already in the investorList
184      */
185     function inList(address addr)
186         public
187         view
188         returns (bool)
189     {
190         if (bytes(investorList[addr]).length != 0) {
191             return true;
192         } else {
193             return false;
194         }
195     }
196 
197     /**
198      * @dev Getter for address role if address is in list.
199      * @param addr address
200      * @return string for address role
201      */
202     function getRole(address addr)
203         public
204         view
205         returns (string)
206     {
207         require(inList(addr));
208         return investorList[addr];
209     }
210 
211     /**
212      * @dev Returns a boolean indicating if the given address is in the list
213      *      with the given role.
214      * @param addr address to check
215      * @param role role to check
216      * @ return boolean for whether the address is in the list with the role
217      */
218     function hasRole(address addr, string role)
219         public
220         view
221         returns (bool)
222     {
223         return keccak256(bytes(role)) == keccak256(bytes(investorList[addr]));
224     }
225 
226     /**
227      * @dev Add single address to the investorList.
228      * @param addr address
229      * @param role string
230      */
231     function addAddress(address addr, string role)
232         onlyOwner
233         validRole(role)
234         public
235     {
236         investorList[addr] = role;
237         emit AddressAdded(addr, role);
238     }
239 
240     /**
241      * @dev Add multiple addresses to the investorList.
242      * @param addrs addresses
243      * @param role string
244      */
245     function addAddresses(address[] addrs, string role)
246         onlyOwner
247         validRole(role)
248         public
249     {
250         for (uint256 i = 0; i < addrs.length; i++) {
251             addAddress(addrs[i], role);
252         }
253     }
254 
255     /**
256      * @dev Remove single address from the investorList.
257      * @param addr address
258      */
259     function removeAddress(address addr)
260         onlyOwner
261         public
262     {
263         // removeRole(addr, ROLE_WHITELISTED);
264         require(inList(addr));
265         string memory role = investorList[addr];
266         investorList[addr] = "";
267         emit AddressRemoved(addr, role);
268     }
269 
270     /**
271      * @dev Remove multiple addresses from the investorList.
272      * @param addrs addresses
273      */
274     function removeAddresses(address[] addrs)
275         onlyOwner
276         public
277     {
278         for (uint256 i = 0; i < addrs.length; i++) {
279             if (inList(addrs[i])) {
280                 removeAddress(addrs[i]);
281             }
282         }
283     }
284 
285 }
286 
287 library SafeMath {
288 
289     /**
290     * @dev Multiplies two numbers, throws on overflow.
291     */
292     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
293         if (a == 0) {
294             return 0;
295         }
296         c = a * b;
297         assert(c / a == b);
298         return c;
299     }
300 
301     /**
302     * @dev Integer division of two numbers, truncating the quotient.
303     */
304     function div(uint256 a, uint256 b) internal pure returns (uint256) {
305         // assert(b > 0); // Solidity automatically throws when dividing by 0
306         // uint256 c = a / b;
307         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
308         return a / b;
309     }
310 
311     /**
312     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
313     */
314     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
315         assert(b <= a);
316         return a - b;
317     }
318 
319     /**
320     * @dev Adds two numbers, throws on overflow.
321     */
322     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
323         c = a + b;
324         assert(c >= a);
325         return c;
326     }
327 }
328 
329 contract ISecurityController {
330     function balanceOf(address _a) public view returns (uint);
331     function totalSupply() public view returns (uint);
332 
333     function isTransferAuthorized(address _from, address _to) public view returns (bool);
334     function setTransferAuthorized(address from, address to, uint expiry) public;
335 
336     function transfer(address _from, address _to, uint _value) public returns (bool success);
337     function transferFrom(address _spender, address _from, address _to, uint _value) public returns (bool success);
338     function allowance(address _owner, address _spender) public view returns (uint);
339     function approve(address _owner, address _spender, uint _value) public returns (bool success);
340     function increaseApproval(address _owner, address _spender, uint _addedValue) public returns (bool success);
341     function decreaseApproval(address _owner, address _spender, uint _subtractedValue) public returns (bool success);
342 
343     function burn(address _owner, uint _amount) public;
344     function ledgerTransfer(address from, address to, uint val) public;
345     function setLedger(address _ledger) public;
346     function setSale(address _sale) public;
347     function setToken(address _token) public;
348     function setAffiliateList(address _affiliateList) public;
349 }
350 
351 contract SecurityController is ISecurityController, Ownable {
352     ISecurityLedger public ledger;
353     ISecurityToken public token;
354     ISecuritySale public sale;
355     IInvestorList public investorList;
356     ITransferAuthorizations public transferAuthorizations;
357     IAffiliateList public affiliateList;
358 
359     uint public lockoutPeriod = 10 * 60 * 60; // length in seconds of the lockout period
360 
361     // restrict who can grant transfer authorizations
362     mapping(address => bool) public transferAuthPermission;
363 
364     constructor() public {
365     }
366 
367     function setTransferAuthorized(address from, address to, uint expiry) public {
368         // Must be called from address in the transferAuthPermission mapping
369         require(transferAuthPermission[msg.sender]);
370 
371         // don't allow 'from' to be zero
372         require(from != 0);
373 
374         // verify expiry is in future, but not more than 30 days
375         if(expiry > 0) {
376             require(expiry > block.timestamp);
377             require(expiry <= (block.timestamp + 30 days));
378         }
379 
380         transferAuthorizations.set(from, to, expiry);
381     }
382 
383     // functions below this line are onlyOwner
384 
385     function setLockoutPeriod(uint _lockoutPeriod) public onlyOwner {
386         lockoutPeriod = _lockoutPeriod;
387     }
388 
389     function setToken(address _token) public onlyOwner {
390         token = ISecurityToken(_token);
391     }
392 
393     function setLedger(address _ledger) public onlyOwner {
394         ledger = ISecurityLedger(_ledger);
395     }
396 
397     function setSale(address _sale) public onlyOwner {
398         sale = ISecuritySale(_sale);
399     }
400 
401     function setInvestorList(address _investorList) public onlyOwner {
402         investorList = IInvestorList(_investorList);
403     }
404 
405     function setTransferAuthorizations(address _transferAuthorizations) public onlyOwner {
406         transferAuthorizations = ITransferAuthorizations(_transferAuthorizations);
407     }
408 
409     function setAffiliateList(address _affiliateList) public onlyOwner {
410         affiliateList = IAffiliateList(_affiliateList);
411     }
412 
413     function setDependencies(address _token, address _ledger, address _sale,
414         address _investorList, address _transferAuthorizations, address _affiliateList)
415         public onlyOwner
416     {
417         token = ISecurityToken(_token);
418         ledger = ISecurityLedger(_ledger);
419         sale = ISecuritySale(_sale);
420         investorList = IInvestorList(_investorList);
421         transferAuthorizations = ITransferAuthorizations(_transferAuthorizations);
422         affiliateList = IAffiliateList(_affiliateList);
423     }
424 
425     function setTransferAuthPermission(address agent, bool hasPermission) public onlyOwner {
426         require(agent != address(0));
427         transferAuthPermission[agent] = hasPermission;
428     }
429 
430     modifier onlyToken() {
431         require(msg.sender == address(token));
432         _;
433     }
434 
435     modifier onlyLedger() {
436         require(msg.sender == address(ledger));
437         _;
438     }
439 
440     // public functions
441 
442     function totalSupply() public view returns (uint) {
443         return ledger.totalSupply();
444     }
445 
446     function balanceOf(address _a) public view returns (uint) {
447         return ledger.balanceOf(_a);
448     }
449 
450     function allowance(address _owner, address _spender) public view returns (uint) {
451         return ledger.allowance(_owner, _spender);
452     }
453 
454     function isTransferAuthorized(address _from, address _to) public view returns (bool) {
455         // A `from` address could have both an allowance for the `to` address
456         // and a global allowance (to the zero address). We pick the maximum
457         // of the two.
458 
459         uint expiry = transferAuthorizations.get(_from, _to);
460         uint globalExpiry = transferAuthorizations.get(_from, 0);
461         if(globalExpiry > expiry) {
462             expiry = globalExpiry;
463         }
464 
465         return expiry > block.timestamp;
466     }
467 
468     /**
469      * @dev Determines whether the given transfer is possible. Returns multiple
470      *      boolean flags specifying how the transfer must occur.
471      *      This is kept public to provide for testing and subclasses overriding behavior.
472      * @param _from Address the tokens are being transferred from
473      * @param _to Address the tokens are being transferred to
474      * @param _value Number of tokens that would be transferred
475      * @param lockoutTime A point in time, specified in epoch time, that specifies
476      *                    the lockout period (typically 1 year before now).
477      * @return canTransfer Whether the transfer can occur at all.
478      * @return useLockoutTime Whether the lockoutTime should be used to determine which tokens to transfer.
479      * @return newTokensAreRestricted Whether the transferred tokens should be marked as restricted.
480      * @return preservePurchaseDate Whether the purchase date on the tokens should be preserved, or reset to 'now'.
481      */
482     function checkTransfer(address _from, address _to, uint _value, uint lockoutTime)
483         public
484         returns (bool canTransfer, bool useLockoutTime, bool newTokensAreRestricted, bool preservePurchaseDate) {
485 
486         // DEFAULT BEHAVIOR:
487         //
488         // If there exists a Transfer Agent authorization, allow transfer regardless
489         //
490         // All transfers from an affiliate must be authorized by Transfer Agent
491         //   - tokens become restricted
492         //
493         // From Reg S to Reg S: allowable, regardless of holding period
494         //
495         // otherwise must meet holding period
496 
497         // presently this isn't used, so always setting to false to avoid warning
498         preservePurchaseDate = false;
499 
500         bool transferIsAuthorized = isTransferAuthorized(_from, _to);
501 
502         bool fromIsAffiliate = affiliateList.inListAsOf(_from, block.timestamp);
503         bool toIsAffiliate = affiliateList.inListAsOf(_to, block.timestamp);
504 
505         if(transferIsAuthorized) {
506             canTransfer = true;
507             if(fromIsAffiliate || toIsAffiliate) {
508                 newTokensAreRestricted = true;
509             }
510             // useLockoutTime will remain false
511             // preservePurchaseDate will remain false
512         }
513         else if(!fromIsAffiliate) {
514             // see if both are Reg S
515             if(investorList.hasRole(_from, investorList.ROLE_REGS())
516                 && investorList.hasRole(_to, investorList.ROLE_REGS())) {
517                 canTransfer = true;
518                 // newTokensAreRestricted will remain false
519                 // useLockoutTime will remain false
520                 // preservePurchaseDate will remain false
521             }
522             else {
523                 if(ledger.transferDryRun(_from, _to, _value, lockoutTime) == _value) {
524                     canTransfer = true;
525                     useLockoutTime = true;
526                     // newTokensAreRestricted will remain false
527                     // preservePurchaseDate will remain false
528                 }
529             }
530         }
531     }
532 
533     // functions below this line are onlyLedger
534 
535     // let the ledger send transfer events (the most obvious case
536     // is when we mint directly to the ledger and need the Transfer()
537     // events to appear in the token)
538     function ledgerTransfer(address from, address to, uint val) public onlyLedger {
539         token.controllerTransfer(from, to, val);
540     }
541 
542     // functions below this line are onlyToken
543 
544     function transfer(address _from, address _to, uint _value) public onlyToken returns (bool success) {
545         uint lockoutTime = block.timestamp - lockoutPeriod;
546         bool canTransfer;
547         bool useLockoutTime;
548         bool newTokensAreRestricted;
549         bool preservePurchaseDate;
550         (canTransfer, useLockoutTime, newTokensAreRestricted, preservePurchaseDate)
551             = checkTransfer(_from, _to, _value, lockoutTime);
552 
553         if(!canTransfer) {
554             return false;
555         }
556 
557         uint overrideLockoutTime = lockoutTime;
558         if(!useLockoutTime) {
559             overrideLockoutTime = 0;
560         }
561 
562         return ledger.transfer(_from, _to, _value, overrideLockoutTime, newTokensAreRestricted, preservePurchaseDate);
563     }
564 
565     function transferFrom(address _spender, address _from, address _to, uint _value) public onlyToken returns (bool success) {
566         uint lockoutTime = block.timestamp - lockoutPeriod;
567         bool canTransfer;
568         bool useLockoutTime;
569         bool newTokensAreRestricted;
570         bool preservePurchaseDate;
571         (canTransfer, useLockoutTime, newTokensAreRestricted, preservePurchaseDate)
572             = checkTransfer(_from, _to, _value, lockoutTime);
573 
574         if(!canTransfer) {
575             return false;
576         }
577 
578         uint overrideLockoutTime = lockoutTime;
579         if(!useLockoutTime) {
580             overrideLockoutTime = 0;
581         }
582 
583         return ledger.transferFrom(_spender, _from, _to, _value, overrideLockoutTime, newTokensAreRestricted, preservePurchaseDate);
584     }
585 
586     function approve(address _owner, address _spender, uint _value) public onlyToken returns (bool success) {
587         return ledger.approve(_owner, _spender, _value);
588     }
589 
590     function increaseApproval (address _owner, address _spender, uint _addedValue) public onlyToken returns (bool success) {
591         return ledger.increaseApproval(_owner, _spender, _addedValue);
592     }
593 
594     function decreaseApproval (address _owner, address _spender, uint _subtractedValue) public onlyToken returns (bool success) {
595         return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
596     }
597 
598     function burn(address _owner, uint _amount) public onlyToken {
599         ledger.burn(_owner, _amount);
600     }
601 }
602 
603 interface ISecurityLedger {
604     function balanceOf(address _a) external view returns (uint);
605     function totalSupply() external view returns (uint);
606 
607     function transferDryRun(address _from, address _to, uint amount, uint lockoutTime) external returns (uint transferrableCount);
608     function transfer(address _from, address _to, uint _value, uint lockoutTime, bool newTokensAreRestricted, bool preservePurchaseDate) external returns (bool success);
609     function transferFrom(address _spender, address _from, address _to, uint _value, uint lockoutTime, bool newTokensAreRestricted, bool preservePurchaseDate) external returns (bool success);
610     function allowance(address _owner, address _spender) external view returns (uint);
611     function approve(address _owner, address _spender, uint _value) external returns (bool success);
612     function increaseApproval(address _owner, address _spender, uint _addedValue) external returns (bool success);
613     function decreaseApproval(address _owner, address _spender, uint _subtractedValue) external returns (bool success);
614 
615     function burn(address _owner, uint _amount) external;
616     function setController(address _controller) external;
617 }
618 
619 contract SecurityLedger is Ownable {
620     using SafeMath for uint256;
621 
622     struct TokenLot {
623         uint amount;
624         uint purchaseDate;
625         bool restricted;
626     }
627     mapping(address => TokenLot[]) public tokenLotsOf;
628 
629     SecurityController public controller;
630     mapping(address => uint) public balanceOf;
631     mapping (address => mapping (address => uint)) public allowance;
632     uint public totalSupply;
633     uint public mintingNonce;
634     bool public mintingStopped;
635 
636 
637     constructor() public {
638     }
639 
640     // functions below this line are onlyOwner
641 
642     function setController(address _controller) public onlyOwner {
643         controller = SecurityController(_controller);
644     }
645 
646     function stopMinting() public onlyOwner {
647         mintingStopped = true;
648     }
649 
650     //TODO: not sure if this function should stay long term
651     function mint(address addr, uint value, uint timestamp) public onlyOwner {
652         require(!mintingStopped);
653 
654         uint time = timestamp;
655         if(time == 0) {
656             time = block.timestamp;
657         }
658 
659         balanceOf[addr] = balanceOf[addr].add(value);
660         tokenLotsOf[addr].push(TokenLot(value, time, true));
661         controller.ledgerTransfer(0, addr, value);
662         totalSupply = totalSupply.add(value);
663     }
664 
665     function multiMint(uint nonce, uint256[] bits, uint timestamp) external onlyOwner {
666         require(!mintingStopped);
667         if (nonce != mintingNonce) return;
668         mintingNonce = mintingNonce.add(1);
669         uint256 lomask = (1 << 96) - 1;
670         uint created = 0;
671 
672         uint time = timestamp;
673         if(time == 0) {
674             time = block.timestamp;
675         }
676 
677         for (uint i = 0; i < bits.length; i++) {
678             address addr = address(bits[i]>>96);
679             uint value = bits[i] & lomask;
680             balanceOf[addr] = balanceOf[addr].add(value);
681             tokenLotsOf[addr].push(TokenLot(value, time, true));
682             controller.ledgerTransfer(0, addr, value);
683             created = created.add(value);
684         }
685         totalSupply = totalSupply.add(created);
686     }
687 
688     // send received tokens to anyone
689     function sendReceivedTokens(address token, address sender, uint amount) public onlyOwner {
690         ERC20Basic t = ERC20Basic(token);
691         require(t.transfer(sender, amount));
692     }
693 
694     // functions below this line are onlyController
695 
696     modifier onlyController() {
697         require(msg.sender == address(controller));
698         _;
699     }
700 
701     /**
702      * @dev Walks through the list of TokenLots for the given address, attempting to find
703      *      `amount` tokens that can be transferred. It uses the given `lockoutTime` if
704      *      the supplied value is not zero. If `removeTokens` is true the tokens are
705      *      actually removed from the address, otherwise this function acts as a dry run.
706      *      The value returned is the actual number of transferrable tokens found, up to
707      *      the maximum value of `amount`.
708      */
709     function walkTokenLots(address from, address to, uint amount, uint lockoutTime, bool removeTokens,
710         bool newTokensAreRestricted, bool preservePurchaseDate)
711         internal returns (uint numTransferrableTokens)
712     {
713         TokenLot[] storage fromTokenLots = tokenLotsOf[from];
714         for(uint i=0; i<fromTokenLots.length; i++) {
715             TokenLot storage lot = fromTokenLots[i];
716             uint lotAmount = lot.amount;
717 
718             // skip if there are no available tokens
719             if(lotAmount == 0) {
720                 continue;
721             }
722 
723             if(lockoutTime > 0) {
724                 // skip if it is more recent than the lockout period AND it's restricted
725                 if(lot.restricted && lot.purchaseDate > lockoutTime) {
726                     continue;
727                 }
728             }
729 
730             uint remaining = amount.sub(numTransferrableTokens);
731 
732             if(lotAmount >= remaining) {
733                 numTransferrableTokens = numTransferrableTokens.add(remaining);
734                 if(removeTokens) {
735                     lot.amount = lotAmount.sub(remaining);
736                     if(to != address(0)) {
737                         if(preservePurchaseDate) {
738                             tokenLotsOf[to].push(TokenLot(remaining, lot.purchaseDate, newTokensAreRestricted));
739                         }
740                         else {
741                             tokenLotsOf[to].push(TokenLot(remaining, block.timestamp, newTokensAreRestricted));
742                         }
743                     }
744                 }
745                 break;
746             }
747 
748             // If we're here, then amount in this lot is not yet enough.
749             // Take all of it.
750             numTransferrableTokens = numTransferrableTokens.add(lotAmount);
751             if(removeTokens) {
752                 lot.amount = 0;
753                 if(to != address(0)) {
754                     if(preservePurchaseDate) {
755                         tokenLotsOf[to].push(TokenLot(lotAmount, lot.purchaseDate, newTokensAreRestricted));
756                     }
757                     else {
758                         tokenLotsOf[to].push(TokenLot(lotAmount, block.timestamp, newTokensAreRestricted));
759                     }
760                 }
761             }
762         }
763     }
764 
765     function transferDryRun(address from, address to, uint amount, uint lockoutTime) public onlyController returns (uint) {
766         return walkTokenLots(from, to, amount, lockoutTime, false, false, false);
767     }
768 
769     function transfer(address _from, address _to, uint _value, uint lockoutTime, bool newTokensAreRestricted, bool preservePurchaseDate) public onlyController returns (bool success) {
770         if (balanceOf[_from] < _value) return false;
771 
772         // ensure number of tokens removed from TokenLots is as expected
773         uint tokensTransferred = walkTokenLots(_from, _to, _value, lockoutTime, true, newTokensAreRestricted, preservePurchaseDate);
774         require(tokensTransferred == _value);
775 
776         // adjust balances
777         balanceOf[_from] = balanceOf[_from].sub(_value);
778         balanceOf[_to] = balanceOf[_to].add(_value);
779 
780         return true;
781     }
782 
783     function transferFrom(address _spender, address _from, address _to, uint _value, uint lockoutTime, bool newTokensAreRestricted, bool preservePurchaseDate) public onlyController returns (bool success) {
784         if (balanceOf[_from] < _value) return false;
785 
786         // ensure there is enough allowance
787         uint allowed = allowance[_from][_spender];
788         if (allowed < _value) return false;
789 
790         // ensure number of tokens removed from TokenLots is as expected
791         uint tokensTransferred = walkTokenLots(_from, _to, _value, lockoutTime, true, newTokensAreRestricted, preservePurchaseDate);
792         require(tokensTransferred == _value);
793 
794         // adjust balances
795         balanceOf[_from] = balanceOf[_from].sub(_value);
796         balanceOf[_to] = balanceOf[_to].add(_value);
797 
798         allowance[_from][_spender] = allowed.sub(_value);
799         return true;
800     }
801 
802     function approve(address _owner, address _spender, uint _value) public onlyController returns (bool success) {
803         // require user to set to zero before resetting to nonzero
804         if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
805             return false;
806         }
807 
808         allowance[_owner][_spender] = _value;
809         return true;
810     }
811 
812     function increaseApproval (address _owner, address _spender, uint _addedValue) public onlyController returns (bool success) {
813         uint oldValue = allowance[_owner][_spender];
814         allowance[_owner][_spender] = oldValue.add(_addedValue);
815         return true;
816     }
817 
818     function decreaseApproval (address _owner, address _spender, uint _subtractedValue) public onlyController returns (bool success) {
819         uint oldValue = allowance[_owner][_spender];
820         if (_subtractedValue > oldValue) {
821             allowance[_owner][_spender] = 0;
822         } else {
823             allowance[_owner][_spender] = oldValue.sub(_subtractedValue);
824         }
825         return true;
826     }
827 
828     function burn(address _owner, uint _amount) public onlyController {
829         require(balanceOf[_owner] >= _amount);
830 
831         balanceOf[_owner] = balanceOf[_owner].sub(_amount);
832 
833         // remove tokens from TokenLots
834         // (i.e. transfer them to 0)
835         walkTokenLots(_owner, address(0), _amount, 0, true, false, false);
836 
837         totalSupply = totalSupply.sub(_amount);
838     }
839 }
840 
841 interface ISecuritySale {
842     function setLive(bool newLiveness) external;
843     function setInvestorList(address _investorList) external;
844 }
845 
846 contract SecuritySale is Ownable {
847 
848     bool public live;        // sale is live right now
849     IInvestorList public investorList; // approved contributors
850 
851     event SaleLive(bool liveness);
852     event EtherIn(address from, uint amount);
853     event StartSale();
854     event EndSale();
855 
856     constructor() public {
857         live = false;
858     }
859 
860     function setInvestorList(address _investorList) public onlyOwner {
861         investorList = IInvestorList(_investorList);
862     }
863 
864     function () public payable {
865         require(live);
866         require(investorList.inList(msg.sender));
867         emit EtherIn(msg.sender, msg.value);
868     }
869 
870     // set liveness
871     function setLive(bool newLiveness) public onlyOwner {
872         if(live && !newLiveness) {
873             live = false;
874             emit EndSale();
875         }
876         else if(!live && newLiveness) {
877             live = true;
878             emit StartSale();
879         }
880     }
881 
882     // withdraw all of the Ether to owner
883     function withdraw() public onlyOwner {
884         msg.sender.transfer(address(this).balance);
885     }
886 
887     // withdraw some of the Ether to owner
888     function withdrawSome(uint value) public onlyOwner {
889         require(value <= address(this).balance);
890         msg.sender.transfer(value);
891     }
892 
893     // withdraw tokens to owner
894     function withdrawTokens(address token) public onlyOwner {
895         ERC20Basic t = ERC20Basic(token);
896         require(t.transfer(msg.sender, t.balanceOf(this)));
897     }
898 
899     // send received tokens to anyone
900     function sendReceivedTokens(address token, address sender, uint amount) public onlyOwner {
901         ERC20Basic t = ERC20Basic(token);
902         require(t.transfer(sender, amount));
903     }
904 }
905 
906 interface ISecurityToken {
907     function balanceOf(address addr) external view returns(uint);
908     function transfer(address to, uint amount) external returns(bool);
909     function controllerTransfer(address _from, address _to, uint _value) external;
910 }
911 
912 contract SecurityToken is Ownable{
913     using SafeMath for uint256;
914 
915     ISecurityController public controller;
916     // these public fields are set once in constructor
917     string public name;
918     string public symbol;
919     uint8 public decimals;
920 
921     event Transfer(address indexed from, address indexed to, uint value);
922     event Approval(address indexed owner, address indexed spender, uint value);
923 
924     constructor(string _name, string  _symbol, uint8 _decimals) public {
925         name = _name;
926         symbol = _symbol;
927         decimals = _decimals;
928     }
929 
930     // functions below this line are onlyOwner
931 
932     function setName(string _name) public onlyOwner {
933         name = _name;
934     }
935 
936     function setSymbol(string _symbol) public onlyOwner {
937         symbol = _symbol;
938     }
939     
940     function setController(address _c) public onlyOwner {
941         controller = ISecurityController(_c);
942     }
943 
944     // send received tokens to anyone
945     function sendReceivedTokens(address token, address sender, uint amount) public onlyOwner {
946         ERC20Basic t = ERC20Basic(token);
947         require(t.transfer(sender, amount));
948     }
949 
950     // functions below this line are public
951 
952     function balanceOf(address a) public view returns (uint) {
953         return controller.balanceOf(a);
954     }
955 
956     function totalSupply() public view returns (uint) {
957         return controller.totalSupply();
958     }
959 
960     function allowance(address _owner, address _spender) public view returns (uint) {
961         return controller.allowance(_owner, _spender);
962     }
963 
964     function burn(uint _amount) public {
965         controller.burn(msg.sender, _amount);
966         emit Transfer(msg.sender, 0x0, _amount);
967     }
968 
969     // functions below this line are onlyPayloadSize
970 
971     // TODO: investigate this security optimization more
972     modifier onlyPayloadSize(uint numwords) {
973         assert(msg.data.length >= numwords.mul(32).add(4));
974         _;
975     }
976 
977     function isTransferAuthorized(address _from, address _to) public onlyPayloadSize(2) view returns (bool) {
978         return controller.isTransferAuthorized(_from, _to);
979     }
980 
981     function transfer(address _to, uint _value) public onlyPayloadSize(2) returns (bool success) {
982         if (controller.transfer(msg.sender, _to, _value)) {
983             emit Transfer(msg.sender, _to, _value);
984             return true;
985         }
986         return false;
987     }
988 
989     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3) returns (bool success) {
990         if (controller.transferFrom(msg.sender, _from, _to, _value)) {
991             emit Transfer(_from, _to, _value);
992             return true;
993         }
994         return false;
995     }
996 
997     function approve(address _spender, uint _value) onlyPayloadSize(2) public returns (bool success) {
998         if (controller.approve(msg.sender, _spender, _value)) {
999             emit Approval(msg.sender, _spender, _value);
1000             return true;
1001         }
1002         return false;
1003     }
1004 
1005     function increaseApproval (address _spender, uint _addedValue) public onlyPayloadSize(2) returns (bool success) {
1006         if (controller.increaseApproval(msg.sender, _spender, _addedValue)) {
1007             uint newval = controller.allowance(msg.sender, _spender);
1008             emit Approval(msg.sender, _spender, newval);
1009             return true;
1010         }
1011         return false;
1012     }
1013 
1014     function decreaseApproval (address _spender, uint _subtractedValue) public onlyPayloadSize(2) returns (bool success) {
1015         if (controller.decreaseApproval(msg.sender, _spender, _subtractedValue)) {
1016             uint newval = controller.allowance(msg.sender, _spender);
1017             emit Approval(msg.sender, _spender, newval);
1018             return true;
1019         }
1020         return false;
1021     }
1022 
1023     // functions below this line are onlyController
1024 
1025     modifier onlyController() {
1026         assert(msg.sender == address(controller));
1027         _;
1028     }
1029 
1030     function controllerTransfer(address _from, address _to, uint _value) public onlyController {
1031         emit Transfer(_from, _to, _value);
1032     }
1033 
1034     function controllerApprove(address _owner, address _spender, uint _value) public onlyController {
1035         emit Approval(_owner, _spender, _value);
1036     }
1037 }
1038 
1039 interface ITransferAuthorizations {
1040     function setController(address _controller) external;
1041     function get(address from, address to) external view returns (uint);
1042     function set(address from, address to, uint expiry) external;
1043 }
1044 
1045 contract TransferAuthorizations is Ownable, ITransferAuthorizations {
1046 
1047     /**
1048      * @dev The first key is the `from` address. The second key is the `to` address.
1049      *      The uint value of the mapping is the epoch time (seconds since 1/1/1970)
1050      *      of the expiration of the approved transfer.
1051      */
1052     mapping(address => mapping(address => uint)) public authorizations;
1053 
1054     /**
1055      * @dev This controller is the only contract allowed to call the `set` function.
1056      */
1057     address public controller;
1058 
1059     event TransferAuthorizationSet(address from, address to, uint expiry);
1060 
1061     function setController(address _controller) public onlyOwner {
1062         controller = _controller;
1063     }
1064 
1065     modifier onlyController() {
1066         assert(msg.sender == controller);
1067         _;
1068     }
1069 
1070     /**
1071      * @dev Sets the authorization for a transfer to occur between the 'from' and
1072      *      'to' addresses, to expire at the 'expiry' time.
1073      * @param from The address from which funds would be transferred.
1074      * @param to The address to which funds would be transferred. This can be
1075      *           the zero address to allow transfers to any address.
1076      * @param expiry The epoch time (seconds since 1/1/1970) at which point this
1077      *               authorization will no longer be valid.
1078      */
1079     function set(address from, address to, uint expiry) public onlyController {
1080         require(from != 0);
1081         authorizations[from][to] = expiry;
1082         emit TransferAuthorizationSet(from, to, expiry);
1083     }
1084 
1085     /**
1086      * @dev Returns the expiration time for the transfer authorization between the
1087      *      given addresses. Returns 0 if not allowed.
1088      * @param from The address from which funds would be transferred.
1089      * @param to The address to which funds would be transferred. This can be
1090      *           the zero address to allow transfers to any address.
1091      */
1092     function get(address from, address to) public view returns (uint) {
1093         return authorizations[from][to];
1094     }
1095 }