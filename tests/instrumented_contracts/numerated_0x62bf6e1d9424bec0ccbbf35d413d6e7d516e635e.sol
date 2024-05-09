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
413     function setTransferAuthPermission(address agent, bool hasPermission) public onlyOwner {
414         require(agent != address(0));
415         transferAuthPermission[agent] = hasPermission;
416     }
417 
418     modifier onlyToken() {
419         require(msg.sender == address(token));
420         _;
421     }
422 
423     modifier onlyLedger() {
424         require(msg.sender == address(ledger));
425         _;
426     }
427 
428     // public functions
429 
430     function totalSupply() public view returns (uint) {
431         return ledger.totalSupply();
432     }
433 
434     function balanceOf(address _a) public view returns (uint) {
435         return ledger.balanceOf(_a);
436     }
437 
438     function allowance(address _owner, address _spender) public view returns (uint) {
439         return ledger.allowance(_owner, _spender);
440     }
441 
442     function isTransferAuthorized(address _from, address _to) public view returns (bool) {
443         // A `from` address could have both an allowance for the `to` address
444         // and a global allowance (to the zero address). We pick the maximum
445         // of the two.
446 
447         uint expiry = transferAuthorizations.get(_from, _to);
448         uint globalExpiry = transferAuthorizations.get(_from, 0);
449         if(globalExpiry > expiry) {
450             expiry = globalExpiry;
451         }
452 
453         return expiry > block.timestamp;
454     }
455 
456     /**
457      * @dev Determines whether the given transfer is possible. Returns multiple
458      *      boolean flags specifying how the transfer must occur.
459      *      This is kept public to provide for testing and subclasses overriding behavior.
460      * @param _from Address the tokens are being transferred from
461      * @param _to Address the tokens are being transferred to
462      * @param _value Number of tokens that would be transferred
463      * @param lockoutTime A point in time, specified in epoch time, that specifies
464      *                    the lockout period (typically 1 year before now).
465      * @return canTransfer Whether the transfer can occur at all.
466      * @return useLockoutTime Whether the lockoutTime should be used to determine which tokens to transfer.
467      * @return newTokensAreRestricted Whether the transferred tokens should be marked as restricted.
468      * @return preservePurchaseDate Whether the purchase date on the tokens should be preserved, or reset to 'now'.
469      */
470     function checkTransfer(address _from, address _to, uint _value, uint lockoutTime)
471         public
472         returns (bool canTransfer, bool useLockoutTime, bool newTokensAreRestricted, bool preservePurchaseDate) {
473 
474         // DEFAULT BEHAVIOR:
475         //
476         // If there exists a Transfer Agent authorization, allow transfer regardless
477         //
478         // All transfers from an affiliate must be authorized by Transfer Agent
479         //   - tokens become restricted
480         //
481         // From Reg S to Reg S: allowable, regardless of holding period
482         //
483         // otherwise must meet holding period
484 
485         // presently this isn't used, so always setting to false to avoid warning
486         preservePurchaseDate = false;
487 
488         bool transferIsAuthorized = isTransferAuthorized(_from, _to);
489 
490         bool fromIsAffiliate = affiliateList.inListAsOf(_from, block.timestamp);
491         bool toIsAffiliate = affiliateList.inListAsOf(_to, block.timestamp);
492 
493         if(transferIsAuthorized) {
494             canTransfer = true;
495             if(fromIsAffiliate || toIsAffiliate) {
496                 newTokensAreRestricted = true;
497             }
498             // useLockoutTime will remain false
499             // preservePurchaseDate will remain false
500         }
501         else if(!fromIsAffiliate) {
502             // see if both are Reg S
503             if(investorList.hasRole(_from, investorList.ROLE_REGS())
504                 && investorList.hasRole(_to, investorList.ROLE_REGS())) {
505                 canTransfer = true;
506                 // newTokensAreRestricted will remain false
507                 // useLockoutTime will remain false
508                 // preservePurchaseDate will remain false
509             }
510             else {
511                 if(ledger.transferDryRun(_from, _to, _value, lockoutTime) == _value) {
512                     canTransfer = true;
513                     useLockoutTime = true;
514                     // newTokensAreRestricted will remain false
515                     // preservePurchaseDate will remain false
516                 }
517             }
518         }
519     }
520 
521     // functions below this line are onlyLedger
522 
523     // let the ledger send transfer events (the most obvious case
524     // is when we mint directly to the ledger and need the Transfer()
525     // events to appear in the token)
526     function ledgerTransfer(address from, address to, uint val) public onlyLedger {
527         token.controllerTransfer(from, to, val);
528     }
529 
530     // functions below this line are onlyToken
531 
532     function transfer(address _from, address _to, uint _value) public onlyToken returns (bool success) {
533         //TODO: this could be configurable
534         uint lockoutTime = block.timestamp - lockoutPeriod;
535         bool canTransfer;
536         bool useLockoutTime;
537         bool newTokensAreRestricted;
538         bool preservePurchaseDate;
539         (canTransfer, useLockoutTime, newTokensAreRestricted, preservePurchaseDate)
540             = checkTransfer(_from, _to, _value, lockoutTime);
541 
542         if(!canTransfer) {
543             return false;
544         }
545 
546         uint overrideLockoutTime = lockoutTime;
547         if(!useLockoutTime) {
548             overrideLockoutTime = 0;
549         }
550 
551         return ledger.transfer(_from, _to, _value, overrideLockoutTime, newTokensAreRestricted, preservePurchaseDate);
552     }
553 
554     function transferFrom(address _spender, address _from, address _to, uint _value) public onlyToken returns (bool success) {
555         //TODO: this could be configurable
556         uint lockoutTime = block.timestamp - lockoutPeriod;
557         bool canTransfer;
558         bool useLockoutTime;
559         bool newTokensAreRestricted;
560         bool preservePurchaseDate;
561         (canTransfer, useLockoutTime, newTokensAreRestricted, preservePurchaseDate)
562             = checkTransfer(_from, _to, _value, lockoutTime);
563 
564         if(!canTransfer) {
565             return false;
566         }
567 
568         uint overrideLockoutTime = lockoutTime;
569         if(!useLockoutTime) {
570             overrideLockoutTime = 0;
571         }
572 
573         return ledger.transferFrom(_spender, _from, _to, _value, overrideLockoutTime, newTokensAreRestricted, preservePurchaseDate);
574     }
575 
576     function approve(address _owner, address _spender, uint _value) public onlyToken returns (bool success) {
577         return ledger.approve(_owner, _spender, _value);
578     }
579 
580     function increaseApproval (address _owner, address _spender, uint _addedValue) public onlyToken returns (bool success) {
581         return ledger.increaseApproval(_owner, _spender, _addedValue);
582     }
583 
584     function decreaseApproval (address _owner, address _spender, uint _subtractedValue) public onlyToken returns (bool success) {
585         return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
586     }
587 
588     function burn(address _owner, uint _amount) public onlyToken {
589         ledger.burn(_owner, _amount);
590     }
591 }
592 
593 interface ISecurityLedger {
594     function balanceOf(address _a) external view returns (uint);
595     function totalSupply() external view returns (uint);
596 
597     function transferDryRun(address _from, address _to, uint amount, uint lockoutTime) external returns (uint transferrableCount);
598     function transfer(address _from, address _to, uint _value, uint lockoutTime, bool newTokensAreRestricted, bool preservePurchaseDate) external returns (bool success);
599     function transferFrom(address _spender, address _from, address _to, uint _value, uint lockoutTime, bool newTokensAreRestricted, bool preservePurchaseDate) external returns (bool success);
600     function allowance(address _owner, address _spender) external view returns (uint);
601     function approve(address _owner, address _spender, uint _value) external returns (bool success);
602     function increaseApproval(address _owner, address _spender, uint _addedValue) external returns (bool success);
603     function decreaseApproval(address _owner, address _spender, uint _subtractedValue) external returns (bool success);
604 
605     function burn(address _owner, uint _amount) external;
606     function setController(address _controller) external;
607 }
608 
609 contract SecurityLedger is Ownable {
610     using SafeMath for uint256;
611 
612     struct TokenLot {
613         uint amount;
614         uint purchaseDate;
615         bool restricted;
616     }
617     mapping(address => TokenLot[]) public tokenLotsOf;
618 
619     SecurityController public controller;
620     mapping(address => uint) public balanceOf;
621     mapping (address => mapping (address => uint)) public allowance;
622     uint public totalSupply;
623     uint public mintingNonce;
624     bool public mintingStopped;
625 
626 
627     constructor() public {
628     }
629 
630     // functions below this line are onlyOwner
631 
632     function setController(address _controller) public onlyOwner {
633         controller = SecurityController(_controller);
634     }
635 
636     function stopMinting() public onlyOwner {
637         mintingStopped = true;
638     }
639 
640     //TODO: not sure if this function should stay long term
641     function mint(address addr, uint value, uint timestamp) public onlyOwner {
642         require(!mintingStopped);
643 
644         uint time = timestamp;
645         if(time == 0) {
646             time = block.timestamp;
647         }
648 
649         balanceOf[addr] = balanceOf[addr].add(value);
650         tokenLotsOf[addr].push(TokenLot(value, time, true));
651         controller.ledgerTransfer(0, addr, value);
652         totalSupply = totalSupply.add(value);
653     }
654 
655     function multiMint(uint nonce, uint256[] bits, uint timestamp) external onlyOwner {
656         require(!mintingStopped);
657         if (nonce != mintingNonce) return;
658         mintingNonce = mintingNonce.add(1);
659         uint256 lomask = (1 << 96) - 1;
660         uint created = 0;
661 
662         uint time = timestamp;
663         if(time == 0) {
664             time = block.timestamp;
665         }
666 
667         for (uint i = 0; i < bits.length; i++) {
668             address addr = address(bits[i]>>96);
669             uint value = bits[i] & lomask;
670             balanceOf[addr] = balanceOf[addr].add(value);
671             tokenLotsOf[addr].push(TokenLot(value, time, true));
672             controller.ledgerTransfer(0, addr, value);
673             created = created.add(value);
674         }
675         totalSupply = totalSupply.add(created);
676     }
677 
678     // send received tokens to anyone
679     function sendReceivedTokens(address token, address sender, uint amount) public onlyOwner {
680         ERC20Basic t = ERC20Basic(token);
681         require(t.transfer(sender, amount));
682     }
683 
684     // functions below this line are onlyController
685 
686     modifier onlyController() {
687         require(msg.sender == address(controller));
688         _;
689     }
690 
691     /**
692      * @dev Walks through the list of TokenLots for the given address, attempting to find
693      *      `amount` tokens that can be transferred. It uses the given `lockoutTime` if
694      *      the supplied value is not zero. If `removeTokens` is true the tokens are
695      *      actually removed from the address, otherwise this function acts as a dry run.
696      *      The value returned is the actual number of transferrable tokens found, up to
697      *      the maximum value of `amount`.
698      */
699     function walkTokenLots(address from, address to, uint amount, uint lockoutTime, bool removeTokens,
700         bool newTokensAreRestricted, bool preservePurchaseDate)
701         internal returns (uint numTransferrableTokens)
702     {
703         TokenLot[] storage fromTokenLots = tokenLotsOf[from];
704         for(uint i=0; i<fromTokenLots.length; i++) {
705             TokenLot storage lot = fromTokenLots[i];
706             uint lotAmount = lot.amount;
707 
708             // skip if there are no available tokens
709             if(lotAmount == 0) {
710                 continue;
711             }
712 
713             if(lockoutTime > 0) {
714                 // skip if it is more recent than the lockout period AND it's restricted
715                 if(lot.restricted && lot.purchaseDate > lockoutTime) {
716                     continue;
717                 }
718             }
719 
720             uint remaining = amount - numTransferrableTokens;
721 
722             if(lotAmount >= remaining) {
723                 numTransferrableTokens = numTransferrableTokens.add(remaining);
724                 if(removeTokens) {
725                     lot.amount = lotAmount.sub(remaining);
726                     if(to != address(0)) {
727                         if(preservePurchaseDate) {
728                             tokenLotsOf[to].push(TokenLot(remaining, lot.purchaseDate, newTokensAreRestricted));
729                         }
730                         else {
731                             tokenLotsOf[to].push(TokenLot(remaining, block.timestamp, newTokensAreRestricted));
732                         }
733                     }
734                 }
735                 break;
736             }
737 
738             // If we're here, then amount in this lot is not yet enough.
739             // Take all of it.
740             numTransferrableTokens = numTransferrableTokens.add(lotAmount);
741             if(removeTokens) {
742                 lot.amount = 0;
743                 if(to != address(0)) {
744                     if(preservePurchaseDate) {
745                         tokenLotsOf[to].push(TokenLot(lotAmount, lot.purchaseDate, newTokensAreRestricted));
746                     }
747                     else {
748                         tokenLotsOf[to].push(TokenLot(lotAmount, block.timestamp, newTokensAreRestricted));
749                     }
750                 }
751             }
752         }
753     }
754 
755     function transferDryRun(address from, address to, uint amount, uint lockoutTime) public onlyController returns (uint) {
756         return walkTokenLots(from, to, amount, lockoutTime, false, false, false);
757     }
758 
759     function transfer(address _from, address _to, uint _value, uint lockoutTime, bool newTokensAreRestricted, bool preservePurchaseDate) public onlyController returns (bool success) {
760         if (balanceOf[_from] < _value) return false;
761 
762         // ensure number of tokens removed from TokenLots is as expected
763         uint tokensTransferred = walkTokenLots(_from, _to, _value, lockoutTime, true, newTokensAreRestricted, preservePurchaseDate);
764         require(tokensTransferred == _value);
765 
766         // adjust balances
767         balanceOf[_from] = balanceOf[_from].sub(_value);
768         balanceOf[_to] = balanceOf[_to].add(_value);
769 
770         return true;
771     }
772 
773     function transferFrom(address _spender, address _from, address _to, uint _value, uint lockoutTime, bool newTokensAreRestricted, bool preservePurchaseDate) public onlyController returns (bool success) {
774         if (balanceOf[_from] < _value) return false;
775 
776         // ensure there is enough allowance
777         uint allowed = allowance[_from][_spender];
778         if (allowed < _value) return false;
779 
780         // ensure number of tokens removed from TokenLots is as expected
781         uint tokensTransferred = walkTokenLots(_from, _to, _value, lockoutTime, true, newTokensAreRestricted, preservePurchaseDate);
782         require(tokensTransferred == _value);
783 
784         // adjust balances
785         balanceOf[_from] = balanceOf[_from].sub(_value);
786         balanceOf[_to] = balanceOf[_to].add(_value);
787 
788         allowance[_from][_spender] = allowed.sub(_value);
789         return true;
790     }
791 
792     function approve(address _owner, address _spender, uint _value) public onlyController returns (bool success) {
793         // require user to set to zero before resetting to nonzero
794         if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
795             return false;
796         }
797 
798         allowance[_owner][_spender] = _value;
799         return true;
800     }
801 
802     function increaseApproval (address _owner, address _spender, uint _addedValue) public onlyController returns (bool success) {
803         uint oldValue = allowance[_owner][_spender];
804         allowance[_owner][_spender] = oldValue.add(_addedValue);
805         return true;
806     }
807 
808     function decreaseApproval (address _owner, address _spender, uint _subtractedValue) public onlyController returns (bool success) {
809         uint oldValue = allowance[_owner][_spender];
810         if (_subtractedValue > oldValue) {
811             allowance[_owner][_spender] = 0;
812         } else {
813             allowance[_owner][_spender] = oldValue.sub(_subtractedValue);
814         }
815         return true;
816     }
817 
818     function burn(address _owner, uint _amount) public onlyController {
819         require(balanceOf[_owner] >= _amount);
820 
821         balanceOf[_owner] = balanceOf[_owner].sub(_amount);
822 
823         // remove tokens from TokenLots
824         // (i.e. transfer them to 0)
825         walkTokenLots(_owner, address(0), _amount, 0, true, false, false);
826 
827         totalSupply = totalSupply.sub(_amount);
828     }
829 }
830 
831 interface ISecuritySale {
832     function setLive(bool newLiveness) external;
833     function setInvestorList(address _investorList) external;
834 }
835 
836 contract SecuritySale is Ownable {
837 
838     bool public live;        // sale is live right now
839     IInvestorList public investorList; // approved contributors
840 
841     event SaleLive(bool liveness);
842     event EtherIn(address from, uint amount);
843     event StartSale();
844     event EndSale();
845 
846     constructor() public {
847         live = false;
848     }
849 
850     function setInvestorList(address _investorList) public onlyOwner {
851         investorList = IInvestorList(_investorList);
852     }
853 
854     function () public payable {
855         require(live);
856         require(investorList.inList(msg.sender));
857         emit EtherIn(msg.sender, msg.value);
858     }
859 
860     // set liveness
861     function setLive(bool newLiveness) public onlyOwner {
862         if(live && !newLiveness) {
863             live = false;
864             emit EndSale();
865         }
866         else if(!live && newLiveness) {
867             live = true;
868             emit StartSale();
869         }
870     }
871 
872     // withdraw all of the Ether to owner
873     function withdraw() public onlyOwner {
874         msg.sender.transfer(address(this).balance);
875     }
876 
877     // withdraw some of the Ether to owner
878     function withdrawSome(uint value) public onlyOwner {
879         require(value <= address(this).balance);
880         msg.sender.transfer(value);
881     }
882 
883     // withdraw tokens to owner
884     function withdrawTokens(address token) public onlyOwner {
885         ERC20Basic t = ERC20Basic(token);
886         require(t.transfer(msg.sender, t.balanceOf(this)));
887     }
888 
889     // send received tokens to anyone
890     function sendReceivedTokens(address token, address sender, uint amount) public onlyOwner {
891         ERC20Basic t = ERC20Basic(token);
892         require(t.transfer(sender, amount));
893     }
894 }
895 
896 interface ISecurityToken {
897     function balanceOf(address addr) external view returns(uint);
898     function transfer(address to, uint amount) external returns(bool);
899     function controllerTransfer(address _from, address _to, uint _value) external;
900 }
901 
902 contract SecurityToken is Ownable{
903     using SafeMath for uint256;
904 
905     ISecurityController public controller;
906     // these public fields are set once in constructor
907     string public name;
908     string public symbol;
909     uint8 public decimals;
910 
911     event Transfer(address indexed from, address indexed to, uint value);
912     event Approval(address indexed owner, address indexed spender, uint value);
913 
914     constructor(string _name, string  _symbol, uint8 _decimals) public {
915         name = _name;
916         symbol = _symbol;
917         decimals = _decimals;
918     }
919 
920     // functions below this line are onlyOwner
921 
922     function setController(address _c) public onlyOwner {
923         controller = ISecurityController(_c);
924     }
925 
926     // send received tokens to anyone
927     function sendReceivedTokens(address token, address sender, uint amount) public onlyOwner {
928         ERC20Basic t = ERC20Basic(token);
929         require(t.transfer(sender, amount));
930     }
931 
932     // functions below this line are public
933 
934     function balanceOf(address a) public view returns (uint) {
935         return controller.balanceOf(a);
936     }
937 
938     function totalSupply() public view returns (uint) {
939         return controller.totalSupply();
940     }
941 
942     function allowance(address _owner, address _spender) public view returns (uint) {
943         return controller.allowance(_owner, _spender);
944     }
945 
946     function burn(uint _amount) public {
947         controller.burn(msg.sender, _amount);
948         emit Transfer(msg.sender, 0x0, _amount);
949     }
950 
951     // functions below this line are onlyPayloadSize
952 
953     // TODO: investigate this security optimization more
954     modifier onlyPayloadSize(uint numwords) {
955         assert(msg.data.length >= numwords.mul(32).add(4));
956         _;
957     }
958 
959     function isTransferAuthorized(address _from, address _to) public onlyPayloadSize(2) view returns (bool) {
960         return controller.isTransferAuthorized(_from, _to);
961     }
962 
963     function transfer(address _to, uint _value) public onlyPayloadSize(2) returns (bool success) {
964         if (controller.transfer(msg.sender, _to, _value)) {
965             emit Transfer(msg.sender, _to, _value);
966             return true;
967         }
968         return false;
969     }
970 
971     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3) returns (bool success) {
972         if (controller.transferFrom(msg.sender, _from, _to, _value)) {
973             emit Transfer(_from, _to, _value);
974             return true;
975         }
976         return false;
977     }
978 
979     function approve(address _spender, uint _value) onlyPayloadSize(2) public returns (bool success) {
980         if (controller.approve(msg.sender, _spender, _value)) {
981             emit Approval(msg.sender, _spender, _value);
982             return true;
983         }
984         return false;
985     }
986 
987     function increaseApproval (address _spender, uint _addedValue) public onlyPayloadSize(2) returns (bool success) {
988         if (controller.increaseApproval(msg.sender, _spender, _addedValue)) {
989             uint newval = controller.allowance(msg.sender, _spender);
990             emit Approval(msg.sender, _spender, newval);
991             return true;
992         }
993         return false;
994     }
995 
996     function decreaseApproval (address _spender, uint _subtractedValue) public onlyPayloadSize(2) returns (bool success) {
997         if (controller.decreaseApproval(msg.sender, _spender, _subtractedValue)) {
998             uint newval = controller.allowance(msg.sender, _spender);
999             emit Approval(msg.sender, _spender, newval);
1000             return true;
1001         }
1002         return false;
1003     }
1004 
1005     // functions below this line are onlyController
1006 
1007     modifier onlyController() {
1008         assert(msg.sender == address(controller));
1009         _;
1010     }
1011 
1012     function controllerTransfer(address _from, address _to, uint _value) public onlyController {
1013         emit Transfer(_from, _to, _value);
1014     }
1015 
1016     function controllerApprove(address _owner, address _spender, uint _value) public onlyController {
1017         emit Approval(_owner, _spender, _value);
1018     }
1019 }
1020 
1021 interface ITransferAuthorizations {
1022     function setController(address _controller) external;
1023     function get(address from, address to) external view returns (uint);
1024     function set(address from, address to, uint expiry) external;
1025 }
1026 
1027 contract TransferAuthorizations is Ownable, ITransferAuthorizations {
1028 
1029     /**
1030      * @dev The first key is the `from` address. The second key is the `to` address.
1031      *      The uint value of the mapping is the epoch time (seconds since 1/1/1970)
1032      *      of the expiration of the approved transfer.
1033      */
1034     mapping(address => mapping(address => uint)) public authorizations;
1035 
1036     /**
1037      * @dev This controller is the only contract allowed to call the `set` function.
1038      */
1039     address public controller;
1040 
1041     event TransferAuthorizationSet(address from, address to, uint expiry);
1042 
1043     function setController(address _controller) public onlyOwner {
1044         controller = _controller;
1045     }
1046 
1047     modifier onlyController() {
1048         assert(msg.sender == controller);
1049         _;
1050     }
1051 
1052     /**
1053      * @dev Sets the authorization for a transfer to occur between the 'from' and
1054      *      'to' addresses, to expire at the 'expiry' time.
1055      * @param from The address from which funds would be transferred.
1056      * @param to The address to which funds would be transferred. This can be
1057      *           the zero address to allow transfers to any address.
1058      * @param expiry The epoch time (seconds since 1/1/1970) at which point this
1059      *               authorization will no longer be valid.
1060      */
1061     function set(address from, address to, uint expiry) public onlyController {
1062         require(from != 0);
1063         authorizations[from][to] = expiry;
1064         emit TransferAuthorizationSet(from, to, expiry);
1065     }
1066 
1067     /**
1068      * @dev Returns the expiration time for the transfer authorization between the
1069      *      given addresses. Returns 0 if not allowed.
1070      * @param from The address from which funds would be transferred.
1071      * @param to The address to which funds would be transferred. This can be
1072      *           the zero address to allow transfers to any address.
1073      */
1074     function get(address from, address to) public view returns (uint) {
1075         return authorizations[from][to];
1076     }
1077 }