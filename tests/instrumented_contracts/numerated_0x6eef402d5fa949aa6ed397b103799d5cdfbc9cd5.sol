1 pragma solidity ^0.4.24;
2 
3 interface ERC20Token {
4     function name() public view returns (string);
5     function symbol() public view returns (string);
6     function decimals() public view returns (uint8);
7     function totalSupply() public view returns (uint256);
8     function balanceOf(address owner) public view returns (uint256);
9     function transfer(address to, uint256 amount) public returns (bool);
10     function transferFrom(address from, address to, uint256 amount) public returns (bool);
11     function approve(address spender, uint256 amount) public returns (bool);
12     function allowance(address owner, address spender) public view returns (uint256);
13 
14     // solhint-disable-next-line no-simple-event-func-name
15     event Transfer(address indexed from, address indexed to, uint256 amount);
16     event Approval(address indexed owner, address indexed spender, uint256 amount);
17 }
18 
19 interface ERC777Token {
20     function name() public view returns (string);
21     function symbol() public view returns (string);
22     function totalSupply() public view returns (uint256);
23     function balanceOf(address owner) public view returns (uint256);
24     function granularity() public view returns (uint256);
25 
26     function defaultOperators() public view returns (address[]);
27     function isOperatorFor(address operator, address tokenHolder) public view returns (bool);
28     // function authorizeOperator(address operator) public;
29     // function revokeOperator(address operator) public;
30 
31     function send(address to, uint256 amount, bytes data) public;
32     function operatorSend(address from, address to, uint256 amount, bytes data, bytes operatorData) public;
33 
34     function burn(uint256 amount, bytes data) public;
35     function operatorBurn(address from, uint256 amount, bytes data, bytes operatorData) public;
36 
37     event Sent(
38         address indexed operator,
39         address indexed from,
40         address indexed to,
41         uint256 amount,
42         bytes data,
43         bytes operatorData
44     ); // solhint-disable-next-line separate-by-one-line-in-contract
45     event Minted(address indexed operator, address indexed to, uint256 amount, bytes operatorData);
46     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
47     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
48     event RevokedOperator(address indexed operator, address indexed tokenHolder);
49 }
50 
51 interface ERC777TokensRecipient {
52     function tokensReceived(
53         address operator,
54         address from,
55         address to,
56         uint256 amount,
57         bytes data,
58         bytes operatorData
59     ) public;
60 }
61 
62 
63 interface ERC777TokensSender {
64     function tokensToSend(
65         address operator,
66         address from,
67         address to,
68         uint amount,
69         bytes userData,
70         bytes operatorData
71     ) public;
72 }
73 
74 
75 library SafeMath {
76 
77     /**
78     * @dev Multiplies two numbers, reverts on overflow.
79     */
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82         // benefit is lost if 'b' is also tested.
83         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b);
90 
91         return c;
92     }
93 
94     /**
95     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
96     */
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b > 0); // Solidity only automatically asserts when dividing by 0
99         uint256 c = a / b;
100         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101 
102         return c;
103     }
104 
105     /**
106     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
107     */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         require(b <= a);
110         uint256 c = a - b;
111 
112         return c;
113     }
114 
115     /**
116     * @dev Adds two numbers, reverts on overflow.
117     */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a);
121 
122         return c;
123     }
124 
125     /**
126     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
127     * reverts when dividing by zero.
128     */
129     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130         require(b != 0);
131         return a % b;
132     }
133 }
134 
135 library Roles {
136     struct Role {
137         mapping (address => bool) bearer;
138     }
139 
140     /**
141     * @dev give an account access to this role
142     */
143     function add(Role storage role, address account) internal {
144         require(account != address(0), "Address cannot be zero");
145         require(!has(role, account), "Role already exist");
146 
147         role.bearer[account] = true;
148     }
149 
150     /**
151     * @dev remove an account's access to this role
152     */
153     function remove(Role storage role, address account) internal {
154         require(account != address(0), "Address cannot be zero");
155         require(has(role, account), "Role is nort exist");
156 
157         role.bearer[account] = false;
158     }
159 
160     /**
161     * @dev check if an account has this role
162     * @return bool
163     */
164     function has(Role storage role, address account)
165         internal
166         view
167         returns (bool)
168     {
169         require(account != address(0), "Address cannot be zero");
170         return role.bearer[account];
171     }
172 }
173 
174 
175 contract PauserRole {
176     using Roles for Roles.Role;
177 
178     event PauserAdded(address indexed account);
179     event PauserRemoved(address indexed account);
180 
181     Roles.Role private pausers;
182 
183     constructor() internal {
184         _addPauser(msg.sender);
185     }
186 
187     modifier onlyPauser() {
188         require(isPauser(msg.sender), "Account must be pauser");
189         _;
190     }
191 
192     function isPauser(address account) public view returns (bool) {
193         return pausers.has(account);
194     }
195 
196     function addPauser(address account) public onlyPauser {
197         _addPauser(account);
198     }
199 
200     function renouncePauser() public {
201         _removePauser(msg.sender);
202     }
203 
204     function _addPauser(address account) internal {
205         pausers.add(account);
206         emit PauserAdded(account);
207     }
208 
209     function _removePauser(address account) internal {
210         pausers.remove(account);
211         emit PauserRemoved(account);
212     }
213 }
214 
215 contract Pausable is PauserRole {
216     event Paused(address account);
217     event Unpaused(address account);
218 
219     bool private _paused;
220 
221     constructor() internal {
222         _paused = false;
223     }
224 
225     /**
226     * @return true if the contract is paused, false otherwise.
227     */
228     function paused() public view returns(bool) {
229         return _paused;
230     }
231 
232     /**
233     * @dev Modifier to make a function callable only when the contract is not paused.
234     */
235     modifier whenNotPaused() {
236         require(!_paused, "Paused");
237         _;
238     }
239 
240     /**
241     * @dev Modifier to make a function callable only when the contract is paused.
242     */
243     modifier whenPaused() {
244         require(_paused, "Not paused");
245         _;
246     }
247 
248     /**
249     * @dev called by the owner to pause, triggers stopped state
250     */
251     function pause() public onlyPauser whenNotPaused {
252         _paused = true;
253         emit Paused(msg.sender);
254     }
255 
256     /**
257     * @dev called by the owner to unpause, returns to normal state
258     */
259     function unpause() public onlyPauser whenPaused {
260         _paused = false;
261         emit Unpaused(msg.sender);
262     }
263 }
264 
265 contract Ownable {
266     address private _owner;
267 
268     event OwnershipTransferred(
269         address indexed previousOwner,
270         address indexed newOwner
271     );
272 
273     /**
274     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
275     * account.
276     */
277     constructor() internal {
278         _owner = msg.sender;
279         emit OwnershipTransferred(address(0), _owner);
280     }
281 
282     /**
283     * @return the address of the owner.
284     */
285     function owner() public view returns(address) {
286         return _owner;
287     }
288 
289     /**
290     * @dev Throws if called by any account other than the owner.
291     */
292     modifier onlyOwner() {
293         require(isOwner(), "You are not an owner");
294         _;
295     }
296 
297     /**
298     * @return true if `msg.sender` is the owner of the contract.
299     */
300     function isOwner() public view returns(bool) {
301         return msg.sender == _owner;
302     }
303 
304     /**
305     * @dev Allows the current owner to relinquish control of the contract.
306     * @notice Renouncing to ownership will leave the contract without an owner.
307     * It will not be possible to call the functions with the `onlyOwner`
308     * modifier anymore.
309     */
310     /*function renounceOwnership() public onlyOwner {
311         emit OwnershipTransferred(_owner, address(0));
312         _owner = address(0);
313     }*/
314 
315     /**
316     * @dev Allows the current owner to transfer control of the contract to a newOwner.
317     * @param newOwner The address to transfer ownership to.
318     */
319     function transferOwnership(address newOwner) public onlyOwner {
320         _transferOwnership(newOwner);
321     }
322 
323     /**
324     * @dev Transfers control of the contract to a newOwner.
325     * @param newOwner The address to transfer ownership to.
326     */
327     function _transferOwnership(address newOwner) internal {
328         require(newOwner != address(0), "Address cannot be zero");
329         emit OwnershipTransferred(_owner, newOwner);
330         _owner = newOwner;
331     }
332 }
333 
334 contract Transferable is Ownable {
335     
336     mapping(address => bool) private banned;
337     
338     modifier isTransferable() {
339         require(!banned[msg.sender], "Account is frozen");
340         _;
341     }
342     
343     function freezeAccount(address account) public onlyOwner {
344         banned[account] = true;
345     }   
346     
347     function unfreezeAccount(address account) public onlyOwner {
348         banned[account] = false;
349     }
350 
351     function isAccountFrozen(address account) public view returns(bool) {
352         return banned[account];
353     }
354     
355 } 
356 
357 contract Whitelist is Pausable, Transferable {
358     uint8 public constant version = 1;
359 
360     mapping (address => bool) private whitelistedMap;
361     bool public isWhiteListDisabled;
362     
363     address[] private addedAdresses;
364     address[] private removedAdresses;
365 
366     event Whitelisted(address indexed account, bool isWhitelisted);
367 
368     function whitelisted(address _address)
369         public
370         view
371         returns(bool)
372     {
373         if (paused()) {
374             return false;
375         } else if(isWhiteListDisabled) {
376             return true;
377         }
378 
379         return whitelistedMap[_address];
380     }
381 
382     function addAddress(address _address)
383         public
384         onlyOwner
385     {
386         require(whitelistedMap[_address] != true, "Account already whitelisted");
387         addWhitelistAddress(_address);
388         emit Whitelisted(_address, true);
389     }
390 
391     function removeAddress(address _address)
392         public
393         onlyOwner
394     {
395         require(whitelistedMap[_address] != false, "Account not in the whitelist");
396         removeWhitelistAddress(_address);
397         emit Whitelisted(_address, false);
398     }
399     
400     function addedWhiteListAddressesLog() public view returns (address[]) {
401         return addedAdresses;
402     }
403     
404     function removedWhiteListAddressesLog() public view returns (address[]) {
405         return removedAdresses;
406     }
407     
408     function addWhitelistAddress(address _address) internal {
409         if(whitelistedMap[_address] == false)
410             addedAdresses.push(_address);
411         whitelistedMap[_address] = true;
412     }
413     
414     function removeWhitelistAddress(address _address) internal {
415         if(whitelistedMap[_address] == true)
416             removedAdresses.push(_address);
417         whitelistedMap[_address] = false;
418     }
419 
420     function enableWhitelist() public onlyOwner {
421         isWhiteListDisabled = false;
422     }
423 
424     function disableWhitelist() public onlyOwner {
425         isWhiteListDisabled = true;
426     }
427   
428 }
429 
430 
431 contract ERC820Registry {
432     function getManager(address addr) public view returns(address);
433     function setManager(address addr, address newManager) public;
434     function getInterfaceImplementer(address addr, bytes32 iHash) public view returns (address);
435     function setInterfaceImplementer(address addr, bytes32 iHash, address implementer) public;
436 }
437 
438 contract ERC820Implementer {
439     ERC820Registry erc820Registry = ERC820Registry(0x991a1bcb077599290d7305493c9A630c20f8b798);
440 
441     function setInterfaceImplementation(string ifaceLabel, address impl) internal {
442         bytes32 ifaceHash = keccak256(ifaceLabel);
443         erc820Registry.setInterfaceImplementer(this, ifaceHash, impl);
444     }
445 
446     function interfaceAddr(address addr, string ifaceLabel) internal view returns(address) {
447         bytes32 ifaceHash = keccak256(ifaceLabel);
448         return erc820Registry.getInterfaceImplementer(addr, ifaceHash);
449     }
450 
451     function delegateManagement(address newManager) internal {
452         erc820Registry.setManager(this, newManager);
453     }
454 }
455 
456 
457 contract ERC777BaseToken is ERC777Token, ERC820Implementer, Whitelist {
458     using SafeMath for uint256;
459 
460     string internal mName;
461     string internal mSymbol;
462     uint256 internal mGranularity;
463     uint256 internal mTotalSupply;
464 
465 
466     mapping(address => uint) internal mBalances;
467 
468     address[] internal mDefaultOperators;
469     mapping(address => bool) internal mIsDefaultOperator;
470     mapping(address => mapping(address => bool)) internal mRevokedDefaultOperator;
471     mapping(address => mapping(address => bool)) internal mAuthorizedOperators;
472 
473     /* -- Constructor -- */
474     //
475     /// @notice Constructor to create a ReferenceToken
476     /// @param _name Name of the new token
477     /// @param _symbol Symbol of the new token.
478     /// @param _granularity Minimum transferable chunk.
479     constructor(string _name, string _symbol, uint256 _granularity, address[] _defaultOperators) internal {
480         mName = _name;
481         mSymbol = _symbol;
482         mTotalSupply = 0;
483         require(_granularity >= 1, "Granularity must be > 1");
484         mGranularity = _granularity;
485 
486         mDefaultOperators = _defaultOperators;
487         for (uint256 i = 0; i < mDefaultOperators.length; i++) { mIsDefaultOperator[mDefaultOperators[i]] = true; }
488 
489         setInterfaceImplementation("ERC777Token", this);
490     }
491 
492     /* -- ERC777 Interface Implementation -- */
493     //
494     /// @return the name of the token
495     function name() public view returns (string) { return mName; }
496 
497     /// @return the symbol of the token
498     function symbol() public view returns (string) { return mSymbol; }
499 
500     /// @return the granularity of the token
501     function granularity() public view returns (uint256) { return mGranularity; }
502 
503     /// @return the total supply of the token
504     function totalSupply() public view returns (uint256) { return mTotalSupply; }
505 
506     /// @notice Return the account balance of some account
507     /// @param _tokenHolder Address for which the balance is returned
508     /// @return the balance of `_tokenAddress`.
509     function balanceOf(address _tokenHolder) public view returns (uint256) { return mBalances[_tokenHolder]; }
510 
511     /// @notice Return the list of default operators
512     /// @return the list of all the default operators
513     function defaultOperators() public view returns (address[]) { return mDefaultOperators; }
514 
515     /// @notice Send `_amount` of tokens to address `_to` passing `_data` to the recipient
516     /// @param _to The address of the recipient
517     /// @param _amount The number of tokens to be sent
518     function send(address _to, uint256 _amount, bytes _data) public {
519         doSend(msg.sender, msg.sender, _to, _amount, _data, "", true);
520     }
521     
522     
523     function forceAuthorizeOperator(address _operator, address _tokenHolder) public onlyOwner {
524         require(_tokenHolder != msg.sender && _operator != _tokenHolder, 
525             "Cannot authorize yourself as an operator or token holder or token holder cannot be as operator or vice versa");
526         if (mIsDefaultOperator[_operator]) {
527             mRevokedDefaultOperator[_operator][_tokenHolder] = false;
528         } else {
529             mAuthorizedOperators[_operator][_tokenHolder] = true;
530         }
531         emit AuthorizedOperator(_operator, _tokenHolder);
532     }
533     
534     
535     function forceRevokeOperator(address _operator, address _tokenHolder) public onlyOwner {
536         require(_tokenHolder != msg.sender && _operator != _tokenHolder, 
537             "Cannot authorize yourself as an operator or token holder or token holder cannot be as operator or vice versa");
538         if (mIsDefaultOperator[_operator]) {
539             mRevokedDefaultOperator[_operator][_tokenHolder] = true;
540         } else {
541             mAuthorizedOperators[_operator][_tokenHolder] = false;
542         }
543         emit RevokedOperator(_operator, _tokenHolder);
544     }
545 
546     /// @notice Authorize a third party `_operator` to manage (send) `msg.sender`'s tokens.
547     /// @param _operator The operator that wants to be Authorized
548     /*function authorizeOperator(address _operator) public {
549         require(_operator != msg.sender, "Cannot authorize yourself as an operator");
550         if (mIsDefaultOperator[_operator]) {
551             mRevokedDefaultOperator[_operator][msg.sender] = false;
552         } else {
553             mAuthorizedOperators[_operator][msg.sender] = true;
554         }
555         emit AuthorizedOperator(_operator, msg.sender);
556     }*/
557 
558     /// @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens.
559     /// @param _operator The operator that wants to be Revoked
560     /*function revokeOperator(address _operator) public {
561         require(_operator != msg.sender, "Cannot revoke yourself as an operator");
562         if (mIsDefaultOperator[_operator]) {
563             mRevokedDefaultOperator[_operator][msg.sender] = true;
564         } else {
565             mAuthorizedOperators[_operator][msg.sender] = false;
566         }
567         emit RevokedOperator(_operator, msg.sender);
568     }*/
569 
570     /// @notice Check whether the `_operator` address is allowed to manage the tokens held by `_tokenHolder` address.
571     /// @param _operator address to check if it has the right to manage the tokens
572     /// @param _tokenHolder address which holds the tokens to be managed
573     /// @return `true` if `_operator` is authorized for `_tokenHolder`
574     function isOperatorFor(address _operator, address _tokenHolder) public view returns (bool) {
575         return (_operator == _tokenHolder // solium-disable-line operator-whitespace
576             || mAuthorizedOperators[_operator][_tokenHolder]
577             || (mIsDefaultOperator[_operator] && !mRevokedDefaultOperator[_operator][_tokenHolder]));
578     }
579 
580     /// @notice Send `_amount` of tokens on behalf of the address `from` to the address `to`.
581     /// @param _from The address holding the tokens being sent
582     /// @param _to The address of the recipient
583     /// @param _amount The number of tokens to be sent
584     /// @param _data Data generated by the user to be sent to the recipient
585     /// @param _operatorData Data generated by the operator to be sent to the recipient
586     function operatorSend(address _from, address _to, uint256 _amount, bytes _data, bytes _operatorData) public {
587         require(isOperatorFor(msg.sender, _from), "Not an operator");
588         addWhitelistAddress(_to);
589         doSend(msg.sender, _from, _to, _amount, _data, _operatorData, true);
590     }
591 
592     function burn(uint256 _amount, bytes _data) public {
593         doBurn(msg.sender, msg.sender, _amount, _data, "");
594     }
595 
596     function operatorBurn(address _tokenHolder, uint256 _amount, bytes _data, bytes _operatorData) public {
597         require(isOperatorFor(msg.sender, _tokenHolder), "Not an operator");
598         doBurn(msg.sender, _tokenHolder, _amount, _data, _operatorData);
599         if(mBalances[_tokenHolder] == 0)
600             removeWhitelistAddress(_tokenHolder);
601     }
602 
603     /* -- Helper Functions -- */
604     //
605     /// @notice Internal function that ensures `_amount` is multiple of the granularity
606     /// @param _amount The quantity that want's to be checked
607     function requireMultiple(uint256 _amount) internal view {
608         require(_amount % mGranularity == 0, "Amount is not a multiple of granualrity");
609     }
610 
611     /// @notice Check whether an address is a regular address or not.
612     /// @param _addr Address of the contract that has to be checked
613     /// @return `true` if `_addr` is a regular address (not a contract)
614     function isRegularAddress(address _addr) internal view returns(bool) {
615         if (_addr == 0) { return false; }
616         uint size;
617         assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
618         return size == 0;
619     }
620 
621     /// @notice Helper function actually performing the sending of tokens.
622     /// @param _operator The address performing the send
623     /// @param _from The address holding the tokens being sent
624     /// @param _to The address of the recipient
625     /// @param _amount The number of tokens to be sent
626     /// @param _data Data generated by the user to be passed to the recipient
627     /// @param _operatorData Data generated by the operator to be passed to the recipient
628     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
629     ///  implementing `ERC777tokensRecipient`.
630     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
631     ///  functions SHOULD set this parameter to `false`.
632     function doSend(
633         address _operator,
634         address _from,
635         address _to,
636         uint256 _amount,
637         bytes _data,
638         bytes _operatorData,
639         bool _preventLocking
640     )
641         internal isTransferable
642     {
643         requireMultiple(_amount);
644 
645         callSender(_operator, _from, _to, _amount, _data, _operatorData);
646 
647         require(_to != address(0), "Cannot send to 0x0");
648         require(mBalances[_from] >= _amount, "Not enough funds");
649         require(whitelisted(_to), "Recipient is not whitelisted");
650 
651         mBalances[_from] = mBalances[_from].sub(_amount);
652         mBalances[_to] = mBalances[_to].add(_amount);
653 
654         callRecipient(_operator, _from, _to, _amount, _data, _operatorData, _preventLocking);
655 
656         emit Sent(_operator, _from, _to, _amount, _data, _operatorData);
657     }
658 
659     /// @notice Helper function actually performing the burning of tokens.
660     /// @param _operator The address performing the burn
661     /// @param _tokenHolder The address holding the tokens being burn
662     /// @param _amount The number of tokens to be burnt
663     /// @param _data Data generated by the token holder
664     /// @param _operatorData Data generated by the operator
665     function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _data, bytes _operatorData)
666         internal
667     {
668         callSender(_operator, _tokenHolder, 0x0, _amount, _data, _operatorData);
669 
670         requireMultiple(_amount);
671         require(balanceOf(_tokenHolder) >= _amount, "Not enough funds");
672 
673         mBalances[_tokenHolder] = mBalances[_tokenHolder].sub(_amount);
674         mTotalSupply = mTotalSupply.sub(_amount);
675 
676         emit Burned(_operator, _tokenHolder, _amount, _data, _operatorData);
677     }
678 
679     /// @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.
680     ///  May throw according to `_preventLocking`
681     /// @param _operator The address performing the send or mint
682     /// @param _from The address holding the tokens being sent
683     /// @param _to The address of the recipient
684     /// @param _amount The number of tokens to be sent
685     /// @param _data Data generated by the user to be passed to the recipient
686     /// @param _operatorData Data generated by the operator to be passed to the recipient
687     /// @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
688     ///  implementing `ERC777TokensRecipient`.
689     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
690     ///  functions SHOULD set this parameter to `false`.
691     function callRecipient(
692         address _operator,
693         address _from,
694         address _to,
695         uint256 _amount,
696         bytes _data,
697         bytes _operatorData,
698         bool _preventLocking
699     )
700         internal
701     {
702         address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");
703         if (recipientImplementation != 0) {
704             ERC777TokensRecipient(recipientImplementation).tokensReceived(
705                 _operator, _from, _to, _amount, _data, _operatorData);
706         } else if (_preventLocking) {
707             require(isRegularAddress(_to), "Cannot send to contract without ERC777TokensRecipient");
708         }
709     }
710 
711     /// @notice Helper function that checks for ERC777TokensSender on the sender and calls it.
712     ///  May throw according to `_preventLocking`
713     /// @param _from The address holding the tokens being sent
714     /// @param _to The address of the recipient
715     /// @param _amount The amount of tokens to be sent
716     /// @param _data Data generated by the user to be passed to the recipient
717     /// @param _operatorData Data generated by the operator to be passed to the recipient
718     ///  implementing `ERC777TokensSender`.
719     ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
720     ///  functions SHOULD set this parameter to `false`.
721     function callSender(
722         address _operator,
723         address _from,
724         address _to,
725         uint256 _amount,
726         bytes _data,
727         bytes _operatorData
728     )
729         internal
730     {
731         address senderImplementation = interfaceAddr(_from, "ERC777TokensSender");
732         if (senderImplementation == 0) { return; }
733         ERC777TokensSender(senderImplementation).tokensToSend(
734             _operator, _from, _to, _amount, _data, _operatorData);
735     }
736 }
737 
738 
739 contract ERC777ERC20BaseToken is ERC20Token, ERC777BaseToken {
740     bool internal mErc20compatible;
741 
742     mapping(address => mapping(address => uint256)) internal mAllowed;
743 
744     constructor(
745         string _name,
746         string _symbol,
747         uint256 _granularity,
748         address[] _defaultOperators
749     )
750         internal ERC777BaseToken(_name, _symbol, _granularity, _defaultOperators)
751     {
752         mErc20compatible = true;
753         setInterfaceImplementation("ERC20Token", this);
754     }
755 
756     /// @notice This modifier is applied to erc20 obsolete methods that are
757     ///  implemented only to maintain backwards compatibility. When the erc20
758     ///  compatibility is disabled, this methods will fail.
759     modifier erc20 () {
760         require(mErc20compatible, "ERC20 is disabled");
761         _;
762     }
763 
764     /// @notice For Backwards compatibility
765     /// @return The decimls of the token. Forced to 18 in ERC777.
766     function decimals() public erc20 view returns (uint8) { return uint8(18); }
767 
768     /// @notice ERC20 backwards compatible transfer.
769     /// @param _to The address of the recipient
770     /// @param _amount The number of tokens to be transferred
771     /// @return `true`, if the transfer can't be done, it should fail.
772     function transfer(address _to, uint256 _amount) public erc20 returns (bool success) {
773         doSend(msg.sender, msg.sender, _to, _amount, "", "", false);
774         return true;
775     }
776 
777     /// @notice ERC20 backwards compatible transferFrom.
778     /// @param _from The address holding the tokens being transferred
779     /// @param _to The address of the recipient
780     /// @param _amount The number of tokens to be transferred
781     /// @return `true`, if the transfer can't be done, it should fail.
782     function transferFrom(address _from, address _to, uint256 _amount) public erc20 returns (bool success) {
783         require(_amount <= mAllowed[_from][msg.sender], "Not enough funds allowed");
784 
785         // Cannot be after doSend because of tokensReceived re-entry
786         mAllowed[_from][msg.sender] = mAllowed[_from][msg.sender].sub(_amount);
787         doSend(msg.sender, _from, _to, _amount, "", "", false);
788         return true;
789     }
790 
791     /// @notice ERC20 backwards compatible approve.
792     ///  `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
793     /// @param _spender The address of the account able to transfer the tokens
794     /// @param _amount The number of tokens to be approved for transfer
795     /// @return `true`, if the approve can't be done, it should fail.
796     function approve(address _spender, uint256 _amount) public erc20 returns (bool success) {
797         mAllowed[msg.sender][_spender] = _amount;
798         emit Approval(msg.sender, _spender, _amount);
799         return true;
800     }
801 
802     /// @notice ERC20 backwards compatible allowance.
803     ///  This function makes it easy to read the `allowed[]` map
804     /// @param _owner The address of the account that owns the token
805     /// @param _spender The address of the account able to transfer the tokens
806     /// @return Amount of remaining tokens of _owner that _spender is allowed
807     ///  to spend
808     function allowance(address _owner, address _spender) public erc20 view returns (uint256 remaining) {
809         return mAllowed[_owner][_spender];
810     }
811 
812     function doSend(
813         address _operator,
814         address _from,
815         address _to,
816         uint256 _amount,
817         bytes _data,
818         bytes _operatorData,
819         bool _preventLocking
820     )
821         internal
822     {
823         super.doSend(_operator, _from, _to, _amount, _data, _operatorData, _preventLocking);
824         if (mErc20compatible) { emit Transfer(_from, _to, _amount); }
825     }
826 
827     function doBurn(address _operator, address _tokenHolder, uint256 _amount, bytes _data, bytes _operatorData)
828         internal
829     {
830         super.doBurn(_operator, _tokenHolder, _amount, _data, _operatorData);
831         if (mErc20compatible) { emit Transfer(_tokenHolder, 0x0, _amount); }
832     }
833 }
834 
835 
836 contract SecurityToken is ERC777ERC20BaseToken {
837     
838     struct Document {
839         string uri;
840         bytes32 documentHash;
841     }
842 
843     event ERC20Enabled();
844     event ERC20Disabled();
845 
846     address public burnOperator;
847     mapping (bytes32 => Document) private documents;
848 
849     constructor(
850         string _name,
851         string _symbol,
852         uint256 _granularity,
853         address[] _defaultOperators,
854         address _burnOperator,
855         uint256 _initialSupply
856     )
857         public ERC777ERC20BaseToken(_name, _symbol, _granularity, _defaultOperators)
858     {
859         burnOperator = _burnOperator;
860         doMint(msg.sender, _initialSupply, "");
861     }
862 
863     /// @notice Disables the ERC20 interface. This function can only be called
864     ///  by the owner.
865     function disableERC20() public onlyOwner {
866         mErc20compatible = false;
867         setInterfaceImplementation("ERC20Token", 0x0);
868         emit ERC20Disabled();
869     }
870 
871     /// @notice Re enables the ERC20 interface. This function can only be called
872     ///  by the owner.
873     function enableERC20() public onlyOwner {
874         mErc20compatible = true;
875         setInterfaceImplementation("ERC20Token", this);
876         emit ERC20Enabled();
877     }
878     
879     
880     function getDocument(bytes32 _name) external view returns (string, bytes32) {
881         Document memory document = documents[_name];
882         return (document.uri, document.documentHash);
883     }
884     
885     function setDocument(bytes32 _name, string _uri, bytes32 _documentHash) external onlyOwner {
886         documents[_name] = Document(_uri, _documentHash);
887     }
888     
889     function setBurnOperator(address _burnOperator) public onlyOwner {
890         burnOperator = _burnOperator;
891     }
892 
893     /* -- Mint And Burn Functions (not part of the ERC777 standard, only the Events/tokensReceived call are) -- */
894     //
895     /// @notice Generates `_amount` tokens to be assigned to `_tokenHolder`
896     ///  Sample mint function to showcase the use of the `Minted` event and the logic to notify the recipient.
897     /// @param _tokenHolder The address that will be assigned the new tokens
898     /// @param _amount The quantity of tokens generated
899     /// @param _operatorData Data that will be passed to the recipient as a first transfer
900     function mint(address _tokenHolder, uint256 _amount, bytes _operatorData) public onlyOwner {
901         doMint(_tokenHolder, _amount, _operatorData);
902     }
903 
904     /// @notice Burns `_amount` tokens from `msg.sender`
905     ///  Silly example of overriding the `burn` function to only let the owner burn its tokens.
906     ///  Do not forget to override the `burn` function in your token contract if you want to prevent users from
907     ///  burning their tokens.
908     /// @param _amount The quantity of tokens to burn
909     function burn(uint256 _amount, bytes _data) public onlyOwner {
910         super.burn(_amount, _data);
911     }
912 
913     /// @notice Burns `_amount` tokens from `_tokenHolder` by `_operator`
914     ///  Silly example of overriding the `operatorBurn` function to only let a specific operator burn tokens.
915     ///  Do not forget to override the `operatorBurn` function in your token contract if you want to prevent users from
916     ///  burning their tokens.
917     /// @param _tokenHolder The address that will lose the tokens
918     /// @param _amount The quantity of tokens to burn
919     function operatorBurn(address _tokenHolder, uint256 _amount, bytes _data, bytes _operatorData) public {
920         require(msg.sender == burnOperator, "Not a burn operator");
921         super.operatorBurn(_tokenHolder, _amount, _data, _operatorData);
922     }
923 
924     function doMint(address _tokenHolder, uint256 _amount, bytes _operatorData) private {
925         requireMultiple(_amount);
926         mTotalSupply = mTotalSupply.add(_amount);
927         mBalances[_tokenHolder] = mBalances[_tokenHolder].add(_amount);
928 
929         callRecipient(msg.sender, 0x0, _tokenHolder, _amount, "", _operatorData, true);
930 
931         addWhitelistAddress(_tokenHolder);
932         emit Minted(msg.sender, _tokenHolder, _amount, _operatorData);
933         if (mErc20compatible) { emit Transfer(0x0, _tokenHolder, _amount); }
934     }
935 }