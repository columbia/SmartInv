1 pragma solidity ^0.4.24;
2 
3 interface itoken {
4     function freezeAccount(address _target, bool _freeze) external;
5     function freezeAccountPartialy(address _target, uint256 _value) external;
6     function balanceOf(address _owner) external view returns (uint256 balance);
7     // function totalSupply() external view returns (uint256);
8     // function transferOwnership(address newOwner) external;
9     function allowance(address _owner, address _spender) external view returns (uint256);
10     function initialCongress(address _congress) external;
11     function mint(address _to, uint256 _amount) external returns (bool);
12     function finishMinting() external returns (bool);
13     function pause() external;
14     function unpause() external;
15 }
16 
17 library StringUtils {
18   /// @dev Does a byte-by-byte lexicographical comparison of two strings.
19   /// @return a negative number if `_a` is smaller, zero if they are equal
20   /// and a positive numbe if `_b` is smaller.
21   function compare(string _a, string _b) public pure returns (int) {
22     bytes memory a = bytes(_a);
23     bytes memory b = bytes(_b);
24     uint minLength = a.length;
25     if (b.length < minLength) minLength = b.length;
26     //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
27     for (uint i = 0; i < minLength; i ++)
28       if (a[i] < b[i])
29         return -1;
30       else if (a[i] > b[i])
31         return 1;
32     if (a.length < b.length)
33       return -1;
34     else if (a.length > b.length)
35       return 1;
36     else
37       return 0;
38   }
39   /// @dev Compares two strings and returns true iff they are equal.
40   function equal(string _a, string _b) public pure returns (bool) {
41     return compare(_a, _b) == 0;
42   }
43   /// @dev Finds the index of the first occurrence of _needle in _haystack
44   function indexOf(string _haystack, string _needle) public pure returns (int) {
45         bytes memory h = bytes(_haystack);
46         bytes memory n = bytes(_needle);
47         if(h.length < 1 || n.length < 1 || (n.length > h.length))
48       return -1;
49     else if(h.length > (2**128 -1)) // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)
50       return -1;
51     else {
52       uint subindex = 0;
53       for (uint i = 0; i < h.length; i ++) {
54         if (h[i] == n[0]) { // found the first char of b
55           subindex = 1;
56           while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {// search until the chars don't match or until we reach the end of a or b
57                 subindex++;
58           }
59           if(subindex == n.length)
60                 return int(i);
61         }
62       }
63       return -1;
64     }
65   }
66 }
67 
68 library SafeMath {
69 
70   /**
71   * @dev Multiplies two numbers, throws on overflow.
72   */
73   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
74     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
75     // benefit is lost if 'b' is also tested.
76     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
77     if (a == 0) {
78       return 0;
79     }
80 
81     c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   /**
87   * @dev Integer division of two numbers, truncating the quotient.
88   */
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     // uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return a / b;
94   }
95 
96   /**
97   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
98   */
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   /**
105   * @dev Adds two numbers, throws on overflow.
106   */
107   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
108     c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 contract Ownable {
115   address public owner;
116 
117 
118   event OwnershipRenounced(address indexed previousOwner);
119   event OwnershipTransferred(
120     address indexed previousOwner,
121     address indexed newOwner
122   );
123 
124 
125   /**
126    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
127    * account.
128    */
129   constructor() public {
130     owner = msg.sender;
131   }
132 
133   /**
134    * @dev Throws if called by any account other than the owner.
135    */
136   modifier onlyOwner() {
137     require(msg.sender == owner);
138     _;
139   }
140 
141   /**
142    * @dev Allows the current owner to relinquish control of the contract.
143    */
144   function renounceOwnership() public onlyOwner {
145     emit OwnershipRenounced(owner);
146     owner = address(0);
147   }
148 
149   /**
150    * @dev Allows the current owner to transfer control of the contract to a newOwner.
151    * @param _newOwner The address to transfer ownership to.
152    */
153   function transferOwnership(address _newOwner) public onlyOwner {
154     _transferOwnership(_newOwner);
155   }
156 
157   /**
158    * @dev Transfers control of the contract to a newOwner.
159    * @param _newOwner The address to transfer ownership to.
160    */
161   function _transferOwnership(address _newOwner) internal {
162     require(_newOwner != address(0));
163     emit OwnershipTransferred(owner, _newOwner);
164     owner = _newOwner;
165   }
166 }
167 
168 contract Claimable is Ownable {
169   address public pendingOwner;
170 
171   /**
172    * @dev Modifier throws if called by any account other than the pendingOwner.
173    */
174   modifier onlyPendingOwner() {
175     require(msg.sender == pendingOwner);
176     _;
177   }
178 
179   /**
180    * @dev Allows the current owner to set the pendingOwner address.
181    * @param newOwner The address to transfer ownership to.
182    */
183   function transferOwnership(address newOwner) onlyOwner public {
184     pendingOwner = newOwner;
185   }
186 
187   /**
188    * @dev Allows the pendingOwner address to finalize the transfer.
189    */
190   function claimOwnership() onlyPendingOwner public {
191     emit OwnershipTransferred(owner, pendingOwner);
192     owner = pendingOwner;
193     pendingOwner = address(0);
194   }
195 }
196 
197 contract DelayedClaimable is Claimable {
198 
199   uint256 public end;
200   uint256 public start;
201 
202   /**
203    * @dev Used to specify the time period during which a pending
204    * owner can claim ownership.
205    * @param _start The earliest time ownership can be claimed.
206    * @param _end The latest time ownership can be claimed.
207    */
208   function setLimits(uint256 _start, uint256 _end) onlyOwner public {
209     require(_start <= _end);
210     end = _end;
211     start = _start;
212   }
213 
214   /**
215    * @dev Allows the pendingOwner address to finalize the transfer, as long as it is called within
216    * the specified start and end time.
217    */
218   function claimOwnership() onlyPendingOwner public {
219     require((block.number <= end) && (block.number >= start));
220     emit OwnershipTransferred(owner, pendingOwner);
221     owner = pendingOwner;
222     pendingOwner = address(0);
223     end = 0;
224   }
225 
226 }
227 
228 contract RBAC {
229   using Roles for Roles.Role;
230 
231   mapping (string => Roles.Role) private roles;
232 
233   event RoleAdded(address addr, string roleName);
234   event RoleRemoved(address addr, string roleName);
235 
236   /**
237    * @dev reverts if addr does not have role
238    * @param addr address
239    * @param roleName the name of the role
240    * // reverts
241    */
242   function checkRole(address addr, string roleName)
243     view
244     public
245   {
246     roles[roleName].check(addr);
247   }
248 
249   /**
250    * @dev determine if addr has role
251    * @param addr address
252    * @param roleName the name of the role
253    * @return bool
254    */
255   function hasRole(address addr, string roleName)
256     view
257     public
258     returns (bool)
259   {
260     return roles[roleName].has(addr);
261   }
262 
263   /**
264    * @dev add a role to an address
265    * @param addr address
266    * @param roleName the name of the role
267    */
268   function addRole(address addr, string roleName)
269     internal
270   {
271     roles[roleName].add(addr);
272     emit RoleAdded(addr, roleName);
273   }
274 
275   /**
276    * @dev remove a role from an address
277    * @param addr address
278    * @param roleName the name of the role
279    */
280   function removeRole(address addr, string roleName)
281     internal
282   {
283     roles[roleName].remove(addr);
284     emit RoleRemoved(addr, roleName);
285   }
286 
287   /**
288    * @dev modifier to scope access to a single role (uses msg.sender as addr)
289    * @param roleName the name of the role
290    * // reverts
291    */
292   modifier onlyRole(string roleName)
293   {
294     checkRole(msg.sender, roleName);
295     _;
296   }
297 
298   /**
299    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
300    * @param roleNames the names of the roles to scope access to
301    * // reverts
302    *
303    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
304    *  see: https://github.com/ethereum/solidity/issues/2467
305    */
306   // modifier onlyRoles(string[] roleNames) {
307   //     bool hasAnyRole = false;
308   //     for (uint8 i = 0; i < roleNames.length; i++) {
309   //         if (hasRole(msg.sender, roleNames[i])) {
310   //             hasAnyRole = true;
311   //             break;
312   //         }
313   //     }
314 
315   //     require(hasAnyRole);
316 
317   //     _;
318   // }
319 }
320 
321 contract MultiOwners is DelayedClaimable, RBAC {
322   using SafeMath for uint256;
323   using StringUtils for string;
324 
325   mapping (string => uint256) private authorizations;
326   mapping (address => string) private ownerOfSides;
327 //   mapping (string => mapping (string => bool)) private voteResults;
328   mapping (string => uint256) private sideExist;
329   mapping (string => mapping (string => address[])) private sideVoters;
330   address[] public owners;
331   string[] private authTypes;
332 //   string[] private ownerSides;
333   uint256 public multiOwnerSides;
334   uint256 ownerSidesLimit = 5;
335 //   uint256 authRate = 75;
336   bool initAdd = true;
337 
338   event OwnerAdded(address addr, string side);
339   event OwnerRemoved(address addr);
340   event InitialFinished();
341 
342   string public constant ROLE_MULTIOWNER = "multiOwner";
343   string public constant AUTH_ADDOWNER = "addOwner";
344   string public constant AUTH_REMOVEOWNER = "removeOwner";
345 //   string public constant AUTH_SETAUTHRATE = "setAuthRate";
346 
347   /**
348    * @dev Throws if called by any account that's not multiOwners.
349    */
350   modifier onlyMultiOwners() {
351     checkRole(msg.sender, ROLE_MULTIOWNER);
352     _;
353   }
354 
355   /**
356    * @dev Throws if not in initializing stage.
357    */
358   modifier canInitial() {
359     require(initAdd);
360     _;
361   }
362 
363   /**
364    * @dev the msg.sender will authorize a type of event.
365    * @param _authType the event type need to be authorized
366    */
367   function authorize(string _authType) onlyMultiOwners public {
368     string memory side = ownerOfSides[msg.sender];
369     address[] storage voters = sideVoters[side][_authType];
370 
371     if (voters.length == 0) {
372       // if the first time to authorize this type of event
373       authorizations[_authType] = authorizations[_authType].add(1);
374     //   voteResults[side][_authType] = true;
375     }
376 
377     // add voters of one side
378     uint j = 0;
379     for (; j < voters.length; j = j.add(1)) {
380       if (voters[j] == msg.sender) {
381         break;
382       }
383     }
384 
385     if (j >= voters.length) {
386       voters.push(msg.sender);
387     }
388 
389     // add the authType for clearing auth
390     uint i = 0;
391     for (; i < authTypes.length; i = i.add(1)) {
392       if (authTypes[i].equal(_authType)) {
393         break;
394       }
395     }
396 
397     if (i >= authTypes.length) {
398       authTypes.push(_authType);
399     }
400   }
401 
402   /**
403    * @dev the msg.sender will clear the authorization he has given for the event.
404    * @param _authType the event type need to be authorized
405    */
406   function deAuthorize(string _authType) onlyMultiOwners public {
407     string memory side = ownerOfSides[msg.sender];
408     address[] storage voters = sideVoters[side][_authType];
409 
410     for (uint j = 0; j < voters.length; j = j.add(1)) {
411       if (voters[j] == msg.sender) {
412         delete voters[j];
413         break;
414       }
415     }
416 
417     // if the sender has authorized this type of event, will remove its vote
418     if (j < voters.length) {
419       for (uint jj = j; jj < voters.length.sub(1); jj = jj.add(1)) {
420         voters[jj] = voters[jj.add(1)];
421       }
422 
423       delete voters[voters.length.sub(1)];
424       voters.length = voters.length.sub(1);
425 
426       // if there is no votes of one side, the authorization need to be decreased
427       if (voters.length == 0) {
428         authorizations[_authType] = authorizations[_authType].sub(1);
429       //   voteResults[side][_authType] = true;
430       }
431 
432       // if there is no authorization on this type of event,
433       // this event need to be removed from the list
434       if (authorizations[_authType] == 0) {
435         for (uint i = 0; i < authTypes.length; i = i.add(1)) {
436           if (authTypes[i].equal(_authType)) {
437             delete authTypes[i];
438             break;
439           }
440         }
441         for (uint ii = i; ii < authTypes.length.sub(1); ii = ii.add(1)) {
442           authTypes[ii] = authTypes[ii.add(1)];
443         }
444 
445         delete authTypes[authTypes.length.sub(1)];
446         authTypes.length = authTypes.length.sub(1);
447       }
448     }
449   }
450 
451   /**
452    * @dev judge if the event has already been authorized.
453    * @param _authType the event type need to be authorized
454    */
455   function hasAuth(string _authType) public view returns (bool) {
456     require(multiOwnerSides > 1); // at least 2 sides have authorized
457 
458     // uint256 rate = authorizations[_authType].mul(100).div(multiOwnerNumber)
459     return (authorizations[_authType] == multiOwnerSides);
460   }
461 
462   /**
463    * @dev clear all the authorizations that have been given for a type of event.
464    * @param _authType the event type need to be authorized
465    */
466   function clearAuth(string _authType) internal {
467     authorizations[_authType] = 0; // clear authorizations
468     for (uint i = 0; i < owners.length; i = i.add(1)) {
469       string memory side = ownerOfSides[owners[i]];
470       address[] storage voters = sideVoters[side][_authType];
471       for (uint j = 0; j < voters.length; j = j.add(1)) {
472         delete voters[j]; // clear votes of one side
473       }
474       voters.length = 0;
475     }
476 
477     // clear this type of event
478     for (uint k = 0; k < authTypes.length; k = k.add(1)) {
479       if (authTypes[k].equal(_authType)) {
480         delete authTypes[k];
481         break;
482       }
483     }
484     for (uint kk = k; kk < authTypes.length.sub(1); kk = kk.add(1)) {
485       authTypes[kk] = authTypes[kk.add(1)];
486     }
487 
488     delete authTypes[authTypes.length.sub(1)];
489     authTypes.length = authTypes.length.sub(1);
490   }
491 
492   /**
493    * @dev add an address as one of the multiOwners.
494    * @param _addr the account address used as a multiOwner
495    */
496   function addAddress(address _addr, string _side) internal {
497     require(multiOwnerSides < ownerSidesLimit);
498     require(_addr != address(0));
499     require(ownerOfSides[_addr].equal("")); // not allow duplicated adding
500 
501     // uint i = 0;
502     // for (; i < owners.length; i = i.add(1)) {
503     //   if (owners[i] == _addr) {
504     //     break;
505     //   }
506     // }
507 
508     // if (i >= owners.length) {
509     owners.push(_addr); // for not allowing duplicated adding, so each addr should be new
510 
511     addRole(_addr, ROLE_MULTIOWNER);
512     ownerOfSides[_addr] = _side;
513     // }
514 
515     if (sideExist[_side] == 0) {
516       multiOwnerSides = multiOwnerSides.add(1);
517     }
518 
519     sideExist[_side] = sideExist[_side].add(1);
520   }
521 
522   /**
523    * @dev add an address to the whitelist
524    * @param _addr address will be one of the multiOwner
525    * @param _side the side name of the multiOwner
526    * @return true if the address was added to the multiOwners list,
527    *         false if the address was already in the multiOwners list
528    */
529   function initAddressAsMultiOwner(address _addr, string _side)
530     onlyOwner
531     canInitial
532     public
533   {
534     // require(initAdd);
535     addAddress(_addr, _side);
536 
537     // initAdd = false;
538     emit OwnerAdded(_addr, _side);
539   }
540 
541   /**
542    * @dev Function to stop initial stage.
543    */
544   function finishInitOwners() onlyOwner canInitial public {
545     initAdd = false;
546     emit InitialFinished();
547   }
548 
549   /**
550    * @dev add an address to the whitelist
551    * @param _addr address
552    * @param _side the side name of the multiOwner
553    * @return true if the address was added to the multiOwners list,
554    *         false if the address was already in the multiOwners list
555    */
556   function addAddressAsMultiOwner(address _addr, string _side)
557     onlyMultiOwners
558     public
559   {
560     require(hasAuth(AUTH_ADDOWNER));
561 
562     addAddress(_addr, _side);
563 
564     clearAuth(AUTH_ADDOWNER);
565     emit OwnerAdded(_addr, _side);
566   }
567 
568   /**
569    * @dev getter to determine if address is in multiOwner list
570    */
571   function isMultiOwner(address _addr)
572     public
573     view
574     returns (bool)
575   {
576     return hasRole(_addr, ROLE_MULTIOWNER);
577   }
578 
579   /**
580    * @dev remove an address from the whitelist
581    * @param _addr address
582    * @return true if the address was removed from the multiOwner list,
583    *         false if the address wasn't in the multiOwner list
584    */
585   function removeAddressFromOwners(address _addr)
586     onlyMultiOwners
587     public
588   {
589     require(hasAuth(AUTH_REMOVEOWNER));
590 
591     removeRole(_addr, ROLE_MULTIOWNER);
592 
593     // first remove the owner
594     uint j = 0;
595     for (; j < owners.length; j = j.add(1)) {
596       if (owners[j] == _addr) {
597         delete owners[j];
598         break;
599       }
600     }
601     if (j < owners.length) {
602       for (uint jj = j; jj < owners.length.sub(1); jj = jj.add(1)) {
603         owners[jj] = owners[jj.add(1)];
604       }
605 
606       delete owners[owners.length.sub(1)];
607       owners.length = owners.length.sub(1);
608     }
609 
610     string memory side = ownerOfSides[_addr];
611     // if (sideExist[side] > 0) {
612     sideExist[side] = sideExist[side].sub(1);
613     if (sideExist[side] == 0) {
614       require(multiOwnerSides > 2); // not allow only left 1 side
615       multiOwnerSides = multiOwnerSides.sub(1); // this side has been removed
616     }
617 
618     // for every event type, if this owner has voted the event, then need to remove
619     for (uint i = 0; i < authTypes.length; ) {
620       address[] storage voters = sideVoters[side][authTypes[i]];
621       for (uint m = 0; m < voters.length; m = m.add(1)) {
622         if (voters[m] == _addr) {
623           delete voters[m];
624           break;
625         }
626       }
627       if (m < voters.length) {
628         for (uint n = m; n < voters.length.sub(1); n = n.add(1)) {
629           voters[n] = voters[n.add(1)];
630         }
631 
632         delete voters[voters.length.sub(1)];
633         voters.length = voters.length.sub(1);
634 
635         // if this side only have this 1 voter, the authorization of this event need to be decreased
636         if (voters.length == 0) {
637           authorizations[authTypes[i]] = authorizations[authTypes[i]].sub(1);
638         }
639 
640         // if there is no authorization of this event, the event need to be removed
641         if (authorizations[authTypes[i]] == 0) {
642           delete authTypes[i];
643 
644           for (uint kk = i; kk < authTypes.length.sub(1); kk = kk.add(1)) {
645             authTypes[kk] = authTypes[kk.add(1)];
646           }
647 
648           delete authTypes[authTypes.length.sub(1)];
649           authTypes.length = authTypes.length.sub(1);
650         } else {
651           i = i.add(1);
652         }
653       } else {
654         i = i.add(1);
655       }
656     }
657 //   }
658 
659     delete ownerOfSides[_addr];
660 
661     clearAuth(AUTH_REMOVEOWNER);
662     emit OwnerRemoved(_addr);
663   }
664 
665 }
666 
667 contract MultiOwnerContract is MultiOwners {
668     Claimable public ownedContract;
669     address public pendingOwnedOwner;
670     // address internal origOwner;
671 
672     string public constant AUTH_CHANGEOWNEDOWNER = "transferOwnerOfOwnedContract";
673 
674     /**
675      * @dev Modifier throws if called by any account other than the pendingOwner.
676      */
677     // modifier onlyPendingOwnedOwner() {
678     //     require(msg.sender == pendingOwnedOwner);
679     //     _;
680     // }
681 
682     /**
683      * @dev bind a contract as its owner
684      *
685      * @param _contract the contract address that will be binded by this Owner Contract
686      */
687     function bindContract(address _contract) onlyOwner public returns (bool) {
688         require(_contract != address(0));
689         ownedContract = Claimable(_contract);
690         // origOwner = ownedContract.owner();
691 
692         // take ownership of the owned contract
693         ownedContract.claimOwnership();
694 
695         return true;
696     }
697 
698     /**
699      * @dev change the owner of the contract from this contract address to the original one.
700      *
701      */
702     // function transferOwnershipBack() onlyOwner public {
703     //     ownedContract.transferOwnership(origOwner);
704     //     ownedContract = Claimable(address(0));
705     //     origOwner = address(0);
706     // }
707 
708     /**
709      * @dev change the owner of the contract from this contract address to another one.
710      *
711      * @param _nextOwner the contract address that will be next Owner of the original Contract
712      */
713     function changeOwnedOwnershipto(address _nextOwner) onlyMultiOwners public {
714         require(ownedContract != address(0));
715         require(hasAuth(AUTH_CHANGEOWNEDOWNER));
716 
717         if (ownedContract.owner() != pendingOwnedOwner) {
718             ownedContract.transferOwnership(_nextOwner);
719             pendingOwnedOwner = _nextOwner;
720             // ownedContract = Claimable(address(0));
721             // origOwner = address(0);
722         } else {
723             // the pending owner has already taken the ownership
724             ownedContract = Claimable(address(0));
725             pendingOwnedOwner = address(0);
726         }
727 
728         clearAuth(AUTH_CHANGEOWNEDOWNER);
729     }
730 
731     function ownedOwnershipTransferred() onlyOwner public returns (bool) {
732         require(ownedContract != address(0));
733         if (ownedContract.owner() == pendingOwnedOwner) {
734             // the pending owner has already taken the ownership
735             ownedContract = Claimable(address(0));
736             pendingOwnedOwner = address(0);
737             return true;
738         } else {
739             return false;
740         }
741     }
742 
743 }
744 
745 contract DRCTOwner is MultiOwnerContract {
746     string public constant AUTH_INITCONGRESS = "initCongress";
747     string public constant AUTH_CANMINT = "canMint";
748     string public constant AUTH_SETMINTAMOUNT = "setMintAmount";
749     string public constant AUTH_FREEZEACCOUNT = "freezeAccount";
750 
751     bool congressInit = false;
752     // bool paramsInit = false;
753     // iParams public params;
754     uint256 onceMintAmount;
755 
756 
757     // function initParams(address _params) onlyOwner public {
758     //     require(!paramsInit);
759     //     require(_params != address(0));
760 
761     //     params = _params;
762     //     paramsInit = false;
763     // }
764 
765     /**
766      * @dev Function to set mint token amount
767      * @param _value The mint value.
768      */
769     function setOnceMintAmount(uint256 _value) onlyMultiOwners public {
770         require(hasAuth(AUTH_SETMINTAMOUNT));
771         require(_value > 0);
772         onceMintAmount = _value;
773 
774         clearAuth(AUTH_SETMINTAMOUNT);
775     }
776 
777     /**
778      * @dev change the owner of the contract from this contract address to another one.
779      *
780      * @param _congress the contract address that will be next Owner of the original Contract
781      */
782     function initCongress(address _congress) onlyMultiOwners public {
783         require(hasAuth(AUTH_INITCONGRESS));
784         require(!congressInit);
785 
786         itoken tk = itoken(address(ownedContract));
787         tk.initialCongress(_congress);
788 
789         clearAuth(AUTH_INITCONGRESS);
790         congressInit = true;
791     }
792 
793     /**
794      * @dev Function to mint tokens
795      * @param _to The address that will receive the minted tokens.
796      * @return A boolean that indicates if the operation was successful.
797      */
798     function mint(address _to) onlyMultiOwners public returns (bool) {
799         require(hasAuth(AUTH_CANMINT));
800 
801         itoken tk = itoken(address(ownedContract));
802         bool res = tk.mint(_to, onceMintAmount);
803 
804         clearAuth(AUTH_CANMINT);
805         return res;
806     }
807 
808     /**
809      * @dev Function to stop minting new tokens.
810      * @return True if the operation was successful.
811      */
812     function finishMinting() onlyMultiOwners public returns (bool) {
813         require(hasAuth(AUTH_CANMINT));
814 
815         itoken tk = itoken(address(ownedContract));
816         bool res = tk.finishMinting();
817 
818         clearAuth(AUTH_CANMINT);
819         return res;
820     }
821 
822     /**
823      * @dev freeze the account's balance under urgent situation
824      *
825      * by default all the accounts will not be frozen until set freeze value as true.
826      *
827      * @param _target address the account should be frozen
828      * @param _freeze bool if true, the account will be frozen
829      */
830     function freezeAccountDirect(address _target, bool _freeze) onlyMultiOwners public {
831         require(hasAuth(AUTH_FREEZEACCOUNT));
832 
833         require(_target != address(0));
834         itoken tk = itoken(address(ownedContract));
835         tk.freezeAccount(_target, _freeze);
836 
837         clearAuth(AUTH_FREEZEACCOUNT);
838     }
839 
840     /**
841      * @dev freeze the account's balance
842      *
843      * by default all the accounts will not be frozen until set freeze value as true.
844      *
845      * @param _target address the account should be frozen
846      * @param _freeze bool if true, the account will be frozen
847      */
848     function freezeAccount(address _target, bool _freeze) onlyOwner public {
849         require(_target != address(0));
850         itoken tk = itoken(address(ownedContract));
851         if (_freeze) {
852             require(tk.allowance(_target, this) == tk.balanceOf(_target));
853         }
854 
855         tk.freezeAccount(_target, _freeze);
856     }
857 
858     /**
859      * @dev freeze the account's balance
860      *
861      * @param _target address the account should be frozen
862      * @param _value uint256 the amount of tokens that will be frozen
863      */
864     function freezeAccountPartialy(address _target, uint256 _value) onlyOwner public {
865         require(_target != address(0));
866         itoken tk = itoken(address(ownedContract));
867         require(tk.allowance(_target, this) == _value);
868 
869         tk.freezeAccountPartialy(_target, _value);
870     }
871 
872     /**
873      * @dev called by the owner to pause, triggers stopped state
874      */
875     function pause() onlyOwner public {
876         itoken tk = itoken(address(ownedContract));
877         tk.pause();
878     }
879 
880     /**
881      * @dev called by the owner to unpause, returns to normal state
882      */
883     function unpause() onlyOwner public {
884         itoken tk = itoken(address(ownedContract));
885         tk.unpause();
886     }
887 
888 }
889 
890 library Roles {
891   struct Role {
892     mapping (address => bool) bearer;
893   }
894 
895   /**
896    * @dev give an address access to this role
897    */
898   function add(Role storage role, address addr)
899     internal
900   {
901     role.bearer[addr] = true;
902   }
903 
904   /**
905    * @dev remove an address' access to this role
906    */
907   function remove(Role storage role, address addr)
908     internal
909   {
910     role.bearer[addr] = false;
911   }
912 
913   /**
914    * @dev check if an address has this role
915    * // reverts
916    */
917   function check(Role storage role, address addr)
918     view
919     internal
920   {
921     require(has(role, addr));
922   }
923 
924   /**
925    * @dev check if an address has this role
926    * @return bool
927    */
928   function has(Role storage role, address addr)
929     view
930     internal
931     returns (bool)
932   {
933     return role.bearer[addr];
934   }
935 }