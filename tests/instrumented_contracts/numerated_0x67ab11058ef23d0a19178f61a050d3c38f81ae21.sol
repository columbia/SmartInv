1 pragma solidity 0.4.25;
2 
3 // File: contracts/ERC777/ERC20Token.sol
4 
5 /* This Source Code Form is subject to the terms of the Mozilla external
6  * License, v. 2.0. If a copy of the MPL was not distributed with this
7  * file, You can obtain one at http://mozilla.org/MPL/2.0/.
8  *
9  * This code has not been reviewed.
10  * Do not use or deploy this code before reviewing it personally first.
11  */
12 
13 
14 interface ERC20Token {
15   function name() external view returns (string);
16   function symbol() external view returns (string);
17   function decimals() external view returns (uint8);
18   function totalSupply() external view returns (uint256);
19   function balanceOf(address owner) external view returns (uint256);
20   function transfer(address to, uint256 amount) external returns (bool);
21   function transferFrom(address from, address to, uint256 amount) external returns (bool);
22   function approve(address spender, uint256 amount) external returns (bool);
23   function allowance(address owner, address spender) external view returns (uint256);
24 
25   event Transfer(address indexed from, address indexed to, uint256 amount);
26   event Approval(address indexed owner, address indexed spender, uint256 amount);
27 }
28 
29 // File: contracts/ERC820/ERC820Client.sol
30 
31 contract ERC820Registry {
32     function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) external;
33     function getInterfaceImplementer(address _addr, bytes32 _interfaceHash) external view returns (address);
34     function setManager(address _addr, address _newManager) external;
35     function getManager(address _addr) public view returns(address);
36 }
37 
38 
39 /// Base client to interact with the registry.
40 contract ERC820Client {
41     ERC820Registry erc820Registry = ERC820Registry(0x820c4597Fc3E4193282576750Ea4fcfe34DdF0a7);
42 
43     function setInterfaceImplementation(string _interfaceLabel, address _implementation) internal {
44         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
45         erc820Registry.setInterfaceImplementer(this, interfaceHash, _implementation);
46     }
47 
48     function interfaceAddr(address addr, string _interfaceLabel) internal view returns(address) {
49         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
50         return erc820Registry.getInterfaceImplementer(addr, interfaceHash);
51     }
52 
53     function delegateManagement(address _newManager) internal {
54         erc820Registry.setManager(this, _newManager);
55     }
56 }
57 
58 // File: contracts/openzeppelin-solidity/math/SafeMath.sol
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that revert on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, reverts on overflow.
68   */
69   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
71     // benefit is lost if 'b' is also tested.
72     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
73     if (a == 0) {
74       return 0;
75     }
76 
77     uint256 c = a * b;
78     require(c / a == b);
79 
80     return c;
81   }
82 
83   /**
84   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
85   */
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     require(b > 0); // Solidity only automatically asserts when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91     return c;
92   }
93 
94   /**
95   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     require(b <= a);
99     uint256 c = a - b;
100 
101     return c;
102   }
103 
104   /**
105   * @dev Adds two numbers, reverts on overflow.
106   */
107   function add(uint256 a, uint256 b) internal pure returns (uint256) {
108     uint256 c = a + b;
109     require(c >= a);
110 
111     return c;
112   }
113 
114   /**
115   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
116   * reverts when dividing by zero.
117   */
118   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
119     require(b != 0);
120     return a % b;
121   }
122 }
123 
124 // File: contracts/openzeppelin-solidity/Address.sol
125 
126 /**
127  * Utility library of inline functions on addresses
128  */
129 library Address {
130 
131   /**
132    * Returns whether the target address is a contract
133    * @dev This function will return false if invoked during the constructor of a contract,
134    * as the code is not actually created until after the constructor finishes.
135    * @param account address of the account to check
136    * @return whether the target address is a contract
137    */
138   function isContract(address account) internal view returns (bool) {
139     uint256 size;
140     // XXX Currently there is no better way to check if there is a contract in an address
141     // than to check the size of the code at that address.
142     // See https://ethereum.stackexchange.com/a/14016/36603
143     // for more details about how this works.
144     // TODO Check this again before the Serenity release, because all addresses will be
145     // contracts then.
146     // solium-disable-next-line security/no-inline-assembly
147     assembly { size := extcodesize(account) }
148     return size > 0;
149   }
150 
151 }
152 
153 // File: contracts/ERC777/ERC777Token.sol
154 
155 /* This Source Code Form is subject to the terms of the Mozilla external
156  * License, v. 2.0. If a copy of the MPL was not distributed with this
157  * file, You can obtain one at http://mozilla.org/MPL/2.0/.
158  *
159  * This code has not been reviewed.
160  * Do not use or deploy this code before reviewing it personally first.
161  */
162 
163 
164 interface ERC777Token {
165   function name() external view returns (string);
166   function symbol() external view returns (string);
167   function totalSupply() external view returns (uint256);
168   function balanceOf(address owner) external view returns (uint256);
169   function granularity() external view returns (uint256);
170 
171   function defaultOperators() external view returns (address[]);
172   function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
173   function authorizeOperator(address operator) external;
174   function revokeOperator(address operator) external;
175 
176   function send(address to, uint256 amount, bytes holderData) external;
177   function operatorSend(address from, address to, uint256 amount, bytes holderData, bytes operatorData) external;
178 
179   function burn(uint256 amount, bytes holderData) external;
180   function operatorBurn(address from, uint256 amount, bytes holderData, bytes operatorData) external;
181 
182   event Sent(
183     address indexed operator,
184     address indexed from,
185     address indexed to,
186     uint256 amount,
187     bytes holderData,
188     bytes operatorData
189   );
190   event Minted(address indexed operator, address indexed to, uint256 amount, bytes operatorData);
191   event Burned(address indexed operator, address indexed from, uint256 amount, bytes holderData, bytes operatorData);
192   event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
193   event RevokedOperator(address indexed operator, address indexed tokenHolder);
194 }
195 
196 // File: contracts/ERC777/ERC777TokensSender.sol
197 
198 /* This Source Code Form is subject to the terms of the Mozilla Public
199  * License, v. 2.0. If a copy of the MPL was not distributed with this
200  * file, You can obtain one at http://mozilla.org/MPL/2.0/.
201  *
202  * This code has not been reviewed.
203  * Do not use or deploy this code before reviewing it personally first.
204  */
205 
206 
207 interface ERC777TokensSender {
208   function tokensToSend(
209     address operator,
210     address from,
211     address to,
212     uint amount,
213     bytes userData,
214     bytes operatorData
215   ) external;
216 }
217 
218 // File: contracts/ERC777/ERC777TokensRecipient.sol
219 
220 /* This Source Code Form is subject to the terms of the Mozilla Public
221  * License, v. 2.0. If a copy of the MPL was not distributed with this
222  * file, You can obtain one at http://mozilla.org/MPL/2.0/.
223  *
224  * This code has not been reviewed.
225  * Do not use or deploy this code before reviewing it personally first.
226  */
227 
228 
229 interface ERC777TokensRecipient {
230   function tokensReceived(
231     address operator,
232     address from,
233     address to,
234     uint amount,
235     bytes userData,
236     bytes operatorData
237   ) external;
238 }
239 
240 // File: contracts/ERC777/ERC777BaseToken.sol
241 
242 /* This Source Code Form is subject to the terms of the Mozilla Public
243 * License, v. 2.0. If a copy of the MPL was not distributed with this
244 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
245 
246 
247 
248 
249 
250 
251 
252 
253 contract ERC777BaseToken is ERC777Token, ERC820Client {
254   using SafeMath for uint256;
255   using Address for address;
256 
257   string internal mName;
258   string internal mSymbol;
259   uint256 internal mGranularity;
260   uint256 internal mTotalSupply;
261 
262 
263   mapping(address => uint) internal mBalances;
264   mapping(address => mapping(address => bool)) internal mAuthorized;
265 
266   address[] internal mDefaultOperators;
267   mapping(address => bool) internal mIsDefaultOperator;
268   mapping(address => mapping(address => bool)) internal mRevokedDefaultOperator;
269 
270   /* -- Constructor -- */
271   //
272   /// @notice Constructor to create a SelfToken
273   /// @param _name Name of the new token
274   /// @param _symbol Symbol of the new token.
275   /// @param _granularity Minimum transferable chunk.
276   constructor(
277     string _name,
278     string _symbol,
279     uint256 _granularity,
280     address[] _defaultOperators
281   )
282     internal
283   {
284     mName = _name;
285     mSymbol = _symbol;
286     mTotalSupply = 0;
287     require(_granularity >= 1);
288     mGranularity = _granularity;
289 
290     mDefaultOperators = _defaultOperators;
291     for (uint i = 0; i < mDefaultOperators.length; i++) {
292       mIsDefaultOperator[mDefaultOperators[i]] = true;
293     }
294 
295     setInterfaceImplementation("ERC777Token", this);
296   }
297 
298   /* -- ERC777 Interface Implementation -- */
299 
300   /// @notice Send `_amount` of tokens to address `_to` passing `_userData` to the recipient
301   /// @param _to The address of the recipient
302   /// @param _amount The number of tokens to be sent
303   function send(address _to, uint256 _amount, bytes _userData) external {
304     doSend(msg.sender, msg.sender, _to, _amount, _userData, "", true);
305   }
306 
307   /// @notice Send `_amount` of tokens on behalf of the address `from` to the address `to`.
308   /// @param _from The address holding the tokens being sent
309   /// @param _to The address of the recipient
310   /// @param _amount The number of tokens to be sent
311   /// @param _userData Data generated by the user to be sent to the recipient
312   /// @param _operatorData Data generated by the operator to be sent to the recipient
313   function operatorSend(address _from, address _to, uint256 _amount, bytes _userData, bytes _operatorData) external {
314     require(isOperatorFor(msg.sender, _from));
315     doSend(msg.sender, _from, _to, _amount, _userData, _operatorData, true);
316   }
317 
318   function burn(uint256 _amount, bytes _holderData) external {
319     doBurn(msg.sender, msg.sender, _amount, _holderData, "");
320   }
321 
322   function operatorBurn(address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData) external {
323     require(isOperatorFor(msg.sender, _tokenHolder));
324     doBurn(msg.sender, _tokenHolder, _amount, _holderData, _operatorData);
325   }
326 
327   /// @return the name of the token
328   function name() external view returns (string) { return mName; }
329 
330   /// @return the symbol of the token
331   function symbol() external view returns (string) { return mSymbol; }
332 
333   /// @return the granularity of the token
334   function granularity() external view returns (uint256) { return mGranularity; }
335 
336   /// @return the total supply of the token
337   function totalSupply() public view returns (uint256) { return mTotalSupply; }
338 
339   /// @notice Return the account balance of some account
340   /// @param _tokenHolder Address for which the balance is returned
341   /// @return the balance of `_tokenAddress`.
342   function balanceOf(address _tokenHolder) public view returns (uint256) { return mBalances[_tokenHolder]; }
343 
344   /// @notice Return the list of default operators
345   /// @return the list of all the default operators
346   function defaultOperators() external view returns (address[]) { return mDefaultOperators; }
347 
348   /// @notice Authorize a third party `_operator` to manage (send) `msg.sender`'s tokens. An operator cannot be reauthorized
349   /// @param _operator The operator that wants to be Authorized
350   function authorizeOperator(address _operator) external {
351     require(_operator != msg.sender);
352     require(!mAuthorized[_operator][msg.sender]);
353 
354     if (mIsDefaultOperator[_operator]) {
355       mRevokedDefaultOperator[_operator][msg.sender] = false;
356     } else {
357       mAuthorized[_operator][msg.sender] = true;
358     }
359     emit AuthorizedOperator(_operator, msg.sender);
360   }
361 
362   /// @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens.
363   /// @param _operator The operator that wants to be Revoked
364   function revokeOperator(address _operator) external {
365     require(_operator != msg.sender);
366     require(mAuthorized[_operator][msg.sender]);
367 
368     if (mIsDefaultOperator[_operator]) {
369       mRevokedDefaultOperator[_operator][msg.sender] = true;
370     } else {
371       mAuthorized[_operator][msg.sender] = false;
372     }
373     emit RevokedOperator(_operator, msg.sender);
374   }
375 
376   /// @notice Check whether the `_operator` address is allowed to manage the tokens held by `_tokenHolder` address.
377   /// @param _operator address to check if it has the right to manage the tokens
378   /// @param _tokenHolder address which holds the tokens to be managed
379   /// @return `true` if `_operator` is authorized for `_tokenHolder`
380   function isOperatorFor(address _operator, address _tokenHolder) public view returns (bool) {
381     return (
382       _operator == _tokenHolder
383       || mAuthorized[_operator][_tokenHolder]
384       || (mIsDefaultOperator[_operator] && !mRevokedDefaultOperator[_operator][_tokenHolder])
385     );
386   }
387 
388   /* -- Helper Functions -- */
389   //
390   /// @notice Internal function that ensures `_amount` is multiple of the granularity
391   /// @param _amount The quantity that want's to be checked
392   function requireMultiple(uint256 _amount) internal view {
393     require(_amount.div(mGranularity).mul(mGranularity) == _amount);
394   }
395 
396   /// @notice Helper function actually performing the sending of tokens.
397   /// @param _operator The address performing the send
398   /// @param _from The address holding the tokens being sent
399   /// @param _to The address of the recipient
400   /// @param _amount The number of tokens to be sent
401   /// @param _userData Data generated by the user to be passed to the recipient
402   /// @param _operatorData Data generated by the operator to be passed to the recipient
403   /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
404   ///  implementing `ERC777TokensRecipient`.
405   ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
406   ///  functions SHOULD set this parameter to `false`.
407   function doSend(
408     address _operator,
409     address _from,
410     address _to,
411     uint256 _amount,
412     bytes _userData,
413     bytes _operatorData,
414     bool _preventLocking
415   )
416     internal
417   {
418     requireMultiple(_amount);
419 
420     callSender(_operator, _from, _to, _amount, _userData, _operatorData);
421 
422     require(_to != address(0));          // forbid sending to 0x0 (=burning)
423     require(mBalances[_from] >= _amount); // ensure enough funds
424 
425     mBalances[_from] = mBalances[_from].sub(_amount);
426     mBalances[_to] = mBalances[_to].add(_amount);
427 
428     callRecipient(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
429 
430     emit Sent(_operator, _from, _to, _amount, _userData, _operatorData);
431   }
432 
433   /// @notice Helper function actually performing the burning of tokens.
434   /// @param _operator The address performing the burn
435   /// @param _tokenHolder The address holding the tokens being burn
436   /// @param _amount The number of tokens to be burnt
437   /// @param _holderData Data generated by the token holder
438   /// @param _operatorData Data generated by the operator
439   function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData)
440     internal
441   {
442     requireMultiple(_amount);
443     require(balanceOf(_tokenHolder) >= _amount);
444 
445     mBalances[_tokenHolder] = mBalances[_tokenHolder].sub(_amount);
446     mTotalSupply = mTotalSupply.sub(_amount);
447 
448     callSender(_operator, _tokenHolder, 0x0, _amount, _holderData, _operatorData);
449     emit Burned(_operator, _tokenHolder, _amount, _holderData, _operatorData);
450   }
451 
452   /// @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.
453   ///  May throw according to `_preventLocking`
454   /// @param _operator The address performing the send or mint
455   /// @param _from The address holding the tokens being sent
456   /// @param _to The address of the recipient
457   /// @param _amount The number of tokens to be sent
458   /// @param _userData Data generated by the user to be passed to the recipient
459   /// @param _operatorData Data generated by the operator to be passed to the recipient
460   /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
461   ///  implementing `ERC777TokensRecipient`.
462   ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
463   ///  functions SHOULD set this parameter to `false`.
464   function callRecipient(
465     address _operator,
466     address _from,
467     address _to,
468     uint256 _amount,
469     bytes _userData,
470     bytes _operatorData,
471     bool _preventLocking
472   )
473     internal
474   {
475     address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");
476     if (recipientImplementation != 0) {
477       ERC777TokensRecipient(recipientImplementation).tokensReceived(
478         _operator, _from, _to, _amount, _userData, _operatorData);
479     } else if (_preventLocking) {
480       require(!_to.isContract());
481     }
482   }
483 
484   /// @notice Helper function that checks for ERC777TokensSender on the sender and calls it.
485   ///  May throw according to `_preventLocking`
486   /// @param _from The address holding the tokens being sent
487   /// @param _to The address of the recipient
488   /// @param _amount The amount of tokens to be sent
489   /// @param _userData Data generated by the user to be passed to the recipient
490   /// @param _operatorData Data generated by the operator to be passed to the recipient
491   ///  implementing `ERC777TokensSender`.
492   ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
493   ///  functions SHOULD set this parameter to `false`.
494   function callSender(
495     address _operator,
496     address _from,
497     address _to,
498     uint256 _amount,
499     bytes _userData,
500     bytes _operatorData
501   )
502     internal
503   {
504     address senderImplementation = interfaceAddr(_from, "ERC777TokensSender");
505     if (senderImplementation == 0) {
506       return;
507     }
508     ERC777TokensSender(senderImplementation).tokensToSend(_operator, _from, _to, _amount, _userData, _operatorData);
509   }
510 }
511 
512 // File: contracts/ERC777/ERC777ERC20BaseToken.sol
513 
514 /* This Source Code Form is subject to the terms of the Mozilla Public
515  * License, v. 2.0. If a copy of the MPL was not distributed with this
516  * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
517 
518 
519 
520 
521 contract ERC777ERC20BaseToken is ERC20Token, ERC777BaseToken {
522   bool internal mErc20compatible;
523 
524   mapping(address => mapping(address => uint256)) internal mAllowed;
525 
526   constructor(
527     string _name,
528     string _symbol,
529     uint256 _granularity,
530     address[] _defaultOperators
531   )
532     internal ERC777BaseToken(_name, _symbol, _granularity, _defaultOperators)
533   {
534     mErc20compatible = true;
535     setInterfaceImplementation("ERC20Token", this);
536   }
537 
538   /// @notice This modifier is applied to erc20 obsolete methods that are
539   ///  implemented only to maintain backwards compatibility. When the erc20
540   ///  compatibility is disabled, this methods will fail.
541   modifier erc20 () {
542     require(mErc20compatible);
543     _;
544   }
545 
546   /// @notice For Backwards compatibility
547   /// @return The decimls of the token. Forced to 18 in ERC777.
548   function decimals() external erc20 view returns (uint8) { return uint8(18); }
549 
550   /// @notice ERC20 backwards compatible transfer.
551   /// @param _to The address of the recipient
552   /// @param _amount The number of tokens to be transferred
553   /// @return `true`, if the transfer can't be done, it should fail.
554   function transfer(address _to, uint256 _amount) public erc20 returns (bool success) {
555     doSend(msg.sender, msg.sender, _to, _amount, "", "", false);
556     return true;
557   }
558 
559   /// @notice ERC20 backwards compatible transferFrom.
560   /// @param _from The address holding the tokens being transferred
561   /// @param _to The address of the recipient
562   /// @param _amount The number of tokens to be transferred
563   /// @return `true`, if the transfer can't be done, it should fail.
564   function transferFrom(address _from, address _to, uint256 _amount) public erc20 returns (bool success) {
565     require(_amount <= mAllowed[_from][msg.sender]);
566 
567     // Cannot be after doSend because of tokensReceived re-entry
568     mAllowed[_from][msg.sender] = mAllowed[_from][msg.sender].sub(_amount);
569     doSend(msg.sender, _from, _to, _amount, "", "", false);
570     return true;
571   }
572 
573   /// @notice ERC20 backwards compatible approve.
574   ///  `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
575   /// @param _spender The address of the account able to transfer the tokens
576   /// @param _amount The number of tokens to be approved for transfer
577   /// @return `true`, if the approve can't be done, it should fail.
578   function approve(address _spender, uint256 _amount) public erc20 returns (bool success) {
579     mAllowed[msg.sender][_spender] = _amount;
580     emit Approval(msg.sender, _spender, _amount);
581     return true;
582   }
583 
584   /// @notice ERC20 backwards compatible allowance.
585   ///  This function makes it easy to read the `allowed[]` map
586   /// @param _owner The address of the account that owns the token
587   /// @param _spender The address of the account able to transfer the tokens
588   /// @return Amount of remaining tokens of _owner that _spender is allowed
589   ///  to spend
590   function allowance(address _owner, address _spender) public erc20 view returns (uint256 remaining) {
591     return mAllowed[_owner][_spender];
592   }
593 
594   function doSend(
595     address _operator,
596     address _from,
597     address _to,
598     uint256 _amount,
599     bytes _userData,
600     bytes _operatorData,
601     bool _preventLocking
602   )
603     internal
604   {
605     super.doSend(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
606     if (mErc20compatible) {
607       emit Transfer(_from, _to, _amount);
608     }
609   }
610 
611   function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData)
612     internal
613   {
614     super.doBurn(_operator, _tokenHolder, _amount, _holderData, _operatorData);
615     if (mErc20compatible) {
616       emit Transfer(_tokenHolder, 0x0, _amount);
617     }
618   }
619 }
620 
621 // File: contracts/openzeppelin-solidity/ownership/Ownable.sol
622 
623 /**
624  * @title Ownable
625  * @dev The Ownable contract has an owner address, and provides basic authorization control
626  * functions, this simplifies the implementation of "user permissions".
627  */
628 contract Ownable {
629   address public owner;
630 
631 
632   event OwnershipRenounced(address indexed previousOwner);
633   event OwnershipTransferred(
634     address indexed previousOwner,
635     address indexed newOwner
636   );
637 
638 
639   /**
640    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
641    * account.
642    */
643   constructor() public {
644     owner = msg.sender;
645   }
646 
647   /**
648    * @dev Throws if called by any account other than the owner.
649    */
650   modifier onlyOwner() {
651     require(msg.sender == owner);
652     _;
653   }
654 
655   /**
656    * @dev Allows the current owner to relinquish control of the contract.
657    * @notice Renouncing to ownership will leave the contract without an owner.
658    * It will not be possible to call the functions with the `onlyOwner`
659    * modifier anymore.
660    */
661   function renounceOwnership() public onlyOwner {
662     emit OwnershipRenounced(owner);
663     owner = address(0);
664   }
665 
666   /**
667    * @dev Allows the current owner to transfer control of the contract to a newOwner.
668    * @param _newOwner The address to transfer ownership to.
669    */
670   function transferOwnership(address _newOwner) public onlyOwner {
671     _transferOwnership(_newOwner);
672   }
673 
674   /**
675    * @dev Transfers control of the contract to a newOwner.
676    * @param _newOwner The address to transfer ownership to.
677    */
678   function _transferOwnership(address _newOwner) internal {
679     require(_newOwner != address(0));
680     emit OwnershipTransferred(owner, _newOwner);
681     owner = _newOwner;
682   }
683 }
684 
685 // File: contracts/openzeppelin-solidity/lifecycle/Pausable.sol
686 
687 /**
688  * @title Pausable
689  * @dev Base contract which allows children to implement an emergency stop mechanism.
690  */
691 contract Pausable is Ownable {
692   event Pause();
693   event Unpause();
694 
695   bool public paused = false;
696 
697 
698   /**
699    * @dev Modifier to make a function callable only when the contract is not paused.
700    */
701   modifier whenNotPaused() {
702     require(!paused);
703     _;
704   }
705 
706   /**
707    * @dev Modifier to make a function callable only when the contract is paused.
708    */
709   modifier whenPaused() {
710     require(paused);
711     _;
712   }
713 
714   /**
715    * @dev called by the owner to pause, triggers stopped state
716    */
717   function pause() public onlyOwner whenNotPaused {
718     paused = true;
719     emit Pause();
720   }
721 
722   /**
723    * @dev called by the owner to unpause, returns to normal state
724    */
725   function unpause() public onlyOwner whenPaused {
726     paused = false;
727     emit Unpause();
728   }
729 }
730 
731 // File: contracts/utils/Freezable.sol
732 
733 /// @title An inheritable extension for a contract to freeze accessibility of any specific addresses
734 /// @author Jeff Hu
735 /// @notice Have a contract inherited from this to use the modifiers: whenAccountFrozen(), whenAccountNotFrozen()
736 /// @dev Concern: Ownable may cause multiple owners; You need to pass in msg.sender when using modifiers
737 contract Freezable is Ownable {
738 
739   event AccountFrozen(address indexed _account);
740   event AccountUnfrozen(address indexed _account);
741 
742   // frozen status of all accounts
743   mapping(address=>bool) public frozenAccounts;
744 
745 
746    /**
747    * @dev Modifier to make a function callable only when the address is frozen.
748    */
749   modifier whenAccountFrozen(address _account) {
750     require(frozenAccounts[_account] == true);
751     _;
752   }
753 
754   /**
755    * @dev Modifier to make a function callable only when the address is not frozen.
756    */
757   modifier whenAccountNotFrozen(address _account) {
758     require(frozenAccounts[_account] == false);
759     _;
760   }
761 
762 
763   /**
764    * @dev Function to freeze an account from transactions
765    */
766   function freeze(address _account)
767     external
768     onlyOwner
769     whenAccountNotFrozen(_account)
770     returns (bool)
771   {
772     frozenAccounts[_account] = true;
773     emit AccountFrozen(_account);
774     return true;
775   }
776 
777   /**
778    * @dev Function to unfreeze an account form frozen state
779    */
780   function unfreeze(address _account)
781     external
782     onlyOwner
783     whenAccountFrozen(_account)
784     returns (bool)
785   {
786     frozenAccounts[_account] = false;
787     emit AccountUnfrozen(_account);
788     return true;
789   }
790 
791 
792   /**
793    * @dev A user can choose to freeze her account (not unfreezable)
794    */
795   function freezeMyAccount()
796     external
797     whenAccountNotFrozen(msg.sender)
798     returns (bool)
799   {
800     // require(msg.sender != owner);       // Only the owner cannot freeze herself
801 
802     frozenAccounts[msg.sender] = true;
803     emit AccountFrozen(msg.sender);
804     return true;
805   }
806 }
807 
808 // File: contracts/PausableFreezableERC777ERC20Token.sol
809 
810 /// @dev The owner can pause/unpause the token.
811 /// When paused, all functions that may change the token balances are prohibited.
812 /// Function approve is prohibited too.
813 contract PausableFreezableERC777ERC20Token is ERC777ERC20BaseToken, Pausable, Freezable {
814 
815   // ERC777 methods
816 
817   /// @dev We can not call super.send() because send() is an external function.
818   /// We can only override it.
819   function send(address _to, uint256 _amount, bytes _userData)
820     external
821     whenNotPaused
822     whenAccountNotFrozen(msg.sender)
823     whenAccountNotFrozen(_to)
824   {
825     doSend(msg.sender, msg.sender, _to, _amount, _userData, "", true);
826   }
827 
828   function operatorSend(address _from, address _to, uint256 _amount, bytes _userData, bytes _operatorData)
829     external
830     whenNotPaused
831     whenAccountNotFrozen(msg.sender)
832     whenAccountNotFrozen(_from)
833     whenAccountNotFrozen(_to)
834   {
835     require(isOperatorFor(msg.sender, _from));
836     doSend(msg.sender, _from, _to, _amount, _userData, _operatorData, true);
837   }
838 
839   function burn(uint256 _amount, bytes _holderData)
840     external
841     whenNotPaused
842     whenAccountNotFrozen(msg.sender)
843   {
844     doBurn(msg.sender, msg.sender, _amount, _holderData, "");
845   }
846 
847   function operatorBurn(address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData)
848     external
849     whenNotPaused
850     whenAccountNotFrozen(msg.sender)
851     whenAccountNotFrozen(_tokenHolder)
852   {
853     require(isOperatorFor(msg.sender, _tokenHolder));
854     doBurn(msg.sender, _tokenHolder, _amount, _holderData, _operatorData);
855   }
856 
857   // ERC20 methods
858 
859   function transfer(address _to, uint256 _amount)
860     public
861     erc20
862     whenNotPaused
863     whenAccountNotFrozen(msg.sender)
864     whenAccountNotFrozen(_to)
865     returns (bool success)
866   {
867     return super.transfer(_to, _amount);
868   }
869 
870   function transferFrom(address _from, address _to, uint256 _amount)
871     public
872     erc20
873     whenNotPaused
874     whenAccountNotFrozen(msg.sender)
875     whenAccountNotFrozen(_from)
876     whenAccountNotFrozen(_to)
877     returns (bool success)
878   {
879     return super.transferFrom(_from, _to, _amount);
880   }
881 
882   function approve(address _spender, uint256 _amount)
883     public
884     erc20
885     whenNotPaused
886     whenAccountNotFrozen(msg.sender)
887     whenAccountNotFrozen(_spender)
888     returns (bool success)
889   {
890     return super.approve(_spender, _amount);
891   }
892 
893   /// @dev allow Owner to transfer funds from a Frozen account
894   /// @notice the "_from" account must be frozen
895   /// @notice only the owner can trigger this function
896   /// @notice super.doSend to skip "_from" frozen checking
897   function transferFromFrozenAccount(
898     address _from,
899     address _to,
900     uint256 _amount
901   )
902     external
903     onlyOwner
904     whenNotPaused
905     whenAccountFrozen(_from)
906     whenAccountNotFrozen(_to)
907     whenAccountNotFrozen(msg.sender)
908   {
909     super.doSend(msg.sender, _from, _to, _amount, "", "", true);
910   }
911 
912   function doSend(
913     address _operator,
914     address _from,
915     address _to,
916     uint256 _amount,
917     bytes _userData,
918     bytes _operatorData,
919     bool _preventLocking
920   )
921     internal
922     whenNotPaused
923     whenAccountNotFrozen(msg.sender)
924     whenAccountNotFrozen(_operator)
925     whenAccountNotFrozen(_from)
926     whenAccountNotFrozen(_to)
927   {
928     super.doSend(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
929   }
930 
931   function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData)
932     internal
933     whenNotPaused
934     whenAccountNotFrozen(msg.sender)
935     whenAccountNotFrozen(_operator)
936     whenAccountNotFrozen(_tokenHolder)
937   {
938     super.doBurn(_operator, _tokenHolder, _amount, _holderData, _operatorData);
939   }
940 }
941 
942 // File: contracts/ERC777ERC20TokenWithOfficialOperators.sol
943 
944 /// @title ERC777 ERC20 Token with Official Operators
945 /// @author Roger-Wu
946 /// @notice Official operators are officially recommended operator contracts.
947 /// By adding new official operators, we can keep adding new features to
948 /// an already deployed token contract, which can be viewed as a way to
949 /// upgrade the token contract.
950 /// Rules of official operators:
951 /// 1. An official operator must be a contract.
952 /// 2. An official operator can only be added or removed by the contract owner.
953 /// 3. A token holder can either accept all official operators or not.
954 ///    By default, a token holder accepts all official operators, including
955 ///    the official operators added in the future.
956 /// 4. If a token holder accepts all official operators, it works as if all
957 ///    the addresses of official operators has been authorized to be his operator.
958 ///    In this case, an official operator will always be the token holder's
959 ///    operator even if he tries to revoke it by sending `revokeOperator` transactions.
960 /// 5. If a token holder chooses not to accept all official operators, it works as if
961 ///    there is no official operator at all for him. The token holder can still authorize
962 ///    any addresses, including which of official operators, to be his operators.
963 contract ERC777ERC20TokenWithOfficialOperators is ERC777ERC20BaseToken, Ownable {
964   using Address for address;
965 
966   mapping(address => bool) internal mIsOfficialOperator;
967   mapping(address => bool) internal mIsUserNotAcceptingAllOfficialOperators;
968 
969   event OfficialOperatorAdded(address operator);
970   event OfficialOperatorRemoved(address operator);
971   event OfficialOperatorsAcceptedByUser(address indexed user);
972   event OfficialOperatorsRejectedByUser(address indexed user);
973 
974   /// @notice Add an address into the list of official operators.
975   /// @param _operator The address of a new official operator.
976   /// An official operator must be a contract.
977   function addOfficialOperator(address _operator) external onlyOwner {
978     require(_operator.isContract(), "An official operator must be a contract.");
979     require(!mIsOfficialOperator[_operator], "_operator is already an official operator.");
980 
981     mIsOfficialOperator[_operator] = true;
982     emit OfficialOperatorAdded(_operator);
983   }
984 
985   /// @notice Delete an address from the list of official operators.
986   /// @param _operator The address of an official operator.
987   function removeOfficialOperator(address _operator) external onlyOwner {
988     require(mIsOfficialOperator[_operator], "_operator is not an official operator.");
989 
990     mIsOfficialOperator[_operator] = false;
991     emit OfficialOperatorRemoved(_operator);
992   }
993 
994   /// @notice Unauthorize all official operators to manage `msg.sender`'s tokens.
995   function rejectAllOfficialOperators() external {
996     require(!mIsUserNotAcceptingAllOfficialOperators[msg.sender], "Official operators are already rejected by msg.sender.");
997 
998     mIsUserNotAcceptingAllOfficialOperators[msg.sender] = true;
999     emit OfficialOperatorsRejectedByUser(msg.sender);
1000   }
1001 
1002   /// @notice Authorize all official operators to manage `msg.sender`'s tokens.
1003   function acceptAllOfficialOperators() external {
1004     require(mIsUserNotAcceptingAllOfficialOperators[msg.sender], "Official operators are already accepted by msg.sender.");
1005 
1006     mIsUserNotAcceptingAllOfficialOperators[msg.sender] = false;
1007     emit OfficialOperatorsAcceptedByUser(msg.sender);
1008   }
1009 
1010   /// @return true if the address is an official operator, false if not.
1011   function isOfficialOperator(address _operator) external view returns(bool) {
1012     return mIsOfficialOperator[_operator];
1013   }
1014 
1015   /// @return true if a user is accepting all official operators, false if not.
1016   function isUserAcceptingAllOfficialOperators(address _user) external view returns(bool) {
1017     return !mIsUserNotAcceptingAllOfficialOperators[_user];
1018   }
1019 
1020   /// @notice Check whether the `_operator` address is allowed to manage the tokens held by `_tokenHolder` address.
1021   /// @param _operator address to check if it has the right to manage the tokens
1022   /// @param _tokenHolder address which holds the tokens to be managed
1023   /// @return `true` if `_operator` is authorized for `_tokenHolder`
1024   function isOperatorFor(address _operator, address _tokenHolder) public view returns (bool) {
1025     return (
1026       _operator == _tokenHolder
1027       || (!mIsUserNotAcceptingAllOfficialOperators[_tokenHolder] && mIsOfficialOperator[_operator])
1028       || mAuthorized[_operator][_tokenHolder]
1029       || (mIsDefaultOperator[_operator] && !mRevokedDefaultOperator[_operator][_tokenHolder])
1030     );
1031   }
1032 }
1033 
1034 // File: contracts/ApprovalRecipient.sol
1035 
1036 interface ApprovalRecipient {
1037   function receiveApproval(
1038     address _from,
1039     uint256 _value,
1040     address _token,
1041     bytes _extraData
1042   ) external;
1043 }
1044 
1045 // File: contracts/ERC777ERC20TokenWithApproveAndCall.sol
1046 
1047 contract ERC777ERC20TokenWithApproveAndCall is PausableFreezableERC777ERC20Token {
1048   /// Set allowance for other address and notify
1049   /// Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
1050   /// From https://www.ethereum.org/token
1051   /// @param _spender The address authorized to spend
1052   /// @param _value the max amount they can spend
1053   /// @param _extraData some extra information to send to the approved contract
1054   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
1055     external
1056     whenNotPaused
1057     whenAccountNotFrozen(msg.sender)
1058     whenAccountNotFrozen(_spender)
1059     returns (bool success)
1060   {
1061     ApprovalRecipient spender = ApprovalRecipient(_spender);
1062     if (approve(_spender, _value)) {
1063       spender.receiveApproval(msg.sender, _value, this, _extraData);
1064       return true;
1065     }
1066   }
1067 }
1068 
1069 // File: contracts/ERC777ERC20TokenWithBatchTransfer.sol
1070 
1071 contract ERC777ERC20TokenWithBatchTransfer is PausableFreezableERC777ERC20Token {
1072   /// @notice ERC20 backwards compatible batch transfer.
1073   /// The transaction will revert if any of the recipients is frozen.
1074   /// We check whether a recipient is frozen in `doSend`.
1075   /// @param _recipients The addresses of the recipients
1076   /// @param _amounts The numbers of tokens to be transferred
1077   /// @return `true`, if the transfer can't be done, it should fail.
1078   function batchTransfer(address[] _recipients, uint256[] _amounts)
1079     external
1080     erc20
1081     whenNotPaused
1082     whenAccountNotFrozen(msg.sender)
1083     returns (bool success)
1084   {
1085     require(
1086       _recipients.length == _amounts.length,
1087       "The lengths of _recipients and _amounts should be the same."
1088     );
1089 
1090     for (uint256 i = 0; i < _recipients.length; i++) {
1091       doSend(msg.sender, msg.sender, _recipients[i], _amounts[i], "", "", false);
1092     }
1093     return true;
1094   }
1095 
1096   /// @notice Send tokens to multiple recipients.
1097   /// The transaction will revert if any of the recipients is frozen.
1098   /// We check whether a recipient is frozen in `doSend`.
1099   /// @param _recipients The addresses of the recipients
1100   /// @param _amounts The numbers of tokens to be transferred
1101   /// @param _userData Data generated by the user to be sent to the recipient
1102   function batchSend(
1103     address[] _recipients,
1104     uint256[] _amounts,
1105     bytes _userData
1106   )
1107     external
1108     whenNotPaused
1109     whenAccountNotFrozen(msg.sender)
1110   {
1111     require(
1112       _recipients.length == _amounts.length,
1113       "The lengths of _recipients and _amounts should be the same."
1114     );
1115 
1116     for (uint256 i = 0; i < _recipients.length; i++) {
1117       doSend(msg.sender, msg.sender, _recipients[i], _amounts[i], _userData, "", true);
1118     }
1119   }
1120 
1121   /// @notice Send tokens to multiple recipients on behalf of the address `from`
1122   /// The transaction will revert if any of the recipients is frozen.
1123   /// We check whether a recipient is frozen in `doSend`.
1124   /// @param _from The address holding the tokens being sent
1125   /// @param _recipients The addresses of the recipients
1126   /// @param _amounts The numbers of tokens to be transferred
1127   /// @param _userData Data generated by the user to be sent to the recipient
1128   /// @param _operatorData Data generated by the operator to be sent to the recipient
1129   function operatorBatchSend(
1130     address _from,
1131     address[] _recipients,
1132     uint256[] _amounts,
1133     bytes _userData,
1134     bytes _operatorData
1135   )
1136     external
1137     whenNotPaused
1138     whenAccountNotFrozen(msg.sender)
1139     whenAccountNotFrozen(_from)
1140   {
1141     require(
1142       _recipients.length == _amounts.length,
1143       "The lengths of _recipients and _amounts should be the same."
1144     );
1145     require(isOperatorFor(msg.sender, _from));
1146 
1147     for (uint256 i = 0; i < _recipients.length; i++) {
1148       doSend(msg.sender, _from, _recipients[i], _amounts[i], _userData, _operatorData, true);
1149     }
1150   }
1151 }
1152 
1153 // File: contracts/CappedMintableERC777ERC20Token.sol
1154 
1155 /// @title Capped Mintable ERC777 ERC20 Token
1156 /// @author Roger-Wu
1157 /// @dev Mintable token with a minting cap.
1158 ///  The owner can mint any amount of tokens until the cap is reached.
1159 contract CappedMintableERC777ERC20Token is ERC777ERC20BaseToken, Ownable {
1160   uint256 internal mTotalSupplyCap;
1161 
1162   constructor(uint256 _totalSupplyCap) public {
1163     mTotalSupplyCap = _totalSupplyCap;
1164   }
1165 
1166   /// @return the cap of total supply
1167   function totalSupplyCap() external view returns(uint _totalSupplyCap) {
1168     return mTotalSupplyCap;
1169   }
1170 
1171   /// @dev Generates `_amount` tokens to be assigned to `_tokenHolder`
1172   ///  Sample mint function to showcase the use of the `Minted` event and the logic to notify the recipient.
1173   ///  Reference: https://github.com/jacquesd/ERC777/blob/devel/contracts/examples/SelfToken.sol
1174   /// @param _tokenHolder The address that will be assigned the new tokens
1175   /// @param _amount The quantity of tokens generated
1176   /// @param _operatorData Data that will be passed to the recipient as a first transfer
1177   function mint(address _tokenHolder, uint256 _amount, bytes _operatorData) external onlyOwner {
1178     requireMultiple(_amount);
1179     require(mTotalSupply.add(_amount) <= mTotalSupplyCap);
1180 
1181     mTotalSupply = mTotalSupply.add(_amount);
1182     mBalances[_tokenHolder] = mBalances[_tokenHolder].add(_amount);
1183 
1184     callRecipient(msg.sender, address(0), _tokenHolder, _amount, "", _operatorData, true);
1185 
1186     emit Minted(msg.sender, _tokenHolder, _amount, _operatorData);
1187     if (mErc20compatible) {
1188       emit Transfer(0x0, _tokenHolder, _amount);
1189     }
1190   }
1191 }
1192 
1193 // File: contracts/ERC777ERC20TokenWithOperatorApprove.sol
1194 
1195 /// @title ERC777 ERC20 Token with Operator Approve
1196 /// @author Roger-Wu
1197 /// @notice Allow an operator to approve tokens for a token holder.
1198 contract ERC777ERC20TokenWithOperatorApprove is ERC777ERC20BaseToken {
1199   function operatorApprove(
1200     address _tokenHolder,
1201     address _spender,
1202     uint256 _amount
1203   )
1204     external
1205     erc20
1206     returns (bool success)
1207   {
1208     require(
1209       isOperatorFor(msg.sender, _tokenHolder),
1210       "msg.sender is not an operator for _tokenHolder"
1211     );
1212 
1213     mAllowed[_tokenHolder][_spender] = _amount;
1214     emit Approval(_tokenHolder, _spender, _amount);
1215     return true;
1216   }
1217 }
1218 
1219 // File: contracts/openzeppelin-solidity/ownership/Claimable.sol
1220 
1221 /**
1222  * @title Claimable
1223  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
1224  * This allows the new owner to accept the transfer.
1225  */
1226 contract Claimable is Ownable {
1227   address public pendingOwner;
1228 
1229   /**
1230    * @dev Modifier throws if called by any account other than the pendingOwner.
1231    */
1232   modifier onlyPendingOwner() {
1233     require(msg.sender == pendingOwner);
1234     _;
1235   }
1236 
1237   /**
1238    * @dev Allows the current owner to set the pendingOwner address.
1239    * @param newOwner The address to transfer ownership to.
1240    */
1241   function transferOwnership(address newOwner) public onlyOwner {
1242     pendingOwner = newOwner;
1243   }
1244 
1245   /**
1246    * @dev Allows the pendingOwner address to finalize the transfer.
1247    */
1248   function claimOwnership() public onlyPendingOwner {
1249     emit OwnershipTransferred(owner, pendingOwner);
1250     owner = pendingOwner;
1251     pendingOwner = address(0);
1252   }
1253 }
1254 
1255 // File: contracts/SelfToken.sol
1256 
1257 /// @title SelfToken
1258 /// @author Roger Wu (Roger-Wu), Tina Lee (tina1998612), Jeff Hu (yhuag)
1259 /// @dev The inheritance order is important.
1260 contract SelfToken is
1261   ERC777ERC20BaseToken,
1262   PausableFreezableERC777ERC20Token,
1263   ERC777ERC20TokenWithOfficialOperators,
1264   ERC777ERC20TokenWithApproveAndCall,
1265   ERC777ERC20TokenWithBatchTransfer,
1266   CappedMintableERC777ERC20Token,
1267   ERC777ERC20TokenWithOperatorApprove,
1268   Claimable
1269 {
1270   constructor()
1271     public
1272     ERC777ERC20BaseToken("SELF TOKEN", "SELF", 1, new address[](0))
1273     CappedMintableERC777ERC20Token(1e9 * 1e18)
1274   {}
1275 }