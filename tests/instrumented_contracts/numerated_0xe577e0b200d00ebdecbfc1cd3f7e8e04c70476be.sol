1 pragma solidity 0.5.7;
2 
3 /*
4 *  xEuro.sol
5 *  xEUR tokens smart contract
6 *  implements [ERC-20 Token Standard](https://eips.ethereum.org/EIPS/eip-20)
7 *  ver. 1.0.7
8 *  2019-04-29
9 *  https://xeuro.online
10 *  address: https://etherscan.io/address/0xe577e0B200d00eBdecbFc1cd3F7E8E04C70476BE 
11 *  deployed on block: 7660532
12 *  solc version : 0.5.7+commit.6da8b019
13 **/
14 
15 /**
16  * @title SafeMath
17  * @dev Unsigned math operations with safety checks that revert on error
18  */
19 library SafeMath {
20     /**
21      * @dev Multiplies two unsigned integers, reverts on overflow.
22      */
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
25         // benefit is lost if 'b' is also tested.
26         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
27         if (a == 0) {
28             return 0;
29         }
30         uint256 c = a * b;
31         require(c / a == b);
32         return c;
33     }
34 
35     /**
36      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
37      */
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         // Solidity only automatically asserts when dividing by 0
40         require(b > 0);
41         uint256 c = a / b;
42         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43         return c;
44     }
45 
46     /**
47      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
48      */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         require(b <= a);
51         uint256 c = a - b;
52         return c;
53     }
54 
55     /**
56      * @dev Adds two unsigned integers, reverts on overflow.
57      */
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a);
61         return c;
62     }
63 
64     /**
65      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
66      * reverts when dividing by zero.
67      */
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b != 0);
70         return a % b;
71     }
72 }
73 
74 /**
75 * ERC-677
76 * see: https://github.com/ethereum/EIPs/issues/677
77 * Allow tokens to be transferred to contracts and have the contract trigger logic for how to respond to receiving
78 * the tokens within a single transaction.
79 */
80 contract TokenRecipient {
81 
82     function onTokenTransfer(address _from, uint256 _value, bytes calldata _extraData) external returns (bool);
83     // function tokenFallback(address _from, uint256 _value, bytes calldata _extraData) external returns (bool);
84 
85 }
86 
87 /**
88 * see: https://www.cryptonomica.net/#!/verifyEthAddress/
89 * in our smart contract every new admin should have a verified identity on cryptonomica.net
90 */
91 contract CryptonomicaVerification {
92 
93     // returns 0 if verification is not revoked
94     function revokedOn(address _address) external view returns (uint unixTime);
95 
96     function keyCertificateValidUntil(address _address) external view returns (uint unixTime);
97 
98 }
99 
100 contract xEuro {
101 
102     /**
103     * see: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
104     */
105     using SafeMath for uint256;
106 
107     CryptonomicaVerification public cryptonomicaVerification;
108 
109     /* --- ERC-20 variables ----- */
110 
111     /**
112     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#name
113     * function name() constant returns (string name)
114     */
115     string public constant name = "xEuro";
116 
117     /**
118     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#symbol
119     * function symbol() constant returns (string symbol)
120     */
121     string public constant symbol = "xEUR";
122 
123     /**
124     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#decimals
125     * function decimals() constant returns (uint8 decimals)
126     */
127     uint8 public constant decimals = 0; // 1 token = €1, no smaller unit
128 
129     /**
130     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#totalsupply
131     * function totalSupply() constant returns (uint256 totalSupply)
132     * we start with zero
133     */
134     uint256 public totalSupply = 0;
135 
136     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#balanceof
137     // function balanceOf(address _owner) constant returns (uint256 balance)
138     mapping(address => uint256) public balanceOf;
139 
140     /**
141     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#allowance
142     * function allowance(address _owner, address _spender) constant returns (uint256 remaining)
143     */
144     mapping(address => mapping(address => uint256)) public allowance;
145 
146     /* --- administrative variables */
147 
148     /**
149     * addresses that are admins in this smart contracts
150     * admin can assign and revoke authority to perform functions (mint, burn, transfer) in this contract
151     * for other addresses and for himself
152     */
153     mapping(address => bool) public isAdmin;
154 
155     /**
156     * addresses that can mint tokens
157     */
158     mapping(address => bool) public canMint;
159 
160     /**
161     * addresses allowed to transfer tokens from contract's own address to another address
162     * for example after tokens were minted, they can be transferred to user
163     * (tokenholder of new (fresh minted) tokens is always this smart contract itself)
164     */
165     mapping(address => bool) public canTransferFromContract;
166 
167     /**
168     * addresses allowed to burn tokens
169     * tokens can burned only if their tokenholder is smart contract itself
170     * nobody can burn tokens owned by user
171     */
172     mapping(address => bool) public canBurn;
173 
174     /* --- ERC-20 events */
175 
176     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#events
177 
178     /**
179     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer-1
180     */
181     event Transfer(address indexed _from, address indexed _to, uint256 _value);
182 
183     /**
184     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approval
185     */
186     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
187 
188     /**
189     * event we fire when data are sent from this smart contract to other smart contract
190     * @param _from will be msg.sender
191     * @param _toContract address of smart contract information is sent to
192     * @param _extraData any data that msg.sender sends to another smart contract
193     */
194     event DataSentToAnotherContract(address indexed _from, address indexed _toContract, bytes _extraData);
195 
196     /* --- ERC-20 Functions */
197     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods
198 
199     /*
200     *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
201     * there is and attack:
202     * https://github.com/CORIONplatform/solidity/issues/6,
203     * https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view
204     * but this function is required by ERC-20:
205     * To prevent attack vectors like the one described on https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/
206     * and discussed on https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 ,
207     * clients SHOULD make sure to create user interfaces in such a way that they set the allowance first to 0 before
208     * setting it to another value for the same spender.
209     * THOUGH The contract itself shouldn’t enforce it, to allow backwards compatibility with contracts deployed before
210     *
211     * @param _spender The address which will spend the funds.
212     * @param _value The amount of tokens to be spent.
213     */
214     function approve(address _spender, uint256 _value) public returns (bool success){
215 
216         allowance[msg.sender][_spender] = _value;
217 
218         emit Approval(msg.sender, _spender, _value);
219 
220         return true;
221     }
222 
223     /**
224     * Overloaded (see https://solidity.readthedocs.io/en/v0.5.7/contracts.html#function-overloading) approve function
225     * see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/
226     */
227     function approve(address _spender, uint256 _currentValue, uint256 _value) external returns (bool success){
228 
229         require(allowance[msg.sender][_spender] == _currentValue);
230 
231         return approve(_spender, _value);
232     }
233 
234     /**
235     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer
236     */
237     function transfer(address _to, uint256 _value) public returns (bool success){
238         return transferFrom(msg.sender, _to, _value);
239     }
240 
241     /**
242     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom
243     */
244     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
245 
246         // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
247         // Variables of uint type cannot be negative. Thus, comparing uint variable with zero (greater than or equal) is redundant
248         // require(_value >= 0);
249 
250         require(_to != address(0));
251 
252         // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
253         require(
254             msg.sender == _from
255         || _value <= allowance[_from][msg.sender]
256         || (_from == address(this) && canTransferFromContract[msg.sender]),
257             "Sender not authorized");
258 
259         // check if _from account have required amount
260         require(_value <= balanceOf[_from], "Account doesn't have required amount");
261 
262         if (_to == address(this)) {// tokens sent to smart contract itself (for exchange to fiat)
263 
264             // (!) only token holder can send tokens to smart contract address to get fiat, not using allowance
265             require(_from == msg.sender, "Only token holder can do this");
266 
267             require(_value >= minExchangeAmount, "Value is less than min. exchange amount");
268 
269             // this event used by our bot to monitor tokens that have to be burned and to make a fiat payment
270             // bot also verifies this information checking 'tokensInTransfer' mapping, which contains the same data
271             tokensInEventsCounter++;
272             emit TokensIn(
273                 _from,
274                 _value,
275                 tokensInEventsCounter
276             );
277 
278             // here we write information about this transfer
279             // (the same as in event, but stored in contract variable and with timestamp)
280             tokensInTransfer[tokensInEventsCounter].from = _from;
281             tokensInTransfer[tokensInEventsCounter].value = _value;
282             // timestamp:
283             tokensInTransfer[tokensInEventsCounter].receivedOn = now;
284 
285         }
286 
287         balanceOf[_from] = balanceOf[_from].sub(_value);
288         balanceOf[_to] = balanceOf[_to].add(_value);
289 
290         // If allowance used, change allowances correspondingly
291         if (_from != msg.sender && _from != address(this)) {
292             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
293         }
294 
295         emit Transfer(_from, _to, _value);
296 
297         return true;
298     }
299 
300     /*  ---------- Interaction with other contracts  */
301 
302     /**
303     * ERC-677
304     * https://github.com/ethereum/EIPs/issues/677
305     * transfer tokens with additional info to another smart contract, and calls its correspondent function
306     * @param _to - another smart contract address
307     * @param _value - number of tokens
308     * @param _extraData - data to send to another contract
309     * this is a recommended method to send tokens to smart contracts
310     */
311     function transferAndCall(address _to, uint256 _value, bytes memory _extraData) public returns (bool success){
312 
313         TokenRecipient receiver = TokenRecipient(_to);
314 
315         if (transferFrom(msg.sender, _to, _value)) {
316 
317             // if (receiver.tokenFallback(msg.sender, _value, _extraData)) {
318             if (receiver.onTokenTransfer(msg.sender, _value, _extraData)) {
319                 emit DataSentToAnotherContract(msg.sender, _to, _extraData);
320                 return true;
321             }
322 
323         }
324 
325         return false;
326     }
327 
328     /**
329     * the same as above ('transferAndCall'), but for all tokens on user account
330     * for example for converting ALL tokens of user account to another tokens
331     */
332     function transferAllAndCall(address _to, bytes calldata _extraData) external returns (bool){
333         return transferAndCall(_to, balanceOf[msg.sender], _extraData);
334     }
335 
336     /* --- Administrative functions */
337 
338     /**
339     * @param from old address
340     * @param to new address
341     * @param by who made a change
342     */
343     event CryptonomicaArbitrationContractAddressChanged(address from, address to, address indexed by);
344 
345     /*
346     * @param _newAddress address of new contract to be used to verify identity of new admins
347     */
348     function changeCryptonomicaVerificationContractAddress(address _newAddress) public returns (bool success) {
349 
350         require(isAdmin[msg.sender], "Only admin can do that");
351 
352         emit CryptonomicaArbitrationContractAddressChanged(address(cryptonomicaVerification), _newAddress, msg.sender);
353 
354         cryptonomicaVerification = CryptonomicaVerification(_newAddress);
355 
356         return true;
357     }
358 
359     /**
360    * @param by who added new admin
361    * @param newAdmin address of new admin
362    */
363     event AdminAdded(address indexed by, address indexed newAdmin);
364 
365     function addAdmin(address _newAdmin) public returns (bool success){
366 
367         require(isAdmin[msg.sender], "Only admin can do that");
368         require(_newAdmin != address(0), "Address can not be zero-address");
369 
370         require(cryptonomicaVerification.keyCertificateValidUntil(_newAdmin) > now, "New admin has to be verified on Cryptonomica.net");
371 
372         // revokedOn returns uint256 (unix time), it's 0 if verification is not revoked
373         require(cryptonomicaVerification.revokedOn(_newAdmin) == 0, "Verification for this address was revoked, can not add");
374 
375         isAdmin[_newAdmin] = true;
376 
377         emit AdminAdded(msg.sender, _newAdmin);
378 
379         return true;
380     }
381 
382     /**
383     * @param by an address who removed admin
384     * @param _oldAdmin address of the admin removed
385     */
386     event AdminRemoved(address indexed by, address indexed _oldAdmin);
387 
388     /**
389     * @param _oldAdmin address to be removed from admins
390     */
391     function removeAdmin(address _oldAdmin) external returns (bool success){
392 
393         require(isAdmin[msg.sender], "Only admin can do that");
394 
395         // prevents from deleting the last admin (can be multisig smart contract) by itself:
396         require(msg.sender != _oldAdmin, "Admin can't remove himself");
397 
398         isAdmin[_oldAdmin] = false;
399 
400         emit AdminRemoved(msg.sender, _oldAdmin);
401 
402         return true;
403     }
404 
405     /**
406     * minimum amount of tokens than can be exchanged to fiat
407     * can be changed by admin
408     */
409     uint256 public minExchangeAmount;
410 
411     /**
412     * @param by address who made a change
413     * @param from value before the change
414     * @param to value after the change
415     */
416     event MinExchangeAmountChanged (address indexed by, uint256 from, uint256 to);
417 
418     /**
419     * @param _minExchangeAmount new value of minimum amount of tokens that can be exchanged to fiat
420     * only admin can make this change
421     */
422     function changeMinExchangeAmount(uint256 _minExchangeAmount) public returns (bool success){
423 
424         require(isAdmin[msg.sender], "Only admin can do that");
425 
426         uint256 from = minExchangeAmount;
427 
428         minExchangeAmount = _minExchangeAmount;
429 
430         emit MinExchangeAmountChanged(msg.sender, from, minExchangeAmount);
431 
432         return true;
433     }
434 
435     /**
436     * @param by who add permission to mint (only admin can do this)
437     * @param newAddress address that was authorized to mint new tokens
438     */
439     event AddressAddedToCanMint(address indexed by, address indexed newAddress);
440 
441     /**
442     * Add permission to mint new tokens to address _newAddress
443     */
444     function addToCanMint(address _newAddress) public returns (bool success){
445 
446         require(isAdmin[msg.sender], "Only admin can do that");
447         require(_newAddress != address(0), "Address can not be zero-address");
448 
449         canMint[_newAddress] = true;
450 
451         emit AddressAddedToCanMint(msg.sender, _newAddress);
452 
453         return true;
454     }
455 
456     event AddressRemovedFromCanMint(address indexed by, address indexed removedAddress);
457 
458     function removeFromCanMint(address _addressToRemove) external returns (bool success){
459 
460         require(isAdmin[msg.sender], "Only admin can do that");
461 
462         canMint[_addressToRemove] = false;
463 
464         emit AddressRemovedFromCanMint(msg.sender, _addressToRemove);
465 
466         return true;
467     }
468 
469     /**
470     * @param by who add permission (should be admin)
471     * @param newAddress address that got permission
472     */
473     event AddressAddedToCanTransferFromContract(address indexed by, address indexed newAddress);
474 
475     function addToCanTransferFromContract(address _newAddress) public returns (bool success){
476 
477         require(isAdmin[msg.sender], "Only admin can do that");
478         require(_newAddress != address(0), "Address can not be zero-address");
479 
480         canTransferFromContract[_newAddress] = true;
481 
482         emit AddressAddedToCanTransferFromContract(msg.sender, _newAddress);
483 
484         return true;
485     }
486 
487     event AddressRemovedFromCanTransferFromContract(address indexed by, address indexed removedAddress);
488 
489     function removeFromCanTransferFromContract(address _addressToRemove) external returns (bool success){
490 
491         require(isAdmin[msg.sender], "Only admin can do that");
492 
493         canTransferFromContract[_addressToRemove] = false;
494 
495         emit AddressRemovedFromCanTransferFromContract(msg.sender, _addressToRemove);
496 
497         return true;
498     }
499 
500     /**
501     * @param by who add permission (should be admin)
502     * @param newAddress address that got permission
503     */
504     event AddressAddedToCanBurn(address indexed by, address indexed newAddress);
505 
506     function addToCanBurn(address _newAddress) public returns (bool success){
507 
508         require(isAdmin[msg.sender], "Only admin can do that");
509         require(_newAddress != address(0), "Address can not be zero-address");
510 
511         canBurn[_newAddress] = true;
512 
513         emit AddressAddedToCanBurn(msg.sender, _newAddress);
514 
515         return true;
516     }
517 
518     event AddressRemovedFromCanBurn(address indexed by, address indexed removedAddress);
519 
520     function removeFromCanBurn(address _addressToRemove) external returns (bool success){
521 
522         require(isAdmin[msg.sender], "Only admin can do that");
523 
524         canBurn[_addressToRemove] = false;
525 
526         emit AddressRemovedFromCanBurn(msg.sender, _addressToRemove);
527 
528         return true;
529     }
530 
531     /* ---------- Create and burn tokens  */
532 
533     /**
534     * number (id) for MintTokensEvent
535     */
536     uint public mintTokensEventsCounter = 0;
537 
538     /**
539     * struct used to write information about every transaction that mint new tokens (we call it 'MintTokensEvent')
540     * every 'MintTokensEvent' has its number/id (mintTokensEventsCounter)
541     */
542     struct MintTokensEvent {
543         address mintedBy; // address that minted tokens (msg.sender)
544         uint256 fiatInPaymentId; // reference to fiat transfer (deposit)
545         uint value;  // number of new tokens minted
546         uint on;    // UnixTime
547         uint currentTotalSupply; // new value of totalSupply
548     }
549 
550     /**
551     * keep all fiat tx ids, to prevent minting tokens twice (or more times) for the same fiat deposit
552     * @param uint256 reference (id) of fiat deposit
553     * @param bool if true tokens already were minted for this fiat deposit
554     * (see: require(!fiatInPaymentIds[fiatInPaymentId]); in function mintTokens
555     */
556     mapping(uint256 => bool) public fiatInPaymentIds;
557 
558     /**
559     * here we can find a MintTokensEvent by fiatInPaymentId (id of fiat deposit),
560     * so we now if tokens were minted for given incoming fiat payment (deposit), and if yes when and how many
561     * @param uint256 reference (id) of fiat deposit
562     */
563     mapping(uint256 => MintTokensEvent) public fiatInPaymentsToMintTokensEvent;
564 
565     /**
566     * here we store MintTokensEvent with its ordinal numbers/ids (mintTokensEventsCounter)
567     * @param uint256 > mintTokensEventsCounter
568     */
569     mapping(uint256 => MintTokensEvent) public mintTokensEvent;
570 
571     /**
572     * an event with the same information as in struct MintTokensEvent
573     */
574     event TokensMinted(
575         address indexed by, // who minted new tokens
576         uint256 indexed fiatInPaymentId, // reference to fiat payment (deposit)
577         uint value, // number of new minted tokens
578         uint currentTotalSupply, // totalSupply value after new tokens were minted
579         uint indexed mintTokensEventsCounter //
580     );
581 
582     /**
583     * tokens should be minted to contract own address, (!) after that tokens should be transferred using transferFrom
584     * @param value number of tokens to create
585     * @param fiatInPaymentId fiat payment (deposit) id
586     */
587     function mintTokens(uint256 value, uint256 fiatInPaymentId) public returns (bool success){
588 
589         require(canMint[msg.sender], "Sender not authorized");
590 
591         // require that this fiatInPaymentId was not used before:
592         require(!fiatInPaymentIds[fiatInPaymentId], "This fiat payment id is already used");
593 
594         // Variables of uint type cannot be negative. Thus, comparing uint variable with zero (greater than or equal) is redundant
595         // require(value >= 0);
596 
597         // this is the moment when new tokens appear in the system
598         totalSupply = totalSupply.add(value);
599 
600         // first token holder of fresh minted tokens always is the contract itself
601         // (than tokens have to be transferred from contract address to user address)
602         balanceOf[address(this)] = balanceOf[address(this)].add(value);
603 
604         mintTokensEventsCounter++;
605         mintTokensEvent[mintTokensEventsCounter].mintedBy = msg.sender;
606         mintTokensEvent[mintTokensEventsCounter].fiatInPaymentId = fiatInPaymentId;
607         mintTokensEvent[mintTokensEventsCounter].value = value;
608         mintTokensEvent[mintTokensEventsCounter].on = block.timestamp;
609         mintTokensEvent[mintTokensEventsCounter].currentTotalSupply = totalSupply;
610 
611         // fiatInPaymentId => struct mintTokensEvent
612         fiatInPaymentsToMintTokensEvent[fiatInPaymentId] = mintTokensEvent[mintTokensEventsCounter];
613 
614         emit TokensMinted(msg.sender, fiatInPaymentId, value, totalSupply, mintTokensEventsCounter);
615 
616         // mark fiatInPaymentId as used to mint tokens
617         fiatInPaymentIds[fiatInPaymentId] = true;
618 
619         return true;
620     }
621 
622     /**
623     * mint and transfer new tokens to user in one tx
624     * requires msg.sender to have both 'canMint' and 'canTransferFromContract' permissions
625     * @param _value number of new tokens to create (to mint)
626     * @param fiatInPaymentId id of fiat payment (deposit) received for new tokens
627     * @param _to receiver of new tokens
628     */
629     function mintAndTransfer(uint256 _value, uint256 fiatInPaymentId, address _to) public returns (bool success){
630 
631         if (mintTokens(_value, fiatInPaymentId) && transferFrom(address(this), _to, _value)) {
632             return true;
633         }
634 
635         return false;
636     }
637 
638     /* -- Exchange tokens to fiat (tokens sent to contract owns address > fiat payment) */
639 
640     /**
641     * number for every 'event' when we receive tokens to contract own address for exchange to fiat
642     */
643     uint public tokensInEventsCounter = 0;
644 
645     /**
646     * @param from who sent tokens for exchange
647     * @param value number of tokens received for exchange
648     * @param receivedOn timestamp (UnixTime)
649     */
650     struct TokensInTransfer {// <<< used in 'transfer'
651         address from; //
652         uint value;   //
653         uint receivedOn; // unix time
654     }
655 
656     /**
657     * @param uint256 < tokensInEventsCounter
658     */
659     mapping(uint256 => TokensInTransfer) public tokensInTransfer;
660 
661     /**
662     * @param from address that sent tokens for exchange to fiat
663     * @param value number of tokens received
664     * @param tokensInEventsCounter number of event
665     */
666     event TokensIn(
667         address indexed from,
668         uint256 value,
669         uint256 indexed tokensInEventsCounter
670     );
671 
672     /**
673     * we also count every every token burning
674     */
675     uint public burnTokensEventsCounter = 0;//
676 
677     /**
678     * @param by who burned tokens
679     * @param value number of tokens burned
680     * @param tokensInEventId corresponding id on tokensInEvent, after witch tokens were burned
681     * @param fiatOutPaymentId id of outgoing fiat payment to user
682     * @param burnedOn timestamp (unix time)
683     * @param currentTotalSupply totalSupply after tokens were burned
684     */
685     struct burnTokensEvent {
686         address by; //
687         uint256 value;   //
688         uint256 tokensInEventId;
689         uint256 fiatOutPaymentId;
690         uint256 burnedOn; // UnixTime
691         uint256 currentTotalSupply;
692     }
693 
694     /**
695     * @param uint256 < burnTokensEventsCounter
696     */
697     mapping(uint256 => burnTokensEvent) public burnTokensEvents;
698 
699     /**
700     *  we count every fiat payment id used when burn tokens to prevent using it twice
701     */
702     mapping(uint256 => bool) public fiatOutPaymentIdsUsed; //
703 
704     /**
705     * smart contract event with the same data as in struct burnTokensEvent
706     */
707     event TokensBurned(
708         address indexed by,
709         uint256 value,
710         uint256 indexed tokensInEventId, // this is the same as uint256 indexed tokensInEventsCounter in event TokensIn
711         uint256 indexed fiatOutPaymentId,
712         uint burnedOn, // UnixTime
713         uint currentTotalSupply
714     );
715 
716     /**
717     * (!) only contract's own tokens (balanceOf[this]) can be burned
718     * @param value number of tokens to burn
719     * @param tokensInEventId reference to tokensInEventsCounter value for incoming tokens event (tokensInEvent)
720     * @param fiatOutPaymentId id of outgoing fiat payment (from the bank)
721     */
722     function burnTokens(
723         uint256 value,
724         uint256 tokensInEventId, // this is the same as uint256 indexed tokensInEventsCounter in event TokensIn
725         uint256 fiatOutPaymentId
726     ) public returns (bool success){
727 
728         // Variables of uint type cannot be negative. Thus, comparing uint variable with zero (greater than or equal) is redundant
729         // require(value >= 0);
730 
731         require(canBurn[msg.sender], "Sender not authorized");
732         require(balanceOf[address(this)] >= value, "Account does not have required amount");
733 
734         // require(!tokensInEventIdsUsed[tokensInEventId]);
735         require(!fiatOutPaymentIdsUsed[fiatOutPaymentId], "This fiat payment id is already used");
736 
737         balanceOf[address(this)] = balanceOf[address(this)].sub(value);
738         totalSupply = totalSupply.sub(value);
739 
740         burnTokensEventsCounter++;
741         burnTokensEvents[burnTokensEventsCounter].by = msg.sender;
742         burnTokensEvents[burnTokensEventsCounter].value = value;
743         burnTokensEvents[burnTokensEventsCounter].tokensInEventId = tokensInEventId;
744         burnTokensEvents[burnTokensEventsCounter].fiatOutPaymentId = fiatOutPaymentId;
745         burnTokensEvents[burnTokensEventsCounter].burnedOn = block.timestamp;
746         burnTokensEvents[burnTokensEventsCounter].currentTotalSupply = totalSupply;
747 
748         emit TokensBurned(msg.sender, value, tokensInEventId, fiatOutPaymentId, block.timestamp, totalSupply);
749 
750         fiatOutPaymentIdsUsed[fiatOutPaymentId] = true;
751 
752         return true;
753     }
754 
755     /* ---------- Constructor */
756     constructor() public {// Constructor must be public or internal
757 
758         // initial admin:
759         isAdmin[msg.sender] = true;
760 
761         addToCanMint(msg.sender);
762         addToCanTransferFromContract(msg.sender);
763         addToCanBurn(msg.sender);
764 
765         changeCryptonomicaVerificationContractAddress(0x846942953c3b2A898F10DF1e32763A823bf6b27f);
766         addAdmin(0xD851d045d8Aee53EF24890afBa3d701163AcbC8B);
767 
768         // to test main functions and events (can be removed in production, or can be not):
769         changeMinExchangeAmount(12);
770         mintAndTransfer(12, 0, msg.sender);
771         transfer(msg.sender, 12);
772         transfer(address(this), 12);
773         burnTokens(12, 1, 0);
774 
775     }
776 
777 }