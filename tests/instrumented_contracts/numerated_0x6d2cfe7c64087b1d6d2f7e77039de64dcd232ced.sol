1 pragma solidity ^0.4.21;
2 
3 contract ERC820Registry {
4     function getManager(address addr) public view returns(address);
5     function setManager(address addr, address newManager) public;
6     function getInterfaceImplementer(address addr, bytes32 iHash) public constant returns (address);
7     function setInterfaceImplementer(address addr, bytes32 iHash, address implementer) public;
8 }
9 
10 contract ERC820Implementer {
11     ERC820Registry erc820Registry = ERC820Registry(0x991a1bcb077599290d7305493c9A630c20f8b798);
12 
13     function setInterfaceImplementation(string ifaceLabel, address impl) internal {
14         bytes32 ifaceHash = keccak256(ifaceLabel);
15         erc820Registry.setInterfaceImplementer(this, ifaceHash, impl);
16     }
17 
18     function interfaceAddr(address addr, string ifaceLabel) internal constant returns(address) {
19         bytes32 ifaceHash = keccak256(ifaceLabel);
20         return erc820Registry.getInterfaceImplementer(addr, ifaceHash);
21     }
22 
23     function delegateManagement(address newManager) internal {
24         erc820Registry.setManager(this, newManager);
25     }
26 }
27 
28 
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36   address public owner;
37 
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50   /**
51    * @dev Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     require(newOwner != address(0));
64     emit OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67 
68 }
69 /* This Source Code Form is subject to the terms of the Mozilla Public
70 * License, v. 2.0. If a copy of the MPL was not distributed with this
71 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
72 
73 
74 /// @title ERC777 ReferenceToken Contract
75 /// @author Jordi Baylina, Jacques Dafflon
76 /// @dev This token contract's goal is to give an example implementation
77 ///  of ERC777 with ERC20 compatiblity using the base ERC777 and ERC20
78 ///  implementations provided with the erc777 package.
79 ///  This contract does not define any standard, but can be taken as a reference
80 ///  implementation in case of any ambiguity into the standard
81 
82 
83 /* This Source Code Form is subject to the terms of the Mozilla Public
84  * License, v. 2.0. If a copy of the MPL was not distributed with this
85  * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
86 
87 
88 
89 /* This Source Code Form is subject to the terms of the Mozilla Public
90  * License, v. 2.0. If a copy of the MPL was not distributed with this
91  * file, You can obtain one at http://mozilla.org/MPL/2.0/.
92  *
93  * This code has not been reviewed.
94  * Do not use or deploy this code before reviewing it personally first.
95  */
96 // solhint-disable-next-line compiler-fixed
97 
98 
99 
100 interface ERC20Token {
101     function name() public constant returns (string);
102     function symbol() public constant returns (string);
103     function decimals() public constant returns (uint8);
104     function totalSupply() public constant returns (uint256);
105     function balanceOf(address owner) public constant returns (uint256);
106     function transfer(address to, uint256 amount) public returns (bool);
107     function transferFrom(address from, address to, uint256 amount) public returns (bool);
108     function approve(address spender, uint256 amount) public returns (bool);
109     function allowance(address owner, address spender) public constant returns (uint256);
110 
111     // solhint-disable-next-line no-simple-event-func-name
112     event Transfer(address indexed from, address indexed to, uint256 amount);
113     event Approval(address indexed owner, address indexed spender, uint256 amount);
114 }
115 
116 /* This Source Code Form is subject to the terms of the Mozilla Public
117 * License, v. 2.0. If a copy of the MPL was not distributed with this
118 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
119 
120 
121 
122 
123 
124 
125 /**
126  * @title SafeMath
127  * @dev Math operations with safety checks that throw on error
128  */
129 library SafeMath {
130 
131   /**
132   * @dev Multiplies two numbers, throws on overflow.
133   */
134   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
135     if (a == 0) {
136       return 0;
137     }
138     c = a * b;
139     assert(c / a == b);
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers, truncating the quotient.
145   */
146   function div(uint256 a, uint256 b) internal pure returns (uint256) {
147     // assert(b > 0); // Solidity automatically throws when dividing by 0
148     // uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150     return a / b;
151   }
152 
153   /**
154   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
155   */
156   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157     assert(b <= a);
158     return a - b;
159   }
160 
161   /**
162   * @dev Adds two numbers, throws on overflow.
163   */
164   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
165     c = a + b;
166     assert(c >= a);
167     return c;
168   }
169 }
170 
171 /* This Source Code Form is subject to the terms of the Mozilla Public
172  * License, v. 2.0. If a copy of the MPL was not distributed with this
173  * file, You can obtain one at http://mozilla.org/MPL/2.0/.
174  *
175  * This code has not been reviewed.
176  * Do not use or deploy this code before reviewing it personally first.
177  */
178 // solhint-disable-next-line compiler-fixed
179 
180 
181 
182 interface ERC777Token {
183     function name() public view returns (string);
184     function symbol() public view returns (string);
185     function totalSupply() public view returns (uint256);
186     function balanceOf(address owner) public view returns (uint256);
187     function granularity() public view returns (uint256);
188 
189     function defaultOperators() public view returns (address[]);
190     function isOperatorFor(address operator, address tokenHolder) public view returns (bool);
191     function authorizeOperator(address operator) public;
192     function revokeOperator(address operator) public;
193 
194     function send(address to, uint256 amount, bytes holderData) public;
195     function operatorSend(address from, address to, uint256 amount, bytes holderData, bytes operatorData) public;
196 
197     function burn(uint256 amount, bytes holderData) public;
198     function operatorBurn(address from, uint256 amount, bytes holderData, bytes operatorData) public;
199 
200     event Sent(
201         address indexed operator,
202         address indexed from,
203         address indexed to,
204         uint256 amount,
205         bytes holderData,
206         bytes operatorData
207     ); // solhint-disable-next-line separate-by-one-line-in-contract
208     event Minted(address indexed operator, address indexed to, uint256 amount, bytes operatorData);
209     event Burned(address indexed operator, address indexed from, uint256 amount, bytes holderData, bytes operatorData);
210     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
211     event RevokedOperator(address indexed operator, address indexed tokenHolder);
212 }
213 
214 /* This Source Code Form is subject to the terms of the Mozilla Public
215  * License, v. 2.0. If a copy of the MPL was not distributed with this
216  * file, You can obtain one at http://mozilla.org/MPL/2.0/.
217  *
218  * This code has not been reviewed.
219  * Do not use or deploy this code before reviewing it personally first.
220  */
221 // solhint-disable-next-line compiler-fixed
222 
223 
224 
225 interface ERC777TokensSender {
226     function tokensToSend(
227         address operator,
228         address from,
229         address to,
230         uint amount,
231         bytes userData,
232         bytes operatorData
233     ) public;
234 }
235 
236 /* This Source Code Form is subject to the terms of the Mozilla Public
237  * License, v. 2.0. If a copy of the MPL was not distributed with this
238  * file, You can obtain one at http://mozilla.org/MPL/2.0/.
239  *
240  * This code has not been reviewed.
241  * Do not use or deploy this code before reviewing it personally first.
242  */
243 // solhint-disable-next-line compiler-fixed
244 
245 
246 
247 interface ERC777TokensRecipient {
248     function tokensReceived(
249         address operator,
250         address from,
251         address to,
252         uint amount,
253         bytes userData,
254         bytes operatorData
255     ) public;
256 }
257 
258 
259 
260 contract ERC777BaseToken is ERC777Token, ERC820Implementer {
261     using SafeMath for uint256;
262 
263     string internal mName;
264     string internal mSymbol;
265     uint256 internal mGranularity;
266     uint256 internal mTotalSupply;
267 
268 
269     mapping(address => uint) internal mBalances;
270     mapping(address => mapping(address => bool)) internal mAuthorized;
271 
272     address[] internal mDefaultOperators;
273     mapping(address => bool) internal mIsDefaultOperator;
274     mapping(address => mapping(address => bool)) internal mRevokedDefaultOperator;
275 
276     /* -- Constructor -- */
277     //
278     /// @notice Constructor to create a ReferenceToken
279     /// @param _name Name of the new token
280     /// @param _symbol Symbol of the new token.
281     /// @param _granularity Minimum transferable chunk.
282     function ERC777BaseToken(string _name, string _symbol, uint256 _granularity, address[] _defaultOperators) internal {
283         mName = _name;
284         mSymbol = _symbol;
285         mTotalSupply = 0;
286         require(_granularity >= 1);
287         mGranularity = _granularity;
288 
289         mDefaultOperators = _defaultOperators;
290         for (uint i = 0; i < mDefaultOperators.length; i++) { mIsDefaultOperator[mDefaultOperators[i]] = true; }
291 
292         setInterfaceImplementation("ERC777Token", this);
293     }
294 
295     /* -- ERC777 Interface Implementation -- */
296     //
297     /// @return the name of the token
298     function name() public constant returns (string) { return mName; }
299 
300     /// @return the symbol of the token
301     function symbol() public constant returns (string) { return mSymbol; }
302 
303     /// @return the granularity of the token
304     function granularity() public constant returns (uint256) { return mGranularity; }
305 
306     /// @return the total supply of the token
307     function totalSupply() public constant returns (uint256) { return mTotalSupply; }
308 
309     /// @notice Return the account balance of some account
310     /// @param _tokenHolder Address for which the balance is returned
311     /// @return the balance of `_tokenAddress`.
312     function balanceOf(address _tokenHolder) public constant returns (uint256) { return mBalances[_tokenHolder]; }
313 
314     /// @notice Return the list of default operators
315     /// @return the list of all the default operators
316     function defaultOperators() public view returns (address[]) { return mDefaultOperators; }
317 
318     /// @notice Send `_amount` of tokens to address `_to` passing `_userData` to the recipient
319     /// @param _to The address of the recipient
320     /// @param _amount The number of tokens to be sent
321     function send(address _to, uint256 _amount, bytes _userData) public {
322         doSend(msg.sender, msg.sender, _to, _amount, _userData, "", true);
323     }
324 
325     /// @notice Authorize a third party `_operator` to manage (send) `msg.sender`'s tokens.
326     /// @param _operator The operator that wants to be Authorized
327     function authorizeOperator(address _operator) public {
328         require(_operator != msg.sender);
329         if (mIsDefaultOperator[_operator]) {
330             mRevokedDefaultOperator[_operator][msg.sender] = false;
331         } else {
332             mAuthorized[_operator][msg.sender] = true;
333         }
334         AuthorizedOperator(_operator, msg.sender);
335     }
336 
337     /// @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens.
338     /// @param _operator The operator that wants to be Revoked
339     function revokeOperator(address _operator) public {
340         require(_operator != msg.sender);
341         if (mIsDefaultOperator[_operator]) {
342             mRevokedDefaultOperator[_operator][msg.sender] = true;
343         } else {
344             mAuthorized[_operator][msg.sender] = false;
345         }
346         RevokedOperator(_operator, msg.sender);
347     }
348 
349     /// @notice Check whether the `_operator` address is allowed to manage the tokens held by `_tokenHolder` address.
350     /// @param _operator address to check if it has the right to manage the tokens
351     /// @param _tokenHolder address which holds the tokens to be managed
352     /// @return `true` if `_operator` is authorized for `_tokenHolder`
353     function isOperatorFor(address _operator, address _tokenHolder) public constant returns (bool) {
354         return (_operator == _tokenHolder
355             || mAuthorized[_operator][_tokenHolder]
356             || (mIsDefaultOperator[_operator] && !mRevokedDefaultOperator[_operator][_tokenHolder]));
357     }
358 
359     /// @notice Send `_amount` of tokens on behalf of the address `from` to the address `to`.
360     /// @param _from The address holding the tokens being sent
361     /// @param _to The address of the recipient
362     /// @param _amount The number of tokens to be sent
363     /// @param _userData Data generated by the user to be sent to the recipient
364     /// @param _operatorData Data generated by the operator to be sent to the recipient
365     function operatorSend(address _from, address _to, uint256 _amount, bytes _userData, bytes _operatorData) public {
366         require(isOperatorFor(msg.sender, _from));
367         doSend(msg.sender, _from, _to, _amount, _userData, _operatorData, true);
368     }
369 
370     function burn(uint256 _amount, bytes _holderData) public {
371         doBurn(msg.sender, msg.sender, _amount, _holderData, "");
372     }
373 
374     function operatorBurn(address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData) public {
375         require(isOperatorFor(msg.sender, _tokenHolder));
376         doBurn(msg.sender, _tokenHolder, _amount, _holderData, _operatorData);
377     }
378 
379     /* -- Helper Functions -- */
380     //
381     /// @notice Internal function that ensures `_amount` is multiple of the granularity
382     /// @param _amount The quantity that want's to be checked
383     function requireMultiple(uint256 _amount) internal view {
384         require(_amount.div(mGranularity).mul(mGranularity) == _amount);
385     }
386 
387     /// @notice Check whether an address is a regular address or not.
388     /// @param _addr Address of the contract that has to be checked
389     /// @return `true` if `_addr` is a regular address (not a contract)
390     function isRegularAddress(address _addr) internal constant returns(bool) {
391         if (_addr == 0) { return false; }
392         uint size;
393         assembly { size := extcodesize(_addr) } // solhint-disable-line no-inline-assembly
394         return size == 0;
395     }
396 
397     /// @notice Helper function actually performing the sending of tokens.
398     /// @param _operator The address performing the send
399     /// @param _from The address holding the tokens being sent
400     /// @param _to The address of the recipient
401     /// @param _amount The number of tokens to be sent
402     /// @param _userData Data generated by the user to be passed to the recipient
403     /// @param _operatorData Data generated by the operator to be passed to the recipient
404     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
405     ///  implementing `erc777_tokenHolder`.
406     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
407     ///  functions SHOULD set this parameter to `false`.
408     function doSend(
409         address _operator,
410         address _from,
411         address _to,
412         uint256 _amount,
413         bytes _userData,
414         bytes _operatorData,
415         bool _preventLocking
416     )
417         internal
418     {
419         requireMultiple(_amount);
420 
421         callSender(_operator, _from, _to, _amount, _userData, _operatorData);
422 
423         require(_to != address(0));          // forbid sending to 0x0 (=burning)
424         require(mBalances[_from] >= _amount); // ensure enough funds
425 
426         mBalances[_from] = mBalances[_from].sub(_amount);
427         mBalances[_to] = mBalances[_to].add(_amount);
428 
429         callRecipient(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
430 
431         Sent(_operator, _from, _to, _amount, _userData, _operatorData);
432     }
433 
434     /// @notice Helper function actually performing the burning of tokens.
435     /// @param _operator The address performing the burn
436     /// @param _tokenHolder The address holding the tokens being burn
437     /// @param _amount The number of tokens to be burnt
438     /// @param _holderData Data generated by the token holder
439     /// @param _operatorData Data generated by the operator
440     function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData)
441         internal
442     {
443         requireMultiple(_amount);
444         require(balanceOf(_tokenHolder) >= _amount);
445 
446         mBalances[_tokenHolder] = mBalances[_tokenHolder].sub(_amount);
447         mTotalSupply = mTotalSupply.sub(_amount);
448 
449         callSender(_operator, _tokenHolder, 0x0, _amount, _holderData, _operatorData);
450         Burned(_operator, _tokenHolder, _amount, _holderData, _operatorData);
451     }
452 
453     /// @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.
454     ///  May throw according to `_preventLocking`
455     /// @param _operator The address performing the send or mint
456     /// @param _from The address holding the tokens being sent
457     /// @param _to The address of the recipient
458     /// @param _amount The number of tokens to be sent
459     /// @param _userData Data generated by the user to be passed to the recipient
460     /// @param _operatorData Data generated by the operator to be passed to the recipient
461     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
462     ///  implementing `ERC777TokensRecipient`.
463     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
464     ///  functions SHOULD set this parameter to `false`.
465     function callRecipient(
466         address _operator,
467         address _from,
468         address _to,
469         uint256 _amount,
470         bytes _userData,
471         bytes _operatorData,
472         bool _preventLocking
473     )
474         internal
475     {
476         address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");
477         if (recipientImplementation != 0) {
478             ERC777TokensRecipient(recipientImplementation).tokensReceived(
479                 _operator, _from, _to, _amount, _userData, _operatorData);
480         } else if (_preventLocking) {
481             require(isRegularAddress(_to));
482         }
483     }
484 
485     /// @notice Helper function that checks for ERC777TokensSender on the sender and calls it.
486     ///  May throw according to `_preventLocking`
487     /// @param _from The address holding the tokens being sent
488     /// @param _to The address of the recipient
489     /// @param _amount The amount of tokens to be sent
490     /// @param _userData Data generated by the user to be passed to the recipient
491     /// @param _operatorData Data generated by the operator to be passed to the recipient
492     ///  implementing `ERC777TokensSender`.
493     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
494     ///  functions SHOULD set this parameter to `false`.
495     function callSender(
496         address _operator,
497         address _from,
498         address _to,
499         uint256 _amount,
500         bytes _userData,
501         bytes _operatorData
502     )
503         internal
504     {
505         address senderImplementation = interfaceAddr(_from, "ERC777TokensSender");
506         if (senderImplementation == 0) { return; }
507         ERC777TokensSender(senderImplementation).tokensToSend(_operator, _from, _to, _amount, _userData, _operatorData);
508     }
509 }
510 
511 
512 
513 contract ERC777ERC20BaseToken is ERC20Token, ERC777BaseToken {
514     bool internal mErc20compatible;
515     bool public unlocked;
516 
517     mapping(address => mapping(address => bool)) internal mAuthorized;
518     mapping(address => mapping(address => uint256)) internal mAllowed;
519 
520     function ERC777ERC20BaseToken(
521         string _name,
522         string _symbol,
523         uint256 _granularity,
524         address[] _defaultOperators
525     )
526         internal ERC777BaseToken(_name, _symbol, _granularity, _defaultOperators)
527     {
528         mErc20compatible = true;
529         unlocked = true;
530         setInterfaceImplementation("ERC20Token", this);
531     }
532 
533     /// @notice This modifier is applied to erc20 obsolete methods that are
534     ///  implemented only to maintain backwards compatibility. When the erc20
535     ///  compatibility is disabled, this methods will fail.
536     modifier erc20 () {
537         require(mErc20compatible);
538         _;
539     }
540 
541     /// @notice For Backwards compatibility
542     /// @return The decimls of the token. Forced to 18 in ERC777.
543     function decimals() public erc20 constant returns (uint8) { return uint8(18); }
544 
545     /// @notice ERC20 backwards compatible transfer.
546     /// @param _to The address of the recipient
547     /// @param _amount The number of tokens to be transferred
548     /// @return `true`, if the transfer can't be done, it should fail.
549     function transfer(address _to, uint256 _amount) public erc20 returns (bool success) {
550         doSend(msg.sender, msg.sender, _to, _amount, "", "", false);
551         return true;
552     }
553 
554     /// @notice ERC20 backwards compatible transferFrom.
555     /// @param _from The address holding the tokens being transferred
556     /// @param _to The address of the recipient
557     /// @param _amount The number of tokens to be transferred
558     /// @return `true`, if the transfer can't be done, it should fail.
559     function transferFrom(address _from, address _to, uint256 _amount) public erc20 returns (bool success) {
560         require(_amount <= mAllowed[_from][msg.sender]);
561 
562         // Cannot be after doSend because of tokensReceived re-entry
563         mAllowed[_from][msg.sender] = mAllowed[_from][msg.sender].sub(_amount);
564         doSend(msg.sender, _from, _to, _amount, "", "", false);
565         return true;
566     }
567 
568     /// @notice ERC20 backwards compatible approve.
569     ///  `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
570     /// @param _spender The address of the account able to transfer the tokens
571     /// @param _amount The number of tokens to be approved for transfer
572     /// @return `true`, if the approve can't be done, it should fail.
573     function approve(address _spender, uint256 _amount) public erc20 returns (bool success) {
574         mAllowed[msg.sender][_spender] = _amount;
575         Approval(msg.sender, _spender, _amount);
576         return true;
577     }
578 
579     /// @notice ERC20 backwards compatible allowance.
580     ///  This function makes it easy to read the `allowed[]` map
581     /// @param _owner The address of the account that owns the token
582     /// @param _spender The address of the account able to transfer the tokens
583     /// @return Amount of remaining tokens of _owner that _spender is allowed
584     ///  to spend
585     function allowance(address _owner, address _spender) public erc20 constant returns (uint256 remaining) {
586         return mAllowed[_owner][_spender];
587     }
588 
589     function doSend(
590         address _operator,
591         address _from,
592         address _to,
593         uint256 _amount,
594         bytes _userData,
595         bytes _operatorData,
596         bool _preventLocking
597     )
598         internal
599     {
600         require(unlocked);
601         super.doSend(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
602         if (mErc20compatible) { Transfer(_from, _to, _amount); }
603     }
604 
605     function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData)
606         internal
607     {
608         super.doBurn(_operator, _tokenHolder, _amount, _holderData, _operatorData);
609         if (mErc20compatible) { Transfer(_tokenHolder, 0x0, _amount); }
610     }
611 }
612 
613 
614 
615 
616 contract ReferenceToken is ERC777ERC20BaseToken, Ownable {
617 
618     address private mBurnOperator;
619 
620     function ReferenceToken(
621         string _name,
622         string _symbol,
623         uint256 _granularity,
624         address[] _defaultOperators,
625         address _burnOperator
626     ) public ERC777ERC20BaseToken(_name, _symbol, _granularity, _defaultOperators) {
627         mBurnOperator = _burnOperator;
628     }
629 
630     /// @notice Disables the ERC20 interface. This function can only be called
631     ///  by the owner.
632     function disableERC20() public onlyOwner {
633         mErc20compatible = false;
634         setInterfaceImplementation("ERC20Token", 0x0);
635     }
636 
637     /// @notice Re enables the ERC20 interface. This function can only be called
638     ///  by the owner.
639     function enableERC20() public onlyOwner {
640         mErc20compatible = true;
641         setInterfaceImplementation("ERC20Token", this);
642     }
643 
644     /// @notice Disables an interface. This function can only be called
645     ///  by the owner.
646     function disableInterface(string _interface) public onlyOwner { setInterfaceImplementation(_interface, 0x0); }
647 
648     /// @notice Enables an interface. This function can only be called
649     ///  by the owner.
650     function enableInterface(string _interface, address _impl) public onlyOwner { setInterfaceImplementation(_interface, _impl); }
651 
652     /// @notice sets the manager of register implementations of interfaces. This function can only be called
653     ///  by the owner.
654     function delegateERC820Management(address _newManager) public onlyOwner { delegateManagement(_newManager); }
655 
656     /// @notice Locks the token. In later stage, this feature will be disabled. This function can only be called
657     ///  by the owner.
658     function lock() public onlyOwner { unlocked = false; }
659 
660     /// @notice Unlocks the token. This function can only be called
661     ///  by the owner.
662     function unlock() public onlyOwner { unlocked = true;}
663 
664 
665     /* -- Mint And Burn Functions (not part of the ERC777 standard, only the Events/tokensReceived call are) -- */
666     //
667     /// @notice Generates `_amount` tokens to be assigned to `_tokenHolder`
668     ///  Sample mint function to showcase the use of the `Minted` event and the logic to notify the recipient.
669     /// @param _tokenHolder The address that will be assigned the new tokens
670     /// @param _amount The quantity of tokens generated
671     /// @param _operatorData Data that will be passed to the recipient as a first transfer
672     function mint(address _tokenHolder, uint256 _amount, bytes _operatorData) public onlyOwner {
673         requireMultiple(_amount);
674         mTotalSupply = mTotalSupply.add(_amount);
675         mBalances[_tokenHolder] = mBalances[_tokenHolder].add(_amount);
676 
677         callRecipient(msg.sender, 0x0, _tokenHolder, _amount, "", _operatorData, true);
678 
679         Minted(msg.sender, _tokenHolder, _amount, _operatorData);
680         if (mErc20compatible) { Transfer(0x0, _tokenHolder, _amount); }
681     }
682 
683     /// @notice Burns `_amount` tokens from `_tokenHolder`
684     ///  Silly example of overriding the `burn` function to only let the owner burn its tokens.
685     ///  Do not forget to override the `burn` function in your token contract if you want to prevent users from
686     ///  burning their tokens.
687     /// @param _amount The quantity of tokens to burn
688     function burn(uint256 _amount, bytes _holderData) public onlyOwner {
689         require(msg.sender == mBurnOperator);
690         super.burn(_amount, _holderData);
691     }
692 
693     /// @notice Burns `_amount` tokens from `_tokenHolder` by `_operator`
694     ///  Silly example of overriding the `operatorBurn` function to only let a specific operator burn tokens.
695     ///  Do not forget to override the `operatorBurn` function in your token contract if you want to prevent users from
696     ///  burning their tokens.
697     /// @param _tokenHolder The address that will lose the tokens
698     /// @param _amount The quantity of tokens to burn
699     function operatorBurn(address _tokenHolder, uint256 _amount, bytes _holderData, bytes _operatorData) public {
700         require(msg.sender == mBurnOperator);
701         super.operatorBurn(_tokenHolder, _amount, _holderData, _operatorData);
702     }
703 }