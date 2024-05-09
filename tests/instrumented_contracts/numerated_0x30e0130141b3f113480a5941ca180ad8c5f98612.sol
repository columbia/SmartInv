1 // File: @0xcert/ethereum-utils/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @dev Math operations with safety checks that throw on error. This contract is based
7  * on the source code at https://goo.gl/iyQsmU.
8  */
9 library SafeMath {
10 
11   /**
12    * @dev Multiplies two numbers, throws on overflow.
13    * @param _a Factor number.
14    * @param _b Factor number.
15    */
16   function mul(
17     uint256 _a,
18     uint256 _b
19   )
20     internal
21     pure
22     returns (uint256)
23   {
24     if (_a == 0) {
25       return 0;
26     }
27     uint256 c = _a * _b;
28     assert(c / _a == _b);
29     return c;
30   }
31 
32   /**
33    * @dev Integer division of two numbers, truncating the quotient.
34    * @param _a Dividend number.
35    * @param _b Divisor number.
36    */
37   function div(
38     uint256 _a,
39     uint256 _b
40   )
41     internal
42     pure
43     returns (uint256)
44   {
45     uint256 c = _a / _b;
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   /**
52    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53    * @param _a Minuend number.
54    * @param _b Subtrahend number.
55    */
56   function sub(
57     uint256 _a,
58     uint256 _b
59   )
60     internal
61     pure
62     returns (uint256)
63   {
64     assert(_b <= _a);
65     return _a - _b;
66   }
67 
68   /**
69    * @dev Adds two numbers, throws on overflow.
70    * @param _a Number.
71    * @param _b Number.
72    */
73   function add(
74     uint256 _a,
75     uint256 _b
76   )
77     internal
78     pure
79     returns (uint256)
80   {
81     uint256 c = _a + _b;
82     assert(c >= _a);
83     return c;
84   }
85 
86 }
87 
88 // File: @0xcert/ethereum-utils/contracts/utils/ERC165.sol
89 
90 pragma solidity ^0.4.24;
91 
92 /**
93  * @dev A standard for detecting smart contract interfaces. See https://goo.gl/cxQCse.
94  */
95 interface ERC165 {
96 
97   /**
98    * @dev Checks if the smart contract includes a specific interface.
99    * @notice This function uses less than 30,000 gas.
100    * @param _interfaceID The interface identifier, as specified in ERC-165.
101    */
102   function supportsInterface(
103     bytes4 _interfaceID
104   )
105     external
106     view
107     returns (bool);
108 
109 }
110 
111 // File: @0xcert/ethereum-utils/contracts/utils/SupportsInterface.sol
112 
113 pragma solidity ^0.4.24;
114 
115 
116 /**
117  * @dev Implementation of standard for detect smart contract interfaces.
118  */
119 contract SupportsInterface is
120   ERC165
121 {
122 
123   /**
124    * @dev Mapping of supported intefraces.
125    * @notice You must not set element 0xffffffff to true.
126    */
127   mapping(bytes4 => bool) internal supportedInterfaces;
128 
129   /**
130    * @dev Contract constructor.
131    */
132   constructor()
133     public
134   {
135     supportedInterfaces[0x01ffc9a7] = true; // ERC165
136   }
137 
138   /**
139    * @dev Function to check which interfaces are suported by this contract.
140    * @param _interfaceID Id of the interface.
141    */
142   function supportsInterface(
143     bytes4 _interfaceID
144   )
145     external
146     view
147     returns (bool)
148   {
149     return supportedInterfaces[_interfaceID];
150   }
151 
152 }
153 
154 // File: @0xcert/ethereum-utils/contracts/utils/AddressUtils.sol
155 
156 pragma solidity ^0.4.24;
157 
158 /**
159  * @dev Utility library of inline functions on addresses.
160  */
161 library AddressUtils {
162 
163   /**
164    * @dev Returns whether the target address is a contract.
165    * @param _addr Address to check.
166    */
167   function isContract(
168     address _addr
169   )
170     internal
171     view
172     returns (bool)
173   {
174     uint256 size;
175 
176     /**
177      * XXX Currently there is no better way to check if there is a contract in an address than to
178      * check the size of the code at that address.
179      * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
180      * TODO: Check this again before the Serenity release, because all addresses will be
181      * contracts then.
182      */
183     assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
184     return size > 0;
185   }
186 
187 }
188 
189 // File: @0xcert/ethereum-utils/contracts/ownership/Ownable.sol
190 
191 pragma solidity ^0.4.24;
192 
193 /**
194  * @dev The contract has an owner address, and provides basic authorization control whitch
195  * simplifies the implementation of user permissions. This contract is based on the source code
196  * at https://goo.gl/n2ZGVt.
197  */
198 contract Ownable {
199   address public owner;
200 
201   /**
202    * @dev An event which is triggered when the owner is changed.
203    * @param previousOwner The address of the previous owner.
204    * @param newOwner The address of the new owner.
205    */
206   event OwnershipTransferred(
207     address indexed previousOwner,
208     address indexed newOwner
209   );
210 
211   /**
212    * @dev The constructor sets the original `owner` of the contract to the sender account.
213    */
214   constructor()
215     public
216   {
217     owner = msg.sender;
218   }
219 
220   /**
221    * @dev Throws if called by any account other than the owner.
222    */
223   modifier onlyOwner() {
224     require(msg.sender == owner);
225     _;
226   }
227 
228   /**
229    * @dev Allows the current owner to transfer control of the contract to a newOwner.
230    * @param _newOwner The address to transfer ownership to.
231    */
232   function transferOwnership(
233     address _newOwner
234   )
235     onlyOwner
236     public
237   {
238     require(_newOwner != address(0));
239     emit OwnershipTransferred(owner, _newOwner);
240     owner = _newOwner;
241   }
242 
243 }
244 
245 // File: @0xcert/ethereum-utils/contracts/ownership/Claimable.sol
246 
247 pragma solidity ^0.4.24;
248 
249 
250 /**
251  * @dev The contract has an owner address, and provides basic authorization control whitch
252  * simplifies the implementation of user permissions. This contract is based on the source code
253  * at goo.gl/CfEAkv and upgrades Ownable contracts with additional claim step which makes ownership
254  * transfers less prone to errors.
255  */
256 contract Claimable is Ownable {
257   address public pendingOwner;
258 
259   /**
260    * @dev An event which is triggered when the owner is changed.
261    * @param previousOwner The address of the previous owner.
262    * @param newOwner The address of the new owner.
263    */
264   event OwnershipTransferred(
265     address indexed previousOwner,
266     address indexed newOwner
267   );
268 
269   /**
270    * @dev Allows the current owner to give new owner ability to claim the ownership of the contract.
271    * This differs from the Owner's function in that it allows setting pedingOwner address to 0x0,
272    * which effectively cancels an active claim.
273    * @param _newOwner The address which can claim ownership of the contract.
274    */
275   function transferOwnership(
276     address _newOwner
277   )
278     onlyOwner
279     public
280   {
281     pendingOwner = _newOwner;
282   }
283 
284   /**
285    * @dev Allows the current pending owner to claim the ownership of the contract. It emits
286    * OwnershipTransferred event and resets pending owner to 0.
287    */
288   function claimOwnership()
289     public
290   {
291     require(msg.sender == pendingOwner);
292     address previousOwner = owner;
293     owner = pendingOwner;
294     pendingOwner = 0;
295     emit OwnershipTransferred(previousOwner, owner);
296   }
297 }
298 
299 // File: contracts/Adminable.sol
300 
301 pragma solidity ^0.4.24;
302 
303 
304 /**
305  * @title Adminable
306  * @dev Allows to manage privilages to special contract functionality.
307  */
308 contract Adminable is Claimable {
309   mapping(address => uint) public adminsMap;
310   address[] public adminList;
311 
312   /**
313    * @dev Returns true, if provided address has special privilages, otherwise false
314    * @param adminAddress - address to check
315    */
316   function isAdmin(address adminAddress)
317     public
318     view
319     returns(bool isIndeed)
320   {
321     if (adminAddress == owner) return true;
322 
323     if (adminList.length == 0) return false;
324     return (adminList[adminsMap[adminAddress]] == adminAddress);
325   }
326 
327   /**
328    * @dev Grants special rights for address holder
329    * @param adminAddress - address of future admin
330    */
331   function addAdmin(address adminAddress)
332     public
333     onlyOwner
334     returns(uint index)
335   {
336     require(!isAdmin(adminAddress), "Address already has admin rights!");
337 
338     adminsMap[adminAddress] = adminList.push(adminAddress)-1;
339 
340     return adminList.length-1;
341   }
342 
343   /**
344    * @dev Removes special rights for provided address
345    * @param adminAddress - address of current admin
346    */
347   function removeAdmin(address adminAddress)
348     public
349     onlyOwner
350     returns(uint index)
351   {
352     // we can not remove owner from admin role
353     require(owner != adminAddress, "Owner can not be removed from admin role!");
354     require(isAdmin(adminAddress), "Provided address is not admin.");
355 
356     uint rowToDelete = adminsMap[adminAddress];
357     address keyToMove = adminList[adminList.length-1];
358     adminList[rowToDelete] = keyToMove;
359     adminsMap[keyToMove] = rowToDelete;
360     adminList.length--;
361 
362     return rowToDelete;
363   }
364 
365   /**
366    * @dev modifier Throws if called by any account other than the owner.
367    */
368   modifier onlyAdmin() {
369     require(isAdmin(msg.sender), "Can be executed only by admin accounts!");
370     _;
371   }
372 }
373 
374 // File: contracts/Priceable.sol
375 
376 pragma solidity ^0.4.24;
377 
378 
379 
380 /**
381  * @title Priceable
382  * @dev Contracts allows to handle ETH resources of the contract.
383  */
384 contract Priceable is Claimable {
385 
386   using SafeMath for uint256;
387 
388   /**
389    * @dev Emits when owner take ETH out of contract
390    * @param balance - amount of ETh sent out from contract
391    */
392   event Withdraw(uint256 balance);
393 
394   /**
395    * @dev modifier Checks minimal amount, what was sent to function call.
396    * @param _minimalAmount - minimal amount neccessary to  continue function call
397    */
398   modifier minimalPrice(uint256 _minimalAmount) {
399     require(msg.value >= _minimalAmount, "Not enough Ether provided.");
400     _;
401   }
402 
403   /**
404    * @dev modifier Associete fee with a function call. If the caller sent too much, then is refunded, but only after the function body.
405    * This was dangerous before Solidity version 0.4.0, where it was possible to skip the part after `_;`.
406    * @param _amount - ether needed to call the function
407    */
408   modifier price(uint256 _amount) {
409     require(msg.value >= _amount, "Not enough Ether provided.");
410     _;
411     if (msg.value > _amount) {
412       msg.sender.transfer(msg.value.sub(_amount));
413     }
414   }
415 
416   /*
417    * @dev Remove all Ether from the contract, and transfer it to account of owner
418    */
419   function withdrawBalance()
420     external
421     onlyOwner
422   {
423     uint256 balance = address(this).balance;
424     msg.sender.transfer(balance);
425 
426     // Tell everyone !!!!!!!!!!!!!!!!!!!!!!
427     emit Withdraw(balance);
428   }
429 
430   // fallback function that allows contract to accept ETH
431   function () public payable {}
432 }
433 
434 // File: contracts/Pausable.sol
435 
436 pragma solidity ^0.4.24;
437 
438 
439 /**
440  * @title Pausable
441  * @dev Base contract which allows children to implement an emergency stop mechanism for mainenance purposes
442  */
443 contract Pausable is Ownable {
444   event Pause();
445   event Unpause();
446 
447   bool public paused = false;
448 
449 
450   /**
451    * @dev modifier to allow actions only when the contract IS paused
452    */
453   modifier whenNotPaused() {
454     require(!paused);
455     _;
456   }
457 
458   /**
459    * @dev modifier to allow actions only when the contract IS NOT paused
460    */
461   modifier whenPaused {
462     require(paused);
463     _;
464   }
465 
466   /**
467    * @dev called by the owner to pause, triggers stopped state
468    */
469   function pause()
470     external
471     onlyOwner
472     whenNotPaused
473     returns (bool)
474   {
475     paused = true;
476     emit Pause();
477     return true;
478   }
479 
480   /**
481    * @dev called by the owner to unpause, returns to normal state
482    */
483   function unpause()
484     external
485     onlyOwner
486     whenPaused
487     returns (bool)
488   {
489     paused = false;
490     emit Unpause();
491     return true;
492   }
493 }
494 
495 // File: contracts/MarbleNFTCandidateInterface.sol
496 
497 pragma solidity ^0.4.24;
498 
499 /**
500  * @title Marble NFT Candidate Contract
501  * @dev Contracts allows public audiance to create Marble NFT candidates. All our candidates for NFT goes through our services to figure out if they are suitable for Marble NFT.
502  * once their are picked our other contract will create NFT with same owner as candite and plcae it to minting auction. In minitng auction everyone can buy created NFT until duration period.
503  * If duration is over, and noone has bought NFT, then creator of candidate can take Marble NFT from minting auction to his collection.
504  */
505 interface MarbleNFTCandidateInterface {
506 
507   /**
508    * @dev Sets minimal price for creating Marble NFT Candidate
509    * @param _minimalMintingPrice Minimal price asked from creator of Marble NFT candidate (weis)
510    */
511   function setMinimalPrice(uint256 _minimalMintingPrice)
512     external;
513 
514   /**
515    * @dev Returns true if URI is already a candidate. Otherwise false.
516    * @param _uri URI to check
517    */
518   function isCandidate(string _uri)
519     external
520     view
521     returns(bool isIndeed);
522 
523 
524   /**
525    * @dev Creates Marble NFT Candidate. This candidate will go through our processing. If it's suitable, then Marble NFT is created.
526    * @param _uri URI of resource you want to transform to Marble NFT
527    */
528   function createCandidate(string _uri)
529     external
530     payable
531     returns(uint index);
532 
533   /**
534    * @dev Removes URI from candidate list.
535    * @param _uri URI to be removed from candidate list.
536    */
537   function removeCandidate(string _uri)
538     external;
539 
540   /**
541    * @dev Returns total count of candidates.
542    */
543   function getCandidatesCount()
544     external
545     view
546     returns(uint256 count);
547 
548   /**
549    * @dev Transforms URI to hash.
550    * @param _uri URI to be transformed to hash.
551    */
552   function getUriHash(string _uri)
553     external
554     view
555     returns(uint256 hash);
556 
557   /**
558    * @dev Returns Candidate model by URI
559    * @param _uri URI representing candidate
560    */
561   function getCandidate(string _uri)
562     external
563     view
564     returns(
565     uint256 index,
566     address owner,
567     uint256 mintingPrice,
568     string url,
569     uint256 created);
570 }
571 
572 // File: contracts/MarbleNFTCandidate.sol
573 
574 pragma solidity ^0.4.24;
575 
576 
577 
578 
579 
580 
581 
582 
583 /**
584  * @title Marble NFT Candidate Contract
585  * @dev Contracts allows public audiance to create Marble NFT candidates. All our candidates for NFT goes through our services to figure out if they are suitable for Marble NFT.
586  * once their are picked our other contract will create NFT with same owner as candite and plcae it to minting auction. In minitng auction everyone can buy created NFT until duration ends.
587  * If duration is over, and noone has bought NFT, then creator of candidate can take Marble NFT from minting auction to his collection.
588  */
589 contract MarbleNFTCandidate is
590   SupportsInterface,
591   Adminable,
592   Pausable,
593   Priceable,
594   MarbleNFTCandidateInterface
595 {
596 
597   using SafeMath for uint256;
598   using AddressUtils for address;
599 
600   struct Candidate {
601     uint256 index;
602 
603     // possible NFT creator
604     address owner;
605 
606     // price paid for minting and placiing NFT to initial auction
607     uint256 mintingPrice;
608 
609     // CANDIDATES DNA
610     string uri;
611 
612     // date of creation
613     uint256 created;
614   }
615 
616   // minimal price for creating candidate
617   uint256 public minimalMintingPrice;
618 
619   // index of candidate in candidates is unique candidate id
620   mapping(uint256 => Candidate) public uriHashToCandidates;
621   uint256[] public uriHashIndex;
622 
623 
624   /**
625    * @dev Transforms URI to hash.
626    * @param _uri URI to be transformed to hash.
627    */
628   function _getUriHash(string _uri)
629     internal
630     pure
631     returns(uint256 hash_) // `hash` changed to `hash_` - according to review
632   {
633     return uint256(keccak256(abi.encodePacked(_uri)));
634   }
635 
636   /**
637    * @dev Returns true if URI is already a candidate. Otherwise false.
638    * @param _uri URI to check
639    */
640   function _isCandidate(string _uri)
641     internal
642     view
643     returns(bool isIndeed)
644   {
645     if(uriHashIndex.length == 0) return false;
646 
647     uint256 uriHash = _getUriHash(_uri);
648     return (uriHashIndex[uriHashToCandidates[uriHash].index] == uriHash);
649   }
650 
651   /**
652    * @dev Sets minimal price for creating Marble NFT Candidate
653    * @param _minimalMintingPrice Minimal price asked from creator of Marble NFT candidate
654    */
655   function setMinimalPrice(uint256 _minimalMintingPrice)
656     external
657     onlyAdmin
658   {
659     minimalMintingPrice = _minimalMintingPrice;
660   }
661 
662   /**
663    * @dev Returns true if URI is already a candidate. Otherwise false.
664    * @param _uri URI to check
665    */
666   function isCandidate(string _uri)
667     external
668     view
669     returns(bool isIndeed)
670   {
671     return _isCandidate(_uri);
672   }
673 
674   /**
675    * @dev Creates Marble NFT Candidate. This candidate will go through our processing. If it's suitable, then Marble NFT is created.
676    * @param _uri URI of resource you want to transform to Marble NFT
677    */
678   function createCandidate(string _uri)
679     external
680     whenNotPaused
681     payable
682     minimalPrice(minimalMintingPrice)
683     returns(uint256 index)
684   {
685     uint256 uriHash = _getUriHash(_uri);
686 
687     require(uriHash != _getUriHash(""), "Candidate URI can not be empty!");
688     require(!_isCandidate(_uri), "Candidate is already created!");
689 
690     uriHashToCandidates[uriHash] = Candidate(uriHashIndex.push(uriHash)-1, msg.sender, msg.value, _uri, now);
691     return uriHashIndex.length -1;
692   }
693 
694 
695   /**
696    * @dev Removes URI from candidate list.
697    * @param _uri URI to be removed from candidate list.
698    */
699   function removeCandidate(string _uri)
700     external
701     onlyAdmin
702   {
703     require(_isCandidate(_uri), "Candidate is not present!");
704 
705     uint256 uriHash = _getUriHash(_uri);
706 
707     uint256 rowToDelete = uriHashToCandidates[uriHash].index;
708     uint256 keyToMove = uriHashIndex[uriHashIndex.length-1];
709     uriHashIndex[rowToDelete] = keyToMove;
710     uriHashToCandidates[keyToMove].index = rowToDelete;
711 
712     delete uriHashToCandidates[uriHash];
713     uriHashIndex.length--;
714   }
715 
716   /**
717    * @dev Returns total count of candidates.
718    */
719   function getCandidatesCount()
720     external
721     view
722     returns(uint256 count)
723   {
724     return uriHashIndex.length;
725   }
726 
727   /**
728    * @dev Transforms URI to hash.
729    * @param _uri URI to be transformed to hash.
730    */
731   function getUriHash(string _uri)
732     external
733     view
734     returns(uint256 hash)
735   {
736     return _getUriHash(_uri);
737   }
738 
739 
740   /**
741    * @dev Returns Candidate model by URI
742    * @param _uri URI representing candidate
743    */
744   function getCandidate(string _uri)
745     external
746     view
747     returns(
748     uint256 index,
749     address owner,
750     uint256 mintingPrice,
751     string uri,
752     uint256 created)
753   {
754     Candidate memory candidate = uriHashToCandidates[_getUriHash(_uri)];
755 
756     return (
757       candidate.index,
758       candidate.owner,
759       candidate.mintingPrice,
760       candidate.uri,
761       candidate.created);
762   }
763 
764 }