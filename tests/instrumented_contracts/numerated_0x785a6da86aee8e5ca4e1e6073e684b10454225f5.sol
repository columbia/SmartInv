1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20 interface
5  */
6 interface ERC20Token {
7     function name() public constant returns (string);
8     function symbol() public constant returns (string);
9     function decimals() public constant returns (uint8);
10     function totalSupply() public constant returns (uint256);
11     function balanceOf(address owner) public constant returns (uint256);
12     function transfer(address to, uint256 amount) public returns (bool);
13     function transferFrom(address from, address to, uint256 amount) public returns (bool);
14     function approve(address spender, uint256 amount) public returns (bool);
15     function allowance(address owner, address spender) public constant returns (uint256);
16 
17     // solhint-disable-next-line no-simple-event-func-name
18     event Transfer(address indexed from, address indexed to, uint256 amount);
19     event Approval(address indexed owner, address indexed spender, uint256 amount);
20 }
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable {
28   address public owner;
29 
30 
31   event OwnershipRenounced(address indexed previousOwner);
32   event OwnershipTransferred(
33     address indexed previousOwner,
34     address indexed newOwner
35   );
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   constructor() public {
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to relinquish control of the contract.
56    * @notice Renouncing to ownership will leave the contract without an owner.
57    * It will not be possible to call the functions with the `onlyOwner`
58    * modifier anymore.
59    */
60   function renounceOwnership() public onlyOwner {
61     emit OwnershipRenounced(owner);
62     owner = address(0);
63   }
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param _newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address _newOwner) public onlyOwner {
70     _transferOwnership(_newOwner);
71   }
72 
73   /**
74    * @dev Transfers control of the contract to a newOwner.
75    * @param _newOwner The address to transfer ownership to.
76    */
77   function _transferOwnership(address _newOwner) internal {
78     require(_newOwner != address(0));
79     emit OwnershipTransferred(owner, _newOwner);
80     owner = _newOwner;
81   }
82 }
83 
84 /**
85  * @title SafeMath
86  * @dev Math operations with safety checks that throw on error
87  */
88 library SafeMath {
89 
90   /**
91   * @dev Multiplies two numbers, throws on overflow.
92   */
93   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
94     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
95     // benefit is lost if 'b' is also tested.
96     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
97     if (_a == 0) {
98       return 0;
99     }
100 
101     c = _a * _b;
102     assert(c / _a == _b);
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers, truncating the quotient.
108   */
109   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
110     // assert(_b > 0); // Solidity automatically throws when dividing by 0
111     // uint256 c = _a / _b;
112     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
113     return _a / _b;
114   }
115 
116   /**
117   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
120     assert(_b <= _a);
121     return _a - _b;
122   }
123 
124   /**
125   * @dev Adds two numbers, throws on overflow.
126   */
127   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
128     c = _a + _b;
129     assert(c >= _a);
130     return c;
131   }
132 }
133 
134 /**
135  * @title ERC820Registry
136  */
137 contract ERC820Registry {
138     function getManager(address addr) public view returns(address);
139     function setManager(address addr, address newManager) public;
140     function getInterfaceImplementer(address addr, bytes32 iHash) public constant returns (address);
141     function setInterfaceImplementer(address addr, bytes32 iHash, address implementer) public;
142 }
143 
144 /**
145  * @title ERC820Implementer
146  */
147 contract ERC820Implementer {
148     //The contract will have this address for every chain it is deployed to.
149     ERC820Registry erc820Registry = ERC820Registry(0xbe78655dff872d22b95ae366fb3477d977328ade);
150 
151     function setInterfaceImplementation(string ifaceLabel, address impl) internal {
152         bytes32 ifaceHash = keccak256(ifaceLabel);
153         erc820Registry.setInterfaceImplementer(this, ifaceHash, impl);
154     }
155 
156     function interfaceAddr(address addr, string ifaceLabel) internal constant returns(address) {
157         bytes32 ifaceHash = keccak256(ifaceLabel);
158         return erc820Registry.getInterfaceImplementer(addr, ifaceHash);
159     }
160 
161     function delegateManagement(address newManager) internal {
162         erc820Registry.setManager(this, newManager);
163     }
164 }
165 
166 /**
167  * @title ERC777Token interface
168  */
169 interface ERC777Token {
170     function name() public view returns (string);
171     function symbol() public view returns (string);
172     function totalSupply() public view returns (uint256);
173     function balanceOf(address owner) public view returns (uint256);
174     function granularity() public view returns (uint256);
175 
176     function defaultOperators() public view returns (address[]);
177     function isOperatorFor(address operator, address tokenHolder) public view returns (bool);
178     function authorizeOperator(address operator) public;
179     function revokeOperator(address operator) public;
180 
181     function send(address to, uint256 amount, bytes holderData) public;
182     function operatorSend(address from, address to, uint256 amount, bytes holderData, bytes operatorData) public;
183 
184     function burn(uint256 amount, bytes holderData) public;
185     function operatorBurn(address from, uint256 amount, bytes holderData, bytes operatorData) public;
186 
187     event Sent(
188         address indexed operator,
189         address indexed from,
190         address indexed to,
191         uint256 amount,
192         bytes holderData,
193         bytes operatorData
194     ); // solhint-disable-next-line separate-by-one-line-in-contract
195     event Minted(address indexed operator, address indexed to, uint256 amount, bytes operatorData);
196     event Burned(address indexed operator, address indexed from, uint256 amount, bytes holderData, bytes operatorData);
197     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
198     event RevokedOperator(address indexed operator, address indexed tokenHolder);
199 }
200 
201 /**
202  * @title ERC777TokensRecipient interface
203  */
204 interface ERC777TokensRecipient {
205     function tokensReceived(
206         address operator,
207         address from,
208         address to,
209         uint amount,
210         bytes userData,
211         bytes operatorData
212     ) public;
213 }
214 
215 /**
216  * @title ERC777TokensSender interface
217  */
218 interface ERC777TokensSender {
219     function tokensToSend(
220         address operator,
221         address from,
222         address to,
223         uint amount,
224         bytes userData,
225         bytes operatorData
226     ) public;
227 }
228 
229 /**
230  * @title ERC777BaseToken
231  */
232 contract ERC777BaseToken is ERC777Token, ERC820Implementer {
233     using SafeMath for uint256;
234 
235     string internal mName;
236     string internal mSymbol;
237     uint256 internal mGranularity;
238     uint256 internal mTotalSupply;
239 
240 
241     mapping(address => uint) internal mBalances;
242     mapping(address => mapping(address => bool)) internal mAuthorized;
243 
244     address[] internal mDefaultOperators;
245     mapping(address => bool) internal mIsDefaultOperator;
246     mapping(address => mapping(address => bool)) internal mRevokedDefaultOperator;
247 
248     /* -- Constructor -- */
249     //
250     /// @notice Constructor to create a ReferenceToken
251     /// @param _name Name of the new token
252     /// @param _symbol Symbol of the new token.
253     /// @param _granularity Minimum transferable chunk.
254     constructor(string _name, string _symbol, uint256 _granularity, address[] _defaultOperators) internal {
255         mName = _name;
256         mSymbol = _symbol;
257         mTotalSupply = 0;
258         require(_granularity >= 1);
259         mGranularity = _granularity;
260 
261         mDefaultOperators = _defaultOperators;
262         for (uint i = 0; i < mDefaultOperators.length; i++) { mIsDefaultOperator[mDefaultOperators[i]] = true; }
263 
264         setInterfaceImplementation("ERC777Token", this);
265     }
266 
267     /* -- ERC777 Interface Implementation -- */
268     //
269     /// @return the name of the token
270     function name() public constant returns (string) { return mName; }
271 
272     /// @return the symbol of the token
273     function symbol() public constant returns (string) { return mSymbol; }
274 
275     /// @return the granularity of the token
276     function granularity() public constant returns (uint256) { return mGranularity; }
277 
278     /// @return the total supply of the token
279     function totalSupply() public constant returns (uint256) { return mTotalSupply; }
280 
281     /// @notice Return the account balance of some account
282     /// @param _tokenHolder Address for which the balance is returned
283     /// @return the balance of `_tokenAddress`.
284     function balanceOf(address _tokenHolder) public constant returns (uint256) { return mBalances[_tokenHolder]; }
285 
286     /// @notice Return the list of default operators
287     /// @return the list of all the default operators
288     function defaultOperators() public view returns (address[]) { return mDefaultOperators; }
289 
290     /// @notice Send `_amount` of tokens to address `_to` passing `_userData` to the recipient
291     /// @param _to The address of the recipient
292     /// @param _amount The number of tokens to be sent
293     function send(address _to, uint256 _amount, bytes _userData) public {
294         doSend(msg.sender, msg.sender, _to, _amount, _userData, "", true);
295     }
296 
297     /// @notice Authorize a third party `_operator` to manage (send) `msg.sender`'s tokens.
298     /// @param _operator The operator that wants to be Authorized
299     function authorizeOperator(address _operator) public {
300         require(_operator != msg.sender);
301         if (mIsDefaultOperator[_operator]) {
302             mRevokedDefaultOperator[_operator][msg.sender] = false;
303         } else {
304             mAuthorized[_operator][msg.sender] = true;
305         }
306         AuthorizedOperator(_operator, msg.sender);
307     }
308 
309     /// @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens.
310     /// @param _operator The operator that wants to be Revoked
311     function revokeOperator(address _operator) public {
312         require(_operator != msg.sender);
313         if (mIsDefaultOperator[_operator]) {
314             mRevokedDefaultOperator[_operator][msg.sender] = true;
315         } else {
316             mAuthorized[_operator][msg.sender] = false;
317         }
318         RevokedOperator(_operator, msg.sender);
319     }
320 
321     /// @notice Check whether the `_operator` address is allowed to manage the tokens held by `_tokenHolder` address.
322     /// @param _operator address to check if it has the right to manage the tokens
323     /// @param _tokenHolder address which holds the tokens to be managed
324     /// @return `true` if `_operator` is authorized for `_tokenHolder`
325     function isOperatorFor(address _operator, address _tokenHolder) public constant returns (bool) {
326         return (_operator == _tokenHolder
327             || mAuthorized[_operator][_tokenHolder]
328             || (mIsDefaultOperator[_operator] && !mRevokedDefaultOperator[_operator][_tokenHolder]));
329     }
330 
331     /// @notice Send `_amount` of tokens on behalf of the address `from` to the address `to`.
332     /// @param _from The address holding the tokens being sent
333     /// @param _to The address of the recipient
334     /// @param _amount The number of tokens to be sent
335     /// @param _userData Data generated by the user to be sent to the recipient
336     /// @param _operatorData Data generated by the operator to be sent to the recipient
337     function operatorSend(address _from, address _to, uint256 _amount, bytes _userData, bytes _operatorData) public {
338         require(isOperatorFor(msg.sender, _from));
339         doSend(msg.sender, _from, _to, _amount, _userData, _operatorData, true);
340     }
341 
342     function burn(uint256 _amount, bytes _holderData) public {
343         doBurn(msg.sender, msg.sender, _amount, _holderData, "");
344     }
345 
346     function operatorBurn(address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData) public {
347         require(isOperatorFor(msg.sender, _tokenHolder));
348         doBurn(msg.sender, _tokenHolder, _amount, _holderData, _operatorData);
349     }
350 
351     /* -- Helper Functions -- */
352     //
353     /// @notice Internal function that ensures `_amount` is multiple of the granularity
354     /// @param _amount The quantity that want's to be checked
355     function requireMultiple(uint256 _amount) internal view {
356         require(_amount.div(mGranularity).mul(mGranularity) == _amount);
357     }
358 
359     /// @notice Check whether an address is a regular address or not.
360     /// @param _addr Address of the contract that has to be checked
361     /// @return `true` if `_addr` is a regular address (not a contract)
362     function isRegularAddress(address _addr) internal constant returns(bool) {
363         if (_addr == 0) { return false; }
364         uint size;
365         assembly { size := extcodesize(_addr) } // solhint-disable-line no-inline-assembly
366         return size == 0;
367     }
368 
369     /// @notice Helper function actually performing the sending of tokens.
370     /// @param _operator The address performing the send
371     /// @param _from The address holding the tokens being sent
372     /// @param _to The address of the recipient
373     /// @param _amount The number of tokens to be sent
374     /// @param _userData Data generated by the user to be passed to the recipient
375     /// @param _operatorData Data generated by the operator to be passed to the recipient
376     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
377     ///  implementing `erc777_tokenHolder`.
378     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
379     ///  functions SHOULD set this parameter to `false`.
380     function doSend(
381         address _operator,
382         address _from,
383         address _to,
384         uint256 _amount,
385         bytes _userData,
386         bytes _operatorData,
387         bool _preventLocking
388     )
389         internal
390     {
391         requireMultiple(_amount);
392 
393         callSender(_operator, _from, _to, _amount, _userData, _operatorData);
394 
395         require(_to != address(0));          // forbid sending to 0x0 (=burning)
396         require(mBalances[_from] >= _amount); // ensure enough funds
397 
398         mBalances[_from] = mBalances[_from].sub(_amount);
399         mBalances[_to] = mBalances[_to].add(_amount);
400 
401         callRecipient(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
402 
403         Sent(_operator, _from, _to, _amount, _userData, _operatorData);
404     }
405 
406     /// @notice Helper function actually performing the burning of tokens.
407     /// @param _operator The address performing the burn
408     /// @param _tokenHolder The address holding the tokens being burn
409     /// @param _amount The number of tokens to be burnt
410     /// @param _holderData Data generated by the token holder
411     /// @param _operatorData Data generated by the operator
412     function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData)
413         internal
414     {
415         requireMultiple(_amount);
416         require(balanceOf(_tokenHolder) >= _amount);
417 
418         mBalances[_tokenHolder] = mBalances[_tokenHolder].sub(_amount);
419         mTotalSupply = mTotalSupply.sub(_amount);
420 
421         callSender(_operator, _tokenHolder, 0x0, _amount, _holderData, _operatorData);
422         Burned(_operator, _tokenHolder, _amount, _holderData, _operatorData);
423     }
424 
425     /// @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.
426     ///  May throw according to `_preventLocking`
427     /// @param _operator The address performing the send or mint
428     /// @param _from The address holding the tokens being sent
429     /// @param _to The address of the recipient
430     /// @param _amount The number of tokens to be sent
431     /// @param _userData Data generated by the user to be passed to the recipient
432     /// @param _operatorData Data generated by the operator to be passed to the recipient
433     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
434     ///  implementing `ERC777TokensRecipient`.
435     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
436     ///  functions SHOULD set this parameter to `false`.
437     function callRecipient(
438         address _operator,
439         address _from,
440         address _to,
441         uint256 _amount,
442         bytes _userData,
443         bytes _operatorData,
444         bool _preventLocking
445     )
446         internal
447     {
448         address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");
449         if (recipientImplementation != 0) {
450             ERC777TokensRecipient(recipientImplementation).tokensReceived(
451                 _operator, _from, _to, _amount, _userData, _operatorData);
452         } else if (_preventLocking) {
453             require(isRegularAddress(_to));
454         }
455     }
456 
457     /// @notice Helper function that checks for ERC777TokensSender on the sender and calls it.
458     ///  May throw according to `_preventLocking`
459     /// @param _from The address holding the tokens being sent
460     /// @param _to The address of the recipient
461     /// @param _amount The amount of tokens to be sent
462     /// @param _userData Data generated by the user to be passed to the recipient
463     /// @param _operatorData Data generated by the operator to be passed to the recipient
464     ///  implementing `ERC777TokensSender`.
465     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
466     ///  functions SHOULD set this parameter to `false`.
467     function callSender(
468         address _operator,
469         address _from,
470         address _to,
471         uint256 _amount,
472         bytes _userData,
473         bytes _operatorData
474     )
475         internal
476     {
477         address senderImplementation = interfaceAddr(_from, "ERC777TokensSender");
478         if (senderImplementation == 0) { return; }
479         ERC777TokensSender(senderImplementation).tokensToSend(_operator, _from, _to, _amount, _userData, _operatorData);
480     }
481 }
482 
483 /**
484  * @title ERC777ERC20BaseToken
485  */
486 contract ERC777ERC20BaseToken is ERC20Token, ERC777BaseToken {
487     bool internal mErc20compatible;
488 
489     mapping(address => mapping(address => bool)) internal mAuthorized;
490     mapping(address => mapping(address => uint256)) internal mAllowed;
491 
492     constructor (
493         string _name,
494         string _symbol,
495         uint256 _granularity,
496         address[] _defaultOperators
497     )
498         internal ERC777BaseToken(_name, _symbol, _granularity, _defaultOperators)
499     {
500         mErc20compatible = true;
501         setInterfaceImplementation("ERC20Token", this);
502     }
503 
504     /// @notice This modifier is applied to erc20 obsolete methods that are
505     ///  implemented only to maintain backwards compatibility. When the erc20
506     ///  compatibility is disabled, this methods will fail.
507     modifier erc20 () {
508         require(mErc20compatible);
509         _;
510     }
511 
512     /// @notice For Backwards compatibility
513     /// @return The decimls of the token. Forced to 18 in ERC777.
514     function decimals() public erc20 constant returns (uint8) { return uint8(18); }
515 
516     /// @notice ERC20 backwards compatible transfer.
517     /// @param _to The address of the recipient
518     /// @param _amount The number of tokens to be transferred
519     /// @return `true`, if the transfer can't be done, it should fail.
520     function transfer(address _to, uint256 _amount) public erc20 returns (bool success) {
521         doSend(msg.sender, msg.sender, _to, _amount, "", "", false);
522         return true;
523     }
524 
525     /// @notice ERC20 backwards compatible transferFrom.
526     /// @param _from The address holding the tokens being transferred
527     /// @param _to The address of the recipient
528     /// @param _amount The number of tokens to be transferred
529     /// @return `true`, if the transfer can't be done, it should fail.
530     function transferFrom(address _from, address _to, uint256 _amount) public erc20 returns (bool success) {
531         require(_amount <= mAllowed[_from][msg.sender]);
532 
533         // Cannot be after doSend because of tokensReceived re-entry
534         mAllowed[_from][msg.sender] = mAllowed[_from][msg.sender].sub(_amount);
535         doSend(msg.sender, _from, _to, _amount, "", "", false);
536         return true;
537     }
538 
539     /// @notice ERC20 backwards compatible approve.
540     ///  `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
541     /// @param _spender The address of the account able to transfer the tokens
542     /// @param _amount The number of tokens to be approved for transfer
543     /// @return `true`, if the approve can't be done, it should fail.
544     function approve(address _spender, uint256 _amount) public erc20 returns (bool success) {
545         mAllowed[msg.sender][_spender] = _amount;
546         Approval(msg.sender, _spender, _amount);
547         return true;
548     }
549 
550     /// @notice ERC20 backwards compatible allowance.
551     ///  This function makes it easy to read the `allowed[]` map
552     /// @param _owner The address of the account that owns the token
553     /// @param _spender The address of the account able to transfer the tokens
554     /// @return Amount of remaining tokens of _owner that _spender is allowed
555     ///  to spend
556     function allowance(address _owner, address _spender) public erc20 constant returns (uint256 remaining) {
557         return mAllowed[_owner][_spender];
558     }
559 
560     function doSend(
561         address _operator,
562         address _from,
563         address _to,
564         uint256 _amount,
565         bytes _userData,
566         bytes _operatorData,
567         bool _preventLocking
568     )
569         internal
570     {
571         super.doSend(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
572         if (mErc20compatible) { Transfer(_from, _to, _amount); }
573     }
574 
575     function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData)
576         internal
577     {
578         super.doBurn(_operator, _tokenHolder, _amount, _holderData, _operatorData);
579         if (mErc20compatible) { Transfer(_tokenHolder, 0x0, _amount); }
580     }
581 }
582 
583 /**
584  * @title ERC777 InstallB Contract
585  */
586 contract InstallB is ERC777ERC20BaseToken, Ownable {
587 
588     address private mBurnOperator;
589 
590     constructor (
591         string _name,
592         string _symbol,
593         uint256 _granularity,
594         address[] _defaultOperators,
595         address _burnOperator
596     ) public ERC777ERC20BaseToken(_name, _symbol, _granularity, _defaultOperators) {
597         mBurnOperator = _burnOperator;
598     }
599 
600     /// @notice Disables the ERC20 interface. This function can only be called
601     ///  by the owner.
602     function disableERC20() public onlyOwner {
603         mErc20compatible = false;
604         setInterfaceImplementation("ERC20Token", 0x0);
605     }
606 
607     /// @notice Re enables the ERC20 interface. This function can only be called
608     ///  by the owner.
609     function enableERC20() public onlyOwner {
610         mErc20compatible = true;
611         setInterfaceImplementation("ERC20Token", this);
612     }
613 
614     /* -- Mint And Burn Functions (not part of the ERC777 standard, only the Events/tokensReceived call are) -- */
615     //
616     /// @notice Generates `_amount` tokens to be assigned to `_tokenHolder`
617     ///  Sample mint function to showcase the use of the `Minted` event and the logic to notify the recipient.
618     /// @param _tokenHolder The address that will be assigned the new tokens
619     /// @param _amount The quantity of tokens generated
620     /// @param _operatorData Data that will be passed to the recipient as a first transfer
621     function mint(address _tokenHolder, uint256 _amount, bytes _operatorData) public onlyOwner {
622         requireMultiple(_amount);
623         mTotalSupply = mTotalSupply.add(_amount);
624         mBalances[_tokenHolder] = mBalances[_tokenHolder].add(_amount);
625 
626         callRecipient(msg.sender, 0x0, _tokenHolder, _amount, "", _operatorData, true);
627 
628         Minted(msg.sender, _tokenHolder, _amount, _operatorData);
629         if (mErc20compatible) { Transfer(0x0, _tokenHolder, _amount); }
630     }
631 
632     /// @notice Burns `_amount` tokens from `_tokenHolder`
633     ///  Silly example of overriding the `burn` function to only let the owner burn its tokens.
634     ///  Do not forget to override the `burn` function in your token contract if you want to prevent users from
635     ///  burning their tokens.
636     /// @param _amount The quantity of tokens to burn
637     function burn(uint256 _amount, bytes _holderData) public onlyOwner {
638         super.burn(_amount, _holderData);
639     }
640 
641     /// @notice Burns `_amount` tokens from `_tokenHolder` by `_operator`
642     ///  Silly example of overriding the `operatorBurn` function to only let a specific operator burn tokens.
643     ///  Do not forget to override the `operatorBurn` function in your token contract if you want to prevent users from
644     ///  burning their tokens.
645     /// @param _tokenHolder The address that will lose the tokens
646     /// @param _amount The quantity of tokens to burn
647     function operatorBurn(address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData) public {
648         require(msg.sender == mBurnOperator);
649         super.operatorBurn(_tokenHolder, _amount, _holderData, _operatorData);
650     }
651 }