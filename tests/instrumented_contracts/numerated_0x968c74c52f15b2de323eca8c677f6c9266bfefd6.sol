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
849  * @title Checkpoint module for issuing ether dividends
850  */
851 contract EtherDividendCheckpoint is DividendCheckpoint {
852     using SafeMath for uint256;
853     event EtherDividendDeposited(
854         address indexed _depositor,
855         uint256 _checkpointId,
856         uint256 _created,
857         uint256 _maturity,
858         uint256 _expiry,
859         uint256 _amount,
860         uint256 _totalSupply,
861         uint256 _dividendIndex,
862         bytes32 indexed _name
863     );
864     event EtherDividendClaimed(address indexed _payee, uint256 _dividendIndex, uint256 _amount, uint256 _withheld);
865     event EtherDividendReclaimed(address indexed _claimer, uint256 _dividendIndex, uint256 _claimedAmount);
866     event EtherDividendClaimFailed(address indexed _payee, uint256 _dividendIndex, uint256 _amount, uint256 _withheld);
867     event EtherDividendWithholdingWithdrawn(address indexed _claimer, uint256 _dividendIndex, uint256 _withheldAmount);
868 
869     /**
870      * @notice Constructor
871      * @param _securityToken Address of the security token
872      * @param _polyAddress Address of the polytoken
873      */
874     constructor (address _securityToken, address _polyAddress) public
875     Module(_securityToken, _polyAddress)
876     {
877     }
878 
879     /**
880      * @notice Creates a dividend and checkpoint for the dividend, using global list of excluded addresses
881      * @param _maturity Time from which dividend can be paid
882      * @param _expiry Time until dividend can no longer be paid, and can be reclaimed by issuer
883      * @param _name Name/title for identification
884      */
885     function createDividend(uint256 _maturity, uint256 _expiry, bytes32 _name) external payable withPerm(MANAGE) {
886         createDividendWithExclusions(_maturity, _expiry, excluded, _name);
887     }
888 
889     /**
890      * @notice Creates a dividend with a provided checkpoint, using global list of excluded addresses
891      * @param _maturity Time from which dividend can be paid
892      * @param _expiry Time until dividend can no longer be paid, and can be reclaimed by issuer
893      * @param _checkpointId Id of the checkpoint from which to issue dividend
894      * @param _name Name/title for identification
895      */
896     function createDividendWithCheckpoint(
897         uint256 _maturity,
898         uint256 _expiry,
899         uint256 _checkpointId,
900         bytes32 _name
901     ) 
902         external
903         payable
904         withPerm(MANAGE)
905     {
906         _createDividendWithCheckpointAndExclusions(_maturity, _expiry, _checkpointId, excluded, _name);
907     }
908 
909     /**
910      * @notice Creates a dividend and checkpoint for the dividend, specifying explicit excluded addresses
911      * @param _maturity Time from which dividend can be paid
912      * @param _expiry Time until dividend can no longer be paid, and can be reclaimed by issuer
913      * @param _excluded List of addresses to exclude
914      * @param _name Name/title for identification
915      */
916     function createDividendWithExclusions(
917         uint256 _maturity,
918         uint256 _expiry,
919         address[] _excluded,
920         bytes32 _name
921     ) 
922         public
923         payable
924         withPerm(MANAGE)
925     {
926         uint256 checkpointId = ISecurityToken(securityToken).createCheckpoint();
927         _createDividendWithCheckpointAndExclusions(_maturity, _expiry, checkpointId, _excluded, _name);
928     }
929 
930     /**
931      * @notice Creates a dividend with a provided checkpoint, specifying explicit excluded addresses
932      * @param _maturity Time from which dividend can be paid
933      * @param _expiry Time until dividend can no longer be paid, and can be reclaimed by issuer
934      * @param _checkpointId Id of the checkpoint from which to issue dividend
935      * @param _excluded List of addresses to exclude
936      * @param _name Name/title for identification
937      */
938     function createDividendWithCheckpointAndExclusions(
939         uint256 _maturity, 
940         uint256 _expiry, 
941         uint256 _checkpointId, 
942         address[] _excluded, 
943         bytes32 _name
944     )
945         public
946         payable
947         withPerm(MANAGE)
948     {
949         _createDividendWithCheckpointAndExclusions(_maturity, _expiry, _checkpointId, _excluded, _name);
950     }
951 
952     /**
953      * @notice Creates a dividend with a provided checkpoint, specifying explicit excluded addresses
954      * @param _maturity Time from which dividend can be paid
955      * @param _expiry Time until dividend can no longer be paid, and can be reclaimed by issuer
956      * @param _checkpointId Id of the checkpoint from which to issue dividend
957      * @param _excluded List of addresses to exclude
958      * @param _name Name/title for identification
959      */
960     function _createDividendWithCheckpointAndExclusions(
961         uint256 _maturity, 
962         uint256 _expiry, 
963         uint256 _checkpointId, 
964         address[] _excluded, 
965         bytes32 _name
966     ) 
967         internal
968     {
969         require(_excluded.length <= EXCLUDED_ADDRESS_LIMIT, "Too many addresses excluded");
970         require(_expiry > _maturity, "Expiry is before maturity");
971         /*solium-disable-next-line security/no-block-members*/
972         require(_expiry > now, "Expiry is in the past");
973         require(msg.value > 0, "No dividend sent");
974         require(_checkpointId <= ISecurityToken(securityToken).currentCheckpointId());
975         require(_name[0] != 0);
976         uint256 dividendIndex = dividends.length;
977         uint256 currentSupply = ISecurityToken(securityToken).totalSupplyAt(_checkpointId);
978         uint256 excludedSupply = 0;
979         dividends.push(
980           Dividend(
981             _checkpointId,
982             now, /*solium-disable-line security/no-block-members*/
983             _maturity,
984             _expiry,
985             msg.value,
986             0,
987             0,
988             false,
989             0,
990             0,
991             _name
992           )
993         );
994 
995         for (uint256 j = 0; j < _excluded.length; j++) {
996             require (_excluded[j] != address(0), "Invalid address");
997             require(!dividends[dividendIndex].dividendExcluded[_excluded[j]], "duped exclude address");
998             excludedSupply = excludedSupply.add(ISecurityToken(securityToken).balanceOfAt(_excluded[j], _checkpointId));
999             dividends[dividendIndex].dividendExcluded[_excluded[j]] = true;
1000         }
1001         dividends[dividendIndex].totalSupply = currentSupply.sub(excludedSupply);
1002         /*solium-disable-next-line security/no-block-members*/
1003         emit EtherDividendDeposited(msg.sender, _checkpointId, now, _maturity, _expiry, msg.value, currentSupply, dividendIndex, _name);
1004     }
1005 
1006     /**
1007      * @notice Internal function for paying dividends
1008      * @param _payee address of investor
1009      * @param _dividend storage with previously issued dividends
1010      * @param _dividendIndex Dividend to pay
1011      */
1012     function _payDividend(address _payee, Dividend storage _dividend, uint256 _dividendIndex) internal {
1013         (uint256 claim, uint256 withheld) = calculateDividend(_dividendIndex, _payee);
1014         _dividend.claimed[_payee] = true;      
1015         uint256 claimAfterWithheld = claim.sub(withheld);
1016         if (claimAfterWithheld > 0) {
1017             /*solium-disable-next-line security/no-send*/
1018             if (_payee.send(claimAfterWithheld)) {
1019                 _dividend.claimedAmount = _dividend.claimedAmount.add(claim);
1020                 _dividend.dividendWithheld = _dividend.dividendWithheld.add(withheld);
1021                 investorWithheld[_payee] = investorWithheld[_payee].add(withheld);
1022                 emit EtherDividendClaimed(_payee, _dividendIndex, claim, withheld);
1023             } else {
1024                 _dividend.claimed[_payee] = false;
1025                 emit EtherDividendClaimFailed(_payee, _dividendIndex, claim, withheld);
1026             }
1027         }
1028     }
1029 
1030     /**
1031      * @notice Issuer can reclaim remaining unclaimed dividend amounts, for expired dividends
1032      * @param _dividendIndex Dividend to reclaim
1033      */
1034     function reclaimDividend(uint256 _dividendIndex) external withPerm(MANAGE) {
1035         require(_dividendIndex < dividends.length, "Incorrect dividend index");
1036         /*solium-disable-next-line security/no-block-members*/
1037         require(now >= dividends[_dividendIndex].expiry, "Dividend expiry is in the future");
1038         require(!dividends[_dividendIndex].reclaimed, "Dividend is already claimed");
1039         Dividend storage dividend = dividends[_dividendIndex];
1040         dividend.reclaimed = true;
1041         uint256 remainingAmount = dividend.amount.sub(dividend.claimedAmount);
1042         address owner = IOwnable(securityToken).owner();
1043         owner.transfer(remainingAmount);
1044         emit EtherDividendReclaimed(owner, _dividendIndex, remainingAmount);
1045     }
1046 
1047     /**
1048      * @notice Allows issuer to withdraw withheld tax
1049      * @param _dividendIndex Dividend to withdraw from
1050      */
1051     function withdrawWithholding(uint256 _dividendIndex) external withPerm(MANAGE) {
1052         require(_dividendIndex < dividends.length, "Incorrect dividend index");
1053         Dividend storage dividend = dividends[_dividendIndex];
1054         uint256 remainingWithheld = dividend.dividendWithheld.sub(dividend.dividendWithheldReclaimed);
1055         dividend.dividendWithheldReclaimed = dividend.dividendWithheld;
1056         address owner = IOwnable(securityToken).owner();
1057         owner.transfer(remainingWithheld);
1058         emit EtherDividendWithholdingWithdrawn(owner, _dividendIndex, remainingWithheld);
1059     }
1060 
1061 }
1062 
1063 /**
1064  * @title Interface that every module factory contract should implement
1065  */
1066 interface IModuleFactory {
1067 
1068     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
1069     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
1070     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
1071     event GenerateModuleFromFactory(
1072         address _module,
1073         bytes32 indexed _moduleName,
1074         address indexed _moduleFactory,
1075         address _creator,
1076         uint256 _setupCost,
1077         uint256 _timestamp
1078     );
1079     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
1080 
1081     //Should create an instance of the Module, or throw
1082     function deploy(bytes _data) external returns(address);
1083 
1084     /**
1085      * @notice Type of the Module factory
1086      */
1087     function getTypes() external view returns(uint8[]);
1088 
1089     /**
1090      * @notice Get the name of the Module
1091      */
1092     function getName() external view returns(bytes32);
1093 
1094     /**
1095      * @notice Returns the instructions associated with the module
1096      */
1097     function getInstructions() external view returns (string);
1098 
1099     /**
1100      * @notice Get the tags related to the module factory
1101      */
1102     function getTags() external view returns (bytes32[]);
1103 
1104     /**
1105      * @notice Used to change the setup fee
1106      * @param _newSetupCost New setup fee
1107      */
1108     function changeFactorySetupFee(uint256 _newSetupCost) external;
1109 
1110     /**
1111      * @notice Used to change the usage fee
1112      * @param _newUsageCost New usage fee
1113      */
1114     function changeFactoryUsageFee(uint256 _newUsageCost) external;
1115 
1116     /**
1117      * @notice Used to change the subscription fee
1118      * @param _newSubscriptionCost New subscription fee
1119      */
1120     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
1121 
1122     /**
1123      * @notice Function use to change the lower and upper bound of the compatible version st
1124      * @param _boundType Type of bound
1125      * @param _newVersion New version array
1126      */
1127     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
1128 
1129    /**
1130      * @notice Get the setup cost of the module
1131      */
1132     function getSetupCost() external view returns (uint256);
1133 
1134     /**
1135      * @notice Used to get the lower bound
1136      * @return Lower bound
1137      */
1138     function getLowerSTVersionBounds() external view returns(uint8[]);
1139 
1140      /**
1141      * @notice Used to get the upper bound
1142      * @return Upper bound
1143      */
1144     function getUpperSTVersionBounds() external view returns(uint8[]);
1145 
1146 }
1147 
1148 /**
1149  * @title Helper library use to compare or validate the semantic versions
1150  */
1151 
1152 library VersionUtils {
1153 
1154     /**
1155      * @notice This function is used to validate the version submitted
1156      * @param _current Array holds the present version of ST
1157      * @param _new Array holds the latest version of the ST
1158      * @return bool
1159      */
1160     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
1161         bool[] memory _temp = new bool[](_current.length);
1162         uint8 counter = 0;
1163         for (uint8 i = 0; i < _current.length; i++) {
1164             if (_current[i] < _new[i])
1165                 _temp[i] = true;
1166             else
1167                 _temp[i] = false;
1168         }
1169 
1170         for (i = 0; i < _current.length; i++) {
1171             if (i == 0) {
1172                 if (_current[i] <= _new[i])
1173                     if(_temp[0]) {
1174                         counter = counter + 3;
1175                         break;
1176                     } else
1177                         counter++;
1178                 else
1179                     return false;
1180             } else {
1181                 if (_temp[i-1])
1182                     counter++;
1183                 else if (_current[i] <= _new[i])
1184                     counter++;
1185                 else
1186                     return false;
1187             }
1188         }
1189         if (counter == _current.length)
1190             return true;
1191     }
1192 
1193     /**
1194      * @notice Used to compare the lower bound with the latest version
1195      * @param _version1 Array holds the lower bound of the version
1196      * @param _version2 Array holds the latest version of the ST
1197      * @return bool
1198      */
1199     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
1200         require(_version1.length == _version2.length, "Input length mismatch");
1201         uint counter = 0;
1202         for (uint8 j = 0; j < _version1.length; j++) {
1203             if (_version1[j] == 0)
1204                 counter ++;
1205         }
1206         if (counter != _version1.length) {
1207             counter = 0;
1208             for (uint8 i = 0; i < _version1.length; i++) {
1209                 if (_version2[i] > _version1[i])
1210                     return true;
1211                 else if (_version2[i] < _version1[i])
1212                     return false;
1213                 else
1214                     counter++;
1215             }
1216             if (counter == _version1.length - 1)
1217                 return true;
1218             else
1219                 return false;
1220         } else
1221             return true;
1222     }
1223 
1224     /**
1225      * @notice Used to compare the upper bound with the latest version
1226      * @param _version1 Array holds the upper bound of the version
1227      * @param _version2 Array holds the latest version of the ST
1228      * @return bool
1229      */
1230     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
1231         require(_version1.length == _version2.length, "Input length mismatch");
1232         uint counter = 0;
1233         for (uint8 j = 0; j < _version1.length; j++) {
1234             if (_version1[j] == 0)
1235                 counter ++;
1236         }
1237         if (counter != _version1.length) {
1238             counter = 0;
1239             for (uint8 i = 0; i < _version1.length; i++) {
1240                 if (_version1[i] > _version2[i])
1241                     return true;
1242                 else if (_version1[i] < _version2[i])
1243                     return false;
1244                 else
1245                     counter++;
1246             }
1247             if (counter == _version1.length - 1)
1248                 return true;
1249             else
1250                 return false;
1251         } else
1252             return true;
1253     }
1254 
1255 
1256     /**
1257      * @notice Used to pack the uint8[] array data into uint24 value
1258      * @param _major Major version
1259      * @param _minor Minor version
1260      * @param _patch Patch version
1261      */
1262     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
1263         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
1264     }
1265 
1266     /**
1267      * @notice Used to convert packed data into uint8 array
1268      * @param _packedVersion Packed data
1269      */
1270     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
1271         uint8[] memory _unpackVersion = new uint8[](3);
1272         _unpackVersion[0] = uint8(_packedVersion >> 16);
1273         _unpackVersion[1] = uint8(_packedVersion >> 8);
1274         _unpackVersion[2] = uint8(_packedVersion);
1275         return _unpackVersion;
1276     }
1277 
1278 
1279 }
1280 
1281 /**
1282  * @title Interface that any module factory contract should implement
1283  * @notice Contract is abstract
1284  */
1285 contract ModuleFactory is IModuleFactory, Ownable {
1286 
1287     IERC20 public polyToken;
1288     uint256 public usageCost;
1289     uint256 public monthlySubscriptionCost;
1290 
1291     uint256 public setupCost;
1292     string public description;
1293     string public version;
1294     bytes32 public name;
1295     string public title;
1296 
1297     // @notice Allow only two variables to be stored
1298     // 1. lowerBound 
1299     // 2. upperBound
1300     // @dev (0.0.0 will act as the wildcard) 
1301     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
1302     mapping(string => uint24) compatibleSTVersionRange;
1303 
1304     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
1305     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
1306     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
1307     event GenerateModuleFromFactory(
1308         address _module,
1309         bytes32 indexed _moduleName,
1310         address indexed _moduleFactory,
1311         address _creator,
1312         uint256 _timestamp
1313     );
1314     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
1315 
1316     /**
1317      * @notice Constructor
1318      * @param _polyAddress Address of the polytoken
1319      */
1320     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
1321         polyToken = IERC20(_polyAddress);
1322         setupCost = _setupCost;
1323         usageCost = _usageCost;
1324         monthlySubscriptionCost = _subscriptionCost;
1325     }
1326 
1327     /**
1328      * @notice Used to change the fee of the setup cost
1329      * @param _newSetupCost new setup cost
1330      */
1331     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
1332         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
1333         setupCost = _newSetupCost;
1334     }
1335 
1336     /**
1337      * @notice Used to change the fee of the usage cost
1338      * @param _newUsageCost new usage cost
1339      */
1340     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
1341         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
1342         usageCost = _newUsageCost;
1343     }
1344 
1345     /**
1346      * @notice Used to change the fee of the subscription cost
1347      * @param _newSubscriptionCost new subscription cost
1348      */
1349     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
1350         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
1351         monthlySubscriptionCost = _newSubscriptionCost;
1352 
1353     }
1354 
1355     /**
1356      * @notice Updates the title of the ModuleFactory
1357      * @param _newTitle New Title that will replace the old one.
1358      */
1359     function changeTitle(string _newTitle) public onlyOwner {
1360         require(bytes(_newTitle).length > 0, "Invalid title");
1361         title = _newTitle;
1362     }
1363 
1364     /**
1365      * @notice Updates the description of the ModuleFactory
1366      * @param _newDesc New description that will replace the old one.
1367      */
1368     function changeDescription(string _newDesc) public onlyOwner {
1369         require(bytes(_newDesc).length > 0, "Invalid description");
1370         description = _newDesc;
1371     }
1372 
1373     /**
1374      * @notice Updates the name of the ModuleFactory
1375      * @param _newName New name that will replace the old one.
1376      */
1377     function changeName(bytes32 _newName) public onlyOwner {
1378         require(_newName != bytes32(0),"Invalid name");
1379         name = _newName;
1380     }
1381 
1382     /**
1383      * @notice Updates the version of the ModuleFactory
1384      * @param _newVersion New name that will replace the old one.
1385      */
1386     function changeVersion(string _newVersion) public onlyOwner {
1387         require(bytes(_newVersion).length > 0, "Invalid version");
1388         version = _newVersion;
1389     }
1390 
1391     /**
1392      * @notice Function use to change the lower and upper bound of the compatible version st
1393      * @param _boundType Type of bound
1394      * @param _newVersion new version array
1395      */
1396     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
1397         require(
1398             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
1399             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
1400             "Must be a valid bound type"
1401         );
1402         require(_newVersion.length == 3);
1403         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
1404             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
1405             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
1406         }
1407         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
1408         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
1409     }
1410 
1411     /**
1412      * @notice Used to get the lower bound
1413      * @return lower bound
1414      */
1415     function getLowerSTVersionBounds() external view returns(uint8[]) {
1416         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
1417     }
1418 
1419     /**
1420      * @notice Used to get the upper bound
1421      * @return upper bound
1422      */
1423     function getUpperSTVersionBounds() external view returns(uint8[]) {
1424         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
1425     }
1426 
1427     /**
1428      * @notice Get the setup cost of the module
1429      */
1430     function getSetupCost() external view returns (uint256) {
1431         return setupCost;
1432     }
1433 
1434    /**
1435     * @notice Get the name of the Module
1436     */
1437     function getName() public view returns(bytes32) {
1438         return name;
1439     }
1440 
1441 }
1442 
1443 /**
1444  * @title Factory for deploying EtherDividendCheckpoint module
1445  */
1446 contract EtherDividendCheckpointFactory is ModuleFactory {
1447 
1448     /**
1449      * @notice Constructor
1450      * @param _polyAddress Address of the polytoken
1451      * @param _setupCost Setup cost of the module
1452      * @param _usageCost Usage cost of the module
1453      * @param _subscriptionCost Subscription cost of the module
1454      */
1455     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
1456     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
1457     {
1458         version = "1.0.0";
1459         name = "EtherDividendCheckpoint";
1460         title = "Ether Dividend Checkpoint";
1461         description = "Create ETH dividends for token holders at a specific checkpoint";
1462         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1463         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1464     }
1465 
1466     /**
1467      * @notice Used to launch the Module with the help of factory
1468      * @return address Contract address of the Module
1469      */
1470     function deploy(bytes /* _data */) external returns(address) {
1471         if(setupCost > 0)
1472             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Insufficent allowance or balance");
1473         address ethDividendCheckpoint = new EtherDividendCheckpoint(msg.sender, address(polyToken));
1474         /*solium-disable-next-line security/no-block-members*/
1475         emit GenerateModuleFromFactory(ethDividendCheckpoint, getName(), address(this), msg.sender, setupCost, now);
1476         return ethDividendCheckpoint;
1477     }
1478 
1479     /**
1480      * @notice Type of the Module factory
1481      */
1482     function getTypes() external view returns(uint8[]) {
1483         uint8[] memory res = new uint8[](1);
1484         res[0] = 4;
1485         return res;
1486     }
1487 
1488     /**
1489      * @notice Returns the instructions associated with the module
1490      */
1491     function getInstructions() external view returns(string) {
1492         return "Create a dividend which will be paid out to token holders proportionally according to their balances at the point the dividend is created";
1493     }
1494 
1495     /**
1496      * @notice Get the tags related to the module factory
1497      */
1498     function getTags() external view returns(bytes32[]) {
1499         bytes32[] memory availableTags = new bytes32[](3);
1500         availableTags[0] = "ETH";
1501         availableTags[1] = "Checkpoint";
1502         availableTags[2] = "Dividend";
1503         return availableTags;
1504     }
1505 }