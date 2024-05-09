1 pragma solidity 0.5.9;
2 
3 /*
4 * @author Cryptonomica Ltd.(cryptonomica.net), 2019
5 * @version 2019-06-10
6 * Github: https://github.com/Cryptonomica/
7 * Contract address: https://etherscan.io/address/0x2ddd25a959ca2b11d1d9ea81069e50b271d56ae3
8 * Deployed on block: 7930206
9 *
10 * @section LEGAL:
11 * aim of this contract is to create a mechanism to draw, transfer and accept negotiable instruments
12 * that that will be recognized as 'bills of exchange' according at least to following regulations:
13 *
14 * 1) Convention providing a Uniform Law for Bills of Exchange and Promissory Notes (Geneva, 7 June 1930):
15 * https://www.jus.uio.no/lm/bills.of.exchange.and.promissory.notes.convention.1930/doc.html
16 * https://treaties.un.org/Pages/LONViewDetails.aspx?src=LON&id=552&chapter=30&clang=_en
17 *
18 * 2) U.K. Bills of Exchange Act 1882:
19 * http://www.legislation.gov.uk/ukpga/Vict/45-46/61/section/3
20 *
21 * and as a 'draft' according to
22 * U.S. Uniform Commercial Code
23 * https://www.law.cornell.edu/ucc/3/3-104
24 *
25 * see more on: https://github.com/Cryptonomica/cryptonomica/wiki/electronic-bills-of-exchange
26 *
27 * Bills of exchange created with this smart contract are payable to the bearer,
28 * and can be transferred using Ethereum blockchain (from one blockchain address to another)
29 *
30 */
31 
32 /**
33  * @title SafeMath
34  * @dev Unsigned math operations with safety checks that revert on error
35  * source:
36  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
37  * commit 67bca85 on Apr 25, 2019
38  */
39 library SafeMath {
40     /**
41      * @dev Multiplies two unsigned integers, reverts on overflow.
42      */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
45         // benefit is lost if 'b' is also tested.
46         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47         if (a == 0) {
48             return 0;
49         }
50 
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
59      */
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Solidity only automatically asserts when dividing by 0
62         require(b > 0, "SafeMath: division by zero");
63         uint256 c = a / b;
64         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65 
66         return c;
67     }
68 
69     /**
70      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
71      */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         require(b <= a, "SafeMath: subtraction overflow");
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Adds two unsigned integers, reverts on overflow.
81      */
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a, "SafeMath: addition overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
91      * reverts when dividing by zero.
92      */
93     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
94         require(b != 0, "SafeMath: modulo by zero");
95         return a % b;
96     }
97 }
98 
99 /**
100 * @title Contract that will work with ERC-677 tokens
101 * see:
102 * https://github.com/ethereum/EIPs/issues/677
103 * https://github.com/smartcontractkit/LinkToken/blob/master/contracts/ERC677Token.sol
104 */
105 contract ERC677Receiver {
106     /**
107     * The function is added to contracts enabling them to react to receiving tokens within a single transaction.
108     * The from parameter is the account which just transferred amount from the token contract. data is available to pass
109     * additional parameters, i.e. to indicate what the intention of the transfer is if a contract allows transfers for multiple reasons.
110     * @param from address sending tokens
111     * @param amount of tokens
112     * @param data to send to another contract
113     */
114     function onTokenTransfer(address from, uint256 amount, bytes calldata data) external returns (bool success);
115 }
116 
117 /**
118 * @title Contract that will work with overloaded 'transfer' function
119 * see: https://github.com/ethereum/EIPs/issues/223
120 */
121 contract ERC223ReceivingContract {
122     /**
123      * @dev Standard ERC223 function that will handle incoming token transfers.
124      * @param _from  Token sender address.
125      * @param _value Amount of tokens.
126      * @param _data  Transaction metadata.
127      */
128     function tokenFallback(address _from, uint _value, bytes calldata _data) external;
129 }
130 
131 /**
132  * @title Contract that implements:
133  * ERC-20  (https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md)
134  * overloaded 'transfer' function (like in ERC-223 (https://github.com/ethereum/EIPs/issues/223 )
135  * ERC-677 (https://github.com/ethereum/EIPs/issues/677)
136  * overloaded 'approve' function (https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/)
137 */
138 contract Token {
139 
140     using SafeMath for uint256;
141 
142     /* --- ERC-20 variables */
143 
144     string public name;
145 
146     string public symbol;
147 
148     uint8 public constant decimals = 0;
149 
150     uint256 public totalSupply;
151 
152     mapping(address => uint256) public balanceOf;
153 
154     mapping(address => mapping(address => uint256)) public allowance;
155 
156     /*
157     * stored address that deployed this smart contract to blockchain
158     * for bills of exchange smart contracts this will be 'BillsOfExchangeFactory' contract address
159     */
160     address public creator;
161 
162     /**
163     * Constructor
164     * no args constructor make possible to create contracts with code pre-verified on etherscan.io
165     * (once we verify one contract, all next contracts with the same code and constructor args will be verified by etherscan)
166     */
167     constructor() public {
168         /*
169         * this will be 'BillsOfExchangeFactory' contract address
170         */
171         creator = msg.sender;
172     }
173 
174     /*
175     * initializes token: set initial values for erc20 variables
176     * assigns all tokens ('totalSupply') to one address ('tokenOwner')
177     * @param _name Name of the token
178     * @param _symbol Symbol of the token
179     * @param _totalSupply Amount of tokens to create
180     * @param _tokenOwner Address that will initially hold all created tokens
181     */
182     function initToken(
183         string calldata _name,
184         string calldata _symbol,
185         uint256 _totalSupply,
186         address tokenOwner
187     ) external {
188 
189         // creator is BillsOfExchangeFactory address
190         require(msg.sender == creator, "Only creator can initialize token contract");
191 
192         name = _name;
193         symbol = _symbol;
194         totalSupply = _totalSupply;
195         balanceOf[tokenOwner] = totalSupply;
196 
197         emit Transfer(address(0), tokenOwner, totalSupply);
198 
199     }
200 
201     /* --- ERC-20 events */
202 
203     event Transfer(address indexed from, address indexed to, uint256 value);
204 
205     event Approval(address indexed _owner, address indexed spender, uint256 value);
206 
207     /* --- Events for interaction with other smart contracts */
208 
209     /**
210     * @param _from Address that sent transaction
211     * @param _toContract Receiver (smart contract)
212     * @param _extraData Data sent
213     */
214     event DataSentToAnotherContract(address indexed _from, address indexed _toContract, bytes indexed _extraData);
215 
216     /* --- ERC-20 Functions */
217 
218     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
219 
220         // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
221         // Variables of uint type cannot be negative. Thus, comparing uint variable with zero (greater than or equal) is redundant
222         // require(_value >= 0);
223 
224         require(_to != address(0), "_to was 0x0 address");
225 
226         // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
227         require(msg.sender == _from || _value <= allowance[_from][msg.sender], "Sender not authorized");
228 
229         // check if _from account have required amount
230         require(_value <= balanceOf[_from], "Account doesn't have required amount");
231 
232         // Subtract from the sender
233         balanceOf[_from] = balanceOf[_from].sub(_value);
234         // Add the same to the recipient
235         balanceOf[_to] = balanceOf[_to].add(_value);
236 
237         // If allowance used, change allowances correspondingly
238         if (_from != msg.sender) {
239             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
240         }
241 
242         emit Transfer(_from, _to, _value);
243 
244         return true;
245     } // end of transferFrom
246 
247     function transfer(address _to, uint256 _value) public returns (bool success){
248         return transferFrom(msg.sender, _to, _value);
249     }
250 
251     /**
252     * overloaded transfer (like in ERC-223)
253     * see: https://github.com/ethereum/EIPs/issues/223
254     * https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol
255     */
256     function transfer(address _to, uint _value, bytes calldata _data) external returns (bool success){
257         if (transfer(_to, _value)) {
258             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
259             receiver.tokenFallback(msg.sender, _value, _data);
260             emit DataSentToAnotherContract(msg.sender, _to, _data);
261             return true;
262         }
263         return false;
264     }
265 
266     /**
267     * ERC-677
268     * https://github.com/ethereum/EIPs/issues/677
269     * transfer tokens with additional info to another smart contract, and calls its correspondent function
270     * @param _to Another smart contract address (receiver)
271     * @param _value Number of tokens to transfer
272     * @param _extraData Data to send to another contract
273     *
274     * This function is a recommended method to send tokens to smart contracts.
275     */
276     function transferAndCall(address _to, uint256 _value, bytes memory _extraData) public returns (bool success){
277         if (transferFrom(msg.sender, _to, _value)) {
278             ERC677Receiver receiver = ERC677Receiver(_to);
279             if (receiver.onTokenTransfer(msg.sender, _value, _extraData)) {
280                 emit DataSentToAnotherContract(msg.sender, _to, _extraData);
281                 return true;
282             }
283         }
284         return false;
285     }
286 
287     /**
288     * the same as above ('transferAndCall'), but for all tokens on user account
289     * for example for converting ALL tokens on user account to another tokens
290     */
291     function transferAllAndCall(address _to, bytes calldata _extraData) external returns (bool){
292         return transferAndCall(_to, balanceOf[msg.sender], _extraData);
293     }
294 
295     /*
296     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
297     * there is an attack:
298     * https://github.com/CORIONplatform/solidity/issues/6,
299     * https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view
300     * but this function is required by ERC-20:
301     * To prevent attack vectors like the one described on https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/
302     * and discussed on https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 ,
303     * clients SHOULD make sure to create user interfaces in such a way that they set the allowance first to 0 before
304     * setting it to another value for the same spender.
305     * THOUGH The contract itself shouldn’t enforce it, to allow backwards compatibility with contracts deployed before
306     *
307     * @param _spender The address which will spend the funds.
308     * @param _value The amount of tokens to be spent.
309     */
310     function approve(address _spender, uint256 _value) public returns (bool success){
311         allowance[msg.sender][_spender] = _value;
312         emit Approval(msg.sender, _spender, _value);
313         return true;
314     }
315 
316     /**
317     * Overloaded approve function
318     * see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/
319     * @param _spender The address which will spend the funds.
320     * @param _currentValue The current value of allowance for spender
321     * @param _value The amount of tokens to be spent.
322     */
323     function approve(address _spender, uint256 _currentValue, uint256 _value) external returns (bool success){
324         require(
325             allowance[msg.sender][_spender] == _currentValue,
326             "Current value in contract is different than provided current value"
327         );
328         return approve(_spender, _value);
329     }
330 
331 }
332 
333 /*
334 * Token that can be burned by tokenholder
335 * see also: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Burnable.sol
336 */
337 contract BurnableToken is Token {
338 
339     /**
340     * @param from Address of the tokenholder
341     * @param value Amount of tokens burned
342     * @param by Address who send transaction to burn tokens
343     */
344     event TokensBurned(address indexed from, uint256 value, address by);
345 
346     /*
347     * @param _from Tokenholder address
348     * @param _value Amount of tokens to burn
349     *
350     */
351     function burnTokensFrom(address _from, uint256 _value) public returns (bool success){
352 
353         require(msg.sender == _from || _value <= allowance[_from][msg.sender], "Sender not authorized");
354         require(_value <= balanceOf[_from], "Account doesn't have required amount");
355 
356         balanceOf[_from] = balanceOf[_from].sub(_value);
357         totalSupply = totalSupply.sub(_value);
358 
359         // If allowance used, change allowances correspondingly
360         if (_from != msg.sender) {
361             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
362         }
363 
364         emit Transfer(_from, address(0), _value);
365         emit TokensBurned(_from, _value, msg.sender);
366 
367         return true;
368     }
369 
370     function burnTokens(uint256 _value) external returns (bool success){
371         return burnTokensFrom(msg.sender, _value);
372     }
373 
374 }
375 
376 /**
377 * see: https://www.cryptonomica.net/#!/verifyEthAddress/
378 * in our bills of exchange smart contracts:
379 * 1) every new admin should have a verified identity on cryptonomica.net
380 * 2) every person that signs (draw or accept) a bill should be verified
381 */
382 contract CryptonomicaVerification {
383 
384     /**
385     * @param _address The address to check
386     * @return 0 if key certificate is not revoked, or Unix time of revocation
387     */
388     function revokedOn(address _address) external view returns (uint unixTime);
389 
390     /**
391     * @param _address The address to check
392     * @return Unix time
393     */
394     function keyCertificateValidUntil(address _address) external view returns (uint unixTime);
395 }
396 
397 /*
398 * Universal functions for smart contract management
399 */
400 contract ManagedContract {
401 
402     /*
403     * smart contract that provides information about person that owns given Ethereum address/key
404     */
405     CryptonomicaVerification public cryptonomicaVerification;
406 
407     /*
408     * ledger of admins
409     */
410     mapping(address => bool) isAdmin;
411 
412     modifier onlyAdmin() {
413         require(isAdmin[msg.sender], "Only admin can do that");
414         _;
415     }
416 
417     /**
418     * @param from Old address
419     * @param to New address
420     * @param by Who made a change
421     */
422     event CryptonomicaVerificationContractAddressChanged(address from, address to, address indexed by);
423 
424     /**
425     * @param _newAddress address of new contract to be used to verify identity of new admins
426     */
427     function changeCryptonomicaVerificationContractAddress(address _newAddress) public onlyAdmin returns (bool success) {
428 
429         emit CryptonomicaVerificationContractAddressChanged(address(cryptonomicaVerification), _newAddress, msg.sender);
430 
431         cryptonomicaVerification = CryptonomicaVerification(_newAddress);
432 
433         return true;
434     }
435 
436     /**
437     * @param added New admin address
438     * @param addedBy Who added new admin
439     */
440     event AdminAdded(
441         address indexed added,
442         address indexed addedBy
443     );
444 
445     /**
446     * @param _newAdmin Address of new admin
447     */
448     function addAdmin(address _newAdmin) public onlyAdmin returns (bool success){
449 
450         require(
451             cryptonomicaVerification.keyCertificateValidUntil(_newAdmin) > now,
452             "New admin has to be verified on Cryptonomica.net"
453         );
454 
455         // revokedOn returns uint256 (unix time), it's 0 if verification is not revoked
456         require(
457             cryptonomicaVerification.revokedOn(_newAdmin) == 0,
458             "Verification for this address was revoked, can not add"
459         );
460 
461         isAdmin[_newAdmin] = true;
462 
463         emit AdminAdded(_newAdmin, msg.sender);
464 
465         return true;
466     }
467 
468     /**
469     * @param removed Removed admin address
470     * @param removedBy Who removed admin
471     */
472     event AdminRemoved(
473         address indexed removed,
474         address indexed removedBy
475     );
476 
477     /**
478     * @param _oldAdmin Address to remove from admins
479     */
480     function removeAdmin(address _oldAdmin) external onlyAdmin returns (bool){
481 
482         require(msg.sender != _oldAdmin, "Admin can not remove himself");
483 
484         isAdmin[_oldAdmin] = false;
485 
486         emit AdminRemoved(_oldAdmin, msg.sender);
487 
488         return true;
489     }
490 
491     /* --- financial management */
492 
493     /*
494     * address to send Ether from this contract
495     */
496     address payable public withdrawalAddress;
497 
498     /*
499     * withdrawal address can be fixed (protected from changes),
500     */
501     bool public withdrawalAddressFixed = false;
502 
503     /*
504     * @param from Old address
505     * @param to New address
506     * @param changedBy Who made this change
507     */
508     event WithdrawalAddressChanged(address indexed from, address indexed to, address indexed changedBy);
509 
510     /*
511     * @param _withdrawalAddress address to which funds from this contract will be sent
512     */
513     function setWithdrawalAddress(address payable _withdrawalAddress) public onlyAdmin returns (bool success) {
514 
515         require(!withdrawalAddressFixed, "Withdrawal address already fixed");
516         require(_withdrawalAddress != address(0), "Wrong address: 0x0");
517         require(_withdrawalAddress != address(this), "Wrong address: contract itself");
518 
519         emit WithdrawalAddressChanged(withdrawalAddress, _withdrawalAddress, msg.sender);
520 
521         withdrawalAddress = _withdrawalAddress;
522 
523         return true;
524     }
525 
526     /*
527     * @param withdrawalAddressFixedAs Address for withdrawal
528     * @param fixedBy Address who made this change (msg.sender)
529     *
530     * This event can be fired one time only
531     */
532     event WithdrawalAddressFixed(address indexed withdrawalAddressFixedAs, address indexed fixedBy);
533 
534     /**
535     * @param _withdrawalAddress Address to which funds from this contract will be sent
536     * This function can be called one time only.
537     */
538     function fixWithdrawalAddress(address _withdrawalAddress) external onlyAdmin returns (bool success) {
539 
540         // prevents event if already fixed
541         require(!withdrawalAddressFixed, "Can't change, address fixed");
542 
543         // check, to prevent fixing wrong address
544         require(withdrawalAddress == _withdrawalAddress, "Wrong address in argument");
545 
546         withdrawalAddressFixed = true;
547 
548         emit WithdrawalAddressFixed(withdrawalAddress, msg.sender);
549 
550         return true;
551     }
552 
553     /**
554     * @param to address to which ETH was sent
555     * @param sumInWei sum sent (in wei)
556     * @param by who made withdrawal (msg.sender)
557     * @param success if withdrawal was successful
558     */
559     event Withdrawal(
560         address indexed to,
561         uint sumInWei,
562         address indexed by,
563         bool indexed success
564     );
565 
566     /**
567     * !!! can be called by any user or contract
568     * possible warning: check for reentrancy vulnerability http://solidity.readthedocs.io/en/develop/security-considerations.html#re-entrancy
569     * >>> since we are making a withdrawal to our own contract/address only there is no possible attack using re-entrancy vulnerability
570     */
571     function withdrawAllToWithdrawalAddress() external returns (bool success) {
572 
573         // http://solidity.readthedocs.io/en/develop/security-considerations.html#sending-and-receiving-ether
574         // about <address>.send(uint256 amount) and <address>.transfer(uint256 amount)
575         // see: http://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=transfer#address-related
576         // https://ethereum.stackexchange.com/questions/19341/address-send-vs-address-transfer-best-practice-usage
577 
578         uint sum = address(this).balance;
579 
580         if (!withdrawalAddress.send(sum)) {// makes withdrawal and returns true (success) or false
581 
582             emit Withdrawal(withdrawalAddress, sum, msg.sender, false);
583 
584             return false;
585         }
586 
587         emit Withdrawal(withdrawalAddress, sum, msg.sender, true);
588 
589         return true;
590     }
591 
592 }
593 
594 /*
595 * This is a model contract where some paid service provided and there is a price
596 * (in main function we can check if msg.value >= price)
597 */
598 contract ManagedContractWithPaidService is ManagedContract {
599 
600     uint256 public price;
601 
602     /*
603     * @param from The old price
604     * @param to The new price
605     * @param by Who changed the price
606     */
607     event PriceChanged(uint256 from, uint256 to, address indexed by);
608 
609     /*
610     * @param _newPrice The new price for the service
611     */
612     function changePrice(uint256 _newPrice) public onlyAdmin returns (bool success){
613         emit PriceChanged(price, _newPrice, msg.sender);
614         price = _newPrice;
615         return true;
616     }
617 
618 }
619 
620 /**
621  * This contract represents a bunch of bills of exchange issued by one person at the same time and on the same conditions
622  */
623 contract BillsOfExchange is BurnableToken {
624 
625     /* ---- Bill of Exchange requisites: */
626 
627     /**
628     * Number of this contract in the ledger maintained by factory contract
629     */
630     uint256 public billsOfExchangeContractNumber;
631 
632     /**
633     * Legal name of a person who issues the bill (drawer)
634     * This can be a name of a company/organization or of a physical person
635     */
636     string public drawerName;
637 
638     /**
639     * Ethereum address of the signer
640     * His/her identity has to be verified via Cryptonomica.net smart contract
641     */
642     address public drawerRepresentedBy;
643 
644     /**
645     * Link to information about signer's authority to represent the drawer
646     * This should be a proof that signer can represent drawer
647     * It can be link to public register like Companies House in U.K., or other proof.
648     * Whosoever puts his signature on a bill of exchange as representing a person for whom he had no power to act is
649     * bound himself as a party to the bill. The same rule applies to a representative who has exceeded his powers.
650     */
651     string public linkToSignersAuthorityToRepresentTheDrawer;
652 
653     /**
654     * The name of the person who is to pay (drawee)
655     */
656     string public drawee;
657 
658     /**
659     * Ethereum address of a person who can represent the drawee
660     * This address should be verified via Cryptonomica.net smart contract
661     */
662     address public draweeSignerAddress;
663 
664     /**
665     * This should be a proof that signer can represent drawee.
666     */
667     string  public linkToSignersAuthorityToRepresentTheDrawee;
668 
669     /*
670     * Legal conditions to be included
671     */
672     string public description;
673     string public order;
674     string public disputeResolutionAgreement;
675     CryptonomicaVerification public cryptonomicaVerification;
676 
677     /*
678     *  a statement of the time of payment
679     *  we use string to make possible variants like: '01 Jan 2021', 'at sight', 'at sight but not before 2019-12-31'
680     *  '10 days after sight' etc.,
681     * see https://www.jus.uio.no/lm/bills.of.exchange.and.promissory.notes.convention.1930/doc.html#109
682     */
683     string public timeOfPayment;
684 
685     // A statement of the date and of the place where the bill is issued
686     uint256 public issuedOnUnixTime;
687     string public placeWhereTheBillIsIssued; //  i.e. "London, U.K.";
688 
689     // a statement of the place where payment is to be made;
690     // usually it is an address of the payer
691     string public placeWherePaymentIsToBeMade;
692 
693     // https://en.wikipedia.org/wiki/ISO_4217
694     // or crypto currency
695     string public currency; // for example: "EUR", "USD"
696 
697     uint256 public sumToBePaidForEveryToken; //
698 
699     /*
700     * number of signatures under disputeResolution agreement
701     */
702     uint256 public disputeResolutionAgreementSignaturesCounter;
703 
704     /*
705     * @param signatoryAddress Ethereum address of the person, that signed the agreement
706     * @param signatoryName Legal name of the person that signed agreement. This can be a name of a legal or physical
707     * person
708     */
709     struct Signature {
710         address signatoryAddress;
711         string signatoryName;
712     }
713 
714     mapping(uint256 => Signature) public disputeResolutionAgreementSignatures;
715 
716     /*
717     * Event to be emitted when disputeResolution agreement was signed by new person
718     * @param signatureNumber Number of the signature (see 'disputeResolutionAgreementSignaturesCounter')
719     * @param singedBy Name of the person who signed disputeResolution agreement
720     * @param representedBy Ethereum address of the person who signed disputeResolution agreement
721     * @param signedOn Timestamp (Unix time)
722     */
723     event disputeResolutionAgreementSigned(
724         uint256 indexed signatureNumber,
725         string signedBy,
726         address indexed representedBy,
727         uint256 signedOn
728     );
729 
730     /*
731        * @param _signatoryAddress Ethereum address of the person who signs agreement
732        * @param _signatoryName Name of the person that signs dispute resolution agreement
733        */
734     function signDisputeResolutionAgreementFor(
735         address _signatoryAddress,
736         string memory _signatoryName
737     ) public returns (bool success){
738 
739         require(
740             msg.sender == _signatoryAddress ||
741             msg.sender == creator,
742             "Not authorized to sign dispute resolution agreement"
743         );
744 
745         // ! signer should have valid identity verification in cryptonomica.net smart contract:
746 
747         require(
748             cryptonomicaVerification.keyCertificateValidUntil(_signatoryAddress) > now,
749             "Signer has to be verified on Cryptonomica.net"
750         );
751 
752         // revokedOn returns uint256 (unix time), it's 0 if verification is not revoked
753         require(
754             cryptonomicaVerification.revokedOn(_signatoryAddress) == 0,
755             "Verification for this address was revoked, can not sign"
756         );
757 
758         disputeResolutionAgreementSignaturesCounter++;
759 
760         disputeResolutionAgreementSignatures[disputeResolutionAgreementSignaturesCounter].signatoryAddress = _signatoryAddress;
761         disputeResolutionAgreementSignatures[disputeResolutionAgreementSignaturesCounter].signatoryName = _signatoryName;
762 
763         emit disputeResolutionAgreementSigned(disputeResolutionAgreementSignaturesCounter, _signatoryName, msg.sender, now);
764 
765         return true;
766     }
767 
768     function signDisputeResolutionAgreement(string calldata _signatoryName) external returns (bool success){
769         return signDisputeResolutionAgreementFor(msg.sender, _signatoryName);
770     }
771 
772     /**
773     * set up new bunch of bills of exchange and sign dispute resolution agreement
774     *
775     * @param _billsOfExchangeContractNumber A number of this contract in the ledger ('billsOfExchangeContractsCounter' from BillsOfExchangeFactory)
776     * @param _currency Currency of the payment, for example: "EUR", "USD"
777     * @param _sumToBePaidForEveryToken The amount in the above currency, that have to be paid for every token (bill of exchange)
778     * @param _drawerName The person who issues the bill (drawer)
779     * @param _drawerRepresentedBy The Ethereum address of the signer
780     * @param _linkToSignersAuthorityToRepresentTheDrawer Link to information about signers authority to represent the drawer
781     * @param  _drawee The name of the person who is to pay (can be the same as drawer)
782     */
783     function initBillsOfExchange(
784         uint256 _billsOfExchangeContractNumber,
785         string calldata _currency,
786         uint256 _sumToBePaidForEveryToken,
787         string calldata _drawerName,
788         address _drawerRepresentedBy,
789         string calldata _linkToSignersAuthorityToRepresentTheDrawer,
790         string calldata _drawee,
791         address _draweeSignerAddress
792     ) external {
793 
794         require(msg.sender == creator, "Only contract creator can call 'initBillsOfExchange' function");
795 
796         billsOfExchangeContractNumber = _billsOfExchangeContractNumber;
797 
798         // https://en.wikipedia.org/wiki/ISO_4217
799         // or crypto currency
800         currency = _currency;
801 
802         sumToBePaidForEveryToken = _sumToBePaidForEveryToken;
803 
804         // person who issues the bill (drawer)
805         drawerName = _drawerName;
806         drawerRepresentedBy = _drawerRepresentedBy;
807         linkToSignersAuthorityToRepresentTheDrawer = _linkToSignersAuthorityToRepresentTheDrawer;
808 
809         // order to
810         // (the name of the person who is to pay)
811         drawee = _drawee;
812         draweeSignerAddress = _draweeSignerAddress;
813 
814     }
815 
816     /**
817     * Set places and time
818     * not included in 'init' because of exception: 'Stack too deep, try using fewer variables.'
819     * @param _timeOfPayment The time when payment has to be made
820     * @param  _placeWhereTheBillIsIssued Place where the bills were issued. Usually it's the address of the drawer.
821     * @param _placeWherePaymentIsToBeMade Place where the payment has to be made. Usually it's the address of the drawee.
822     */
823     function setPlacesAndTime(
824         string calldata _timeOfPayment,
825         string calldata _placeWhereTheBillIsIssued,
826         string calldata _placeWherePaymentIsToBeMade
827     ) external {
828 
829         require(msg.sender == creator, "Only contract creator can call 'setPlacesAndTime' function");
830 
831         // require(issuedOnUnixTime == 0, "setPlacesAndTime can be called one time only");
832         // (this can be ensured in factory contract)
833 
834         issuedOnUnixTime = now;
835         timeOfPayment = _timeOfPayment;
836 
837         placeWhereTheBillIsIssued = _placeWhereTheBillIsIssued;
838         placeWherePaymentIsToBeMade = _placeWherePaymentIsToBeMade;
839 
840     }
841 
842     /*
843     * @param _description Legal description of bills of exchange created.
844     * @param _order Order to pay (text or the order)
845     * @param _disputeResolutionAgreement Agreement about dispute resolution (text)
846     * this function should be called only once - when initializing smart contract
847     */
848     function setLegal(
849         string calldata _description,
850         string calldata _order,
851         string calldata _disputeResolutionAgreement,
852         address _cryptonomicaVerificationAddress
853 
854     ) external {
855 
856         require(msg.sender == creator, "Only contract creator can call 'setLegal' function");
857 
858         // require(address(cryptonomicaVerification) == address(0), "setLegal can be called one time only");
859         // (this can be ensured in factory contract)
860 
861         description = _description;
862         order = _order;
863         disputeResolutionAgreement = _disputeResolutionAgreement;
864         cryptonomicaVerification = CryptonomicaVerification(_cryptonomicaVerificationAddress);
865 
866     }
867 
868     uint256 public acceptedOnUnixTime;
869 
870     /**
871     * Drawee can accept only all bills in the smart contract, or not accept at all
872     * @param acceptedOnUnixTime Time when drawee accepted bills
873     * @param drawee The name of the drawee
874     * @param draweeRepresentedBy The Ethereum address of the drawee's representative
875     * (or drawee himself if he is a physical person)
876     */
877     event Acceptance(
878         uint256 acceptedOnUnixTime,
879         string drawee,
880         address draweeRepresentedBy
881     );
882 
883     /**
884     * function for drawee to accept bill of exchange
885     * see:
886     * http://www.legislation.gov.uk/ukpga/Vict/45-46/61/section/17
887     * https://www.jus.uio.no/lm/bills.of.exchange.and.promissory.notes.convention.1930/doc.html#69
888     *
889     * @param _linkToSignersAuthorityToRepresentTheDrawee Link to information about signer's authority to represent the drawee
890     */
891     function accept(string calldata _linkToSignersAuthorityToRepresentTheDrawee) external returns (bool success) {
892 
893         /*
894         * this should be called only by address, previously indicated as drawee's address by the drawer
895         * or by BillsOfExchangeFactory address via 'createAndAcceptBillsOfExchange' function
896         */
897         require(
898             msg.sender == draweeSignerAddress ||
899             msg.sender == creator,
900             "Not authorized to accept"
901         );
902 
903         signDisputeResolutionAgreementFor(draweeSignerAddress, drawee);
904 
905         linkToSignersAuthorityToRepresentTheDrawee = _linkToSignersAuthorityToRepresentTheDrawee;
906 
907         acceptedOnUnixTime = now;
908 
909         emit Acceptance(acceptedOnUnixTime, drawee, msg.sender);
910 
911         return true;
912     }
913 
914 }
915 
916 /*
917 BillsOfExchangeFactory :
918 https://ropsten.etherscan.io/address/0xa535386ffa1019a3816730960eef0f5a88ede4a2
919 */
920 //contract BillsOfExchangeFactory is ManagedContractWithPaidService, ManagedContractUsingCryptonomicaServices {
921 contract BillsOfExchangeFactory is ManagedContractWithPaidService {
922 
923     // using SafeMath for uint256;
924 
925     /*
926     * Legal conditions to be included
927     */
928     string public description = "Every token (ERC20) in this smart contract is a bill of exchange in blank - payable to bearer (bearer is the owner of the Ethereum address witch holds the tokens, or the person he/she represents), but not to order - that means no endorsement possible and the token holder can only transfer the token (bill of exchange in blank) itself.";
929     // string public forkClause = "";
930     string public order = "Pay to bearer (tokenholder), but not to order, the sum defined for every token in currency defined in 'currency' (according to ISO 4217 standard; or XAU for for one troy ounce of gold, XBT or BTC for Bitcoin, ETH for Ether, DASH for Dash, ZEC for Zcash, XRP for Ripple, XMR for Monero, xEUR for xEuro)";
931     string public disputeResolutionAgreement =
932     "Any dispute, controversy or claim arising out of or relating to this bill(s) of exchange, including invalidity thereof and payments based on this bill(s), shall be settled by arbitration in accordance with the Cryptonomica Arbitration Rules (https://github.com/Cryptonomica/arbitration-rules) in the version in effect at the time of the filing of the claim. In the case of the Ethereum blockchain fork, the blockchain that has the highest hashrate is considered valid, and all others are not considered a valid registry; bill payment settles bill even if valid blockchain (hashrate) changes after the payment. All Ethereum test networks are not valid registries.";
933 
934     /**
935     *  Constructor
936     */
937     constructor() public {
938 
939         isAdmin[msg.sender] = true;
940 
941         changePrice(0.15 ether);
942 
943         // Ropsten: > verification always valid for any address
944         // TODO: change in production to https://etherscan.io/address/0x846942953c3b2A898F10DF1e32763A823bf6b27f <<<<<<<<
945         // require(changeCryptonomicaVerificationContractAddress(0xE48BC3dB5b512d4A3e3Cd388bE541Be7202285B5)); // Ropsten
946         require(changeCryptonomicaVerificationContractAddress(0x846942953c3b2A898F10DF1e32763A823bf6b27f));
947 
948         require(setWithdrawalAddress(msg.sender));
949     }
950 
951     /**
952     * every bills of exchange contract will have a number
953     */
954     uint256 public billsOfExchangeContractsCounter;
955 
956     /**
957     * ledger bills of exchange contract number => bills of exchange contract address
958     */
959     mapping(uint256 => address) public billsOfExchangeContractsLedger;
960 
961     /*
962     * @param _name Name of the token, also will be used for erc20 'symbol' property (see billsOfExchange.initToken )
963     * @param _totalSupply Number (amount) of bills of exchange to create
964     * @param __currency A currency in which bill payments have to be made, for example: "EUR", "USD"
965     * @param _sumToBePaidForEveryToken A sum of each bill of exchange
966     * @param _drawerName The name of the person (legal or physical) who issues the bill (drawer)
967     * @param _drawee The name of the person (legal or physical) who is to pay (drawee)
968     * @param __draweeSignerAddress Ethereum address of the person who has to accept bills of exchange in the name of
969     * the drawee. Drawer has to agree this address with the drawee (acceptor) in advance.
970     * @param _timeOfPayment Time when bill payment has to be made
971     * @param _placeWhereTheBillIsIssued A statement of the place where the bill is issued.
972     * Usual it's the address of the drawer.
973     * @param _placeWherePaymentIsToBeMadeA statement of the place where payment is to be made.
974     * Usual it's the address of the drawee.
975     *
976     * arguments to test this function in remix:
977     * "Test Company Ltd. bills of exchange, Series TST01", "TST01", 100000000, "EUR",1,"Test Company Ltd, 3 Main Street, London, XY1Z  1XZ, U.K.; company # 12345678","https://beta.companieshouse.gov.uk/company/12345678/officers","Test Company Ltd, 3 Main Street, London, XY1Z  1XZ, U.K.; company # 12345678",0x07BaD6bda22A830f58fDA19eBA45552C44168600,"at sight but not before 01 Sep 2021","London, U.K.", "London, U.K."
978     */
979     function createBillsOfExchange(
980         string memory _name,
981         string memory _symbol,
982         uint256 _totalSupply,
983         string memory _currency,
984         uint256 _sumToBePaidForEveryToken,
985         string memory _drawerName,
986     // address _drawerRepresentedBy, // <<< msg.sender
987         string memory _linkToSignersAuthorityToRepresentTheDrawer,
988         string memory _drawee,
989         address _draweeSignerAddress,
990         string memory _timeOfPayment,
991         string memory _placeWhereTheBillIsIssued,
992         string memory _placeWherePaymentIsToBeMade
993     ) public payable returns (address newBillsOfExchangeContractAddress) {
994 
995         require(msg.value >= price, "Payment sent was lower than the price for creating Bills of Exchange");
996 
997         BillsOfExchange billsOfExchange = new BillsOfExchange();
998         billsOfExchangeContractsCounter++;
999         billsOfExchangeContractsLedger[billsOfExchangeContractsCounter] = address(billsOfExchange);
1000 
1001         billsOfExchange.initToken(
1002             _name, //
1003             _symbol, // symbol
1004             _totalSupply,
1005             msg.sender // tokenOwner (drawer or drawer representative)
1006         );
1007 
1008         billsOfExchange.initBillsOfExchange(
1009             billsOfExchangeContractsCounter,
1010             _currency,
1011             _sumToBePaidForEveryToken,
1012             _drawerName,
1013             msg.sender,
1014             _linkToSignersAuthorityToRepresentTheDrawer,
1015             _drawee,
1016             _draweeSignerAddress
1017         );
1018 
1019         billsOfExchange.setPlacesAndTime(
1020             _timeOfPayment,
1021             _placeWhereTheBillIsIssued,
1022             _placeWherePaymentIsToBeMade
1023         );
1024 
1025         billsOfExchange.setLegal(
1026             description,
1027             order,
1028             disputeResolutionAgreement,
1029             address(cryptonomicaVerification)
1030         );
1031 
1032         /*
1033         * (!) Here we check if msg.sender has valid verification from 'cryptonomicaVerification' contract
1034         */
1035         billsOfExchange.signDisputeResolutionAgreementFor(msg.sender, _drawerName);
1036 
1037         return address(billsOfExchange);
1038     }
1039 
1040     /*
1041     * As above, but the drawer and the drawee are the same person, and bills will be accepted instantly
1042     *
1043     * arguments to test this function in remix:
1044     * "Test Company Ltd. bills of exchange, Series TST01", "TST01", 100000000, "EUR",1,"Test Company Ltd, 3 Main Street, London, XY1Z  1XZ, U.K.; company # 12345678","https://beta.companieshouse.gov.uk/company/12345678/officers","at sight but not before 01 Sep 2021","London, U.K.", "London, U.K."
1045     */
1046     function createAndAcceptBillsOfExchange(
1047         string memory _name, // name of the token
1048         string memory _symbol,
1049         uint256 _totalSupply,
1050         string memory _currency,
1051         uint256 _sumToBePaidForEveryToken,
1052         string memory _drawerName,
1053     // address _drawerRepresentedBy, // <<< msg.sender
1054         string memory _linkToSignersAuthorityToRepresentTheDrawer,
1055     // string  _drawee, > the same as drawer
1056     // address _draweeSignerAddress, > the same as msg.sender
1057         string memory _timeOfPayment,
1058         string memory _placeWhereTheBillIsIssued,
1059         string memory _placeWherePaymentIsToBeMade
1060 
1061     ) public payable returns (address newBillsOfExchangeContractAddress) {// if 'external' > "Stack to deep ..." error
1062 
1063         require(msg.value >= price, "Payment sent was lower than the price for creating Bills of Exchange");
1064 
1065         BillsOfExchange billsOfExchange = new BillsOfExchange();
1066         billsOfExchangeContractsCounter++;
1067         billsOfExchangeContractsLedger[billsOfExchangeContractsCounter] = address(billsOfExchange);
1068 
1069         billsOfExchange.initToken(
1070             _name, //
1071             _symbol, // symbol
1072             _totalSupply,
1073             msg.sender // tokenOwner (drawer or drawer representative)
1074         );
1075 
1076         billsOfExchange.initBillsOfExchange(
1077             billsOfExchangeContractsCounter,
1078             _currency,
1079             _sumToBePaidForEveryToken,
1080             _drawerName,
1081             msg.sender,
1082             _linkToSignersAuthorityToRepresentTheDrawer,
1083             _drawerName, // < _drawee,
1084             msg.sender // < _draweeSignerAddress
1085         );
1086 
1087         billsOfExchange.setPlacesAndTime(
1088             _timeOfPayment,
1089             _placeWhereTheBillIsIssued,
1090             _placeWherePaymentIsToBeMade
1091         );
1092 
1093         billsOfExchange.setLegal(
1094             description,
1095             order,
1096             disputeResolutionAgreement,
1097             address(cryptonomicaVerification)
1098         );
1099 
1100         // not needed to sign dispute resolution agreement here because signature is required by 'accept' function
1101 
1102         billsOfExchange.accept(_linkToSignersAuthorityToRepresentTheDrawer);
1103 
1104         return address(billsOfExchange);
1105 
1106     }
1107 
1108 }