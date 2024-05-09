1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Interface to be implemented by all checkpoint modules
5  */
6 /*solium-disable-next-line no-empty-blocks*/
7 interface ICheckpoint {
8 
9 }
10 
11 /**
12  * @title Interface that every module contract should implement
13  */
14 interface IModule {
15 
16     /**
17      * @notice This function returns the signature of configure function
18      */
19     function getInitFunction() external pure returns (bytes4);
20 
21     /**
22      * @notice Return the permission flags that are associated with a module
23      */
24     function getPermissions() external view returns(bytes32[]);
25 
26     /**
27      * @notice Used to withdraw the fee by the factory owner
28      */
29     function takeFee(uint256 _amount) external returns(bool);
30 
31 }
32 
33 /**
34  * @title Interface for all security tokens
35  */
36 interface ISecurityToken {
37 
38     // Standard ERC20 interface
39     function decimals() external view returns (uint8);
40     function totalSupply() external view returns (uint256);
41     function balanceOf(address _owner) external view returns (uint256);
42     function allowance(address _owner, address _spender) external view returns (uint256);
43     function transfer(address _to, uint256 _value) external returns (bool);
44     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
45     function approve(address _spender, uint256 _value) external returns (bool);
46     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
47     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 
51     //transfer, transferFrom must respect the result of verifyTransfer
52     function verifyTransfer(address _from, address _to, uint256 _value) external returns (bool success);
53 
54     /**
55      * @notice Mints new tokens and assigns them to the target _investor.
56      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
57      * @param _investor Address the tokens will be minted to
58      * @param _value is the amount of tokens that will be minted to the investor
59      */
60     function mint(address _investor, uint256 _value) external returns (bool success);
61 
62     /**
63      * @notice Mints new tokens and assigns them to the target _investor.
64      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
65      * @param _investor Address the tokens will be minted to
66      * @param _value is The amount of tokens that will be minted to the investor
67      * @param _data Data to indicate validation
68      */
69     function mintWithData(address _investor, uint256 _value, bytes _data) external returns (bool success);
70 
71     /**
72      * @notice Used to burn the securityToken on behalf of someone else
73      * @param _from Address for whom to burn tokens
74      * @param _value No. of tokens to be burned
75      * @param _data Data to indicate validation
76      */
77     function burnFromWithData(address _from, uint256 _value, bytes _data) external;
78 
79     /**
80      * @notice Used to burn the securityToken
81      * @param _value No. of tokens to be burned
82      * @param _data Data to indicate validation
83      */
84     function burnWithData(uint256 _value, bytes _data) external;
85 
86     event Minted(address indexed _to, uint256 _value);
87     event Burnt(address indexed _burner, uint256 _value);
88 
89     // Permissions this to a Permission module, which has a key of 1
90     // If no Permission return false - note that IModule withPerm will allow ST owner all permissions anyway
91     // this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
92     function checkPermission(address _delegate, address _module, bytes32 _perm) external view returns (bool);
93 
94     /**
95      * @notice Returns module list for a module type
96      * @param _module Address of the module
97      * @return bytes32 Name
98      * @return address Module address
99      * @return address Module factory address
100      * @return bool Module archived
101      * @return uint8 Module type
102      * @return uint256 Module index
103      * @return uint256 Name index
104 
105      */
106     function getModule(address _module) external view returns(bytes32, address, address, bool, uint8, uint256, uint256);
107 
108     /**
109      * @notice Returns module list for a module name
110      * @param _name Name of the module
111      * @return address[] List of modules with this name
112      */
113     function getModulesByName(bytes32 _name) external view returns (address[]);
114 
115     /**
116      * @notice Returns module list for a module type
117      * @param _type Type of the module
118      * @return address[] List of modules with this type
119      */
120     function getModulesByType(uint8 _type) external view returns (address[]);
121 
122     /**
123      * @notice Queries totalSupply at a specified checkpoint
124      * @param _checkpointId Checkpoint ID to query as of
125      */
126     function totalSupplyAt(uint256 _checkpointId) external view returns (uint256);
127 
128     /**
129      * @notice Queries balance at a specified checkpoint
130      * @param _investor Investor to query balance for
131      * @param _checkpointId Checkpoint ID to query as of
132      */
133     function balanceOfAt(address _investor, uint256 _checkpointId) external view returns (uint256);
134 
135     /**
136      * @notice Creates a checkpoint that can be used to query historical balances / totalSuppy
137      */
138     function createCheckpoint() external returns (uint256);
139 
140     /**
141      * @notice Gets length of investors array
142      * NB - this length may differ from investorCount if the list has not been pruned of zero-balance investors
143      * @return Length
144      */
145     function getInvestors() external view returns (address[]);
146 
147     /**
148      * @notice returns an array of investors at a given checkpoint
149      * NB - this length may differ from investorCount as it contains all investors that ever held tokens
150      * @param _checkpointId Checkpoint id at which investor list is to be populated
151      * @return list of investors
152      */
153     function getInvestorsAt(uint256 _checkpointId) external view returns(address[]);
154 
155     /**
156      * @notice generates subset of investors
157      * NB - can be used in batches if investor list is large
158      * @param _start Position of investor to start iteration from
159      * @param _end Position of investor to stop iteration at
160      * @return list of investors
161      */
162     function iterateInvestors(uint256 _start, uint256 _end) external view returns(address[]);
163     
164     /**
165      * @notice Gets current checkpoint ID
166      * @return Id
167      */
168     function currentCheckpointId() external view returns (uint256);
169 
170     /**
171     * @notice Gets an investor at a particular index
172     * @param _index Index to return address from
173     * @return Investor address
174     */
175     function investors(uint256 _index) external view returns (address);
176 
177    /**
178     * @notice Allows the owner to withdraw unspent POLY stored by them on the ST or any ERC20 token.
179     * @dev Owner can transfer POLY to the ST which will be used to pay for modules that require a POLY fee.
180     * @param _tokenContract Address of the ERC20Basic compliance token
181     * @param _value Amount of POLY to withdraw
182     */
183     function withdrawERC20(address _tokenContract, uint256 _value) external;
184 
185     /**
186     * @notice Allows owner to approve more POLY to one of the modules
187     * @param _module Module address
188     * @param _budget New budget
189     */
190     function changeModuleBudget(address _module, uint256 _budget) external;
191 
192     /**
193      * @notice Changes the tokenDetails
194      * @param _newTokenDetails New token details
195      */
196     function updateTokenDetails(string _newTokenDetails) external;
197 
198     /**
199     * @notice Allows the owner to change token granularity
200     * @param _granularity Granularity level of the token
201     */
202     function changeGranularity(uint256 _granularity) external;
203 
204     /**
205     * @notice Removes addresses with zero balances from the investors list
206     * @param _start Index in investors list at which to start removing zero balances
207     * @param _iters Max number of iterations of the for loop
208     * NB - pruning this list will mean you may not be able to iterate over investors on-chain as of a historical checkpoint
209     */
210     function pruneInvestors(uint256 _start, uint256 _iters) external;
211 
212     /**
213      * @notice Freezes all the transfers
214      */
215     function freezeTransfers() external;
216 
217     /**
218      * @notice Un-freezes all the transfers
219      */
220     function unfreezeTransfers() external;
221 
222     /**
223      * @notice Ends token minting period permanently
224      */
225     function freezeMinting() external;
226 
227     /**
228      * @notice Mints new tokens and assigns them to the target investors.
229      * Can only be called by the STO attached to the token or by the Issuer (Security Token contract owner)
230      * @param _investors A list of addresses to whom the minted tokens will be delivered
231      * @param _values A list of the amount of tokens to mint to corresponding addresses from _investor[] list
232      * @return Success
233      */
234     function mintMulti(address[] _investors, uint256[] _values) external returns (bool success);
235 
236     /**
237      * @notice Function used to attach a module to the security token
238      * @dev  E.G.: On deployment (through the STR) ST gets a TransferManager module attached to it
239      * @dev to control restrictions on transfers.
240      * @dev You are allowed to add a new moduleType if:
241      * @dev - there is no existing module of that type yet added
242      * @dev - the last member of the module list is replacable
243      * @param _moduleFactory is the address of the module factory to be added
244      * @param _data is data packed into bytes used to further configure the module (See STO usage)
245      * @param _maxCost max amount of POLY willing to pay to module. (WIP)
246      */
247     function addModule(
248         address _moduleFactory,
249         bytes _data,
250         uint256 _maxCost,
251         uint256 _budget
252     ) external;
253 
254     /**
255     * @notice Archives a module attached to the SecurityToken
256     * @param _module address of module to archive
257     */
258     function archiveModule(address _module) external;
259 
260     /**
261     * @notice Unarchives a module attached to the SecurityToken
262     * @param _module address of module to unarchive
263     */
264     function unarchiveModule(address _module) external;
265 
266     /**
267     * @notice Removes a module attached to the SecurityToken
268     * @param _module address of module to archive
269     */
270     function removeModule(address _module) external;
271 
272     /**
273      * @notice Used by the issuer to set the controller addresses
274      * @param _controller address of the controller
275      */
276     function setController(address _controller) external;
277 
278     /**
279      * @notice Used by a controller to execute a forced transfer
280      * @param _from address from which to take tokens
281      * @param _to address where to send tokens
282      * @param _value amount of tokens to transfer
283      * @param _data data to indicate validation
284      * @param _log data attached to the transfer by controller to emit in event
285      */
286     function forceTransfer(address _from, address _to, uint256 _value, bytes _data, bytes _log) external;
287 
288     /**
289      * @notice Used by a controller to execute a foced burn
290      * @param _from address from which to take tokens
291      * @param _value amount of tokens to transfer
292      * @param _data data to indicate validation
293      * @param _log data attached to the transfer by controller to emit in event
294      */
295     function forceBurn(address _from, uint256 _value, bytes _data, bytes _log) external;
296 
297     /**
298      * @notice Used by the issuer to permanently disable controller functionality
299      * @dev enabled via feature switch "disableControllerAllowed"
300      */
301      function disableController() external;
302 
303      /**
304      * @notice Used to get the version of the securityToken
305      */
306      function getVersion() external view returns(uint8[]);
307 
308      /**
309      * @notice Gets the investor count
310      */
311      function getInvestorCount() external view returns(uint256);
312 
313      /**
314       * @notice Overloaded version of the transfer function
315       * @param _to receiver of transfer
316       * @param _value value of transfer
317       * @param _data data to indicate validation
318       * @return bool success
319       */
320      function transferWithData(address _to, uint256 _value, bytes _data) external returns (bool success);
321 
322      /**
323       * @notice Overloaded version of the transferFrom function
324       * @param _from sender of transfer
325       * @param _to receiver of transfer
326       * @param _value value of transfer
327       * @param _data data to indicate validation
328       * @return bool success
329       */
330      function transferFromWithData(address _from, address _to, uint256 _value, bytes _data) external returns(bool);
331 
332      /**
333       * @notice Provides the granularity of the token
334       * @return uint256
335       */
336      function granularity() external view returns(uint256);
337 }
338 
339 /**
340  * @title ERC20 interface
341  * @dev see https://github.com/ethereum/EIPs/issues/20
342  */
343 interface IERC20 {
344     function decimals() external view returns (uint8);
345     function totalSupply() external view returns (uint256);
346     function balanceOf(address _owner) external view returns (uint256);
347     function allowance(address _owner, address _spender) external view returns (uint256);
348     function transfer(address _to, uint256 _value) external returns (bool);
349     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
350     function approve(address _spender, uint256 _value) external returns (bool);
351     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
352     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
353     event Transfer(address indexed from, address indexed to, uint256 value);
354     event Approval(address indexed owner, address indexed spender, uint256 value);
355 }
356 
357 /**
358  * @title Ownable
359  * @dev The Ownable contract has an owner address, and provides basic authorization control
360  * functions, this simplifies the implementation of "user permissions".
361  */
362 contract Ownable {
363   address public owner;
364 
365 
366   event OwnershipRenounced(address indexed previousOwner);
367   event OwnershipTransferred(
368     address indexed previousOwner,
369     address indexed newOwner
370   );
371 
372 
373   /**
374    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
375    * account.
376    */
377   constructor() public {
378     owner = msg.sender;
379   }
380 
381   /**
382    * @dev Throws if called by any account other than the owner.
383    */
384   modifier onlyOwner() {
385     require(msg.sender == owner);
386     _;
387   }
388 
389   /**
390    * @dev Allows the current owner to relinquish control of the contract.
391    */
392   function renounceOwnership() public onlyOwner {
393     emit OwnershipRenounced(owner);
394     owner = address(0);
395   }
396 
397   /**
398    * @dev Allows the current owner to transfer control of the contract to a newOwner.
399    * @param _newOwner The address to transfer ownership to.
400    */
401   function transferOwnership(address _newOwner) public onlyOwner {
402     _transferOwnership(_newOwner);
403   }
404 
405   /**
406    * @dev Transfers control of the contract to a newOwner.
407    * @param _newOwner The address to transfer ownership to.
408    */
409   function _transferOwnership(address _newOwner) internal {
410     require(_newOwner != address(0));
411     emit OwnershipTransferred(owner, _newOwner);
412     owner = _newOwner;
413   }
414 }
415 
416 /**
417  * @title Interface that any module contract should implement
418  * @notice Contract is abstract
419  */
420 contract Module is IModule {
421 
422     address public factory;
423 
424     address public securityToken;
425 
426     bytes32 public constant FEE_ADMIN = "FEE_ADMIN";
427 
428     IERC20 public polyToken;
429 
430     /**
431      * @notice Constructor
432      * @param _securityToken Address of the security token
433      * @param _polyAddress Address of the polytoken
434      */
435     constructor (address _securityToken, address _polyAddress) public {
436         securityToken = _securityToken;
437         factory = msg.sender;
438         polyToken = IERC20(_polyAddress);
439     }
440 
441     //Allows owner, factory or permissioned delegate
442     modifier withPerm(bytes32 _perm) {
443         bool isOwner = msg.sender == Ownable(securityToken).owner();
444         bool isFactory = msg.sender == factory;
445         require(isOwner||isFactory||ISecurityToken(securityToken).checkPermission(msg.sender, address(this), _perm), "Permission check failed");
446         _;
447     }
448 
449     modifier onlyOwner {
450         require(msg.sender == Ownable(securityToken).owner(), "Sender is not owner");
451         _;
452     }
453 
454     modifier onlyFactory {
455         require(msg.sender == factory, "Sender is not factory");
456         _;
457     }
458 
459     modifier onlyFactoryOwner {
460         require(msg.sender == Ownable(factory).owner(), "Sender is not factory owner");
461         _;
462     }
463 
464     modifier onlyFactoryOrOwner {
465         require((msg.sender == Ownable(securityToken).owner()) || (msg.sender == factory), "Sender is not factory or owner");
466         _;
467     }
468 
469     /**
470      * @notice used to withdraw the fee by the factory owner
471      */
472     function takeFee(uint256 _amount) public withPerm(FEE_ADMIN) returns(bool) {
473         require(polyToken.transferFrom(securityToken, Ownable(factory).owner(), _amount), "Unable to take fee");
474         return true;
475     }
476 }
477 
478 /**
479  * @title SafeMath
480  * @dev Math operations with safety checks that throw on error
481  */
482 library SafeMath {
483 
484   /**
485   * @dev Multiplies two numbers, throws on overflow.
486   */
487   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
488     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
489     // benefit is lost if 'b' is also tested.
490     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
491     if (a == 0) {
492       return 0;
493     }
494 
495     c = a * b;
496     assert(c / a == b);
497     return c;
498   }
499 
500   /**
501   * @dev Integer division of two numbers, truncating the quotient.
502   */
503   function div(uint256 a, uint256 b) internal pure returns (uint256) {
504     // assert(b > 0); // Solidity automatically throws when dividing by 0
505     // uint256 c = a / b;
506     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
507     return a / b;
508   }
509 
510   /**
511   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
512   */
513   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
514     assert(b <= a);
515     return a - b;
516   }
517 
518   /**
519   * @dev Adds two numbers, throws on overflow.
520   */
521   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
522     c = a + b;
523     assert(c >= a);
524     return c;
525   }
526 }
527 
528 /**
529  * @title Math
530  * @dev Assorted math operations
531  */
532 library Math {
533   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
534     return a >= b ? a : b;
535   }
536 
537   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
538     return a < b ? a : b;
539   }
540 
541   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
542     return a >= b ? a : b;
543   }
544 
545   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
546     return a < b ? a : b;
547   }
548 }
549 
550 /**
551  * DISCLAIMER: Under certain conditions, the function pushDividendPayment
552  * may fail due to block gas limits.
553  * If the total number of investors that ever held tokens is greater than ~15,000 then
554  * the function may fail. If this happens investors can pull their dividends, or the Issuer
555  * can use pushDividendPaymentToAddresses to provide an explict address list in batches
556  */
557 
558 
559 
560 
561 
562 
563 
564 
565 /**
566  * @title Checkpoint module for issuing ether dividends
567  * @dev abstract contract
568  */
569 contract DividendCheckpoint is ICheckpoint, Module {
570     using SafeMath for uint256;
571 
572     uint256 public EXCLUDED_ADDRESS_LIMIT = 50;
573     bytes32 public constant DISTRIBUTE = "DISTRIBUTE";
574     bytes32 public constant MANAGE = "MANAGE";
575     bytes32 public constant CHECKPOINT = "CHECKPOINT";
576 
577     struct Dividend {
578         uint256 checkpointId;
579         uint256 created; // Time at which the dividend was created
580         uint256 maturity; // Time after which dividend can be claimed - set to 0 to bypass
581         uint256 expiry;  // Time until which dividend can be claimed - after this time any remaining amount can be withdrawn by issuer -
582                          // set to very high value to bypass
583         uint256 amount; // Dividend amount in WEI
584         uint256 claimedAmount; // Amount of dividend claimed so far
585         uint256 totalSupply; // Total supply at the associated checkpoint (avoids recalculating this)
586         bool reclaimed;  // True if expiry has passed and issuer has reclaimed remaining dividend
587         uint256 dividendWithheld;
588         uint256 dividendWithheldReclaimed;
589         mapping (address => bool) claimed; // List of addresses which have claimed dividend
590         mapping (address => bool) dividendExcluded; // List of addresses which cannot claim dividends
591         bytes32 name; // Name/title - used for identification
592     }
593 
594     // List of all dividends
595     Dividend[] public dividends;
596 
597     // List of addresses which cannot claim dividends
598     address[] public excluded;
599 
600     // Mapping from address to withholding tax as a percentage * 10**16
601     mapping (address => uint256) public withholdingTax;
602 
603     // Total amount of ETH withheld per investor
604     mapping (address => uint256) public investorWithheld;
605 
606     event SetDefaultExcludedAddresses(address[] _excluded, uint256 _timestamp);
607     event SetWithholding(address[] _investors, uint256[] _withholding, uint256 _timestamp);
608     event SetWithholdingFixed(address[] _investors, uint256 _withholding, uint256 _timestamp);
609 
610     modifier validDividendIndex(uint256 _dividendIndex) {
611         require(_dividendIndex < dividends.length, "Invalid dividend");
612         require(!dividends[_dividendIndex].reclaimed, "Dividend reclaimed");
613         /*solium-disable-next-line security/no-block-members*/
614         require(now >= dividends[_dividendIndex].maturity, "Dividend maturity in future");
615         /*solium-disable-next-line security/no-block-members*/
616         require(now < dividends[_dividendIndex].expiry, "Dividend expiry in past");
617         _;
618     }
619 
620     /**
621     * @notice Init function i.e generalise function to maintain the structure of the module contract
622     * @return bytes4
623     */
624     function getInitFunction() public pure returns (bytes4) {
625         return bytes4(0);
626     }
627 
628     /**
629      * @notice Return the default excluded addresses
630      * @return List of excluded addresses
631      */
632     function getDefaultExcluded() external view returns (address[]) {
633         return excluded;
634     }
635 
636     /**
637      * @notice Creates a checkpoint on the security token
638      * @return Checkpoint ID
639      */
640     function createCheckpoint() public withPerm(CHECKPOINT) returns (uint256) {
641         return ISecurityToken(securityToken).createCheckpoint();
642     }
643 
644     /**
645      * @notice Function to clear and set list of excluded addresses used for future dividends
646      * @param _excluded Addresses of investors
647      */
648     function setDefaultExcluded(address[] _excluded) public withPerm(MANAGE) {
649         require(_excluded.length <= EXCLUDED_ADDRESS_LIMIT, "Too many excluded addresses");
650         for (uint256 j = 0; j < _excluded.length; j++) {
651             require (_excluded[j] != address(0), "Invalid address");
652             for (uint256 i = j + 1; i < _excluded.length; i++) {
653                 require (_excluded[j] != _excluded[i], "Duplicate exclude address");
654             }
655         }
656         excluded = _excluded;
657         /*solium-disable-next-line security/no-block-members*/
658         emit SetDefaultExcludedAddresses(excluded, now);
659     }
660 
661     /**
662      * @notice Function to set withholding tax rates for investors
663      * @param _investors Addresses of investors
664      * @param _withholding Withholding tax for individual investors (multiplied by 10**16)
665      */
666     function setWithholding(address[] _investors, uint256[] _withholding) public withPerm(MANAGE) {
667         require(_investors.length == _withholding.length, "Mismatched input lengths");
668         /*solium-disable-next-line security/no-block-members*/
669         emit SetWithholding(_investors, _withholding, now);
670         for (uint256 i = 0; i < _investors.length; i++) {
671             require(_withholding[i] <= 10**18, "Incorrect withholding tax");
672             withholdingTax[_investors[i]] = _withholding[i];
673         }
674     }
675 
676     /**
677      * @notice Function to set withholding tax rates for investors
678      * @param _investors Addresses of investor
679      * @param _withholding Withholding tax for all investors (multiplied by 10**16)
680      */
681     function setWithholdingFixed(address[] _investors, uint256 _withholding) public withPerm(MANAGE) {
682         require(_withholding <= 10**18, "Incorrect withholding tax");
683         /*solium-disable-next-line security/no-block-members*/
684         emit SetWithholdingFixed(_investors, _withholding, now);
685         for (uint256 i = 0; i < _investors.length; i++) {
686             withholdingTax[_investors[i]] = _withholding;
687         }
688     }
689 
690     /**
691      * @notice Issuer can push dividends to provided addresses
692      * @param _dividendIndex Dividend to push
693      * @param _payees Addresses to which to push the dividend
694      */
695     function pushDividendPaymentToAddresses(
696         uint256 _dividendIndex,
697         address[] _payees
698     )
699         public
700         withPerm(DISTRIBUTE)
701         validDividendIndex(_dividendIndex)
702     {
703         Dividend storage dividend = dividends[_dividendIndex];
704         for (uint256 i = 0; i < _payees.length; i++) {
705             if ((!dividend.claimed[_payees[i]]) && (!dividend.dividendExcluded[_payees[i]])) {
706                 _payDividend(_payees[i], dividend, _dividendIndex);
707             }
708         }
709     }
710 
711     /**
712      * @notice Issuer can push dividends using the investor list from the security token
713      * @param _dividendIndex Dividend to push
714      * @param _start Index in investor list at which to start pushing dividends
715      * @param _iterations Number of addresses to push dividends for
716      */
717     function pushDividendPayment(
718         uint256 _dividendIndex,
719         uint256 _start,
720         uint256 _iterations
721     )
722         public
723         withPerm(DISTRIBUTE)
724         validDividendIndex(_dividendIndex)
725     {
726         Dividend storage dividend = dividends[_dividendIndex];
727         address[] memory investors = ISecurityToken(securityToken).getInvestors();
728         uint256 numberInvestors = Math.min256(investors.length, _start.add(_iterations));
729         for (uint256 i = _start; i < numberInvestors; i++) {
730             address payee = investors[i];
731             if ((!dividend.claimed[payee]) && (!dividend.dividendExcluded[payee])) {
732                 _payDividend(payee, dividend, _dividendIndex);
733             }
734         }
735     }
736 
737     /**
738      * @notice Investors can pull their own dividends
739      * @param _dividendIndex Dividend to pull
740      */
741     function pullDividendPayment(uint256 _dividendIndex) public validDividendIndex(_dividendIndex)
742     {
743         Dividend storage dividend = dividends[_dividendIndex];
744         require(!dividend.claimed[msg.sender], "Dividend already claimed");
745         require(!dividend.dividendExcluded[msg.sender], "msg.sender excluded from Dividend");
746         _payDividend(msg.sender, dividend, _dividendIndex);
747     }
748 
749     /**
750      * @notice Internal function for paying dividends
751      * @param _payee Address of investor
752      * @param _dividend Storage with previously issued dividends
753      * @param _dividendIndex Dividend to pay
754      */
755     function _payDividend(address _payee, Dividend storage _dividend, uint256 _dividendIndex) internal;
756 
757     /**
758      * @notice Issuer can reclaim remaining unclaimed dividend amounts, for expired dividends
759      * @param _dividendIndex Dividend to reclaim
760      */
761     function reclaimDividend(uint256 _dividendIndex) external;
762 
763     /**
764      * @notice Calculate amount of dividends claimable
765      * @param _dividendIndex Dividend to calculate
766      * @param _payee Affected investor address
767      * @return claim, withheld amounts
768      */
769     function calculateDividend(uint256 _dividendIndex, address _payee) public view returns(uint256, uint256) {
770         require(_dividendIndex < dividends.length, "Invalid dividend");
771         Dividend storage dividend = dividends[_dividendIndex];
772         if (dividend.claimed[_payee] || dividend.dividendExcluded[_payee]) {
773             return (0, 0);
774         }
775         uint256 balance = ISecurityToken(securityToken).balanceOfAt(_payee, dividend.checkpointId);
776         uint256 claim = balance.mul(dividend.amount).div(dividend.totalSupply);
777         uint256 withheld = claim.mul(withholdingTax[_payee]).div(uint256(10**18));
778         return (claim, withheld);
779     }
780 
781     /**
782      * @notice Get the index according to the checkpoint id
783      * @param _checkpointId Checkpoint id to query
784      * @return uint256[]
785      */
786     function getDividendIndex(uint256 _checkpointId) public view returns(uint256[]) {
787         uint256 counter = 0;
788         for(uint256 i = 0; i < dividends.length; i++) {
789             if (dividends[i].checkpointId == _checkpointId) {
790                 counter++;
791             }
792         }
793 
794         uint256[] memory index = new uint256[](counter);
795         counter = 0;
796         for(uint256 j = 0; j < dividends.length; j++) {
797             if (dividends[j].checkpointId == _checkpointId) {
798                 index[counter] = j;
799                 counter++;
800             }
801         }
802         return index;
803     }
804 
805     /**
806      * @notice Allows issuer to withdraw withheld tax
807      * @param _dividendIndex Dividend to withdraw from
808      */
809     function withdrawWithholding(uint256 _dividendIndex) external;
810 
811     /**
812      * @notice Return the permissions flag that are associated with this module
813      * @return bytes32 array
814      */
815     function getPermissions() public view returns(bytes32[]) {
816         bytes32[] memory allPermissions = new bytes32[](2);
817         allPermissions[0] = DISTRIBUTE;
818         allPermissions[1] = MANAGE;
819         return allPermissions;
820     }
821 
822 }
823 
824 /**
825  * @title Ownable
826  * @dev The Ownable contract has an owner address, and provides basic authorization control
827  * functions, this simplifies the implementation of "user permissions".
828  */
829 interface IOwnable {
830     /**
831     * @dev Returns owner
832     */
833     function owner() external view returns (address);
834 
835     /**
836     * @dev Allows the current owner to relinquish control of the contract.
837     */
838     function renounceOwnership() external;
839 
840     /**
841     * @dev Allows the current owner to transfer control of the contract to a newOwner.
842     * @param _newOwner The address to transfer ownership to.
843     */
844     function transferOwnership(address _newOwner) external;
845 
846 }
847 
848 /**
849  * @title Checkpoint module for issuing ERC20 dividends
850  */
851 contract ERC20DividendCheckpoint is DividendCheckpoint {
852     using SafeMath for uint256;
853 
854     // Mapping to token address for each dividend
855     mapping (uint256 => address) public dividendTokens;
856     event ERC20DividendDeposited(
857         address indexed _depositor,
858         uint256 _checkpointId,
859         uint256 _created,
860         uint256 _maturity,
861         uint256 _expiry,
862         address indexed _token,
863         uint256 _amount,
864         uint256 _totalSupply,
865         uint256 _dividendIndex,
866         bytes32 indexed _name
867     );
868     event ERC20DividendClaimed(
869         address indexed _payee,
870         uint256 _dividendIndex,
871         address indexed _token,
872         uint256 _amount,
873         uint256 _withheld
874     );
875     event ERC20DividendReclaimed(
876         address indexed _claimer,
877         uint256 _dividendIndex,
878         address indexed _token,
879         uint256 _claimedAmount
880     );
881     event ERC20DividendWithholdingWithdrawn(
882         address indexed _claimer,
883         uint256 _dividendIndex,
884         address indexed _token,
885         uint256 _withheldAmount
886     );
887 
888     /**
889      * @notice Constructor
890      * @param _securityToken Address of the security token
891      * @param _polyAddress Address of the polytoken
892      */
893     constructor (address _securityToken, address _polyAddress) public
894     Module(_securityToken, _polyAddress)
895     {
896     }
897 
898     /**
899      * @notice Creates a dividend and checkpoint for the dividend
900      * @param _maturity Time from which dividend can be paid
901      * @param _expiry Time until dividend can no longer be paid, and can be reclaimed by issuer
902      * @param _token Address of ERC20 token in which dividend is to be denominated
903      * @param _amount Amount of specified token for dividend
904      * @param _name Name/Title for identification
905      */
906     function createDividend(
907         uint256 _maturity,
908         uint256 _expiry,
909         address _token,
910         uint256 _amount,
911         bytes32 _name
912     ) 
913         external 
914         withPerm(MANAGE)
915     {
916         createDividendWithExclusions(_maturity, _expiry, _token, _amount, excluded, _name);
917     }
918 
919     /**
920      * @notice Creates a dividend with a provided checkpoint
921      * @param _maturity Time from which dividend can be paid
922      * @param _expiry Time until dividend can no longer be paid, and can be reclaimed by issuer
923      * @param _token Address of ERC20 token in which dividend is to be denominated
924      * @param _amount Amount of specified token for dividend
925      * @param _checkpointId Checkpoint id from which to create dividends
926      * @param _name Name/Title for identification
927      */
928     function createDividendWithCheckpoint(
929         uint256 _maturity,
930         uint256 _expiry,
931         address _token,
932         uint256 _amount,
933         uint256 _checkpointId,
934         bytes32 _name
935     )
936         external
937         withPerm(MANAGE)
938     {
939         _createDividendWithCheckpointAndExclusions(_maturity, _expiry, _token, _amount, _checkpointId, excluded, _name);
940     }
941 
942     /**
943      * @notice Creates a dividend and checkpoint for the dividend
944      * @param _maturity Time from which dividend can be paid
945      * @param _expiry Time until dividend can no longer be paid, and can be reclaimed by issuer
946      * @param _token Address of ERC20 token in which dividend is to be denominated
947      * @param _amount Amount of specified token for dividend
948      * @param _excluded List of addresses to exclude
949      * @param _name Name/Title for identification
950      */
951     function createDividendWithExclusions(
952         uint256 _maturity,
953         uint256 _expiry,
954         address _token,
955         uint256 _amount,
956         address[] _excluded,
957         bytes32 _name
958     )
959         public
960         withPerm(MANAGE)
961     {
962         uint256 checkpointId = ISecurityToken(securityToken).createCheckpoint();
963         _createDividendWithCheckpointAndExclusions(_maturity, _expiry, _token, _amount, checkpointId, _excluded, _name);
964     }
965 
966     /**
967      * @notice Creates a dividend with a provided checkpoint
968      * @param _maturity Time from which dividend can be paid
969      * @param _expiry Time until dividend can no longer be paid, and can be reclaimed by issuer
970      * @param _token Address of ERC20 token in which dividend is to be denominated
971      * @param _amount Amount of specified token for dividend
972      * @param _checkpointId Checkpoint id from which to create dividends
973      * @param _excluded List of addresses to exclude
974      * @param _name Name/Title for identification
975      */
976     function createDividendWithCheckpointAndExclusions(
977         uint256 _maturity, 
978         uint256 _expiry, 
979         address _token, 
980         uint256 _amount, 
981         uint256 _checkpointId, 
982         address[] _excluded,
983         bytes32 _name
984     ) 
985         public
986         withPerm(MANAGE)      
987     {
988         _createDividendWithCheckpointAndExclusions(_maturity, _expiry, _token, _amount, _checkpointId, _excluded, _name);
989     }
990 
991     /**
992      * @notice Creates a dividend with a provided checkpoint
993      * @param _maturity Time from which dividend can be paid
994      * @param _expiry Time until dividend can no longer be paid, and can be reclaimed by issuer
995      * @param _token Address of ERC20 token in which dividend is to be denominated
996      * @param _amount Amount of specified token for dividend
997      * @param _checkpointId Checkpoint id from which to create dividends
998      * @param _excluded List of addresses to exclude
999      * @param _name Name/Title for identification
1000      */
1001     function _createDividendWithCheckpointAndExclusions(
1002         uint256 _maturity, 
1003         uint256 _expiry, 
1004         address _token, 
1005         uint256 _amount, 
1006         uint256 _checkpointId, 
1007         address[] _excluded,
1008         bytes32 _name
1009     ) 
1010         internal  
1011     {
1012         ISecurityToken securityTokenInstance = ISecurityToken(securityToken);
1013         require(_excluded.length <= EXCLUDED_ADDRESS_LIMIT, "Too many addresses excluded");
1014         require(_expiry > _maturity, "Expiry before maturity");
1015         /*solium-disable-next-line security/no-block-members*/
1016         require(_expiry > now, "Expiry in past");
1017         require(_amount > 0, "No dividend sent");
1018         require(_token != address(0), "Invalid token");
1019         require(_checkpointId <= securityTokenInstance.currentCheckpointId(), "Invalid checkpoint");
1020         require(IERC20(_token).transferFrom(msg.sender, address(this), _amount), "insufficent allowance");
1021         require(_name[0] != 0);
1022         uint256 dividendIndex = dividends.length;
1023         uint256 currentSupply = securityTokenInstance.totalSupplyAt(_checkpointId);
1024         uint256 excludedSupply = 0;
1025         dividends.push(
1026           Dividend(
1027             _checkpointId,
1028             now, /*solium-disable-line security/no-block-members*/
1029             _maturity,
1030             _expiry,
1031             _amount,
1032             0,
1033             0,
1034             false,
1035             0,
1036             0,
1037             _name
1038           )
1039         );
1040 
1041         for (uint256 j = 0; j < _excluded.length; j++) {
1042             require (_excluded[j] != address(0), "Invalid address");
1043             require(!dividends[dividendIndex].dividendExcluded[_excluded[j]], "duped exclude address");
1044             excludedSupply = excludedSupply.add(securityTokenInstance.balanceOfAt(_excluded[j], _checkpointId));
1045             dividends[dividendIndex].dividendExcluded[_excluded[j]] = true;
1046         }
1047 
1048         dividends[dividendIndex].totalSupply = currentSupply.sub(excludedSupply);
1049         dividendTokens[dividendIndex] = _token;
1050         _emitERC20DividendDepositedEvent(_checkpointId, _maturity, _expiry, _token, _amount, currentSupply, dividendIndex, _name);
1051     }
1052 
1053     /**
1054      * @notice Emits the ERC20DividendDeposited event. 
1055      * Seperated into a different function as a workaround for stack too deep error
1056      */
1057     function _emitERC20DividendDepositedEvent(
1058         uint256 _checkpointId,
1059         uint256 _maturity,
1060         uint256 _expiry,
1061         address _token,
1062         uint256 _amount,
1063         uint256 currentSupply,
1064         uint256 dividendIndex,
1065         bytes32 _name
1066     )
1067         internal
1068     {
1069         /*solium-disable-next-line security/no-block-members*/
1070         emit ERC20DividendDeposited(msg.sender, _checkpointId, now, _maturity, _expiry, _token, _amount, currentSupply, dividendIndex, _name);
1071     }
1072 
1073     /**
1074      * @notice Internal function for paying dividends
1075      * @param _payee Address of investor
1076      * @param _dividend Storage with previously issued dividends
1077      * @param _dividendIndex Dividend to pay
1078      */
1079     function _payDividend(address _payee, Dividend storage _dividend, uint256 _dividendIndex) internal {
1080         (uint256 claim, uint256 withheld) = calculateDividend(_dividendIndex, _payee);
1081         _dividend.claimed[_payee] = true;
1082         _dividend.claimedAmount = claim.add(_dividend.claimedAmount);
1083         uint256 claimAfterWithheld = claim.sub(withheld);
1084         if (claimAfterWithheld > 0) {
1085             require(IERC20(dividendTokens[_dividendIndex]).transfer(_payee, claimAfterWithheld), "transfer failed");
1086             _dividend.dividendWithheld = _dividend.dividendWithheld.add(withheld);
1087             investorWithheld[_payee] = investorWithheld[_payee].add(withheld);
1088             emit ERC20DividendClaimed(_payee, _dividendIndex, dividendTokens[_dividendIndex], claim, withheld);
1089         }
1090     }
1091 
1092     /**
1093      * @notice Issuer can reclaim remaining unclaimed dividend amounts, for expired dividends
1094      * @param _dividendIndex Dividend to reclaim
1095      */
1096     function reclaimDividend(uint256 _dividendIndex) external withPerm(MANAGE) {
1097         require(_dividendIndex < dividends.length, "Invalid dividend");
1098         /*solium-disable-next-line security/no-block-members*/
1099         require(now >= dividends[_dividendIndex].expiry, "Dividend expiry in future");
1100         require(!dividends[_dividendIndex].reclaimed, "already claimed");
1101         dividends[_dividendIndex].reclaimed = true;
1102         Dividend storage dividend = dividends[_dividendIndex];
1103         uint256 remainingAmount = dividend.amount.sub(dividend.claimedAmount);
1104         address owner = IOwnable(securityToken).owner();
1105         require(IERC20(dividendTokens[_dividendIndex]).transfer(owner, remainingAmount), "transfer failed");
1106         emit ERC20DividendReclaimed(owner, _dividendIndex, dividendTokens[_dividendIndex], remainingAmount);
1107     }
1108 
1109     /**
1110      * @notice Allows issuer to withdraw withheld tax
1111      * @param _dividendIndex Dividend to withdraw from
1112      */
1113     function withdrawWithholding(uint256 _dividendIndex) external withPerm(MANAGE) {
1114         require(_dividendIndex < dividends.length, "Invalid dividend");
1115         Dividend storage dividend = dividends[_dividendIndex];
1116         uint256 remainingWithheld = dividend.dividendWithheld.sub(dividend.dividendWithheldReclaimed);
1117         dividend.dividendWithheldReclaimed = dividend.dividendWithheld;
1118         address owner = IOwnable(securityToken).owner();
1119         require(IERC20(dividendTokens[_dividendIndex]).transfer(owner, remainingWithheld), "transfer failed");
1120         emit ERC20DividendWithholdingWithdrawn(owner, _dividendIndex, dividendTokens[_dividendIndex], remainingWithheld);
1121     }
1122 
1123 }
1124 
1125 /**
1126  * @title Interface that every module factory contract should implement
1127  */
1128 interface IModuleFactory {
1129 
1130     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
1131     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
1132     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
1133     event GenerateModuleFromFactory(
1134         address _module,
1135         bytes32 indexed _moduleName,
1136         address indexed _moduleFactory,
1137         address _creator,
1138         uint256 _setupCost,
1139         uint256 _timestamp
1140     );
1141     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
1142 
1143     //Should create an instance of the Module, or throw
1144     function deploy(bytes _data) external returns(address);
1145 
1146     /**
1147      * @notice Type of the Module factory
1148      */
1149     function getTypes() external view returns(uint8[]);
1150 
1151     /**
1152      * @notice Get the name of the Module
1153      */
1154     function getName() external view returns(bytes32);
1155 
1156     /**
1157      * @notice Returns the instructions associated with the module
1158      */
1159     function getInstructions() external view returns (string);
1160 
1161     /**
1162      * @notice Get the tags related to the module factory
1163      */
1164     function getTags() external view returns (bytes32[]);
1165 
1166     /**
1167      * @notice Used to change the setup fee
1168      * @param _newSetupCost New setup fee
1169      */
1170     function changeFactorySetupFee(uint256 _newSetupCost) external;
1171 
1172     /**
1173      * @notice Used to change the usage fee
1174      * @param _newUsageCost New usage fee
1175      */
1176     function changeFactoryUsageFee(uint256 _newUsageCost) external;
1177 
1178     /**
1179      * @notice Used to change the subscription fee
1180      * @param _newSubscriptionCost New subscription fee
1181      */
1182     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
1183 
1184     /**
1185      * @notice Function use to change the lower and upper bound of the compatible version st
1186      * @param _boundType Type of bound
1187      * @param _newVersion New version array
1188      */
1189     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
1190 
1191    /**
1192      * @notice Get the setup cost of the module
1193      */
1194     function getSetupCost() external view returns (uint256);
1195 
1196     /**
1197      * @notice Used to get the lower bound
1198      * @return Lower bound
1199      */
1200     function getLowerSTVersionBounds() external view returns(uint8[]);
1201 
1202      /**
1203      * @notice Used to get the upper bound
1204      * @return Upper bound
1205      */
1206     function getUpperSTVersionBounds() external view returns(uint8[]);
1207 
1208 }
1209 
1210 /**
1211  * @title Helper library use to compare or validate the semantic versions
1212  */
1213 
1214 library VersionUtils {
1215 
1216     /**
1217      * @notice This function is used to validate the version submitted
1218      * @param _current Array holds the present version of ST
1219      * @param _new Array holds the latest version of the ST
1220      * @return bool
1221      */
1222     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
1223         bool[] memory _temp = new bool[](_current.length);
1224         uint8 counter = 0;
1225         for (uint8 i = 0; i < _current.length; i++) {
1226             if (_current[i] < _new[i])
1227                 _temp[i] = true;
1228             else
1229                 _temp[i] = false;
1230         }
1231 
1232         for (i = 0; i < _current.length; i++) {
1233             if (i == 0) {
1234                 if (_current[i] <= _new[i])
1235                     if(_temp[0]) {
1236                         counter = counter + 3;
1237                         break;
1238                     } else
1239                         counter++;
1240                 else
1241                     return false;
1242             } else {
1243                 if (_temp[i-1])
1244                     counter++;
1245                 else if (_current[i] <= _new[i])
1246                     counter++;
1247                 else
1248                     return false;
1249             }
1250         }
1251         if (counter == _current.length)
1252             return true;
1253     }
1254 
1255     /**
1256      * @notice Used to compare the lower bound with the latest version
1257      * @param _version1 Array holds the lower bound of the version
1258      * @param _version2 Array holds the latest version of the ST
1259      * @return bool
1260      */
1261     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
1262         require(_version1.length == _version2.length, "Input length mismatch");
1263         uint counter = 0;
1264         for (uint8 j = 0; j < _version1.length; j++) {
1265             if (_version1[j] == 0)
1266                 counter ++;
1267         }
1268         if (counter != _version1.length) {
1269             counter = 0;
1270             for (uint8 i = 0; i < _version1.length; i++) {
1271                 if (_version2[i] > _version1[i])
1272                     return true;
1273                 else if (_version2[i] < _version1[i])
1274                     return false;
1275                 else
1276                     counter++;
1277             }
1278             if (counter == _version1.length - 1)
1279                 return true;
1280             else
1281                 return false;
1282         } else
1283             return true;
1284     }
1285 
1286     /**
1287      * @notice Used to compare the upper bound with the latest version
1288      * @param _version1 Array holds the upper bound of the version
1289      * @param _version2 Array holds the latest version of the ST
1290      * @return bool
1291      */
1292     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
1293         require(_version1.length == _version2.length, "Input length mismatch");
1294         uint counter = 0;
1295         for (uint8 j = 0; j < _version1.length; j++) {
1296             if (_version1[j] == 0)
1297                 counter ++;
1298         }
1299         if (counter != _version1.length) {
1300             counter = 0;
1301             for (uint8 i = 0; i < _version1.length; i++) {
1302                 if (_version1[i] > _version2[i])
1303                     return true;
1304                 else if (_version1[i] < _version2[i])
1305                     return false;
1306                 else
1307                     counter++;
1308             }
1309             if (counter == _version1.length - 1)
1310                 return true;
1311             else
1312                 return false;
1313         } else
1314             return true;
1315     }
1316 
1317 
1318     /**
1319      * @notice Used to pack the uint8[] array data into uint24 value
1320      * @param _major Major version
1321      * @param _minor Minor version
1322      * @param _patch Patch version
1323      */
1324     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
1325         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
1326     }
1327 
1328     /**
1329      * @notice Used to convert packed data into uint8 array
1330      * @param _packedVersion Packed data
1331      */
1332     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
1333         uint8[] memory _unpackVersion = new uint8[](3);
1334         _unpackVersion[0] = uint8(_packedVersion >> 16);
1335         _unpackVersion[1] = uint8(_packedVersion >> 8);
1336         _unpackVersion[2] = uint8(_packedVersion);
1337         return _unpackVersion;
1338     }
1339 
1340 
1341 }
1342 
1343 /**
1344  * @title Interface that any module factory contract should implement
1345  * @notice Contract is abstract
1346  */
1347 contract ModuleFactory is IModuleFactory, Ownable {
1348 
1349     IERC20 public polyToken;
1350     uint256 public usageCost;
1351     uint256 public monthlySubscriptionCost;
1352 
1353     uint256 public setupCost;
1354     string public description;
1355     string public version;
1356     bytes32 public name;
1357     string public title;
1358 
1359     // @notice Allow only two variables to be stored
1360     // 1. lowerBound 
1361     // 2. upperBound
1362     // @dev (0.0.0 will act as the wildcard) 
1363     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
1364     mapping(string => uint24) compatibleSTVersionRange;
1365 
1366     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
1367     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
1368     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
1369     event GenerateModuleFromFactory(
1370         address _module,
1371         bytes32 indexed _moduleName,
1372         address indexed _moduleFactory,
1373         address _creator,
1374         uint256 _timestamp
1375     );
1376     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
1377 
1378     /**
1379      * @notice Constructor
1380      * @param _polyAddress Address of the polytoken
1381      */
1382     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
1383         polyToken = IERC20(_polyAddress);
1384         setupCost = _setupCost;
1385         usageCost = _usageCost;
1386         monthlySubscriptionCost = _subscriptionCost;
1387     }
1388 
1389     /**
1390      * @notice Used to change the fee of the setup cost
1391      * @param _newSetupCost new setup cost
1392      */
1393     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
1394         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
1395         setupCost = _newSetupCost;
1396     }
1397 
1398     /**
1399      * @notice Used to change the fee of the usage cost
1400      * @param _newUsageCost new usage cost
1401      */
1402     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
1403         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
1404         usageCost = _newUsageCost;
1405     }
1406 
1407     /**
1408      * @notice Used to change the fee of the subscription cost
1409      * @param _newSubscriptionCost new subscription cost
1410      */
1411     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
1412         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
1413         monthlySubscriptionCost = _newSubscriptionCost;
1414 
1415     }
1416 
1417     /**
1418      * @notice Updates the title of the ModuleFactory
1419      * @param _newTitle New Title that will replace the old one.
1420      */
1421     function changeTitle(string _newTitle) public onlyOwner {
1422         require(bytes(_newTitle).length > 0, "Invalid title");
1423         title = _newTitle;
1424     }
1425 
1426     /**
1427      * @notice Updates the description of the ModuleFactory
1428      * @param _newDesc New description that will replace the old one.
1429      */
1430     function changeDescription(string _newDesc) public onlyOwner {
1431         require(bytes(_newDesc).length > 0, "Invalid description");
1432         description = _newDesc;
1433     }
1434 
1435     /**
1436      * @notice Updates the name of the ModuleFactory
1437      * @param _newName New name that will replace the old one.
1438      */
1439     function changeName(bytes32 _newName) public onlyOwner {
1440         require(_newName != bytes32(0),"Invalid name");
1441         name = _newName;
1442     }
1443 
1444     /**
1445      * @notice Updates the version of the ModuleFactory
1446      * @param _newVersion New name that will replace the old one.
1447      */
1448     function changeVersion(string _newVersion) public onlyOwner {
1449         require(bytes(_newVersion).length > 0, "Invalid version");
1450         version = _newVersion;
1451     }
1452 
1453     /**
1454      * @notice Function use to change the lower and upper bound of the compatible version st
1455      * @param _boundType Type of bound
1456      * @param _newVersion new version array
1457      */
1458     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
1459         require(
1460             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
1461             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
1462             "Must be a valid bound type"
1463         );
1464         require(_newVersion.length == 3);
1465         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
1466             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
1467             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
1468         }
1469         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
1470         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
1471     }
1472 
1473     /**
1474      * @notice Used to get the lower bound
1475      * @return lower bound
1476      */
1477     function getLowerSTVersionBounds() external view returns(uint8[]) {
1478         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
1479     }
1480 
1481     /**
1482      * @notice Used to get the upper bound
1483      * @return upper bound
1484      */
1485     function getUpperSTVersionBounds() external view returns(uint8[]) {
1486         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
1487     }
1488 
1489     /**
1490      * @notice Get the setup cost of the module
1491      */
1492     function getSetupCost() external view returns (uint256) {
1493         return setupCost;
1494     }
1495 
1496    /**
1497     * @notice Get the name of the Module
1498     */
1499     function getName() public view returns(bytes32) {
1500         return name;
1501     }
1502 
1503 }
1504 
1505 /**
1506  * @title Factory for deploying ERC20DividendCheckpoint module
1507  */
1508 contract ERC20DividendCheckpointFactory is ModuleFactory {
1509 
1510     /**
1511      * @notice Constructor
1512      * @param _polyAddress Address of the polytoken
1513      * @param _setupCost Setup cost of the module
1514      * @param _usageCost Usage cost of the module
1515      * @param _subscriptionCost Subscription cost of the module
1516      */
1517     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
1518     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
1519     {
1520         version = "1.0.0";
1521         name = "ERC20DividendCheckpoint";
1522         title = "ERC20 Dividend Checkpoint";
1523         description = "Create ERC20 dividends for token holders at a specific checkpoint";
1524         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1525         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1526     }
1527 
1528     /**
1529      * @notice Used to launch the Module with the help of factory
1530      * @return Address Contract address of the Module
1531      */
1532     function deploy(bytes /* _data */) external returns(address) {
1533         if (setupCost > 0)
1534             require(polyToken.transferFrom(msg.sender, owner, setupCost), "insufficent allowance");
1535         address erc20DividendCheckpoint = new ERC20DividendCheckpoint(msg.sender, address(polyToken));
1536         /*solium-disable-next-line security/no-block-members*/
1537         emit GenerateModuleFromFactory(erc20DividendCheckpoint, getName(), address(this), msg.sender, setupCost, now);
1538         return erc20DividendCheckpoint;
1539     }
1540 
1541     /**
1542      * @notice Type of the Module factory
1543      */
1544     function getTypes() external view returns(uint8[]) {
1545         uint8[] memory res = new uint8[](1);
1546         res[0] = 4;
1547         return res;
1548     }
1549 
1550     /**
1551      * @notice Returns the instructions associated with the module
1552      */
1553     function getInstructions() external view returns(string) {
1554         return "Create ERC20 dividend to be paid out to token holders based on their balances at dividend creation time";
1555     }
1556 
1557     /**
1558      * @notice Get the tags related to the module factory
1559      */
1560     function getTags() external view returns(bytes32[]) {
1561         bytes32[] memory availableTags = new bytes32[](3);
1562         availableTags[0] = "ERC20";
1563         availableTags[1] = "Dividend";
1564         availableTags[2] = "Checkpoint";
1565         return availableTags;
1566     }
1567 }