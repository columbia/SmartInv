1 pragma solidity 0.4.25;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 library ECDSA {
6 
7   /**
8    * @dev Recover signer address from a message by using their signature
9    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
10    * @param signature bytes signature, the signature is generated using web3.eth.sign()
11    */
12   function recover(bytes32 hash, bytes signature)
13     internal
14     pure
15     returns (address)
16   {
17     bytes32 r;
18     bytes32 s;
19     uint8 v;
20 
21     // Check the signature length
22     if (signature.length != 65) {
23       return (address(0));
24     }
25 
26     // Divide the signature in r, s and v variables
27     // ecrecover takes the signature parameters, and the only way to get them
28     // currently is to use assembly.
29     // solium-disable-next-line security/no-inline-assembly
30     assembly {
31       r := mload(add(signature, 0x20))
32       s := mload(add(signature, 0x40))
33       v := byte(0, mload(add(signature, 0x60)))
34     }
35 
36     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
37     if (v < 27) {
38       v += 27;
39     }
40 
41     // If the version is correct return the signer address
42     if (v != 27 && v != 28) {
43       return (address(0));
44     } else {
45       // solium-disable-next-line arg-overflow
46       return ecrecover(hash, v, r, s);
47     }
48   }
49 
50   /**
51    * toEthSignedMessageHash
52    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
53    * and hash the result
54    */
55   function toEthSignedMessageHash(bytes32 hash)
56     internal
57     pure
58     returns (bytes32)
59   {
60     // 32 is the length in bytes of hash,
61     // enforced by the type signature above
62     return keccak256(
63       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
64     );
65   }
66 }
67 
68 contract Ownable {
69   address private _owner;
70 
71   event OwnershipTransferred(
72     address indexed previousOwner,
73     address indexed newOwner
74   );
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   constructor() internal {
81     _owner = msg.sender;
82     emit OwnershipTransferred(address(0), _owner);
83   }
84 
85   /**
86    * @return the address of the owner.
87    */
88   function owner() public view returns(address) {
89     return _owner;
90   }
91 
92   /**
93    * @dev Throws if called by any account other than the owner.
94    */
95   modifier onlyOwner() {
96     require(isOwner());
97     _;
98   }
99 
100   /**
101    * @return true if `msg.sender` is the owner of the contract.
102    */
103   function isOwner() public view returns(bool) {
104     return msg.sender == _owner;
105   }
106 
107   /**
108    * @dev Allows the current owner to relinquish control of the contract.
109    * @notice Renouncing to ownership will leave the contract without an owner.
110    * It will not be possible to call the functions with the `onlyOwner`
111    * modifier anymore.
112    */
113   function renounceOwnership() public onlyOwner {
114     emit OwnershipTransferred(_owner, address(0));
115     _owner = address(0);
116   }
117 
118   /**
119    * @dev Allows the current owner to transfer control of the contract to a newOwner.
120    * @param newOwner The address to transfer ownership to.
121    */
122   function transferOwnership(address newOwner) public onlyOwner {
123     _transferOwnership(newOwner);
124   }
125 
126   /**
127    * @dev Transfers control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function _transferOwnership(address newOwner) internal {
131     require(newOwner != address(0));
132     emit OwnershipTransferred(_owner, newOwner);
133     _owner = newOwner;
134   }
135 }
136 
137 contract DecoBaseProjectsMarketplace is Ownable {
138     using SafeMath for uint256;
139 
140     // `DecoRelay` contract address.
141     address public relayContractAddress;
142 
143     /**
144      * @dev Payble fallback for reverting transactions of any incoming ETH.
145      */
146     function () public payable {
147         require(msg.value == 0, "Blocking any incoming ETH.");
148     }
149 
150     /**
151      * @dev Set the new address of the `DecoRelay` contract.
152      * @param _newAddress An address of the new contract.
153      */
154     function setRelayContractAddress(address _newAddress) external onlyOwner {
155         require(_newAddress != address(0x0), "Relay address must not be 0x0.");
156         relayContractAddress = _newAddress;
157     }
158 
159     /**
160      * @dev Allows to trasnfer any ERC20 tokens from the contract balance to owner's address.
161      * @param _tokenAddress An `address` of an ERC20 token.
162      * @param _tokens An `uint` tokens amount.
163      * @return A `bool` operation result state.
164      */
165     function transferAnyERC20Token(
166         address _tokenAddress,
167         uint _tokens
168     )
169         public
170         onlyOwner
171         returns (bool success)
172     {
173         IERC20 token = IERC20(_tokenAddress);
174         return token.transfer(owner(), _tokens);
175     }
176 }
177 
178 
179 interface IERC20 {
180   function totalSupply() external view returns (uint256);
181 
182   function balanceOf(address who) external view returns (uint256);
183 
184   function allowance(address owner, address spender)
185     external view returns (uint256);
186 
187   function transfer(address to, uint256 value) external returns (bool);
188 
189   function approve(address spender, uint256 value)
190     external returns (bool);
191 
192   function transferFrom(address from, address to, uint256 value)
193     external returns (bool);
194 
195   event Transfer(
196     address indexed from,
197     address indexed to,
198     uint256 value
199   );
200 
201   event Approval(
202     address indexed owner,
203     address indexed spender,
204     uint256 value
205   );
206 }
207 
208 /// @title Contract to store other contracts newest versions addresses and service information.
209 contract DecoRelay is DecoBaseProjectsMarketplace {
210     address public projectsContractAddress;
211     address public milestonesContractAddress;
212     address public escrowFactoryContractAddress;
213     address public arbitrationContractAddress;
214 
215     address public feesWithdrawalAddress;
216 
217     uint8 public shareFee;
218 
219     function setProjectsContractAddress(address _newAddress) external onlyOwner {
220         require(_newAddress != address(0x0), "Address should not be 0x0.");
221         projectsContractAddress = _newAddress;
222     }
223 
224     function setMilestonesContractAddress(address _newAddress) external onlyOwner {
225         require(_newAddress != address(0x0), "Address should not be 0x0.");
226         milestonesContractAddress = _newAddress;
227     }
228 
229     function setEscrowFactoryContractAddress(address _newAddress) external onlyOwner {
230         require(_newAddress != address(0x0), "Address should not be 0x0.");
231         escrowFactoryContractAddress = _newAddress;
232     }
233 
234     function setArbitrationContractAddress(address _newAddress) external onlyOwner {
235         require(_newAddress != address(0x0), "Address should not be 0x0.");
236         arbitrationContractAddress = _newAddress;
237     }
238 
239     function setFeesWithdrawalAddress(address _newAddress) external onlyOwner {
240         require(_newAddress != address(0x0), "Address should not be 0x0.");
241         feesWithdrawalAddress = _newAddress;
242     }
243 
244     function setShareFee(uint8 _shareFee) external onlyOwner {
245         require(_shareFee <= 100, "Deconet share fee must be less than 100%.");
246         shareFee = _shareFee;
247     }
248 }
249 
250 /**
251  * @title Escrow contract, every project deploys a clone and transfer ownership to the project client, so all
252  *        funds not reserved to pay for a milestone can be safely moved in/out.
253  */
254 contract DecoEscrow is DecoBaseProjectsMarketplace {
255     using SafeMath for uint256;
256 
257     // Indicates if the current clone has been initialized.
258     bool internal isInitialized;
259 
260     // Stores share fee that should apply on any successful distribution.
261     uint8 public shareFee;
262 
263     // Authorized party for executing funds distribution operations.
264     address public authorizedAddress;
265 
266     // State variable to track available ETH Escrow owner balance.
267     // Anything that is not blocked or distributed in favor of any party can be withdrawn by the owner.
268     uint public balance;
269 
270     // Mapping of available for withdrawal funds by the address.
271     // Accounted amounts are excluded from the `balance`.
272     mapping (address => uint) public withdrawalAllowanceForAddress;
273 
274     // Maps information about the amount of deposited ERC20 token to the token address.
275     mapping(address => uint) public tokensBalance;
276 
277     /**
278      * Mapping of ERC20 tokens amounts to token addresses that are available for withdrawal for a given address.
279      * Accounted here amounts are excluded from the `tokensBalance`.
280      */
281     mapping(address => mapping(address => uint)) public tokensWithdrawalAllowanceForAddress;
282 
283     // ETH amount blocked in Escrow.
284     // `balance` excludes this amount.
285     uint public blockedBalance;
286 
287     // Mapping of the amount of ERC20 tokens to the the token address that are blocked in Escrow.
288     // A token value in `tokensBalance` excludes stored here amount.
289     mapping(address => uint) public blockedTokensBalance;
290 
291     // Logged when an operation with funds occurred.
292     event FundsOperation (
293         address indexed sender,
294         address indexed target,
295         address tokenAddress,
296         uint amount,
297         PaymentType paymentType,
298         OperationType indexed operationType
299     );
300 
301     // Logged when the given address authorization to distribute Escrow funds changed.
302     event FundsDistributionAuthorization (
303         address targetAddress,
304         bool isAuthorized
305     );
306 
307     // Accepted types of payments.
308     enum PaymentType { Ether, Erc20 }
309 
310     // Possible operations with funds.
311     enum OperationType { Receive, Send, Block, Unblock, Distribute }
312 
313     // Restrict function call to be originated from an address that was authorized to distribute funds.
314     modifier onlyAuthorized() {
315         require(authorizedAddress == msg.sender, "Only authorized addresses allowed.");
316         _;
317     }
318 
319     /**
320      * @dev Default `payable` fallback to accept incoming ETH from any address.
321      */
322     function () public payable {
323         deposit();
324     }
325 
326     /**
327      * @dev Initialize the Escrow clone with default values.
328      * @param _newOwner An address of a new escrow owner.
329      * @param _authorizedAddress An address that will be stored as authorized.
330      */
331     function initialize(
332         address _newOwner,
333         address _authorizedAddress,
334         uint8 _shareFee,
335         address _relayContractAddress
336     )
337         external
338     {
339         require(!isInitialized, "Only uninitialized contracts allowed.");
340         isInitialized = true;
341         authorizedAddress = _authorizedAddress;
342         emit FundsDistributionAuthorization(_authorizedAddress, true);
343         _transferOwnership(_newOwner);
344         shareFee = _shareFee;
345         relayContractAddress = _relayContractAddress;
346     }
347 
348     /**
349      * @dev Start transfering the given amount of the ERC20 tokens available by provided address.
350      * @param _tokenAddress ERC20 token contract address.
351      * @param _amount Amount to transfer from sender`s address.
352      */
353     function depositErc20(address _tokenAddress, uint _amount) external {
354         require(_tokenAddress != address(0x0), "Token Address shouldn't be 0x0.");
355         IERC20 token = IERC20(_tokenAddress);
356         require(
357             token.transferFrom(msg.sender, address(this), _amount),
358             "Transfer operation should be successful."
359         );
360         tokensBalance[_tokenAddress] = tokensBalance[_tokenAddress].add(_amount);
361         emit FundsOperation (
362             msg.sender,
363             address(this),
364             _tokenAddress,
365             _amount,
366             PaymentType.Erc20,
367             OperationType.Receive
368         );
369     }
370 
371     /**
372      * @dev Withdraw the given amount of ETH to sender`s address if allowance or contract balance is sufficient.
373      * @param _amount Amount to withdraw.
374      */
375     function withdraw(uint _amount) external {
376         withdrawForAddress(msg.sender, _amount);
377     }
378 
379     /**
380      * @dev Withdraw the given amount of ERC20 token to sender`s address if allowance or contract balance is sufficient.
381      * @param _tokenAddress ERC20 token address.
382      * @param _amount Amount to withdraw.
383      */
384     function withdrawErc20(address _tokenAddress, uint _amount) external {
385         withdrawErc20ForAddress(msg.sender, _tokenAddress, _amount);
386     }
387 
388     /**
389      * @dev Block funds for future use by authorized party stored in `authorizedAddress`.
390      * @param _amount An uint of Wei to be blocked.
391      */
392     function blockFunds(uint _amount) external onlyAuthorized {
393         require(_amount <= balance, "Amount to block should be less or equal than balance.");
394         balance = balance.sub(_amount);
395         blockedBalance = blockedBalance.add(_amount);
396         emit FundsOperation (
397             address(this),
398             msg.sender,
399             address(0x0),
400             _amount,
401             PaymentType.Ether,
402             OperationType.Block
403         );
404     }
405 
406     /**
407      * @dev Blocks ERC20 tokens funds for future use by authorized party listed in `authorizedAddress`.
408      * @param _tokenAddress An address of ERC20 token.
409      * @param _amount An uint of tokens to be blocked.
410      */
411     function blockTokenFunds(address _tokenAddress, uint _amount) external onlyAuthorized {
412         uint accountedTokensBalance = tokensBalance[_tokenAddress];
413         require(
414             _amount <= accountedTokensBalance,
415             "Tokens mount to block should be less or equal than balance."
416         );
417         tokensBalance[_tokenAddress] = accountedTokensBalance.sub(_amount);
418         blockedTokensBalance[_tokenAddress] = blockedTokensBalance[_tokenAddress].add(_amount);
419         emit FundsOperation (
420             address(this),
421             msg.sender,
422             _tokenAddress,
423             _amount,
424             PaymentType.Erc20,
425             OperationType.Block
426         );
427     }
428 
429     /**
430      * @dev Distribute funds between contract`s balance and allowance for some address.
431      *  Deposit may be returned back to the contract address, i.e. to the escrow owner.
432      *  Or deposit may flow to the allowance for an address as a result of an evidence
433      *  given by an authorized party about fullfilled obligations.
434      *  **IMPORTANT** This operation includes fees deduction.
435      * @param _destination Destination address for funds distribution.
436      * @param _amount Amount to distribute in favor of a destination address.
437      */
438     function distributeFunds(
439         address _destination,
440         uint _amount
441     )
442         external
443         onlyAuthorized
444     {
445         require(
446             _amount <= blockedBalance,
447             "Amount to distribute should be less or equal than blocked balance."
448         );
449         uint amount = _amount;
450         if (shareFee > 0 && relayContractAddress != address(0x0)) {
451             DecoRelay relayContract = DecoRelay(relayContractAddress);
452             address feeDestination = relayContract.feesWithdrawalAddress();
453             uint fee = amount.mul(shareFee).div(100);
454             amount = amount.sub(fee);
455             blockedBalance = blockedBalance.sub(fee);
456             withdrawalAllowanceForAddress[feeDestination] =
457                 withdrawalAllowanceForAddress[feeDestination].add(fee);
458             emit FundsOperation(
459                 msg.sender,
460                 feeDestination,
461                 address(0x0),
462                 fee,
463                 PaymentType.Ether,
464                 OperationType.Distribute
465             );
466         }
467         if (_destination == owner()) {
468             unblockFunds(amount);
469             return;
470         }
471         blockedBalance = blockedBalance.sub(amount);
472         withdrawalAllowanceForAddress[_destination] = withdrawalAllowanceForAddress[_destination].add(amount);
473         emit FundsOperation(
474             msg.sender,
475             _destination,
476             address(0x0),
477             amount,
478             PaymentType.Ether,
479             OperationType.Distribute
480         );
481     }
482 
483     /**
484      * @dev Distribute ERC20 token funds between contract`s balance and allowanc for some address.
485      *  Deposit may be returned back to the contract address, i.e. to the escrow owner.
486      *  Or deposit may flow to the allowance for an address as a result of an evidence
487      *  given by authorized party about fullfilled obligations.
488      *  **IMPORTANT** This operation includes fees deduction.
489      * @param _destination Destination address for funds distribution.
490      * @param _tokenAddress ERC20 Token address.
491      * @param _amount Amount to distribute in favor of a destination address.
492      */
493     function distributeTokenFunds(
494         address _destination,
495         address _tokenAddress,
496         uint _amount
497     )
498         external
499         onlyAuthorized
500     {
501         require(
502             _amount <= blockedTokensBalance[_tokenAddress],
503             "Amount to distribute should be less or equal than blocked balance."
504         );
505         uint amount = _amount;
506         if (shareFee > 0 && relayContractAddress != address(0x0)) {
507             DecoRelay relayContract = DecoRelay(relayContractAddress);
508             address feeDestination = relayContract.feesWithdrawalAddress();
509             uint fee = amount.mul(shareFee).div(100);
510             amount = amount.sub(fee);
511             blockedTokensBalance[_tokenAddress] = blockedTokensBalance[_tokenAddress].sub(fee);
512             uint allowance = tokensWithdrawalAllowanceForAddress[feeDestination][_tokenAddress];
513             tokensWithdrawalAllowanceForAddress[feeDestination][_tokenAddress] = allowance.add(fee);
514             emit FundsOperation(
515                 msg.sender,
516                 feeDestination,
517                 _tokenAddress,
518                 fee,
519                 PaymentType.Erc20,
520                 OperationType.Distribute
521             );
522         }
523         if (_destination == owner()) {
524             unblockTokenFunds(_tokenAddress, amount);
525             return;
526         }
527         blockedTokensBalance[_tokenAddress] = blockedTokensBalance[_tokenAddress].sub(amount);
528         uint allowanceForSender = tokensWithdrawalAllowanceForAddress[_destination][_tokenAddress];
529         tokensWithdrawalAllowanceForAddress[_destination][_tokenAddress] = allowanceForSender.add(amount);
530         emit FundsOperation(
531             msg.sender,
532             _destination,
533             _tokenAddress,
534             amount,
535             PaymentType.Erc20,
536             OperationType.Distribute
537         );
538     }
539 
540     /**
541      * @dev Withdraws ETH amount from the contract's balance to the provided address.
542      * @param _targetAddress An `address` for transfer ETH to.
543      * @param _amount An `uint` amount to be transfered.
544      */
545     function withdrawForAddress(address _targetAddress, uint _amount) public {
546         require(
547             _amount <= address(this).balance,
548             "Amount to withdraw should be less or equal than balance."
549         );
550         if (_targetAddress == owner()) {
551             balance = balance.sub(_amount);
552         } else {
553             uint withdrawalAllowance = withdrawalAllowanceForAddress[_targetAddress];
554             withdrawalAllowanceForAddress[_targetAddress] = withdrawalAllowance.sub(_amount);
555         }
556         _targetAddress.transfer(_amount);
557         emit FundsOperation (
558             address(this),
559             _targetAddress,
560             address(0x0),
561             _amount,
562             PaymentType.Ether,
563             OperationType.Send
564         );
565     }
566 
567     /**
568      * @dev Withdraws ERC20 token amount from the contract's balance to the provided address.
569      * @param _targetAddress An `address` for transfer tokens to.
570      * @param _tokenAddress An `address` of ERC20 token.
571      * @param _amount An `uint` amount of ERC20 tokens to be transfered.
572      */
573     function withdrawErc20ForAddress(address _targetAddress, address _tokenAddress, uint _amount) public {
574         IERC20 token = IERC20(_tokenAddress);
575         require(
576             _amount <= token.balanceOf(this),
577             "Token amount to withdraw should be less or equal than balance."
578         );
579         if (_targetAddress == owner()) {
580             tokensBalance[_tokenAddress] = tokensBalance[_tokenAddress].sub(_amount);
581         } else {
582             uint tokenWithdrawalAllowance = getTokenWithdrawalAllowance(_targetAddress, _tokenAddress);
583             tokensWithdrawalAllowanceForAddress[_targetAddress][_tokenAddress] = tokenWithdrawalAllowance.sub(
584                 _amount
585             );
586         }
587         token.transfer(_targetAddress, _amount);
588         emit FundsOperation (
589             address(this),
590             _targetAddress,
591             _tokenAddress,
592             _amount,
593             PaymentType.Erc20,
594             OperationType.Send
595         );
596     }
597 
598     /**
599      * @dev Returns allowance for withdrawing the given token for sender address.
600      * @param _tokenAddress An address of ERC20 token.
601      * @return An uint value of allowance.
602      */
603     function getTokenWithdrawalAllowance(address _account, address _tokenAddress) public view returns(uint) {
604         return tokensWithdrawalAllowanceForAddress[_account][_tokenAddress];
605     }
606 
607     /**
608      * @dev Accept and account incoming deposit in contract state.
609      */
610     function deposit() public payable {
611         require(msg.value > 0, "Deposited amount should be greater than 0.");
612         balance = balance.add(msg.value);
613         emit FundsOperation (
614             msg.sender,
615             address(this),
616             address(0x0),
617             msg.value,
618             PaymentType.Ether,
619             OperationType.Receive
620         );
621     }
622 
623     /**
624      * @dev Unblock blocked funds and make them available to the contract owner.
625      * @param _amount An uint of Wei to be unblocked.
626      */
627     function unblockFunds(uint _amount) public onlyAuthorized {
628         require(
629             _amount <= blockedBalance,
630             "Amount to unblock should be less or equal than balance"
631         );
632         blockedBalance = blockedBalance.sub(_amount);
633         balance = balance.add(_amount);
634         emit FundsOperation (
635             msg.sender,
636             address(this),
637             address(0x0),
638             _amount,
639             PaymentType.Ether,
640             OperationType.Unblock
641         );
642     }
643 
644     /**
645      * @dev Unblock blocked token funds and make them available to the contract owner.
646      * @param _amount An uint of Wei to be unblocked.
647      */
648     function unblockTokenFunds(address _tokenAddress, uint _amount) public onlyAuthorized {
649         uint accountedBlockedTokensAmount = blockedTokensBalance[_tokenAddress];
650         require(
651             _amount <= accountedBlockedTokensAmount,
652             "Tokens amount to unblock should be less or equal than balance"
653         );
654         blockedTokensBalance[_tokenAddress] = accountedBlockedTokensAmount.sub(_amount);
655         tokensBalance[_tokenAddress] = tokensBalance[_tokenAddress].add(_amount);
656         emit FundsOperation (
657             msg.sender,
658             address(this),
659             _tokenAddress,
660             _amount,
661             PaymentType.Erc20,
662             OperationType.Unblock
663         );
664     }
665 
666     /**
667      * @dev Override base contract logic to block this operation for Escrow contract.
668      * @param _tokenAddress An `address` of an ERC20 token.
669      * @param _tokens An `uint` tokens amount.
670      * @return A `bool` operation result state.
671      */
672     function transferAnyERC20Token(
673         address _tokenAddress,
674         uint _tokens
675     )
676         public
677         onlyOwner
678         returns (bool success)
679     {
680         return false;
681     }
682 }
683 
684 contract CloneFactory {
685 
686   event CloneCreated(address indexed target, address clone);
687 
688   function createClone(address target) internal returns (address result) {
689     bytes memory clone = hex"600034603b57603080600f833981f36000368180378080368173bebebebebebebebebebebebebebebebebebebebe5af43d82803e15602c573d90f35b3d90fd";
690     bytes20 targetBytes = bytes20(target);
691     for (uint i = 0; i < 20; i++) {
692       clone[26 + i] = targetBytes[i];
693     }
694     assembly {
695       let len := mload(clone)
696       let data := add(clone, 0x20)
697       result := create(0, data, len)
698     }
699   }
700 }
701 
702 /**
703  * @title Utility contract that provides a way to execute cheap clone deployment of the DecoEscrow contract
704  *        on chain.
705  */
706 contract DecoEscrowFactory is DecoBaseProjectsMarketplace, CloneFactory {
707 
708     // Escrow master-contract address.
709     address public libraryAddress;
710 
711     // Logged when a new Escrow clone is deployed to the chain.
712     event EscrowCreated(address newEscrowAddress);
713 
714     /**
715      * @dev Constructor for the contract.
716      * @param _libraryAddress Escrow master-contract address.
717      */
718     constructor(address _libraryAddress) public {
719         libraryAddress = _libraryAddress;
720     }
721 
722     /**
723      * @dev Updates library address with the given value.
724      * @param _libraryAddress Address of a new base contract.
725      */
726     function setLibraryAddress(address _libraryAddress) external onlyOwner {
727         require(libraryAddress != _libraryAddress);
728         require(_libraryAddress != address(0x0));
729 
730         libraryAddress = _libraryAddress;
731     }
732 
733     /**
734      * @dev Create Escrow clone.
735      * @param _ownerAddress An address of the Escrow contract owner.
736      * @param _authorizedAddress An addresses that is going to be authorized in Escrow contract.
737      */
738     function createEscrow(
739         address _ownerAddress,
740         address _authorizedAddress
741     )
742         external
743         returns(address)
744     {
745         address clone = createClone(libraryAddress);
746         DecoRelay relay = DecoRelay(relayContractAddress);
747         DecoEscrow(clone).initialize(
748             _ownerAddress,
749             _authorizedAddress,
750             relay.shareFee(),
751             relayContractAddress
752         );
753         emit EscrowCreated(clone);
754         return clone;
755     }
756 }
757 
758 contract IDecoArbitrationTarget {
759 
760     /**
761      * @dev Prepare arbitration target for a started dispute.
762      * @param _idHash A `bytes32` hash of id.
763      */
764     function disputeStartedFreeze(bytes32 _idHash) public;
765 
766     /**
767      * @dev React to an active dispute settlement with given parameters.
768      * @param _idHash A `bytes32` hash of id.
769      * @param _respondent An `address` of a respondent.
770      * @param _respondentShare An `uint8` share for the respondent.
771      * @param _initiator An `address` of a dispute initiator.
772      * @param _initiatorShare An `uint8` share for the initiator.
773      * @param _isInternal A `bool` indicating if dispute was settled by participants without an arbiter.
774      * @param _arbiterWithdrawalAddress An `address` for sending out arbiter compensation.
775      */
776     function disputeSettledTerminate(
777         bytes32 _idHash,
778         address _respondent,
779         uint8 _respondentShare,
780         address _initiator,
781         uint8 _initiatorShare,
782         bool _isInternal,
783         address _arbiterWithdrawalAddress
784     )
785         public;
786 
787     /**
788      * @dev Check eligibility of a given address to perform operations.
789      * @param _idHash A `bytes32` hash of id.
790      * @param _addressToCheck An `address` to check.
791      * @return A `bool` check status.
792      */
793     function checkEligibility(bytes32 _idHash, address _addressToCheck) public view returns(bool);
794 
795     /**
796      * @dev Check if target is ready for a dispute.
797      * @param _idHash A `bytes32` hash of id.
798      * @return A `bool` check status.
799      */
800     function canStartDispute(bytes32 _idHash) public view returns(bool);
801 }
802 
803 library SafeMath {
804 
805   /**
806   * @dev Multiplies two numbers, reverts on overflow.
807   */
808   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
809     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
810     // benefit is lost if 'b' is also tested.
811     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
812     if (a == 0) {
813       return 0;
814     }
815 
816     uint256 c = a * b;
817     require(c / a == b);
818 
819     return c;
820   }
821 
822   /**
823   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
824   */
825   function div(uint256 a, uint256 b) internal pure returns (uint256) {
826     require(b > 0); // Solidity only automatically asserts when dividing by 0
827     uint256 c = a / b;
828     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
829 
830     return c;
831   }
832 
833   /**
834   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
835   */
836   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
837     require(b <= a);
838     uint256 c = a - b;
839 
840     return c;
841   }
842 
843   /**
844   * @dev Adds two numbers, reverts on overflow.
845   */
846   function add(uint256 a, uint256 b) internal pure returns (uint256) {
847     uint256 c = a + b;
848     require(c >= a);
849 
850     return c;
851   }
852 
853   /**
854   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
855   * reverts when dividing by zero.
856   */
857   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
858     require(b != 0);
859     return a % b;
860   }
861 }
862 
863 interface IDecoArbitration {
864 
865     /**
866      * @dev Should be logged upon dispute start.
867      */
868     event LogStartedDispute(
869         address indexed sender,
870         bytes32 indexed idHash,
871         uint timestamp,
872         int respondentShareProposal
873     );
874 
875     /**
876      * @dev Should be logged upon proposal rejection.
877      */
878     event LogRejectedProposal(
879         address indexed sender,
880         bytes32 indexed idHash,
881         uint timestamp,
882         uint8 rejectedProposal
883     );
884 
885     /**
886      * @dev Should be logged upon dispute settlement.
887      */
888     event LogSettledDispute(
889         address indexed sender,
890         bytes32 indexed idHash,
891         uint timestamp,
892         uint8 respondentShare,
893         uint8 initiatorShare
894     );
895 
896     /**
897      * @dev Should be logged when contract owner updates fees.
898      */
899     event LogFeesUpdated(
900         uint timestamp,
901         uint fixedFee,
902         uint8 shareFee
903     );
904 
905     /**
906      * @dev Should be logged when time limit to accept/reject proposal for respondent is updated.
907      */
908     event LogProposalTimeLimitUpdated(
909         uint timestamp,
910         uint proposalActionTimeLimit
911     );
912 
913     /**
914      * @dev Should be logged when the withdrawal address for the contract owner changed.
915      */
916     event LogWithdrawalAddressChanged(
917         uint timestamp,
918         address newWithdrawalAddress
919     );
920 
921     /**
922      * @notice Start dispute for the given project.
923      * @dev This call should log event and save dispute information and notify `IDecoArbitrationTarget` object
924      *      about started dispute. Dipsute can be started only if target instance call of
925      *      `canStartDispute` method confirms that state is valid. Also, txn sender and respondent addresses
926      *      eligibility must be confirmed by arbitation target `checkEligibility` method call.
927      * @param _idHash A `bytes32` hash of a project id.
928      * @param _respondent An `address` of the second paty involved in the dispute.
929      * @param _respondentShareProposal An `int` value indicating percentage of disputed funds
930      *  proposed to the respondent. Valid values range is 0-100, different values are considered as 'No Proposal'.
931      *  When provided percentage is 100 then this dispute is processed automatically,
932      *  and all funds are distributed in favor of the respondent.
933      */
934     function startDispute(bytes32 _idHash, address _respondent, int _respondentShareProposal) external;
935 
936     /**
937      * @notice Accept active dispute proposal, sender should be the respondent.
938      * @dev Respondent of a dispute can accept existing proposal and if proposal exists then `settleDispute`
939      *      method should be called with proposal value. Time limit for respondent to accept/reject proposal
940      *      must not be exceeded.
941      * @param _idHash A `bytes32` hash of a project id.
942      */
943     function acceptProposal(bytes32 _idHash) external;
944 
945     /**
946      * @notice Reject active dispute proposal and escalate dispute.
947      * @dev Txn sender should be dispute's respondent. Dispute automatically gets escalated to this contract
948      *      owner aka arbiter. Proposal must exist, otherwise this method should do nothing. When respondent
949      *      rejects proposal then it should get removed and corresponding event should be logged.
950      *      There should be a time limit for a respondent to reject a given proposal, and if it is overdue
951      *      then arbiter should take on a dispute to settle it.
952      * @param _idHash A `bytes32` hash of a project id.
953      */
954     function rejectProposal(bytes32 _idHash) external;
955 
956     /**
957      * @notice Settle active dispute.
958      * @dev Sender should be the current contract or its owner(arbiter). Action is possible only when there is no active
959      *      proposal or time to accept the proposal is over. Sum of shares should be 100%. Should notify target
960      *      instance about a dispute settlement via `disputeSettledTerminate` method call. Also corresponding
961      *      event must be emitted.
962      * @param _idHash A `bytes32` hash of a project id.
963      * @param _respondentShare An `uint` percents of respondent share.
964      * @param _initiatorShare An `uint` percents of initiator share.
965      */
966     function settleDispute(bytes32 _idHash, uint _respondentShare, uint _initiatorShare) external;
967 
968     /**
969      * @return Retuns this arbitration contract withdrawal `address`.
970      */
971     function getWithdrawalAddress() external view returns(address);
972 
973     /**
974      * @return The arbitration contract fixed `uint` fee and `uint8` share of all disputed funds fee.
975      */
976     function getFixedAndShareFees() external view returns(uint, uint8);
977 
978     /**
979      * @return An `uint` time limit for accepting/rejecting a proposal by respondent.
980      */
981     function getTimeLimitForReplyOnProposal() external view returns(uint);
982 
983 }
984 
985 
986 
987 pragma solidity 0.4.25;
988 
989 
990 
991 
992 /// @title Contract for Project events and actions handling.
993 contract DecoProjects is DecoBaseProjectsMarketplace {
994     using SafeMath for uint256;
995     using ECDSA for bytes32;
996 
997     // struct for project details
998     struct Project {
999         string agreementId;
1000         address client;
1001         address maker;
1002         address arbiter;
1003         address escrowContractAddress;
1004         uint startDate;
1005         uint endDate;
1006         uint8 milestoneStartWindow;
1007         uint8 feedbackWindow;
1008         uint8 milestonesCount;
1009 
1010         uint8 customerSatisfaction;
1011         uint8 makerSatisfaction;
1012 
1013         bool agreementsEncrypted;
1014     }
1015 
1016     struct EIP712Domain {
1017         string  name;
1018         string  version;
1019         uint256 chainId;
1020         address verifyingContract;
1021     }
1022 
1023     struct Proposal {
1024         string agreementId;
1025         address arbiter;
1026     }
1027 
1028     bytes32 constant private EIP712DOMAIN_TYPEHASH = keccak256(
1029         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1030     );
1031 
1032     bytes32 constant private PROPOSAL_TYPEHASH = keccak256(
1033         "Proposal(string agreementId,address arbiter)"
1034     );
1035 
1036     bytes32 private DOMAIN_SEPARATOR;
1037 
1038     // enumeration to describe possible project states for easier state changes reporting.
1039     enum ProjectState { Active, Completed, Terminated }
1040 
1041     // enumeration to describe possible satisfaction score types.
1042     enum ScoreType { CustomerSatisfaction, MakerSatisfaction }
1043 
1044     // Logged when a project state changes.
1045     event LogProjectStateUpdate (
1046         bytes32 indexed agreementHash,
1047         address updatedBy,
1048         uint timestamp,
1049         ProjectState state
1050     );
1051 
1052     // Logged when either party sets satisfaction score after the completion of a project.
1053     event LogProjectRated (
1054         bytes32 indexed agreementHash,
1055         address indexed ratedBy,
1056         address indexed ratingTarget,
1057         uint8 rating,
1058         uint timestamp
1059     );
1060 
1061     // maps the agreement`s unique hash to the project details.
1062     mapping (bytes32 => Project) public projects;
1063 
1064     // maps hashes of all maker's projects to the maker's address.
1065     mapping (address => bytes32[]) public makerProjects;
1066 
1067     // maps hashes of all client's projects to the client's address.
1068     mapping (address => bytes32[]) public clientProjects;
1069 
1070     // maps arbiter's fixed fee to a project.
1071     mapping (bytes32 => uint) public projectArbiterFixedFee;
1072 
1073     // maps arbiter's share fee to a project.
1074     mapping (bytes32 => uint8) public projectArbiterShareFee;
1075 
1076     // Modifier to restrict method to be called either by project`s owner or maker
1077     modifier eitherClientOrMaker(bytes32 _agreementHash) {
1078         Project memory project = projects[_agreementHash];
1079         require(
1080             project.client == msg.sender || project.maker == msg.sender,
1081             "Only project owner or maker can perform this operation."
1082         );
1083         _;
1084     }
1085 
1086     // Modifier to restrict method to be called either by project`s owner or maker
1087     modifier eitherClientOrMakerOrMilestoneContract(bytes32 _agreementHash) {
1088         Project memory project = projects[_agreementHash];
1089         DecoRelay relay = DecoRelay(relayContractAddress);
1090         require(
1091             project.client == msg.sender ||
1092             project.maker == msg.sender ||
1093             relay.milestonesContractAddress() == msg.sender,
1094             "Only project owner or maker can perform this operation."
1095         );
1096         _;
1097     }
1098 
1099     // Modifier to restrict method to be called by the milestones contract.
1100     modifier onlyMilestonesContract(bytes32 _agreementHash) {
1101         DecoRelay relay = DecoRelay(relayContractAddress);
1102         require(
1103             msg.sender == relay.milestonesContractAddress(),
1104             "Only milestones contract can perform this operation."
1105         );
1106         Project memory project = projects[_agreementHash];
1107         _;
1108     }
1109 
1110     constructor (uint256 _chainId) public {
1111         require(_chainId != 0, "You must specify a nonzero chainId");
1112 
1113         DOMAIN_SEPARATOR = hash(EIP712Domain({
1114             name: "Deco.Network",
1115             version: "1",
1116             chainId: _chainId,
1117             verifyingContract: address(this)
1118         }));
1119     }
1120 
1121     /**
1122      * @dev Creates a new milestone-based project with pre-selected maker and owner. All parameters are required.
1123      * @param _agreementId A `string` unique id of the agreement document for that project.
1124      * @param _client An `address` of the project owner.
1125      * @param _arbiter An `address` of the referee to settle all escalated disputes between parties.
1126      * @param _maker An `address` of the project`s maker.
1127      * @param _makersSignature A `bytes` digital signature of the maker to proof the agreement acceptance.
1128      * @param _milestonesCount An `uint8` count of planned milestones for the project.
1129      * @param _milestoneStartWindow An `uint8` count of days project`s owner has to start the next milestone.
1130      *        If this time is exceeded then the maker can terminate the project.
1131      * @param _feedbackWindow An `uint8` time in days project`s owner has to provide feedback for the last milestone.
1132      *                        If that time is exceeded then maker can terminate the project and get paid for awaited
1133      *                        milestone.
1134      * @param _agreementEncrypted A `bool` flag indicating whether or not the agreement is encrypted.
1135      */
1136     function startProject(
1137         string _agreementId,
1138         address _client,
1139         address _arbiter,
1140         address _maker,
1141         bytes _makersSignature,
1142         uint8 _milestonesCount,
1143         uint8 _milestoneStartWindow,
1144         uint8 _feedbackWindow,
1145         bool _agreementEncrypted
1146     )
1147         external
1148     {
1149         require(msg.sender == _client, "Only the client can kick off the project.");
1150         require(_client != _maker, "Client can`t be a maker on her own project.");
1151         require(_arbiter != _maker && _arbiter != _client, "Arbiter must not be a client nor a maker.");
1152 
1153         require(
1154             isMakersSignatureValid(_maker, _makersSignature, _agreementId, _arbiter),
1155             "Maker should sign the hash of immutable agreement doc."
1156         );
1157         require(_milestonesCount >= 1 && _milestonesCount <= 24, "Milestones count is not in the allowed 1-24 range.");
1158         bytes32 hash = keccak256(_agreementId);
1159         require(projects[hash].client == address(0x0), "Project shouldn't exist yet.");
1160 
1161         saveCurrentArbitrationFees(_arbiter, hash);
1162 
1163         address newEscrowCloneAddress = deployEscrowClone(msg.sender);
1164         projects[hash] = Project(
1165             _agreementId,
1166             msg.sender,
1167             _maker,
1168             _arbiter,
1169             newEscrowCloneAddress,
1170             now,
1171             0, // end date is unknown yet
1172             _milestoneStartWindow,
1173             _feedbackWindow,
1174             _milestonesCount,
1175             0, // CSAT is 0 to indicate that it isn't set by maker yet
1176             0, // MSAT is 0 to indicate that it isn't set by client yet
1177             _agreementEncrypted
1178         );
1179         makerProjects[_maker].push(hash);
1180         clientProjects[_client].push(hash);
1181         emit LogProjectStateUpdate(hash, msg.sender, now, ProjectState.Active);
1182     }
1183 
1184     /**
1185      * @dev Terminate the project.
1186      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1187      */
1188     function terminateProject(bytes32 _agreementHash)
1189         external
1190         eitherClientOrMakerOrMilestoneContract(_agreementHash)
1191     {
1192         Project storage project = projects[_agreementHash];
1193         require(project.client != address(0x0), "Only allowed for existing projects.");
1194         require(project.endDate == 0, "Only allowed for active projects.");
1195         address milestoneContractAddress = DecoRelay(relayContractAddress).milestonesContractAddress();
1196         if (msg.sender != milestoneContractAddress) {
1197             DecoMilestones milestonesContract = DecoMilestones(milestoneContractAddress);
1198             milestonesContract.terminateLastMilestone(_agreementHash, msg.sender);
1199         }
1200 
1201         project.endDate = now;
1202         emit LogProjectStateUpdate(_agreementHash, msg.sender, now, ProjectState.Terminated);
1203     }
1204 
1205     /**
1206      * @dev Complete the project.
1207      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1208      */
1209     function completeProject(
1210         bytes32 _agreementHash
1211     )
1212         external
1213         onlyMilestonesContract(_agreementHash)
1214     {
1215         Project storage project = projects[_agreementHash];
1216         require(project.client != address(0x0), "Only allowed for existing projects.");
1217         require(project.endDate == 0, "Only allowed for active projects.");
1218         projects[_agreementHash].endDate = now;
1219         DecoMilestones milestonesContract = DecoMilestones(
1220             DecoRelay(relayContractAddress).milestonesContractAddress()
1221         );
1222         bool isLastMilestoneAccepted;
1223         uint8 milestoneNumber;
1224         (isLastMilestoneAccepted, milestoneNumber) = milestonesContract.isLastMilestoneAccepted(
1225             _agreementHash
1226         );
1227         require(
1228             milestoneNumber == projects[_agreementHash].milestonesCount,
1229             "The last milestone should be the last for that project."
1230         );
1231         require(isLastMilestoneAccepted, "Only allowed when all milestones are completed.");
1232         emit LogProjectStateUpdate(_agreementHash, msg.sender, now, ProjectState.Completed);
1233     }
1234 
1235     /**
1236      * @dev Rate the second party on the project.
1237      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1238      * @param _rating An `uint8` satisfaction score of either client or maker.
1239               Min value is 1, max is 10.
1240      */
1241     function rateProjectSecondParty(
1242         bytes32 _agreementHash,
1243         uint8 _rating
1244     )
1245         external
1246         eitherClientOrMaker(_agreementHash)
1247     {
1248         require(_rating >= 1 && _rating <= 10, "Project rating should be in the range 1-10.");
1249         Project storage project = projects[_agreementHash];
1250         require(project.endDate != 0, "Only allowed for active projects.");
1251         address ratingTarget;
1252         if (msg.sender == project.client) {
1253             require(project.customerSatisfaction == 0, "CSAT is allowed to provide only once.");
1254             project.customerSatisfaction = _rating;
1255             ratingTarget = project.maker;
1256         } else {
1257             require(project.makerSatisfaction == 0, "MSAT is allowed to provide only once.");
1258             project.makerSatisfaction = _rating;
1259             ratingTarget = project.client;
1260         }
1261         emit LogProjectRated(_agreementHash, msg.sender, ratingTarget, _rating, now);
1262     }
1263 
1264     /**
1265      * @dev Query for getting the address of Escrow contract clone deployed for the given project.
1266      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1267      * @return An `address` of a clone.
1268      */
1269     function getProjectEscrowAddress(bytes32 _agreementHash) public view returns(address) {
1270         return projects[_agreementHash].escrowContractAddress;
1271     }
1272 
1273     /**
1274      * @dev Query for getting the address of a client for the given project.
1275      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1276      * @return An `address` of a client.
1277      */
1278     function getProjectClient(bytes32 _agreementHash) public view returns(address) {
1279         return projects[_agreementHash].client;
1280     }
1281 
1282     /**
1283      * @dev Query for getting the address of a maker for the given project.
1284      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1285      * @return An `address` of a maker.
1286      */
1287     function getProjectMaker(bytes32 _agreementHash) public view returns(address) {
1288         return projects[_agreementHash].maker;
1289     }
1290 
1291     /**
1292      * @dev Query for getting the address of an arbiter for the given project.
1293      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1294      * @return An `address` of an arbiter.
1295      */
1296     function getProjectArbiter(bytes32 _agreementHash) public view returns(address) {
1297         return projects[_agreementHash].arbiter;
1298     }
1299 
1300     /**
1301      * @dev Query for getting the feedback window for a client for the given project.
1302      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1303      * @return An `uint8` feedback window in days.
1304      */
1305     function getProjectFeedbackWindow(bytes32 _agreementHash) public view returns(uint8) {
1306         return projects[_agreementHash].feedbackWindow;
1307     }
1308 
1309     /**
1310      * @dev Query for getting the milestone start window for a client for the given project.
1311      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1312      * @return An `uint8` milestone start window in days.
1313      */
1314     function getProjectMilestoneStartWindow(bytes32 _agreementHash) public view returns(uint8) {
1315         return projects[_agreementHash].milestoneStartWindow;
1316     }
1317 
1318     /**
1319      * @dev Query for getting the start date for the given project.
1320      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1321      * @return An `uint` start date.
1322      */
1323     function getProjectStartDate(bytes32 _agreementHash) public view returns(uint) {
1324         return projects[_agreementHash].startDate;
1325     }
1326 
1327     /**
1328      * @dev Calculates sum and number of CSAT scores of ended & rated projects for the given maker`s address.
1329      * @param _maker An `address` of the maker to look up.
1330      * @return An `uint` sum of all scores and an `uint` number of projects counted in sum.
1331      */
1332     function makersAverageRating(address _maker) public view returns(uint, uint) {
1333         return calculateScore(_maker, ScoreType.CustomerSatisfaction);
1334     }
1335 
1336     /**
1337      * @dev Calculates sum and number of MSAT scores of ended & rated projects for the given client`s address.
1338      * @param _client An `address` of the client to look up.
1339      * @return An `uint` sum of all scores and an `uint` number of projects counted in sum.
1340      */
1341     function clientsAverageRating(address _client) public view returns(uint, uint) {
1342         return calculateScore(_client, ScoreType.MakerSatisfaction);
1343     }
1344 
1345     /**
1346      * @dev Returns hashes of all client`s projects
1347      * @param _client An `address` to look up.
1348      * @return `bytes32[]` of projects hashes.
1349      */
1350     function getClientProjects(address _client) public view returns(bytes32[]) {
1351         return clientProjects[_client];
1352     }
1353 
1354     /**
1355       @dev Returns hashes of all maker`s projects
1356      * @param _maker An `address` to look up.
1357      * @return `bytes32[]` of projects hashes.
1358      */
1359     function getMakerProjects(address _maker) public view returns(bytes32[]) {
1360         return makerProjects[_maker];
1361     }
1362 
1363     /**
1364      * @dev Checks if a project with the given hash exists.
1365      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1366      * @return A `bool` stating for the project`s existence.
1367     */
1368     function checkIfProjectExists(bytes32 _agreementHash) public view returns(bool) {
1369         return projects[_agreementHash].client != address(0x0);
1370     }
1371 
1372     /**
1373      * @dev Query for getting end date of the given project.
1374      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1375      * @return An `uint` end time of the project
1376      */
1377     function getProjectEndDate(bytes32 _agreementHash) public view returns(uint) {
1378         return projects[_agreementHash].endDate;
1379     }
1380 
1381     /**
1382      * @dev Returns preconfigured count of milestones for a project with the given hash.
1383      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1384      * @return An `uint8` count of milestones set upon the project creation.
1385     */
1386     function getProjectMilestonesCount(bytes32 _agreementHash) public view returns(uint8) {
1387         return projects[_agreementHash].milestonesCount;
1388     }
1389 
1390     /**
1391      * @dev Returns configured for the given project arbiter fees.
1392      * @param _agreementHash A `bytes32` hash of the project`s agreement id.
1393      * @return An `uint` fixed fee and an `uint8` share fee of the project's arbiter.
1394      */
1395     function getProjectArbitrationFees(bytes32 _agreementHash) public view returns(uint, uint8) {
1396         return (
1397             projectArbiterFixedFee[_agreementHash],
1398             projectArbiterShareFee[_agreementHash]
1399         );
1400     }
1401 
1402     function getInfoForDisputeAndValidate(
1403         bytes32 _agreementHash,
1404         address _respondent,
1405         address _initiator,
1406         address _arbiter
1407     )
1408         public
1409         view
1410         returns(uint, uint8, address)
1411     {
1412         require(checkIfProjectExists(_agreementHash), "Project must exist.");
1413         Project memory project = projects[_agreementHash];
1414         address client = project.client;
1415         address maker = project.maker;
1416         require(project.arbiter == _arbiter, "Arbiter should be same as saved in project.");
1417         require(
1418             (_initiator == client && _respondent == maker) ||
1419             (_initiator == maker && _respondent == client),
1420             "Initiator and respondent must be different and equal to maker/client addresses."
1421         );
1422         (uint fixedFee, uint8 shareFee) = getProjectArbitrationFees(_agreementHash);
1423         return (fixedFee, shareFee, project.escrowContractAddress);
1424     }
1425 
1426     /**
1427      * @dev Pulls the current arbitration contract fixed & share fees and save them for a project.
1428      * @param _arbiter An `address` of arbitration contract.
1429      * @param _agreementHash A `bytes32` hash of agreement id.
1430      */
1431     function saveCurrentArbitrationFees(address _arbiter, bytes32 _agreementHash) internal {
1432         IDecoArbitration arbitration = IDecoArbitration(_arbiter);
1433         uint fixedFee;
1434         uint8 shareFee;
1435         (fixedFee, shareFee) = arbitration.getFixedAndShareFees();
1436         projectArbiterFixedFee[_agreementHash] = fixedFee;
1437         projectArbiterShareFee[_agreementHash] = shareFee;
1438     }
1439 
1440     /**
1441      * @dev Calculates the sum of scores and the number of ended and rated projects for the given client`s or
1442      *      maker`s address.
1443      * @param _address An `address` to look up.
1444      * @param _scoreType A `ScoreType` indicating what score should be calculated.
1445      *        `CustomerSatisfaction` type means that CSAT score for the given address as a maker should be calculated.
1446      *        `MakerSatisfaction` type means that MSAT score for the given address as a client should be calculated.
1447      * @return An `uint` sum of all scores and an `uint` number of projects counted in sum.
1448      */
1449     function calculateScore(
1450         address _address,
1451         ScoreType _scoreType
1452     )
1453         internal
1454         view
1455         returns(uint, uint)
1456     {
1457         bytes32[] memory allProjectsHashes = getProjectsByScoreType(_address, _scoreType);
1458         uint rating = 0;
1459         uint endedProjectsCount = 0;
1460         for (uint index = 0; index < allProjectsHashes.length; index++) {
1461             bytes32 agreementHash = allProjectsHashes[index];
1462             if (projects[agreementHash].endDate == 0) {
1463                 continue;
1464             }
1465             uint8 score = getProjectScoreByType(agreementHash, _scoreType);
1466             if (score == 0) {
1467                 continue;
1468             }
1469             endedProjectsCount++;
1470             rating = rating.add(score);
1471         }
1472         return (rating, endedProjectsCount);
1473     }
1474 
1475     /**
1476      * @dev Returns all projects for the given address depending on the provided score type.
1477      * @param _address An `address` to look up.
1478      * @param _scoreType A `ScoreType` to identify projects source.
1479      * @return `bytes32[]` of projects hashes either from `clientProjects` or `makerProjects` storage arrays.
1480      */
1481     function getProjectsByScoreType(address _address, ScoreType _scoreType) internal view returns(bytes32[]) {
1482         if (_scoreType == ScoreType.CustomerSatisfaction) {
1483             return makerProjects[_address];
1484         } else {
1485             return clientProjects[_address];
1486         }
1487     }
1488 
1489     /**
1490      * @dev Returns project score by the given type.
1491      * @param _agreementHash A `bytes32` hash of a project`s agreement id.
1492      * @param _scoreType A `ScoreType` to identify what score is requested.
1493      * @return An `uint8` score of the given project and of the given type.
1494      */
1495     function getProjectScoreByType(bytes32 _agreementHash, ScoreType _scoreType) internal view returns(uint8) {
1496         if (_scoreType == ScoreType.CustomerSatisfaction) {
1497             return projects[_agreementHash].customerSatisfaction;
1498         } else {
1499             return projects[_agreementHash].makerSatisfaction;
1500         }
1501     }
1502 
1503     /**
1504      * @dev Deploy DecoEscrow contract clone for the newly created project.
1505      * @param _newContractOwner An `address` of a new contract owner.
1506      * @return An `address` of a new deployed escrow contract.
1507      */
1508     function deployEscrowClone(address _newContractOwner) internal returns(address) {
1509         DecoRelay relay = DecoRelay(relayContractAddress);
1510         DecoEscrowFactory factory = DecoEscrowFactory(relay.escrowFactoryContractAddress());
1511         return factory.createEscrow(_newContractOwner, relay.milestonesContractAddress());
1512     }
1513 
1514     /**
1515      * @dev Check validness of maker's signature on project creation.
1516      * @param _maker An `address` of a maker.
1517      * @param _signature A `bytes` digital signature generated by a maker.
1518      * @param _agreementId A unique id of the agreement document for a project
1519      * @param _arbiter An `address` of a referee to settle all escalated disputes between parties.
1520      * @return A `bool` indicating validity of the signature.
1521      */
1522     function isMakersSignatureValid(address _maker, bytes _signature, string _agreementId, address _arbiter) internal view returns (bool) {
1523         bytes32 digest = keccak256(abi.encodePacked(
1524             "\x19\x01",
1525             DOMAIN_SEPARATOR,
1526             hash(Proposal(_agreementId, _arbiter))
1527         ));
1528         address signatureAddress = digest.recover(_signature);
1529         return signatureAddress == _maker;
1530     }
1531 
1532     function hash(EIP712Domain eip712Domain) internal view returns (bytes32) {
1533         return keccak256(abi.encode(
1534             EIP712DOMAIN_TYPEHASH,
1535             keccak256(bytes(eip712Domain.name)),
1536             keccak256(bytes(eip712Domain.version)),
1537             eip712Domain.chainId,
1538             eip712Domain.verifyingContract
1539         ));
1540     }
1541 
1542     function hash(Proposal proposal) internal view returns (bytes32) {
1543         return keccak256(abi.encode(
1544             PROPOSAL_TYPEHASH,
1545             keccak256(bytes(proposal.agreementId)),
1546             proposal.arbiter
1547         ));
1548     }
1549 }
1550 
1551 
1552 
1553 /// @title Contract for Milesotone events and actions handling.
1554 contract DecoMilestones is IDecoArbitrationTarget, DecoBaseProjectsMarketplace {
1555 
1556     address public constant ETH_TOKEN_ADDRESS = address(0x0);
1557 
1558     // struct to describe Milestone
1559     struct Milestone {
1560         uint8 milestoneNumber;
1561 
1562         // original duration of a milestone.
1563         uint32 duration;
1564 
1565         // track all adjustments caused by state changes Active <-> Delivered <-> Rejected
1566         // `adjustedDuration` time gets increased by the time that is spent by client
1567         // to provide a feedback when agreed milestone time is not exceeded yet.
1568         // Initial value is the same as duration.
1569         uint32 adjustedDuration;
1570 
1571         uint depositAmount;
1572         address tokenAddress;
1573 
1574         uint startedTime;
1575         uint deliveredTime;
1576         uint acceptedTime;
1577 
1578         // indicates that a milestone progress was paused.
1579         bool isOnHold;
1580     }
1581 
1582     // enumeration to describe possible milestone states.
1583     enum MilestoneState { Active, Delivered, Accepted, Rejected, Terminated, Paused }
1584 
1585     // map agreement id hash to milestones list.
1586     mapping (bytes32 => Milestone[]) public projectMilestones;
1587 
1588     // Logged when milestone state changes.
1589     event LogMilestoneStateUpdated (
1590         bytes32 indexed agreementHash,
1591         address indexed sender,
1592         uint timestamp,
1593         uint8 milestoneNumber,
1594         MilestoneState indexed state
1595     );
1596 
1597     event LogMilestoneDurationAdjusted (
1598         bytes32 indexed agreementHash,
1599         address indexed sender,
1600         uint32 amountAdded,
1601         uint8 milestoneNumber
1602     );
1603 
1604     /**
1605      * @dev Starts a new milestone for the project and deposit ETH in smart contract`s escrow.
1606      * @param _agreementHash A `bytes32` hash of the agreement id.
1607      * @param _depositAmount An `uint` of wei that are going to be deposited for a new milestone.
1608      * @param _duration An `uint` seconds of a milestone duration.
1609      */
1610     function startMilestone(
1611         bytes32 _agreementHash,
1612         uint _depositAmount,
1613         address _tokenAddress,
1614         uint32 _duration
1615     )
1616         external
1617     {
1618         uint8 completedMilestonesCount = uint8(projectMilestones[_agreementHash].length);
1619         if (completedMilestonesCount > 0) {
1620             Milestone memory lastMilestone = projectMilestones[_agreementHash][completedMilestonesCount - 1];
1621             require(lastMilestone.acceptedTime > 0, "All milestones must be accepted prior starting a new one.");
1622         }
1623         DecoProjects projectsContract = DecoProjects(
1624             DecoRelay(relayContractAddress).projectsContractAddress()
1625         );
1626         require(projectsContract.checkIfProjectExists(_agreementHash), "Project must exist.");
1627         require(
1628             projectsContract.getProjectClient(_agreementHash) == msg.sender,
1629             "Only project's client starts a miestone"
1630         );
1631         require(
1632             projectsContract.getProjectMilestonesCount(_agreementHash) > completedMilestonesCount,
1633             "Milestones count should not exceed the number configured in the project."
1634         );
1635         require(
1636             projectsContract.getProjectEndDate(_agreementHash) == 0,
1637             "Project should be active."
1638         );
1639         blockFundsInEscrow(
1640             projectsContract.getProjectEscrowAddress(_agreementHash),
1641             _depositAmount,
1642             _tokenAddress
1643         );
1644         uint nowTimestamp = now;
1645         projectMilestones[_agreementHash].push(
1646             Milestone(
1647                 completedMilestonesCount + 1,
1648                 _duration,
1649                 _duration,
1650                 _depositAmount,
1651                 _tokenAddress,
1652                 nowTimestamp,
1653                 0,
1654                 0,
1655                 false
1656             )
1657         );
1658         emit LogMilestoneStateUpdated(
1659             _agreementHash,
1660             msg.sender,
1661             nowTimestamp,
1662             completedMilestonesCount + 1,
1663             MilestoneState.Active
1664         );
1665     }
1666 
1667     /**
1668      * @dev Maker delivers the current active milestone.
1669      * @param _agreementHash Project`s unique hash.
1670      */
1671     function deliverLastMilestone(bytes32 _agreementHash) external {
1672         DecoProjects projectsContract = DecoProjects(
1673             DecoRelay(relayContractAddress).projectsContractAddress()
1674         );
1675         require(projectsContract.checkIfProjectExists(_agreementHash), "Project must exist.");
1676         require(projectsContract.getProjectEndDate(_agreementHash) == 0, "Project should be active.");
1677         require(projectsContract.getProjectMaker(_agreementHash) == msg.sender, "Sender must be a maker.");
1678         uint nowTimestamp = now;
1679         uint8 milestonesCount = uint8(projectMilestones[_agreementHash].length);
1680         require(milestonesCount > 0, "There must be milestones to make a delivery.");
1681         Milestone storage milestone = projectMilestones[_agreementHash][milestonesCount - 1];
1682         require(
1683             milestone.startedTime > 0 && milestone.deliveredTime == 0 && milestone.acceptedTime == 0,
1684             "Milestone must be active, not delivered and not accepted."
1685         );
1686         require(!milestone.isOnHold, "Milestone must not be paused.");
1687         milestone.deliveredTime = nowTimestamp;
1688         emit LogMilestoneStateUpdated(
1689             _agreementHash,
1690             msg.sender,
1691             nowTimestamp,
1692             milestonesCount,
1693             MilestoneState.Delivered
1694         );
1695     }
1696 
1697     /**
1698      * @dev Project owner accepts the current delivered milestone.
1699      * @param _agreementHash Project`s unique hash.
1700      */
1701     function acceptLastMilestone(bytes32 _agreementHash) external {
1702         DecoProjects projectsContract = DecoProjects(
1703             DecoRelay(relayContractAddress).projectsContractAddress()
1704         );
1705         require(projectsContract.checkIfProjectExists(_agreementHash), "Project must exist.");
1706         require(projectsContract.getProjectEndDate(_agreementHash) == 0, "Project should be active.");
1707         require(projectsContract.getProjectClient(_agreementHash) == msg.sender, "Sender must be a client.");
1708         uint8 milestonesCount = uint8(projectMilestones[_agreementHash].length);
1709         require(milestonesCount > 0, "There must be milestones to accept a delivery.");
1710         Milestone storage milestone = projectMilestones[_agreementHash][milestonesCount - 1];
1711         require(
1712             milestone.startedTime > 0 &&
1713             milestone.acceptedTime == 0 &&
1714             milestone.deliveredTime > 0 &&
1715             milestone.isOnHold == false,
1716             "Milestone should be active and delivered, but not rejected, or already accepted, or put on hold."
1717         );
1718         uint nowTimestamp = now;
1719         milestone.acceptedTime = nowTimestamp;
1720         if (projectsContract.getProjectMilestonesCount(_agreementHash) == milestonesCount) {
1721             projectsContract.completeProject(_agreementHash);
1722         }
1723         distributeFundsInEscrow(
1724             projectsContract.getProjectEscrowAddress(_agreementHash),
1725             projectsContract.getProjectMaker(_agreementHash),
1726             milestone.depositAmount,
1727             milestone.tokenAddress
1728         );
1729         emit LogMilestoneStateUpdated(
1730             _agreementHash,
1731             msg.sender,
1732             nowTimestamp,
1733             milestonesCount,
1734             MilestoneState.Accepted
1735         );
1736     }
1737 
1738     /**
1739      * @dev Project owner rejects the current active milestone.
1740      * @param _agreementHash Project`s unique hash.
1741      */
1742     function rejectLastDeliverable(bytes32 _agreementHash) external {
1743         DecoProjects projectsContract = DecoProjects(
1744             DecoRelay(relayContractAddress).projectsContractAddress()
1745         );
1746         require(projectsContract.checkIfProjectExists(_agreementHash), "Project must exist.");
1747         require(projectsContract.getProjectEndDate(_agreementHash) == 0, "Project should be active.");
1748         require(projectsContract.getProjectClient(_agreementHash) == msg.sender, "Sender must be a client.");
1749         uint8 milestonesCount = uint8(projectMilestones[_agreementHash].length);
1750         require(milestonesCount > 0, "There must be milestones to reject a delivery.");
1751         Milestone storage milestone = projectMilestones[_agreementHash][milestonesCount - 1];
1752         require(
1753             milestone.startedTime > 0 &&
1754             milestone.acceptedTime == 0 &&
1755             milestone.deliveredTime > 0 &&
1756             milestone.isOnHold == false,
1757             "Milestone should be active and delivered, but not rejected, or already accepted, or on hold."
1758         );
1759         uint nowTimestamp = now;
1760         if (milestone.startedTime.add(milestone.adjustedDuration) > milestone.deliveredTime) {
1761             uint32 timeToAdd = uint32(nowTimestamp.sub(milestone.deliveredTime));
1762             milestone.adjustedDuration += timeToAdd;
1763             emit LogMilestoneDurationAdjusted (
1764                 _agreementHash,
1765                 msg.sender,
1766                 timeToAdd,
1767                 milestonesCount
1768             );
1769         }
1770         milestone.deliveredTime = 0;
1771         emit LogMilestoneStateUpdated(
1772             _agreementHash,
1773             msg.sender,
1774             nowTimestamp,
1775             milestonesCount,
1776             MilestoneState.Rejected
1777         );
1778     }
1779 
1780     /**
1781      * @dev Prepare arbitration target for a started dispute.
1782      * @param _idHash A `bytes32` hash of id.
1783      */
1784     function disputeStartedFreeze(bytes32 _idHash) public {
1785         address projectsContractAddress = DecoRelay(relayContractAddress).projectsContractAddress();
1786         DecoProjects projectsContract = DecoProjects(projectsContractAddress);
1787         require(
1788             projectsContract.getProjectArbiter(_idHash) == msg.sender,
1789             "Freezing upon dispute start can be sent only by arbiter."
1790         );
1791         uint milestonesCount = projectMilestones[_idHash].length;
1792         require(milestonesCount > 0, "There must be active milestone.");
1793         Milestone storage lastMilestone = projectMilestones[_idHash][milestonesCount - 1];
1794         lastMilestone.isOnHold = true;
1795         emit LogMilestoneStateUpdated(
1796             _idHash,
1797             msg.sender,
1798             now,
1799             uint8(milestonesCount),
1800             MilestoneState.Paused
1801         );
1802     }
1803 
1804     /**
1805      * @dev React to an active dispute settlement with given parameters.
1806      * @param _idHash A `bytes32` hash of id.
1807      * @param _respondent An `address` of a respondent.
1808      * @param _respondentShare An `uint8` share for the respondent.
1809      * @param _initiator An `address` of a dispute initiator.
1810      * @param _initiatorShare An `uint8` share for the initiator.
1811      * @param _isInternal A `bool` indicating if dispute was settled by participants without an arbiter.
1812      * @param _arbiterWithdrawalAddress An `address` for sending out arbiter compensation.
1813      */
1814     function disputeSettledTerminate(
1815         bytes32 _idHash,
1816         address _respondent,
1817         uint8 _respondentShare,
1818         address _initiator,
1819         uint8 _initiatorShare,
1820         bool _isInternal,
1821         address _arbiterWithdrawalAddress
1822     )
1823         public
1824     {
1825         uint milestonesCount = projectMilestones[_idHash].length;
1826         require(milestonesCount > 0, "There must be at least one milestone.");
1827         Milestone memory lastMilestone = projectMilestones[_idHash][milestonesCount - 1];
1828         require(lastMilestone.isOnHold, "Last milestone must be on hold.");
1829         require(uint(_respondentShare).add(uint(_initiatorShare)) == 100, "Shares must be 100% in sum.");
1830         DecoProjects projectsContract = DecoProjects(
1831             DecoRelay(relayContractAddress).projectsContractAddress()
1832         );
1833         (
1834             uint fixedFee,
1835             uint8 shareFee,
1836             address escrowAddress
1837         ) = projectsContract.getInfoForDisputeAndValidate (
1838             _idHash,
1839             _respondent,
1840             _initiator,
1841             msg.sender
1842         );
1843         distributeDisputeFunds(
1844             escrowAddress,
1845             lastMilestone.tokenAddress,
1846             _respondent,
1847             _initiator,
1848             _initiatorShare,
1849             _isInternal,
1850             _arbiterWithdrawalAddress,
1851             lastMilestone.depositAmount,
1852             fixedFee,
1853             shareFee
1854         );
1855         projectsContract.terminateProject(_idHash);
1856         emit LogMilestoneStateUpdated(
1857             _idHash,
1858             msg.sender,
1859             now,
1860             uint8(milestonesCount),
1861             MilestoneState.Terminated
1862         );
1863     }
1864 
1865     /**
1866      * @dev Check eligibility of a given address to perform operations,
1867      *      basically the address should be either client or maker.
1868      * @param _idHash A `bytes32` hash of id.
1869      * @param _addressToCheck An `address` to check.
1870      * @return A `bool` check status.
1871      */
1872     function checkEligibility(bytes32 _idHash, address _addressToCheck) public view returns(bool) {
1873         address projectsContractAddress = DecoRelay(relayContractAddress).projectsContractAddress();
1874         DecoProjects projectsContract = DecoProjects(projectsContractAddress);
1875         return _addressToCheck == projectsContract.getProjectClient(_idHash) ||
1876             _addressToCheck == projectsContract.getProjectMaker(_idHash);
1877     }
1878 
1879     /**
1880      * @dev Check if target is ready for a dispute.
1881      * @param _idHash A `bytes32` hash of id.
1882      * @return A `bool` check status.
1883      */
1884     function canStartDispute(bytes32 _idHash) public view returns(bool) {
1885         uint milestonesCount = projectMilestones[_idHash].length;
1886         if (milestonesCount == 0)
1887             return false;
1888         Milestone memory lastMilestone = projectMilestones[_idHash][milestonesCount - 1];
1889         if (lastMilestone.isOnHold || lastMilestone.acceptedTime > 0)
1890             return false;
1891         address projectsContractAddress = DecoRelay(relayContractAddress).projectsContractAddress();
1892         DecoProjects projectsContract = DecoProjects(projectsContractAddress);
1893         uint feedbackWindow = uint(projectsContract.getProjectFeedbackWindow(_idHash)).mul(24 hours);
1894         uint nowTimestamp = now;
1895         uint plannedDeliveryTime = lastMilestone.startedTime.add(uint(lastMilestone.adjustedDuration));
1896         if (plannedDeliveryTime < lastMilestone.deliveredTime || plannedDeliveryTime < nowTimestamp) {
1897             return false;
1898         }
1899         if (lastMilestone.deliveredTime > 0 &&
1900             lastMilestone.deliveredTime.add(feedbackWindow) < nowTimestamp)
1901             return false;
1902         return true;
1903     }
1904 
1905     /**
1906      * @dev Either project owner or maker can terminate the project in certain cases
1907      *      and the current active milestone must be marked as terminated for records-keeping.
1908      *      All blocked funds should be distributed in favor of eligible project party.
1909      *      The termination with this method initiated only by project contract.
1910      * @param _agreementHash Project`s unique hash.
1911      * @param _initiator An `address` of the termination initiator.
1912      */
1913     function terminateLastMilestone(bytes32 _agreementHash, address _initiator) public {
1914         address projectsContractAddress = DecoRelay(relayContractAddress).projectsContractAddress();
1915         require(msg.sender == projectsContractAddress, "Method should be called by Project contract.");
1916         DecoProjects projectsContract = DecoProjects(projectsContractAddress);
1917         require(projectsContract.checkIfProjectExists(_agreementHash), "Project must exist.");
1918         address projectClient = projectsContract.getProjectClient(_agreementHash);
1919         address projectMaker = projectsContract.getProjectMaker(_agreementHash);
1920         require(
1921             _initiator == projectClient ||
1922             _initiator == projectMaker,
1923             "Initiator should be either maker or client address."
1924         );
1925         if (_initiator == projectClient) {
1926             require(canClientTerminate(_agreementHash));
1927         } else {
1928             require(canMakerTerminate(_agreementHash));
1929         }
1930         uint milestonesCount = projectMilestones[_agreementHash].length;
1931         if (milestonesCount == 0) return;
1932         Milestone memory lastMilestone = projectMilestones[_agreementHash][milestonesCount - 1];
1933         if (lastMilestone.acceptedTime > 0) return;
1934         address projectEscrowContractAddress = projectsContract.getProjectEscrowAddress(_agreementHash);
1935         if (_initiator == projectClient) {
1936             unblockFundsInEscrow(
1937                 projectEscrowContractAddress,
1938                 lastMilestone.depositAmount,
1939                 lastMilestone.tokenAddress
1940             );
1941         } else {
1942             distributeFundsInEscrow(
1943                 projectEscrowContractAddress,
1944                 _initiator,
1945                 lastMilestone.depositAmount,
1946                 lastMilestone.tokenAddress
1947             );
1948         }
1949         emit LogMilestoneStateUpdated(
1950             _agreementHash,
1951             msg.sender,
1952             now,
1953             uint8(milestonesCount),
1954             MilestoneState.Terminated
1955         );
1956     }
1957 
1958     /**
1959      * @dev Returns the last project milestone completion status and number.
1960      * @param _agreementHash Project's unique hash.
1961      * @return isAccepted A boolean flag for acceptance state, and milestoneNumber for the last milestone.
1962      */
1963     function isLastMilestoneAccepted(
1964         bytes32 _agreementHash
1965     )
1966         public
1967         view
1968         returns(bool isAccepted, uint8 milestoneNumber)
1969     {
1970         milestoneNumber = uint8(projectMilestones[_agreementHash].length);
1971         if (milestoneNumber > 0) {
1972             isAccepted = projectMilestones[_agreementHash][milestoneNumber - 1].acceptedTime > 0;
1973         } else {
1974             isAccepted = false;
1975         }
1976     }
1977 
1978     /**
1979      * @dev Client can terminate milestone if the last milestone delivery is overdue and
1980      *      milestone is not on hold. By default termination is not available.
1981      * @param _agreementHash Project`s unique hash.
1982      * @return `true` if the last project's milestone could be terminated by client.
1983      */
1984     function canClientTerminate(bytes32 _agreementHash) public view returns(bool) {
1985         uint milestonesCount = projectMilestones[_agreementHash].length;
1986         if (milestonesCount == 0) return false;
1987         Milestone memory lastMilestone = projectMilestones[_agreementHash][milestonesCount - 1];
1988         return lastMilestone.acceptedTime == 0 &&
1989             !lastMilestone.isOnHold &&
1990             lastMilestone.startedTime.add(uint(lastMilestone.adjustedDuration)) < now;
1991     }
1992 
1993     /**
1994      * @dev Maker can terminate milestone if delivery review is taking longer than project feedback window and
1995      *      milestone is not on hold, or if client doesn't start the next milestone for a period longer than
1996      *      project's milestone start window. By default termination is not available.
1997      * @param _agreementHash Project`s unique hash.
1998      * @return `true` if the last project's milestone could be terminated by maker.
1999      */
2000     function canMakerTerminate(bytes32 _agreementHash) public view returns(bool) {
2001         address projectsContractAddress = DecoRelay(relayContractAddress).projectsContractAddress();
2002         DecoProjects projectsContract = DecoProjects(projectsContractAddress);
2003         uint feedbackWindow = uint(projectsContract.getProjectFeedbackWindow(_agreementHash)).mul(24 hours);
2004         uint milestoneStartWindow = uint(projectsContract.getProjectMilestoneStartWindow(
2005             _agreementHash
2006         )).mul(24 hours);
2007         uint projectStartDate = projectsContract.getProjectStartDate(_agreementHash);
2008         uint milestonesCount = projectMilestones[_agreementHash].length;
2009         if (milestonesCount == 0) return now.sub(projectStartDate) > milestoneStartWindow;
2010         Milestone memory lastMilestone = projectMilestones[_agreementHash][milestonesCount - 1];
2011         uint nowTimestamp = now;
2012         if (!lastMilestone.isOnHold &&
2013             lastMilestone.acceptedTime > 0 &&
2014             nowTimestamp.sub(lastMilestone.acceptedTime) > milestoneStartWindow)
2015             return true;
2016         return !lastMilestone.isOnHold &&
2017             lastMilestone.acceptedTime == 0 &&
2018             lastMilestone.deliveredTime > 0 &&
2019             nowTimestamp.sub(feedbackWindow) > lastMilestone.deliveredTime;
2020     }
2021 
2022     /*
2023      * @dev Block funds in escrow from balance to the blocked balance.
2024      * @param _projectEscrowContractAddress An `address` of project`s escrow.
2025      * @param _amount An `uint` amount to distribute.
2026      * @param _tokenAddress An `address` of a token.
2027      */
2028     function blockFundsInEscrow(
2029         address _projectEscrowContractAddress,
2030         uint _amount,
2031         address _tokenAddress
2032     )
2033         internal
2034     {
2035         if (_amount == 0) return;
2036         DecoEscrow escrow = DecoEscrow(_projectEscrowContractAddress);
2037         if (_tokenAddress == ETH_TOKEN_ADDRESS) {
2038             escrow.blockFunds(_amount);
2039         } else {
2040             escrow.blockTokenFunds(_tokenAddress, _amount);
2041         }
2042     }
2043 
2044     /*
2045      * @dev Unblock funds in escrow from blocked balance to the balance.
2046      * @param _projectEscrowContractAddress An `address` of project`s escrow.
2047      * @param _amount An `uint` amount to distribute.
2048      * @param _tokenAddress An `address` of a token.
2049      */
2050     function unblockFundsInEscrow(
2051         address _projectEscrowContractAddress,
2052         uint _amount,
2053         address _tokenAddress
2054     )
2055         internal
2056     {
2057         if (_amount == 0) return;
2058         DecoEscrow escrow = DecoEscrow(_projectEscrowContractAddress);
2059         if (_tokenAddress == ETH_TOKEN_ADDRESS) {
2060             escrow.unblockFunds(_amount);
2061         } else {
2062             escrow.unblockTokenFunds(_tokenAddress, _amount);
2063         }
2064     }
2065 
2066     /**
2067      * @dev Distribute funds in escrow from blocked balance to the target address.
2068      * @param _projectEscrowContractAddress An `address` of project`s escrow.
2069      * @param _distributionTargetAddress Target `address`.
2070      * @param _amount An `uint` amount to distribute.
2071      * @param _tokenAddress An `address` of a token.
2072      */
2073     function distributeFundsInEscrow(
2074         address _projectEscrowContractAddress,
2075         address _distributionTargetAddress,
2076         uint _amount,
2077         address _tokenAddress
2078     )
2079         internal
2080     {
2081         if (_amount == 0) return;
2082         DecoEscrow escrow = DecoEscrow(_projectEscrowContractAddress);
2083         if (_tokenAddress == ETH_TOKEN_ADDRESS) {
2084             escrow.distributeFunds(_distributionTargetAddress, _amount);
2085         } else {
2086             escrow.distributeTokenFunds(_distributionTargetAddress, _tokenAddress, _amount);
2087         }
2088     }
2089 
2090     /**
2091      * @dev Distribute project funds between arbiter and project parties.
2092      * @param _projectEscrowContractAddress An `address` of project`s escrow.
2093      * @param _tokenAddress An `address` of a token.
2094      * @param _respondent An `address` of a respondent.
2095      * @param _initiator An `address` of an initiator.
2096      * @param _initiatorShare An `uint8` iniator`s share.
2097      * @param _isInternal A `bool` indicating if dispute was settled solely by project parties.
2098      * @param _arbiterWithdrawalAddress A withdrawal `address` of an arbiter.
2099      * @param _amount An `uint` amount for distributing between project parties and arbiter.
2100      * @param _fixedFee An `uint` fixed fee of an arbiter.
2101      * @param _shareFee An `uint8` share fee of an arbiter.
2102      */
2103     function distributeDisputeFunds(
2104         address _projectEscrowContractAddress,
2105         address _tokenAddress,
2106         address _respondent,
2107         address _initiator,
2108         uint8 _initiatorShare,
2109         bool _isInternal,
2110         address _arbiterWithdrawalAddress,
2111         uint _amount,
2112         uint _fixedFee,
2113         uint8 _shareFee
2114     )
2115         internal
2116     {
2117         if (!_isInternal && _arbiterWithdrawalAddress != address(0x0)) {
2118             uint arbiterFee = getArbiterFeeAmount(_fixedFee, _shareFee, _amount, _tokenAddress);
2119             distributeFundsInEscrow(
2120                 _projectEscrowContractAddress,
2121                 _arbiterWithdrawalAddress,
2122                 arbiterFee,
2123                 _tokenAddress
2124             );
2125             _amount = _amount.sub(arbiterFee);
2126         }
2127         uint initiatorAmount = _amount.mul(_initiatorShare).div(100);
2128         distributeFundsInEscrow(
2129             _projectEscrowContractAddress,
2130             _initiator,
2131             initiatorAmount,
2132             _tokenAddress
2133         );
2134         distributeFundsInEscrow(
2135             _projectEscrowContractAddress,
2136             _respondent,
2137             _amount.sub(initiatorAmount),
2138             _tokenAddress
2139         );
2140     }
2141 
2142     /**
2143      * @dev Calculates arbiter`s fee.
2144      * @param _fixedFee An `uint` fixed fee of an arbiter.
2145      * @param _shareFee An `uint8` share fee of an arbiter.
2146      * @param _amount An `uint` amount for distributing between project parties and arbiter.
2147      * @param _tokenAddress An `address` of a token.
2148      * @return An `uint` amount allotted to the arbiter.
2149      */
2150     function getArbiterFeeAmount(uint _fixedFee, uint8 _shareFee, uint _amount, address _tokenAddress)
2151         internal
2152         pure
2153         returns(uint)
2154     {
2155         if (_tokenAddress != ETH_TOKEN_ADDRESS) {
2156             _fixedFee = 0;
2157         }
2158         return _amount.sub(_fixedFee).mul(uint(_shareFee)).div(100).add(_fixedFee);
2159     }
2160 }
2161 
2162 contract DecoProxy {
2163     using ECDSA for bytes32;
2164 
2165     /// Emitted when incoming ETH funds land into account.
2166     event Received (address indexed sender, uint value);
2167 
2168     /// Emitted when transaction forwarded to the next destination.
2169     event Forwarded (
2170         bytes signature,
2171         address indexed signer,
2172         address indexed destination,
2173         uint value,
2174         bytes data,
2175         bytes32 _hash
2176     );
2177 
2178     /// Emitted when owner is changed
2179     event OwnerChanged (
2180         address indexed newOwner
2181     );
2182 
2183     bool internal isInitialized;
2184 
2185     // Keep track to avoid replay attack.
2186     uint public nonce;
2187 
2188     /// Proxy owner.
2189     address public owner;
2190 
2191 
2192     /**
2193      * @dev Initialize the Proxy clone with default values.
2194      * @param _owner An address that orders forwarding of transactions.
2195      */
2196     function initialize(address _owner) public {
2197         require(!isInitialized, "Clone must be initialized only once.");
2198         isInitialized = true;
2199         owner = _owner;
2200     }
2201 
2202     /**
2203      * @dev Payable fallback to accept incoming payments.
2204      */
2205     function () external payable {
2206         emit Received(msg.sender, msg.value);
2207     }
2208 
2209     /**
2210      * @dev Change the owner of this proxy.  Used when the user forgets their key, and we can recover it via SSSS split key.  This will be the final txn of the forgotten key as it transfers ownership of the proxy to the new replacement key.  Note that this is also callable by the contract itself, which would be used in the case that a user is changing their owner address via a metatxn
2211      * @param _newOwner An `address` of the new proxy owner.
2212      */
2213     function changeOwner(address _newOwner) public {
2214         require(owner == msg.sender || address(this) == msg.sender, "Only owner can change owner");
2215         owner = _newOwner;
2216         emit OwnerChanged(_newOwner);
2217     }
2218 
2219     /**
2220      * @dev Forward a regular (non meta) transaction to the destination address.
2221      * @param _destination An `address` where txn should be forwarded to.
2222      * @param _value An `uint` of Wei value to be sent out.
2223      * @param _data A `bytes` data array of the given transaction.
2224      */
2225     function forwardFromOwner(address _destination, uint _value, bytes memory _data) public {
2226         require(owner == msg.sender, "Only owner can use forwardFromOwner method");
2227         require(executeCall(_destination, _value, _data), "Call must be successfull.");
2228         emit Forwarded("", owner, _destination, _value, _data, "");
2229     }
2230 
2231     /**
2232      * @dev Returns hash for the given transaction.
2233      * @param _signer An `address` of transaction signer.
2234      * @param _destination An `address` where txn should be forwarded to.
2235      * @param _value An `uint` of Wei value to be sent out.
2236      * @param _data A `bytes` data array of the given transaction.
2237      * @return A `bytes32` hash calculated for all incoming parameters.
2238      */
2239     function getHash(
2240         address _signer,
2241         address _destination,
2242         uint _value,
2243         bytes memory _data
2244     )
2245         public
2246         view
2247         returns(bytes32)
2248     {
2249         return keccak256(abi.encodePacked(address(this), _signer, _destination, _value, _data, nonce));
2250     }
2251 
2252     /**
2253      * @dev Forward a meta transaction to the destination address.
2254      * @param _signature A `bytes` array cotaining signature generated by owner.
2255      * @param _signer An `address` of transaction signer.
2256      * @param _destination An `address` where txn should be forwarded to.
2257      * @param _value An `uint` of Wei value to be sent out.
2258      * @param _data A `bytes` data array of the given transaction.
2259      */
2260     function forward(bytes memory _signature, address _signer, address _destination, uint _value, bytes memory _data) public {
2261         bytes32 hash = getHash(_signer, _destination, _value, _data);
2262         nonce++;
2263         require(owner == hash.toEthSignedMessageHash().recover(_signature), "Signer must be owner.");
2264         require(executeCall(_destination, _value, _data), "Call must be successfull.");
2265         emit Forwarded(_signature, _signer, _destination, _value, _data, hash);
2266     }
2267 
2268     /**
2269      * @dev Withdraw given amount of wei to the specified address.
2270      * @param _to An `address` of where to send the wei.
2271      * @param _value An `uint` amount to withdraw from the contract balance.
2272      */
2273     function withdraw(address _to, uint _value) public {
2274         require(owner == msg.sender || address(this) == msg.sender, "Only owner can withdraw");
2275         _to.transfer(_value);
2276     }
2277 
2278     /**
2279      * @dev Withdraw any ERC20 tokens from the contract balance to owner's address.
2280      * @param _tokenAddress An `address` of an ERC20 token.
2281      * @param _to An `address` of where to send the tokens.
2282      * @param _tokens An `uint` tokens amount.
2283      */
2284     function withdrawERC20Token(address _tokenAddress, address _to, uint _tokens) public {
2285         require(owner == msg.sender || address(this) == msg.sender, "Only owner can withdraw");
2286         IERC20 token = IERC20(_tokenAddress);
2287         require(token.transfer(_to, _tokens), "Tokens transfer must complete successfully.");
2288     }
2289 
2290     /**
2291      * @dev Forward txn by executing a call.
2292      * @param _to Destination `address`.
2293      * @param _value An `uint256` Wei value to be sent out.
2294      * @param _data A `bytes` array with txn data.
2295      * @return A `bool` completion status.
2296      */
2297     function executeCall(address _to, uint256 _value, bytes memory _data) internal returns (bool success) {
2298         assembly {
2299             let x := mload(0x40)
2300             success := call(gas, _to, _value, add(_data, 0x20), mload(_data), 0, 0)
2301         }
2302     }
2303 }
2304 
2305 
2306 contract DecoProxyFactory is DecoBaseProjectsMarketplace, CloneFactory {
2307 
2308     // Proxy master-contract address.
2309     address public libraryAddress;
2310 
2311     // Logged when a new Escrow clone is deployed to the chain.
2312     event ProxyCreated(address newProxyAddress);
2313 
2314     /**
2315      * @dev Constructor for the contract.
2316      * @param _libraryAddress Proxy master-contract address.
2317      */
2318     constructor(address _libraryAddress) public {
2319         libraryAddress = _libraryAddress;
2320     }
2321 
2322     /**
2323      * @dev Updates library address with the given value.
2324      * @param _libraryAddress Address of a new base contract.
2325      */
2326     function setLibraryAddress(address _libraryAddress) external onlyOwner {
2327         require(libraryAddress != _libraryAddress);
2328         require(_libraryAddress != address(0x0));
2329 
2330         libraryAddress = _libraryAddress;
2331     }
2332 
2333     /**
2334      * @dev Create Proxy clone.
2335      * @param _ownerAddress An address of the Proxy contract owner.
2336      */
2337     function createProxy(
2338         address _ownerAddress
2339     )
2340         external
2341         returns(address)
2342     {
2343         address clone = createClone(libraryAddress);
2344         DecoProxy(clone).initialize(
2345             _ownerAddress
2346         );
2347         emit ProxyCreated(clone);
2348         return clone;
2349     }
2350 }
