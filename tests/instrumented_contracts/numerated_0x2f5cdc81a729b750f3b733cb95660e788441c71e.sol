1 pragma solidity ^0.4.19;
2 
3 // File: contracts/storage/interface/RocketStorageInterface.sol
4 
5 // Our eternal storage interface
6 contract RocketStorageInterface {
7     // Modifiers
8     modifier onlyLatestRocketNetworkContract() {_;}
9     // Getters
10     function getAddress(bytes32 _key) external view returns (address);
11     function getUint(bytes32 _key) external view returns (uint);
12     function getString(bytes32 _key) external view returns (string);
13     function getBytes(bytes32 _key) external view returns (bytes);
14     function getBool(bytes32 _key) external view returns (bool);
15     function getInt(bytes32 _key) external view returns (int);
16     // Setters
17     function setAddress(bytes32 _key, address _value) onlyLatestRocketNetworkContract external;
18     function setUint(bytes32 _key, uint _value) onlyLatestRocketNetworkContract external;
19     function setString(bytes32 _key, string _value) onlyLatestRocketNetworkContract external;
20     function setBytes(bytes32 _key, bytes _value) onlyLatestRocketNetworkContract external;
21     function setBool(bytes32 _key, bool _value) onlyLatestRocketNetworkContract external;
22     function setInt(bytes32 _key, int _value) onlyLatestRocketNetworkContract external;
23     // Deleters
24     function deleteAddress(bytes32 _key) onlyLatestRocketNetworkContract external;
25     function deleteUint(bytes32 _key) onlyLatestRocketNetworkContract external;
26     function deleteString(bytes32 _key) onlyLatestRocketNetworkContract external;
27     function deleteBytes(bytes32 _key) onlyLatestRocketNetworkContract external;
28     function deleteBool(bytes32 _key) onlyLatestRocketNetworkContract external;
29     function deleteInt(bytes32 _key) onlyLatestRocketNetworkContract external;
30     // Hash helpers
31     function kcck256str(string _key1) external pure returns (bytes32);
32     function kcck256strstr(string _key1, string _key2) external pure returns (bytes32);
33     function kcck256stradd(string _key1, address _key2) external pure returns (bytes32);
34     function kcck256straddadd(string _key1, address _key2, address _key3) external pure returns (bytes32);
35 }
36 
37 // File: contracts/storage/RocketBase.sol
38 
39 /// @title Base settings / modifiers for each contract in Rocket Pool
40 /// @author David Rugendyke
41 contract RocketBase {
42 
43     /*** Events ****************/
44 
45     event ContractAdded (
46         address indexed _newContractAddress,                    // Address of the new contract
47         uint256 created                                         // Creation timestamp
48     );
49 
50     event ContractUpgraded (
51         address indexed _oldContractAddress,                    // Address of the contract being upgraded
52         address indexed _newContractAddress,                    // Address of the new contract
53         uint256 created                                         // Creation timestamp
54     );
55 
56     /**** Properties ************/
57 
58     uint8 public version;                                                   // Version of this contract
59 
60 
61     /*** Contracts **************/
62 
63     RocketStorageInterface rocketStorage = RocketStorageInterface(0);       // The main storage contract where primary persistant storage is maintained
64 
65 
66     /*** Modifiers ************/
67 
68     /**
69     * @dev Throws if called by any account other than the owner.
70     */
71     modifier onlyOwner() {
72         roleCheck("owner", msg.sender);
73         _;
74     }
75 
76     /**
77     * @dev Modifier to scope access to admins
78     */
79     modifier onlyAdmin() {
80         roleCheck("admin", msg.sender);
81         _;
82     }
83 
84     /**
85     * @dev Modifier to scope access to admins
86     */
87     modifier onlySuperUser() {
88         require(roleHas("owner", msg.sender) || roleHas("admin", msg.sender));
89         _;
90     }
91 
92     /**
93     * @dev Reverts if the address doesn't have this role
94     */
95     modifier onlyRole(string _role) {
96         roleCheck(_role, msg.sender);
97         _;
98     }
99 
100   
101     /*** Constructor **********/
102    
103     /// @dev Set the main Rocket Storage address
104     constructor(address _rocketStorageAddress) public {
105         // Update the contract address
106         rocketStorage = RocketStorageInterface(_rocketStorageAddress);
107     }
108 
109 
110     /*** Role Utilities */
111 
112     /**
113     * @dev Check if an address is an owner
114     * @return bool
115     */
116     function isOwner(address _address) public view returns (bool) {
117         return rocketStorage.getBool(keccak256("access.role", "owner", _address));
118     }
119 
120     /**
121     * @dev Check if an address has this role
122     * @return bool
123     */
124     function roleHas(string _role, address _address) internal view returns (bool) {
125         return rocketStorage.getBool(keccak256("access.role", _role, _address));
126     }
127 
128      /**
129     * @dev Check if an address has this role, reverts if it doesn't
130     */
131     function roleCheck(string _role, address _address) view internal {
132         require(roleHas(_role, _address) == true);
133     }
134 
135 }
136 
137 // File: contracts/Authorized.sol
138 
139 /**
140  * @title Authorized
141  * @dev The Authorized contract has an issuer, depository, and auditor address, and provides basic 
142  * authorization control functions, this simplifies the implementation of "user permissions".
143  */
144 contract Authorized is RocketBase {
145 
146     // The issuer's address
147     // In contract's RocketStorage 
148     // address public token.issuer;
149 
150     // The depository's address
151     // In contract's RocketStorage 
152     // address public token.depository;
153 
154     // The auditor's address
155     // In contract's RocketStorage 
156     // address public token.auditor;
157 
158     event IssuerTransferred(address indexed previousIssuer, address indexed newIssuer);
159     event AuditorTransferred(address indexed previousAuditor, address indexed newAuditor);
160     event DepositoryTransferred(address indexed previousDepository, address indexed newDepository);
161 
162     /* 
163      *  Modifiers
164      */
165 
166     // Ensure sender is issuer   
167     modifier onlyIssuer {
168         require( msg.sender == issuer() );
169         _;
170     }
171 
172     // Ensure sender is depository
173     modifier onlyDepository {
174         require( msg.sender == depository() );
175         _;
176     }
177 
178     // Ensure sender is auditor
179     modifier onlyAuditor {
180         require( msg.sender == auditor() );
181         _;
182     }
183 
184 
185   /**
186    * @dev Allows the current owner to explicity assign a new issuer.
187    * @param newIssuer The address of the new issuer.
188    */
189   function setIssuer(address newIssuer) public onlyOwner {
190     require(newIssuer != address(0));
191     rocketStorage.setAddress(keccak256("token.issuer"), newIssuer);
192     emit IssuerTransferred(issuer(), newIssuer);
193   }
194 
195   /**
196    * @dev Get the current issuer address from storage.
197    */
198   function issuer() public view returns (address) {
199     return rocketStorage.getAddress(keccak256("token.issuer"));
200   }
201 
202   /**
203    * @dev Allows the current owner to explicity assign a new auditor.
204    * @param newAuditor The address of the new auditor.
205    */
206   function setAuditor(address newAuditor) public onlyOwner {
207     require(newAuditor != address(0));
208     rocketStorage.setAddress(keccak256("token.auditor"), newAuditor);
209     emit AuditorTransferred(auditor(), newAuditor);
210   }
211 
212   /**
213    * @dev Get the current auditor address from storage.
214    */
215   function auditor() public view returns (address) {
216     return rocketStorage.getAddress(keccak256("token.auditor"));
217   }
218 
219   /**
220    * @dev Allows the current owner to explicity assign a new depository.
221    * @param newDepository The address of the new depository.
222    */
223   function setDepository(address newDepository) public onlyOwner {
224     require(newDepository != address(0));
225     rocketStorage.setAddress(keccak256("token.depository"), newDepository);
226     emit DepositoryTransferred(depository(), newDepository);
227   }
228 
229   /**
230    * @dev Get the current depository address from storage.
231    */
232   function depository() public view returns (address) {
233     return rocketStorage.getAddress(keccak256("token.depository"));
234   }
235 
236 }
237 
238 // File: contracts/PausableRedemption.sol
239 
240 /**
241  * @title PausableRedemption
242  * @dev Base contract which allows children to implement an emergency stop mechanism, specifically for redemption.
243  */
244 contract PausableRedemption is RocketBase {
245   event PauseRedemption();
246   event UnpauseRedemption();
247 
248   // Whether redemption is paused or not
249   // Stored in RocketStorage
250   // bool public token.redemptionPaused = false;
251 
252   /**
253    * @dev Modifier to make a function callable only when the contract redemption is not paused.
254    */
255   modifier whenRedemptionNotPaused() {
256     require(!redemptionPaused());
257     _;
258   }
259 
260   /**
261    * @dev Modifier to make a function callable only when the contract redemption is paused.
262    */
263   modifier whenRedemptionPaused() {
264     require(redemptionPaused());
265     _;
266   }
267 
268   /**
269    * @dev returns the redemptionPaused status from contract storage
270    */
271   function redemptionPaused() public view returns (bool) {
272     return rocketStorage.getBool(keccak256("token.redemptionPaused"));
273   }
274 
275   /**
276    * @dev called by the owner to pause, triggers stopped state
277    */
278   function pauseRedemption() onlyOwner whenRedemptionNotPaused public {
279     rocketStorage.setBool(keccak256("token.redemptionPaused"), true);
280     emit PauseRedemption();
281   }
282 
283   /**
284    * @dev called by the owner to unpause redemption, returns to normal state
285    */
286   function unpauseRedemption() onlyOwner whenRedemptionPaused public {
287     rocketStorage.setBool(keccak256("token.redemptionPaused"), false);
288     emit UnpauseRedemption();
289   }
290 }
291 
292 // File: zeppelin-solidity/contracts/math/SafeMath.sol
293 
294 /**
295  * @title SafeMath
296  * @dev Math operations with safety checks that throw on error
297  */
298 library SafeMath {
299 
300   /**
301   * @dev Multiplies two numbers, throws on overflow.
302   */
303   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
304     if (a == 0) {
305       return 0;
306     }
307     uint256 c = a * b;
308     assert(c / a == b);
309     return c;
310   }
311 
312   /**
313   * @dev Integer division of two numbers, truncating the quotient.
314   */
315   function div(uint256 a, uint256 b) internal pure returns (uint256) {
316     // assert(b > 0); // Solidity automatically throws when dividing by 0
317     uint256 c = a / b;
318     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
319     return c;
320   }
321 
322   /**
323   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
324   */
325   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
326     assert(b <= a);
327     return a - b;
328   }
329 
330   /**
331   * @dev Adds two numbers, throws on overflow.
332   */
333   function add(uint256 a, uint256 b) internal pure returns (uint256) {
334     uint256 c = a + b;
335     assert(c >= a);
336     return c;
337   }
338 }
339 
340 // File: contracts/Issuable.sol
341 
342 contract Issuable is RocketBase, Authorized, PausableRedemption {
343     using SafeMath for uint256;
344 
345     event AssetsUpdated(address indexed depository, uint256 amount);
346     event CertificationUpdated(address indexed auditor, uint256 amount);
347 
348     // Get assetsOnDeposit
349     function assetsOnDeposit() public view returns (uint256) {
350         return rocketStorage.getUint(keccak256("issuable.assetsOnDeposit"));
351     }
352 
353     // Get assetsCertified
354     function assetsCertified() public view returns (uint256) {
355         return rocketStorage.getUint(keccak256("issuable.assetsCertified"));
356     }
357 
358     /******* For paused redemption *******/
359 
360     // Set assetsOnDeposit
361     function setAssetsOnDeposit(uint256 _total) public onlyDepository whenRedemptionPaused {
362         uint256 totalSupply_ = rocketStorage.getUint(keccak256("token.totalSupply"));
363         require(_total >= totalSupply_);
364         rocketStorage.setUint(keccak256("issuable.assetsOnDeposit"), _total);
365         emit AssetsUpdated(msg.sender, _total);
366     }
367 
368     // Set assetsCertified
369     function setAssetsCertified(uint256 _total) public onlyAuditor whenRedemptionPaused {
370         uint256 totalSupply_ = rocketStorage.getUint(keccak256("token.totalSupply"));
371         require(_total >= totalSupply_);
372         rocketStorage.setUint(keccak256("issuable.assetsCertified"), _total);
373         emit CertificationUpdated(msg.sender, _total);
374     }
375 
376     /******* For during both paused and non-paused redemption *******/
377 
378     // Depository can receive assets (increasing)
379     function receiveAssets(uint256 _units) public onlyDepository {
380         uint256 total_ = assetsOnDeposit().add(_units);
381         rocketStorage.setUint(keccak256("issuable.assetsOnDeposit"), total_);
382         emit AssetsUpdated(msg.sender, total_);
383     }
384 
385     // Depository can release assets (decreasing), but never to less than the totalSupply
386     function releaseAssets(uint256 _units) public onlyDepository {
387         uint256 totalSupply_ = rocketStorage.getUint(keccak256("token.totalSupply"));
388         uint256 total_ = assetsOnDeposit().sub(_units);
389         require(total_ >= totalSupply_);
390         rocketStorage.setUint(keccak256("issuable.assetsOnDeposit"), total_);
391         emit AssetsUpdated(msg.sender, total_);
392     }
393 
394     // Auditor can increase certified assets
395     function increaseAssetsCertified(uint256 _units) public onlyAuditor {
396         uint256 total_ = assetsCertified().add(_units);
397         rocketStorage.setUint(keccak256("issuable.assetsCertified"), total_);
398         emit CertificationUpdated(msg.sender, total_);
399     }
400 
401     // Auditor can decrease certified assets
402     function decreaseAssetsCertified(uint256 _units) public onlyAuditor {
403         uint256 totalSupply_ = rocketStorage.getUint(keccak256("token.totalSupply"));
404         uint256 total_ = assetsCertified().sub(_units);
405         require(total_ >= totalSupply_);
406         rocketStorage.setUint(keccak256("issuable.assetsCertified"), total_);
407         emit CertificationUpdated(msg.sender, total_);
408     }
409 
410 }
411 
412 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
413 
414 /**
415  * @title ERC20Basic
416  * @dev Simpler version of ERC20 interface
417  * @dev see https://github.com/ethereum/EIPs/issues/179
418  */
419 contract ERC20Basic {
420   function totalSupply() public view returns (uint256);
421   function balanceOf(address who) public view returns (uint256);
422   function transfer(address to, uint256 value) public returns (bool);
423   event Transfer(address indexed from, address indexed to, uint256 value);
424 }
425 
426 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
427 
428 /**
429  * @title ERC20 interface
430  * @dev see https://github.com/ethereum/EIPs/issues/20
431  */
432 contract ERC20 is ERC20Basic {
433   function allowance(address owner, address spender) public view returns (uint256);
434   function transferFrom(address from, address to, uint256 value) public returns (bool);
435   function approve(address spender, uint256 value) public returns (bool);
436   event Approval(address indexed owner, address indexed spender, uint256 value);
437 }
438 
439 // File: contracts/LD2Token.sol
440 
441 /// @title The primary ERC20 token contract, using LD2 storage
442 /// @author Steven Brendtro
443 contract LD2Token is ERC20, RocketBase, Issuable {
444   using SafeMath for uint256;
445 
446   event TokensIssued(address indexed issuer, uint256 amount);
447 
448   // The balances of the token, per ERC20, but stored in contract storage (rocketStorage)
449   // mapping(address => uint256) token.balances;
450 
451   // The totalSupply of the token, per ERC20, but stored in contract storage (rocketStorage)
452   // uint256 token.totalSupply;
453 
454   // The authorizations of the token, per ERC20, but stored in contract storage (rocketStorage)
455   // This is accomplished by hashing token.allowed + _fromAddr + _toAddr
456   // mapping (address => mapping (address => uint256)) internal allowed;
457 
458   /**
459   * @dev total number of tokens in existence
460   */
461   function totalSupply() public view returns (uint256) {
462     return rocketStorage.getUint(keccak256("token.totalSupply"));
463   }
464 
465   /**
466   * @dev increase total number of tokens in existence
467   */
468   function increaseTotalSupply(uint256 _increase) internal {
469     uint256 totalSupply_ = totalSupply();
470     totalSupply_ = totalSupply_.add(_increase);
471     rocketStorage.setUint(keccak256("token.totalSupply"),totalSupply_);
472   }
473 
474   /**
475   * @dev decrease total number of tokens in existence
476   */
477   function decreaseTotalSupply(uint256 _decrease) internal {
478     uint256 totalSupply_ = totalSupply();
479     totalSupply_ = totalSupply_.sub(_decrease);
480     rocketStorage.setUint(keccak256("token.totalSupply"),totalSupply_);
481   }
482 
483   /**
484   * @dev transfer token for a specified address
485   * @param _to The address to transfer to.
486   * @param _value The amount to be transferred.
487   */
488   function transfer(address _to, uint256 _value) public returns (bool) {
489     require(_to != address(0));
490     require(_value <= balanceOf(msg.sender));
491 
492     // SafeMath.sub will throw if there is not enough balance.
493     // Use the contract storage
494     setBalanceOf(msg.sender, balanceOf(msg.sender).sub(_value));
495     setBalanceOf(_to, balanceOf(_to).add(_value));
496     emit Transfer(msg.sender, _to, _value);
497     return true;
498   }
499 
500   /**
501   * @dev Gets the balance of the specified address.
502   * @param _owner The address to query the the balance of.
503   * @return An uint256 representing the amount owned by the passed address.
504   */
505   function balanceOf(address _owner) public view returns (uint256 balance) {
506     return rocketStorage.getUint(keccak256("token.balances",_owner));
507   }
508 
509   /**
510   * @dev Updates the balance of the specified address.
511   * @param _owner The address to query the the balance of.
512   * @param _balance An uint256 representing the amount owned by the passed address.
513   */
514   function setBalanceOf(address _owner, uint256 _balance) internal {
515     rocketStorage.setUint(keccak256("token.balances",_owner), _balance);
516   }
517 
518   /**
519    * @dev Function to check the amount of tokens that an owner allowed to a spender.
520    * @param _owner address The address which owns the funds.
521    * @param _spender address The address which will spend the funds.
522    * @return A uint256 specifying the amount of tokens still available for the spender.
523    */
524   function allowance(address _owner, address _spender) public view returns (uint256) {
525     return rocketStorage.getUint(keccak256("token.allowed",_owner,_spender));
526   }
527 
528   /**
529   * @dev Updates the allowance by _owner of the _spender to have access to _balance.
530   * @param _owner The address to query the the balance of.
531   * @param _spender The address which will spend the funds
532   * @param _balance An uint256 representing the amount owned by the passed address.
533   */
534   function setAllowance(address _owner, address _spender, uint256 _balance) internal {
535     rocketStorage.setUint(keccak256("token.allowed",_owner,_spender), _balance);
536   }
537 
538   /**
539    * @dev Transfer tokens from one address to another
540    * @param _from address The address which you want to send tokens from
541    * @param _to address The address which you want to transfer to
542    * @param _value uint256 the amount of tokens to be transferred
543    */
544   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
545     require(_to != address(0));
546     require(_value <= balanceOf(_from));
547     require(_value <= allowance(_from, msg.sender));
548     
549     setBalanceOf(_from, balanceOf(_from).sub(_value));
550     setBalanceOf(_to, balanceOf(_to).add(_value));
551     setAllowance(_from, msg.sender, allowance(_from, msg.sender).sub(_value));
552     emit Transfer(_from, _to, _value);
553     return true;
554   }
555 
556   /**
557    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
558    *
559    * Beware that changing an allowance with this method brings the risk that someone may use both the old
560    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
561    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
562    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
563    * @param _spender The address which will spend the funds.
564    * @param _value The amount of tokens to be spent.
565    */
566   function approve(address _spender, uint256 _value) public returns (bool) {
567     setAllowance(msg.sender, _spender, _value);
568     emit Approval(msg.sender, _spender, _value);
569     return true;
570   }
571 
572   /**
573    * @dev Increase the amount of tokens that an owner allowed to a spender.
574    *
575    * approve should be called when allowed[_spender] == 0. To increment
576    * allowed value is better to use this function to avoid 2 calls (and wait until
577    * the first transaction is mined)
578    * From MonolithDAO Token.sol
579    * @param _spender The address which will spend the funds.
580    * @param _addedValue The amount of tokens to increase the allowance by.
581    */
582   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
583     setAllowance(msg.sender, _spender, allowance(msg.sender, _spender).add(_addedValue));
584     emit Approval(msg.sender, _spender, allowance(msg.sender, _spender));
585     return true;
586   }
587 
588   /**
589    * @dev Decrease the amount of tokens that an owner allowed to a spender.
590    *
591    * approve should be called when allowed[_spender] == 0. To decrement
592    * allowed value is better to use this function to avoid 2 calls (and wait until
593    * the first transaction is mined)
594    * From MonolithDAO Token.sol
595    * @param _spender The address which will spend the funds.
596    * @param _subtractedValue The amount of tokens to decrease the allowance by.
597    */
598   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
599     uint oldValue = allowance(msg.sender, _spender);
600     if (_subtractedValue > oldValue) {
601       setAllowance(msg.sender, _spender, 0);
602     } else {
603       setAllowance(msg.sender, _spender, oldValue.sub(_subtractedValue));
604     }
605     emit Approval(msg.sender, _spender, allowance(msg.sender, _spender));
606     return true;
607   }
608 
609 
610   /**
611    * @dev Decrease the amount of tokens that an owner allowed to a spender.
612    *
613    * Issuer can only issue tokens up to the lesser of assetsOnDeposit and
614    * assetsCertified.  This prevents issuing uncertified tokens and ensures
615    * that every token issued has exactly one unit of the asset backing it.
616    * @param _units Total amount of additional tokens to issue
617    */
618   function issueTokensForAssets( uint256 _units ) public onlyIssuer {
619 
620     uint256 newSupply_ = totalSupply().add(_units);
621 
622     // Find the greater of assetsOnDeposit and assetsCertified
623     uint256 limit_ = 0;
624     if ( assetsOnDeposit() > assetsCertified() )
625       limit_ = assetsOnDeposit();
626     else
627       limit_ = assetsCertified();
628 
629     // the new supply can't be larger than our issuance limit
630     require( newSupply_ <= limit_ );
631 
632     // Increase the total supply
633     increaseTotalSupply( _units );
634 
635     // Increase the issuer's balance
636     setBalanceOf(issuer(), balanceOf(issuer()).add(_units));
637 
638     emit TokensIssued(issuer(), _units);
639   }
640 
641 }
642 
643 // File: contracts/LD2Zero.sol
644 
645 /// @title The LD2-style ERC20 token for LD2.zero
646 /// @author Steven Brendtro
647 contract LD2Zero is LD2Token {
648 
649   string public name = "LD2.zero";
650   string public symbol = "XLDZ";
651   // Decimals are stored in RocketStorage
652   // uint8 public token.decimals = 18;
653 
654   /*** Constructor ***********/
655 
656   /// @dev LD2Zero constructor
657   constructor(address _rocketStorageAddress) RocketBase(_rocketStorageAddress) public {
658     // Set the decimals
659     if(decimals() == 0) {
660       rocketStorage.setUint(keccak256("token.decimals"),18);
661     }
662   }
663 
664   function decimals() public view returns (uint8) {
665     return uint8(rocketStorage.getUint(keccak256("token.decimals")));
666   }
667 
668 }