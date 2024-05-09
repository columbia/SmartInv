1 pragma solidity ^0.5.3;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 library Address {
50 
51   /**
52    * Returns whether the target address is a contract
53    * @dev This function will return false if invoked during the constructor of a contract,
54    * as the code is not actually created until after the constructor finishes.
55    * @param account address of the account to check
56    * @return whether the target address is a contract
57    */
58   function isContract(address account) internal view returns (bool) {
59     uint256 size;
60     // XXX Currently there is no better way to check if there is a contract in an address
61     // than to check the size of the code at that address.
62     // See https://ethereum.stackexchange.com/a/14016/36603
63     // for more details about how this works.
64     // TODO Check this again before the Serenity release, because all addresses will be
65     // contracts then.
66     // solium-disable-next-line security/no-inline-assembly
67     assembly { size := extcodesize(account) }
68     return size > 0;
69   }
70 
71 }
72 
73 library SafeERC20 {
74     function safeTransfer(
75       ERC20Basic _token,
76       address _to,
77       uint256 _value
78     )
79       internal
80     {
81       require(_token.transfer(_to, _value));
82     }
83   
84     function safeTransferFrom(
85       ERC20 _token,
86       address _from,
87       address _to,
88       uint256 _value
89     )
90       internal
91     {
92       require(_token.transferFrom(_from, _to, _value));
93     }
94   
95     function safeApprove(
96       ERC20 _token,
97       address _spender,
98       uint256 _value
99     )
100       internal
101     {
102         require(_token.approve(_spender, _value));
103     }
104 }
105 
106 contract Ownable {
107   address public owner;
108 
109 
110   event OwnershipRenounced(address indexed previousOwner);
111   event OwnershipTransferred(
112     address indexed previousOwner,
113     address indexed newOwner
114   );
115 
116 
117   /**
118    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
119    * account.
120    */
121   constructor() public {
122     owner = msg.sender;
123   }
124 
125   /**
126    * @dev Throws if called by any account other than the owner.
127    */
128   modifier onlyOwner() {
129     require(msg.sender == owner);
130     _;
131   }
132 
133   /**
134    * @dev Allows the current owner to relinquish control of the contract.
135    * @notice Renouncing to ownership will leave the contract without an owner.
136    * It will not be possible to call the functions with the `onlyOwner`
137    * modifier anymore.
138    */
139   function renounceOwnership() public onlyOwner {
140     emit OwnershipRenounced(owner);
141     owner = address(0);
142   }
143 
144   /**
145    * @dev Allows the current owner to transfer control of the contract to a newOwner.
146    * @param _newOwner The address to transfer ownership to.
147    */
148   function transferOwnership(address _newOwner) public onlyOwner {
149     _transferOwnership(_newOwner);
150   }
151 
152   /**
153    * @dev Transfers control of the contract to a newOwner.
154    * @param _newOwner The address to transfer ownership to.
155    */
156   function _transferOwnership(address _newOwner) internal {
157     require(_newOwner != address(0));
158     emit OwnershipTransferred(owner, _newOwner);
159     owner = _newOwner;
160   }
161 }
162 
163 contract Pausable is Ownable {
164   event Pause();
165   event Unpause();
166 
167   bool public paused = false;
168 
169 
170   /**
171    * @dev Modifier to make a function callable only when the contract is not paused.
172    */
173   modifier whenNotPaused() {
174     require(!paused);
175     _;
176   }
177 
178   /**
179    * @dev Modifier to make a function callable only when the contract is paused.
180    */
181   modifier whenPaused() {
182     require(paused);
183     _;
184   }
185 
186   /**
187    * @dev called by the owner to pause, triggers stopped state
188    */
189   function pause() public onlyOwner whenNotPaused {
190     paused = true;
191     emit Pause();
192   }
193 
194   /**
195    * @dev called by the owner to unpause, returns to normal state
196    */
197   function unpause() public onlyOwner whenPaused {
198     paused = false;
199     emit Unpause();
200   }
201 }
202 
203 contract ERC20Basic {
204   function totalSupply() public view returns (uint256);
205   function balanceOf(address _who) public view returns (uint256);
206   function transfer(address _to, uint256 _value) public returns (bool);
207   event Transfer(address indexed from, address indexed to, uint256 value);
208 }
209   
210 contract BasicToken is ERC20Basic {
211   using SafeMath for uint256;
212 
213   mapping(address => uint256) internal balances;
214 
215   uint256 internal totalSupply_;
216 
217   /**
218   * @dev Total number of tokens in existence
219   */
220   function totalSupply() public view returns (uint256) {
221     return totalSupply_;
222   }
223 
224   /**
225   * @dev Transfer token for a specified address
226   * @param _to The address to transfer to.
227   * @param _value The amount to be transferred.
228   */
229   function transfer(address _to, uint256 _value) public returns (bool) {
230     require(_value <= balances[msg.sender]);
231     require(_to != address(0));
232 
233     balances[msg.sender] = balances[msg.sender].sub(_value);
234     balances[_to] = balances[_to].add(_value);
235     emit Transfer(msg.sender, _to, _value);
236     return true;
237   }
238 
239   /**
240   * @dev Gets the balance of the specified address.
241   * @param _owner The address to query the the balance of.
242   * @return An uint256 representing the amount owned by the passed address.
243   */
244   function balanceOf(address _owner) public view returns (uint256) {
245     return balances[_owner];
246   }
247 
248 }
249 
250 contract ERC20 is ERC20Basic {
251   function allowance(address _owner, address _spender)
252     public view returns (uint256);
253 
254   function transferFrom(address _from, address _to, uint256 _value)
255     public returns (bool);
256 
257   function approve(address _spender, uint256 _value) public returns (bool);
258   event Approval(
259     address indexed owner,
260     address indexed spender,
261     uint256 value
262   );
263 }
264 
265 contract StandardToken is ERC20, BasicToken {
266 
267   mapping (address => mapping (address => uint256)) internal allowed;
268 
269 
270   /**
271    * @dev Transfer tokens from one address to another
272    * @param _from address The address which you want to send tokens from
273    * @param _to address The address which you want to transfer to
274    * @param _value uint256 the amount of tokens to be transferred
275    */
276   function transferFrom(
277     address _from,
278     address _to,
279     uint256 _value
280   )
281     public
282     returns (bool)
283   {
284     require(_value <= balances[_from]);
285     require(_value <= allowed[_from][msg.sender]);
286     require(_to != address(0));
287 
288     balances[_from] = balances[_from].sub(_value);
289     balances[_to] = balances[_to].add(_value);
290     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
291     emit Transfer(_from, _to, _value);
292     return true;
293   }
294 
295   /**
296    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
297    * Beware that changing an allowance with this method brings the risk that someone may use both the old
298    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
299    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
300    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
301    * @param _spender The address which will spend the funds.
302    * @param _value The amount of tokens to be spent.
303    */
304   function approve(address _spender, uint256 _value) public returns (bool) {
305     allowed[msg.sender][_spender] = _value;
306     emit Approval(msg.sender, _spender, _value);
307     return true;
308   }
309 
310   /**
311    * @dev Function to check the amount of tokens that an owner allowed to a spender.
312    * @param _owner address The address which owns the funds.
313    * @param _spender address The address which will spend the funds.
314    * @return A uint256 specifying the amount of tokens still available for the spender.
315    */
316   function allowance(
317     address _owner,
318     address _spender
319    )
320     public
321     view
322     returns (uint256)
323   {
324     return allowed[_owner][_spender];
325   }
326 
327   /**
328    * @dev Increase the amount of tokens that an owner allowed to a spender.
329    * approve should be called when allowed[_spender] == 0. To increment
330    * allowed value is better to use this function to avoid 2 calls (and wait until
331    * the first transaction is mined)
332    * From MonolithDAO Token.sol
333    * @param _spender The address which will spend the funds.
334    * @param _addedValue The amount of tokens to increase the allowance by.
335    */
336   function increaseApproval(
337     address _spender,
338     uint256 _addedValue
339   )
340     public
341     returns (bool)
342   {
343     allowed[msg.sender][_spender] = (
344       allowed[msg.sender][_spender].add(_addedValue));
345     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346     return true;
347   }
348 
349   /**
350    * @dev Decrease the amount of tokens that an owner allowed to a spender.
351    * approve should be called when allowed[_spender] == 0. To decrement
352    * allowed value is better to use this function to avoid 2 calls (and wait until
353    * the first transaction is mined)
354    * From MonolithDAO Token.sol
355    * @param _spender The address which will spend the funds.
356    * @param _subtractedValue The amount of tokens to decrease the allowance by.
357    */
358   function decreaseApproval(
359     address _spender,
360     uint256 _subtractedValue
361   )
362     public
363     returns (bool)
364   {
365     uint256 oldValue = allowed[msg.sender][_spender];
366     if (_subtractedValue >= oldValue) {
367       allowed[msg.sender][_spender] = 0;
368     } else {
369       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
370     }
371     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
372     return true;
373   }
374 
375 }
376 
377 contract PausableToken is StandardToken, Pausable {
378 
379   function transfer(
380     address _to,
381     uint256 _value
382   )
383     public
384     whenNotPaused
385     returns (bool)
386   {
387     return super.transfer(_to, _value);
388   }
389 
390   function transferFrom(
391     address _from,
392     address _to,
393     uint256 _value
394   )
395     public
396     whenNotPaused
397     returns (bool)
398   {
399     return super.transferFrom(_from, _to, _value);
400   }
401 
402   function approve(
403     address _spender,
404     uint256 _value
405   )
406     public
407     whenNotPaused
408     returns (bool)
409   {
410     return super.approve(_spender, _value);
411   }
412 
413   function increaseApproval(
414     address _spender,
415     uint _addedValue
416   )
417     public
418     whenNotPaused
419     returns (bool success)
420   {
421     return super.increaseApproval(_spender, _addedValue);
422   }
423 
424   function decreaseApproval(
425     address _spender,
426     uint _subtractedValue
427   )
428     public
429     whenNotPaused
430     returns (bool success)
431   {
432     return super.decreaseApproval(_spender, _subtractedValue);
433   }
434 }
435 
436 contract AccessControl is Ownable, Pausable {
437 
438     /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles.
439     address payable public ceoAddress;
440     address payable public cfoAddress;
441     address payable public cooAddress;
442     address payable public cmoAddress;
443     address payable public BAEFeeAddress;
444     address payable public owner = msg.sender;
445 
446     /// @dev Access modifier for CEO-only functionality
447     modifier onlyCEO() {
448         require(
449             msg.sender == ceoAddress,
450             "Only our CEO address can execute this function");
451         _;
452     }
453 
454     /// @dev Access modifier for CFO-only functionality
455     modifier onlyCFO() {
456         require(
457             msg.sender == cfoAddress,
458             "Only our CFO can can ll this function");
459         _;
460     }
461 
462     /// @dev Access modifier for COO-only functionality
463     modifier onlyCOO() {
464         require(
465             msg.sender == cooAddress,
466             "Only our COO can can ll this function");
467         _;
468     }
469 
470     /// @dev Access modifier for Clevel functions
471     modifier onlyCLevelOrOwner() {
472         require(
473             msg.sender == cooAddress ||
474             msg.sender == ceoAddress ||
475             msg.sender == cfoAddress ||
476             msg.sender == owner,
477             "You need to be the owner or a Clevel @BAE to call this function"
478         );
479         _;
480     }
481     
482 
483     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
484     /// @param _newCEO The address of the new CEO
485     function setCEO(address payable _newCEO) external onlyCEO whenNotPaused {
486         require(_newCEO != address(0));
487         ceoAddress = _newCEO;
488     }
489 
490     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
491     /// @param _newCFO The address of the new CFO
492     function setCFO(address payable _newCFO) external onlyCLevelOrOwner whenNotPaused {
493         require(_newCFO != address(0));
494         cfoAddress = _newCFO;
495     }
496 
497     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
498     /// @param _newCOO The address of the new COO
499     function setCOO(address payable _newCOO) external onlyCLevelOrOwner whenNotPaused {
500         require(_newCOO != address(0));
501         cooAddress = _newCOO;
502     }
503      /// @dev Assigns a new address to act as the CMO. 
504     /// @param _newCMO The address of the new CMO
505     function setCMO(address payable _newCMO) external onlyCLevelOrOwner whenNotPaused {
506         require(_newCMO != address(0));
507         cmoAddress = _newCMO;
508     }
509 
510     function getBAEFeeAddress() external view onlyCLevelOrOwner returns (address) {
511         return BAEFeeAddress;
512     }
513 
514     function setBAEFeeAddress(address payable _newAddress) public onlyCLevelOrOwner {
515         BAEFeeAddress = _newAddress;
516     }
517 
518     // Only the CEO, COO, and CFO can execute this function:
519     function pause() public onlyCLevelOrOwner whenNotPaused {
520         paused = true;
521         emit Pause();
522     }
523 
524     function unpause() public onlyCLevelOrOwner whenPaused {
525         paused = false;
526         emit Unpause();
527     }
528 }
529 
530 contract Destructible is AccessControl {
531 
532     /**
533     * @dev Transfers the current balance to the owner and terminates the contract
534     *      onlyOwner needs to be changed to onlyBAE
535     */
536     function destroy() public onlyCLevelOrOwner whenPaused{
537         selfdestruct(owner);
538     }
539 
540     /**
541     * @dev Transfers the current balance to the address and terminates the contract.
542     */
543     function destroyAndSend(address payable _recipient) public onlyCLevelOrOwner whenPaused {
544         selfdestruct(_recipient);
545     }
546 }
547 
548 contract ArtShop is Destructible {
549     using SafeMath for uint256;
550 
551     /// @dev this fires everytime an artpiece is created
552     event NewArtpiece(uint pieceId, string  name, string artist);
553     /// @dev this is set up to track how many changes the url has been changed
554     event UrlChange(uint pieceId);
555 
556     /// @dev - both baeFeeLevel and royaltyFeeLevel are percentages and the combined should be
557     ///        kept below 95% on first sale or 99% on secondary sale :)
558     uint8 internal baeFeeLevel;
559     uint8 internal royaltyFeeLevel;
560     uint8 internal potFeeLevel = 5;
561 
562     /// @dev this is used to prevent constant movement of art   
563     uint32 public timeUntilAbleToTransfer = 1 hours;
564 
565     /// @dev all metadata relating to an artpiece
566     /// @dev this is done to prevent the error: Stacktrace too long as per 
567     /// @dev https://ethereum.stackexchange.com/questions/7325/stack-too-deep-try-removing-local-variables
568     struct ArtpieceMetaData {
569         uint8 remainingPrintings;
570         uint64 basePrice; ///@dev listing price
571         uint256 dateCreatedByTheArtist;
572         string notes;
573         bool isFirstSale;
574         bool physical;
575     }
576 
577     /// @dev all properties of an artpiece
578     struct Artpiece {
579         string name; /// @dev - should this change? I don't think so
580         string artist; ///@dev artist's name for now - might be good to be an id/hash
581         string thumbnailUrl;
582         string mainUrl;
583         string grade;
584         uint64 price; /// @dev current price
585         uint8 feeLevel; /// @dev this is the royalty fee
586         uint8 baeFeeLevel;
587         ArtpieceMetaData metadata;
588     }
589 
590     Artpiece[] artpieces;
591 
592     mapping (uint256 => address) public numArtInAddress;
593     mapping (address => uint256) public artCollection;
594     mapping (uint256 => address) public artpieceApproved;
595 
596     /// @dev contract-specific modifiers on fees
597     modifier onlyWithGloballySetFee() {
598         require(
599             baeFeeLevel > 0,
600             "Requires a fee level to be set up"
601         );
602         require(
603             royaltyFeeLevel > 0,
604             "Requires a an artist fee level to be set up"
605         );
606         _;
607     }
608 
609     /// @dev this is the gloabal fee setter
610     /// @dev setBAEFeeLevel should be 35 initially on first sale
611     function setBAEFeeLevel(uint8 _newFee) public onlyCLevelOrOwner {
612         baeFeeLevel = _newFee;
613     }
614 
615     function setRoyaltyFeeLevel(uint8 _newFee) public onlyCLevelOrOwner {
616         royaltyFeeLevel = _newFee;
617     }
618     
619     function _createArtpiece(
620         string memory _name,
621         string memory _artist,
622         string memory _thumbnailUrl,
623         string memory _mainUrl,
624         string memory _notes,
625         string memory _grade,
626         uint256 _dateCreatedByTheArtist,
627         uint64 _price,
628         uint64 _basePrice,
629         uint8 _remainingPrintings,
630         bool _physical
631         )  
632         internal
633         onlyWithGloballySetFee
634         whenNotPaused
635         {
636         
637         ArtpieceMetaData memory metd = ArtpieceMetaData(
638                 _remainingPrintings,
639                 _basePrice,
640                 _dateCreatedByTheArtist,
641                 _notes,
642                 true,
643                 _physical
644         ); 
645             
646         Artpiece memory newArtpiece = Artpiece(
647             _name,
648             _artist,
649             _thumbnailUrl,
650             _mainUrl,
651             _grade,
652             _price,
653             royaltyFeeLevel,
654             baeFeeLevel,
655             metd
656         );
657         uint id = artpieces.push(newArtpiece) - 1;
658 
659         numArtInAddress[id] = msg.sender;
660         artCollection[msg.sender] = artCollection[msg.sender].add(1);
661             
662         emit NewArtpiece(id, _name, _artist);
663     }
664 }
665 
666 contract Helpers is ArtShop {
667     
668         /// @dev modifiers for the ERC721-compliant functions
669     modifier onlyOwnerOf(uint _artpieceId) {
670         require(msg.sender == numArtInAddress[_artpieceId]);
671         _;
672     }
673     
674     /// @dev we use this so we can't delete artpieces once they are on auction
675     ///      so people have the feeling they really own the 
676     modifier onlyBeforeFirstSale(uint _tokenId) {
677         (,,,,bool isFirstSale,) = getArtpieceMeta(_tokenId);
678         require(isFirstSale == true);
679         _;
680     }
681 
682     event Printed(uint indexed _id, uint256 indexed _time);
683     
684     function getArtpieceData(uint _id) public view returns(string memory name, string memory artist, string memory thumbnailUrl, string memory grade, uint64 price) {
685         return (
686             artpieces[_id].name, 
687             artpieces[_id].artist, 
688             artpieces[_id].thumbnailUrl, 
689             artpieces[_id].grade,
690             artpieces[_id].price 
691         );
692     }
693     
694     function getArtpieceFeeLevels(uint _id) public view returns(uint8, uint8) {
695         return (
696             artpieces[_id].feeLevel,
697             artpieces[_id].baeFeeLevel
698         );
699     }
700     
701     function getArtpieceMeta(uint _id) public view returns(uint8, uint64, uint256, string memory, bool, bool) {
702         return (
703             artpieces[_id].metadata.remainingPrintings, 
704             artpieces[_id].metadata.basePrice, 
705             artpieces[_id].metadata.dateCreatedByTheArtist, 
706             artpieces[_id].metadata.notes, 
707             artpieces[_id].metadata.isFirstSale, 
708             artpieces[_id].metadata.physical
709         );
710     }
711     
712     function getMainUrl(uint _id) public view onlyOwnerOf(_id) returns(string memory) {
713         return artpieces[_id].mainUrl;
714     }
715 
716     function setArtpieceName(uint _id, string memory _name) public onlyCLevelOrOwner whenNotPaused {
717         artpieces[_id].name = _name;
718     }
719 
720     function setArtist(uint _id, string memory _artist) public onlyCLevelOrOwner whenNotPaused {
721         artpieces[_id].artist = _artist;
722     }
723 
724     function setThumbnailUrl(uint _id, string memory _newThumbnailUrl) public onlyCLevelOrOwner whenNotPaused {
725         artpieces[_id].thumbnailUrl = _newThumbnailUrl;
726     }
727 
728     // this used to be internal
729     function setMainUrl(uint _id, string memory _newUrl) public onlyCLevelOrOwner whenNotPaused {
730         artpieces[_id].mainUrl = _newUrl;
731         emit UrlChange(_id);
732     }
733 
734     function setGrade(uint _id, string memory _grade) public onlyCLevelOrOwner whenNotPaused returns (bool success) {
735         artpieces[_id].grade = _grade;
736         return true;
737     }
738 
739     function setPrice(uint _id, uint64 _price) public onlyCLevelOrOwner whenNotPaused {
740         artpieces[_id].price = _price;
741     }
742 
743     function setArtpieceBAEFee(uint _id, uint8 _newFee) public onlyCLevelOrOwner whenNotPaused {
744         artpieces[_id].baeFeeLevel = _newFee;
745     }
746 
747     function setArtpieceRoyaltyFeeLevel(uint _id, uint8 _newFee) public onlyCLevelOrOwner whenNotPaused {
748         artpieces[_id].feeLevel = _newFee;
749     }
750 
751     function setRemainingPrintings(uint _id, uint8 _remainingPrintings) internal onlyCLevelOrOwner whenNotPaused {
752         artpieces[_id].metadata.remainingPrintings = _remainingPrintings;
753     }
754     
755     function setBasePrice(uint _id, uint64 _basePrice) public onlyCLevelOrOwner {
756         artpieces[_id].metadata.basePrice = _basePrice;
757     }
758 
759     function setDateCreateByArtist(uint _id, uint256 _dateCreatedByTheArtist) public onlyCLevelOrOwner {
760         artpieces[_id].metadata.dateCreatedByTheArtist = _dateCreatedByTheArtist;
761     }
762 
763     function setNotes(uint _id, string memory _notes) public onlyCLevelOrOwner {
764         artpieces[_id].metadata.notes = _notes;
765     }
766 
767     function setIsPhysical(uint _id, bool _physical) public onlyCLevelOrOwner {
768         artpieces[_id].metadata.physical = _physical;
769     }
770     
771     function getArtpiecesByOwner(address _owner) external view returns(uint[] memory) {
772         uint[] memory result = new uint[](artCollection[_owner]);
773         uint counter = 0;
774 
775         for ( uint i = 0; i < artpieces.length; i++ ) {
776             if (numArtInAddress[i] == _owner) {
777                 result[counter] = i;
778                 counter = counter.add(1);
779             }
780         }
781 
782         return result;
783     }
784 }
785 
786 contract BAEToken is PausableToken, AccessControl  {
787     using SafeMath for uint256;
788     using SafeERC20 for ERC20;
789 
790     event Mint(address indexed to, uint256 amount);
791     event MintFinished();
792     event Burn(address indexed burner, uint256 value);
793    
794     string public constant name = "BAEToken";
795     string public constant symbol = "BAE";
796     uint public constant decimals = 6;
797     uint public currentAmount = 0; // rate is £1 == 10 BAE based on 100 000 000 = 10,000,000
798     uint public totalAllocated = 0;
799     bool public mintingFinished = false;
800     uint256 public currentIndex = 0;
801 
802     /// @dev - holder adresses by index
803     mapping(uint => address) public holderAddresses;
804 
805     /// @dev total supply assigned to msg.sender directly
806     constructor() public {
807         totalSupply_ = 0;
808     }
809 
810     modifier validDestination(address _to)
811     {
812         require(_to != address(0x0));
813         require(_to != address(this)); 
814         _;
815     }
816 
817     modifier canMint() {
818         require(
819             !mintingFinished,
820             "Still minting."
821         );
822         _;
823     }
824 
825     modifier hasMintPermission() {
826         require(
827             msg.sender == owner,
828             "Message sender is not owner."
829         );
830         _;
831     }
832 
833     modifier onlyWhenNotMinting() {
834         require(
835             mintingFinished == false,
836             "Minting needs to be stopped to execute this function"
837         );
838         _;
839     }
840 
841     /** 
842      * @dev getter for name
843      */
844     function getName() public pure returns (string memory) {
845         return name;
846     }
847 
848     /** 
849      * @dev getter for token symbol
850      */
851     function getSymbol() public pure returns (string memory) {
852         return symbol;
853     }
854 
855     /** 
856      * @dev getter for totalSupply_
857      */
858     function getTotalSupply() public view returns (uint) {
859         return totalSupply_;
860     }
861 
862     /** 
863      * @dev getter for user amount
864      */
865     function getBalance() public view returns (uint) {
866         return balances[msg.sender];
867     }
868 
869     /// @dev this is a superuser function to check each wallet amount
870     function getUserBalance(address _userAddress) public view onlyCLevelOrOwner returns(uint) {
871         return balances[_userAddress];
872     }
873     
874     /** 
875      * @dev private 
876      */
877     function burn(address _who, uint256 _value) public onlyCEO whenNotPaused {
878         require(
879             _value <= balances[_who],
880             "Value is smaller than the value the account in balances has"
881         );
882         // no need to require value <= totalSupply, since that would imply the
883         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
884 
885         // BAEholders[_who] = BAEholders[_who].sub(_value);
886         totalSupply_ = totalSupply_.sub(_value);
887         totalAllocated = totalAllocated.sub(_value);
888         balances[_who] = balances[_who].sub(_value);
889         emit Burn(_who, _value);
890         emit Transfer(_who, address(0), _value);
891     }
892 
893     /**
894     * @dev Function to mint tokens
895     * @param _to The address that will receive the minted tokens.
896     * @param _amount The amount of tokens to mint.
897     * @return A boolean that indicates if the operation was successful.
898     */
899     function mint(
900         address _to,
901         uint256 _amount
902     )
903     public
904     canMint
905     onlyCLevelOrOwner
906     whenNotPaused
907     returns (bool) {
908         totalSupply_ = totalSupply_.add(_amount);
909         totalAllocated = totalAllocated.add(_amount);
910         balances[_to] = balances[_to].add(_amount);
911         emit Mint(_to, _amount);
912         emit Transfer(address(0), _to, _amount);
913         return true;
914     }
915 
916     /**
917     * @dev Function to stop minting new tokens.
918     * @return True if the operation was successful.
919     */
920     function finishMinting() 
921     public 
922     onlyCEO
923     canMint
924     whenNotPaused
925     returns (bool) {
926         mintingFinished = true;
927         emit MintFinished();
928         return true;
929     }
930 
931 
932     /** ------------------------------------------------------------------------
933      *  @dev - Owner can transfer out ERC20 tokens
934      *  ------------------------------------------------------------------------ 
935     // */    
936 
937     /// @dev - we `override` the ability of calling those methods to be allowed only of the owner
938     ///        or the C level as the tokens shouldn't have any money properties.
939     function transfer(address _to, uint256 _value) public onlyCLevelOrOwner returns (bool) {
940         /// @dev call the super function transfer as is
941         super.transfer(_to, _value);
942         
943         /// @dev and add the required
944         totalAllocated = totalAllocated.add(_value);
945         balances[msg.sender] = balances[msg.sender].sub(_value);
946         balances[_to] = balances[_to].add(_value);
947         holderAddresses[currentIndex] = _to;
948         currentIndex = currentIndex.add(1);
949         return true;
950     }
951 
952     function transferFrom(
953         address _from,
954         address _to,
955         uint256 _value
956     )
957     public
958     onlyCLevelOrOwner
959     returns (bool) {
960         super.transferFrom(_from, _to, _value);
961         totalAllocated = totalAllocated.add(_value);
962         balances[_from] = balances[_from].sub(_value);
963         balances[_to] = balances[_to].add(_value);
964         holderAddresses[currentIndex] = _to;
965         currentIndex = currentIndex.add(1);
966         return true;
967     }
968 
969 
970     function approve(address _spender, uint256 _value) public onlyCLevelOrOwner returns (bool) {
971         super.approve(_spender, _value);
972     }
973     
974 
975 }
976 
977 contract Payments is BAEToken {
978     
979     event PotPayout(address indexed _to, uint256 indexed value);
980 
981     BAECore public baeInstance;
982     
983     constructor() public {
984         ceoAddress = msg.sender;
985     }
986 
987     function setBAECoreAddress(address payable _address) public onlyCEO whenPaused {
988         BAECore baeCandidate = BAECore(_address);
989         baeInstance = baeCandidate;
990     }
991     
992     /// @dev - Update balances - % of ownership
993     function addToBAEHolders(address _to) public onlyCLevelOrOwner whenNotPaused {
994         mint(_to, currentAmount);
995     }
996     
997     function subToBAEHolders(address _from, address _to, uint _amount) public onlyCLevelOrOwner whenNotPaused {
998         transferFrom(_from, _to, _amount);
999     }
1000     
1001     function setFinalPriceInPounds(uint _finalPrice) public onlyCLevelOrOwner whenNotPaused {
1002         currentAmount = _finalPrice.mul(10000000);
1003     }
1004     
1005     function withdraw() public onlyCFO {
1006         cfoAddress.transfer(address(this).balance);
1007     }
1008     
1009     function() external payable { }
1010 }
1011 
1012 interface IERC165 {
1013 
1014   /**
1015   * @notice Query if a contract implements an interface
1016   * @param interfaceId The interface identifier, as specified in ERC-165
1017   * @dev Interface identification is specified in ERC-165. This function
1018   * uses less than 30,000 gas.
1019   */
1020   function supportsInterface(bytes4 interfaceId)
1021     external
1022     view
1023     returns (bool);
1024 }
1025 
1026 contract IERC721 is IERC165 {
1027 
1028   event Transfer(
1029     address indexed from,
1030     address indexed to,
1031     uint256 indexed tokenId
1032   );
1033   event Approval(
1034     address indexed owner,
1035     address indexed approved,
1036     uint256 indexed tokenId
1037   );
1038   event ApprovalForAll(
1039     address indexed owner,
1040     address indexed operator,
1041     bool approved
1042   );
1043 
1044   function balanceOf(address owner) public view returns (uint256 balance);
1045   function ownerOf(uint256 tokenId) public view returns (address owner);
1046 
1047   function approve(address to, uint256 tokenId) public;
1048   function getApproved(uint256 tokenId)
1049     public view returns (address operator);
1050 
1051   function setApprovalForAll(address operator, bool _approved) public;
1052   function isApprovedForAll(address owner, address operator)
1053     public view returns (bool);
1054 
1055   function transferFrom(address from, address to, uint256 tokenId) public;
1056   function safeTransferFrom(address from, address to, uint256 tokenId)
1057     public;
1058 
1059   function safeTransferFrom(
1060     address from,
1061     address to,
1062     uint256 tokenId,
1063     bytes memory data
1064   )
1065     public;
1066 }
1067 
1068 contract IERC721Metadata is IERC721 {
1069   function name() external view returns (string memory);
1070   function symbol() external view returns (string memory);
1071   function tokenURI(uint256 tokenId) public view returns (string memory);
1072 }
1073 
1074 contract IERC721Enumerable is IERC721 {
1075   function totalSupply() public view returns (uint256);
1076   function tokenOfOwnerByIndex(
1077     address owner,
1078     uint256 index
1079   )
1080     public
1081     view
1082     returns (uint256 tokenId);
1083 
1084   function tokenByIndex(uint256 index) public view returns (uint256);
1085 }
1086 
1087 contract IERC721Receiver {
1088   /**
1089   * @notice Handle the receipt of an NFT
1090   * @dev The ERC721 smart contract calls this function on the recipient
1091   * after a `safeTransfer`. This function MUST return the function selector,
1092   * otherwise the caller will revert the transaction. The selector to be
1093   * returned can be obtained as `this.onERC721Received.selector`. This
1094   * function MAY throw to revert and reject the transfer.
1095   * Note: the ERC721 contract address is always the message sender.
1096   * @param operator The address which called `safeTransferFrom` function
1097   * @param from The address which previously owned the token
1098   * @param tokenId The NFT identifier which is being transferred
1099   * @param data Additional data with no specified format
1100   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1101   */
1102   function onERC721Received(
1103     address operator,
1104     address from,
1105     uint256 tokenId,
1106     bytes memory data
1107   )
1108     public
1109     returns(bytes4);
1110 }
1111 
1112 contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {
1113 }
1114 
1115 contract ERC165 is IERC165 {
1116 
1117   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
1118   /**
1119   * 0x01ffc9a7 ===
1120   *   bytes4(keccak256('supportsInterface(bytes4)'))
1121   */
1122 
1123   /**
1124   * @dev a mapping of interface id to whether or not it's supported
1125   */
1126   mapping(bytes4 => bool) internal _supportedInterfaces;
1127 
1128   /**
1129   * @dev A contract implementing SupportsInterfaceWithLookup
1130   * implement ERC165 itself
1131   */
1132   constructor()
1133     public
1134   {
1135     _registerInterface(_InterfaceId_ERC165);
1136   }
1137 
1138   /**
1139   * @dev implement supportsInterface(bytes4) using a lookup table
1140   */
1141   function supportsInterface(bytes4 interfaceId)
1142     external
1143     view
1144     returns (bool)
1145   {
1146     return _supportedInterfaces[interfaceId];
1147   }
1148 
1149   /**
1150   * @dev private method for registering an interface
1151   */
1152   function _registerInterface(bytes4 interfaceId)
1153     internal
1154   {
1155     require(interfaceId != 0xffffffff);
1156     _supportedInterfaces[interfaceId] = true;
1157   }
1158 }
1159 
1160 contract ERC721 is ERC165, IERC721 {
1161   using SafeMath for uint256;
1162   using Address for address;
1163 
1164   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1165   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1166   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1167 
1168   // Mapping from token ID to owner
1169   mapping (uint256 => address) private _tokenOwner;
1170 
1171   // Mapping from token ID to approved address
1172   mapping (uint256 => address) private _tokenApprovals;
1173 
1174   // Mapping from owner to number of owned token
1175   mapping (address => uint256) private _ownedTokensCount;
1176 
1177   // Mapping from owner to operator approvals
1178   mapping (address => mapping (address => bool)) private _operatorApprovals;
1179 
1180   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
1181   /*
1182   * 0x80ac58cd ===
1183   *   bytes4(keccak256('balanceOf(address)')) ^
1184   *   bytes4(keccak256('ownerOf(uint256)')) ^
1185   *   bytes4(keccak256('approve(address,uint256)')) ^
1186   *   bytes4(keccak256('getApproved(uint256)')) ^
1187   *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
1188   *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
1189   *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1190   *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
1191   *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1192   */
1193 
1194   constructor()
1195     public
1196   {
1197     // register the supported interfaces to conform to ERC721 via ERC165
1198     _registerInterface(_InterfaceId_ERC721);
1199   }
1200 
1201   /**
1202   * @dev Gets the balance of the specified address
1203   * @param owner address to query the balance of
1204   * @return uint256 representing the amount owned by the passed address
1205   */
1206   function balanceOf(address owner) public view returns (uint256) {
1207     require(owner != address(0));
1208     return _ownedTokensCount[owner];
1209   }
1210 
1211   /**
1212   * @dev Gets the owner of the specified token ID
1213   * @param tokenId uint256 ID of the token to query the owner of
1214   * @return owner address currently marked as the owner of the given token ID
1215   */
1216   function ownerOf(uint256 tokenId) public view returns (address) {
1217     address owner = _tokenOwner[tokenId];
1218     require(owner != address(0));
1219     return owner;
1220   }
1221 
1222   /**
1223   * @dev Approves another address to transfer the given token ID
1224   * The zero address indicates there is no approved address.
1225   * There can only be one approved address per token at a given time.
1226   * Can only be called by the token owner or an approved operator.
1227   * @param to address to be approved for the given token ID
1228   * @param tokenId uint256 ID of the token to be approved
1229   */
1230   function approve(address to, uint256 tokenId) public {
1231     address owner = ownerOf(tokenId);
1232     require(to != owner);
1233     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1234 
1235     _tokenApprovals[tokenId] = to;
1236     emit Approval(owner, to, tokenId);
1237   }
1238 
1239   /**
1240   * @dev Gets the approved address for a token ID, or zero if no address set
1241   * Reverts if the token ID does not exist.
1242   * @param tokenId uint256 ID of the token to query the approval of
1243   * @return address currently approved for the given token ID
1244   */
1245   function getApproved(uint256 tokenId) public view returns (address) {
1246     require(_exists(tokenId));
1247     return _tokenApprovals[tokenId];
1248   }
1249 
1250   /**
1251   * @dev Sets or unsets the approval of a given operator
1252   * An operator is allowed to transfer all tokens of the sender on their behalf
1253   * @param to operator address to set the approval
1254   * @param approved representing the status of the approval to be set
1255   */
1256   function setApprovalForAll(address to, bool approved) public {
1257     require(to != msg.sender);
1258     _operatorApprovals[msg.sender][to] = approved;
1259     emit ApprovalForAll(msg.sender, to, approved);
1260   }
1261 
1262   /**
1263   * @dev Tells whether an operator is approved by a given owner
1264   * @param owner owner address which you want to query the approval of
1265   * @param operator operator address which you want to query the approval of
1266   * @return bool whether the given operator is approved by the given owner
1267   */
1268   function isApprovedForAll(
1269     address owner,
1270     address operator
1271   )
1272     public
1273     view
1274     returns (bool)
1275   {
1276     return _operatorApprovals[owner][operator];
1277   }
1278 
1279   /**
1280   * @dev Transfers the ownership of a given token ID to another address
1281   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1282   * Requires the msg sender to be the owner, approved, or operator
1283   * @param from current owner of the token
1284   * @param to address to receive the ownership of the given token ID
1285   * @param tokenId uint256 ID of the token to be transferred
1286   */
1287   function transferFrom(
1288     address from,
1289     address to,
1290     uint256 tokenId
1291   )
1292     public
1293   {
1294     require(_isApprovedOrOwner(msg.sender, tokenId));
1295     require(to != address(0));
1296 
1297     _clearApproval(from, tokenId);
1298     _removeTokenFrom(from, tokenId);
1299     _addTokenTo(to, tokenId);
1300 
1301     emit Transfer(from, to, tokenId);
1302   }
1303 
1304 
1305   /**
1306   * @dev Safely transfers the ownership of a given token ID to another address
1307   * If the target address is a contract, it must implement `onERC721Received`,
1308   * which is called upon a safe transfer, and return the magic value
1309   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1310   * the transfer is reverted.
1311   *
1312   * Requires the msg sender to be the owner, approved, or operator
1313   * @param from current owner of the token
1314   * @param to address to receive the ownership of the given token ID
1315   * @param tokenId uint256 ID of the token to be transferred
1316   */
1317   function safeTransferFrom(
1318     address from,
1319     address to,
1320     uint256 tokenId
1321   )
1322     public
1323   {
1324     // solium-disable-next-line arg-overflow
1325     safeTransferFrom(from, to, tokenId, "");
1326   }
1327 
1328   /**
1329   * @dev Safely transfers the ownership of a given token ID to another address
1330   * If the target address is a contract, it must implement `onERC721Received`,
1331   * which is called upon a safe transfer, and return the magic value
1332   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1333   * the transfer is reverted.
1334   * Requires the msg sender to be the owner, approved, or operator
1335   * @param from current owner of the token
1336   * @param to address to receive the ownership of the given token ID
1337   * @param tokenId uint256 ID of the token to be transferred
1338   * @param _data bytes data to send along with a safe transfer check
1339   */
1340   function safeTransferFrom(
1341     address from,
1342     address to,
1343     uint256 tokenId,
1344     bytes memory _data
1345   )
1346     public
1347   {
1348     transferFrom(from, to, tokenId);
1349     // solium-disable-next-line arg-overflow
1350     require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
1351   }
1352 
1353   /**
1354   * @dev Returns whether the specified token exists
1355   * @param tokenId uint256 ID of the token to query the existence of
1356   * @return whether the token exists
1357   */
1358   function _exists(uint256 tokenId) internal view returns (bool) {
1359     address owner = _tokenOwner[tokenId];
1360     return owner != address(0);
1361   }
1362 
1363   /**
1364   * @dev Returns whether the given spender can transfer a given token ID
1365   * @param spender address of the spender to query
1366   * @param tokenId uint256 ID of the token to be transferred
1367   * @return bool whether the msg.sender is approved for the given token ID,
1368   *  is an operator of the owner, or is the owner of the token
1369   */
1370   function _isApprovedOrOwner(
1371     address spender,
1372     uint256 tokenId
1373   )
1374     internal
1375     view
1376     returns (bool)
1377   {
1378     address owner = ownerOf(tokenId);
1379     // Disable solium check because of
1380     // https://github.com/duaraghav8/Solium/issues/175
1381     // solium-disable-next-line operator-whitespace
1382     return (
1383       spender == owner ||
1384       getApproved(tokenId) == spender ||
1385       isApprovedForAll(owner, spender)
1386     );
1387   }
1388 
1389   /**
1390   * @dev Internal function to mint a new token
1391   * Reverts if the given token ID already exists
1392   * @param to The address that will own the minted token
1393   * @param tokenId uint256 ID of the token to be minted by the msg.sender
1394   */
1395   function _mint(address to, uint256 tokenId) internal {
1396     require(to != address(0));
1397     _addTokenTo(to, tokenId);
1398     emit Transfer(address(0), to, tokenId);
1399   }
1400 
1401   /**
1402   * @dev Internal function to burn a specific token
1403   * Reverts if the token does not exist
1404   * @param tokenId uint256 ID of the token being burned by the msg.sender
1405   */
1406   function _burn(address owner, uint256 tokenId) internal {
1407     _clearApproval(owner, tokenId);
1408     _removeTokenFrom(owner, tokenId);
1409     emit Transfer(owner, address(0), tokenId);
1410   }
1411 
1412   /**
1413   * @dev Internal function to clear current approval of a given token ID
1414   * Reverts if the given address is not indeed the owner of the token
1415   * @param owner owner of the token
1416   * @param tokenId uint256 ID of the token to be transferred
1417   */
1418   function _clearApproval(address owner, uint256 tokenId) internal {
1419     require(ownerOf(tokenId) == owner);
1420     if (_tokenApprovals[tokenId] != address(0)) {
1421       _tokenApprovals[tokenId] = address(0);
1422     }
1423   }
1424 
1425   /**
1426   * @dev Internal function to add a token ID to the list of a given address
1427   * @param to address representing the new owner of the given token ID
1428   * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1429   */
1430   function _addTokenTo(address to, uint256 tokenId) internal {
1431     require(_tokenOwner[tokenId] == address(0));
1432     _tokenOwner[tokenId] = to;
1433     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
1434   }
1435 
1436   /**
1437   * @dev Internal function to remove a token ID from the list of a given address
1438   * @param from address representing the previous owner of the given token ID
1439   * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1440   */
1441   function _removeTokenFrom(address from, uint256 tokenId) internal {
1442     require(ownerOf(tokenId) == from);
1443     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
1444     _tokenOwner[tokenId] = address(0);
1445   }
1446 
1447   /**
1448   * @dev Internal function to invoke `onERC721Received` on a target address
1449   * The call is not executed if the target address is not a contract
1450   * @param from address representing the previous owner of the given token ID
1451   * @param to target address that will receive the tokens
1452   * @param tokenId uint256 ID of the token to be transferred
1453   * @param _data bytes optional data to send along with the call
1454   * @return whether the call correctly returned the expected magic value
1455   */
1456   function _checkAndCallSafeTransfer(
1457     address from,
1458     address to,
1459     uint256 tokenId,
1460     bytes memory _data
1461   )
1462     internal
1463     returns (bool)
1464   {
1465     if (!to.isContract()) {
1466       return true;
1467     }
1468     bytes4 retval = IERC721Receiver(to).onERC721Received(
1469       msg.sender, from, tokenId, _data);
1470     return (retval == _ERC721_RECEIVED);
1471   }
1472 }
1473 
1474 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
1475   // Token name
1476   string internal _name;
1477 
1478   // Token symbol
1479   string internal _symbol;
1480 
1481   // Optional mapping for token URIs
1482   mapping(uint256 => string) private _tokenURIs;
1483 
1484   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
1485   /**
1486   * 0x5b5e139f ===
1487   *   bytes4(keccak256('name()')) ^
1488   *   bytes4(keccak256('symbol()')) ^
1489   *   bytes4(keccak256('tokenURI(uint256)'))
1490   */
1491 
1492   /**
1493   * @dev Constructor function
1494   */
1495   constructor(string memory name, string memory symbol) public {
1496     _name = name;
1497     _symbol = symbol;
1498 
1499     // register the supported interfaces to conform to ERC721 via ERC165
1500     _registerInterface(InterfaceId_ERC721Metadata);
1501   }
1502 
1503   /**
1504   * @dev Gets the token name
1505   * @return string representing the token name
1506   */
1507   function name() external view returns (string memory) {
1508     return _name;
1509   }
1510 
1511   /**
1512   * @dev Gets the token symbol
1513   * @return string representing the token symbol
1514   */
1515   function symbol() external view returns (string memory) {
1516     return _symbol;
1517   }
1518 
1519   /**
1520   * @dev Returns an URI for a given token ID
1521   * Throws if the token ID does not exist. May return an empty string.
1522   * @param tokenId uint256 ID of the token to query
1523   */
1524   function tokenURI(uint256 tokenId) public view returns (string memory) {
1525     require(_exists(tokenId));
1526     return _tokenURIs[tokenId];
1527   }
1528 
1529   /**
1530   * @dev Internal function to set the token URI for a given token
1531   * Reverts if the token ID does not exist
1532   * @param tokenId uint256 ID of the token to set its URI
1533   * @param uri string URI to assign
1534   */
1535   function _setTokenURI(uint256 tokenId, string memory uri) internal {
1536     require(_exists(tokenId));
1537     _tokenURIs[tokenId] = uri;
1538   }
1539 
1540   /**
1541   * @dev Internal function to burn a specific token
1542   * Reverts if the token does not exist
1543   * @param owner owner of the token to burn
1544   * @param tokenId uint256 ID of the token being burned by the msg.sender
1545   */
1546   function _burn(address owner, uint256 tokenId) internal {
1547     super._burn(owner, tokenId);
1548 
1549     // Clear metadata (if any)
1550     if (bytes(_tokenURIs[tokenId]).length != 0) {
1551       delete _tokenURIs[tokenId];
1552     }
1553   }
1554 }
1555 
1556 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
1557   // Mapping from owner to list of owned token IDs
1558   mapping(address => uint256[]) private _ownedTokens;
1559 
1560   // Mapping from token ID to index of the owner tokens list
1561   mapping(uint256 => uint256) private _ownedTokensIndex;
1562 
1563   // Array with all token ids, used for enumeration
1564   uint256[] private _allTokens;
1565 
1566   // Mapping from token id to position in the allTokens array
1567   mapping(uint256 => uint256) private _allTokensIndex;
1568 
1569   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
1570   /**
1571   * 0x780e9d63 ===
1572   *   bytes4(keccak256('totalSupply()')) ^
1573   *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
1574   *   bytes4(keccak256('tokenByIndex(uint256)'))
1575   */
1576 
1577   /**
1578   * @dev Constructor function
1579   */
1580   constructor() public {
1581     // register the supported interface to conform to ERC721 via ERC165
1582     _registerInterface(_InterfaceId_ERC721Enumerable);
1583   }
1584 
1585   /**
1586   * @dev Gets the token ID at a given index of the tokens list of the requested owner
1587   * @param owner address owning the tokens list to be accessed
1588   * @param index uint256 representing the index to be accessed of the requested tokens list
1589   * @return uint256 token ID at the given index of the tokens list owned by the requested address
1590   */
1591   function tokenOfOwnerByIndex(
1592     address owner,
1593     uint256 index
1594   )
1595     public
1596     view
1597     returns (uint256)
1598   {
1599     require(index < balanceOf(owner));
1600     return _ownedTokens[owner][index];
1601   }
1602 
1603   /**
1604   * @dev Gets the total amount of tokens stored by the contract
1605   * @return uint256 representing the total amount of tokens
1606   */
1607   function totalSupply() public view returns (uint256) {
1608     return _allTokens.length;
1609   }
1610 
1611   /**
1612   * @dev Gets the token ID at a given index of all the tokens in this contract
1613   * Reverts if the index is greater or equal to the total number of tokens
1614   * @param index uint256 representing the index to be accessed of the tokens list
1615   * @return uint256 token ID at the given index of the tokens list
1616   */
1617   function tokenByIndex(uint256 index) public view returns (uint256) {
1618     require(index < totalSupply());
1619     return _allTokens[index];
1620   }
1621 
1622   /**
1623   * @dev Internal function to add a token ID to the list of a given address
1624   * @param to address representing the new owner of the given token ID
1625   * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1626   */
1627   function _addTokenTo(address to, uint256 tokenId) internal {
1628     super._addTokenTo(to, tokenId);
1629     uint256 length = _ownedTokens[to].length;
1630     _ownedTokens[to].push(tokenId);
1631     _ownedTokensIndex[tokenId] = length;
1632   }
1633 
1634   /**
1635   * @dev Internal function to remove a token ID from the list of a given address
1636   * @param from address representing the previous owner of the given token ID
1637   * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1638   */
1639   function _removeTokenFrom(address from, uint256 tokenId) internal {
1640     super._removeTokenFrom(from, tokenId);
1641 
1642     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1643     // then delete the last slot.
1644     uint256 tokenIndex = _ownedTokensIndex[tokenId];
1645     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1646     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
1647 
1648     _ownedTokens[from][tokenIndex] = lastToken;
1649     // This also deletes the contents at the last position of the array
1650     _ownedTokens[from].length--;
1651 
1652     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1653     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
1654     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1655 
1656     _ownedTokensIndex[tokenId] = 0;
1657     _ownedTokensIndex[lastToken] = tokenIndex;
1658   }
1659 
1660   /**
1661   * @dev Internal function to mint a new token
1662   * Reverts if the given token ID already exists
1663   * @param to address the beneficiary that will own the minted token
1664   * @param tokenId uint256 ID of the token to be minted by the msg.sender
1665   */
1666   function _mint(address to, uint256 tokenId) internal {
1667     super._mint(to, tokenId);
1668 
1669     _allTokensIndex[tokenId] = _allTokens.length;
1670     _allTokens.push(tokenId);
1671   }
1672 
1673   /**
1674   * @dev Internal function to burn a specific token
1675   * Reverts if the token does not exist
1676   * @param owner owner of the token to burn
1677   * @param tokenId uint256 ID of the token being burned by the msg.sender
1678   */
1679   function _burn(address owner, uint256 tokenId) internal {
1680     super._burn(owner, tokenId);
1681 
1682     // Reorg all tokens array
1683     uint256 tokenIndex = _allTokensIndex[tokenId];
1684     uint256 lastTokenIndex = _allTokens.length.sub(1);
1685     uint256 lastToken = _allTokens[lastTokenIndex];
1686 
1687     _allTokens[tokenIndex] = lastToken;
1688     _allTokens[lastTokenIndex] = 0;
1689 
1690     _allTokens.length--;
1691     _allTokensIndex[tokenId] = 0;
1692     _allTokensIndex[lastToken] = tokenIndex;
1693   }
1694 }
1695 
1696 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1697     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1698         // solhint-disable-previous-line no-empty-blocks
1699     }
1700 }
1701 
1702 contract BAE is ERC721Full, Helpers {
1703     using SafeMath for uint256;
1704 
1705     /// @dev - extra events on the ERC721 contract
1706     event Sold(uint indexed _tokenId, address _from, address _to, uint indexed _price);
1707     event Deleted(uint indexed _tokenId, address _from);
1708     event PaymentsContractChange(address _prevAddress, address _futureAddress);
1709     event AuctionContractChange(address _prevAddress, address _futureAddress);
1710 
1711     Payments public tokenInterface;
1712     mapping (uint => address) artTransApprovals;
1713 
1714    constructor() ERC721Full("BlockchainArtExchange", "BAE") public {}
1715     
1716     /// @dev functions affecting ERC20 tokens
1717     function setPaymentAddress(address payable _newAddress) public onlyCEO whenPaused {
1718         Payments tokenInterfaceCandidate = Payments(_newAddress);
1719         tokenInterface = tokenInterfaceCandidate;
1720     }
1721 
1722   function createArtpiece(
1723         string memory _name,
1724         string memory _artist,
1725         string memory _thumbnailUrl,
1726         string memory _mainUrl,
1727         string memory _notes,
1728         string memory _grade,
1729         uint256 _dateCreatedByTheArtist,
1730         uint64 _price,
1731         uint64 _basePrice,
1732         uint8 _remainingPrintings,
1733         bool _physical
1734     ) 
1735       public 
1736     {
1737         super._createArtpiece(_name, _artist, _thumbnailUrl, _mainUrl, _notes, _grade, _dateCreatedByTheArtist, _price, _basePrice, _remainingPrintings, _physical);
1738         
1739         _mint(msg.sender, artpieces.length - 1);
1740     }
1741   
1742     function calculateFees(uint _tokenId) public payable whenNotPaused returns (uint baeFee, uint royaltyFee, uint potFee) {
1743         /// @dev check this will not bring problems in the future or should we be using SafeMath library.
1744         uint baeFeeAmount = (uint(artpieces[_tokenId].baeFeeLevel) * msg.value) / 100;
1745         uint artistFeeAmount = (uint(artpieces[_tokenId].feeLevel) * msg.value) / 100;
1746 
1747         /// @dev any extra money will be added to the pot
1748         uint potFeeAmount = msg.value - (baeFeeAmount + artistFeeAmount);
1749         return (baeFeeAmount, artistFeeAmount, potFeeAmount);
1750     }
1751 
1752     /// @dev - this should be getting the royalty fee so we get the remaining as what is the bae fee
1753     function payFees(uint256 _baeFee, uint256 _royaltyFee, uint256 _potFee, address payable _seller) public payable whenNotPaused {
1754         uint totalToPay = _baeFee + _royaltyFee + _potFee;
1755         require(
1756             msg.value >= totalToPay,
1757             "Value must be equal or greater than the cost of the fees"
1758         );
1759 
1760         BAEFeeAddress.transfer(msg.value.sub(_baeFee));
1761         _seller.transfer(msg.value.sub(_royaltyFee));
1762 
1763         // we send the value left of the message to the POT contract
1764         address(tokenInterface).transfer(msg.value);
1765     }
1766     
1767     /// @dev set post-purchase data
1768     function _postPurchase(address _from, address _to, uint256 _tokenId) internal {
1769         artCollection[_to] = artCollection[_to].add(1);
1770         artCollection[_from] = artCollection[_from].sub(1);
1771         numArtInAddress[_tokenId] = _to;
1772 
1773         if (artpieces[_tokenId].metadata.isFirstSale) {
1774             artpieces[_tokenId].feeLevel = uint8(96);
1775             artpieces[_tokenId].baeFeeLevel = uint8(3);
1776             /// potFeeLevel is calculated from adding up (baeFeeLevel + royaltyFee) - 100
1777         }
1778         
1779         /// @dev we set this as not being the first sale anymore
1780         artpieces[_tokenId].metadata.isFirstSale = false;
1781 
1782         emit Sold(_tokenId, _from, _to, artpieces[_tokenId].price);
1783     }
1784     
1785     
1786     /// @dev this method is not part of erc-721 - not yet tested
1787     function deleteArtpiece(uint256 _tokenId) public onlyCLevelOrOwner whenNotPaused onlyBeforeFirstSale(_tokenId) returns (bool deleted) {
1788         address _from = numArtInAddress[_tokenId];
1789         delete numArtInAddress[_tokenId];
1790         artCollection[_from] = artCollection[_from].sub(1);
1791         _burn(_from, _tokenId);
1792         delete artpieces[_tokenId];
1793         emit Deleted(_tokenId, _from);
1794         return true;
1795     }
1796 
1797     /// @dev - we override this so only the CEO can call it.
1798     function pause() public onlyCEO whenNotPaused {
1799         super.pause();
1800     }
1801 }
1802 
1803 contract PerishableSimpleAuction is Destructible {
1804     using SafeMath for uint256;
1805 
1806     event AuctionCreated(uint id, address seller);
1807     event AuctionWon(uint tokenId, address _who);
1808     event SellerPaid(bool success, uint amount);
1809     
1810     BAECore public baeInstance;
1811     bool private currentAuction;
1812 
1813     struct Auction {
1814         uint256 tokenId;
1815         uint256 startingPrice;
1816         uint256 finalPrice;
1817         address payable seller;
1818         uint8 paid;
1819     }
1820 
1821     // When someone wins add it to this mapping 
1822     /// @dev address => uint === winnerAddress => tokenId
1823     mapping (uint => address) public winners;
1824 
1825     // Map from token ID to their corresponding auction.
1826     mapping (uint256 => Auction) public tokenIdToAuction;
1827     mapping (uint256 => uint256) public tokendIdToAuctionId;
1828 
1829     /// @dev auction array
1830     Auction[20] public auctions;
1831 
1832     /// @dev auction index
1833     uint public idx = 0;
1834 
1835     /// @dev cut on each auction
1836     uint256 public baeAuctionFee = 0.01 ether;
1837 
1838     modifier onlyAuctionOwner() {
1839         require(msg.sender == owner);
1840         _;
1841     }
1842     
1843     modifier onlyAuctionLord() {
1844         require(msg.sender == address(baeInstance));
1845         _;
1846     }
1847     
1848     constructor() public {
1849         paused = true;
1850         ceoAddress = msg.sender;
1851     }
1852     
1853     function setIsCurrentAuction(bool _current) external onlyCEO {
1854         currentAuction = _current;
1855     }
1856     
1857     /// @dev this should be done when paused  as it breaks functionality
1858     /// @dev changes the current contract interaccting with the auction
1859     function setBAEAddress(address payable _newAddress) public onlyAuctionOwner whenPaused {
1860         address currentInstance = address(baeInstance);
1861         BAECore candidate = BAECore(_newAddress);
1862         baeInstance = candidate;
1863         require(address(baeInstance) != address(0) && address(baeInstance) != currentInstance);
1864     }
1865 
1866     function createAuction(
1867         uint256 _tokenId,
1868         uint256 _startingPrice,
1869         uint256 _finalPrice,
1870         address payable _seller
1871     )
1872         external
1873         whenNotPaused
1874         onlyAuctionLord
1875     {
1876         if (tokendIdToAuctionId[_tokenId] != 0) {
1877             require(tokenIdToAuction[_tokenId].paid == 1);
1878         }
1879         require(idx <= 20);
1880         
1881         Auction memory newAuction = Auction(_tokenId, _startingPrice, _finalPrice, _seller, 0);
1882         auctions[idx] = newAuction;
1883         tokenIdToAuction[_tokenId] = newAuction; 
1884         tokendIdToAuctionId[_tokenId] = idx;
1885         idx = idx.add(1);
1886         
1887         emit AuctionCreated(idx,  _seller);
1888     }
1889 
1890     /// @dev this function sets who won that auction and allows the token to be marked as approved for sale.
1891     function hasWon(uint256 _auctionId, address _winner, uint256 _finalBidPrice) external whenNotPaused onlyAuctionLord {
1892         winners[auctions[_auctionId].tokenId] = _winner;
1893         auctions[_auctionId].finalPrice = _finalBidPrice;
1894         emit AuctionWon(auctions[_auctionId].tokenId, _winner);
1895     }
1896 
1897     function winnerCheckWireDetails(uint _auctionId, address _sender) external view whenNotPaused returns(address payable, uint, uint) {
1898         /// get the storage variables
1899         uint finalPrice = auctions[_auctionId].finalPrice;
1900         uint tokenId = auctions[_auctionId].tokenId;
1901         address winnerAddress = winners[tokenId];
1902         address payable seller = auctions[_auctionId].seller;
1903 
1904         /// get winner address and check it is in the winners' mapping
1905         require(_sender == winnerAddress);
1906         return (seller, tokenId, finalPrice);
1907     }
1908     
1909     function setPaid(uint _auctionId) external whenNotPaused onlyAuctionLord {
1910         require(auctions[_auctionId].paid == 0);
1911         auctions[_auctionId].paid = 1;
1912         emit SellerPaid(true, auctions[_auctionId].finalPrice);
1913     }
1914     
1915     /** Takes an auctionId to get the tokenId for the auction and returns the address of the winner. */
1916     function getAuctionWinnerAddress(uint _auctionId) external view whenNotPaused returns(address)  {
1917         return winners[auctions[_auctionId].tokenId];
1918     }
1919     
1920     function getFinalPrice(uint _auctionId) external view whenNotPaused returns(uint)  {
1921         return auctions[_auctionId].finalPrice;
1922     }
1923 
1924     function getAuctionDetails(uint _auctionId) external view whenNotPaused returns (uint, uint, uint, address, uint) {
1925         return (auctions[_auctionId].tokenId, auctions[_auctionId].startingPrice, auctions[_auctionId].finalPrice, auctions[_auctionId].seller, auctions[_auctionId].paid);
1926     }
1927     
1928     function getCurrentIndex() external view returns (uint) {
1929         uint val = idx - 1;
1930                 
1931         if (val > 20) {
1932             return 0;
1933         }
1934         
1935         return val;
1936     }
1937     
1938     function getTokenIdToAuctionId(uint _tokenId) external view returns (uint) {
1939         return tokendIdToAuctionId[_tokenId];
1940     }
1941     
1942     function unpause() public onlyAuctionOwner whenPaused {
1943         require(address(baeInstance) != address(0));
1944 
1945         super.unpause();
1946     }
1947     
1948     function () external payable {
1949         revert();
1950     }
1951 }
1952 
1953 contract BAECore is BAE {
1954       using SafeMath for uint256;
1955  
1956     /// @dev this will be private so no one can see where it is living and will be deployed by another address
1957     PerishableSimpleAuction private instanceAuctionAddress;
1958     
1959     constructor() public {
1960         paused = true;
1961         ceoAddress = msg.sender;
1962     }
1963 
1964     function setAuctionAddress(address payable _newAddress) public onlyCEO whenPaused {
1965         PerishableSimpleAuction possibleAuctionInstance = PerishableSimpleAuction(_newAddress);
1966         instanceAuctionAddress = possibleAuctionInstance;
1967     }
1968     
1969     /// @dev we can also charge straight away by charging an amount and making this function payable
1970     function createAuction(uint _tokenId, uint _startingPrice, uint _finalPrice) external whenNotPaused {
1971         require(ownerOf( _tokenId) == msg.sender, "You can't transfer an artpiece which is not yours");
1972         require(_startingPrice >= artpieces[_tokenId].metadata.basePrice);
1973         instanceAuctionAddress.createAuction(_tokenId, _startingPrice,_finalPrice, msg.sender);
1974         
1975         /// @dev - approve the setWinnerAndPrice callers
1976         setApprovalForAll(owner, true);
1977         setApprovalForAll(ceoAddress, true);
1978         setApprovalForAll(cfoAddress, true);
1979         setApprovalForAll(cooAddress, true);
1980     }
1981     
1982     function getAuctionDetails(uint _auctionId) public view returns (uint) {
1983         (uint tokenId,,,,) = instanceAuctionAddress.getAuctionDetails(_auctionId);
1984         return tokenId;
1985     }
1986     
1987     /// @dev this should be cleared from the array if its called on a second time.
1988     function setWinnerAndPrice(uint256 _auctionId, address _winner, uint256 _finalPrice, uint256 _currentPrice) external onlyCLevelOrOwner whenNotPaused returns(bool hasWinnerInfo) 
1989     {   
1990         (uint tokenId,,,,) = instanceAuctionAddress.getAuctionDetails(_auctionId);
1991         require(_finalPrice >= uint256(artpieces[tokenId].metadata.basePrice));
1992         approve(_winner, tokenId);
1993         instanceAuctionAddress.hasWon(_auctionId, _winner, _finalPrice);
1994         tokenInterface.setFinalPriceInPounds(_currentPrice);
1995         return true;
1996     }
1997     
1998     function calculateFees(uint _tokenId, uint _fullAmount) internal view  whenNotPaused returns (uint baeFee, uint royaltyFee, uint potFee) {
1999         /// @dev check this will not bring problems in the future or should we be using SafeMath library.
2000         uint baeFeeAmount = (uint(artpieces[_tokenId].baeFeeLevel) * _fullAmount) / 100;
2001         uint artistFeeAmount = (uint(artpieces[_tokenId].feeLevel) * _fullAmount) / 100;
2002 
2003         /// @dev any extra money will be added to the pot
2004         uint potFeeAmount = _fullAmount - (baeFeeAmount + artistFeeAmount);
2005         return (baeFeeAmount, artistFeeAmount, potFeeAmount);
2006     }
2007 
2008     function payAndWithdraw(uint _auctionId) public payable {
2009         // calculate the share of each of the stakeholders 
2010         (address payable seller, uint tokenId, uint finalPrice) = instanceAuctionAddress.winnerCheckWireDetails(_auctionId, msg.sender);
2011         (uint baeFeeAmount, uint artistFeeAmount,) = calculateFees(tokenId, finalPrice);
2012         
2013         // break msg.value it into the rightchunks
2014         require(msg.value >= finalPrice);
2015         uint baeFee = msg.value.sub(baeFeeAmount);
2016         uint artistFee = msg.value.sub(artistFeeAmount);
2017         
2018         // do the transfers
2019         BAEFeeAddress.transfer(msg.value.sub(baeFee));
2020         seller.transfer(msg.value.sub(artistFee));
2021         address(tokenInterface).transfer(address(this).balance);
2022         
2023         // and when the money is sent, we mark the auccion as completed
2024         instanceAuctionAddress.setPaid(_auctionId);
2025         
2026         // and since it's paid then initiate the transfer mechanism
2027         transferFrom(seller, msg.sender, tokenId);
2028     }
2029     
2030     function getWinnerAddress(uint _auctionId) public view returns(address)  {
2031         return instanceAuctionAddress.getAuctionWinnerAddress(_auctionId);
2032     }
2033     
2034     function getHighestBid(uint _auctionId) public view returns(uint)  {
2035         return instanceAuctionAddress.getFinalPrice(_auctionId);
2036     }
2037     
2038     function getLatestAuctionIndex() public view returns(uint) {
2039         return instanceAuctionAddress.getCurrentIndex();
2040     }
2041 
2042     function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused {
2043         uint auctionId = instanceAuctionAddress.getTokenIdToAuctionId(_tokenId);
2044         (,,,,uint paid) = (instanceAuctionAddress.getAuctionDetails(auctionId));
2045         require(paid == 1);
2046         super.transferFrom(_from, _to, _tokenId);
2047         _postPurchase(_from, _to, _tokenId);
2048         
2049         /// @dev this gets paid even to non artists, if it's a seller he will get the same
2050         tokenInterface.addToBAEHolders(_from);
2051     }
2052     
2053     function unpause() public onlyCEO whenPaused {
2054         require(ceoAddress != address(0));
2055         require(address(instanceAuctionAddress) != address(0));
2056         require(address(tokenInterface) != address(0));
2057         require(address(BAEFeeAddress) != address(0));
2058 
2059         super.unpause();
2060     }
2061     
2062     /// @dev - we override this so only the CEO can call it.
2063     function pause() public onlyCEO whenNotPaused {
2064         super.pause();
2065     }
2066     
2067     function () external payable {}
2068 }