1 pragma solidity 0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title Owned
36  * @author Adria Massanet <adria@codecontext.io>
37  * @notice The Owned contract has an owner address, and provides basic
38  *  authorization control functions, this simplifies & the implementation of
39  *  user permissions; this contract has three work flows for a change in
40  *  ownership, the first requires the new owner to validate that they have the
41  *  ability to accept ownership, the second allows the ownership to be
42  *  directly transferred without requiring acceptance, and the third allows for
43  *  the ownership to be removed to allow for decentralization
44  */
45 contract Owned {
46 
47     address public owner;
48     address public newOwnerCandidate;
49 
50     event OwnershipRequested(address indexed by, address indexed to);
51     event OwnershipTransferred(address indexed from, address indexed to);
52     event OwnershipRemoved();
53 
54     /**
55      * @dev The constructor sets the `msg.sender` as the`owner` of the contract
56      */
57     constructor() public {
58         owner = msg.sender;
59     }
60 
61     /**
62      * @dev `owner` is the only address that can call a function with this
63      * modifier
64      */
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     /**
71      * @dev In this 1st option for ownership transfer `proposeOwnership()` must
72      *  be called first by the current `owner` then `acceptOwnership()` must be
73      *  called by the `newOwnerCandidate`
74      * @notice `onlyOwner` Proposes to transfer control of the contract to a
75      *  new owner
76      * @param _newOwnerCandidate The address being proposed as the new owner
77      */
78     function proposeOwnership(address _newOwnerCandidate) external onlyOwner {
79         newOwnerCandidate = _newOwnerCandidate;
80         emit OwnershipRequested(msg.sender, newOwnerCandidate);
81     }
82 
83     /**
84      * @notice Can only be called by the `newOwnerCandidate`, accepts the
85      *  transfer of ownership
86      */
87     function acceptOwnership() external {
88         require(msg.sender == newOwnerCandidate);
89 
90         address oldOwner = owner;
91         owner = newOwnerCandidate;
92         newOwnerCandidate = 0x0;
93 
94         emit OwnershipTransferred(oldOwner, owner);
95     }
96 
97     /**
98      * @dev In this 2nd option for ownership transfer `changeOwnership()` can
99      *  be called and it will immediately assign ownership to the `newOwner`
100      * @notice `owner` can step down and assign some other address to this role
101      * @param _newOwner The address of the new owner
102      */
103     function changeOwnership(address _newOwner) external onlyOwner {
104         require(_newOwner != 0x0);
105 
106         address oldOwner = owner;
107         owner = _newOwner;
108         newOwnerCandidate = 0x0;
109 
110         emit OwnershipTransferred(oldOwner, owner);
111     }
112 
113     /**
114      * @dev In this 3rd option for ownership transfer `removeOwnership()` can
115      *  be called and it will immediately assign ownership to the 0x0 address;
116      *  it requires a 0xdece be input as a parameter to prevent accidental use
117      * @notice Decentralizes the contract, this operation cannot be undone
118      * @param _dac `0xdac` has to be entered for this function to work
119      */
120     function removeOwnership(address _dac) external onlyOwner {
121         require(_dac == 0xdac);
122         owner = 0x0;
123         newOwnerCandidate = 0x0;
124         emit OwnershipRemoved();
125     }
126 }
127 
128 /* This Source Code Form is subject to the terms of the Mozilla Public
129  * License, v. 2.0. If a copy of the MPL was not distributed with this
130  * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
131 
132 interface ERC777TokensRecipient {
133     function tokensReceived(
134         address operator,
135         address from,
136         address to,
137         uint amount,
138         bytes userData,
139         bytes operatorData
140     ) public;
141 }
142 
143 /* This Source Code Form is subject to the terms of the Mozilla Public
144  * License, v. 2.0. If a copy of the MPL was not distributed with this
145  * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
146 
147 interface ERC777TokensSender {
148     function tokensToSend(
149         address operator,
150         address from,
151         address to,
152         uint amount,
153         bytes userData,
154         bytes operatorData
155     ) public;
156 }
157 
158 /* This Source Code Form is subject to the terms of the Mozilla Public
159  * License, v. 2.0. If a copy of the MPL was not distributed with this
160  * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
161 
162 interface ERC777Token {
163     function name() public view returns (string);
164 
165     function symbol() public view returns (string);
166 
167     function totalSupply() public view returns (uint256);
168 
169     function granularity() public view returns (uint256);
170 
171     function balanceOf(address owner) public view returns (uint256);
172 
173     function send(address to, uint256 amount) public;
174 
175     function send(address to, uint256 amount, bytes userData) public;
176 
177     function authorizeOperator(address operator) public;
178 
179     function revokeOperator(address operator) public;
180 
181     function isOperatorFor(address operator, address tokenHolder) public view returns (bool);
182 
183     function operatorSend(address from, address to, uint256 amount, bytes userData, bytes operatorData) public;
184 
185     event Sent(
186         address indexed operator,
187         address indexed from,
188         address indexed to,
189         uint256 amount,
190         bytes userData,
191         bytes operatorData
192     ); // solhint-disable-next-line separate-by-one-line-in-contract
193     event Minted(address indexed operator, address indexed to, uint256 amount, bytes operatorData);
194     event Burned(address indexed operator, address indexed from, uint256 amount, bytes userData, bytes operatorData);
195     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
196     event RevokedOperator(address indexed operator, address indexed tokenHolder);
197 }
198 
199 /* This Source Code Form is subject to the terms of the Mozilla Public
200  * License, v. 2.0. If a copy of the MPL was not distributed with this
201  * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
202 
203 interface ERC20Token {
204     function name() public view returns (string);
205 
206     function symbol() public view returns (string);
207 
208     function decimals() public view returns (uint8);
209 
210     function totalSupply() public view returns (uint256);
211 
212     function balanceOf(address owner) public view returns (uint256);
213 
214     function transfer(address to, uint256 amount) public returns (bool);
215 
216     function transferFrom(address from, address to, uint256 amount) public returns (bool);
217 
218     function approve(address spender, uint256 amount) public returns (bool);
219 
220     function allowance(address owner, address spender) public view returns (uint256);
221 
222     // solhint-disable-next-line no-simple-event-func-name
223     event Transfer(address indexed from, address indexed to, uint256 amount);
224     event Approval(address indexed owner, address indexed spender, uint256 amount);
225 }
226 
227 contract ERC820Registry {
228     function getManager(address addr) public view returns(address);
229     function setManager(address addr, address newManager) public;
230     function getInterfaceImplementer(address addr, bytes32 iHash) public constant returns (address);
231     function setInterfaceImplementer(address addr, bytes32 iHash, address implementer) public;
232 }
233 
234 contract ERC820Implementer {
235     ERC820Registry public erc820Registry;
236 
237     constructor(address _registry) public {
238         erc820Registry = ERC820Registry(_registry);
239     }
240 
241     function setInterfaceImplementation(string ifaceLabel, address impl) internal {
242         bytes32 ifaceHash = keccak256(ifaceLabel);
243         erc820Registry.setInterfaceImplementer(this, ifaceHash, impl);
244     }
245 
246     function interfaceAddr(address addr, string ifaceLabel) internal constant returns(address) {
247         bytes32 ifaceHash = keccak256(ifaceLabel);
248         return erc820Registry.getInterfaceImplementer(addr, ifaceHash);
249     }
250 
251     function delegateManagement(address newManager) internal {
252         erc820Registry.setManager(this, newManager);
253     }
254 }
255 
256 /**
257  * @title ERC777 Helper Contract
258  * @author Panos
259  */
260 contract ERC777Helper is ERC777Token, ERC20Token, ERC820Implementer {
261     using SafeMath for uint256;
262 
263     bool internal mErc20compatible;
264     uint256 internal mGranularity;
265     mapping(address => uint) internal mBalances;
266 
267     /**
268      * @notice Internal function that ensures `_amount` is multiple of the granularity
269      * @param _amount The quantity that want's to be checked
270      */
271     function requireMultiple(uint256 _amount) internal view {
272         require(_amount.div(mGranularity).mul(mGranularity) == _amount);
273     }
274 
275     /**
276      * @notice Check whether an address is a regular address or not.
277      * @param _addr Address of the contract that has to be checked
278      * @return `true` if `_addr` is a regular address (not a contract)
279      */
280     function isRegularAddress(address _addr) internal view returns(bool) {
281         if (_addr == 0) { return false; }
282         uint size;
283         assembly { size := extcodesize(_addr) } // solhint-disable-line no-inline-assembly
284         return size == 0;
285     }
286 
287     /**
288      * @notice Helper function actually performing the sending of tokens.
289      * @param _from The address holding the tokens being sent
290      * @param _to The address of the recipient
291      * @param _amount The number of tokens to be sent
292      * @param _userData Data generated by the user to be passed to the recipient
293      * @param _operatorData Data generated by the operator to be passed to the recipient
294      * @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
295      *  implementing `erc777_tokenHolder`.
296      *  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
297      *  functions SHOULD set this parameter to `false`.
298      */
299     function doSend(
300         address _from,
301         address _to,
302         uint256 _amount,
303         bytes _userData,
304         address _operator,
305         bytes _operatorData,
306         bool _preventLocking
307     )
308     internal
309     {
310         requireMultiple(_amount);
311 
312         callSender(_operator, _from, _to, _amount, _userData, _operatorData);
313 
314         require(_to != address(0));          // forbid sending to 0x0 (=burning)
315         require(mBalances[_from] >= _amount); // ensure enough funds
316 
317         mBalances[_from] = mBalances[_from].sub(_amount);
318         mBalances[_to] = mBalances[_to].add(_amount);
319 
320         callRecipient(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
321 
322         emit Sent(_operator, _from, _to, _amount, _userData, _operatorData);
323         if (mErc20compatible) { emit Transfer(_from, _to, _amount); }
324     }
325 
326     /**
327      * @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.
328      *  May throw according to `_preventLocking`
329      * @param _from The address holding the tokens being sent
330      * @param _to The address of the recipient
331      * @param _amount The number of tokens to be sent
332      * @param _userData Data generated by the user to be passed to the recipient
333      * @param _operatorData Data generated by the operator to be passed to the recipient
334      * @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
335      *  implementing `ERC777TokensRecipient`.
336      *  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
337      *  functions SHOULD set this parameter to `false`.
338      */
339     function callRecipient(
340         address _operator,
341         address _from,
342         address _to,
343         uint256 _amount,
344         bytes _userData,
345         bytes _operatorData,
346         bool _preventLocking
347     ) internal {
348         address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");
349         if (recipientImplementation != 0) {
350             ERC777TokensRecipient(recipientImplementation).tokensReceived(
351                 _operator, _from, _to, _amount, _userData, _operatorData);
352         } else if (_preventLocking) {
353             require(isRegularAddress(_to));
354         }
355     }
356 
357     /**
358      * @notice Helper function that checks for ERC777TokensSender on the sender and calls it.
359      *  May throw according to `_preventLocking`
360      * @param _from The address holding the tokens being sent
361      * @param _to The address of the recipient
362      * @param _amount The amount of tokens to be sent
363      * @param _userData Data generated by the user to be passed to the recipient
364      * @param _operatorData Data generated by the operator to be passed to the recipient
365      *  implementing `ERC777TokensSender`.
366      *  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
367      *  functions SHOULD set this parameter to `false`.
368      */
369     function callSender(
370         address _operator,
371         address _from,
372         address _to,
373         uint256 _amount,
374         bytes _userData,
375         bytes _operatorData
376     ) internal {
377         address senderImplementation = interfaceAddr(_from, "ERC777TokensSender");
378         if (senderImplementation != 0) {
379             ERC777TokensSender(senderImplementation).tokensToSend(
380                 _operator, _from, _to, _amount, _userData, _operatorData);
381         }
382     }
383 }
384 
385 /**
386  * @title ERC20 Compatibility Contract
387  * @author Panos
388  */
389 contract ERC20TokenCompat is ERC777Helper, Owned {
390 
391     mapping(address => mapping(address => uint256)) private mAllowed;
392 
393     /**
394      * @notice Contract construction
395      */
396     constructor() public {
397         mErc20compatible = true;
398         setInterfaceImplementation("ERC20Token", this);
399     }
400 
401     /**
402      * @notice This modifier is applied to erc20 obsolete methods that are
403      * implemented only to maintain backwards compatibility. When the erc20
404      * compatibility is disabled, this methods will fail.
405      */
406     modifier erc20 () {
407         require(mErc20compatible);
408         _;
409     }
410 
411     /**
412      * @notice Disables the ERC20 interface. This function can only be called
413      * by the owner.
414      */
415     function disableERC20() public onlyOwner {
416         mErc20compatible = false;
417         setInterfaceImplementation("ERC20Token", 0x0);
418     }
419 
420     /**
421      * @notice Re enables the ERC20 interface. This function can only be called
422      *  by the owner.
423      */
424     function enableERC20() public onlyOwner {
425         mErc20compatible = true;
426         setInterfaceImplementation("ERC20Token", this);
427     }
428 
429     /*
430      * @notice For Backwards compatibility
431      * @return The decimals of the token. Forced to 18 in ERC777.
432      */
433     function decimals() public erc20 view returns (uint8) {return uint8(18);}
434 
435     /**
436      * @notice ERC20 backwards compatible transfer.
437      * @param _to The address of the recipient
438      * @param _amount The number of tokens to be transferred
439      * @return `true`, if the transfer can't be done, it should fail.
440      */
441     function transfer(address _to, uint256 _amount) public erc20 returns (bool success) {
442         doSend(msg.sender, _to, _amount, "", msg.sender, "", false);
443         return true;
444     }
445 
446     /**
447      * @notice ERC20 backwards compatible transferFrom.
448      * @param _from The address holding the tokens being transferred
449      * @param _to The address of the recipient
450      * @param _amount The number of tokens to be transferred
451      * @return `true`, if the transfer can't be done, it should fail.
452      */
453     function transferFrom(address _from, address _to, uint256 _amount) public erc20 returns (bool success) {
454         require(_amount <= mAllowed[_from][msg.sender]);
455 
456         // Cannot be after doSend because of tokensReceived re-entry
457         mAllowed[_from][msg.sender] = mAllowed[_from][msg.sender].sub(_amount);
458         doSend(_from, _to, _amount, "", msg.sender, "", false);
459         return true;
460     }
461 
462     /**
463      * @notice ERC20 backwards compatible approve.
464      *  `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
465      * @param _spender The address of the account able to transfer the tokens
466      * @param _amount The number of tokens to be approved for transfer
467      * @return `true`, if the approve can't be done, it should fail.
468      */
469     function approve(address _spender, uint256 _amount) public erc20 returns (bool success) {
470         mAllowed[msg.sender][_spender] = _amount;
471         emit Approval(msg.sender, _spender, _amount);
472         return true;
473     }
474 
475     /**
476      * @notice ERC20 backwards compatible allowance.
477      *  This function makes it easy to read the `allowed[]` map
478      * @param _owner The address of the account that owns the token
479      * @param _spender The address of the account able to transfer the tokens
480      * @return Amount of remaining tokens of _owner that _spender is allowed
481      *  to spend
482      */
483     function allowance(address _owner, address _spender) public erc20 view returns (uint256 remaining) {
484         return mAllowed[_owner][_spender];
485     }
486 }
487 
488 /**
489  * @title ERC777 Standard Contract
490  * @author Panos
491  */
492 contract ERC777StandardToken is ERC777Helper, Owned {
493     string private mName;
494     string private mSymbol;
495     uint256 private mTotalSupply;
496 
497     mapping(address => mapping(address => bool)) private mAuthorized;
498 
499     /**
500      * @notice Constructor to create a ERC777StandardToken
501      * @param _name Name of the new token
502      * @param _symbol Symbol of the new token.
503      * @param _totalSupply Total tokens issued
504      * @param _granularity Minimum transferable chunk.
505      */
506     constructor(
507         string _name,
508         string _symbol,
509         uint256 _totalSupply,
510         uint256 _granularity
511     )
512     public {
513         require(_granularity >= 1);
514         require(_totalSupply > 0);
515 
516         mName = _name;
517         mSymbol = _symbol;
518         mTotalSupply = _totalSupply;
519         mGranularity = _granularity;
520         mBalances[msg.sender] = mTotalSupply;
521 
522         setInterfaceImplementation("ERC777Token", this);
523     }
524 
525     /**
526      * @return the name of the token
527      */
528     function name() public view returns (string) {return mName;}
529 
530     /**
531      * @return the symbol of the token
532      */
533     function symbol() public view returns (string) {return mSymbol;}
534 
535     /**
536      * @return the granularity of the token
537      */
538     function granularity() public view returns (uint256) {return mGranularity;}
539 
540     /**
541      * @return the total supply of the token
542      */
543     function totalSupply() public view returns (uint256) {return mTotalSupply;}
544 
545     /**
546      * @notice Return the account balance of some account
547      * @param _tokenHolder Address for which the balance is returned
548      * @return the balance of `_tokenAddress`.
549      */
550     function balanceOf(address _tokenHolder) public view returns (uint256) {return mBalances[_tokenHolder];}
551 
552     /**
553      * @notice Send `_amount` of tokens to address `_to`
554      * @param _to The address of the recipient
555      * @param _amount The number of tokens to be sent
556      */
557     function send(address _to, uint256 _amount) public {
558         doSend(msg.sender, _to, _amount, "", msg.sender, "", true);
559     }
560 
561     /**
562      * @notice Send `_amount` of tokens to address `_to` passing `_userData` to the recipient
563      * @param _to The address of the recipient
564      * @param _amount The number of tokens to be sent
565      * @param _userData The user supplied data
566      */
567     function send(address _to, uint256 _amount, bytes _userData) public {
568         doSend(msg.sender, _to, _amount, _userData, msg.sender, "", true);
569     }
570 
571     /**
572      * @notice Authorize a third party `_operator` to manage (send) `msg.sender`'s tokens.
573      * @param _operator The operator that wants to be Authorized
574      */
575     function authorizeOperator(address _operator) public {
576         require(_operator != msg.sender);
577         mAuthorized[_operator][msg.sender] = true;
578         emit AuthorizedOperator(_operator, msg.sender);
579     }
580 
581     /**
582      * @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens.
583      * @param _operator The operator that wants to be Revoked
584      */
585     function revokeOperator(address _operator) public {
586         require(_operator != msg.sender);
587         mAuthorized[_operator][msg.sender] = false;
588         emit RevokedOperator(_operator, msg.sender);
589     }
590 
591     /**
592      * @notice Check whether the `_operator` address is allowed to manage the tokens held by `_tokenHolder` address.
593      * @param _operator address to check if it has the right to manage the tokens
594      * @param _tokenHolder address which holds the tokens to be managed
595      * @return `true` if `_operator` is authorized for `_tokenHolder`
596      */
597     function isOperatorFor(address _operator, address _tokenHolder) public view returns (bool) {
598         return _operator == _tokenHolder || mAuthorized[_operator][_tokenHolder];
599     }
600 
601     /**
602      * @notice Send `_amount` of tokens on behalf of the address `from` to the address `to`.
603      * @param _from The address holding the tokens being sent
604      * @param _to The address of the recipient
605      * @param _amount The number of tokens to be sent
606      * @param _userData Data generated by the user to be sent to the recipient
607      * @param _operatorData Data generated by the operator to be sent to the recipient
608      */
609     function operatorSend(address _from, address _to, uint256 _amount, bytes _userData, bytes _operatorData) public {
610         require(isOperatorFor(msg.sender, _from));
611         doSend(_from, _to, _amount, _userData, msg.sender, _operatorData, true);
612     }
613 }
614 
615 /**
616  * @title ERC20 Multi Transfer Contract
617  * @author Panos
618  */
619 contract ERC20Multi is ERC20TokenCompat {
620 
621     /**
622      * @dev Transfer the specified amounts of tokens to the specified addresses.
623      * @dev Be aware that there is no check for duplicate recipients.
624      * @param _toAddresses Receiver addresses.
625      * @param _amounts Amounts of tokens that will be transferred.
626      */
627     function multiPartyTransfer(address[] _toAddresses, uint256[] _amounts) external erc20 {
628         /* Ensures _toAddresses array is less than or equal to 255 */
629         require(_toAddresses.length <= 255);
630         /* Ensures _toAddress and _amounts have the same number of entries. */
631         require(_toAddresses.length == _amounts.length);
632 
633         for (uint8 i = 0; i < _toAddresses.length; i++) {
634             transfer(_toAddresses[i], _amounts[i]);
635         }
636     }
637 
638     /**
639     * @dev Transfer the specified amounts of tokens to the specified addresses from authorized balance of sender.
640     * @dev Be aware that there is no check for duplicate recipients.
641     * @param _from The address of the sender
642     * @param _toAddresses The addresses of the recipients (MAX 255)
643     * @param _amounts The amounts of tokens to be transferred
644     */
645     function multiPartyTransferFrom(address _from, address[] _toAddresses, uint256[] _amounts) external erc20 {
646         /* Ensures _toAddresses array is less than or equal to 255 */
647         require(_toAddresses.length <= 255);
648         /* Ensures _toAddress and _amounts have the same number of entries. */
649         require(_toAddresses.length == _amounts.length);
650 
651         for (uint8 i = 0; i < _toAddresses.length; i++) {
652             transferFrom(_from, _toAddresses[i], _amounts[i]);
653         }
654     }
655 }
656 
657 /**
658  * @title ERC777 Multi Transfer Contract
659  * @author Panos
660  */
661 contract ERC777Multi is ERC777Helper {
662 
663     /**
664      * @dev Transfer the specified amounts of tokens to the specified addresses as `_from`.
665      * @dev Be aware that there is no check for duplicate recipients.
666      * @param _from Address to use as sender
667      * @param _to Receiver addresses.
668      * @param _amounts Amounts of tokens that will be transferred.
669      * @param _userData User supplied data
670      * @param _operatorData Operator supplied data
671      */
672     function multiOperatorSend(address _from, address[] _to, uint256[] _amounts, bytes _userData, bytes _operatorData)
673     external {
674         /* Ensures _toAddresses array is less than or equal to 255 */
675         require(_to.length <= 255);
676         /* Ensures _toAddress and _amounts have the same number of entries. */
677         require(_to.length == _amounts.length);
678 
679         for (uint8 i = 0; i < _to.length; i++) {
680             operatorSend(_from, _to[i], _amounts[i], _userData, _operatorData);
681         }
682     }
683 
684     /**
685      * @dev Transfer the specified amounts of tokens to the specified addresses.
686      * @dev Be aware that there is no check for duplicate recipients.
687      * @param _toAddresses Receiver addresses.
688      * @param _amounts Amounts of tokens that will be transferred.
689      * @param _userData User supplied data
690      */
691     function multiPartySend(address[] _toAddresses, uint256[] _amounts, bytes _userData) public {
692         /* Ensures _toAddresses array is less than or equal to 255 */
693         require(_toAddresses.length <= 255);
694         /* Ensures _toAddress and _amounts have the same number of entries. */
695         require(_toAddresses.length == _amounts.length);
696 
697         for (uint8 i = 0; i < _toAddresses.length; i++) {
698             doSend(msg.sender, _toAddresses[i], _amounts[i], _userData, msg.sender, "", true);
699         }
700     }
701 
702     /**
703      * @dev Transfer the specified amounts of tokens to the specified addresses.
704      * @dev Be aware that there is no check for duplicate recipients.
705      * @param _toAddresses Receiver addresses.
706      * @param _amounts Amounts of tokens that will be transferred.
707      */
708     function multiPartySend(address[] _toAddresses, uint256[] _amounts) public {
709         /* Ensures _toAddresses array is less than or equal to 255 */
710         require(_toAddresses.length <= 255);
711         /* Ensures _toAddress and _amounts have the same number of entries. */
712         require(_toAddresses.length == _amounts.length);
713 
714         for (uint8 i = 0; i < _toAddresses.length; i++) {
715             doSend(msg.sender, _toAddresses[i], _amounts[i], "", msg.sender, "", true);
716         }
717     }
718 }
719 
720 /**
721  * @title Safe Guard Contract
722  * @author Panos
723  */
724 contract SafeGuard is Owned {
725 
726     event Transaction(address indexed destination, uint value, bytes data);
727 
728     /**
729      * @dev Allows owner to execute a transaction.
730      */
731     function executeTransaction(address destination, uint value, bytes data)
732     public
733     onlyOwner
734     {
735         require(externalCall(destination, value, data.length, data));
736         emit Transaction(destination, value, data);
737     }
738 
739     /**
740      * @dev call has been separated into its own function in order to take advantage
741      *  of the Solidity's code generator to produce a loop that copies tx.data into memory.
742      */
743     function externalCall(address destination, uint value, uint dataLength, bytes data)
744     private
745     returns (bool) {
746         bool result;
747         assembly { // solhint-disable-line no-inline-assembly
748         let x := mload(0x40)   // "Allocate" memory for output
749             // (0x40 is where "free memory" pointer is stored by convention)
750             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
751             result := call(
752             sub(gas, 34710), // 34710 is the value that solidity is currently emitting
753             // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
754             // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
755             destination,
756             value,
757             d,
758             dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
759             x,
760             0                  // Output is ignored, therefore the output size is zero
761             )
762         }
763         return result;
764     }
765 }
766 
767 /**
768  * @title ERC664 Standard Balances Contract
769  * @author chrisfranko
770  */
771 contract ERC664Balances is SafeGuard {
772     using SafeMath for uint256;
773 
774     uint256 public totalSupply;
775 
776     event BalanceAdj(address indexed module, address indexed account, uint amount, string polarity);
777     event ModuleSet(address indexed module, bool indexed set);
778 
779     mapping(address => bool) public modules;
780     mapping(address => uint256) public balances;
781     mapping(address => mapping(address => uint256)) public allowed;
782 
783     modifier onlyModule() {
784         require(modules[msg.sender]);
785         _;
786     }
787 
788     /**
789      * @notice Constructor to create ERC664Balances
790      * @param _initialAmount Database initial amount
791      */
792     constructor(uint256 _initialAmount) public {
793         balances[msg.sender] = _initialAmount;
794         totalSupply = _initialAmount;
795     }
796 
797     /**
798      * @notice Set allowance of `_spender` in behalf of `_sender` at `_value`
799      * @param _sender Owner account
800      * @param _spender Spender account
801      * @param _value Value to approve
802      * @return Operation status
803      */
804     function setApprove(address _sender, address _spender, uint256 _value) external onlyModule returns (bool) {
805         allowed[_sender][_spender] = _value;
806         return true;
807     }
808 
809     /**
810      * @notice Decrease allowance of `_spender` in behalf of `_from` at `_value`
811      * @param _from Owner account
812      * @param _spender Spender account
813      * @param _value Value to decrease
814      * @return Operation status
815      */
816     function decApprove(address _from, address _spender, uint _value) external onlyModule returns (bool) {
817         allowed[_from][_spender] = allowed[_from][_spender].sub(_value);
818         return true;
819     }
820 
821     /**
822     * @notice Increase total supply by `_val`
823     * @param _val Value to increase
824     * @return Operation status
825     */
826     function incTotalSupply(uint _val) external onlyOwner returns (bool) {
827         totalSupply = totalSupply.add(_val);
828         return true;
829     }
830 
831     /**
832      * @notice Decrease total supply by `_val`
833      * @param _val Value to decrease
834      * @return Operation status
835      */
836     function decTotalSupply(uint _val) external onlyOwner returns (bool) {
837         totalSupply = totalSupply.sub(_val);
838         return true;
839     }
840 
841     /**
842      * @notice Set/Unset `_acct` as an authorized module
843      * @param _acct Module address
844      * @param _set Module set status
845      * @return Operation status
846      */
847     function setModule(address _acct, bool _set) external onlyOwner returns (bool) {
848         modules[_acct] = _set;
849         emit ModuleSet(_acct, _set);
850         return true;
851     }
852 
853     /**
854      * @notice Get `_acct` balance
855      * @param _acct Target account to get balance.
856      * @return The account balance
857      */
858     function getBalance(address _acct) external view returns (uint256) {
859         return balances[_acct];
860     }
861 
862     /**
863      * @notice Get allowance of `_spender` in behalf of `_owner`
864      * @param _owner Owner account
865      * @param _spender Spender account
866      * @return Allowance
867      */
868     function getAllowance(address _owner, address _spender) external view returns (uint256) {
869         return allowed[_owner][_spender];
870     }
871 
872     /**
873      * @notice Get if `_acct` is an authorized module
874      * @param _acct Module address
875      * @return Operation status
876      */
877     function getModule(address _acct) external view returns (bool) {
878         return modules[_acct];
879     }
880 
881     /**
882      * @notice Get total supply
883      * @return Total supply
884      */
885     function getTotalSupply() external view returns (uint256) {
886         return totalSupply;
887     }
888 
889     /**
890      * @notice Increment `_acct` balance by `_val`
891      * @param _acct Target account to increment balance.
892      * @param _val Value to increment
893      * @return Operation status
894      */
895     function incBalance(address _acct, uint _val) public onlyModule returns (bool) {
896         balances[_acct] = balances[_acct].add(_val);
897         emit BalanceAdj(msg.sender, _acct, _val, "+");
898         return true;
899     }
900 
901     /**
902      * @notice Decrement `_acct` balance by `_val`
903      * @param _acct Target account to decrement balance.
904      * @param _val Value to decrement
905      * @return Operation status
906      */
907     function decBalance(address _acct, uint _val) public onlyModule returns (bool) {
908         balances[_acct] = balances[_acct].sub(_val);
909         emit BalanceAdj(msg.sender, _acct, _val, "-");
910         return true;
911     }
912 }
913 
914 /**
915  * @title ERC664 Database Contract
916  * @author Panos
917  */
918 contract CStore is ERC664Balances, ERC820Implementer {
919 
920     mapping(address => mapping(address => bool)) private mAuthorized;
921 
922     /**
923      * @notice Database construction
924      * @param _totalSupply The total supply of the token
925      * @param _registry The ERC820 Registry Address
926      */
927     constructor(uint256 _totalSupply, address _registry) public
928     ERC664Balances(_totalSupply)
929     ERC820Implementer(_registry) {
930         setInterfaceImplementation("ERC664Balances", this);
931     }
932 
933     /**
934      * @notice Increase total supply by `_val`
935      * @param _val Value to increase
936      * @return Operation status
937      */
938     // solhint-disable-next-line no-unused-vars
939     function incTotalSupply(uint _val) external onlyOwner returns (bool) {
940         return false;
941     }
942 
943     /**
944      * @notice Decrease total supply by `_val`
945      * @param _val Value to decrease
946      * @return Operation status
947      */
948     // solhint-disable-next-line no-unused-vars
949     function decTotalSupply(uint _val) external onlyOwner returns (bool) {
950         return false;
951     }
952 
953     /**
954      * @notice moving `_amount` from `_from` to `_to`
955      * @param _from The sender address
956      * @param _to The receiving address
957      * @param _amount The moving amount
958      * @return bool The move result
959      */
960     function move(address _from, address _to, uint256 _amount) external
961     onlyModule
962     returns (bool) {
963         balances[_from] = balances[_from].sub(_amount);
964         emit BalanceAdj(msg.sender, _from, _amount, "-");
965         balances[_to] = balances[_to].add(_amount);
966         emit BalanceAdj(msg.sender, _to, _amount, "+");
967         return true;
968     }
969 
970     /**
971      * @notice Setting operator `_operator` for `_tokenHolder`
972      * @param _operator The operator to set status
973      * @param _tokenHolder The token holder to set operator
974      * @param _status The operator status
975      * @return bool Status of operation
976      */
977     function setOperator(address _operator, address _tokenHolder, bool _status) external
978     onlyModule
979     returns (bool) {
980         mAuthorized[_operator][_tokenHolder] = _status;
981         return true;
982     }
983 
984     /**
985      * @notice Getting operator `_operator` for `_tokenHolder`
986      * @param _operator The operator address to get status
987      * @param _tokenHolder The token holder address
988      * @return bool Operator status
989      */
990     function getOperator(address _operator, address _tokenHolder) external
991     view
992     returns (bool) {
993         return mAuthorized[_operator][_tokenHolder];
994     }
995 
996     /**
997      * @notice Increment `_acct` balance by `_val`
998      * @param _acct Target account to increment balance.
999      * @param _val Value to increment
1000      * @return Operation status
1001      */
1002     // solhint-disable-next-line no-unused-vars
1003     function incBalance(address _acct, uint _val) public onlyModule returns (bool) {
1004         return false;
1005     }
1006 
1007     /**
1008      * @notice Decrement `_acct` balance by `_val`
1009      * @param _acct Target account to decrement balance.
1010      * @param _val Value to decrement
1011      * @return Operation status
1012      */
1013     // solhint-disable-next-line no-unused-vars
1014     function decBalance(address _acct, uint _val) public onlyModule returns (bool) {
1015         return false;
1016     }
1017 }
1018 
1019 /**
1020  * @title ERC777 CALL Contract
1021  * @author Panos
1022  */
1023 contract CALL is ERC820Implementer, ERC777StandardToken, ERC20TokenCompat, ERC20Multi, ERC777Multi, SafeGuard {
1024     using SafeMath for uint256;
1025 
1026     CStore public balancesDB;
1027 
1028     /**
1029      * @notice Token construction
1030      * @param _intRegistry The ERC820 Registry Address
1031      * @param _name The name of the token
1032      * @param _symbol The symbol of the token
1033      * @param _totalSupply The total supply of the token
1034      * @param _granularity The granularity of the token
1035      * @param _balancesDB The address of balances database
1036      */
1037     constructor(address _intRegistry, string _name, string _symbol, uint256 _totalSupply,
1038         uint256 _granularity, address _balancesDB) public
1039     ERC820Implementer(_intRegistry)
1040     ERC777StandardToken(_name, _symbol, _totalSupply, _granularity) {
1041         balancesDB = CStore(_balancesDB);
1042         setInterfaceImplementation("ERC777CALLToken", this);
1043     }
1044 
1045     /**
1046      * @notice change the balances database to `_newDB`
1047      * @param _newDB The new balances database address
1048      */
1049     function changeBalancesDB(address _newDB) public onlyOwner {
1050         balancesDB = CStore(_newDB);
1051     }
1052 
1053     /**
1054      * @notice ERC20 backwards compatible transferFrom using backendDB.
1055      * @param _from The address holding the tokens being transferred
1056      * @param _to The address of the recipient
1057      * @param _amount The number of tokens to be transferred
1058      * @return `true`, if the transfer can't be done, it should fail.
1059      */
1060     function transferFrom(address _from, address _to, uint256 _amount) public erc20 returns (bool success) {
1061         uint256 allowance = balancesDB.getAllowance(_from, msg.sender);
1062         require(_amount <= allowance);
1063 
1064         // Cannot be after doSend because of tokensReceived re-entry
1065         require(balancesDB.decApprove(_from, msg.sender, _amount));
1066         doSend(_from, _to, _amount, "", msg.sender, "", false);
1067         return true;
1068     }
1069 
1070     /**
1071      * @notice ERC20 backwards compatible approve.
1072      *  `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
1073      * @param _spender The address of the account able to transfer the tokens
1074      * @param _amount The number of tokens to be approved for transfer
1075      * @return `true`, if the approve can't be done, it should fail.
1076      */
1077     function approve(address _spender, uint256 _amount) public erc20 returns (bool success) {
1078         require(balancesDB.setApprove(msg.sender, _spender, _amount));
1079         emit Approval(msg.sender, _spender, _amount);
1080         return true;
1081     }
1082 
1083     /**
1084      * @notice ERC20 backwards compatible allowance.
1085      *  This function makes it easy to read the `allowed[]` map
1086      * @param _owner The address of the account that owns the token
1087      * @param _spender The address of the account able to transfer the tokens
1088      * @return Amount of remaining tokens of _owner that _spender is allowed
1089      *  to spend
1090      */
1091     function allowance(address _owner, address _spender) public erc20 view returns (uint256 remaining) {
1092         return balancesDB.getAllowance(_owner, _spender);
1093     }
1094 
1095     /**
1096      * @return the total supply of the token
1097      */
1098     function totalSupply() public view returns (uint256) {
1099         return balancesDB.getTotalSupply();
1100     }
1101 
1102     /**
1103      * @notice Return the account balance of some account
1104      * @param _tokenHolder Address for which the balance is returned
1105      * @return the balance of `_tokenAddress`.
1106      */
1107     function balanceOf(address _tokenHolder) public view returns (uint256) {
1108         return balancesDB.getBalance(_tokenHolder);
1109     }
1110 
1111     /**
1112          * @notice Authorize a third party `_operator` to manage (send) `msg.sender`'s tokens at remote database.
1113          * @param _operator The operator that wants to be Authorized
1114          */
1115     function authorizeOperator(address _operator) public {
1116         require(_operator != msg.sender);
1117         require(balancesDB.setOperator(_operator, msg.sender, true));
1118         emit AuthorizedOperator(_operator, msg.sender);
1119     }
1120 
1121     /**
1122      * @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens at remote database.
1123      * @param _operator The operator that wants to be Revoked
1124      */
1125     function revokeOperator(address _operator) public {
1126         require(_operator != msg.sender);
1127         require(balancesDB.setOperator(_operator, msg.sender, false));
1128         emit RevokedOperator(_operator, msg.sender);
1129     }
1130 
1131     /**
1132      * @notice Check whether the `_operator` address is allowed to manage the tokens held by `_tokenHolder`
1133      *  address at remote database.
1134      * @param _operator address to check if it has the right to manage the tokens
1135      * @param _tokenHolder address which holds the tokens to be managed
1136      * @return `true` if `_operator` is authorized for `_tokenHolder`
1137      */
1138     function isOperatorFor(address _operator, address _tokenHolder) public view returns (bool) {
1139         return _operator == _tokenHolder || balancesDB.getOperator(_operator, _tokenHolder);
1140     }
1141 
1142     /**
1143      * @notice Helper function actually performing the sending of tokens using a backend database.
1144      * @param _from The address holding the tokens being sent
1145      * @param _to The address of the recipient
1146      * @param _amount The number of tokens to be sent
1147      * @param _userData Data generated by the user to be passed to the recipient
1148      * @param _operatorData Data generated by the operator to be passed to the recipient
1149      * @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
1150      *  implementing `erc777_tokenHolder`.
1151      *  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
1152      *  functions SHOULD set this parameter to `false`.
1153      */
1154     function doSend(
1155         address _from,
1156         address _to,
1157         uint256 _amount,
1158         bytes _userData,
1159         address _operator,
1160         bytes _operatorData,
1161         bool _preventLocking
1162     )
1163     internal
1164     {
1165         requireMultiple(_amount);
1166 
1167         callSender(_operator, _from, _to, _amount, _userData, _operatorData);
1168 
1169         require(_to != address(0));          // forbid sending to 0x0 (=burning)
1170         // require(mBalances[_from] >= _amount); // ensure enough funds
1171         // (Not Required due to SafeMath throw if underflow in database and false check)
1172 
1173         require(balancesDB.move(_from, _to, _amount));
1174 
1175         callRecipient(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
1176 
1177         emit Sent(_operator, _from, _to, _amount, _userData, _operatorData);
1178         if (mErc20compatible) { emit Transfer(_from, _to, _amount); }
1179     }
1180 }