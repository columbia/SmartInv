1 pragma solidity 0.5.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 contract ERC1820Registry {
68     function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) external;
69     function getInterfaceImplementer(address _addr, bytes32 _interfaceHash) external view returns (address);
70     function setManager(address _addr, address _newManager) external;
71     function getManager(address _addr) public view returns (address);
72 }
73 
74 
75 /// Base client to interact with the registry.
76 contract ERC1820Client {
77     ERC1820Registry constant ERC1820REGISTRY = ERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
78 
79     function setInterfaceImplementation(string memory _interfaceLabel, address _implementation) internal {
80         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
81         ERC1820REGISTRY.setInterfaceImplementer(address(this), interfaceHash, _implementation);
82     }
83 
84     function interfaceAddr(address addr, string memory _interfaceLabel) internal view returns(address) {
85         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
86         return ERC1820REGISTRY.getInterfaceImplementer(addr, interfaceHash);
87     }
88 
89     function delegateManagement(address _newManager) internal {
90         ERC1820REGISTRY.setManager(address(this), _newManager);
91     }
92 }
93 
94 interface ERC20Token {
95     function name() external view returns (string memory);
96     function symbol() external view returns (string memory);
97     function decimals() external view returns (uint8);
98     function totalSupply() external view returns (uint256);
99     function balanceOf(address owner) external view returns (uint256);
100     function transfer(address to, uint256 amount) external returns (bool);
101     function transferFrom(address from, address to, uint256 amount) external returns (bool);
102     function approve(address spender, uint256 amount) external returns (bool);
103     function allowance(address owner, address spender) external view returns (uint256);
104 
105     // solhint-disable-next-line no-simple-event-func-name
106     event Transfer(address indexed from, address indexed to, uint256 amount);
107     event Approval(address indexed owner, address indexed spender, uint256 amount);
108 }
109 
110 interface ERC777Token {
111     function name() external view returns (string memory);
112     function symbol() external view returns (string memory);
113     function totalSupply() external view returns (uint256);
114     function balanceOf(address owner) external view returns (uint256);
115     function granularity() external view returns (uint256);
116 
117     function defaultOperators() external view returns (address[] memory);
118     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
119     function authorizeOperator(address operator) external;
120     function revokeOperator(address operator) external;
121 
122     function send(address to, uint256 amount, bytes calldata data) external;
123     function operatorSend(
124         address from,
125         address to,
126         uint256 amount,
127         bytes calldata data,
128         bytes calldata operatorData
129     ) external;
130 
131     function burn(uint256 amount, bytes calldata data) external;
132     function operatorBurn(address from, uint256 amount, bytes calldata data, bytes calldata operatorData) external;
133 
134     event Sent(
135         address indexed operator,
136         address indexed from,
137         address indexed to,
138         uint256 amount,
139         bytes data,
140         bytes operatorData
141     );
142     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
143     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
144     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
145     event RevokedOperator(address indexed operator, address indexed tokenHolder);
146 }
147 
148 interface ERC777TokensSender {
149     function tokensToSend(
150         address operator,
151         address from,
152         address to,
153         uint amount,
154         bytes calldata data,
155         bytes calldata operatorData
156     ) external;
157 }
158 
159 interface ERC777TokensRecipient {
160     function tokensReceived(
161         address operator,
162         address from,
163         address to,
164         uint256 amount,
165         bytes calldata data,
166         bytes calldata operatorData
167     ) external;
168 }
169 
170 contract ERC777BaseToken is ERC777Token, ERC1820Client {
171     using SafeMath for uint256;
172 
173     string internal mName;
174     string internal mSymbol;
175     uint256 internal mGranularity;
176     uint256 internal mTotalSupply;
177 
178 
179     mapping(address => uint) internal mBalances;
180 
181     address[] internal mDefaultOperators;
182     mapping(address => bool) internal mIsDefaultOperator;
183     mapping(address => mapping(address => bool)) internal mRevokedDefaultOperator;
184     mapping(address => mapping(address => bool)) internal mAuthorizedOperators;
185 
186     /* -- Constructor -- */
187     //
188     /// @notice Constructor to create a ReferenceToken
189     /// @param _name Name of the new token
190     /// @param _symbol Symbol of the new token.
191     /// @param _granularity Minimum transferable chunk.
192     constructor(
193         string memory _name,
194         string memory _symbol,
195         uint256 _granularity,
196         address[] memory _defaultOperators
197     ) internal {
198         mName = _name;
199         mSymbol = _symbol;
200         mTotalSupply = 0;
201         require(_granularity >= 1, "Granularity must be > 1");
202         mGranularity = _granularity;
203 
204         mDefaultOperators = _defaultOperators;
205         for (uint256 i = 0; i < mDefaultOperators.length; i++) { mIsDefaultOperator[mDefaultOperators[i]] = true; }
206 
207         setInterfaceImplementation("ERC777Token", address(this));
208     }
209 
210     /* -- ERC777 Interface Implementation -- */
211     //
212     /// @return the name of the token
213     function name() public view returns (string memory) { return mName; }
214 
215     /// @return the symbol of the token
216     function symbol() public view returns (string memory) { return mSymbol; }
217 
218     /// @return the granularity of the token
219     function granularity() public view returns (uint256) { return mGranularity; }
220 
221     /// @return the total supply of the token
222     function totalSupply() public view returns (uint256) { return mTotalSupply; }
223 
224     /// @notice Return the account balance of some account
225     /// @param _tokenHolder Address for which the balance is returned
226     /// @return the balance of `_tokenAddress`.
227     function balanceOf(address _tokenHolder) public view returns (uint256) { return mBalances[_tokenHolder]; }
228 
229     /// @notice Return the list of default operators
230     /// @return the list of all the default operators
231     function defaultOperators() public view returns (address[] memory) { return mDefaultOperators; }
232 
233     /// @notice Send `_amount` of tokens to address `_to` passing `_data` to the recipient
234     /// @param _to The address of the recipient
235     /// @param _amount The number of tokens to be sent
236     function send(address _to, uint256 _amount, bytes calldata _data) external {
237         doSend(msg.sender, msg.sender, _to, _amount, _data, "", true);
238     }
239 
240     /// @notice Authorize a third party `_operator` to manage (send) `msg.sender`'s tokens.
241     /// @param _operator The operator that wants to be Authorized
242     function authorizeOperator(address _operator) external {
243         require(_operator != msg.sender, "Cannot authorize yourself as an operator");
244         if (mIsDefaultOperator[_operator]) {
245             mRevokedDefaultOperator[_operator][msg.sender] = false;
246         } else {
247             mAuthorizedOperators[_operator][msg.sender] = true;
248         }
249         emit AuthorizedOperator(_operator, msg.sender);
250     }
251 
252     /// @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens.
253     /// @param _operator The operator that wants to be Revoked
254     function revokeOperator(address _operator) external {
255         require(_operator != msg.sender, "Cannot revoke yourself as an operator");
256         if (mIsDefaultOperator[_operator]) {
257             mRevokedDefaultOperator[_operator][msg.sender] = true;
258         } else {
259             mAuthorizedOperators[_operator][msg.sender] = false;
260         }
261         emit RevokedOperator(_operator, msg.sender);
262     }
263 
264     /// @notice Check whether the `_operator` address is allowed to manage the tokens held by `_tokenHolder` address.
265     /// @param _operator address to check if it has the right to manage the tokens
266     /// @param _tokenHolder address which holds the tokens to be managed
267     /// @return `true` if `_operator` is authorized for `_tokenHolder`
268     function isOperatorFor(address _operator, address _tokenHolder) public view returns (bool) {
269         return (_operator == _tokenHolder // solium-disable-line operator-whitespace
270             || mAuthorizedOperators[_operator][_tokenHolder]
271             || (mIsDefaultOperator[_operator] && !mRevokedDefaultOperator[_operator][_tokenHolder]));
272     }
273 
274     /// @notice Send `_amount` of tokens on behalf of the address `from` to the address `to`.
275     /// @param _from The address holding the tokens being sent
276     /// @param _to The address of the recipient
277     /// @param _amount The number of tokens to be sent
278     /// @param _data Data generated by the user to be sent to the recipient
279     /// @param _operatorData Data generated by the operator to be sent to the recipient
280     function operatorSend(
281         address _from,
282         address _to,
283         uint256 _amount,
284         bytes calldata _data,
285         bytes calldata _operatorData
286     )
287         external
288     {
289         require(isOperatorFor(msg.sender, _from), "Not an operator");
290         doSend(msg.sender, _from, _to, _amount, _data, _operatorData, true);
291     }
292 
293     function burn(uint256 _amount, bytes calldata _data) external {
294         doBurn(msg.sender, msg.sender, _amount, _data, "");
295     }
296 
297     function operatorBurn(
298         address _tokenHolder,
299         uint256 _amount,
300         bytes calldata _data,
301         bytes calldata _operatorData
302     )
303         external
304     {
305         require(isOperatorFor(msg.sender, _tokenHolder), "Not an operator");
306         doBurn(msg.sender, _tokenHolder, _amount, _data, _operatorData);
307     }
308 
309     /* -- Helper Functions -- */
310     //
311     /// @notice Internal function that ensures `_amount` is multiple of the granularity
312     /// @param _amount The quantity that want's to be checked
313     function requireMultiple(uint256 _amount) internal view {
314         require(_amount % mGranularity == 0, "Amount is not a multiple of granualrity");
315     }
316 
317     /// @notice Check whether an address is a regular address or not.
318     /// @param _addr Address of the contract that has to be checked
319     /// @return `true` if `_addr` is a regular address (not a contract)
320     function isRegularAddress(address _addr) internal view returns(bool) {
321         if (_addr == address(0)) { return false; }
322         uint size;
323         assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
324         return size == 0;
325     }
326 
327     /// @notice Helper function actually performing the sending of tokens.
328     /// @param _operator The address performing the send
329     /// @param _from The address holding the tokens being sent
330     /// @param _to The address of the recipient
331     /// @param _amount The number of tokens to be sent
332     /// @param _data Data generated by the user to be passed to the recipient
333     /// @param _operatorData Data generated by the operator to be passed to the recipient
334     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
335     ///  implementing `ERC777tokensRecipient`.
336     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
337     ///  functions SHOULD set this parameter to `false`.
338     function doSend(
339         address _operator,
340         address _from,
341         address _to,
342         uint256 _amount,
343         bytes memory _data,
344         bytes memory _operatorData,
345         bool _preventLocking
346     )
347         internal
348     {
349         requireMultiple(_amount);
350 
351         callSender(_operator, _from, _to, _amount, _data, _operatorData);
352 
353         require(_to != address(0), "Cannot send to 0x0");
354         require(mBalances[_from] >= _amount, "Not enough funds");
355 
356         mBalances[_from] = mBalances[_from].sub(_amount);
357         mBalances[_to] = mBalances[_to].add(_amount);
358 
359         callRecipient(_operator, _from, _to, _amount, _data, _operatorData, _preventLocking);
360 
361         emit Sent(_operator, _from, _to, _amount, _data, _operatorData);
362     }
363 
364     /// @notice Helper function actually performing the burning of tokens.
365     /// @param _operator The address performing the burn
366     /// @param _tokenHolder The address holding the tokens being burn
367     /// @param _amount The number of tokens to be burnt
368     /// @param _data Data generated by the token holder
369     /// @param _operatorData Data generated by the operator
370     function doBurn(
371         address _operator,
372         address _tokenHolder,
373         uint256 _amount,
374         bytes memory _data,
375         bytes memory _operatorData
376     )
377         internal
378     {
379         callSender(_operator, _tokenHolder, address(0), _amount, _data, _operatorData);
380 
381         requireMultiple(_amount);
382         require(balanceOf(_tokenHolder) >= _amount, "Not enough funds");
383 
384         mBalances[_tokenHolder] = mBalances[_tokenHolder].sub(_amount);
385         mTotalSupply = mTotalSupply.sub(_amount);
386 
387         emit Burned(_operator, _tokenHolder, _amount, _data, _operatorData);
388     }
389 
390     /// @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.
391     ///  May throw according to `_preventLocking`
392     /// @param _operator The address performing the send or mint
393     /// @param _from The address holding the tokens being sent
394     /// @param _to The address of the recipient
395     /// @param _amount The number of tokens to be sent
396     /// @param _data Data generated by the user to be passed to the recipient
397     /// @param _operatorData Data generated by the operator to be passed to the recipient
398     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
399     ///  implementing `ERC777TokensRecipient`.
400     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
401     ///  functions SHOULD set this parameter to `false`.
402     function callRecipient(
403         address _operator,
404         address _from,
405         address _to,
406         uint256 _amount,
407         bytes memory _data,
408         bytes memory _operatorData,
409         bool _preventLocking
410     )
411         internal
412     {
413         address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");
414         if (recipientImplementation != address(0)) {
415             ERC777TokensRecipient(recipientImplementation).tokensReceived(
416                 _operator, _from, _to, _amount, _data, _operatorData);
417         } else if (_preventLocking) {
418             require(isRegularAddress(_to), "Cannot send to contract without ERC777TokensRecipient");
419         }
420     }
421 
422     /// @notice Helper function that checks for ERC777TokensSender on the sender and calls it.
423     ///  May throw according to `_preventLocking`
424     /// @param _from The address holding the tokens being sent
425     /// @param _to The address of the recipient
426     /// @param _amount The amount of tokens to be sent
427     /// @param _data Data generated by the user to be passed to the recipient
428     /// @param _operatorData Data generated by the operator to be passed to the recipient
429     ///  implementing `ERC777TokensSender`.
430     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
431     ///  functions SHOULD set this parameter to `false`.
432     function callSender(
433         address _operator,
434         address _from,
435         address _to,
436         uint256 _amount,
437         bytes memory _data,
438         bytes memory _operatorData
439     )
440         internal
441     {
442         address senderImplementation = interfaceAddr(_from, "ERC777TokensSender");
443         if (senderImplementation == address(0)) { return; }
444         ERC777TokensSender(senderImplementation).tokensToSend(
445             _operator, _from, _to, _amount, _data, _operatorData);
446     }
447 }
448 
449 contract ERC777ERC20BaseToken is ERC20Token, ERC777BaseToken {
450     bool internal mErc20compatible;
451 
452     mapping(address => mapping(address => uint256)) internal mAllowed;
453 
454     constructor(
455         string memory _name,
456         string memory _symbol,
457         uint256 _granularity,
458         address[] memory _defaultOperators
459     )
460         internal ERC777BaseToken(_name, _symbol, _granularity, _defaultOperators)
461     {
462         mErc20compatible = true;
463         setInterfaceImplementation("ERC20Token", address(this));
464     }
465 
466     /// @notice This modifier is applied to erc20 obsolete methods that are
467     ///  implemented only to maintain backwards compatibility. When the erc20
468     ///  compatibility is disabled, this methods will fail.
469     modifier erc20 () {
470         require(mErc20compatible, "ERC20 is disabled");
471         _;
472     }
473 
474     /// @notice For Backwards compatibility
475     /// @return The decimals of the token. Forced to 18 in ERC777.
476     function decimals() public erc20 view returns (uint8) { return uint8(18); }
477 
478     /// @notice ERC20 backwards compatible transfer.
479     /// @param _to The address of the recipient
480     /// @param _amount The number of tokens to be transferred
481     /// @return `true`, if the transfer can't be done, it should fail.
482     function transfer(address _to, uint256 _amount) public erc20 returns (bool success) {
483         doSend(msg.sender, msg.sender, _to, _amount, "", "", false);
484         return true;
485     }
486 
487     /// @notice ERC20 backwards compatible transferFrom.
488     /// @param _from The address holding the tokens being transferred
489     /// @param _to The address of the recipient
490     /// @param _amount The number of tokens to be transferred
491     /// @return `true`, if the transfer can't be done, it should fail.
492     function transferFrom(address _from, address _to, uint256 _amount) public erc20 returns (bool success) {
493         require(_amount <= mAllowed[_from][msg.sender], "Not enough funds allowed");
494 
495         // Cannot be after doSend because of tokensReceived re-entry
496         mAllowed[_from][msg.sender] = mAllowed[_from][msg.sender].sub(_amount);
497         doSend(msg.sender, _from, _to, _amount, "", "", false);
498         return true;
499     }
500 
501     /// @notice ERC20 backwards compatible approve.
502     ///  `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
503     /// @param _spender The address of the account able to transfer the tokens
504     /// @param _amount The number of tokens to be approved for transfer
505     /// @return `true`, if the approve can't be done, it should fail.
506     function approve(address _spender, uint256 _amount) public erc20 returns (bool success) {
507         _approve(msg.sender, _spender, _amount);
508         return true;
509     }
510 
511     /**
512      * @dev Approve an address to spend another addresses' tokens.
513      * @param owner The address that owns the tokens.
514      * @param spender The address that will spend the tokens.
515      * @param value The number of tokens that can be spent.
516      */
517     function _approve(address owner, address spender, uint256 value) internal {
518         require(spender != address(0));
519         require(owner != address(0));
520 
521         mAllowed[owner][spender] = value;
522         emit Approval(owner, spender, value);
523     }
524 
525     /**
526      * @dev Increase the amount of tokens that an owner allowed to a spender.
527      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
528      * allowed value is better to use this function to avoid 2 calls (and wait until
529      * the first transaction is mined)
530      * From MonolithDAO Token.sol
531      * Emits an Approval event.
532      * @param spender The address which will spend the funds.
533      * @param addedValue The amount of tokens to increase the allowance by.
534      */
535     function increaseAllowance(address spender, uint256 addedValue) public erc20 returns (bool) {
536         _approve(msg.sender, spender, mAllowed[msg.sender][spender].add(addedValue));
537         return true;
538     }
539 
540     
541 
542     /**
543      * @dev Decrease the amount of tokens that an owner allowed to a spender.
544      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
545      * allowed value is better to use this function to avoid 2 calls (and wait until
546      * the first transaction is mined)
547      * From MonolithDAO Token.sol
548      * Emits an Approval event.
549      * @param spender The address which will spend the funds.
550      * @param subtractedValue The amount of tokens to decrease the allowance by.
551      */
552     function decreaseAllowance(address spender, uint256 subtractedValue) public erc20 returns (bool) {
553         _approve(msg.sender, spender, mAllowed[msg.sender][spender].sub(subtractedValue));
554         return true;
555     }
556 
557     /// @notice ERC20 backwards compatible allowance.
558     ///  This function makes it easy to read the `allowed[]` map
559     /// @param _owner The address of the account that owns the token
560     /// @param _spender The address of the account able to transfer the tokens
561     /// @return Amount of remaining tokens of _owner that _spender is allowed
562     ///  to spend
563     function allowance(address _owner, address _spender) public erc20 view returns (uint256 remaining) {
564         return mAllowed[_owner][_spender];
565     }
566 
567     function doSend(
568         address _operator,
569         address _from,
570         address _to,
571         uint256 _amount,
572         bytes memory _data,
573         bytes memory _operatorData,
574         bool _preventLocking
575     )
576         internal
577     {
578         super.doSend(_operator, _from, _to, _amount, _data, _operatorData, _preventLocking);
579         if (mErc20compatible) { emit Transfer(_from, _to, _amount); }
580     }
581 
582     function doBurn(
583         address _operator,
584         address _tokenHolder,
585         uint256 _amount,
586         bytes memory _data,
587         bytes memory _operatorData
588     )
589         internal
590     {
591         super.doBurn(_operator, _tokenHolder, _amount, _data, _operatorData);
592         if (mErc20compatible) { emit Transfer(_tokenHolder, address(0), _amount); }
593     }
594 }
595 
596 /**
597  * @title Ownable
598  * @dev The Ownable contract has an owner address, and provides basic authorization control
599  * functions, this simplifies the implementation of "user permissions".
600  */
601 contract Ownable {
602     address private _owner;
603 
604     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
605 
606     /**
607      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
608      * account.
609      */
610     constructor () internal {
611         _owner = msg.sender;
612         emit OwnershipTransferred(address(0), _owner);
613     }
614 
615     /**
616      * @return the address of the owner.
617      */
618     function owner() public view returns (address) {
619         return _owner;
620     }
621 
622     /**
623      * @dev Throws if called by any account other than the owner.
624      */
625     modifier onlyOwner() {
626         require(isOwner());
627         _;
628     }
629 
630     /**
631      * @return true if `msg.sender` is the owner of the contract.
632      */
633     function isOwner() public view returns (bool) {
634         return msg.sender == _owner;
635     }
636 
637     /**
638      * @dev Allows the current owner to relinquish control of the contract.
639      * It will not be possible to call the functions with the `onlyOwner`
640      * modifier anymore.
641      * @notice Renouncing ownership will leave the contract without an owner,
642      * thereby removing any functionality that is only available to the owner.
643      */
644     function renounceOwnership() public onlyOwner {
645         emit OwnershipTransferred(_owner, address(0));
646         _owner = address(0);
647     }
648 
649     /**
650      * @dev Allows the current owner to transfer control of the contract to a newOwner.
651      * @param newOwner The address to transfer ownership to.
652      */
653     function transferOwnership(address newOwner) public onlyOwner {
654         _transferOwnership(newOwner);
655     }
656 
657     /**
658      * @dev Transfers control of the contract to a newOwner.
659      * @param newOwner The address to transfer ownership to.
660      */
661     function _transferOwnership(address newOwner) internal {
662         require(newOwner != address(0));
663         emit OwnershipTransferred(_owner, newOwner);
664         _owner = newOwner;
665     }
666 }
667 
668 
669 contract DATACHAIN is ERC777ERC20BaseToken, Ownable {
670     string internal dName = "DATACHAIN";
671     string internal dSymbol = "DC";
672     uint256 internal dGranularity = 1;
673     uint256 internal dTotalSupply = 1000000000 * (10**18);
674 
675     function dDefaultOperators() internal pure returns (address[] memory) {
676         address[] memory defaultOps = new address[](1);
677         
678         defaultOps[0] = 0xa6903375509A5F4f740aEC4Aa677b8C18D41027b;
679         
680         return defaultOps;
681     }
682 
683     constructor() public 
684         ERC777ERC20BaseToken(
685             dName, 
686             dSymbol, 
687             dGranularity, 
688             dDefaultOperators()) 
689     {
690         _mint(msg.sender, dTotalSupply);
691     }
692 
693     function _mint(address to, uint256 value) internal returns (bool) {
694 
695         require(to != address(0));
696 
697         requireMultiple(value);
698 
699         mTotalSupply = mTotalSupply.add(value);
700         mBalances[to] = mBalances[to].add(value);
701 
702         callRecipient(msg.sender, address(0), to, value, "", "", true);
703 
704 
705         emit Minted(msg.sender, to, value, "", "");
706 
707         emit Transfer(address(0), to, value);
708 
709         return true;
710     }
711 
712     function mint(address to, uint256 value) public onlyOwner returns (bool) {
713         _mint(to, value);
714         return true;
715     }
716 }