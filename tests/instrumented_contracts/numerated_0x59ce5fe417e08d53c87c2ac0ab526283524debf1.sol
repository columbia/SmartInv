1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 contract ERC20Basic {
65   function totalSupply() public view returns (uint256);
66   function balanceOf(address _who) public view returns (uint256);
67   function transfer(address _to, uint256 _value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 contract ERC20 is ERC20Basic {
71   function allowance(address _owner, address _spender)
72     public view returns (uint256);
73 
74   function transferFrom(address _from, address _to, uint256 _value)
75     public returns (bool);
76 
77   function approve(address _spender, uint256 _value) public returns (bool);
78   event Approval(
79     address indexed owner,
80     address indexed spender,
81     uint256 value
82   );
83 }
84 library SafeERC20 {
85   function safeTransfer(
86     ERC20Basic _token,
87     address _to,
88     uint256 _value
89   )
90     internal
91   {
92     require(_token.transfer(_to, _value));
93   }
94 
95   function safeTransferFrom(
96     ERC20 _token,
97     address _from,
98     address _to,
99     uint256 _value
100   )
101     internal
102   {
103     require(_token.transferFrom(_from, _to, _value));
104   }
105 
106   function safeApprove(
107     ERC20 _token,
108     address _spender,
109     uint256 _value
110   )
111     internal
112   {
113     require(_token.approve(_spender, _value));
114   }
115 }
116 contract TokenRecoverable is Ownable {
117     using SafeERC20 for ERC20Basic;
118 
119     function recoverTokens(ERC20Basic token, address to, uint256 amount) public onlyOwner {
120         uint256 balance = token.balanceOf(address(this));
121         require(balance >= amount);
122         token.safeTransfer(to, amount);
123     }
124 }
125 library SafeMath {
126 
127   /**
128   * @dev Multiplies two numbers, throws on overflow.
129   */
130   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
131     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
132     // benefit is lost if 'b' is also tested.
133     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
134     if (_a == 0) {
135       return 0;
136     }
137 
138     c = _a * _b;
139     assert(c / _a == _b);
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers, truncating the quotient.
145   */
146   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
147     // assert(_b > 0); // Solidity automatically throws when dividing by 0
148     // uint256 c = _a / _b;
149     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
150     return _a / _b;
151   }
152 
153   /**
154   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
155   */
156   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
157     assert(_b <= _a);
158     return _a - _b;
159   }
160 
161   /**
162   * @dev Adds two numbers, throws on overflow.
163   */
164   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
165     c = _a + _b;
166     assert(c >= _a);
167     return c;
168   }
169 }
170 
171 contract ERC820Registry {
172     function getManager(address addr) public view returns(address);
173     function setManager(address addr, address newManager) public;
174     function getInterfaceImplementer(address addr, bytes32 iHash) public constant returns (address);
175     function setInterfaceImplementer(address addr, bytes32 iHash, address implementer) public;
176 }
177 
178 
179 contract ERC820Implementer {
180     ERC820Registry erc820Registry = ERC820Registry(0x991a1bcb077599290d7305493c9A630c20f8b798);
181 
182     function setInterfaceImplementation(string ifaceLabel, address impl) internal {
183         bytes32 ifaceHash = keccak256(abi.encodePacked(ifaceLabel));
184         erc820Registry.setInterfaceImplementer(this, ifaceHash, impl);
185     }
186 
187     function interfaceAddr(address addr, string ifaceLabel) internal constant returns(address) {
188         bytes32 ifaceHash = keccak256(abi.encodePacked(ifaceLabel));
189         return erc820Registry.getInterfaceImplementer(addr, ifaceHash);
190     }
191 
192     function delegateManagement(address newManager) internal {
193         erc820Registry.setManager(this, newManager);
194     }
195 }
196 
197 contract ERC20Token {
198     function name() public view returns (string);
199     function symbol() public view returns (string);
200     function decimals() public view returns (uint8);
201     function totalSupply() public view returns (uint256);
202     function balanceOf(address owner) public view returns (uint256);
203     function transfer(address to, uint256 amount) public returns (bool);
204     function transferFrom(address from, address to, uint256 amount) public returns (bool);
205     function approve(address spender, uint256 amount) public returns (bool);
206     function allowance(address owner, address spender) public view returns (uint256);
207 
208     // solhint-disable-next-line no-simple-event-func-name
209     event Transfer(address indexed from, address indexed to, uint256 amount);
210     event Approval(address indexed owner, address indexed spender, uint256 amount);
211 }
212 
213 contract ERC777Token {
214     function name() public view returns (string);
215     function symbol() public view returns (string);
216     function totalSupply() public view returns (uint256);
217     function balanceOf(address owner) public view returns (uint256);
218     function granularity() public view returns (uint256);
219 
220     function defaultOperators() public view returns (address[]);
221     function isOperatorFor(address operator, address tokenHolder) public view returns (bool);
222     function authorizeOperator(address operator) public;
223     function revokeOperator(address operator) public;
224 
225     function send(address to, uint256 amount, bytes holderData) public;
226     function operatorSend(address from, address to, uint256 amount, bytes holderData, bytes operatorData) public;
227 
228     function burn(uint256 amount, bytes holderData) public;
229     function operatorBurn(address from, uint256 amount, bytes holderData, bytes operatorData) public;
230 
231     event Sent(
232         address indexed operator,
233         address indexed from,
234         address indexed to,
235         uint256 amount,
236         bytes holderData,
237         bytes operatorData
238     ); // solhint-disable-next-line separate-by-one-line-in-contract
239     event Minted(address indexed operator, address indexed to, uint256 amount, bytes operatorData);
240     event Burned(address indexed operator, address indexed from, uint256 amount, bytes holderData, bytes operatorData);
241     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
242     event RevokedOperator(address indexed operator, address indexed tokenHolder);
243 }
244 
245 
246 contract ERC777TokensRecipient {
247     function tokensReceived(
248         address operator,
249         address from,
250         address to,
251         uint amount,
252         bytes userData,
253         bytes operatorData
254     ) public;
255 }
256 
257 
258 contract ERC777TokensSender {
259     function tokensToSend(
260         address operator,
261         address from,
262         address to,
263         uint amount,
264         bytes userData,
265         bytes operatorData
266     ) public;
267 }
268 
269 contract ERC777BaseToken is ERC777Token, ERC820Implementer {
270     using SafeMath for uint256;
271 
272     string internal mName;
273     string internal mSymbol;
274     uint256 internal mGranularity;
275     uint256 internal mTotalSupply;
276 
277 
278     mapping(address => uint) internal mBalances;
279     mapping(address => mapping(address => bool)) internal mAuthorized;
280 
281     address[] internal mDefaultOperators;
282     mapping(address => bool) internal mIsDefaultOperator;
283     mapping(address => mapping(address => bool)) internal mRevokedDefaultOperator;
284 
285     /* -- Constructor -- */
286     //
287     /// @notice Constructor to create a ReferenceToken
288     /// @param _name Name of the new token
289     /// @param _symbol Symbol of the new token.
290     /// @param _granularity Minimum transferable chunk.
291     constructor(string _name, string _symbol, uint256 _granularity, address[] _defaultOperators) internal {
292         mName = _name;
293         mSymbol = _symbol;
294         mTotalSupply = 0;
295         require(_granularity >= 1);
296         mGranularity = _granularity;
297 
298         mDefaultOperators = _defaultOperators;
299         for (uint i = 0; i < mDefaultOperators.length; i++) { mIsDefaultOperator[mDefaultOperators[i]] = true; }
300 
301         setInterfaceImplementation("ERC777Token", this);
302     }
303 
304     /* -- ERC777 Interface Implementation -- */
305     //
306     /// @return the name of the token
307     function name() public view returns (string) { return mName; }
308 
309     /// @return the symbol of the token
310     function symbol() public view returns (string) { return mSymbol; }
311 
312     /// @return the granularity of the token
313     function granularity() public view returns (uint256) { return mGranularity; }
314 
315     /// @return the total supply of the token
316     function totalSupply() public view returns (uint256) { return mTotalSupply; }
317 
318     /// @notice Return the account balance of some account
319     /// @param _tokenHolder Address for which the balance is returned
320     /// @return the balance of `_tokenAddress`.
321     function balanceOf(address _tokenHolder) public view returns (uint256) { return mBalances[_tokenHolder]; }
322 
323     /// @notice Return the list of default operators
324     /// @return the list of all the default operators
325     function defaultOperators() public view returns (address[]) { return mDefaultOperators; }
326 
327     /// @notice Send `_amount` of tokens to address `_to` passing `_userData` to the recipient
328     /// @param _to The address of the recipient
329     /// @param _amount The number of tokens to be sent
330     function send(address _to, uint256 _amount, bytes _userData) public {
331         doSend(msg.sender, msg.sender, _to, _amount, _userData, "", true);
332     }
333 
334     /// @notice Authorize a third party `_operator` to manage (send) `msg.sender`'s tokens.
335     /// @param _operator The operator that wants to be Authorized
336     function authorizeOperator(address _operator) public {
337         require(_operator != msg.sender);
338         if (mIsDefaultOperator[_operator]) {
339             mRevokedDefaultOperator[_operator][msg.sender] = false;
340         } else {
341             mAuthorized[_operator][msg.sender] = true;
342         }
343         emit AuthorizedOperator(_operator, msg.sender);
344     }
345 
346     /// @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens.
347     /// @param _operator The operator that wants to be Revoked
348     function revokeOperator(address _operator) public {
349         require(_operator != msg.sender);
350         if (mIsDefaultOperator[_operator]) {
351             mRevokedDefaultOperator[_operator][msg.sender] = true;
352         } else {
353             mAuthorized[_operator][msg.sender] = false;
354         }
355         emit RevokedOperator(_operator, msg.sender);
356     }
357 
358     /// @notice Check whether the `_operator` address is allowed to manage the tokens held by `_tokenHolder` address.
359     /// @param _operator address to check if it has the right to manage the tokens
360     /// @param _tokenHolder address which holds the tokens to be managed
361     /// @return `true` if `_operator` is authorized for `_tokenHolder`
362     function isOperatorFor(address _operator, address _tokenHolder) public view returns (bool) {
363         return (_operator == _tokenHolder
364             || mAuthorized[_operator][_tokenHolder]
365             || (mIsDefaultOperator[_operator] && !mRevokedDefaultOperator[_operator][_tokenHolder]));
366     }
367 
368     /// @notice Send `_amount` of tokens on behalf of the address `from` to the address `to`.
369     /// @param _from The address holding the tokens being sent
370     /// @param _to The address of the recipient
371     /// @param _amount The number of tokens to be sent
372     /// @param _userData Data generated by the user to be sent to the recipient
373     /// @param _operatorData Data generated by the operator to be sent to the recipient
374     function operatorSend(address _from, address _to, uint256 _amount, bytes _userData, bytes _operatorData) public {
375         require(isOperatorFor(msg.sender, _from));
376         doSend(msg.sender, _from, _to, _amount, _userData, _operatorData, true);
377     }
378 
379     function burn(uint256 _amount, bytes _holderData) public {
380         doBurn(msg.sender, msg.sender, _amount, _holderData, "");
381     }
382 
383     function operatorBurn(address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData) public {
384         require(isOperatorFor(msg.sender, _tokenHolder));
385         doBurn(msg.sender, _tokenHolder, _amount, _holderData, _operatorData);
386     }
387 
388     /* -- Helper Functions -- */
389     //
390     /// @notice Internal function that ensures `_amount` is multiple of the granularity
391     /// @param _amount The quantity that want's to be checked
392     function requireMultiple(uint256 _amount) internal view {
393         require(_amount.div(mGranularity).mul(mGranularity) == _amount);
394     }
395 
396     /// @notice Check whether an address is a regular address or not.
397     /// @param _addr Address of the contract that has to be checked
398     /// @return `true` if `_addr` is a regular address (not a contract)
399     function isRegularAddress(address _addr) internal view returns(bool) {
400         if (_addr == 0) { return false; }
401         uint size;
402         assembly { size := extcodesize(_addr) } // solhint-disable-line no-inline-assembly
403         return size == 0;
404     }
405 
406     /// @notice Helper function actually performing the sending of tokens.
407     /// @param _operator The address performing the send
408     /// @param _from The address holding the tokens being sent
409     /// @param _to The address of the recipient
410     /// @param _amount The number of tokens to be sent
411     /// @param _userData Data generated by the user to be passed to the recipient
412     /// @param _operatorData Data generated by the operator to be passed to the recipient
413     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
414     ///  implementing `erc777_tokenHolder`.
415     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
416     ///  functions SHOULD set this parameter to `false`.
417     function doSend(
418         address _operator,
419         address _from,
420         address _to,
421         uint256 _amount,
422         bytes _userData,
423         bytes _operatorData,
424         bool _preventLocking
425     )
426         internal
427     {
428         requireMultiple(_amount);
429 
430         callSender(_operator, _from, _to, _amount, _userData, _operatorData);
431 
432         require(_to != address(0));          // forbid sending to 0x0 (=burning)
433         require(mBalances[_from] >= _amount); // ensure enough funds
434 
435         mBalances[_from] = mBalances[_from].sub(_amount);
436         mBalances[_to] = mBalances[_to].add(_amount);
437 
438         callRecipient(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
439 
440         emit Sent(_operator, _from, _to, _amount, _userData, _operatorData);
441     }
442 
443     /// @notice Helper function actually performing the burning of tokens.
444     /// @param _operator The address performing the burn
445     /// @param _tokenHolder The address holding the tokens being burn
446     /// @param _amount The number of tokens to be burnt
447     /// @param _holderData Data generated by the token holder
448     /// @param _operatorData Data generated by the operator
449     function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData)
450         internal
451     {
452         requireMultiple(_amount);
453         require(balanceOf(_tokenHolder) >= _amount);
454 
455         mBalances[_tokenHolder] = mBalances[_tokenHolder].sub(_amount);
456         mTotalSupply = mTotalSupply.sub(_amount);
457 
458         callSender(_operator, _tokenHolder, 0x0, _amount, _holderData, _operatorData);
459         emit Burned(_operator, _tokenHolder, _amount, _holderData, _operatorData);
460     }
461 
462     /// @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.
463     ///  May throw according to `_preventLocking`
464     /// @param _operator The address performing the send or mint
465     /// @param _from The address holding the tokens being sent
466     /// @param _to The address of the recipient
467     /// @param _amount The number of tokens to be sent
468     /// @param _userData Data generated by the user to be passed to the recipient
469     /// @param _operatorData Data generated by the operator to be passed to the recipient
470     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
471     ///  implementing `ERC777TokensRecipient`.
472     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
473     ///  functions SHOULD set this parameter to `false`.
474     function callRecipient(
475         address _operator,
476         address _from,
477         address _to,
478         uint256 _amount,
479         bytes _userData,
480         bytes _operatorData,
481         bool _preventLocking
482     )
483         internal
484     {
485         address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");
486         if (recipientImplementation != 0) {
487             ERC777TokensRecipient(recipientImplementation).tokensReceived(
488                 _operator, _from, _to, _amount, _userData, _operatorData);
489         } else if (_preventLocking) {
490             require(isRegularAddress(_to));
491         }
492     }
493 
494     /// @notice Helper function that checks for ERC777TokensSender on the sender and calls it.
495     ///  May throw according to `_preventLocking`
496     /// @param _from The address holding the tokens being sent
497     /// @param _to The address of the recipient
498     /// @param _amount The amount of tokens to be sent
499     /// @param _userData Data generated by the user to be passed to the recipient
500     /// @param _operatorData Data generated by the operator to be passed to the recipient
501     ///  implementing `ERC777TokensSender`.
502     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
503     ///  functions SHOULD set this parameter to `false`.
504     function callSender(
505         address _operator,
506         address _from,
507         address _to,
508         uint256 _amount,
509         bytes _userData,
510         bytes _operatorData
511     )
512         internal
513     {
514         address senderImplementation = interfaceAddr(_from, "ERC777TokensSender");
515         if (senderImplementation == 0) { return; }
516         ERC777TokensSender(senderImplementation).tokensToSend(_operator, _from, _to, _amount, _userData, _operatorData);
517     }
518 }
519 
520 
521 contract ERC777ERC20BaseToken is ERC20Token, ERC777BaseToken {
522     bool internal mErc20compatible;
523 
524     mapping(address => mapping(address => bool)) internal mAuthorized;
525     mapping(address => mapping(address => uint256)) internal mAllowed;
526 
527     constructor(
528         string _name,
529         string _symbol,
530         uint256 _granularity,
531         address[] _defaultOperators
532     )
533         internal ERC777BaseToken(_name, _symbol, _granularity, _defaultOperators)
534     {
535         mErc20compatible = true;
536         setInterfaceImplementation("ERC20Token", this);
537     }
538 
539     /// @notice This modifier is applied to erc20 obsolete methods that are
540     ///  implemented only to maintain backwards compatibility. When the erc20
541     ///  compatibility is disabled, this methods will fail.
542     modifier erc20 () {
543         require(mErc20compatible);
544         _;
545     }
546 
547     /// @notice For Backwards compatibility
548     /// @return The decimls of the token. Forced to 18 in ERC777.
549     function decimals() public erc20 view returns (uint8) { return uint8(18); }
550 
551     /// @notice ERC20 backwards compatible transfer.
552     /// @param _to The address of the recipient
553     /// @param _amount The number of tokens to be transferred
554     /// @return `true`, if the transfer can't be done, it should fail.
555     function transfer(address _to, uint256 _amount) public erc20 returns (bool success) {
556         doSend(msg.sender, msg.sender, _to, _amount, "", "", false);
557         return true;
558     }
559 
560     /// @notice ERC20 backwards compatible transferFrom.
561     /// @param _from The address holding the tokens being transferred
562     /// @param _to The address of the recipient
563     /// @param _amount The number of tokens to be transferred
564     /// @return `true`, if the transfer can't be done, it should fail.
565     function transferFrom(address _from, address _to, uint256 _amount) public erc20 returns (bool success) {
566         require(_amount <= mAllowed[_from][msg.sender]);
567 
568         // Cannot be after doSend because of tokensReceived re-entry
569         mAllowed[_from][msg.sender] = mAllowed[_from][msg.sender].sub(_amount);
570         doSend(msg.sender, _from, _to, _amount, "", "", false);
571         return true;
572     }
573 
574     /// @notice ERC20 backwards compatible approve.
575     ///  `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
576     /// @param _spender The address of the account able to transfer the tokens
577     /// @param _amount The number of tokens to be approved for transfer
578     /// @return `true`, if the approve can't be done, it should fail.
579     function approve(address _spender, uint256 _amount) public erc20 returns (bool success) {
580         mAllowed[msg.sender][_spender] = _amount;
581         emit Approval(msg.sender, _spender, _amount);
582         return true;
583     }
584 
585     /// @notice ERC20 backwards compatible allowance.
586     ///  This function makes it easy to read the `allowed[]` map
587     /// @param _owner The address of the account that owns the token
588     /// @param _spender The address of the account able to transfer the tokens
589     /// @return Amount of remaining tokens of _owner that _spender is allowed
590     ///  to spend
591     function allowance(address _owner, address _spender) public erc20 view returns (uint256 remaining) {
592         return mAllowed[_owner][_spender];
593     }
594 
595     function doSend(
596         address _operator,
597         address _from,
598         address _to,
599         uint256 _amount,
600         bytes _userData,
601         bytes _operatorData,
602         bool _preventLocking
603     )
604         internal
605     {
606         super.doSend(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
607         if (mErc20compatible) { emit Transfer(_from, _to, _amount); }
608     }
609 
610     function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData)
611         internal
612     {
613         super.doBurn(_operator, _tokenHolder, _amount, _holderData, _operatorData);
614         if (mErc20compatible) { emit Transfer(_tokenHolder, 0x0, _amount); }
615     }
616 }
617 
618 
619 /**
620  * @title Eliptic curve signature operations
621  *
622  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
623  *
624  * TODO Remove this library once solidity supports passing a signature to ecrecover.
625  * See https://github.com/ethereum/solidity/issues/864
626  *
627  */
628 library ECRecovery {
629 
630     /**
631     * @dev Recover signer address from a message by using their signature
632     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
633     * @param sig bytes signature, the signature is generated using web3.eth.sign()
634     */
635     function recover(bytes32 hash, bytes sig)
636         internal
637         pure
638         returns (address)
639     {
640         bytes32 r;
641         bytes32 s;
642         uint8 v;
643 
644         // Check the signature length
645         if (sig.length != 65) {
646             return (address(0));
647         }
648 
649         // Divide the signature in r, s and v variables
650         // ecrecover takes the signature parameters, and the only way to get them
651         // currently is to use assembly.
652         // solium-disable-next-line security/no-inline-assembly
653         assembly {
654             r := mload(add(sig, 32))
655             s := mload(add(sig, 64))
656             v := byte(0, mload(add(sig, 96)))
657         }
658 
659         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
660         if (v < 27) {
661             v += 27;
662         }
663 
664         // If the version is correct return the signer address
665         if (v != 27 && v != 28) {
666             return (address(0));
667         } else {
668         // solium-disable-next-line arg-overflow
669             return ecrecover(hash, v, r, s);
670         }
671     }
672 
673     /**
674     * toEthSignedMessageHash
675     * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
676     * @dev and hash the result
677     */
678     function toEthSignedMessageHash(bytes32 hash)
679         internal
680         pure
681         returns (bytes32)
682     {
683         // 32 is the length in bytes of hash,
684         // enforced by the type signature above
685         return keccak256(
686             abi.encodePacked(
687                 "\x19Ethereum Signed Message:\n32",
688                 hash
689             )
690         );
691     }
692 }
693 
694 contract FilesFMToken is TokenRecoverable, ERC777ERC20BaseToken {
695     using SafeMath for uint256;
696     using ECRecovery for bytes32;
697 
698     string private constant name_ = "Files.fm Token";
699     string private constant symbol_ = "FFM";
700     uint256 private constant granularity_ = 1;
701     
702     mapping(bytes => bool) private signatures;
703     address public tokenMinter;
704     address public tokenBag;
705     bool public throwOnIncompatibleContract = true;
706     bool public burnEnabled = false;
707     bool public transfersEnabled = false;
708     bool public defaultOperatorsComplete = false;
709 
710     event TokenBagChanged(address indexed oldAddress, address indexed newAddress, uint256 balance);
711     event DefaultOperatorAdded(address indexed operator);
712     event DefaultOperatorRemoved(address indexed operator);
713     event DefaultOperatorsCompleted();
714 
715     /// @notice Constructor to create a token
716     constructor() public ERC777ERC20BaseToken(name_, symbol_, granularity_, new address[](0)) {
717     }
718 
719     modifier canTransfer(address from, address to) {
720         require(transfersEnabled || from == tokenBag || to == tokenBag);
721         _;
722     }
723 
724     modifier canBurn() {
725         require(burnEnabled);
726         _;
727     }
728 
729     modifier hasMintPermission() {
730         require(msg.sender == owner || msg.sender == tokenMinter, "Only owner or token minter can mint tokens");
731         _;
732     }
733 
734     modifier canManageDefaultOperator() {
735         require(!defaultOperatorsComplete, "Default operator list is not editable");
736         _;
737     }
738 
739     /// @notice Disables the ERC20 interface. This function can only be called
740     ///  by the owner.
741     function disableERC20() public onlyOwner {
742         mErc20compatible = false;
743         setInterfaceImplementation("ERC20Token", 0x0);
744     }
745 
746     /// @notice Re enables the ERC20 interface. This function can only be called
747     ///  by the owner.
748     function enableERC20() public onlyOwner {
749         mErc20compatible = true;
750         setInterfaceImplementation("ERC20Token", this);
751     }
752 
753     function send(address _to, uint256 _amount, bytes _userData) public canTransfer(msg.sender, _to) {
754         super.send(_to, _amount, _userData);
755     }
756 
757     function operatorSend(
758         address _from, 
759         address _to, 
760         uint256 _amount, 
761         bytes _userData, 
762         bytes _operatorData) public canTransfer(_from, _to) {
763         super.operatorSend(_from, _to, _amount, _userData, _operatorData);
764     }
765 
766     function transfer(address _to, uint256 _amount) public erc20 canTransfer(msg.sender, _to) returns (bool success) {
767         return super.transfer(_to, _amount);
768     }
769 
770     function transferFrom(address _from, address _to, uint256 _amount) public erc20 canTransfer(_from, _to) returns (bool success) {
771         return super.transferFrom(_from, _to, _amount);
772     }
773 
774     /* -- Mint And Burn Functions (not part of the ERC777 standard, only the Events/tokensReceived call are) -- */
775     //
776     /// @notice Generates `_amount` tokens to be assigned to `_tokenHolder`
777     ///  Sample mint function to showcase the use of the `Minted` event and the logic to notify the recipient.
778     /// @param _tokenHolder The address that will be assigned the new tokens
779     /// @param _amount The quantity of tokens generated
780     /// @param _operatorData Data that will be passed to the recipient as a first transfer
781     function mint(address _tokenHolder, uint256 _amount, bytes _operatorData) public hasMintPermission {
782         doMint(_tokenHolder, _amount, _operatorData);
783     }
784 
785     function mintToken(address _tokenHolder, uint256 _amount) public hasMintPermission {
786         doMint(_tokenHolder, _amount, "");
787     }
788 
789     function mintTokens(address[] _tokenHolders, uint256[] _amounts) public hasMintPermission {
790         require(_tokenHolders.length > 0 && _tokenHolders.length <= 100);
791         require(_tokenHolders.length == _amounts.length);
792 
793         for (uint256 i = 0; i < _tokenHolders.length; i++) {
794             doMint(_tokenHolders[i], _amounts[i], "");
795         }
796     }
797 
798     /// @notice Burns `_amount` tokens from `_tokenHolder`
799     ///  Sample burn function to showcase the use of the `Burned` event.
800     /// @param _amount The quantity of tokens to burn
801     function burn(uint256 _amount, bytes _holderData) public canBurn {
802         super.burn(_amount, _holderData);
803     }
804 
805     function permitTransfers() public onlyOwner {
806         require(!transfersEnabled);
807         transfersEnabled = true;
808     }
809 
810     function setThrowOnIncompatibleContract(bool _throwOnIncompatibleContract) public onlyOwner {
811         throwOnIncompatibleContract = _throwOnIncompatibleContract;
812     }
813 
814     function permitBurning(bool _enable) public onlyOwner {
815         burnEnabled = _enable;
816     }
817 
818     function completeDefaultOperators() public onlyOwner canManageDefaultOperator {
819         defaultOperatorsComplete = true;
820         emit DefaultOperatorsCompleted();
821     }
822 
823     function setTokenMinter(address _tokenMinter) public onlyOwner {
824         tokenMinter = _tokenMinter;
825     }
826 
827     function setTokenBag(address _tokenBag) public onlyOwner {
828         uint256 balance = mBalances[tokenBag];
829         
830         if (_tokenBag == address(0)) {
831             require(balance == 0, "Token Bag balance must be 0");
832         } else if (balance > 0) {
833             doSend(msg.sender, tokenBag, _tokenBag, balance, "", "", false);
834         }
835 
836         emit TokenBagChanged(tokenBag, _tokenBag, balance);
837         tokenBag = _tokenBag;
838     }
839     
840     function renounceOwnership() public onlyOwner {
841         tokenMinter = address(0);
842         super.renounceOwnership();
843     }
844 
845     function transferOwnership(address _newOwner) public onlyOwner {
846         tokenMinter = address(0);
847         super.transferOwnership(_newOwner);
848     }
849 
850     /// @notice sends tokens using signature to recover token sender
851     /// @param _to the address of the recepient
852     /// @param _amount tokens to send
853     /// @param _fee amound of tokens which goes to msg.sender
854     /// @param _data arbitrary user data
855     /// @param _nonce value to protect from replay attacks
856     /// @param _sig concatenated r,s,v values
857     /// @return `true` if the token transfer is success, otherwise should fail
858     function sendWithSignature(address _to, uint256 _amount, uint256 _fee, bytes _data, uint256 _nonce, bytes _sig) public returns (bool) {
859         doSendWithSignature(_to, _amount, _fee, _data, _nonce, _sig, true);
860         return true;
861     }
862 
863     /// @notice transfers tokens in ERC20 compatible way using signature to recover token sender
864     /// @param _to the address of the recepient
865     /// @param _amount tokens to transfer
866     /// @param _fee amound of tokens which goes to msg.sender
867     /// @param _data arbitrary user data
868     /// @param _nonce value to protect from replay attacks
869     /// @param _sig concatenated r,s,v values
870     /// @return `true` if the token transfer is success, otherwise should fail
871     function transferWithSignature(address _to, uint256 _amount, uint256 _fee, bytes _data, uint256 _nonce, bytes _sig) public returns (bool) {
872         doSendWithSignature(_to, _amount, _fee, _data, _nonce, _sig, false);
873         return true;
874     }
875 
876     function addDefaultOperator(address _operator) public onlyOwner canManageDefaultOperator {
877         require(_operator != address(0), "Default operator cannot be set to address 0x0");
878         require(mIsDefaultOperator[_operator] == false, "This is already default operator");
879         mDefaultOperators.push(_operator);
880         mIsDefaultOperator[_operator] = true;
881         emit DefaultOperatorAdded(_operator);
882     }
883 
884     function removeDefaultOperator(address _operator) public onlyOwner canManageDefaultOperator {
885         require(mIsDefaultOperator[_operator] == true, "This operator is not default operator");
886         uint256 operatorIndex;
887         uint256 count = mDefaultOperators.length;
888         for (operatorIndex = 0; operatorIndex < count; operatorIndex++) {
889             if (mDefaultOperators[operatorIndex] == _operator) {
890                 break;
891             }
892         }
893         if (operatorIndex + 1 < count) {
894             mDefaultOperators[operatorIndex] = mDefaultOperators[count - 1];
895         }
896         mDefaultOperators.length = mDefaultOperators.length - 1;
897         mIsDefaultOperator[_operator] = false;
898         emit DefaultOperatorRemoved(_operator);
899     }
900 
901     function doMint(address _tokenHolder, uint256 _amount, bytes _operatorData) private {
902         require(_tokenHolder != address(0), "Cannot mint to address 0x0");
903         requireMultiple(_amount);
904 
905         mTotalSupply = mTotalSupply.add(_amount);
906         mBalances[_tokenHolder] = mBalances[_tokenHolder].add(_amount);
907 
908         callRecipient(msg.sender, address(0), _tokenHolder, _amount, "", _operatorData, false);
909 
910         emit Minted(msg.sender, _tokenHolder, _amount, _operatorData);
911         if (mErc20compatible) { emit Transfer(address(0), _tokenHolder, _amount); }
912     }
913 
914     function doSendWithSignature(address _to, uint256 _amount, uint256 _fee, bytes _data, uint256 _nonce, bytes _sig, bool _preventLocking) private {
915         require(_to != address(0));
916         require(_to != address(this)); // token contract does not accept own tokens
917 
918         require(signatures[_sig] == false);
919         signatures[_sig] = true;
920 
921         bytes memory packed;
922         if (_preventLocking) {
923             packed = abi.encodePacked(address(this), _to, _amount, _fee, _data, _nonce);
924         } else {
925             packed = abi.encodePacked(address(this), _to, _amount, _fee, _data, _nonce, "ERC20Compat");
926         }
927 
928         address signer = keccak256(packed)
929             .toEthSignedMessageHash()
930             .recover(_sig); // same security considerations as in Ethereum TX
931         
932         require(signer != address(0));
933         require(transfersEnabled || signer == tokenBag || _to == tokenBag);
934 
935         uint256 total = _amount.add(_fee);
936         require(mBalances[signer] >= total);
937 
938         doSend(msg.sender, signer, _to, _amount, _data, "", _preventLocking);
939         if (_fee > 0) {
940             doSend(msg.sender, signer, msg.sender, _fee, "", "", _preventLocking);
941         }
942     }
943 
944     /// @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.
945     ///  May throw according to `_preventLocking`
946     /// @param _from The address holding the tokens being sent
947     /// @param _to The address of the recipient
948     /// @param _amount The number of tokens to be sent
949     /// @param _userData Data generated by the user to be passed to the recipient
950     /// @param _operatorData Data generated by the operator to be passed to the recipient
951     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
952     ///  implementing `ERC777TokensRecipient`.
953     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
954     ///  functions SHOULD set this parameter to `false`.
955     function callRecipient(
956         address _operator,
957         address _from,
958         address _to,
959         uint256 _amount,
960         bytes _userData,
961         bytes _operatorData,
962         bool _preventLocking
963     ) internal {
964         address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");
965         if (recipientImplementation != 0) {
966             ERC777TokensRecipient(recipientImplementation).tokensReceived(
967                 _operator, _from, _to, _amount, _userData, _operatorData);
968         } else if (throwOnIncompatibleContract && _preventLocking) {
969             require(isRegularAddress(_to));
970         }
971     }
972 }