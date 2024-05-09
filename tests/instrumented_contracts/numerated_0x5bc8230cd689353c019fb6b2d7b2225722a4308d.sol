1 pragma solidity ^0.4.25; // solium-disable-line linebreak-style
2 
3 /**
4  * @author Anatolii Kucheruk (anatolii@platin.io)
5  * @author Platin Limited, platin.io (platin@platin.io)
6  */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
18     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (_a == 0) {
22       return 0;
23     }
24 
25     c = _a * _b;
26     assert(c / _a == _b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
34     // assert(_b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = _a / _b;
36     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
37     return _a / _b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
44     assert(_b <= _a);
45     return _a - _b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
52     c = _a + _b;
53     assert(c >= _a);
54     return c;
55   }
56 }
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipRenounced(address indexed previousOwner);
68   event OwnershipTransferred(
69     address indexed previousOwner,
70     address indexed newOwner
71   );
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   constructor() public {
79     owner = msg.sender;
80   }
81 
82   /**
83    * @dev Throws if called by any account other than the owner.
84    */
85   modifier onlyOwner() {
86     require(msg.sender == owner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to relinquish control of the contract.
92    * @notice Renouncing to ownership will leave the contract without an owner.
93    * It will not be possible to call the functions with the `onlyOwner`
94    * modifier anymore.
95    */
96   function renounceOwnership() public onlyOwner {
97     emit OwnershipRenounced(owner);
98     owner = address(0);
99   }
100 
101   /**
102    * @dev Allows the current owner to transfer control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address _newOwner) public onlyOwner {
106     _transferOwnership(_newOwner);
107   }
108 
109   /**
110    * @dev Transfers control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function _transferOwnership(address _newOwner) internal {
114     require(_newOwner != address(0));
115     emit OwnershipTransferred(owner, _newOwner);
116     owner = _newOwner;
117   }
118 }
119 
120 /**
121  * @title Contracts that should not own Ether
122  * @author Remco Bloemen <remco@2π.com>
123  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
124  * in the contract, it will allow the owner to reclaim this Ether.
125  * @notice Ether can still be sent to this contract by:
126  * calling functions labeled `payable`
127  * `selfdestruct(contract_address)`
128  * mining directly to the contract address
129  */
130 contract HasNoEther is Ownable {
131 
132   /**
133   * @dev Constructor that rejects incoming Ether
134   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
135   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
136   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
137   * we could use assembly to access msg.value.
138   */
139   constructor() public payable {
140     require(msg.value == 0);
141   }
142 
143   /**
144    * @dev Disallows direct send by setting a default function without the `payable` flag.
145    */
146   function() external {
147   }
148 
149   /**
150    * @dev Transfer all Ether held by the contract to the owner.
151    */
152   function reclaimEther() external onlyOwner {
153     owner.transfer(address(this).balance);
154   }
155 }
156 
157 /**
158  * @title SafeERC20
159  * @dev Wrappers around ERC20 operations that throw on failure.
160  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
161  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
162  */
163 library SafeERC20 {
164   function safeTransfer(
165     ERC20Basic _token,
166     address _to,
167     uint256 _value
168   )
169     internal
170   {
171     require(_token.transfer(_to, _value));
172   }
173 
174   function safeTransferFrom(
175     ERC20 _token,
176     address _from,
177     address _to,
178     uint256 _value
179   )
180     internal
181   {
182     require(_token.transferFrom(_from, _to, _value));
183   }
184 
185   function safeApprove(
186     ERC20 _token,
187     address _spender,
188     uint256 _value
189   )
190     internal
191   {
192     require(_token.approve(_spender, _value));
193   }
194 }
195 
196 /**
197  * @title Contracts that should be able to recover tokens
198  * @author SylTi
199  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
200  * This will prevent any accidental loss of tokens.
201  */
202 contract CanReclaimToken is Ownable {
203   using SafeERC20 for ERC20Basic;
204 
205   /**
206    * @dev Reclaim all ERC20Basic compatible tokens
207    * @param _token ERC20Basic The address of the token contract
208    */
209   function reclaimToken(ERC20Basic _token) external onlyOwner {
210     uint256 balance = _token.balanceOf(this);
211     _token.safeTransfer(owner, balance);
212   }
213 
214 }
215 
216 /**
217  * @title Contracts that should not own Tokens
218  * @author Remco Bloemen <remco@2π.com>
219  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
220  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
221  * owner to reclaim the tokens.
222  */
223 contract HasNoTokens is CanReclaimToken {
224 
225  /**
226   * @dev Reject all ERC223 compatible tokens
227   * @param _from address The address that is transferring the tokens
228   * @param _value uint256 the amount of the specified token
229   * @param _data Bytes The data passed from the caller.
230   */
231   function tokenFallback(
232     address _from,
233     uint256 _value,
234     bytes _data
235   )
236     external
237     pure
238   {
239     _from;
240     _value;
241     _data;
242     revert();
243   }
244 
245 }
246 
247 /**
248  * @title Contracts that should not own Contracts
249  * @author Remco Bloemen <remco@2π.com>
250  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
251  * of this contract to reclaim ownership of the contracts.
252  */
253 contract HasNoContracts is Ownable {
254 
255   /**
256    * @dev Reclaim ownership of Ownable contracts
257    * @param _contractAddr The address of the Ownable to be reclaimed.
258    */
259   function reclaimContract(address _contractAddr) external onlyOwner {
260     Ownable contractInst = Ownable(_contractAddr);
261     contractInst.transferOwnership(owner);
262   }
263 }
264 
265 /**
266  * @title Base contract for contracts that should not own things.
267  * @author Remco Bloemen <remco@2π.com>
268  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
269  * Owned contracts. See respective base contracts for details.
270  */
271 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
272 }
273 
274 /**
275  * @title Pausable
276  * @dev Base contract which allows children to implement an emergency stop mechanism.
277  */
278 contract Pausable is Ownable {
279   event Pause();
280   event Unpause();
281 
282   bool public paused = false;
283 
284 
285   /**
286    * @dev Modifier to make a function callable only when the contract is not paused.
287    */
288   modifier whenNotPaused() {
289     require(!paused);
290     _;
291   }
292 
293   /**
294    * @dev Modifier to make a function callable only when the contract is paused.
295    */
296   modifier whenPaused() {
297     require(paused);
298     _;
299   }
300 
301   /**
302    * @dev called by the owner to pause, triggers stopped state
303    */
304   function pause() public onlyOwner whenNotPaused {
305     paused = true;
306     emit Pause();
307   }
308 
309   /**
310    * @dev called by the owner to unpause, returns to normal state
311    */
312   function unpause() public onlyOwner whenPaused {
313     paused = false;
314     emit Unpause();
315   }
316 }
317 
318 /**
319  * @title Authorizable
320  * @dev Authorizable contract holds a list of control addresses that authorized to do smth.
321  */
322 contract Authorizable is Ownable {
323 
324     // List of authorized (control) addresses
325     mapping (address => bool) public authorized;
326 
327     // Authorize event logging
328     event Authorize(address indexed who);
329 
330     // UnAuthorize event logging
331     event UnAuthorize(address indexed who);
332 
333     // onlyAuthorized modifier, restrict to the owner and the list of authorized addresses
334     modifier onlyAuthorized() {
335         require(msg.sender == owner || authorized[msg.sender], "Not Authorized.");
336         _;
337     }
338 
339     /**
340      * @dev Authorize given address
341      * @param _who address Address to authorize 
342      */
343     function authorize(address _who) public onlyOwner {
344         require(_who != address(0), "Address can't be zero.");
345         require(!authorized[_who], "Already authorized");
346 
347         authorized[_who] = true;
348         emit Authorize(_who);
349     }
350 
351     /**
352      * @dev unAuthorize given address
353      * @param _who address Address to unauthorize 
354      */
355     function unAuthorize(address _who) public onlyOwner {
356         require(_who != address(0), "Address can't be zero.");
357         require(authorized[_who], "Address is not authorized");
358 
359         authorized[_who] = false;
360         emit UnAuthorize(_who);
361     }
362 }
363 
364 /**
365  * @title ERC20Basic
366  * @dev Simpler version of ERC20 interface
367  * See https://github.com/ethereum/EIPs/issues/179
368  */
369 contract ERC20Basic {
370   function totalSupply() public view returns (uint256);
371   function balanceOf(address _who) public view returns (uint256);
372   function transfer(address _to, uint256 _value) public returns (bool);
373   event Transfer(address indexed from, address indexed to, uint256 value);
374 }
375 
376 /**
377  * @title ERC20 interface
378  * @dev see https://github.com/ethereum/EIPs/issues/20
379  */
380 contract ERC20 is ERC20Basic {
381   function allowance(address _owner, address _spender)
382     public view returns (uint256);
383 
384   function transferFrom(address _from, address _to, uint256 _value)
385     public returns (bool);
386 
387   function approve(address _spender, uint256 _value) public returns (bool);
388   event Approval(
389     address indexed owner,
390     address indexed spender,
391     uint256 value
392   );
393 }
394 
395 /**
396  * @title Basic token
397  * @dev Basic version of StandardToken, with no allowances.
398  */
399 contract BasicToken is ERC20Basic {
400   using SafeMath for uint256;
401 
402   mapping(address => uint256) internal balances;
403 
404   uint256 internal totalSupply_;
405 
406   /**
407   * @dev Total number of tokens in existence
408   */
409   function totalSupply() public view returns (uint256) {
410     return totalSupply_;
411   }
412 
413   /**
414   * @dev Transfer token for a specified address
415   * @param _to The address to transfer to.
416   * @param _value The amount to be transferred.
417   */
418   function transfer(address _to, uint256 _value) public returns (bool) {
419     require(_value <= balances[msg.sender]);
420     require(_to != address(0));
421 
422     balances[msg.sender] = balances[msg.sender].sub(_value);
423     balances[_to] = balances[_to].add(_value);
424     emit Transfer(msg.sender, _to, _value);
425     return true;
426   }
427 
428   /**
429   * @dev Gets the balance of the specified address.
430   * @param _owner The address to query the the balance of.
431   * @return An uint256 representing the amount owned by the passed address.
432   */
433   function balanceOf(address _owner) public view returns (uint256) {
434     return balances[_owner];
435   }
436 
437 }
438 
439 /**
440  * @title Standard ERC20 token
441  *
442  * @dev Implementation of the basic standard token.
443  * https://github.com/ethereum/EIPs/issues/20
444  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
445  */
446 contract StandardToken is ERC20, BasicToken {
447 
448   mapping (address => mapping (address => uint256)) internal allowed;
449 
450 
451   /**
452    * @dev Transfer tokens from one address to another
453    * @param _from address The address which you want to send tokens from
454    * @param _to address The address which you want to transfer to
455    * @param _value uint256 the amount of tokens to be transferred
456    */
457   function transferFrom(
458     address _from,
459     address _to,
460     uint256 _value
461   )
462     public
463     returns (bool)
464   {
465     require(_value <= balances[_from]);
466     require(_value <= allowed[_from][msg.sender]);
467     require(_to != address(0));
468 
469     balances[_from] = balances[_from].sub(_value);
470     balances[_to] = balances[_to].add(_value);
471     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
472     emit Transfer(_from, _to, _value);
473     return true;
474   }
475 
476   /**
477    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
478    * Beware that changing an allowance with this method brings the risk that someone may use both the old
479    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
480    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
481    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
482    * @param _spender The address which will spend the funds.
483    * @param _value The amount of tokens to be spent.
484    */
485   function approve(address _spender, uint256 _value) public returns (bool) {
486     allowed[msg.sender][_spender] = _value;
487     emit Approval(msg.sender, _spender, _value);
488     return true;
489   }
490 
491   /**
492    * @dev Function to check the amount of tokens that an owner allowed to a spender.
493    * @param _owner address The address which owns the funds.
494    * @param _spender address The address which will spend the funds.
495    * @return A uint256 specifying the amount of tokens still available for the spender.
496    */
497   function allowance(
498     address _owner,
499     address _spender
500    )
501     public
502     view
503     returns (uint256)
504   {
505     return allowed[_owner][_spender];
506   }
507 
508   /**
509    * @dev Increase the amount of tokens that an owner allowed to a spender.
510    * approve should be called when allowed[_spender] == 0. To increment
511    * allowed value is better to use this function to avoid 2 calls (and wait until
512    * the first transaction is mined)
513    * From MonolithDAO Token.sol
514    * @param _spender The address which will spend the funds.
515    * @param _addedValue The amount of tokens to increase the allowance by.
516    */
517   function increaseApproval(
518     address _spender,
519     uint256 _addedValue
520   )
521     public
522     returns (bool)
523   {
524     allowed[msg.sender][_spender] = (
525       allowed[msg.sender][_spender].add(_addedValue));
526     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
527     return true;
528   }
529 
530   /**
531    * @dev Decrease the amount of tokens that an owner allowed to a spender.
532    * approve should be called when allowed[_spender] == 0. To decrement
533    * allowed value is better to use this function to avoid 2 calls (and wait until
534    * the first transaction is mined)
535    * From MonolithDAO Token.sol
536    * @param _spender The address which will spend the funds.
537    * @param _subtractedValue The amount of tokens to decrease the allowance by.
538    */
539   function decreaseApproval(
540     address _spender,
541     uint256 _subtractedValue
542   )
543     public
544     returns (bool)
545   {
546     uint256 oldValue = allowed[msg.sender][_spender];
547     if (_subtractedValue >= oldValue) {
548       allowed[msg.sender][_spender] = 0;
549     } else {
550       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
551     }
552     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
553     return true;
554   }
555 
556 }
557 
558 /**
559  * @title Holders Token
560  * @dev Extension to the OpenZepellin's StandardToken contract to track token holders.
561  * Only holders with the non-zero balance are listed.
562  */
563 contract HoldersToken is StandardToken {
564     using SafeMath for uint256;    
565 
566     // holders list
567     address[] public holders;
568 
569     // holder number in the list
570     mapping (address => uint256) public holderNumber;
571 
572     /**
573      * @dev Get the holders count
574      * @return uint256 Holders count
575      */
576     function holdersCount() public view returns (uint256) {
577         return holders.length;
578     }
579 
580     /**
581      * @dev Transfer tokens from one address to another preserving token holders
582      * @param _to address The address which you want to transfer to
583      * @param _value uint256 The amount of tokens to be transferred
584      * @return bool Returns true if the transfer was succeeded
585      */
586     function transfer(address _to, uint256 _value) public returns (bool) {
587         _preserveHolders(msg.sender, _to, _value);
588         return super.transfer(_to, _value);
589     }
590 
591     /**
592      * @dev Transfer tokens from one address to another preserving token holders
593      * @param _from address The address which you want to send tokens from
594      * @param _to address The address which you want to transfer to
595      * @param _value uint256 The amount of tokens to be transferred
596      * @return bool Returns true if the transfer was succeeded
597      */
598     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
599         _preserveHolders(_from, _to, _value);
600         return super.transferFrom(_from, _to, _value);
601     }
602 
603     /**
604      * @dev Remove holder from the holders list
605      * @param _holder address Address of the holder to remove
606      */
607     function _removeHolder(address _holder) internal {
608         uint256 _number = holderNumber[_holder];
609 
610         if (_number == 0 || holders.length == 0 || _number > holders.length)
611             return;
612 
613         uint256 _index = _number.sub(1);
614         uint256 _lastIndex = holders.length.sub(1);
615         address _lastHolder = holders[_lastIndex];
616 
617         if (_index != _lastIndex) {
618             holders[_index] = _lastHolder;
619             holderNumber[_lastHolder] = _number;
620         }
621 
622         holderNumber[_holder] = 0;
623         holders.length = _lastIndex;
624     } 
625 
626     /**
627      * @dev Add holder to the holders list
628      * @param _holder address Address of the holder to add   
629      */
630     function _addHolder(address _holder) internal {
631         if (holderNumber[_holder] == 0) {
632             holders.push(_holder);
633             holderNumber[_holder] = holders.length;
634         }
635     }
636 
637     /**
638      * @dev Preserve holders during transfers
639      * @param _from address The address which you want to send tokens from
640      * @param _to address The address which you want to transfer to
641      * @param _value uint256 the amount of tokens to be transferred
642      */
643     function _preserveHolders(address _from, address _to, uint256 _value) internal {
644         _addHolder(_to);   
645         if (balanceOf(_from).sub(_value) == 0) 
646             _removeHolder(_from);
647     }
648 }
649 
650 /**
651  * @title PlatinToken
652  * @dev Platin PTNX Token contract. Tokens are allocated during TGE.
653  * Token contract is a standard ERC20 token with additional capabilities: TGE allocation, holders tracking and lockup.
654  * Initial allocation should be invoked by the TGE contract at the TGE moment of time.
655  * Token contract holds list of token holders, the list includes holders with positive balance only.
656  * Authorized holders can transfer token with lockup(s). Lockups can be refundable. 
657  * Lockups is a list of releases dates and releases amounts.
658  * In case of refund previous holder can get back locked up tokens. Only still locked up amounts can be transferred back.
659  */
660 contract PlatinToken is HoldersToken, NoOwner, Authorizable, Pausable {
661     using SafeMath for uint256;
662 
663     string public constant name = "Platin Token"; // solium-disable-line uppercase
664     string public constant symbol = "PTNX"; // solium-disable-line uppercase
665     uint8 public constant decimals = 18; // solium-disable-line uppercase
666  
667     // lockup sruct
668     struct Lockup {
669         uint256 release; // release timestamp
670         uint256 amount; // amount of tokens to release
671     }
672 
673     // list of lockups
674     mapping (address => Lockup[]) public lockups;
675 
676     // list of lockups that can be refunded
677     mapping (address => mapping (address => Lockup[])) public refundable;
678 
679     // idexes mapping from refundable to lockups lists 
680     mapping (address => mapping (address => mapping (uint256 => uint256))) public indexes;    
681 
682     // Platin TGE contract
683     PlatinTGE public tge;
684 
685     // allocation event logging
686     event Allocate(address indexed to, uint256 amount);
687 
688     // lockup event logging
689     event SetLockups(address indexed to, uint256 amount, uint256 fromIdx, uint256 toIdx);
690 
691     // refund event logging
692     event Refund(address indexed from, address indexed to, uint256 amount);
693 
694     // spotTransfer modifier, check balance spot on transfer
695     modifier spotTransfer(address _from, uint256 _value) {
696         require(_value <= balanceSpot(_from), "Attempt to transfer more than balance spot.");
697         _;
698     }
699 
700     // onlyTGE modifier, restrict to the TGE contract only
701     modifier onlyTGE() {
702         require(msg.sender == address(tge), "Only TGE method.");
703         _;
704     }
705 
706     /**
707      * @dev Set TGE contract
708      * @param _tge address PlatinTGE contract address    
709      */
710     function setTGE(PlatinTGE _tge) external onlyOwner {
711         require(tge == address(0), "TGE is already set.");
712         require(_tge != address(0), "TGE address can't be zero.");
713         tge = _tge;
714         authorize(_tge);
715     }        
716 
717     /**
718      * @dev Allocate tokens during TGE
719      * @param _to address Address gets the tokens
720      * @param _amount uint256 Amount to allocate
721      */ 
722     function allocate(address _to, uint256 _amount) external onlyTGE {
723         require(_to != address(0), "Allocate To address can't be zero");
724         require(_amount > 0, "Allocate amount should be > 0.");
725        
726         totalSupply_ = totalSupply_.add(_amount);
727         balances[_to] = balances[_to].add(_amount);
728 
729         _addHolder(_to);
730 
731         require(totalSupply_ <= tge.TOTAL_SUPPLY(), "Can't allocate more than TOTAL SUPPLY.");
732 
733         emit Allocate(_to, _amount);
734         emit Transfer(address(0), _to, _amount);
735     }  
736 
737     /**
738      * @dev Transfer tokens from one address to another
739      * @param _to address The address which you want to transfer to
740      * @param _value uint256 The amount of tokens to be transferred
741      * @return bool Returns true if the transfer was succeeded
742      */
743     function transfer(address _to, uint256 _value) public whenNotPaused spotTransfer(msg.sender, _value) returns (bool) {
744         return super.transfer(_to, _value);
745     }
746 
747     /**
748      * @dev Transfer tokens from one address to another
749      * @param _from address The address which you want to send tokens from
750      * @param _to address The address which you want to transfer to
751      * @param _value uint256 The amount of tokens to be transferred
752      * @return bool Returns true if the transfer was succeeded
753      */
754     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused spotTransfer(_from, _value) returns (bool) {
755         return super.transferFrom(_from, _to, _value);
756     }
757 
758     /**
759      * @dev Transfer tokens from one address to another with lockup
760      * @param _to address The address which you want to transfer to
761      * @param _value uint256 The amount of tokens to be transferred
762      * @param _lockupReleases uint256[] List of lockup releases
763      * @param _lockupAmounts uint256[] List of lockup amounts
764      * @param _refundable bool Is locked up amount refundable
765      * @return bool Returns true if the transfer was succeeded     
766      */
767     function transferWithLockup(
768         address _to, 
769         uint256 _value, 
770         uint256[] _lockupReleases,
771         uint256[] _lockupAmounts,
772         bool _refundable
773     ) 
774     public onlyAuthorized returns (bool)
775     {        
776         transfer(_to, _value);
777         _lockup(_to, _value, _lockupReleases, _lockupAmounts, _refundable); // solium-disable-line arg-overflow     
778     }       
779 
780     /**
781      * @dev Transfer tokens from one address to another with lockup
782      * @param _from address The address which you want to send tokens from
783      * @param _to address The address which you want to transfer to
784      * @param _value uint256 The amount of tokens to be transferred
785      * @param _lockupReleases uint256[] List of lockup releases
786      * @param _lockupAmounts uint256[] List of lockup amounts
787      * @param _refundable bool Is locked up amount refundable      
788      * @return bool Returns true if the transfer was succeeded     
789      */
790     function transferFromWithLockup(
791         address _from, 
792         address _to, 
793         uint256 _value, 
794         uint256[] _lockupReleases,
795         uint256[] _lockupAmounts,
796         bool _refundable
797     ) 
798     public onlyAuthorized returns (bool)
799     {
800         transferFrom(_from, _to, _value);
801         _lockup(_to, _value, _lockupReleases, _lockupAmounts, _refundable); // solium-disable-line arg-overflow  
802     }     
803 
804     /**
805      * @dev Refund refundable locked up amount
806      * @param _from address The address which you want to refund tokens from
807      * @return uint256 Returns amount of refunded tokens   
808      */
809     function refundLockedUp(
810         address _from
811     )
812     public onlyAuthorized returns (uint256)
813     {
814         address _sender = msg.sender;
815         uint256 _balanceRefundable = 0;
816         uint256 _refundableLength = refundable[_from][_sender].length;
817         if (_refundableLength > 0) {
818             uint256 _lockupIdx;
819             for (uint256 i = 0; i < _refundableLength; i++) {
820                 if (refundable[_from][_sender][i].release > block.timestamp) { // solium-disable-line security/no-block-members
821                     _balanceRefundable = _balanceRefundable.add(refundable[_from][_sender][i].amount);
822                     refundable[_from][_sender][i].release = 0;
823                     refundable[_from][_sender][i].amount = 0;
824                     _lockupIdx = indexes[_from][_sender][i];
825                     lockups[_from][_lockupIdx].release = 0;
826                     lockups[_from][_lockupIdx].amount = 0;       
827                 }    
828             }
829 
830             if (_balanceRefundable > 0) {
831                 _preserveHolders(_from, _sender, _balanceRefundable);
832                 balances[_from] = balances[_from].sub(_balanceRefundable);
833                 balances[_sender] = balances[_sender].add(_balanceRefundable);
834                 emit Refund(_from, _sender, _balanceRefundable);
835                 emit Transfer(_from, _sender, _balanceRefundable);
836             }
837         }
838         return _balanceRefundable;
839     }
840 
841     /**
842      * @dev Get the lockups list count
843      * @param _who address Address owns locked up list
844      * @return uint256 Lockups list count
845      */
846     function lockupsCount(address _who) public view returns (uint256) {
847         return lockups[_who].length;
848     }
849 
850     /**
851      * @dev Find out if the address has lockups
852      * @param _who address Address checked for lockups
853      * @return bool Returns true if address has lockups
854      */
855     function hasLockups(address _who) public view returns (bool) {
856         return lockups[_who].length > 0;
857     }
858 
859     /**
860      * @dev Get balance locked up at the current moment of time
861      * @param _who address Address owns locked up amounts
862      * @return uint256 Balance locked up at the current moment of time
863      */
864     function balanceLockedUp(address _who) public view returns (uint256) {
865         uint256 _balanceLokedUp = 0;
866         uint256 _lockupsLength = lockups[_who].length;
867         for (uint256 i = 0; i < _lockupsLength; i++) {
868             if (lockups[_who][i].release > block.timestamp) // solium-disable-line security/no-block-members
869                 _balanceLokedUp = _balanceLokedUp.add(lockups[_who][i].amount);
870         }
871         return _balanceLokedUp;
872     }
873 
874     /**
875      * @dev Get refundable locked up balance at the current moment of time
876      * @param _who address Address owns locked up amounts
877      * @param _sender address Address owned locked up amounts
878      * @return uint256 Locked up refundable balance at the current moment of time
879      */
880     function balanceRefundable(address _who, address _sender) public view returns (uint256) {
881         uint256 _balanceRefundable = 0;
882         uint256 _refundableLength = refundable[_who][_sender].length;
883         if (_refundableLength > 0) {
884             for (uint256 i = 0; i < _refundableLength; i++) {
885                 if (refundable[_who][_sender][i].release > block.timestamp) // solium-disable-line security/no-block-members
886                     _balanceRefundable = _balanceRefundable.add(refundable[_who][_sender][i].amount);
887             }
888         }
889         return _balanceRefundable;
890     }
891 
892     /**
893      * @dev Get balance spot for the current moment of time
894      * @param _who address Address owns balance spot
895      * @return uint256 Balance spot for the current moment of time
896      */
897     function balanceSpot(address _who) public view returns (uint256) {
898         uint256 _balanceSpot = balanceOf(_who);
899         _balanceSpot = _balanceSpot.sub(balanceLockedUp(_who));
900         return _balanceSpot;
901     }
902 
903     /**
904      * @dev Lockup amount till release time
905      * @param _who address Address gets the locked up amount
906      * @param _amount uint256 Amount to lockup
907      * @param _lockupReleases uint256[] List of lockup releases
908      * @param _lockupAmounts uint256[] List of lockup amounts
909      * @param _refundable bool Is locked up amount refundable     
910      */     
911     function _lockup(
912         address _who, 
913         uint256 _amount, 
914         uint256[] _lockupReleases,
915         uint256[] _lockupAmounts,
916         bool _refundable) 
917     internal 
918     {
919         require(_lockupReleases.length == _lockupAmounts.length, "Length of lockup releases and amounts lists should be equal.");
920         require(_lockupReleases.length.add(lockups[_who].length) <= 1000, "Can't be more than 1000 lockups per address.");
921         if (_lockupReleases.length > 0) {
922             uint256 _balanceLokedUp = 0;
923             address _sender = msg.sender;
924             uint256 _fromIdx = lockups[_who].length;
925             uint256 _toIdx = _fromIdx + _lockupReleases.length - 1;
926             uint256 _lockupIdx;
927             uint256 _refundIdx;
928             for (uint256 i = 0; i < _lockupReleases.length; i++) {
929                 if (_lockupReleases[i] > block.timestamp) { // solium-disable-line security/no-block-members
930                     lockups[_who].push(Lockup(_lockupReleases[i], _lockupAmounts[i]));
931                     _balanceLokedUp = _balanceLokedUp.add(_lockupAmounts[i]);
932                     if (_refundable) {
933                         refundable[_who][_sender].push(Lockup(_lockupReleases[i], _lockupAmounts[i]));
934                         _lockupIdx = lockups[_who].length - 1;
935                         _refundIdx = refundable[_who][_sender].length - 1;
936                         indexes[_who][_sender][_refundIdx] = _lockupIdx;
937                     }
938                 }
939             }
940 
941             require(_balanceLokedUp <= _amount, "Can't lockup more than transferred amount.");
942             emit SetLockups(_who, _amount, _fromIdx, _toIdx); // solium-disable-line arg-overflow
943         }            
944     }      
945 }
946 
947 /**
948  * @title PlatinTGE
949  * @dev Platin Token Generation Event contract. It holds token economic constants and makes initial token allocation.
950  * Initial token allocation function should be called outside the blockchain at the TGE moment of time, 
951  * from here on out, Platin Token and other Platin contracts become functional.
952  */
953 contract PlatinTGE {
954     using SafeMath for uint256;
955     
956     // Token decimals
957     uint8 public constant decimals = 18; // solium-disable-line uppercase
958 
959     // Total Tokens Supply
960     uint256 public constant TOTAL_SUPPLY = 1000000000 * (10 ** uint256(decimals)); // 1,000,000,000 PTNX
961 
962     // SUPPLY
963     // TOTAL_SUPPLY = 1,000,000,000 PTNX, is distributed as follows:
964     uint256 public constant SALES_SUPPLY = 300000000 * (10 ** uint256(decimals)); // 300,000,000 PTNX - 30%
965     uint256 public constant MINING_POOL_SUPPLY = 200000000 * (10 ** uint256(decimals)); // 200,000,000 PTNX - 20%
966     uint256 public constant FOUNDERS_AND_EMPLOYEES_SUPPLY = 200000000 * (10 ** uint256(decimals)); // 200,000,000 PTNX - 20%
967     uint256 public constant AIRDROPS_POOL_SUPPLY = 100000000 * (10 ** uint256(decimals)); // 100,000,000 PTNX - 10%
968     uint256 public constant RESERVES_POOL_SUPPLY = 100000000 * (10 ** uint256(decimals)); // 100,000,000 PTNX - 10%
969     uint256 public constant ADVISORS_POOL_SUPPLY = 70000000 * (10 ** uint256(decimals)); // 70,000,000 PTNX - 7%
970     uint256 public constant ECOSYSTEM_POOL_SUPPLY = 30000000 * (10 ** uint256(decimals)); // 30,000,000 PTNX - 3%
971 
972     // HOLDERS
973     address public PRE_ICO_POOL; // solium-disable-line mixedcase
974     address public LIQUID_POOL; // solium-disable-line mixedcase
975     address public ICO; // solium-disable-line mixedcase
976     address public MINING_POOL; // solium-disable-line mixedcase 
977     address public FOUNDERS_POOL; // solium-disable-line mixedcase
978     address public EMPLOYEES_POOL; // solium-disable-line mixedcase 
979     address public AIRDROPS_POOL; // solium-disable-line mixedcase 
980     address public RESERVES_POOL; // solium-disable-line mixedcase 
981     address public ADVISORS_POOL; // solium-disable-line mixedcase
982     address public ECOSYSTEM_POOL; // solium-disable-line mixedcase 
983 
984     // HOLDER AMOUNT AS PART OF SUPPLY
985     // SALES_SUPPLY = PRE_ICO_POOL_AMOUNT + LIQUID_POOL_AMOUNT + ICO_AMOUNT
986     uint256 public constant PRE_ICO_POOL_AMOUNT = 20000000 * (10 ** uint256(decimals)); // 20,000,000 PTNX
987     uint256 public constant LIQUID_POOL_AMOUNT = 100000000 * (10 ** uint256(decimals)); // 100,000,000 PTNX
988     uint256 public constant ICO_AMOUNT = 180000000 * (10 ** uint256(decimals)); // 180,000,000 PTNX
989     // FOUNDERS_AND_EMPLOYEES_SUPPLY = FOUNDERS_POOL_AMOUNT + EMPLOYEES_POOL_AMOUNT
990     uint256 public constant FOUNDERS_POOL_AMOUNT = 190000000 * (10 ** uint256(decimals)); // 190,000,000 PTNX
991     uint256 public constant EMPLOYEES_POOL_AMOUNT = 10000000 * (10 ** uint256(decimals)); // 10,000,000 PTNX
992 
993     // Unsold tokens reserve address
994     address public UNSOLD_RESERVE; // solium-disable-line mixedcase
995 
996     // Tokens ico sale with lockup period
997     uint256 public constant ICO_LOCKUP_PERIOD = 182 days;
998     
999     // Platin Token ICO rate, regular
1000     uint256 public constant TOKEN_RATE = 1000; 
1001 
1002     // Platin Token ICO rate with lockup, 20% bonus
1003     uint256 public constant TOKEN_RATE_LOCKUP = 1200;
1004 
1005     // Platin ICO min purchase amount
1006     uint256 public constant MIN_PURCHASE_AMOUNT = 1 ether;
1007 
1008     // Platin Token contract
1009     PlatinToken public token;
1010 
1011     // TGE time
1012     uint256 public tgeTime;
1013 
1014 
1015     /**
1016      * @dev Constructor
1017      * @param _tgeTime uint256 TGE moment of time
1018      * @param _token address Address of the Platin Token contract       
1019      * @param _preIcoPool address Address of the Platin PreICO Pool
1020      * @param _liquidPool address Address of the Platin Liquid Pool
1021      * @param _ico address Address of the Platin ICO contract
1022      * @param _miningPool address Address of the Platin Mining Pool
1023      * @param _foundersPool address Address of the Platin Founders Pool
1024      * @param _employeesPool address Address of the Platin Employees Pool
1025      * @param _airdropsPool address Address of the Platin Airdrops Pool
1026      * @param _reservesPool address Address of the Platin Reserves Pool
1027      * @param _advisorsPool address Address of the Platin Advisors Pool
1028      * @param _ecosystemPool address Address of the Platin Ecosystem Pool  
1029      * @param _unsoldReserve address Address of the Platin Unsold Reserve                                 
1030      */  
1031     constructor(
1032         uint256 _tgeTime,
1033         PlatinToken _token, 
1034         address _preIcoPool,
1035         address _liquidPool,
1036         address _ico,
1037         address _miningPool,
1038         address _foundersPool,
1039         address _employeesPool,
1040         address _airdropsPool,
1041         address _reservesPool,
1042         address _advisorsPool,
1043         address _ecosystemPool,
1044         address _unsoldReserve
1045     ) public {
1046         require(_tgeTime >= block.timestamp, "TGE time should be >= current time."); // solium-disable-line security/no-block-members
1047         require(_token != address(0), "Token address can't be zero.");
1048         require(_preIcoPool != address(0), "PreICO Pool address can't be zero.");
1049         require(_liquidPool != address(0), "Liquid Pool address can't be zero.");
1050         require(_ico != address(0), "ICO address can't be zero.");
1051         require(_miningPool != address(0), "Mining Pool address can't be zero.");
1052         require(_foundersPool != address(0), "Founders Pool address can't be zero.");
1053         require(_employeesPool != address(0), "Employees Pool address can't be zero.");
1054         require(_airdropsPool != address(0), "Airdrops Pool address can't be zero.");
1055         require(_reservesPool != address(0), "Reserves Pool address can't be zero.");
1056         require(_advisorsPool != address(0), "Advisors Pool address can't be zero.");
1057         require(_ecosystemPool != address(0), "Ecosystem Pool address can't be zero.");
1058         require(_unsoldReserve != address(0), "Unsold reserve address can't be zero.");
1059 
1060         // Setup tge time
1061         tgeTime = _tgeTime;
1062 
1063         // Setup token address
1064         token = _token;
1065 
1066         // Setup holder addresses
1067         PRE_ICO_POOL = _preIcoPool;
1068         LIQUID_POOL = _liquidPool;
1069         ICO = _ico;
1070         MINING_POOL = _miningPool;
1071         FOUNDERS_POOL = _foundersPool;
1072         EMPLOYEES_POOL = _employeesPool;
1073         AIRDROPS_POOL = _airdropsPool;
1074         RESERVES_POOL = _reservesPool;
1075         ADVISORS_POOL = _advisorsPool;
1076         ECOSYSTEM_POOL = _ecosystemPool;
1077 
1078         // Setup unsold reserve address
1079         UNSOLD_RESERVE = _unsoldReserve; 
1080     }
1081 
1082     /**
1083      * @dev Allocate function. Token Generation Event entry point.
1084      * It makes initial token allocation according to the initial token supply constants.
1085      */
1086     function allocate() public {
1087 
1088         // Should be called just after tge time
1089         require(block.timestamp >= tgeTime, "Should be called just after tge time."); // solium-disable-line security/no-block-members
1090 
1091         // Should not be allocated already
1092         require(token.totalSupply() == 0, "Allocation is already done.");
1093 
1094         // SALES          
1095         token.allocate(PRE_ICO_POOL, PRE_ICO_POOL_AMOUNT);
1096         token.allocate(LIQUID_POOL, LIQUID_POOL_AMOUNT);
1097         token.allocate(ICO, ICO_AMOUNT);
1098       
1099         // MINING POOL
1100         token.allocate(MINING_POOL, MINING_POOL_SUPPLY);
1101 
1102         // FOUNDERS AND EMPLOYEES
1103         token.allocate(FOUNDERS_POOL, FOUNDERS_POOL_AMOUNT);
1104         token.allocate(EMPLOYEES_POOL, EMPLOYEES_POOL_AMOUNT);
1105 
1106         // AIRDROPS POOL
1107         token.allocate(AIRDROPS_POOL, AIRDROPS_POOL_SUPPLY);
1108 
1109         // RESERVES POOL
1110         token.allocate(RESERVES_POOL, RESERVES_POOL_SUPPLY);
1111 
1112         // ADVISORS POOL
1113         token.allocate(ADVISORS_POOL, ADVISORS_POOL_SUPPLY);
1114 
1115         // ECOSYSTEM POOL
1116         token.allocate(ECOSYSTEM_POOL, ECOSYSTEM_POOL_SUPPLY);
1117 
1118         // Check Token Total Supply
1119         require(token.totalSupply() == TOTAL_SUPPLY, "Total supply check error.");   
1120     }
1121 }