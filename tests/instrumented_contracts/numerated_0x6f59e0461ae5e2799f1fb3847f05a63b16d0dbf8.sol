1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address who) public view returns (uint256);
129   function transfer(address to, uint256 value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address owner, address spender)
141     public view returns (uint256);
142 
143   function transferFrom(address from, address to, uint256 value)
144     public returns (bool);
145 
146   function approve(address spender, uint256 value) public returns (bool);
147   event Approval(
148     address indexed owner,
149     address indexed spender,
150     uint256 value
151   );
152 }
153 
154 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
155 
156 /**
157  * @title SafeERC20
158  * @dev Wrappers around ERC20 operations that throw on failure.
159  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
160  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
161  */
162 library SafeERC20 {
163   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
164     require(token.transfer(to, value));
165   }
166 
167   function safeTransferFrom(
168     ERC20 token,
169     address from,
170     address to,
171     uint256 value
172   )
173     internal
174   {
175     require(token.transferFrom(from, to, value));
176   }
177 
178   function safeApprove(ERC20 token, address spender, uint256 value) internal {
179     require(token.approve(spender, value));
180   }
181 }
182 
183 // Custom contracts developed or adapted for OrcaToken
184 // ---------------------------------------------------
185 
186 contract TokenRecoverable is Ownable {
187     using SafeERC20 for ERC20Basic;
188 
189     function recoverTokens(ERC20Basic token, address to, uint256 amount) public onlyOwner {
190         uint256 balance = token.balanceOf(address(this));
191         require(balance >= amount);
192         token.safeTransfer(to, amount);
193     }
194 }
195 
196 // File: contracts/eip820/contracts/ERC820Implementer.sol
197 
198 contract ERC820Registry {
199     function getManager(address addr) public view returns(address);
200     function setManager(address addr, address newManager) public;
201     function getInterfaceImplementer(address addr, bytes32 iHash) public constant returns (address);
202     function setInterfaceImplementer(address addr, bytes32 iHash, address implementer) public;
203 }
204 
205 
206 contract ERC820Implementer {
207     ERC820Registry erc820Registry = ERC820Registry(0x991a1bcb077599290d7305493c9A630c20f8b798);
208 
209     function setInterfaceImplementation(string ifaceLabel, address impl) internal {
210         bytes32 ifaceHash = keccak256(abi.encodePacked(ifaceLabel));
211         erc820Registry.setInterfaceImplementer(this, ifaceHash, impl);
212     }
213 
214     function interfaceAddr(address addr, string ifaceLabel) internal constant returns(address) {
215         bytes32 ifaceHash = keccak256(abi.encodePacked(ifaceLabel));
216         return erc820Registry.getInterfaceImplementer(addr, ifaceHash);
217     }
218 
219     function delegateManagement(address newManager) internal {
220         erc820Registry.setManager(this, newManager);
221     }
222 }
223 
224 contract ERC20Token {
225     function name() public view returns (string);
226     function symbol() public view returns (string);
227     function decimals() public view returns (uint8);
228     function totalSupply() public view returns (uint256);
229     function balanceOf(address owner) public view returns (uint256);
230     function transfer(address to, uint256 amount) public returns (bool);
231     function transferFrom(address from, address to, uint256 amount) public returns (bool);
232     function approve(address spender, uint256 amount) public returns (bool);
233     function allowance(address owner, address spender) public view returns (uint256);
234 
235     // solhint-disable-next-line no-simple-event-func-name
236     event Transfer(address indexed from, address indexed to, uint256 amount);
237     event Approval(address indexed owner, address indexed spender, uint256 amount);
238 }
239 
240 contract ERC777Token {
241     function name() public view returns (string);
242     function symbol() public view returns (string);
243     function totalSupply() public view returns (uint256);
244     function balanceOf(address owner) public view returns (uint256);
245     function granularity() public view returns (uint256);
246 
247     function defaultOperators() public view returns (address[]);
248     function isOperatorFor(address operator, address tokenHolder) public view returns (bool);
249     function authorizeOperator(address operator) public;
250     function revokeOperator(address operator) public;
251 
252     function send(address to, uint256 amount, bytes holderData) public;
253     function operatorSend(address from, address to, uint256 amount, bytes holderData, bytes operatorData) public;
254 
255     function burn(uint256 amount, bytes holderData) public;
256     function operatorBurn(address from, uint256 amount, bytes holderData, bytes operatorData) public;
257 
258     event Sent(
259         address indexed operator,
260         address indexed from,
261         address indexed to,
262         uint256 amount,
263         bytes holderData,
264         bytes operatorData
265     ); // solhint-disable-next-line separate-by-one-line-in-contract
266     event Minted(address indexed operator, address indexed to, uint256 amount, bytes operatorData);
267     event Burned(address indexed operator, address indexed from, uint256 amount, bytes holderData, bytes operatorData);
268     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
269     event RevokedOperator(address indexed operator, address indexed tokenHolder);
270 }
271 
272 contract ERC777TokensRecipient {
273     function tokensReceived(
274         address operator,
275         address from,
276         address to,
277         uint amount,
278         bytes userData,
279         bytes operatorData
280     ) public;
281 }
282 
283 contract ERC777TokensSender {
284     function tokensToSend(
285         address operator,
286         address from,
287         address to,
288         uint amount,
289         bytes userData,
290         bytes operatorData
291     ) public;
292 }
293 
294 contract ERC777BaseToken is ERC777Token, ERC820Implementer {
295     using SafeMath for uint256;
296 
297     string internal mName;
298     string internal mSymbol;
299     uint256 internal mGranularity;
300     uint256 internal mTotalSupply;
301 
302 
303     mapping(address => uint) internal mBalances;
304     mapping(address => mapping(address => bool)) internal mAuthorized;
305 
306     address[] internal mDefaultOperators;
307     mapping(address => bool) internal mIsDefaultOperator;
308     mapping(address => mapping(address => bool)) internal mRevokedDefaultOperator;
309 
310     /* -- Constructor -- */
311     //
312     /// @notice Constructor to create a ReferenceToken
313     /// @param _name Name of the new token
314     /// @param _symbol Symbol of the new token.
315     /// @param _granularity Minimum transferable chunk.
316     constructor(string _name, string _symbol, uint256 _granularity, address[] _defaultOperators) internal {
317         mName = _name;
318         mSymbol = _symbol;
319         mTotalSupply = 0;
320         require(_granularity >= 1);
321         mGranularity = _granularity;
322 
323         mDefaultOperators = _defaultOperators;
324         for (uint i = 0; i < mDefaultOperators.length; i++) { mIsDefaultOperator[mDefaultOperators[i]] = true; }
325 
326         setInterfaceImplementation("ERC777Token", this);
327     }
328 
329     /* -- ERC777 Interface Implementation -- */
330     //
331     /// @return the name of the token
332     function name() public constant returns (string) { return mName; }
333 
334     /// @return the symbol of the token
335     function symbol() public constant returns (string) { return mSymbol; }
336 
337     /// @return the granularity of the token
338     function granularity() public constant returns (uint256) { return mGranularity; }
339 
340     /// @return the total supply of the token
341     function totalSupply() public constant returns (uint256) { return mTotalSupply; }
342 
343     /// @notice Return the account balance of some account
344     /// @param _tokenHolder Address for which the balance is returned
345     /// @return the balance of `_tokenAddress`.
346     function balanceOf(address _tokenHolder) public constant returns (uint256) { return mBalances[_tokenHolder]; }
347 
348     /// @notice Return the list of default operators
349     /// @return the list of all the default operators
350     function defaultOperators() public view returns (address[]) { return mDefaultOperators; }
351 
352     /// @notice Send `_amount` of tokens to address `_to` passing `_userData` to the recipient
353     /// @param _to The address of the recipient
354     /// @param _amount The number of tokens to be sent
355     function send(address _to, uint256 _amount, bytes _userData) public {
356         doSend(msg.sender, msg.sender, _to, _amount, _userData, "", true);
357     }
358 
359     /// @notice Authorize a third party `_operator` to manage (send) `msg.sender`'s tokens.
360     /// @param _operator The operator that wants to be Authorized
361     function authorizeOperator(address _operator) public {
362         require(_operator != msg.sender);
363         if (mIsDefaultOperator[_operator]) {
364             mRevokedDefaultOperator[_operator][msg.sender] = false;
365         } else {
366             mAuthorized[_operator][msg.sender] = true;
367         }
368         emit AuthorizedOperator(_operator, msg.sender);
369     }
370 
371     /// @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens.
372     /// @param _operator The operator that wants to be Revoked
373     function revokeOperator(address _operator) public {
374         require(_operator != msg.sender);
375         if (mIsDefaultOperator[_operator]) {
376             mRevokedDefaultOperator[_operator][msg.sender] = true;
377         } else {
378             mAuthorized[_operator][msg.sender] = false;
379         }
380         emit RevokedOperator(_operator, msg.sender);
381     }
382 
383     /// @notice Check whether the `_operator` address is allowed to manage the tokens held by `_tokenHolder` address.
384     /// @param _operator address to check if it has the right to manage the tokens
385     /// @param _tokenHolder address which holds the tokens to be managed
386     /// @return `true` if `_operator` is authorized for `_tokenHolder`
387     function isOperatorFor(address _operator, address _tokenHolder) public constant returns (bool) {
388         return (_operator == _tokenHolder
389             || mAuthorized[_operator][_tokenHolder]
390             || (mIsDefaultOperator[_operator] && !mRevokedDefaultOperator[_operator][_tokenHolder]));
391     }
392 
393     /// @notice Send `_amount` of tokens on behalf of the address `from` to the address `to`.
394     /// @param _from The address holding the tokens being sent
395     /// @param _to The address of the recipient
396     /// @param _amount The number of tokens to be sent
397     /// @param _userData Data generated by the user to be sent to the recipient
398     /// @param _operatorData Data generated by the operator to be sent to the recipient
399     function operatorSend(address _from, address _to, uint256 _amount, bytes _userData, bytes _operatorData) public {
400         require(isOperatorFor(msg.sender, _from));
401         doSend(msg.sender, _from, _to, _amount, _userData, _operatorData, true);
402     }
403 
404     function burn(uint256 _amount, bytes _holderData) public {
405         doBurn(msg.sender, msg.sender, _amount, _holderData, "");
406     }
407 
408     function operatorBurn(address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData) public {
409         require(isOperatorFor(msg.sender, _tokenHolder));
410         doBurn(msg.sender, _tokenHolder, _amount, _holderData, _operatorData);
411     }
412 
413     /* -- Helper Functions -- */
414     //
415     /// @notice Internal function that ensures `_amount` is multiple of the granularity
416     /// @param _amount The quantity that want's to be checked
417     function requireMultiple(uint256 _amount) internal view {
418         require(_amount.div(mGranularity).mul(mGranularity) == _amount);
419     }
420 
421     /// @notice Check whether an address is a regular address or not.
422     /// @param _addr Address of the contract that has to be checked
423     /// @return `true` if `_addr` is a regular address (not a contract)
424     function isRegularAddress(address _addr) internal constant returns(bool) {
425         if (_addr == 0) { return false; }
426         uint size;
427         assembly { size := extcodesize(_addr) } // solhint-disable-line no-inline-assembly
428         return size == 0;
429     }
430 
431     /// @notice Helper function actually performing the sending of tokens.
432     /// @param _operator The address performing the send
433     /// @param _from The address holding the tokens being sent
434     /// @param _to The address of the recipient
435     /// @param _amount The number of tokens to be sent
436     /// @param _userData Data generated by the user to be passed to the recipient
437     /// @param _operatorData Data generated by the operator to be passed to the recipient
438     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
439     ///  implementing `erc777_tokenHolder`.
440     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
441     ///  functions SHOULD set this parameter to `false`.
442     function doSend(
443         address _operator,
444         address _from,
445         address _to,
446         uint256 _amount,
447         bytes _userData,
448         bytes _operatorData,
449         bool _preventLocking
450     )
451         internal
452     {
453         requireMultiple(_amount);
454 
455         callSender(_operator, _from, _to, _amount, _userData, _operatorData);
456 
457         require(_to != address(0));          // forbid sending to 0x0 (=burning)
458         require(mBalances[_from] >= _amount); // ensure enough funds
459 
460         mBalances[_from] = mBalances[_from].sub(_amount);
461         mBalances[_to] = mBalances[_to].add(_amount);
462 
463         callRecipient(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
464 
465         emit Sent(_operator, _from, _to, _amount, _userData, _operatorData);
466     }
467 
468     /// @notice Helper function actually performing the burning of tokens.
469     /// @param _operator The address performing the burn
470     /// @param _tokenHolder The address holding the tokens being burn
471     /// @param _amount The number of tokens to be burnt
472     /// @param _holderData Data generated by the token holder
473     /// @param _operatorData Data generated by the operator
474     function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData)
475         internal
476     {
477         requireMultiple(_amount);
478         require(balanceOf(_tokenHolder) >= _amount);
479 
480         mBalances[_tokenHolder] = mBalances[_tokenHolder].sub(_amount);
481         mTotalSupply = mTotalSupply.sub(_amount);
482 
483         callSender(_operator, _tokenHolder, 0x0, _amount, _holderData, _operatorData);
484         emit Burned(_operator, _tokenHolder, _amount, _holderData, _operatorData);
485     }
486 
487     /// @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.
488     ///  May throw according to `_preventLocking`
489     /// @param _operator The address performing the send or mint
490     /// @param _from The address holding the tokens being sent
491     /// @param _to The address of the recipient
492     /// @param _amount The number of tokens to be sent
493     /// @param _userData Data generated by the user to be passed to the recipient
494     /// @param _operatorData Data generated by the operator to be passed to the recipient
495     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
496     ///  implementing `ERC777TokensRecipient`.
497     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
498     ///  functions SHOULD set this parameter to `false`.
499     function callRecipient(
500         address _operator,
501         address _from,
502         address _to,
503         uint256 _amount,
504         bytes _userData,
505         bytes _operatorData,
506         bool _preventLocking
507     )
508         internal
509     {
510         address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");
511         if (recipientImplementation != 0) {
512             ERC777TokensRecipient(recipientImplementation).tokensReceived(
513                 _operator, _from, _to, _amount, _userData, _operatorData);
514         } else if (_preventLocking) {
515             require(isRegularAddress(_to));
516         }
517     }
518 
519     /// @notice Helper function that checks for ERC777TokensSender on the sender and calls it.
520     ///  May throw according to `_preventLocking`
521     /// @param _from The address holding the tokens being sent
522     /// @param _to The address of the recipient
523     /// @param _amount The amount of tokens to be sent
524     /// @param _userData Data generated by the user to be passed to the recipient
525     /// @param _operatorData Data generated by the operator to be passed to the recipient
526     ///  implementing `ERC777TokensSender`.
527     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
528     ///  functions SHOULD set this parameter to `false`.
529     function callSender(
530         address _operator,
531         address _from,
532         address _to,
533         uint256 _amount,
534         bytes _userData,
535         bytes _operatorData
536     )
537         internal
538     {
539         address senderImplementation = interfaceAddr(_from, "ERC777TokensSender");
540         if (senderImplementation == 0) { return; }
541         ERC777TokensSender(senderImplementation).tokensToSend(_operator, _from, _to, _amount, _userData, _operatorData);
542     }
543 }
544 
545 contract ERC777ERC20BaseToken is ERC20Token, ERC777BaseToken {
546     bool internal mErc20compatible;
547 
548     mapping(address => mapping(address => bool)) internal mAuthorized;
549     mapping(address => mapping(address => uint256)) internal mAllowed;
550 
551     constructor(
552         string _name,
553         string _symbol,
554         uint256 _granularity,
555         address[] _defaultOperators
556     )
557         internal ERC777BaseToken(_name, _symbol, _granularity, _defaultOperators)
558     {
559         mErc20compatible = true;
560         setInterfaceImplementation("ERC20Token", this);
561     }
562 
563     /// @notice This modifier is applied to erc20 obsolete methods that are
564     ///  implemented only to maintain backwards compatibility. When the erc20
565     ///  compatibility is disabled, this methods will fail.
566     modifier erc20 () {
567         require(mErc20compatible);
568         _;
569     }
570 
571     /// @notice For Backwards compatibility
572     /// @return The decimls of the token. Forced to 18 in ERC777.
573     function decimals() public erc20 constant returns (uint8) { return uint8(18); }
574 
575     /// @notice ERC20 backwards compatible transfer.
576     /// @param _to The address of the recipient
577     /// @param _amount The number of tokens to be transferred
578     /// @return `true`, if the transfer can't be done, it should fail.
579     function transfer(address _to, uint256 _amount) public erc20 returns (bool success) {
580         doSend(msg.sender, msg.sender, _to, _amount, "", "", false);
581         return true;
582     }
583 
584     /// @notice ERC20 backwards compatible transferFrom.
585     /// @param _from The address holding the tokens being transferred
586     /// @param _to The address of the recipient
587     /// @param _amount The number of tokens to be transferred
588     /// @return `true`, if the transfer can't be done, it should fail.
589     function transferFrom(address _from, address _to, uint256 _amount) public erc20 returns (bool success) {
590         require(_amount <= mAllowed[_from][msg.sender]);
591 
592         // Cannot be after doSend because of tokensReceived re-entry
593         mAllowed[_from][msg.sender] = mAllowed[_from][msg.sender].sub(_amount);
594         doSend(msg.sender, _from, _to, _amount, "", "", false);
595         return true;
596     }
597 
598     /// @notice ERC20 backwards compatible approve.
599     ///  `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
600     /// @param _spender The address of the account able to transfer the tokens
601     /// @param _amount The number of tokens to be approved for transfer
602     /// @return `true`, if the approve can't be done, it should fail.
603     function approve(address _spender, uint256 _amount) public erc20 returns (bool success) {
604         mAllowed[msg.sender][_spender] = _amount;
605         emit Approval(msg.sender, _spender, _amount);
606         return true;
607     }
608 
609     /// @notice ERC20 backwards compatible allowance.
610     ///  This function makes it easy to read the `allowed[]` map
611     /// @param _owner The address of the account that owns the token
612     /// @param _spender The address of the account able to transfer the tokens
613     /// @return Amount of remaining tokens of _owner that _spender is allowed
614     ///  to spend
615     function allowance(address _owner, address _spender) public erc20 constant returns (uint256 remaining) {
616         return mAllowed[_owner][_spender];
617     }
618 
619     function doSend(
620         address _operator,
621         address _from,
622         address _to,
623         uint256 _amount,
624         bytes _userData,
625         bytes _operatorData,
626         bool _preventLocking
627     )
628         internal
629     {
630         super.doSend(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
631         if (mErc20compatible) { emit Transfer(_from, _to, _amount); }
632     }
633 
634     function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData)
635         internal
636     {
637         super.doBurn(_operator, _tokenHolder, _amount, _holderData, _operatorData);
638         if (mErc20compatible) { emit Transfer(_tokenHolder, 0x0, _amount); }
639     }
640 }
641 
642 contract OrcaToken is TokenRecoverable, ERC777ERC20BaseToken {
643     using SafeMath for uint256;
644 
645     string private constant name_ = "ORCA Token";
646     string private constant symbol_ = "ORCA";
647     uint256 private constant granularity_ = 1;
648 
649     bool public throwOnIncompatibleContract = true;
650     bool public burnEnabled = false;
651     bool public mintingFinished = false;
652 
653     address public communityLock = address(0);
654 
655     event MintFinished();
656 
657     /// @notice Constructor to create a OrcaToken
658     constructor() public ERC777ERC20BaseToken(name_, symbol_, granularity_, new address[](0)) {
659         setInterfaceImplementation("ERC20Token", address(this));
660         setInterfaceImplementation("ERC777Token", address(this));
661     }
662 
663     modifier canMint() {
664         require(!mintingFinished);
665       _;
666     }
667 
668     modifier canTrade() {
669         require(mintingFinished);
670         _;
671     }
672 
673     modifier canBurn() {
674         require(burnEnabled || msg.sender == communityLock);
675         _;
676     }
677 
678     /// @notice Disables the ERC20 interface. This function can only be called
679     ///  by the owner.
680     function disableERC20() public onlyOwner {
681         mErc20compatible = false;
682         setInterfaceImplementation("ERC20Token", 0x0);
683     }
684 
685     /// @notice Re enables the ERC20 interface. This function can only be called
686     ///  by the owner.
687     function enableERC20() public onlyOwner {
688         mErc20compatible = true;
689         setInterfaceImplementation("ERC20Token", this);
690     }
691 
692     function send(address _to, uint256 _amount, bytes _userData) public canTrade {
693         super.send(_to, _amount, _userData);
694     }
695 
696     function operatorSend(address _from, address _to, uint256 _amount, bytes _userData, bytes _operatorData) public canTrade {
697         super.operatorSend(_from, _to, _amount, _userData, _operatorData);
698     }
699 
700     function transfer(address _to, uint256 _amount) public erc20 canTrade returns (bool success) {
701         return super.transfer(_to, _amount);
702     }
703 
704     function transferFrom(address _from, address _to, uint256 _amount) public erc20 canTrade returns (bool success) {
705         return super.transferFrom(_from, _to, _amount);
706     }
707 
708     /* -- Mint And Burn Functions (not part of the ERC777 standard, only the Events/tokensReceived call are) -- */
709     //
710     /// @notice Generates `_amount` tokens to be assigned to `_tokenHolder`
711     ///  Sample mint function to showcase the use of the `Minted` event and the logic to notify the recipient.
712     /// @param _tokenHolder The address that will be assigned the new tokens
713     /// @param _amount The quantity of tokens generated
714     /// @param _operatorData Data that will be passed to the recipient as a first transfer
715     function mint(address _tokenHolder, uint256 _amount, bytes _operatorData) public onlyOwner canMint {
716         requireMultiple(_amount);
717         mTotalSupply = mTotalSupply.add(_amount);
718         mBalances[_tokenHolder] = mBalances[_tokenHolder].add(_amount);
719 
720         callRecipient(msg.sender, 0x0, _tokenHolder, _amount, "", _operatorData, false);
721 
722         emit Minted(msg.sender, _tokenHolder, _amount, _operatorData);
723         if (mErc20compatible) { emit Transfer(0x0, _tokenHolder, _amount); }
724     }
725 
726     /// @notice Burns `_amount` tokens from `_tokenHolder`
727     ///  Sample burn function to showcase the use of the `Burned` event.
728     /// @param _amount The quantity of tokens to burn
729     function burn(uint256 _amount, bytes _holderData) public canBurn {
730         super.burn(_amount, _holderData);
731     }
732 
733     /**
734      * @dev Function to stop minting new tokens.
735      * @return True if the operation was successful.
736      */
737     function finishMinting() public onlyOwner canMint {
738         mintingFinished = true;
739         emit MintFinished();
740     }
741 
742     function setThrowOnIncompatibleContract(bool _throwOnIncompatibleContract) public onlyOwner {
743         throwOnIncompatibleContract = _throwOnIncompatibleContract;
744     }
745 
746     function setCommunityLock(address _communityLock) public onlyOwner {
747         require(_communityLock != address(0));
748         communityLock = _communityLock;
749     }
750 
751     function permitBurning(bool _enable) public onlyOwner {
752         burnEnabled = _enable;
753     }
754 
755     /// @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.
756     ///  May throw according to `_preventLocking`
757     /// @param _from The address holding the tokens being sent
758     /// @param _to The address of the recipient
759     /// @param _amount The number of tokens to be sent
760     /// @param _userData Data generated by the user to be passed to the recipient
761     /// @param _operatorData Data generated by the operator to be passed to the recipient
762     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
763     ///  implementing `ERC777TokensRecipient`.
764     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
765     ///  functions SHOULD set this parameter to `false`.
766     function callRecipient(
767         address _operator,
768         address _from,
769         address _to,
770         uint256 _amount,
771         bytes _userData,
772         bytes _operatorData,
773         bool _preventLocking
774     ) internal {
775         address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");
776         if (recipientImplementation != 0) {
777             ERC777TokensRecipient(recipientImplementation).tokensReceived(
778                 _operator, _from, _to, _amount, _userData, _operatorData);
779         } else if (throwOnIncompatibleContract && _preventLocking) {
780             require(isRegularAddress(_to));
781         }
782     }
783 }