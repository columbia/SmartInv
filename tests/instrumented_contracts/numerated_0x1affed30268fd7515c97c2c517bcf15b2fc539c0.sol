1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, April 24, 2019
3  (UTC) */
4 
5 pragma solidity 0.5.8;
6 
7 /**
8  * @title SafeMath
9  * @dev Unsigned math operations with safety checks that revert on error.
10  */
11 library SafeMath {
12     /**
13      * @dev Multiplies two unsigned integers, reverts on overflow.
14      */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
31      */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Adds two unsigned integers, reverts on overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57 
58         return c;
59     }
60 
61     /**
62      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
63      * reverts when dividing by zero.
64      */
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71 contract ERC1820Registry {
72     function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) external;
73     function getInterfaceImplementer(address _addr, bytes32 _interfaceHash) external view returns (address);
74     function setManager(address _addr, address _newManager) external;
75     function getManager(address _addr) public view returns (address);
76 }
77 
78 
79 /// Base client to interact with the registry.
80 contract ERC1820Client {
81     ERC1820Registry constant ERC1820REGISTRY = ERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
82 
83     function setInterfaceImplementation(string memory _interfaceLabel, address _implementation) internal {
84         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
85         ERC1820REGISTRY.setInterfaceImplementer(address(this), interfaceHash, _implementation);
86     }
87 
88     function interfaceAddr(address addr, string memory _interfaceLabel) internal view returns(address) {
89         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
90         return ERC1820REGISTRY.getInterfaceImplementer(addr, interfaceHash);
91     }
92 
93     function delegateManagement(address _newManager) internal {
94         ERC1820REGISTRY.setManager(address(this), _newManager);
95     }
96 }
97 
98 interface ERC20Token {
99     function name() external view returns (string memory);
100     function symbol() external view returns (string memory);
101     function decimals() external view returns (uint8);
102     function totalSupply() external view returns (uint256);
103     function balanceOf(address owner) external view returns (uint256);
104     function transfer(address to, uint256 amount) external returns (bool);
105     function transferFrom(address from, address to, uint256 amount) external returns (bool);
106     function approve(address spender, uint256 amount) external returns (bool);
107     function allowance(address owner, address spender) external view returns (uint256);
108 
109     // solhint-disable-next-line no-simple-event-func-name
110     event Transfer(address indexed from, address indexed to, uint256 amount);
111     event Approval(address indexed owner, address indexed spender, uint256 amount);
112 }
113 
114 interface ERC777Token {
115     function name() external view returns (string memory);
116     function symbol() external view returns (string memory);
117     function totalSupply() external view returns (uint256);
118     function balanceOf(address owner) external view returns (uint256);
119     function granularity() external view returns (uint256);
120 
121     function defaultOperators() external view returns (address[] memory);
122     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
123     function authorizeOperator(address operator) external;
124     function revokeOperator(address operator) external;
125 
126     function send(address to, uint256 amount, bytes calldata data) external;
127     function operatorSend(
128         address from,
129         address to,
130         uint256 amount,
131         bytes calldata data,
132         bytes calldata operatorData
133     ) external;
134 
135     function burn(uint256 amount, bytes calldata data) external;
136     function operatorBurn(address from, uint256 amount, bytes calldata data, bytes calldata operatorData) external;
137 
138     event Sent(
139         address indexed operator,
140         address indexed from,
141         address indexed to,
142         uint256 amount,
143         bytes data,
144         bytes operatorData
145     );
146     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
147     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
148     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
149     event RevokedOperator(address indexed operator, address indexed tokenHolder);
150 }
151 
152 interface ERC777TokensSender {
153     function tokensToSend(
154         address operator,
155         address from,
156         address to,
157         uint amount,
158         bytes calldata data,
159         bytes calldata operatorData
160     ) external;
161 }
162 
163 interface ERC777TokensRecipient {
164     function tokensReceived(
165         address operator,
166         address from,
167         address to,
168         uint256 amount,
169         bytes calldata data,
170         bytes calldata operatorData
171     ) external;
172 }
173 
174 contract ERC777BaseToken is ERC777Token, ERC1820Client {
175     using SafeMath for uint256;
176 
177     string internal mName;
178     string internal mSymbol;
179     uint256 internal mGranularity;
180     uint256 internal mTotalSupply;
181 
182 
183     mapping(address => uint) internal mBalances;
184 
185     address[] internal mDefaultOperators;
186     mapping(address => bool) internal mIsDefaultOperator;
187     mapping(address => mapping(address => bool)) internal mRevokedDefaultOperator;
188     mapping(address => mapping(address => bool)) internal mAuthorizedOperators;
189 
190     /* -- Constructor -- */
191     //
192     /// @notice Constructor to create a ReferenceToken
193     /// @param _name Name of the new token
194     /// @param _symbol Symbol of the new token.
195     /// @param _granularity Minimum transferable chunk.
196     constructor(
197         string memory _name,
198         string memory _symbol,
199         uint256 _granularity,
200         address[] memory _defaultOperators
201     ) internal {
202         mName = _name;
203         mSymbol = _symbol;
204         mTotalSupply = 0;
205         require(_granularity >= 1, "Granularity must be > 1");
206         mGranularity = _granularity;
207 
208         mDefaultOperators = _defaultOperators;
209         for (uint256 i = 0; i < mDefaultOperators.length; i++) { mIsDefaultOperator[mDefaultOperators[i]] = true; }
210 
211         setInterfaceImplementation("ERC777Token", address(this));
212     }
213 
214     /* -- ERC777 Interface Implementation -- */
215     //
216     /// @return the name of the token
217     function name() public view returns (string memory) { return mName; }
218 
219     /// @return the symbol of the token
220     function symbol() public view returns (string memory) { return mSymbol; }
221 
222     /// @return the granularity of the token
223     function granularity() public view returns (uint256) { return mGranularity; }
224 
225     /// @return the total supply of the token
226     function totalSupply() public view returns (uint256) { return mTotalSupply; }
227 
228     /// @notice Return the account balance of some account
229     /// @param _tokenHolder Address for which the balance is returned
230     /// @return the balance of `_tokenAddress`.
231     function balanceOf(address _tokenHolder) public view returns (uint256) { return mBalances[_tokenHolder]; }
232 
233     /// @notice Return the list of default operators
234     /// @return the list of all the default operators
235     function defaultOperators() public view returns (address[] memory) { return mDefaultOperators; }
236 
237     /// @notice Send `_amount` of tokens to address `_to` passing `_data` to the recipient
238     /// @param _to The address of the recipient
239     /// @param _amount The number of tokens to be sent
240     function send(address _to, uint256 _amount, bytes calldata _data) external {
241         doSend(msg.sender, msg.sender, _to, _amount, _data, "", true);
242     }
243 
244     /// @notice Authorize a third party `_operator` to manage (send) `msg.sender`'s tokens.
245     /// @param _operator The operator that wants to be Authorized
246     function authorizeOperator(address _operator) external {
247         require(_operator != msg.sender, "Cannot authorize yourself as an operator");
248         if (mIsDefaultOperator[_operator]) {
249             mRevokedDefaultOperator[_operator][msg.sender] = false;
250         } else {
251             mAuthorizedOperators[_operator][msg.sender] = true;
252         }
253         emit AuthorizedOperator(_operator, msg.sender);
254     }
255 
256     /// @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens.
257     /// @param _operator The operator that wants to be Revoked
258     function revokeOperator(address _operator) external {
259         require(_operator != msg.sender, "Cannot revoke yourself as an operator");
260         if (mIsDefaultOperator[_operator]) {
261             mRevokedDefaultOperator[_operator][msg.sender] = true;
262         } else {
263             mAuthorizedOperators[_operator][msg.sender] = false;
264         }
265         emit RevokedOperator(_operator, msg.sender);
266     }
267 
268     /// @notice Check whether the `_operator` address is allowed to manage the tokens held by `_tokenHolder` address.
269     /// @param _operator address to check if it has the right to manage the tokens
270     /// @param _tokenHolder address which holds the tokens to be managed
271     /// @return `true` if `_operator` is authorized for `_tokenHolder`
272     function isOperatorFor(address _operator, address _tokenHolder) public view returns (bool) {
273         return (_operator == _tokenHolder // solium-disable-line operator-whitespace
274             || mAuthorizedOperators[_operator][_tokenHolder]
275             || (mIsDefaultOperator[_operator] && !mRevokedDefaultOperator[_operator][_tokenHolder]));
276     }
277 
278     /// @notice Send `_amount` of tokens on behalf of the address `from` to the address `to`.
279     /// @param _from The address holding the tokens being sent
280     /// @param _to The address of the recipient
281     /// @param _amount The number of tokens to be sent
282     /// @param _data Data generated by the user to be sent to the recipient
283     /// @param _operatorData Data generated by the operator to be sent to the recipient
284     function operatorSend(
285         address _from,
286         address _to,
287         uint256 _amount,
288         bytes calldata _data,
289         bytes calldata _operatorData
290     )
291         external
292     {
293         require(isOperatorFor(msg.sender, _from), "Not an operator");
294         doSend(msg.sender, _from, _to, _amount, _data, _operatorData, true);
295     }
296 
297     function burn(uint256 _amount, bytes calldata _data) external {
298         doBurn(msg.sender, msg.sender, _amount, _data, "");
299     }
300 
301     function operatorBurn(
302         address _tokenHolder,
303         uint256 _amount,
304         bytes calldata _data,
305         bytes calldata _operatorData
306     )
307         external
308     {
309         require(isOperatorFor(msg.sender, _tokenHolder), "Not an operator");
310         doBurn(msg.sender, _tokenHolder, _amount, _data, _operatorData);
311     }
312 
313     /* -- Helper Functions -- */
314     //
315     /// @notice Internal function that ensures `_amount` is multiple of the granularity
316     /// @param _amount The quantity that want's to be checked
317     function requireMultiple(uint256 _amount) internal view {
318         require(_amount % mGranularity == 0, "Amount is not a multiple of granualrity");
319     }
320 
321     /// @notice Check whether an address is a regular address or not.
322     /// @param _addr Address of the contract that has to be checked
323     /// @return `true` if `_addr` is a regular address (not a contract)
324     function isRegularAddress(address _addr) internal view returns(bool) {
325         if (_addr == address(0)) { return false; }
326         uint size;
327         assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
328         return size == 0;
329     }
330 
331     /// @notice Helper function actually performing the sending of tokens.
332     /// @param _operator The address performing the send
333     /// @param _from The address holding the tokens being sent
334     /// @param _to The address of the recipient
335     /// @param _amount The number of tokens to be sent
336     /// @param _data Data generated by the user to be passed to the recipient
337     /// @param _operatorData Data generated by the operator to be passed to the recipient
338     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
339     ///  implementing `ERC777tokensRecipient`.
340     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
341     ///  functions SHOULD set this parameter to `false`.
342     function doSend(
343         address _operator,
344         address _from,
345         address _to,
346         uint256 _amount,
347         bytes memory _data,
348         bytes memory _operatorData,
349         bool _preventLocking
350     )
351         internal
352     {
353         // prevent sending if locked
354         requireMultiple(_amount);
355 
356         callSender(_operator, _from, _to, _amount, _data, _operatorData);
357 
358         require(_to != address(0), "Cannot send to 0x0");
359         require(mBalances[_from] >= _amount, "Not enough funds");
360 
361         mBalances[_from] = mBalances[_from].sub(_amount);
362         mBalances[_to] = mBalances[_to].add(_amount);
363 
364         callRecipient(_operator, _from, _to, _amount, _data, _operatorData, _preventLocking);
365 
366         emit Sent(_operator, _from, _to, _amount, _data, _operatorData);
367     }
368 
369     /// @notice Helper function actually performing the burning of tokens.
370     /// @param _operator The address performing the burn
371     /// @param _tokenHolder The address holding the tokens being burn
372     /// @param _amount The number of tokens to be burnt
373     /// @param _data Data generated by the token holder
374     /// @param _operatorData Data generated by the operator
375     function doBurn(
376         address _operator,
377         address _tokenHolder,
378         uint256 _amount,
379         bytes memory _data,
380         bytes memory _operatorData
381     )
382         internal
383     {
384         callSender(_operator, _tokenHolder, address(0), _amount, _data, _operatorData);
385 
386         requireMultiple(_amount);
387         require(balanceOf(_tokenHolder) >= _amount, "Not enough funds");
388 
389         mBalances[_tokenHolder] = mBalances[_tokenHolder].sub(_amount);
390         mTotalSupply = mTotalSupply.sub(_amount);
391 
392         emit Burned(_operator, _tokenHolder, _amount, _data, _operatorData);
393     }
394 
395     /// @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.
396     ///  May throw according to `_preventLocking`
397     /// @param _operator The address performing the send or mint
398     /// @param _from The address holding the tokens being sent
399     /// @param _to The address of the recipient
400     /// @param _amount The number of tokens to be sent
401     /// @param _data Data generated by the user to be passed to the recipient
402     /// @param _operatorData Data generated by the operator to be passed to the recipient
403     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
404     ///  implementing `ERC777TokensRecipient`.
405     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
406     ///  functions SHOULD set this parameter to `false`.
407     function callRecipient(
408         address _operator,
409         address _from,
410         address _to,
411         uint256 _amount,
412         bytes memory _data,
413         bytes memory _operatorData,
414         bool _preventLocking
415     )
416         internal
417     {
418         address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");
419         if (recipientImplementation != address(0)) {
420             ERC777TokensRecipient(recipientImplementation).tokensReceived(
421                 _operator, _from, _to, _amount, _data, _operatorData);
422         } else if (_preventLocking) {
423             require(isRegularAddress(_to), "Cannot send to contract without ERC777TokensRecipient");
424         }
425     }
426 
427     /// @notice Helper function that checks for ERC777TokensSender on the sender and calls it.
428     ///  May throw according to `_preventLocking`
429     /// @param _from The address holding the tokens being sent
430     /// @param _to The address of the recipient
431     /// @param _amount The amount of tokens to be sent
432     /// @param _data Data generated by the user to be passed to the recipient
433     /// @param _operatorData Data generated by the operator to be passed to the recipient
434     ///  implementing `ERC777TokensSender`.
435     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
436     ///  functions SHOULD set this parameter to `false`.
437     function callSender(
438         address _operator,
439         address _from,
440         address _to,
441         uint256 _amount,
442         bytes memory _data,
443         bytes memory _operatorData
444     )
445         internal
446     {
447         address senderImplementation = interfaceAddr(_from, "ERC777TokensSender");
448         if (senderImplementation == address(0)) { return; }
449         ERC777TokensSender(senderImplementation).tokensToSend(
450             _operator, _from, _to, _amount, _data, _operatorData);
451     }
452 }
453 
454 
455 /**
456  * @title Ownable
457  * @dev The Ownable contract has an owner address, and provides basic authorization control
458  * functions, this simplifies the implementation of "user permissions".
459  */
460 contract Ownable {
461     address private _owner;
462 
463     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
464 
465     /**
466      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
467      * account.
468      */
469     constructor () internal {
470         _owner = msg.sender;
471         emit OwnershipTransferred(address(0), _owner);
472     }
473 
474     /**
475      * @return the address of the owner.
476      */
477     function owner() public view returns (address) {
478         return _owner;
479     }
480 
481     /**
482      * @dev Throws if called by any account other than the owner.
483      */
484     modifier onlyOwner() {
485         require(isOwner());
486         _;
487     }
488 
489     /**
490      * @return true if `msg.sender` is the owner of the contract.
491      */
492     function isOwner() public view returns (bool) {
493         return msg.sender == _owner;
494     }
495 
496     /**
497      * @dev Allows the current owner to relinquish control of the contract.
498      * It will not be possible to call the functions with the `onlyOwner`
499      * modifier anymore.
500      * @notice Renouncing ownership will leave the contract without an owner,
501      * thereby removing any functionality that is only available to the owner.
502      */
503     function renounceOwnership() public onlyOwner {
504         emit OwnershipTransferred(_owner, address(0));
505         _owner = address(0);
506     }
507 
508     /**
509      * @dev Allows the current owner to transfer control of the contract to a newOwner.
510      * @param newOwner The address to transfer ownership to.
511      */
512     function transferOwnership(address newOwner) public onlyOwner {
513         _transferOwnership(newOwner);
514     }
515 
516     /**
517      * @dev Transfers control of the contract to a newOwner.
518      * @param newOwner The address to transfer ownership to.
519      */
520     function _transferOwnership(address newOwner) internal {
521         require(newOwner != address(0));
522         emit OwnershipTransferred(_owner, newOwner);
523         _owner = newOwner;
524     }
525 }
526 
527 contract ERC777ERC20BaseToken is ERC20Token, ERC777BaseToken, Ownable {
528     bool internal mErc20compatible;
529 
530     mapping(address => mapping(address => uint256)) internal mAllowed;
531 
532     // allowedAddresses will be able to transfer even when locked
533     // lockedAddresses will *not* be able to transfer even when *not locked*
534     mapping(address => bool) public allowedAddresses;
535     mapping(address => bool) public lockedAddresses;
536     bool public locked = false;
537 
538     function allowAddress(address _addr, bool _isallowed) public onlyOwner {
539       require(_addr != owner());
540       allowedAddresses[_addr] = _isallowed;
541     }
542 
543     function lockAddress(address _addr, bool _locked) public onlyOwner {
544       require(_addr != owner());
545       lockedAddresses[_addr] = _locked;
546     }
547 
548     function setLocked(bool _locked) public onlyOwner {
549       locked = _locked;
550     }
551 
552     function canTransfer(address _addr) public view returns (bool) {
553       if (locked) {
554         if(!allowedAddresses[_addr] &&_addr != owner()) return false;
555       } else if (lockedAddresses[_addr]) return false;
556 
557       return true;
558     }
559 
560     constructor(
561         string memory _name,
562         string memory _symbol,
563         uint256 _granularity,
564         address[] memory _defaultOperators
565     )
566         internal ERC777BaseToken(_name, _symbol, _granularity, _defaultOperators)
567     {
568         mErc20compatible = true;
569         setInterfaceImplementation("ERC20Token", address(this));
570     }
571 
572     /// @notice This modifier is applied to erc20 obsolete methods that are
573     ///  implemented only to maintain backwards compatibility. When the erc20
574     ///  compatibility is disabled, this methods will fail.
575     modifier erc20 () {
576         require(mErc20compatible, "ERC20 is disabled");
577         _;
578     }
579 
580     /// @notice For Backwards compatibility
581     /// @return The decimals of the token. Forced to 18 in ERC777.
582     function decimals() public erc20 view returns (uint8) { return uint8(18); }
583 
584     /// @notice ERC20 backwards compatible transfer.
585     /// @param _to The address of the recipient
586     /// @param _amount The number of tokens to be transferred
587     /// @return `true`, if the transfer can't be done, it should fail.
588     function transfer(address _to, uint256 _amount) public erc20 returns (bool success) {
589         doSend(msg.sender, msg.sender, _to, _amount, "", "", false);
590         return true;
591     }
592 
593     /// @notice ERC20 backwards compatible transferFrom.
594     /// @param _from The address holding the tokens being transferred
595     /// @param _to The address of the recipient
596     /// @param _amount The number of tokens to be transferred
597     /// @return `true`, if the transfer can't be done, it should fail.
598     function transferFrom(address _from, address _to, uint256 _amount) public erc20 returns (bool success) {
599         require(_amount <= mAllowed[_from][msg.sender], "Not enough funds allowed");
600 
601         // Cannot be after doSend because of tokensReceived re-entry
602         mAllowed[_from][msg.sender] = mAllowed[_from][msg.sender].sub(_amount);
603         doSend(msg.sender, _from, _to, _amount, "", "", false);
604         return true;
605     }
606 
607     /// @notice ERC20 backwards compatible approve.
608     ///  `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
609     /// @param _spender The address of the account able to transfer the tokens
610     /// @param _amount The number of tokens to be approved for transfer
611     /// @return `true`, if the approve can't be done, it should fail.
612     function approve(address _spender, uint256 _amount) public erc20 returns (bool success) {
613         _approve(msg.sender, _spender, _amount);
614         return true;
615     }
616 
617     /**
618      * @dev Approve an address to spend another addresses' tokens.
619      * @param owner The address that owns the tokens.
620      * @param spender The address that will spend the tokens.
621      * @param value The number of tokens that can be spent.
622      */
623     function _approve(address owner, address spender, uint256 value) internal {
624         require(spender != address(0));
625         require(owner != address(0));
626 
627         mAllowed[owner][spender] = value;
628         emit Approval(owner, spender, value);
629     }
630 
631     /**
632      * @dev Increase the amount of tokens that an owner allowed to a spender.
633      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
634      * allowed value is better to use this function to avoid 2 calls (and wait until
635      * the first transaction is mined)
636      * From MonolithDAO Token.sol
637      * Emits an Approval event.
638      * @param spender The address which will spend the funds.
639      * @param addedValue The amount of tokens to increase the allowance by.
640      */
641     function increaseAllowance(address spender, uint256 addedValue) public erc20 returns (bool) {
642         _approve(msg.sender, spender, mAllowed[msg.sender][spender].add(addedValue));
643         return true;
644     }
645 
646     
647 
648     /**
649      * @dev Decrease the amount of tokens that an owner allowed to a spender.
650      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
651      * allowed value is better to use this function to avoid 2 calls (and wait until
652      * the first transaction is mined)
653      * From MonolithDAO Token.sol
654      * Emits an Approval event.
655      * @param spender The address which will spend the funds.
656      * @param subtractedValue The amount of tokens to decrease the allowance by.
657      */
658     function decreaseAllowance(address spender, uint256 subtractedValue) public erc20 returns (bool) {
659         _approve(msg.sender, spender, mAllowed[msg.sender][spender].sub(subtractedValue));
660         return true;
661     }
662 
663     /// @notice ERC20 backwards compatible allowance.
664     ///  This function makes it easy to read the `allowed[]` map
665     /// @param _owner The address of the account that owns the token
666     /// @param _spender The address of the account able to transfer the tokens
667     /// @return Amount of remaining tokens of _owner that _spender is allowed
668     ///  to spend
669     function allowance(address _owner, address _spender) public erc20 view returns (uint256 remaining) {
670         return mAllowed[_owner][_spender];
671     }
672 
673     function doSend(
674         address _operator,
675         address _from,
676         address _to,
677         uint256 _amount,
678         bytes memory _data,
679         bytes memory _operatorData,
680         bool _preventLocking
681     )
682         internal
683     {
684         require(canTransfer(_from), "Not allowed to transfer right now!");
685         super.doSend(_operator, _from, _to, _amount, _data, _operatorData, _preventLocking);
686         if (mErc20compatible) { emit Transfer(_from, _to, _amount); }
687     }
688 
689     function doBurn(
690         address _operator,
691         address _tokenHolder,
692         uint256 _amount,
693         bytes memory _data,
694         bytes memory _operatorData
695     )
696         internal
697     {
698         super.doBurn(_operator, _tokenHolder, _amount, _data, _operatorData);
699         if (mErc20compatible) { emit Transfer(_tokenHolder, address(0), _amount); }
700     }
701 }
702 
703 
704 
705 contract DATACHAIN is ERC777ERC20BaseToken {
706     string internal dName = "DATACHAIN";
707     string internal dSymbol = "DC";
708     uint256 internal dGranularity = 1;
709     uint256 internal dTotalSupply = 1000000000 * (10**18);
710 
711     function dDefaultOperators() internal pure returns (address[] memory) {
712         address[] memory defaultOps = new address[](1);
713         
714         defaultOps[0] = 0xa6903375509A5F4f740aEC4Aa677b8C18D41027b;
715         
716         return defaultOps;
717     }
718 
719     constructor() public 
720         ERC777ERC20BaseToken(
721             dName, 
722             dSymbol, 
723             dGranularity, 
724             dDefaultOperators()) 
725     {
726         _mint(msg.sender, dTotalSupply);
727     }
728 
729     function _mint(address to, uint256 value) internal returns (bool) {
730 
731         require(to != address(0));
732 
733         requireMultiple(value);
734 
735         mTotalSupply = mTotalSupply.add(value);
736         mBalances[to] = mBalances[to].add(value);
737 
738         callRecipient(msg.sender, address(0), to, value, "", "", true);
739 
740 
741         emit Minted(msg.sender, to, value, "", "");
742 
743         emit Transfer(address(0), to, value);
744 
745         return true;
746     }
747 
748     function mint(address to, uint256 value) public onlyOwner returns (bool) {
749         _mint(to, value);
750         return true;
751     }
752 }