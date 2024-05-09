1 pragma solidity ^0.4.13;
2 
3 interface ERC721Metadata {
4 
5     /// @dev ERC-165 (draft) interface signature for ERC721
6     // bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata = // 0x2a786f11
7     //     bytes4(keccak256('name()')) ^
8     //     bytes4(keccak256('symbol()')) ^
9     //     bytes4(keccak256('deedUri(uint256)'));
10 
11     /// @notice A descriptive name for a collection of deeds managed by this
12     ///  contract
13     /// @dev Wallets and exchanges MAY display this to the end user.
14     function name() external pure returns (string _name);
15 
16     /// @notice An abbreviated name for deeds managed by this contract
17     /// @dev Wallets and exchanges MAY display this to the end user.
18     function symbol() external pure returns (string _symbol);
19 
20     /// @notice A distinct name for a deed managed by this contract
21     /// @dev Wallets and exchanges MAY display this to the end user.
22     function deedName(uint256 _deedId) external pure returns (string _deedName);
23 
24     /// @notice A distinct URI (RFC 3986) for a given token.
25     /// @dev If:
26     ///  * The URI is a URL
27     ///  * The URL is accessible
28     ///  * The URL points to a valid JSON file format (ECMA-404 2nd ed.)
29     ///  * The JSON base element is an object
30     ///  then these names of the base element SHALL have special meaning:
31     ///  * "name": A string identifying the item to which `_deedId` grants
32     ///    ownership
33     ///  * "description": A string detailing the item to which `_deedId` grants
34     ///    ownership
35     ///  * "image": A URI pointing to a file of image/* mime type representing
36     ///    the item to which `_deedId` grants ownership
37     ///  Wallets and exchanges MAY display this to the end user.
38     ///  Consider making any images at a width between 320 and 1080 pixels and
39     ///  aspect ratio between 1.91:1 and 4:5 inclusive.
40     function deedUri(uint256 _deedId) external view returns (string _deedUri);
41 }
42 
43 contract ReentrancyGuard {
44 
45   /**
46    * @dev We use a single lock for the whole contract.
47    */
48   bool private reentrancy_lock = false;
49 
50   /**
51    * @dev Prevents a contract from calling itself, directly or indirectly.
52    * @notice If you mark a function `nonReentrant`, you should also
53    * mark it `external`. Calling one nonReentrant function from
54    * another is not supported. Instead, you can implement a
55    * `private` function doing the actual work, and a `external`
56    * wrapper marked as `nonReentrant`.
57    */
58   modifier nonReentrant() {
59     require(!reentrancy_lock);
60     reentrancy_lock = true;
61     _;
62     reentrancy_lock = false;
63   }
64 
65 }
66 
67 library SafeMath {
68 
69   /**
70   * @dev Multiplies two numbers, throws on overflow.
71   */
72   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73     if (a == 0) {
74       return 0;
75     }
76     uint256 c = a * b;
77     assert(c / a == b);
78     return c;
79   }
80 
81   /**
82   * @dev Integer division of two numbers, truncating the quotient.
83   */
84   function div(uint256 a, uint256 b) internal pure returns (uint256) {
85     // assert(b > 0); // Solidity automatically throws when dividing by 0
86     // uint256 c = a / b;
87     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88     return a / b;
89   }
90 
91   /**
92   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
93   */
94   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   /**
100   * @dev Adds two numbers, throws on overflow.
101   */
102   function add(uint256 a, uint256 b) internal pure returns (uint256) {
103     uint256 c = a + b;
104     assert(c >= a);
105     return c;
106   }
107 }
108 
109 contract Ownable {
110   address public owner;
111 
112 
113   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114 
115 
116   /**
117    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
118    * account.
119    */
120   function Ownable() public {
121     owner = msg.sender;
122   }
123 
124   /**
125    * @dev Throws if called by any account other than the owner.
126    */
127   modifier onlyOwner() {
128     require(msg.sender == owner);
129     _;
130   }
131 
132   /**
133    * @dev Allows the current owner to transfer control of the contract to a newOwner.
134    * @param newOwner The address to transfer ownership to.
135    */
136   function transferOwnership(address newOwner) public onlyOwner {
137     require(newOwner != address(0));
138     emit OwnershipTransferred(owner, newOwner);
139     owner = newOwner;
140   }
141 
142 }
143 
144 contract Pausable is Ownable {
145   event Pause();
146   event Unpause();
147 
148   bool public paused = false;
149 
150 
151   /**
152    * @dev Modifier to make a function callable only when the contract is not paused.
153    */
154   modifier whenNotPaused() {
155     require(!paused);
156     _;
157   }
158 
159   /**
160    * @dev Modifier to make a function callable only when the contract is paused.
161    */
162   modifier whenPaused() {
163     require(paused);
164     _;
165   }
166 
167   /**
168    * @dev called by the owner to pause, triggers stopped state
169    */
170   function pause() onlyOwner whenNotPaused public {
171     paused = true;
172     emit Pause();
173   }
174 
175   /**
176    * @dev called by the owner to unpause, returns to normal state
177    */
178   function unpause() onlyOwner whenPaused public {
179     paused = false;
180     emit Unpause();
181   }
182 }
183 
184 interface ERC721 {
185 
186     // COMPLIANCE WITH ERC-165 (DRAFT) /////////////////////////////////////////
187 
188     /// @dev ERC-165 (draft) interface signature for itself
189     // bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = // 0x01ffc9a7
190     //     bytes4(keccak256('supportsInterface(bytes4)'));
191 
192     /// @dev ERC-165 (draft) interface signature for ERC721
193     // bytes4 internal constant INTERFACE_SIGNATURE_ERC721 = // 0xda671b9b
194     //     bytes4(keccak256('ownerOf(uint256)')) ^
195     //     bytes4(keccak256('countOfDeeds()')) ^
196     //     bytes4(keccak256('countOfDeedsByOwner(address)')) ^
197     //     bytes4(keccak256('deedOfOwnerByIndex(address,uint256)')) ^
198     //     bytes4(keccak256('approve(address,uint256)')) ^
199     //     bytes4(keccak256('takeOwnership(uint256)'));
200 
201     /// @notice Query a contract to see if it supports a certain interface
202     /// @dev Returns `true` the interface is supported and `false` otherwise,
203     ///  returns `true` for INTERFACE_SIGNATURE_ERC165 and
204     ///  INTERFACE_SIGNATURE_ERC721, see ERC-165 for other interface signatures.
205     function supportsInterface(bytes4 _interfaceID) external pure returns (bool);
206 
207     // PUBLIC QUERY FUNCTIONS //////////////////////////////////////////////////
208 
209     /// @notice Find the owner of a deed
210     /// @param _deedId The identifier for a deed we are inspecting
211     /// @dev Deeds assigned to zero address are considered invalid, and
212     ///  queries about them do throw.
213     /// @return The non-zero address of the owner of deed `_deedId`, or `throw`
214     ///  if deed `_deedId` is not tracked by this contract
215     function ownerOf(uint256 _deedId) external view returns (address _owner);
216 
217     /// @notice Count deeds tracked by this contract
218     /// @return A count of valid deeds tracked by this contract, where each one of
219     ///  them has an assigned and queryable owner not equal to the zero address
220     function countOfDeeds() external view returns (uint256 _count);
221 
222     /// @notice Count all deeds assigned to an owner
223     /// @dev Throws if `_owner` is the zero address, representing invalid deeds.
224     /// @param _owner An address where we are interested in deeds owned by them
225     /// @return The number of deeds owned by `_owner`, possibly zero
226     function countOfDeedsByOwner(address _owner) external view returns (uint256 _count);
227 
228     /// @notice Enumerate deeds assigned to an owner
229     /// @dev Throws if `_index` >= `countOfDeedsByOwner(_owner)` or if
230     ///  `_owner` is the zero address, representing invalid deeds.
231     /// @param _owner An address where we are interested in deeds owned by them
232     /// @param _index A counter less than `countOfDeedsByOwner(_owner)`
233     /// @return The identifier for the `_index`th deed assigned to `_owner`,
234     ///   (sort order not specified)
235     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId);
236 
237     // TRANSFER MECHANISM //////////////////////////////////////////////////////
238 
239     /// @dev This event emits when ownership of any deed changes by any
240     ///  mechanism. This event emits when deeds are created (`from` == 0) and
241     ///  destroyed (`to` == 0). Exception: during contract creation, any
242     ///  transfers may occur without emitting `Transfer`. At the time of any transfer,
243     ///  the "approved taker" is implicitly reset to the zero address.
244     event Transfer(address indexed _from, address indexed _to, uint256 indexed _deedId);
245 
246     /// @dev The Approve event emits to log the "approved taker" for a deed -- whether
247     ///  set for the first time, reaffirmed by setting the same value, or setting to
248     ///  a new value. The "approved taker" is the zero address if nobody can take the
249     ///  deed now or it is an address if that address can call `takeOwnership` to attempt
250     ///  taking the deed. Any change to the "approved taker" for a deed SHALL cause
251     ///  Approve to emit. However, an exception, the Approve event will not emit when
252     ///  Transfer emits, this is because Transfer implicitly denotes the "approved taker"
253     ///  is reset to the zero address.
254     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _deedId);
255 
256     /// @notice Set the "approved taker" for your deed, or revoke approval by
257     ///  setting the zero address. You may `approve` any number of times while
258     ///  the deed is assigned to you, only the most recent approval matters. Emits
259     ///  an Approval event.
260     /// @dev Throws if `msg.sender` does not own deed `_deedId` or if `_to` ==
261     ///  `msg.sender` or if `_deedId` is not a valid deed.
262     /// @param _deedId The deed for which you are granting approval
263     function approve(address _to, uint256 _deedId) external payable;
264 
265     /// @notice Become owner of a deed for which you are currently approved
266     /// @dev Throws if `msg.sender` is not approved to become the owner of
267     ///  `deedId` or if `msg.sender` currently owns `_deedId` or if `_deedId is not a
268     ///  valid deed.
269     /// @param _deedId The deed that is being transferred
270     function takeOwnership(uint256 _deedId) external payable;
271 }
272 
273 contract ERC721Deed is ERC721 {
274   using SafeMath for uint256;
275 
276   // Total amount of deeds
277   uint256 private totalDeeds;
278 
279   // Mapping from deed ID to owner
280   mapping (uint256 => address) private deedOwner;
281 
282   // Mapping from deed ID to approved address
283   mapping (uint256 => address) private deedApprovedFor;
284 
285   // Mapping from owner to list of owned deed IDs
286   mapping (address => uint256[]) private ownedDeeds;
287 
288   // Mapping from deed ID to index of the owner deeds list
289   mapping(uint256 => uint256) private ownedDeedsIndex;
290 
291   /**
292   * @dev Guarantees msg.sender is owner of the given deed
293   * @param _deedId uint256 ID of the deed to validate its ownership belongs to msg.sender
294   */
295   modifier onlyOwnerOf(uint256 _deedId) {
296     require(deedOwner[_deedId] == msg.sender);
297     _;
298   }
299 
300   /**
301   * @dev Gets the owner of the specified deed ID
302   * @param _deedId uint256 ID of the deed to query the owner of
303   * @return owner address currently marked as the owner of the given deed ID
304   */
305   function ownerOf(uint256 _deedId)
306   external view returns (address _owner) {
307     require(deedOwner[_deedId] != address(0));
308     _owner = deedOwner[_deedId];
309   }
310 
311   /**
312   * @dev Gets the total amount of deeds stored by the contract
313   * @return uint256 representing the total amount of deeds
314   */
315   function countOfDeeds()
316   external view returns (uint256) {
317     return totalDeeds;
318   }
319 
320   /**
321   * @dev Gets the number of deeds of the specified address
322   * @param _owner address to query the number of deeds
323   * @return uint256 representing the number of deeds owned by the passed address
324   */
325   function countOfDeedsByOwner(address _owner)
326   external view returns (uint256 _count) {
327     require(_owner != address(0));
328     _count = ownedDeeds[_owner].length;
329   }
330 
331   /**
332   * @dev Gets the deed ID of the specified address at the specified index
333   * @param _owner address for the deed's owner
334   * @param _index uint256 for the n-th deed in the list of deeds owned by this owner
335   * @return uint256 representing the ID of the deed
336   */
337   function deedOfOwnerByIndex(address _owner, uint256 _index)
338   external view returns (uint256 _deedId) {
339     require(_owner != address(0));
340     require(_index < ownedDeeds[_owner].length);
341     _deedId = ownedDeeds[_owner][_index];
342   }
343 
344   /**
345   * @dev Gets all deed IDs of the specified address
346   * @param _owner address for the deed's owner
347   * @return uint256[] representing all deed IDs owned by the passed address
348   */
349   function deedsOf(address _owner)
350   external view returns (uint256[] _ownedDeedIds) {
351     require(_owner != address(0));
352     _ownedDeedIds = ownedDeeds[_owner];
353   }
354 
355   /**
356   * @dev Approves another address to claim for the ownership of the given deed ID
357   * @param _to address to be approved for the given deed ID
358   * @param _deedId uint256 ID of the deed to be approved
359   */
360   function approve(address _to, uint256 _deedId)
361   external onlyOwnerOf(_deedId) payable {
362     require(msg.value == 0);
363     require(_to != msg.sender);
364     if(_to != address(0) || approvedFor(_deedId) != address(0)) {
365       emit Approval(msg.sender, _to, _deedId);
366     }
367     deedApprovedFor[_deedId] = _to;
368   }
369 
370   /**
371   * @dev Claims the ownership of a given deed ID
372   * @param _deedId uint256 ID of the deed being claimed by the msg.sender
373   */
374   function takeOwnership(uint256 _deedId)
375   external payable {
376     require(approvedFor(_deedId) == msg.sender);
377     clearApprovalAndTransfer(deedOwner[_deedId], msg.sender, _deedId);
378   }
379 
380   /**
381    * @dev Gets the approved address to take ownership of a given deed ID
382    * @param _deedId uint256 ID of the deed to query the approval of
383    * @return address currently approved to take ownership of the given deed ID
384    */
385   function approvedFor(uint256 _deedId)
386   public view returns (address) {
387     return deedApprovedFor[_deedId];
388   }
389 
390   /**
391   * @dev Transfers the ownership of a given deed ID to another address
392   * @param _to address to receive the ownership of the given deed ID
393   * @param _deedId uint256 ID of the deed to be transferred
394   */
395   function transfer(address _to, uint256 _deedId)
396   public onlyOwnerOf(_deedId) {
397     clearApprovalAndTransfer(msg.sender, _to, _deedId);
398   }
399 
400   /**
401   * @dev Mint deed function
402   * @param _to The address that will own the minted deed
403   */
404   function _mint(address _to, uint256 _deedId)
405   internal {
406     require(_to != address(0));
407     addDeed(_to, _deedId);
408     emit Transfer(0x0, _to, _deedId);
409   }
410 
411   /**
412   * @dev Burns a specific deed
413   * @param _deedId uint256 ID of the deed being burned by the msg.sender
414   * Removed because Factbars cannot be destroyed
415   */
416   // function _burn(uint256 _deedId) onlyOwnerOf(_deedId)
417   // internal {
418   //   if (approvedFor(_deedId) != 0) {
419   //     clearApproval(msg.sender, _deedId);
420   //   }
421   //   removeDeed(msg.sender, _deedId);
422   //   emit Transfer(msg.sender, 0x0, _deedId);
423   // }
424 
425   /**
426   * @dev Internal function to clear current approval and transfer the ownership of a given deed ID
427   * @param _from address which you want to send deeds from
428   * @param _to address which you want to transfer the deed to
429   * @param _deedId uint256 ID of the deed to be transferred
430   */
431   function clearApprovalAndTransfer(address _from, address _to, uint256 _deedId)
432   internal {
433     require(_to != address(0));
434     require(_to != _from);
435     require(deedOwner[_deedId] == _from);
436 
437     clearApproval(_from, _deedId);
438     removeDeed(_from, _deedId);
439     addDeed(_to, _deedId);
440     emit Transfer(_from, _to, _deedId);
441   }
442 
443   /**
444   * @dev Internal function to clear current approval of a given deed ID
445   * @param _deedId uint256 ID of the deed to be transferred
446   */
447   function clearApproval(address _owner, uint256 _deedId)
448   private {
449     require(deedOwner[_deedId] == _owner);
450     deedApprovedFor[_deedId] = 0;
451     emit Approval(_owner, 0, _deedId);
452   }
453 
454   /**
455   * @dev Internal function to add a deed ID to the list of a given address
456   * @param _to address representing the new owner of the given deed ID
457   * @param _deedId uint256 ID of the deed to be added to the deeds list of the given address
458   */
459   function addDeed(address _to, uint256 _deedId)
460   private {
461     require(deedOwner[_deedId] == address(0));
462     deedOwner[_deedId] = _to;
463     uint256 length = ownedDeeds[_to].length;
464     ownedDeeds[_to].push(_deedId);
465     ownedDeedsIndex[_deedId] = length;
466     totalDeeds = totalDeeds.add(1);
467   }
468 
469   /**
470   * @dev Internal function to remove a deed ID from the list of a given address
471   * @param _from address representing the previous owner of the given deed ID
472   * @param _deedId uint256 ID of the deed to be removed from the deeds list of the given address
473   */
474   function removeDeed(address _from, uint256 _deedId)
475   private {
476     require(deedOwner[_deedId] == _from);
477 
478     uint256 deedIndex = ownedDeedsIndex[_deedId];
479     uint256 lastDeedIndex = ownedDeeds[_from].length.sub(1);
480     uint256 lastDeed = ownedDeeds[_from][lastDeedIndex];
481 
482     deedOwner[_deedId] = 0;
483     ownedDeeds[_from][deedIndex] = lastDeed;
484     ownedDeeds[_from][lastDeedIndex] = 0;
485     // Note that this will handle single-element arrays. In that case, both deedIndex and lastDeedIndex are going to
486     // be zero. Then we can make sure that we will remove _deedId from the ownedDeeds list since we are first swapping
487     // the lastDeed to the first position, and then dropping the element placed in the last position of the list
488 
489     ownedDeeds[_from].length--;
490     ownedDeedsIndex[_deedId] = 0;
491     ownedDeedsIndex[lastDeed] = deedIndex;
492     totalDeeds = totalDeeds.sub(1);
493   }
494 }
495 
496 contract PullPayment {
497   using SafeMath for uint256;
498 
499   mapping(address => uint256) public payments;
500   uint256 public totalPayments;
501 
502   /**
503   * @dev Withdraw accumulated balance, called by payee.
504   */
505   function withdrawPayments() public {
506     address payee = msg.sender;
507     uint256 payment = payments[payee];
508 
509     require(payment != 0);
510     require(address(this).balance >= payment);
511 
512     totalPayments = totalPayments.sub(payment);
513     payments[payee] = 0;
514 
515     payee.transfer(payment);
516   }
517 
518   /**
519   * @dev Called by the payer to store the sent amount as credit to be pulled.
520   * @param dest The destination address of the funds.
521   * @param amount The amount to transfer.
522   */
523   function asyncSend(address dest, uint256 amount) internal {
524     payments[dest] = payments[dest].add(amount);
525     totalPayments = totalPayments.add(amount);
526   }
527 }
528 
529 contract FactbarDeed is ERC721Deed, Pausable, PullPayment, ReentrancyGuard {
530 
531   using SafeMath for uint256;
532 
533   /* Events */
534   // When a deed is created by the contract owner.
535   event Creation(uint256 indexed id, bytes32 indexed name, address factTeam);
536 
537   // When a deed is appropriated, the ownership of the deed is transferred to the new owner.
538   // The old owner is reimbursed, and he gets the new price minus the transfer fee.
539   event Appropriation(uint256 indexed id, address indexed oldOwner, 
540   address indexed newOwner, uint256 oldPrice, uint256 newPrice,
541   uint256 transferFeeAmount, uint256 excess,  uint256 oldOwnerPaymentAmount );
542 
543   // Payments to the deed's fee address via PullPayment are also supported by this contract.
544   event Payment(uint256 indexed id, address indexed sender, address 
545   indexed factTeam, uint256 amount);
546 
547   // Factbars, like facts, cannot be destroyed. So we have removed 
548   // all the deletion and desctruction features
549 
550   // The data structure of the Factbar deed
551   
552   struct Factbar {
553     bytes32 name;
554     address factTeam;
555     uint256 price;
556     uint256 created;
557   }
558 
559   // Mapping from _deedId to Factbar
560   mapping (uint256 => Factbar) private deeds;
561 
562   // Mapping from deed name to boolean indicating if the name is already taken
563   mapping (bytes32 => bool) private deedNameExists;
564 
565   // Needed to make all deeds discoverable. The length of this array also serves as our deed ID.
566   uint256[] private deedIds;
567 
568   // These are the admins who have the power to create deeds.
569   mapping (address => bool) private admins;
570 
571   /* Variables in control of owner */
572 
573   // The contract owner can change the initial price of deeds at Creation.
574   uint256 private creationPrice = 0.0005 ether; 
575 
576   // The contract owner can change the base URL, in case it becomes necessary. It is needed for Metadata.
577   string public url = "https://fact-bar.org/facts/";
578 
579   // ERC-165 Metadata
580   bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = // 0x01ffc9a7
581       bytes4(keccak256('supportsInterface(bytes4)'));
582 
583   bytes4 internal constant INTERFACE_SIGNATURE_ERC721 = // 0xda671b9b
584       bytes4(keccak256('ownerOf(uint256)')) ^
585       bytes4(keccak256('countOfDeeds()')) ^
586       bytes4(keccak256('countOfDeedsByOwner(address)')) ^
587       bytes4(keccak256('deedOfOwnerByIndex(address,uint256)')) ^
588       bytes4(keccak256('approve(address,uint256)')) ^
589       bytes4(keccak256('takeOwnership(uint256)'));
590 
591   bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata = // 0x2a786f11
592       bytes4(keccak256('name()')) ^
593       bytes4(keccak256('symbol()')) ^
594       bytes4(keccak256('deedUri(uint256)'));
595 
596 
597   function FactbarDeed() public {}
598 
599   // payable removed from fallback function following audit
600   function() public {}
601 
602   modifier onlyExistingNames(uint256 _deedId) {
603     require(deedNameExists[deeds[_deedId].name]);
604     _;
605   }
606 
607   modifier noExistingNames(bytes32 _name) {
608     require(!deedNameExists[_name]);
609     _;
610   }
611   
612   modifier onlyAdmins() {
613     require(admins[msg.sender]);
614     _;
615   }
616 
617 
618    /* ERC721Metadata */
619 
620   function name()
621   external pure returns (string) {
622     return "Factbar";
623   }
624 
625   function symbol()
626   external pure returns (string) {
627     return "FTBR";
628   }
629 
630   function supportsInterface(bytes4 _interfaceID)
631   external pure returns (bool) {
632     return (
633       _interfaceID == INTERFACE_SIGNATURE_ERC165
634       || _interfaceID == INTERFACE_SIGNATURE_ERC721
635       || _interfaceID == INTERFACE_SIGNATURE_ERC721Metadata
636     );
637   }
638 
639   function deedUri(uint256 _deedId)
640   external view onlyExistingNames(_deedId) returns (string _uri) {
641     _uri = _strConcat(url, _bytes32ToString(deeds[_deedId].name));
642   }
643 
644   function deedName(uint256 _deedId)
645   external view onlyExistingNames(_deedId) returns (string _name) {
646     _name = _bytes32ToString(deeds[_deedId].name);
647   }
648 
649 
650   // get pending payments to address, generated from appropriations
651   function getPendingPaymentAmount(address _account)
652   external view returns (uint256 _balance) {
653      uint256 payment = payments[_account];
654     _balance = payment;
655   }
656 
657   // get Ids of all deeds  
658   function getDeedIds()
659   external view returns (uint256[]) {
660     return deedIds;
661   }
662  
663   /// Logic for pricing of deeds
664   function nextPriceOf (uint256 _deedId) public view returns (uint256 _nextPrice) {
665     return calculateNextPrice(priceOf(_deedId));
666   }
667 
668   uint256 private increaseLimit1 = 0.02 ether;
669   uint256 private increaseLimit2 = 0.5 ether;
670   uint256 private increaseLimit3 = 2.0 ether;
671   uint256 private increaseLimit4 = 5.0 ether;
672 
673   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
674     if (_price < increaseLimit1) {
675       return _price.mul(200).div(100);
676     } else if (_price < increaseLimit2) {
677       return _price.mul(135).div(100);
678     } else if (_price < increaseLimit3) {
679       return _price.mul(125).div(100);
680     } else if (_price < increaseLimit4) {
681       return _price.mul(117).div(100);
682     } else {
683       return _price.mul(115).div(100);
684     }
685   }
686 
687   function calculateTransferFee (uint256 _price) public view returns (uint256 _devCut) {
688     if (_price < increaseLimit1) {
689       return _price.mul(5).div(100); // 5%
690     } else if (_price < increaseLimit2) {
691       return _price.mul(4).div(100); // 4%
692     } else if (_price < increaseLimit3) {
693       return _price.mul(3).div(100); // 3%
694     } else if (_price < increaseLimit4) {
695       return _price.mul(3).div(100); // 3%
696     } else {
697       return _price.mul(3).div(100); // 3%
698     }
699   }
700 
701 
702   // Forces the transfer of the deed to a new owner, 
703   // if a higher price was paid. This functionality can be paused by the owner.
704   function appropriate(uint256 _deedId)
705   external whenNotPaused nonReentrant payable {
706 
707     // Get current price of deed
708     uint256 price = priceOf(_deedId);
709 
710      // The current owner is forbidden to appropriate himself.
711     address oldOwner = this.ownerOf(_deedId);
712     address newOwner = msg.sender;
713     require(oldOwner != newOwner);
714     
715     // price must be more than zero
716     require(priceOf(_deedId) > 0); 
717     
718     // offered price must be more than or equal to the current price
719     require(msg.value >= price); 
720 
721     /// Any over-payment by the buyer will be sent back to him/her
722     uint256 excess = msg.value.sub(price);
723 
724     // Clear any outstanding approvals and transfer the deed.*/
725     clearApprovalAndTransfer(oldOwner, newOwner, _deedId);
726     uint256 nextPrice = nextPriceOf(_deedId);
727     deeds[_deedId].price = nextPrice;
728     
729     // transfer fee is calculated
730     uint256 transferFee = calculateTransferFee(price);
731 
732     /// previous owner gets entire new payment minus the transfer fee
733     uint256 oldOwnerPayment = price.sub(transferFee);
734 
735     /// using Pullpayment for safety
736     asyncSend(factTeamOf(_deedId), transferFee);
737     asyncSend(oldOwner, oldOwnerPayment);
738 
739     if (excess > 0) {
740        asyncSend(newOwner, excess);
741     }
742 
743     emit Appropriation(_deedId, oldOwner, newOwner, price, nextPrice,
744     transferFee, excess, oldOwnerPayment);
745   }
746 
747   // these events can be turned on to make up for Solidity's horrifying logging situation
748   // event logUint(address add, string text, uint256 value);
749   // event simpleLogUint(string text, uint256 value);
750 
751   // Send a PullPayment.
752   function pay(uint256 _deedId)
753   external nonReentrant payable {
754     address factTeam = factTeamOf(_deedId);
755     asyncSend(factTeam, msg.value);
756     emit Payment(_deedId, msg.sender, factTeam, msg.value);
757   }
758 
759   // The owner can only withdraw what has not been assigned to the transfer fee address as PullPayments.
760   function withdraw()
761   external nonReentrant {
762     withdrawPayments();
763     if (msg.sender == owner) {
764       // The contract's balance MUST stay backing the outstanding withdrawals.
765       //  Only the surplus not needed for any backing can be withdrawn by the owner.
766       uint256 surplus = address(this).balance.sub(totalPayments);
767       if (surplus > 0) {
768         owner.transfer(surplus);
769       }
770     }
771   }
772 
773   /* Owner Functions */
774 
775   // The contract owner creates deeds. Newly created deeds are
776   // initialised with a name and a transfer fee address
777   // only Admins can create deeds
778   function create(bytes32 _name, address _factTeam)
779   public onlyAdmins noExistingNames(_name) {
780     deedNameExists[_name] = true;
781     uint256 deedId = deedIds.length;
782     deedIds.push(deedId);
783     super._mint(owner, deedId);
784     deeds[deedId] = Factbar({
785       name: _name,
786       factTeam: _factTeam,
787       price: creationPrice,
788       created: now
789       // deleted: 0
790     });
791     emit Creation(deedId, _name, owner);
792   }
793 
794   // the owner can add and remove admins as per his/her whim
795 
796   function addAdmin(address _admin)  
797   public onlyOwner{
798     admins[_admin] = true;
799   }
800 
801   function removeAdmin (address _admin)  
802   public onlyOwner{
803     delete admins[_admin];
804   }
805 
806   // the owner can set the creation price 
807 
808   function setCreationPrice(uint256 _price)
809   public onlyOwner {
810     creationPrice = _price;
811   }
812 
813   function setUrl(string _url)
814   public onlyOwner {
815     url = _url;
816   }
817 
818   /* Other publicly available functions */
819 
820   // Returns the last paid price for this deed.
821   function priceOf(uint256 _deedId)
822   public view returns (uint256 _price) {
823     _price = deeds[_deedId].price;
824   }
825 
826   // Returns the current transfer fee address
827   function factTeamOf(uint256 _deedId)
828   public view returns (address _factTeam) {
829     _factTeam = deeds[_deedId].factTeam;
830   }
831 
832 
833   /* Private helper functions */        
834 
835   function _bytes32ToString(bytes32 _bytes32)
836   private pure returns (string) {
837     bytes memory bytesString = new bytes(32);
838     uint charCount = 0;
839     for (uint j = 0; j < 32; j++) {
840       byte char = byte(bytes32(uint(_bytes32) * 2 ** (8 * j)));
841       if (char != 0) {
842         bytesString[charCount] = char;
843         charCount++;
844       }
845     }
846     bytes memory bytesStringTrimmed = new bytes(charCount);
847     for (j = 0; j < charCount; j++) {
848       bytesStringTrimmed[j] = bytesString[j];
849     }
850 
851     return string(bytesStringTrimmed);
852   }
853 
854   function _strConcat(string _a, string _b)
855   private pure returns (string) {
856     bytes memory _ba = bytes(_a);
857     bytes memory _bb = bytes(_b);
858     string memory ab = new string(_ba.length + _bb.length);
859     bytes memory bab = bytes(ab);
860     uint k = 0;
861     for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
862     for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
863     return string(bab);
864   }
865 
866 }
867 
868 // The MIT License (MIT)
869 // Copyright (c) 2018 Factbar
870 // Copyright (c) 2016 Smart Contract Solutions, Inc.
871 
872 // Permission is hereby granted, free of charge, 
873 // to any person obtaining a copy of this software and 
874 // associated documentation files (the "Software"), to 
875 // deal in the Software without restriction, including 
876 // without limitation the rights to use, copy, modify, 
877 // merge, publish, distribute, sublicense, and/or sell 
878 // copies of the Software, and to permit persons to whom 
879 // the Software is furnished to do so, 
880 // subject to the following conditions:
881 
882 // The above copyright notice and this permission notice 
883 // shall be included in all copies or substantial portions of the Software.
884 
885 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
886 // EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
887 // OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
888 // IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR 
889 // ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
890 // TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
891 // SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.