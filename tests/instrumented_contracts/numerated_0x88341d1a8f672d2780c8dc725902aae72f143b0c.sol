1 pragma solidity ^0.5.16;
2 // File: contracts/NFTfi/v1/openzeppelin/Ownable.sol
3 
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12     address private _owner;
13 
14     event OwnershipTransferred(address previousOwner, address newOwner);
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     constructor () internal {
21         _owner = msg.sender;
22         emit OwnershipTransferred(address(0), _owner);
23     }
24 
25     /**
26      * @return the address of the owner.
27      */
28     function owner() public view returns (address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(isOwner());
37         _;
38     }
39 
40     /**
41      * @return true if `msg.sender` is the owner of the contract.
42      */
43     function isOwner() public view returns (bool) {
44         return msg.sender == _owner;
45     }
46 
47     /**
48      * @dev Allows the current owner to relinquish control of the contract.
49      * @notice Renouncing to ownership will leave the contract without an owner.
50      * It will not be possible to call the functions with the `onlyOwner`
51      * modifier anymore.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: contracts/NFTfi/v1/openzeppelin/Roles.sol
78 
79 
80 
81 /**
82  * @title Roles
83  * @dev Library for managing addresses assigned to a Role.
84  */
85 library Roles {
86     struct Role {
87         mapping (address => bool) bearer;
88     }
89 
90     /**
91      * @dev give an account access to this role
92      */
93     function add(Role storage role, address account) internal {
94         require(account != address(0));
95         require(!has(role, account));
96 
97         role.bearer[account] = true;
98     }
99 
100     /**
101      * @dev remove an account's access to this role
102      */
103     function remove(Role storage role, address account) internal {
104         require(account != address(0));
105         require(has(role, account));
106 
107         role.bearer[account] = false;
108     }
109 
110     /**
111      * @dev check if an account has this role
112      * @return bool
113      */
114     function has(Role storage role, address account) internal view returns (bool) {
115         require(account != address(0));
116         return role.bearer[account];
117     }
118 }
119 
120 // File: contracts/NFTfi/v1/openzeppelin/PauserRole.sol
121 
122 
123 
124 
125 contract PauserRole {
126     using Roles for Roles.Role;
127 
128     event PauserAdded(address indexed account);
129     event PauserRemoved(address indexed account);
130 
131     Roles.Role private _pausers;
132 
133     constructor () internal {
134         _addPauser(msg.sender);
135     }
136 
137     modifier onlyPauser() {
138         require(isPauser(msg.sender));
139         _;
140     }
141 
142     function isPauser(address account) public view returns (bool) {
143         return _pausers.has(account);
144     }
145 
146     function addPauser(address account) public onlyPauser {
147         _addPauser(account);
148     }
149 
150     function renouncePauser() public {
151         _removePauser(msg.sender);
152     }
153 
154     function _addPauser(address account) internal {
155         _pausers.add(account);
156         emit PauserAdded(account);
157     }
158 
159     function _removePauser(address account) internal {
160         _pausers.remove(account);
161         emit PauserRemoved(account);
162     }
163 }
164 
165 // File: contracts/NFTfi/v1/openzeppelin/Pausable.sol
166 
167 
168 
169 
170 /**
171  * @title Pausable
172  * @dev Base contract which allows children to implement an emergency stop mechanism.
173  */
174 contract Pausable is PauserRole {
175     event Paused(address account);
176     event Unpaused(address account);
177 
178     bool private _paused;
179 
180     constructor () internal {
181         _paused = false;
182     }
183 
184     /**
185      * @return true if the contract is paused, false otherwise.
186      */
187     function paused() public view returns (bool) {
188         return _paused;
189     }
190 
191     /**
192      * @dev Modifier to make a function callable only when the contract is not paused.
193      */
194     modifier whenNotPaused() {
195         require(!_paused);
196         _;
197     }
198 
199     /**
200      * @dev Modifier to make a function callable only when the contract is paused.
201      */
202     modifier whenPaused() {
203         require(_paused);
204         _;
205     }
206 
207     /**
208      * @dev called by the owner to pause, triggers stopped state
209      */
210     function pause() public onlyPauser whenNotPaused {
211         _paused = true;
212         emit Paused(msg.sender);
213     }
214 
215     /**
216      * @dev called by the owner to unpause, returns to normal state
217      */
218     function unpause() public onlyPauser whenPaused {
219         _paused = false;
220         emit Unpaused(msg.sender);
221     }
222 }
223 
224 // File: contracts/NFTfi/v1/openzeppelin/ReentrancyGuard.sol
225 
226 
227 
228 /**
229  * @title Helps contracts guard against reentrancy attacks.
230  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
231  * @dev If you mark a function `nonReentrant`, you should also
232  * mark it `external`.
233  */
234 contract ReentrancyGuard {
235     /// @dev counter to allow mutex lock with only one SSTORE operation
236     uint256 private _guardCounter;
237 
238     constructor() public {
239         // The counter starts at one to prevent changing it from zero to a non-zero
240         // value, which is a more expensive operation.
241         _guardCounter = 1;
242     }
243 
244     /**
245      * @dev Prevents a contract from calling itself, directly or indirectly.
246      * Calling a `nonReentrant` function from another `nonReentrant`
247      * function is not supported. It is possible to prevent this from happening
248      * by making the `nonReentrant` function external, and make it call a
249      * `private` function that does the actual work.
250      */
251     modifier nonReentrant() {
252         _guardCounter += 1;
253         uint256 localCounter = _guardCounter;
254         _;
255         require(localCounter == _guardCounter);
256     }
257 }
258 
259 // File: contracts/NFTfi/v1/NFTfiAdmin.sol
260 
261 pragma solidity ^0.5.16;
262 
263 
264 
265 
266 // @title Admin contract for NFTfi. Holds owner-only functions to adjust
267 //        contract-wide fees, parameters, etc.
268 // @author smartcontractdev.eth, creator of wrappedkitties.eth, cwhelper.eth, and
269 //         kittybounties.eth
270 contract NFTfiAdmin is Ownable, Pausable, ReentrancyGuard {
271 
272     /* ****** */
273     /* EVENTS */
274     /* ****** */
275 
276     // @notice This event is fired whenever the admins change the percent of
277     //         interest rates earned that they charge as a fee. Note that
278     //         newAdminFee can never exceed 10,000, since the fee is measured
279     //         in basis points.
280     // @param  newAdminFee - The new admin fee measured in basis points. This
281     //         is a percent of the interest paid upon a loan's completion that
282     //         go to the contract admins.
283     event AdminFeeUpdated(
284         uint256 newAdminFee
285     );
286 
287     /* ******* */
288     /* STORAGE */
289     /* ******* */
290 
291     // @notice A mapping from from an ERC20 currency address to whether that
292     //         currency is whitelisted to be used by this contract. Note that
293     //         NFTfi only supports loans that use ERC20 currencies that are
294     //         whitelisted, all other calls to beginLoan() will fail.
295     mapping (address => bool) public erc20CurrencyIsWhitelisted;
296 
297     // @notice A mapping from from an NFT contract's address to whether that
298     //         contract is whitelisted to be used by this contract. Note that
299     //         NFTfi only supports loans that use NFT collateral from contracts
300     //         that are whitelisted, all other calls to beginLoan() will fail.
301     mapping (address => bool) public nftContractIsWhitelisted;
302 
303     // @notice The maximum duration of any loan started on this platform,
304     //         measured in seconds. This is both a sanity-check for borrowers
305     //         and an upper limit on how long admins will have to support v1 of
306     //         this contract if they eventually deprecate it, as well as a check
307     //         to ensure that the loan duration never exceeds the space alotted
308     //         for it in the loan struct.
309     uint256 public maximumLoanDuration = 53 weeks;
310 
311     // @notice The maximum number of active loans allowed on this platform.
312     //         This parameter is used to limit the risk that NFTfi faces while
313     //         the project is first getting started.
314     uint256 public maximumNumberOfActiveLoans = 100;
315 
316     // @notice The percentage of interest earned by lenders on this platform
317     //         that is taken by the contract admin's as a fee, measured in
318     //         basis points (hundreths of a percent).
319     uint256 public adminFeeInBasisPoints = 25;
320 
321     /* *********** */
322     /* CONSTRUCTOR */
323     /* *********** */
324 
325     constructor() internal {
326         // Whitelist mainnet WETH
327         erc20CurrencyIsWhitelisted[address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2)] = true;
328 
329         // Whitelist mainnet DAI
330         erc20CurrencyIsWhitelisted[address(0x6B175474E89094C44Da98b954EedeAC495271d0F)] = true;
331 
332         // Whitelist mainnet CryptoKitties
333         nftContractIsWhitelisted[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)] = true;
334     }
335 
336     /* ********* */
337     /* FUNCTIONS */
338     /* ********* */
339 
340     /**
341      * @dev Gets the token name
342      * @return string representing the token name
343      */
344     function name() external pure returns (string memory) {
345         return "NFTfi Promissory Note";
346     }
347 
348     /**
349      * @dev Gets the token symbol
350      * @return string representing the token symbol
351      */
352     function symbol() external pure returns (string memory) {
353         return "NFTfi";
354     }
355 
356     // @notice This function can be called by admins to change the whitelist
357     //         status of an ERC20 currency. This includes both adding an ERC20
358     //         currency to the whitelist and removing it.
359     // @param  _erc20Currency - The address of the ERC20 currency whose whitelist
360     //         status changed.
361     // @param  _setAsWhitelisted - The new status of whether the currency is
362     //         whitelisted or not.
363     function whitelistERC20Currency(address _erc20Currency, bool _setAsWhitelisted) external onlyOwner {
364         erc20CurrencyIsWhitelisted[_erc20Currency] = _setAsWhitelisted;
365     }
366 
367     // @notice This function can be called by admins to change the whitelist
368     //         status of an NFT contract. This includes both adding an NFT
369     //         contract to the whitelist and removing it.
370     // @param  _nftContract - The address of the NFT contract whose whitelist
371     //         status changed.
372     // @param  _setAsWhitelisted - The new status of whether the contract is
373     //         whitelisted or not.
374     function whitelistNFTContract(address _nftContract, bool _setAsWhitelisted) external onlyOwner {
375         nftContractIsWhitelisted[_nftContract] = _setAsWhitelisted;
376     }
377 
378     // @notice This function can be called by admins to change the
379     //         maximumLoanDuration. Note that they can never change
380     //         maximumLoanDuration to be greater than UINT32_MAX, since that's
381     //         the maximum space alotted for the duration in the loan struct.
382     // @param  _newMaximumLoanDuration - The new maximum loan duration, measured
383     //         in seconds.
384     function updateMaximumLoanDuration(uint256 _newMaximumLoanDuration) external onlyOwner {
385         require(_newMaximumLoanDuration <= uint256(~uint32(0)), 'loan duration cannot exceed space alotted in struct');
386         maximumLoanDuration = _newMaximumLoanDuration;
387     }
388 
389     // @notice This function can be called by admins to change the
390     //         maximumNumberOfActiveLoans. 
391     // @param  _newMaximumNumberOfActiveLoans - The new maximum number of
392     //         active loans, used to limit the risk that NFTfi faces while the
393     //         project is first getting started.
394     function updateMaximumNumberOfActiveLoans(uint256 _newMaximumNumberOfActiveLoans) external onlyOwner {
395         maximumNumberOfActiveLoans = _newMaximumNumberOfActiveLoans;
396     }
397 
398     // @notice This function can be called by admins to change the percent of
399     //         interest rates earned that they charge as a fee. Note that
400     //         newAdminFee can never exceed 10,000, since the fee is measured
401     //         in basis points.
402     // @param  _newAdminFeeInBasisPoints - The new admin fee measured in basis points. This
403     //         is a percent of the interest paid upon a loan's completion that
404     //         go to the contract admins.
405     function updateAdminFee(uint256 _newAdminFeeInBasisPoints) external onlyOwner {
406         require(_newAdminFeeInBasisPoints <= 10000, 'By definition, basis points cannot exceed 10000');
407         adminFeeInBasisPoints = _newAdminFeeInBasisPoints;
408         emit AdminFeeUpdated(_newAdminFeeInBasisPoints);
409     }
410 }
411 
412 // File: contracts/NFTfi/v1/openzeppelin/ECDSA.sol
413 
414 
415 
416 /**
417  * @title Elliptic curve signature operations
418  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
419  * TODO Remove this library once solidity supports passing a signature to ecrecover.
420  * See https://github.com/ethereum/solidity/issues/864
421  */
422 
423 library ECDSA {
424     /**
425      * @dev Recover signer address from a message by using their signature
426      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
427      * @param signature bytes signature, the signature is generated using web3.eth.sign()
428      */
429     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
430         bytes32 r;
431         bytes32 s;
432         uint8 v;
433 
434         // Check the signature length
435         if (signature.length != 65) {
436             return (address(0));
437         }
438 
439         // Divide the signature in r, s and v variables
440         // ecrecover takes the signature parameters, and the only way to get them
441         // currently is to use assembly.
442         // solhint-disable-next-line no-inline-assembly
443         assembly {
444             r := mload(add(signature, 0x20))
445             s := mload(add(signature, 0x40))
446             v := byte(0, mload(add(signature, 0x60)))
447         }
448 
449         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
450         if (v < 27) {
451             v += 27;
452         }
453 
454         // If the version is correct return the signer address
455         if (v != 27 && v != 28) {
456             return (address(0));
457         } else {
458             return ecrecover(hash, v, r, s);
459         }
460     }
461 
462     /**
463      * toEthSignedMessageHash
464      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
465      * and hash the result
466      */
467     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
468         // 32 is the length in bytes of hash,
469         // enforced by the type signature above
470         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
471     }
472 }
473 
474 // File: contracts/NFTfi/v1/NFTfiSigningUtils.sol
475 
476 pragma solidity ^0.5.16;
477 
478 
479 // @title  Helper contract for NFTfi. This contract manages verifying signatures
480 //         from off-chain NFTfi orders.
481 // @author smartcontractdev.eth, creator of wrappedkitties.eth, cwhelper.eth,
482 //         and kittybounties.eth
483 // @notice Cite: I found the following article very insightful while creating
484 //         this contract:
485 //         https://dzone.com/articles/signing-and-verifying-ethereum-signatures
486 // @notice Cite: I also relied on this article somewhat:
487 //         https://forum.openzeppelin.com/t/sign-it-like-you-mean-it-creating-and-verifying-ethereum-signatures/697
488 contract NFTfiSigningUtils {
489 
490     /* *********** */
491     /* CONSTRUCTOR */
492     /* *********** */
493 
494     constructor() internal {}
495 
496     /* ********* */
497     /* FUNCTIONS */
498     /* ********* */
499 
500     // @notice OpenZeppelin's ECDSA library is used to call all ECDSA functions
501     //         directly on the bytes32 variables themselves.
502     using ECDSA for bytes32;
503 
504     // @notice This function gets the current chain ID.
505     function getChainID() public view returns (uint256) {
506         uint256 id;
507         assembly {
508             id := chainid()
509         }
510         return id;
511     }
512 
513     // @notice This function is called in NFTfi.beginLoan() to validate the
514     //         borrower's signature that the borrower provided off-chain to
515     //         verify that they did indeed want to use this NFT for this loan.
516     // @param  _nftCollateralId - The ID within the NFTCollateralContract for
517     //         the NFT being used as collateral for this loan. The NFT is
518     //         stored within this contract during the duration of the loan.
519     // @param  _borrowerNonce - The nonce referred to here
520     //         is not the same as an Ethereum account's nonce. We are referring
521     //         instead to nonces that are used by both the lender and the
522     //         borrower when they are first signing off-chain NFTfi orders.
523     //         These nonces can be any uint256 value that the user has not
524     //         previously used to sign an off-chain order. Each nonce can be
525     //         used at most once per user within NFTfi, regardless of whether
526     //         they are the lender or the borrower in that situation. This
527     //         serves two purposes. First, it prevents replay attacks where an
528     //         attacker would submit a user's off-chain order more than once.
529     //         Second, it allows a user to cancel an off-chain order by calling
530     //         NFTfi.cancelLoanCommitmentBeforeLoanHasBegun(), which marks the
531     //         nonce as used and prevents any future loan from using the user's
532     //         off-chain order that contains that nonce.
533     // @param  _nftCollateralContract - The ERC721 contract of the NFT
534     //         collateral
535     // @param  _borrower - The address of the borrower.
536     // @param  _borrowerSignature - The ECDSA signature of the borrower,
537     //         obtained off-chain ahead of time, signing the following
538     //         combination of parameters: _nftCollateralId, _borrowerNonce,
539     //         _nftCollateralContract, _borrower.
540     // @return A bool representing whether verification succeeded, showing that
541     //         this signature matched this address and parameters.
542     function isValidBorrowerSignature(
543         uint256 _nftCollateralId,
544         uint256 _borrowerNonce,
545         address _nftCollateralContract,
546         address _borrower,
547         bytes memory _borrowerSignature
548     ) public view returns(bool) {
549         if(_borrower == address(0)){
550             return false;
551         } else {
552             uint256 chainId;
553             chainId = getChainID();
554             bytes32 message = keccak256(abi.encodePacked(
555                 _nftCollateralId,
556                 _borrowerNonce,
557                 _nftCollateralContract,
558                 _borrower,
559                 chainId
560             ));
561 
562             bytes32 messageWithEthSignPrefix = message.toEthSignedMessageHash();
563 
564             return (messageWithEthSignPrefix.recover(_borrowerSignature) == _borrower);
565         }
566     }
567 
568     // @notice This function is called in NFTfi.beginLoan() to validate the
569     //         lender's signature that the lender provided off-chain to
570     //         verify that they did indeed want to agree to this loan according
571     //         to these terms.
572     // @param  _loanPrincipalAmount - The original sum of money transferred
573     //         from lender to borrower at the beginning of the loan, measured
574     //         in loanERC20Denomination's smallest units.
575     // @param  _maximumRepaymentAmount - The maximum amount of money that the
576     //         borrower would be required to retrieve their collateral. If
577     //         interestIsProRated is set to false, then the borrower will
578     //         always have to pay this amount to retrieve their collateral.
579     // @param  _nftCollateralId - The ID within the NFTCollateralContract for
580     //         the NFT being used as collateral for this loan. The NFT is
581     //         stored within this contract during the duration of the loan.
582     // @param  _loanDuration - The amount of time (measured in seconds) that can
583     //         elapse before the lender can liquidate the loan and seize the
584     //         underlying collateral NFT.
585     // @param  _loanInterestRateForDurationInBasisPoints - The interest rate
586     //         (measured in basis points, e.g. hundreths of a percent) for the
587     //         loan, that must be repaid pro-rata by the borrower at the
588     //         conclusion of the loan or risk seizure of their nft collateral.
589     // @param  _adminFeeInBasisPoints - The percent (measured in basis
590     //         points) of the interest earned that will be taken as a fee by
591     //         the contract admins when the loan is repaid. The fee is stored
592     //         in the loan struct to prevent an attack where the contract
593     //         admins could adjust the fee right before a loan is repaid, and
594     //         take all of the interest earned.
595     // @param  _lenderNonce - The nonce referred to here
596     //         is not the same as an Ethereum account's nonce. We are referring
597     //         instead to nonces that are used by both the lender and the
598     //         borrower when they are first signing off-chain NFTfi orders.
599     //         These nonces can be any uint256 value that the user has not
600     //         previously used to sign an off-chain order. Each nonce can be
601     //         used at most once per user within NFTfi, regardless of whether
602     //         they are the lender or the borrower in that situation. This
603     //         serves two purposes. First, it prevents replay attacks where an
604     //         attacker would submit a user's off-chain order more than once.
605     //         Second, it allows a user to cancel an off-chain order by calling
606     //         NFTfi.cancelLoanCommitmentBeforeLoanHasBegun(), which marks the
607     //         nonce as used and prevents any future loan from using the user's
608     //         off-chain order that contains that nonce.
609     // @param  _nftCollateralContract - The ERC721 contract of the NFT
610     //         collateral
611     // @param  _loanERC20Denomination - The ERC20 contract of the currency being
612     //         used as principal/interest for this loan.
613     // @param  _lender - The address of the lender. The lender can change their
614     //         address by transferring the NFTfi ERC721 token that they
615     //         received when the loan began.
616     // @param  _interestIsProRated - A boolean value determining whether the
617     //         interest will be pro-rated if the loan is repaid early, or
618     //         whether the borrower will simply pay maximumRepaymentAmount.
619     // @param  _lenderSignature - The ECDSA signature of the lender,
620     //         obtained off-chain ahead of time, signing the following
621     //         combination of parameters: _loanPrincipalAmount,
622     //         _maximumRepaymentAmount _nftCollateralId, _loanDuration,
623     //         _loanInterestRateForDurationInBasisPoints, _lenderNonce,
624     //         _nftCollateralContract, _loanERC20Denomination, _lender,
625     //         _interestIsProRated.
626     // @return A bool representing whether verification succeeded, showing that
627     //         this signature matched this address and parameters.
628     function isValidLenderSignature(
629         uint256 _loanPrincipalAmount,
630         uint256 _maximumRepaymentAmount,
631         uint256 _nftCollateralId,
632         uint256 _loanDuration,
633         uint256 _loanInterestRateForDurationInBasisPoints,
634         uint256 _adminFeeInBasisPoints,
635         uint256 _lenderNonce,
636         address _nftCollateralContract,
637         address _loanERC20Denomination,
638         address _lender,
639         bool _interestIsProRated,
640         bytes memory _lenderSignature
641     ) public view returns(bool) {
642         if(_lender == address(0)){
643             return false;
644         } else {
645             uint256 chainId;
646             chainId = getChainID();
647             bytes32 message = keccak256(abi.encodePacked(
648                 _loanPrincipalAmount,
649                 _maximumRepaymentAmount,
650                 _nftCollateralId,
651                 _loanDuration,
652                 _loanInterestRateForDurationInBasisPoints,
653                 _adminFeeInBasisPoints,
654                 _lenderNonce,
655                 _nftCollateralContract,
656                 _loanERC20Denomination,
657                 _lender,
658                 _interestIsProRated,
659                 chainId
660             ));
661 
662             bytes32 messageWithEthSignPrefix = message.toEthSignedMessageHash();
663 
664             return (messageWithEthSignPrefix.recover(_lenderSignature) == _lender);
665         }
666     }
667 }
668 
669 // File: contracts/NFTfi/v1/openzeppelin/IERC165.sol
670 
671 
672 
673 /**
674  * @title IERC165
675  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
676  */
677 interface IERC165 {
678     /**
679      * @notice Query if a contract implements an interface
680      * @param interfaceId The interface identifier, as specified in ERC-165
681      * @dev Interface identification is specified in ERC-165. This function
682      * uses less than 30,000 gas.
683      */
684     function supportsInterface(bytes4 interfaceId) external view returns (bool);
685 }
686 
687 // File: contracts/NFTfi/v1/openzeppelin/IERC721.sol
688 
689 
690 
691 
692 /**
693  * @title ERC721 Non-Fungible Token Standard basic interface
694  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
695  */
696 contract IERC721 is IERC165 {
697     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
698     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
699     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
700 
701     function balanceOf(address owner) public view returns (uint256 balance);
702     function ownerOf(uint256 tokenId) public view returns (address owner);
703 
704     function approve(address to, uint256 tokenId) public;
705     function getApproved(uint256 tokenId) public view returns (address operator);
706 
707     function setApprovalForAll(address operator, bool _approved) public;
708     function isApprovedForAll(address owner, address operator) public view returns (bool);
709 
710     function transferFrom(address from, address to, uint256 tokenId) public;
711     function safeTransferFrom(address from, address to, uint256 tokenId) public;
712 
713     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
714 }
715 
716 // File: contracts/NFTfi/v1/openzeppelin/IERC721Receiver.sol
717 
718 
719 
720 /**
721  * @title ERC721 token receiver interface
722  * @dev Interface for any contract that wants to support safeTransfers
723  * from ERC721 asset contracts.
724  */
725 contract IERC721Receiver {
726     /**
727      * @notice Handle the receipt of an NFT
728      * @dev The ERC721 smart contract calls this function on the recipient
729      * after a `safeTransfer`. This function MUST return the function selector,
730      * otherwise the caller will revert the transaction. The selector to be
731      * returned can be obtained as `this.onERC721Received.selector`. This
732      * function MAY throw to revert and reject the transfer.
733      * Note: the ERC721 contract address is always the message sender.
734      * @param operator The address which called `safeTransferFrom` function
735      * @param from The address which previously owned the token
736      * @param tokenId The NFT identifier which is being transferred
737      * @param data Additional data with no specified format
738      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
739      */
740     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
741     public returns (bytes4);
742 }
743 
744 // File: contracts/NFTfi/v1/openzeppelin/SafeMath.sol
745 
746 
747 
748 /**
749  * @title SafeMath
750  * @dev Unsigned math operations with safety checks that revert on error
751  */
752 library SafeMath {
753     /**
754     * @dev Multiplies two unsigned integers, reverts on overflow.
755     */
756     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
757         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
758         // benefit is lost if 'b' is also tested.
759         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
760         if (a == 0) {
761             return 0;
762         }
763 
764         uint256 c = a * b;
765         require(c / a == b);
766 
767         return c;
768     }
769 
770     /**
771     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
772     */
773     function div(uint256 a, uint256 b) internal pure returns (uint256) {
774         // Solidity only automatically asserts when dividing by 0
775         require(b > 0);
776         uint256 c = a / b;
777         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
778 
779         return c;
780     }
781 
782     /**
783     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
784     */
785     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
786         require(b <= a);
787         uint256 c = a - b;
788 
789         return c;
790     }
791 
792     /**
793     * @dev Adds two unsigned integers, reverts on overflow.
794     */
795     function add(uint256 a, uint256 b) internal pure returns (uint256) {
796         uint256 c = a + b;
797         require(c >= a);
798 
799         return c;
800     }
801 
802     /**
803     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
804     * reverts when dividing by zero.
805     */
806     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
807         require(b != 0);
808         return a % b;
809     }
810 }
811 
812 // File: contracts/NFTfi/v1/openzeppelin/Address.sol
813 
814 
815 
816 /**
817  * Utility library of inline functions on addresses
818  */
819 library Address {
820     /**
821      * Returns whether the target address is a contract
822      * @dev This function will return false if invoked during the constructor of a contract,
823      * as the code is not actually created until after the constructor finishes.
824      * @param account address of the account to check
825      * @return whether the target address is a contract
826      */
827     function isContract(address account) internal view returns (bool) {
828         uint256 size;
829         // XXX Currently there is no better way to check if there is a contract in an address
830         // than to check the size of the code at that address.
831         // See https://ethereum.stackexchange.com/a/14016/36603
832         // for more details about how this works.
833         // TODO Check this again before the Serenity release, because all addresses will be
834         // contracts then.
835         // solhint-disable-next-line no-inline-assembly
836         assembly { size := extcodesize(account) }
837         return size > 0;
838     }
839 }
840 
841 // File: contracts/NFTfi/v1/openzeppelin/ERC165.sol
842 
843 
844 
845 
846 /**
847  * @title ERC165
848  * @author Matt Condon (@shrugs)
849  * @dev Implements ERC165 using a lookup table.
850  */
851 contract ERC165 is IERC165 {
852     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
853     /**
854      * 0x01ffc9a7 ===
855      *     bytes4(keccak256('supportsInterface(bytes4)'))
856      */
857 
858     /**
859      * @dev a mapping of interface id to whether or not it's supported
860      */
861     mapping(bytes4 => bool) private _supportedInterfaces;
862 
863     /**
864      * @dev A contract implementing SupportsInterfaceWithLookup
865      * implement ERC165 itself
866      */
867     constructor () internal {
868         _registerInterface(_INTERFACE_ID_ERC165);
869     }
870 
871     /**
872      * @dev implement supportsInterface(bytes4) using a lookup table
873      */
874     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
875         return _supportedInterfaces[interfaceId];
876     }
877 
878     /**
879      * @dev internal method for registering an interface
880      */
881     function _registerInterface(bytes4 interfaceId) internal {
882         require(interfaceId != 0xffffffff);
883         _supportedInterfaces[interfaceId] = true;
884     }
885 }
886 
887 // File: contracts/NFTfi/v1/openzeppelin/ERC721.sol
888 
889 
890 
891 
892 
893 
894 
895 
896 /**
897  * @title ERC721 Non-Fungible Token Standard basic implementation
898  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
899  */
900 contract ERC721 is ERC165, IERC721 {
901     using SafeMath for uint256;
902     using Address for address;
903 
904     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
905     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
906     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
907 
908     // Mapping from token ID to owner
909     mapping (uint256 => address) private _tokenOwner;
910 
911     // Mapping from token ID to approved address
912     mapping (uint256 => address) private _tokenApprovals;
913 
914     // Mapping from owner to number of owned token
915     mapping (address => uint256) private _ownedTokensCount;
916 
917     // Mapping from owner to operator approvals
918     mapping (address => mapping (address => bool)) private _operatorApprovals;
919 
920     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
921     /*
922      * 0x80ac58cd ===
923      *     bytes4(keccak256('balanceOf(address)')) ^
924      *     bytes4(keccak256('ownerOf(uint256)')) ^
925      *     bytes4(keccak256('approve(address,uint256)')) ^
926      *     bytes4(keccak256('getApproved(uint256)')) ^
927      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
928      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
929      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
930      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
931      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
932      */
933 
934     constructor () public {
935         // register the supported interfaces to conform to ERC721 via ERC165
936         _registerInterface(_INTERFACE_ID_ERC721);
937     }
938 
939     /**
940      * @dev Gets the balance of the specified address
941      * @param owner address to query the balance of
942      * @return uint256 representing the amount owned by the passed address
943      */
944     function balanceOf(address owner) public view returns (uint256) {
945         require(owner != address(0));
946         return _ownedTokensCount[owner];
947     }
948 
949     /**
950      * @dev Gets the owner of the specified token ID
951      * @param tokenId uint256 ID of the token to query the owner of
952      * @return owner address currently marked as the owner of the given token ID
953      */
954     function ownerOf(uint256 tokenId) public view returns (address) {
955         address owner = _tokenOwner[tokenId];
956         require(owner != address(0));
957         return owner;
958     }
959 
960     /**
961      * @dev Approves another address to transfer the given token ID
962      * The zero address indicates there is no approved address.
963      * There can only be one approved address per token at a given time.
964      * Can only be called by the token owner or an approved operator.
965      * @param to address to be approved for the given token ID
966      * @param tokenId uint256 ID of the token to be approved
967      */
968     function approve(address to, uint256 tokenId) public {
969         address owner = ownerOf(tokenId);
970         require(to != owner);
971         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
972 
973         _tokenApprovals[tokenId] = to;
974         emit Approval(owner, to, tokenId);
975     }
976 
977     /**
978      * @dev Gets the approved address for a token ID, or zero if no address set
979      * Reverts if the token ID does not exist.
980      * @param tokenId uint256 ID of the token to query the approval of
981      * @return address currently approved for the given token ID
982      */
983     function getApproved(uint256 tokenId) public view returns (address) {
984         require(_exists(tokenId));
985         return _tokenApprovals[tokenId];
986     }
987 
988     /**
989      * @dev Sets or unsets the approval of a given operator
990      * An operator is allowed to transfer all tokens of the sender on their behalf
991      * @param to operator address to set the approval
992      * @param approved representing the status of the approval to be set
993      */
994     function setApprovalForAll(address to, bool approved) public {
995         require(to != msg.sender);
996         _operatorApprovals[msg.sender][to] = approved;
997         emit ApprovalForAll(msg.sender, to, approved);
998     }
999 
1000     /**
1001      * @dev Tells whether an operator is approved by a given owner
1002      * @param owner owner address which you want to query the approval of
1003      * @param operator operator address which you want to query the approval of
1004      * @return bool whether the given operator is approved by the given owner
1005      */
1006     function isApprovedForAll(address owner, address operator) public view returns (bool) {
1007         return _operatorApprovals[owner][operator];
1008     }
1009 
1010     /**
1011      * @dev Transfers the ownership of a given token ID to another address
1012      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1013      * Requires the msg sender to be the owner, approved, or operator
1014      * @param from current owner of the token
1015      * @param to address to receive the ownership of the given token ID
1016      * @param tokenId uint256 ID of the token to be transferred
1017     */
1018     function transferFrom(address from, address to, uint256 tokenId) public {
1019         require(_isApprovedOrOwner(msg.sender, tokenId));
1020 
1021         _transferFrom(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev Safely transfers the ownership of a given token ID to another address
1026      * If the target address is a contract, it must implement `onERC721Received`,
1027      * which is called upon a safe transfer, and return the magic value
1028      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1029      * the transfer is reverted.
1030      *
1031      * Requires the msg sender to be the owner, approved, or operator
1032      * @param from current owner of the token
1033      * @param to address to receive the ownership of the given token ID
1034      * @param tokenId uint256 ID of the token to be transferred
1035     */
1036     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1037         safeTransferFrom(from, to, tokenId, "");
1038     }
1039 
1040     /**
1041      * @dev Safely transfers the ownership of a given token ID to another address
1042      * If the target address is a contract, it must implement `onERC721Received`,
1043      * which is called upon a safe transfer, and return the magic value
1044      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1045      * the transfer is reverted.
1046      * Requires the msg sender to be the owner, approved, or operator
1047      * @param from current owner of the token
1048      * @param to address to receive the ownership of the given token ID
1049      * @param tokenId uint256 ID of the token to be transferred
1050      * @param _data bytes data to send along with a safe transfer check
1051      */
1052     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
1053         transferFrom(from, to, tokenId);
1054         require(_checkOnERC721Received(from, to, tokenId, _data));
1055     }
1056 
1057     /**
1058      * @dev Returns whether the specified token exists
1059      * @param tokenId uint256 ID of the token to query the existence of
1060      * @return whether the token exists
1061      */
1062     function _exists(uint256 tokenId) internal view returns (bool) {
1063         address owner = _tokenOwner[tokenId];
1064         return owner != address(0);
1065     }
1066 
1067     /**
1068      * @dev Returns whether the given spender can transfer a given token ID
1069      * @param spender address of the spender to query
1070      * @param tokenId uint256 ID of the token to be transferred
1071      * @return bool whether the msg.sender is approved for the given token ID,
1072      *    is an operator of the owner, or is the owner of the token
1073      */
1074     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1075         address owner = ownerOf(tokenId);
1076         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1077     }
1078 
1079     /**
1080      * @dev Internal function to mint a new token
1081      * Reverts if the given token ID already exists
1082      * @param to The address that will own the minted token
1083      * @param tokenId uint256 ID of the token to be minted
1084      */
1085     function _mint(address to, uint256 tokenId) internal {
1086         require(to != address(0));
1087         require(!_exists(tokenId));
1088 
1089         _tokenOwner[tokenId] = to;
1090         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
1091 
1092         emit Transfer(address(0), to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev Internal function to burn a specific token
1097      * Reverts if the token does not exist
1098      * Deprecated, use _burn(uint256) instead.
1099      * @param owner owner of the token to burn
1100      * @param tokenId uint256 ID of the token being burned
1101      */
1102     function _burn(address owner, uint256 tokenId) internal {
1103         require(ownerOf(tokenId) == owner);
1104 
1105         _clearApproval(tokenId);
1106 
1107         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
1108         _tokenOwner[tokenId] = address(0);
1109 
1110         emit Transfer(owner, address(0), tokenId);
1111     }
1112 
1113     /**
1114      * @dev Internal function to burn a specific token
1115      * Reverts if the token does not exist
1116      * @param tokenId uint256 ID of the token being burned
1117      */
1118     function _burn(uint256 tokenId) internal {
1119         _burn(ownerOf(tokenId), tokenId);
1120     }
1121 
1122     /**
1123      * @dev Internal function to transfer ownership of a given token ID to another address.
1124      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1125      * @param from current owner of the token
1126      * @param to address to receive the ownership of the given token ID
1127      * @param tokenId uint256 ID of the token to be transferred
1128     */
1129     function _transferFrom(address from, address to, uint256 tokenId) internal {
1130         require(ownerOf(tokenId) == from);
1131         require(to != address(0));
1132 
1133         _clearApproval(tokenId);
1134 
1135         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
1136         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
1137 
1138         _tokenOwner[tokenId] = to;
1139 
1140         emit Transfer(from, to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Internal function to invoke `onERC721Received` on a target address
1145      * The call is not executed if the target address is not a contract
1146      * @param from address representing the previous owner of the given token ID
1147      * @param to target address that will receive the tokens
1148      * @param tokenId uint256 ID of the token to be transferred
1149      * @param _data bytes optional data to send along with the call
1150      * @return whether the call correctly returned the expected magic value
1151      */
1152     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1153         internal returns (bool)
1154     {
1155         if (!to.isContract()) {
1156             return true;
1157         }
1158 
1159         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1160         return (retval == _ERC721_RECEIVED);
1161     }
1162 
1163     /**
1164      * @dev Private function to clear current approval of a given token ID
1165      * @param tokenId uint256 ID of the token to be transferred
1166      */
1167     function _clearApproval(uint256 tokenId) private {
1168         if (_tokenApprovals[tokenId] != address(0)) {
1169             _tokenApprovals[tokenId] = address(0);
1170         }
1171     }
1172 }
1173 
1174 // File: contracts/NFTfi/v1/openzeppelin/IERC20.sol
1175 
1176 
1177 
1178 /**
1179  * @title ERC20 interface
1180  * @dev see https://github.com/ethereum/EIPs/issues/20
1181  */
1182 interface IERC20 {
1183     function transfer(address to, uint256 value) external returns (bool);
1184 
1185     function approve(address spender, uint256 value) external returns (bool);
1186 
1187     function transferFrom(address from, address to, uint256 value) external returns (bool);
1188 
1189     function totalSupply() external view returns (uint256);
1190 
1191     function balanceOf(address who) external view returns (uint256);
1192 
1193     function allowance(address owner, address spender) external view returns (uint256);
1194 
1195     event Transfer(address indexed from, address indexed to, uint256 value);
1196 
1197     event Approval(address indexed owner, address indexed spender, uint256 value);
1198 }
1199 
1200 // File: contracts/NFTfi/v1/NFTfi.sol
1201 
1202 pragma solidity ^0.5.16;
1203 
1204 
1205 
1206 
1207 
1208 
1209 // @title  Main contract for NFTfi. This contract manages the ability to create
1210 //         NFT-backed peer-to-peer loans.
1211 // @author smartcontractdev.eth, creator of wrappedkitties.eth, cwhelper.eth, and
1212 //         kittybounties.eth
1213 // @notice There are five steps needed to commence an NFT-backed loan. First,
1214 //         the borrower calls nftContract.approveAll(NFTfi), approving the NFTfi
1215 //         contract to move their NFT's on their behalf. Second, the borrower
1216 //         signs an off-chain message for each NFT that they would like to
1217 //         put up for collateral. This prevents borrowers from accidentally
1218 //         lending an NFT that they didn't mean to lend, due to approveAll()
1219 //         approving their entire collection. Third, the lender calls
1220 //         erc20Contract.approve(NFTfi), allowing NFTfi to move the lender's
1221 //         ERC20 tokens on their behalf. Fourth, the lender signs an off-chain
1222 //         message, proposing the amount, rate, and duration of a loan for a
1223 //         particular NFT. Fifth, the borrower calls NFTfi.beginLoan() to
1224 //         accept these terms and enter into the loan. The NFT is stored in the
1225 //         contract, the borrower receives the loan principal in the specified
1226 //         ERC20 currency, and the lender receives an NFTfi promissory note (in
1227 //         ERC721 form) that represents the rights to either the
1228 //         principal-plus-interest, or the underlying NFT collateral if the
1229 //         borrower does not pay back in time. The lender can freely transfer
1230 //         and trade this ERC721 promissory note as they wish, with the
1231 //         knowledge that transferring the ERC721 promissory note tranfsers the
1232 //         rights to principal-plus-interest and/or collateral, and that they
1233 //         will no longer have a claim on the loan. The ERC721 promissory note
1234 //         itself represents that claim.
1235 // @notice A loan may end in one of two ways. First, a borrower may call
1236 //         NFTfi.payBackLoan() and pay back the loan plus interest at any time,
1237 //         in which case they receive their NFT back in the same transaction.
1238 //         Second, if the loan's duration has passed and the loan has not been
1239 //         paid back yet, a lender can call NFTfi.liquidateOverdueLoan(), in
1240 //         which case they receive the underlying NFT collateral and forfeit
1241 //         the rights to the principal-plus-interest, which the borrower now
1242 //         keeps.
1243 // @notice If the loan was agreed to be a pro-rata interest loan, then the user
1244 //         only pays the principal plus pro-rata interest if repaid early.
1245 //         However, if the loan was agreed to be a fixed-repayment loan (by
1246 //         specifying UINT32_MAX as the value for
1247 //         loanInterestRateForDurationInBasisPoints), then the borrower pays
1248 //         the maximumRepaymentAmount regardless of whether they repay early
1249 //         or not.
1250 contract NFTfi is NFTfiAdmin, NFTfiSigningUtils, ERC721 {
1251 
1252     // @notice OpenZeppelin's SafeMath library is used for all arithmetic
1253     //         operations to avoid overflows/underflows.
1254     using SafeMath for uint256;
1255 
1256     /* ********** */
1257     /* DATA TYPES */
1258     /* ********** */
1259 
1260     // @notice The main Loan struct. The struct fits in six 256-bits words due
1261     //         to Solidity's rules for struct packing.
1262     struct Loan {
1263         // A unique identifier for this particular loan, sourced from the
1264         // continuously increasing parameter totalNumLoans.
1265         uint256 loanId;
1266         // The original sum of money transferred from lender to borrower at the
1267         // beginning of the loan, measured in loanERC20Denomination's smallest
1268         // units.
1269         uint256 loanPrincipalAmount;
1270         // The maximum amount of money that the borrower would be required to
1271         // repay retrieve their collateral, measured in loanERC20Denomination's
1272         // smallest units. If interestIsProRated is set to false, then the
1273         // borrower will always have to pay this amount to retrieve their
1274         // collateral, regardless of whether they repay early.
1275         uint256 maximumRepaymentAmount;
1276         // The ID within the NFTCollateralContract for the NFT being used as
1277         // collateral for this loan. The NFT is stored within this contract
1278         // during the duration of the loan.
1279         uint256 nftCollateralId;
1280         // The block.timestamp when the loan first began (measured in seconds).
1281         uint64 loanStartTime;
1282         // The amount of time (measured in seconds) that can elapse before the
1283         // lender can liquidate the loan and seize the underlying collateral.
1284         uint32 loanDuration;
1285         // If interestIsProRated is set to true, then this is the interest rate
1286         // (measured in basis points, e.g. hundreths of a percent) for the loan,
1287         // that must be repaid pro-rata by the borrower at the conclusion of
1288         // the loan or risk seizure of their nft collateral. Note that if
1289         // interestIsProRated is set to false, then this value is not used and
1290         // is irrelevant.
1291         uint32 loanInterestRateForDurationInBasisPoints;
1292         // The percent (measured in basis points) of the interest earned that
1293         // will be taken as a fee by the contract admins when the loan is
1294         // repaid. The fee is stored here to prevent an attack where the
1295         // contract admins could adjust the fee right before a loan is repaid,
1296         // and take all of the interest earned.
1297         uint32 loanAdminFeeInBasisPoints;
1298         // The ERC721 contract of the NFT collateral
1299         address nftCollateralContract;
1300         // The ERC20 contract of the currency being used as principal/interest
1301         // for this loan.
1302         address loanERC20Denomination;
1303         // The address of the borrower.
1304         address borrower;
1305         // A boolean value determining whether the interest will be pro-rated
1306         // if the loan is repaid early, or whether the borrower will simply
1307         // pay maximumRepaymentAmount.
1308         bool interestIsProRated;
1309     }
1310 
1311     /* ****** */
1312     /* EVENTS */
1313     /* ****** */
1314 
1315     // @notice This event is fired whenever a borrower begins a loan by calling
1316     //         NFTfi.beginLoan(), which can only occur after both the lender
1317     //         and borrower have approved their ERC721 and ERC20 contracts to
1318     //         use NFTfi, and when they both have signed off-chain messages that
1319     //         agree on the terms of the loan.
1320     // @param  loanId - A unique identifier for this particular loan, sourced
1321     //         from the continuously increasing parameter totalNumLoans.
1322     // @param  borrower - The address of the borrower.
1323     // @param  lender - The address of the lender. The lender can change their
1324     //         address by transferring the NFTfi ERC721 token that they
1325     //         received when the loan began.
1326     // @param  loanPrincipalAmount - The original sum of money transferred from
1327     //         lender to borrower at the beginning of the loan, measured in
1328     //         loanERC20Denomination's smallest units.
1329     // @param  maximumRepaymentAmount - The maximum amount of money that the
1330     //         borrower would be required to retrieve their collateral. If
1331     //         interestIsProRated is set to false, then the borrower will
1332     //         always have to pay this amount to retrieve their collateral.
1333     // @param  nftCollateralId - The ID within the NFTCollateralContract for the
1334     //         NFT being used as collateral for this loan. The NFT is stored
1335     //         within this contract during the duration of the loan.
1336     // @param  loanStartTime - The block.timestamp when the loan first began
1337     //         (measured in seconds).
1338     // @param  loanDuration - The amount of time (measured in seconds) that can
1339     //         elapse before the lender can liquidate the loan and seize the
1340     //         underlying collateral NFT.
1341     // @param  loanInterestRateForDurationInBasisPoints - If interestIsProRated
1342     //         is set to true, then this is the interest rate (measured in
1343     //         basis points, e.g. hundreths of a percent) for the loan, that
1344     //         must be repaid pro-rata by the borrower at the conclusion of the
1345     //         loan or risk seizure of their nft collateral. Note that if
1346     //         interestIsProRated is set to false, then this value is not used
1347     //         and is irrelevant.
1348     // @param  nftCollateralContract - The ERC721 contract of the NFT collateral
1349     // @param  loanERC20Denomination - The ERC20 contract of the currency being
1350     //         used as principal/interest for this loan.
1351     // @param  interestIsProRated - A boolean value determining whether the
1352     //         interest will be pro-rated if the loan is repaid early, or
1353     //         whether the borrower will simply pay maximumRepaymentAmount.
1354     event LoanStarted(
1355         uint256 loanId,
1356         address borrower,
1357         address lender,
1358         uint256 loanPrincipalAmount,
1359         uint256 maximumRepaymentAmount,
1360         uint256 nftCollateralId,
1361         uint256 loanStartTime,
1362         uint256 loanDuration,
1363         uint256 loanInterestRateForDurationInBasisPoints,
1364         address nftCollateralContract,
1365         address loanERC20Denomination,
1366         bool interestIsProRated
1367     );
1368 
1369     // @notice This event is fired whenever a borrower successfully repays
1370     //         their loan, paying principal-plus-interest-minus-fee to the
1371     //         lender in loanERC20Denomination, paying fee to owner in
1372     //         loanERC20Denomination, and receiving their NFT collateral back.
1373     // @param  loanId - A unique identifier for this particular loan, sourced
1374     //         from the continuously increasing parameter totalNumLoans.
1375     // @param  borrower - The address of the borrower.
1376     // @param  lender - The address of the lender. The lender can change their
1377     //         address by transferring the NFTfi ERC721 token that they
1378     //         received when the loan began.
1379     // @param  loanPrincipalAmount - The original sum of money transferred from
1380     //         lender to borrower at the beginning of the loan, measured in
1381     //         loanERC20Denomination's smallest units.
1382     // @param  nftCollateralId - The ID within the NFTCollateralContract for the
1383     //         NFT being used as collateral for this loan. The NFT is stored
1384     //         within this contract during the duration of the loan.
1385     // @param  amountPaidToLender The amount of ERC20 that the borrower paid to
1386     //         the lender, measured in the smalled units of
1387     //         loanERC20Denomination.
1388     // @param  adminFee The amount of interest paid to the contract admins,
1389     //         measured in the smalled units of loanERC20Denomination and
1390     //         determined by adminFeeInBasisPoints. This amount never exceeds
1391     //         the amount of interest earned.
1392     // @param  nftCollateralContract - The ERC721 contract of the NFT collateral
1393     // @param  loanERC20Denomination - The ERC20 contract of the currency being
1394     //         used as principal/interest for this loan.
1395     event LoanRepaid(
1396         uint256 loanId,
1397         address borrower,
1398         address lender,
1399         uint256 loanPrincipalAmount,
1400         uint256 nftCollateralId,
1401         uint256 amountPaidToLender,
1402         uint256 adminFee,
1403         address nftCollateralContract,
1404         address loanERC20Denomination
1405     );
1406 
1407     // @notice This event is fired whenever a lender liquidates an outstanding
1408     //         loan that is owned to them that has exceeded its duration. The
1409     //         lender receives the underlying NFT collateral, and the borrower
1410     //         no longer needs to repay the loan principal-plus-interest.
1411     // @param  loanId - A unique identifier for this particular loan, sourced
1412     //         from the continuously increasing parameter totalNumLoans.
1413     // @param  borrower - The address of the borrower.
1414     // @param  lender - The address of the lender. The lender can change their
1415     //         address by transferring the NFTfi ERC721 token that they
1416     //         received when the loan began.
1417     // @param  loanPrincipalAmount - The original sum of money transferred from
1418     //         lender to borrower at the beginning of the loan, measured in
1419     //         loanERC20Denomination's smallest units.
1420     // @param  nftCollateralId - The ID within the NFTCollateralContract for the
1421     //         NFT being used as collateral for this loan. The NFT is stored
1422     //         within this contract during the duration of the loan.
1423     // @param  loanMaturityDate - The unix time (measured in seconds) that the
1424     //         loan became due and was eligible for liquidation.
1425     // @param  loanLiquidationDate - The unix time (measured in seconds) that
1426     //         liquidation occurred.
1427     // @param  nftCollateralContract - The ERC721 contract of the NFT collateral
1428     event LoanLiquidated(
1429         uint256 loanId,
1430         address borrower,
1431         address lender,
1432         uint256 loanPrincipalAmount,
1433         uint256 nftCollateralId,
1434         uint256 loanMaturityDate,
1435         uint256 loanLiquidationDate,
1436         address nftCollateralContract
1437     );
1438 
1439 
1440     /* ******* */
1441     /* STORAGE */
1442     /* ******* */
1443 
1444     // @notice A continuously increasing counter that simultaneously allows
1445     //         every loan to have a unique ID and provides a running count of
1446     //         how many loans have been started by this contract.
1447     uint256 public totalNumLoans = 0;
1448 
1449     // @notice A counter of the number of currently outstanding loans.
1450     uint256 public totalActiveLoans = 0;
1451 
1452     // @notice A mapping from a loan's identifier to the loan's details,
1453     //         represted by the loan struct. To fetch the lender, call
1454     //         NFTfi.ownerOf(loanId).
1455     mapping (uint256 => Loan) public loanIdToLoan;
1456 
1457     // @notice A mapping tracking whether a loan has either been repaid or
1458     //         liquidated. This prevents an attacker trying to repay or
1459     //         liquidate the same loan twice.
1460     mapping (uint256 => bool) public loanRepaidOrLiquidated;
1461 
1462     // @notice A mapping that takes both a user's address and a loan nonce
1463     //         that was first used when signing an off-chain order and checks
1464     //         whether that nonce has previously either been used for a loan,
1465     //         or has been pre-emptively cancelled. The nonce referred to here
1466     //         is not the same as an Ethereum account's nonce. We are referring
1467     //         instead to nonces that are used by both the lender and the
1468     //         borrower when they are first signing off-chain NFTfi orders.
1469     //         These nonces can be any uint256 value that the user has not
1470     //         previously used to sign an off-chain order. Each nonce can be
1471     //         used at most once per user within NFTfi, regardless of whether
1472     //         they are the lender or the borrower in that situation. This
1473     //         serves two purposes. First, it prevents replay attacks where an
1474     //         attacker would submit a user's off-chain order more than once.
1475     //         Second, it allows a user to cancel an off-chain order by calling
1476     //         NFTfi.cancelLoanCommitmentBeforeLoanHasBegun(), which marks the
1477     //         nonce as used and prevents any future loan from using the user's
1478     //         off-chain order that contains that nonce.
1479     mapping (address => mapping (uint256 => bool)) private _nonceHasBeenUsedForUser;
1480 
1481     /* *********** */
1482     /* CONSTRUCTOR */
1483     /* *********** */
1484 
1485     constructor() public {}
1486 
1487     /* ********* */
1488     /* FUNCTIONS */
1489     /* ********* */
1490 
1491     // @notice This function is called by a borrower when they want to commence
1492     //         a loan, but can only be called after first: (1) the borrower has
1493     //         called approve() or approveAll() on the NFT contract for the NFT
1494     //         that will be used as collateral, (2) the borrower has signed an
1495     //         off-chain message indicating that they are willing to use this
1496     //         NFT as collateral, (3) the lender has called approve() on the
1497     //         ERC20 contract of the principal, and (4) the lender has signed
1498     //         an off-chain message agreeing to the terms of this loan supplied
1499     //         in this transaction.
1500     // @notice Note that a user may submit UINT32_MAX as the value for
1501     //         _loanInterestRateForDurationInBasisPoints to indicate that they
1502     //         wish to take out a fixed-repayment loan, where the interest is
1503     //         not pro-rated if repaid early.
1504     // @param  _loanPrincipalAmount - The original sum of money transferred
1505     //         from lender to borrower at the beginning of the loan, measured
1506     //         in loanERC20Denomination's smallest units.
1507     // @param  _maximumRepaymentAmount - The maximum amount of money that the
1508     //         borrower would be required to retrieve their collateral,
1509     //         measured in the smallest units of the ERC20 currency used for
1510     //         the loan. If interestIsProRated is set to false (by submitting
1511     //         a value of UINT32_MAX for
1512     //         _loanInterestRateForDurationInBasisPoints), then the borrower
1513     //         will always have to pay this amount to retrieve their
1514     //         collateral, regardless of whether they repay early.
1515     // @param  _nftCollateralId - The ID within the NFTCollateralContract for
1516     //         the NFT being used as collateral for this loan. The NFT is
1517     //         stored within this contract during the duration of the loan.
1518     // @param  _loanDuration - The amount of time (measured in seconds) that can
1519     //         elapse before the lender can liquidate the loan and seize the
1520     //         underlying collateral NFT.
1521     // @param  _loanInterestRateForDurationInBasisPoints - The interest rate
1522     //         (measured in basis points, e.g. hundreths of a percent) for the
1523     //         loan, that must be repaid pro-rata by the borrower at the
1524     //         conclusion of the loan or risk seizure of their nft collateral.
1525     //         However, a user may submit UINT32_MAX as the value for
1526     //         _loanInterestRateForDurationInBasisPoints to indicate that they
1527     //         wish to take out a fixed-repayment loan, where the interest is
1528     //         not pro-rated if repaid early. Instead, maximumRepaymentAmount
1529     //         will always be the amount to be repaid.
1530     // @param  _adminFeeInBasisPoints - The percent (measured in basis
1531     //         points) of the interest earned that will be taken as a fee by
1532     //         the contract admins when the loan is repaid. The fee is stored
1533     //         in the loan struct to prevent an attack where the contract
1534     //         admins could adjust the fee right before a loan is repaid, and
1535     //         take all of the interest earned.
1536     // @param  _borrowerAndLenderNonces - An array of two UINT256 values, the
1537     //         first of which is the _borrowerNonce and the second of which is
1538     //         the _lenderNonce. The nonces referred to here are not the same
1539     //         as an Ethereum account's nonce. We are referring instead to
1540     //         nonces that are used by both the lender and the borrower when
1541     //         they are first signing off-chain NFTfi orders. These nonces can
1542     //         be any uint256 value that the user has not previously used to
1543     //         sign an off-chain order. Each nonce can be used at most once per
1544     //         user within NFTfi, regardless of whether they are the lender or
1545     //         the borrower in that situation. This serves two purposes. First,
1546     //         it prevents replay attacks where an attacker would submit a
1547     //         user's off-chain order more than once. Second, it allows a user
1548     //         to cancel an off-chain order by calling
1549     //         NFTfi.cancelLoanCommitmentBeforeLoanHasBegun(), which marks the
1550     //         nonce as used and prevents any future loan from using the user's
1551     //         off-chain order that contains that nonce.
1552     // @param  _nftCollateralContract - The address of the ERC721 contract of
1553     //         the NFT collateral.
1554     // @param  _loanERC20Denomination - The address of the ERC20 contract of
1555     //         the currency being used as principal/interest for this loan.
1556     // @param  _lender - The address of the lender. The lender can change their
1557     //         address by transferring the NFTfi ERC721 token that they
1558     //         received when the loan began.
1559     // @param  _borrowerSignature - The ECDSA signature of the borrower,
1560     //         obtained off-chain ahead of time, signing the following
1561     //         combination of parameters: _nftCollateralId, _borrowerNonce,
1562     //         _nftCollateralContract, _borrower.
1563     // @param  _lenderSignature - The ECDSA signature of the lender,
1564     //         obtained off-chain ahead of time, signing the following
1565     //         combination of parameters: _loanPrincipalAmount,
1566     //         _maximumRepaymentAmount _nftCollateralId, _loanDuration,
1567     //         _loanInterestRateForDurationInBasisPoints, _lenderNonce,
1568     //         _nftCollateralContract, _loanERC20Denomination, _lender,
1569     //         _interestIsProRated.
1570     function beginLoan(
1571         uint256 _loanPrincipalAmount,
1572         uint256 _maximumRepaymentAmount,
1573         uint256 _nftCollateralId,
1574         uint256 _loanDuration,
1575         uint256 _loanInterestRateForDurationInBasisPoints,
1576         uint256 _adminFeeInBasisPoints,
1577         uint256[2] memory _borrowerAndLenderNonces,
1578         address _nftCollateralContract,
1579         address _loanERC20Denomination,
1580         address _lender,
1581         bytes memory _borrowerSignature,
1582         bytes memory _lenderSignature
1583     ) public whenNotPaused nonReentrant {
1584 
1585         // Save loan details to a struct in memory first, to save on gas if any
1586         // of the below checks fail, and to avoid the "Stack Too Deep" error by
1587         // clumping the parameters together into one struct held in memory.
1588         Loan memory loan = Loan({
1589             loanId: totalNumLoans, //currentLoanId,
1590             loanPrincipalAmount: _loanPrincipalAmount,
1591             maximumRepaymentAmount: _maximumRepaymentAmount,
1592             nftCollateralId: _nftCollateralId,
1593             loanStartTime: uint64(now), //_loanStartTime
1594             loanDuration: uint32(_loanDuration),
1595             loanInterestRateForDurationInBasisPoints: uint32(_loanInterestRateForDurationInBasisPoints),
1596             loanAdminFeeInBasisPoints: uint32(_adminFeeInBasisPoints),
1597             nftCollateralContract: _nftCollateralContract,
1598             loanERC20Denomination: _loanERC20Denomination,
1599             borrower: msg.sender, //borrower
1600             interestIsProRated: (_loanInterestRateForDurationInBasisPoints != ~(uint32(0)))
1601         });
1602 
1603         // Sanity check loan values.
1604         require(loan.maximumRepaymentAmount >= loan.loanPrincipalAmount, 'Negative interest rate loans are not allowed.');
1605         require(uint256(loan.loanDuration) <= maximumLoanDuration, 'Loan duration exceeds maximum loan duration');
1606         require(uint256(loan.loanDuration) != 0, 'Loan duration cannot be zero');
1607         require(uint256(loan.loanAdminFeeInBasisPoints) == adminFeeInBasisPoints, 'The admin fee has changed since this order was signed.');
1608 
1609         // Check that both the collateral and the principal come from supported
1610         // contracts.
1611         require(erc20CurrencyIsWhitelisted[loan.loanERC20Denomination], 'Currency denomination is not whitelisted to be used by this contract');
1612         require(nftContractIsWhitelisted[loan.nftCollateralContract], 'NFT collateral contract is not whitelisted to be used by this contract');
1613 
1614         // Check loan nonces. These are different from Ethereum account nonces.
1615         // Here, these are uint256 numbers that should uniquely identify
1616         // each signature for each user (i.e. each user should only create one
1617         // off-chain signature for each nonce, with a nonce being any arbitrary
1618         // uint256 value that they have not used yet for an off-chain NFTfi
1619         // signature).
1620         require(!_nonceHasBeenUsedForUser[msg.sender][_borrowerAndLenderNonces[0]], 'Borrower nonce invalid, borrower has either cancelled/begun this loan, or reused this nonce when signing');
1621         _nonceHasBeenUsedForUser[msg.sender][_borrowerAndLenderNonces[0]] = true;
1622         require(!_nonceHasBeenUsedForUser[_lender][_borrowerAndLenderNonces[1]], 'Lender nonce invalid, lender has either cancelled/begun this loan, or reused this nonce when signing');
1623         _nonceHasBeenUsedForUser[_lender][_borrowerAndLenderNonces[1]] = true;
1624 
1625         // Check that both signatures are valid.
1626         require(isValidBorrowerSignature(
1627             loan.nftCollateralId,
1628             _borrowerAndLenderNonces[0],//_borrowerNonce,
1629             loan.nftCollateralContract,
1630             msg.sender,      //borrower,
1631             _borrowerSignature
1632         ), 'Borrower signature is invalid');
1633         require(isValidLenderSignature(
1634             loan.loanPrincipalAmount,
1635             loan.maximumRepaymentAmount,
1636             loan.nftCollateralId,
1637             loan.loanDuration,
1638             loan.loanInterestRateForDurationInBasisPoints,
1639             loan.loanAdminFeeInBasisPoints,
1640             _borrowerAndLenderNonces[1],//_lenderNonce,
1641             loan.nftCollateralContract,
1642             loan.loanERC20Denomination,
1643             _lender,
1644             loan.interestIsProRated,
1645             _lenderSignature
1646         ), 'Lender signature is invalid');
1647 
1648         // Add the loan to storage before moving collateral/principal to follow
1649         // the Checks-Effects-Interactions pattern.
1650         loanIdToLoan[totalNumLoans] = loan;
1651         totalNumLoans = totalNumLoans.add(1);
1652 
1653         // Update number of active loans.
1654         totalActiveLoans = totalActiveLoans.add(1);
1655         require(totalActiveLoans <= maximumNumberOfActiveLoans, 'Contract has reached the maximum number of active loans allowed by admins');
1656 
1657         // Transfer collateral from borrower to this contract to be held until
1658         // loan completion.
1659         IERC721(loan.nftCollateralContract).transferFrom(msg.sender, address(this), loan.nftCollateralId);
1660 
1661         // Transfer principal from lender to borrower.
1662         IERC20(loan.loanERC20Denomination).transferFrom(_lender, msg.sender, loan.loanPrincipalAmount);
1663 
1664         // Issue an ERC721 promissory note to the lender that gives them the
1665         // right to either the principal-plus-interest or the collateral.
1666         _mint(_lender, loan.loanId);
1667 
1668         // Emit an event with all relevant details from this transaction.
1669         emit LoanStarted(
1670             loan.loanId,
1671             msg.sender,      //borrower,
1672             _lender,
1673             loan.loanPrincipalAmount,
1674             loan.maximumRepaymentAmount,
1675             loan.nftCollateralId,
1676             now,             //_loanStartTime
1677             loan.loanDuration,
1678             loan.loanInterestRateForDurationInBasisPoints,
1679             loan.nftCollateralContract,
1680             loan.loanERC20Denomination,
1681             loan.interestIsProRated
1682         );
1683     }
1684 
1685     // @notice This function is called by a borrower when they want to repay
1686     //         their loan. It can be called at any time after the loan has
1687     //         begun. The borrower will pay a pro-rata portion of their
1688     //         interest if the loan is paid off early. The interest will
1689     //         continue to accrue after the loan has expired. This function can
1690     //         continue to be called by the borrower even after the loan has
1691     //         expired to retrieve their NFT. Note that the lender can call
1692     //         NFTfi.liquidateOverdueLoan() at any time after the loan has
1693     //         expired, so a borrower should avoid paying their loan after the
1694     //         due date, as they risk their collateral being seized. However,
1695     //         if a lender has called NFTfi.liquidateOverdueLoan() before a
1696     //         borrower could call NFTfi.payBackLoan(), the borrower will get
1697     //         to keep the principal-plus-interest.
1698     // @notice This function is purposefully not pausable in order to prevent
1699     //         an attack where the contract admin's pause the contract and hold
1700     //         hostage the NFT's that are still within it.
1701     // @param _loanId  A unique identifier for this particular loan, sourced
1702     //        from the continuously increasing parameter totalNumLoans.
1703     function payBackLoan(uint256 _loanId) external nonReentrant {
1704         // Sanity check that payBackLoan() and liquidateOverdueLoan() have
1705         // never been called on this loanId. Depending on how the rest of the
1706         // code turns out, this check may be unnecessary.
1707         require(!loanRepaidOrLiquidated[_loanId], 'Loan has already been repaid or liquidated');
1708 
1709         // Fetch loan details from storage, but store them in memory for the
1710         // sake of saving gas.
1711         Loan memory loan = loanIdToLoan[_loanId];
1712 
1713         // Check that the borrower is the caller, only the borrower is entitled
1714         // to the collateral.
1715         require(msg.sender == loan.borrower, 'Only the borrower can pay back a loan and reclaim the underlying NFT');
1716 
1717         // Fetch current owner of loan promissory note.
1718         address lender = ownerOf(_loanId);
1719 
1720         // Calculate amounts to send to lender and admins
1721         uint256 interestDue = (loan.maximumRepaymentAmount).sub(loan.loanPrincipalAmount);
1722         if(loan.interestIsProRated == true){
1723             interestDue = _computeInterestDue(
1724                 loan.loanPrincipalAmount,
1725                 loan.maximumRepaymentAmount,
1726                 now.sub(uint256(loan.loanStartTime)),
1727                 uint256(loan.loanDuration),
1728                 uint256(loan.loanInterestRateForDurationInBasisPoints)
1729             );
1730         }
1731         uint256 adminFee = _computeAdminFee(interestDue, uint256(loan.loanAdminFeeInBasisPoints));
1732         uint256 payoffAmount = ((loan.loanPrincipalAmount).add(interestDue)).sub(adminFee);
1733 
1734         // Mark loan as repaid before doing any external transfers to follow
1735         // the Checks-Effects-Interactions design pattern.
1736         loanRepaidOrLiquidated[_loanId] = true;
1737 
1738         // Update number of active loans.
1739         totalActiveLoans = totalActiveLoans.sub(1);
1740 
1741         // Transfer principal-plus-interest-minus-fees from borrower to lender
1742         IERC20(loan.loanERC20Denomination).transferFrom(loan.borrower, lender, payoffAmount);
1743 
1744         // Transfer fees from borrower to admins
1745         IERC20(loan.loanERC20Denomination).transferFrom(loan.borrower, owner(), adminFee);
1746 
1747         // Transfer collateral from this contract to borrower.
1748         require(_transferNftToAddress(
1749             loan.nftCollateralContract,
1750             loan.nftCollateralId,
1751             loan.borrower
1752         ), 'NFT was not successfully transferred');
1753 
1754         // Destroy the lender's promissory note.
1755         _burn(_loanId);
1756 
1757         // Emit an event with all relevant details from this transaction.
1758         emit LoanRepaid(
1759             _loanId,
1760             loan.borrower,
1761             lender,
1762             loan.loanPrincipalAmount,
1763             loan.nftCollateralId,
1764             payoffAmount,
1765             adminFee,
1766             loan.nftCollateralContract,
1767             loan.loanERC20Denomination
1768         );
1769 
1770         // Delete the loan from storage in order to achieve a substantial gas
1771         // savings and to lessen the burden of storage on Ethereum nodes, since
1772         // we will never access this loan's details again, and the details are
1773         // still available through event data.
1774         delete loanIdToLoan[_loanId];
1775     }
1776 
1777     // @notice This function is called by a lender once a loan has finished its
1778     //         duration and the borrower still has not repaid. The lender
1779     //         can call this function to seize the underlying NFT collateral,
1780     //         although the lender gives up all rights to the
1781     //         principal-plus-collateral by doing so.
1782     // @notice This function is purposefully not pausable in order to prevent
1783     //         an attack where the contract admin's pause the contract and hold
1784     //         hostage the NFT's that are still within it.
1785     // @notice We intentionally allow anybody to call this function, although
1786     //         only the lender will end up receiving the seized collateral. We
1787     //         are exploring the possbility of incentivizing users to call this
1788     //         function by using some of the admin funds.
1789     // @param _loanId  A unique identifier for this particular loan, sourced
1790     //        from the continuously increasing parameter totalNumLoans.
1791     function liquidateOverdueLoan(uint256 _loanId) external nonReentrant {
1792         // Sanity check that payBackLoan() and liquidateOverdueLoan() have
1793         // never been called on this loanId. Depending on how the rest of the
1794         // code turns out, this check may be unnecessary.
1795         require(!loanRepaidOrLiquidated[_loanId], 'Loan has already been repaid or liquidated');
1796 
1797         // Fetch loan details from storage, but store them in memory for the
1798         // sake of saving gas.
1799         Loan memory loan = loanIdToLoan[_loanId];
1800 
1801         // Ensure that the loan is indeed overdue, since we can only liquidate
1802         // overdue loans.
1803         uint256 loanMaturityDate = (uint256(loan.loanStartTime)).add(uint256(loan.loanDuration));
1804         require(now > loanMaturityDate, 'Loan is not overdue yet');
1805 
1806         // Fetch the current lender of the promissory note corresponding to
1807         // this overdue loan.
1808         address lender = ownerOf(_loanId);
1809 
1810         // Mark loan as liquidated before doing any external transfers to
1811         // follow the Checks-Effects-Interactions design pattern.
1812         loanRepaidOrLiquidated[_loanId] = true;
1813 
1814         // Update number of active loans.
1815         totalActiveLoans = totalActiveLoans.sub(1);
1816 
1817         // Transfer collateral from this contract to the lender, since the
1818         // lender is seizing collateral for an overdue loan.
1819         require(_transferNftToAddress(
1820             loan.nftCollateralContract,
1821             loan.nftCollateralId,
1822             lender
1823         ), 'NFT was not successfully transferred');
1824 
1825         // Destroy the lender's promissory note for this loan, since by seizing
1826         // the collateral, the lender has forfeit the rights to the loan
1827         // principal-plus-interest.
1828         _burn(_loanId);
1829 
1830         // Emit an event with all relevant details from this transaction.
1831         emit LoanLiquidated(
1832             _loanId,
1833             loan.borrower,
1834             lender,
1835             loan.loanPrincipalAmount,
1836             loan.nftCollateralId,
1837             loanMaturityDate,
1838             now,
1839             loan.nftCollateralContract
1840         );
1841 
1842         // Delete the loan from storage in order to achieve a substantial gas
1843         // savings and to lessen the burden of storage on Ethereum nodes, since
1844         // we will never access this loan's details again, and the details are
1845         // still available through event data.
1846         delete loanIdToLoan[_loanId];
1847     }
1848 
1849     // @notice This function can be called by either a lender or a borrower to
1850     //         cancel all off-chain orders that they have signed that contain
1851     //         this nonce. If the off-chain orders were created correctly,
1852     //         there should only be one off-chain order that contains this
1853     //         nonce at all.
1854     // @param  _nonce - The nonce referred to here is not the same as an
1855     //         Ethereum account's nonce. We are referring instead to nonces
1856     //         that are used by both the lender and the borrower when they are
1857     //         first signing off-chain NFTfi orders. These nonces can be any
1858     //         uint256 value that the user has not previously used to sign an
1859     //         off-chain order. Each nonce can be used at most once per user
1860     //         within NFTfi, regardless of whether they are the lender or the
1861     //         borrower in that situation. This serves two purposes. First, it
1862     //         prevents replay attacks where an attacker would submit a user's
1863     //         off-chain order more than once. Second, it allows a user to
1864     //         cancel an off-chain order by calling
1865     //         NFTfi.cancelLoanCommitmentBeforeLoanHasBegun(), which marks the
1866     //         nonce as used and prevents any future loan from using the user's
1867     //         off-chain order that contains that nonce.
1868     function cancelLoanCommitmentBeforeLoanHasBegun(uint256 _nonce) external {
1869         require(!_nonceHasBeenUsedForUser[msg.sender][_nonce], 'Nonce invalid, user has either cancelled/begun this loan, or reused a nonce when signing');
1870         _nonceHasBeenUsedForUser[msg.sender][_nonce] = true;
1871     }
1872 
1873     /* ******************* */
1874     /* READ-ONLY FUNCTIONS */
1875     /* ******************* */
1876 
1877     // @notice This function can be used to view the current quantity of the
1878     //         ERC20 currency used in the specified loan required by the
1879     //         borrower to repay their loan, measured in the smallest unit of
1880     //         the ERC20 currency. Note that since interest accrues every
1881     //         second, once a borrower calls repayLoan(), the amount will have
1882     //         increased slightly.
1883     // @param  _loanId  A unique identifier for this particular loan, sourced
1884     //         from the continuously increasing parameter totalNumLoans.
1885     // @return The amount of the specified ERC20 currency required to pay back
1886     //         this loan, measured in the smallest unit of the specified ERC20
1887     //         currency.
1888     function getPayoffAmount(uint256 _loanId) public view returns (uint256) {
1889         Loan storage loan = loanIdToLoan[_loanId];
1890         if(loan.interestIsProRated == false){
1891             return loan.maximumRepaymentAmount;
1892         } else {
1893             uint256 loanDurationSoFarInSeconds = now.sub(uint256(loan.loanStartTime));
1894             uint256 interestDue = _computeInterestDue(loan.loanPrincipalAmount, loan.maximumRepaymentAmount, loanDurationSoFarInSeconds, uint256(loan.loanDuration), uint256(loan.loanInterestRateForDurationInBasisPoints));
1895             return (loan.loanPrincipalAmount).add(interestDue);
1896         }
1897     }
1898 
1899     // @notice This function can be used to view whether a particular nonce
1900     //         for a particular user has already been used, either from a
1901     //         successful loan or a cancelled off-chain order.
1902     // @param  _user - The address of the user. This function works for both
1903     //         lenders and borrowers alike.
1904     // @param  _nonce - The nonce referred to here is not the same as an
1905     //         Ethereum account's nonce. We are referring instead to nonces
1906     //         that are used by both the lender and the borrower when they are
1907     //         first signing off-chain NFTfi orders. These nonces can be any
1908     //         uint256 value that the user has not previously used to sign an
1909     //         off-chain order. Each nonce can be used at most once per user
1910     //         within NFTfi, regardless of whether they are the lender or the
1911     //         borrower in that situation. This serves two purposes. First, it
1912     //         prevents replay attacks where an attacker would submit a user's
1913     //         off-chain order more than once. Second, it allows a user to
1914     //         cancel an off-chain order by calling
1915     //         NFTfi.cancelLoanCommitmentBeforeLoanHasBegun(), which marks the
1916     //         nonce as used and prevents any future loan from using the user's
1917     //         off-chain order that contains that nonce.
1918     // @return A bool representing whether or not this nonce has been used for
1919     //         this user.
1920     function getWhetherNonceHasBeenUsedForUser(address _user, uint256 _nonce) public view returns (bool) {
1921         return _nonceHasBeenUsedForUser[_user][_nonce];
1922     }
1923 
1924     /* ****************** */
1925     /* INTERNAL FUNCTIONS */
1926     /* ****************** */
1927 
1928     // @notice A convenience function that calculates the amount of interest
1929     //         currently due for a given loan. The interest is capped at
1930     //         _maximumRepaymentAmount minus _loanPrincipalAmount.
1931     // @param  _loanPrincipalAmount - The total quantity of principal first
1932     //         loaned to the borrower, measured in the smallest units of the
1933     //         ERC20 currency used for the loan.
1934     // @param  _maximumRepaymentAmount - The maximum amount of money that the
1935     //         borrower would be required to retrieve their collateral. If
1936     //         interestIsProRated is set to false, then the borrower will
1937     //         always have to pay this amount to retrieve their collateral.
1938     // @param  _loanDurationSoFarInSeconds - The elapsed time (in seconds) that
1939     //         has occurred so far since the loan began until repayment.
1940     // @param  _loanTotalDurationAgreedTo - The original duration that the
1941     //         borrower and lender agreed to, by which they measured the
1942     //         interest that would be due.
1943     // @param  _loanInterestRateForDurationInBasisPoints - The interest rate
1944     ///        that the borrower and lender agreed would be due after the
1945     //         totalDuration passed.
1946     // @return The quantity of interest due, measured in the smallest units of
1947     //         the ERC20 currency used to pay this loan.
1948     function _computeInterestDue(uint256 _loanPrincipalAmount, uint256 _maximumRepaymentAmount, uint256 _loanDurationSoFarInSeconds, uint256 _loanTotalDurationAgreedTo, uint256 _loanInterestRateForDurationInBasisPoints) internal pure returns (uint256) {
1949         uint256 interestDueAfterEntireDuration = (_loanPrincipalAmount.mul(_loanInterestRateForDurationInBasisPoints)).div(uint256(10000));
1950         uint256 interestDueAfterElapsedDuration = (interestDueAfterEntireDuration.mul(_loanDurationSoFarInSeconds)).div(_loanTotalDurationAgreedTo);
1951         if(_loanPrincipalAmount.add(interestDueAfterElapsedDuration) > _maximumRepaymentAmount){
1952             return _maximumRepaymentAmount.sub(_loanPrincipalAmount);
1953         } else {
1954             return interestDueAfterElapsedDuration;
1955         }
1956     }
1957 
1958     // @notice A convenience function computing the adminFee taken from a
1959     //         specified quantity of interest
1960     // @param  _interestDue - The amount of interest due, measured in the
1961     //         smallest quantity of the ERC20 currency being used to pay the
1962     //         interest.
1963     // @param  _adminFeeInBasisPoints - The percent (measured in basis
1964     //         points) of the interest earned that will be taken as a fee by
1965     //         the contract admins when the loan is repaid. The fee is stored
1966     //         in the loan struct to prevent an attack where the contract
1967     //         admins could adjust the fee right before a loan is repaid, and
1968     //         take all of the interest earned.
1969     // @return The quantity of ERC20 currency (measured in smalled units of
1970     //         that ERC20 currency) that is due as an admin fee.
1971     function _computeAdminFee(uint256 _interestDue, uint256 _adminFeeInBasisPoints) internal pure returns (uint256) {
1972     	return (_interestDue.mul(_adminFeeInBasisPoints)).div(10000);
1973     }
1974 
1975     // @notice We call this function when we wish to transfer an NFT from our
1976     //         contract to another destination. Since some prominent NFT
1977     //         contracts do not conform to the same standard, we try multiple
1978     //         variations on transfer/transferFrom, and check whether any
1979     //         succeeded.
1980     // @notice Some nft contracts will not allow you to approve your own
1981     //         address or do not allow you to call transferFrom() when you are
1982     //         the sender, (for example, CryptoKitties does not allow you to),
1983     //         while other nft contracts do not implement transfer() (since it
1984     //         is not part of the official ERC721 standard but is implemented
1985     //         in some prominent nft projects such as Cryptokitties), so we
1986     //         must try calling transferFrom() and transfer(), and see if one
1987     //         succeeds.
1988     // @param  _nftContract - The NFT contract that we are attempting to
1989     //         transfer an NFT from.
1990     // @param  _nftId - The ID of the NFT that we are attempting to transfer.
1991     // @param  _recipient - The destination of the NFT that we are attempting
1992     //         to transfer.
1993     // @return A bool value indicating whether the transfer attempt succeeded.
1994     function _transferNftToAddress(address _nftContract, uint256 _nftId, address _recipient) internal returns (bool) {
1995         // Try to call transferFrom()
1996         bool transferFromSucceeded = _attemptTransferFrom(_nftContract, _nftId, _recipient);
1997         if(transferFromSucceeded){
1998             return true;
1999         } else {
2000             // Try to call transfer()
2001             bool transferSucceeded = _attemptTransfer(_nftContract, _nftId, _recipient);
2002             return transferSucceeded;
2003         }
2004     }
2005 
2006     // @notice This function attempts to call transferFrom() on the specified
2007     //         NFT contract, returning whether it succeeded.
2008     // @notice We only call this function from within _transferNftToAddress(),
2009     //         which is function attempts to call the various ways that
2010     //         different NFT contracts have implemented transfer/transferFrom.
2011     // @param  _nftContract - The NFT contract that we are attempting to
2012     //         transfer an NFT from.
2013     // @param  _nftId - The ID of the NFT that we are attempting to transfer.
2014     // @param  _recipient - The destination of the NFT that we are attempting
2015     //         to transfer.
2016     // @return A bool value indicating whether the transfer attempt succeeded.
2017     function _attemptTransferFrom(address _nftContract, uint256 _nftId, address _recipient) internal returns (bool) {
2018         // @notice Some NFT contracts will not allow you to approve an NFT that
2019         //         you own, so we cannot simply call approve() here, we have to
2020         //         try to call it in a manner that allows the call to fail.
2021         _nftContract.call(abi.encodeWithSelector(IERC721(_nftContract).approve.selector, address(this), _nftId));
2022 
2023         // @notice Some NFT contracts will not allow you to call transferFrom()
2024         //         for an NFT that you own but that is not approved, so we
2025         //         cannot simply call transferFrom() here, we have to try to
2026         //         call it in a manner that allows the call to fail.
2027         (bool success, ) = _nftContract.call(abi.encodeWithSelector(IERC721(_nftContract).transferFrom.selector, address(this), _recipient, _nftId));
2028         return success;
2029     }
2030 
2031     // @notice This function attempts to call transfer() on the specified
2032     //         NFT contract, returning whether it succeeded.
2033     // @notice We only call this function from within _transferNftToAddress(),
2034     //         which is function attempts to call the various ways that
2035     //         different NFT contracts have implemented transfer/transferFrom.
2036     // @param  _nftContract - The NFT contract that we are attempting to
2037     //         transfer an NFT from.
2038     // @param  _nftId - The ID of the NFT that we are attempting to transfer.
2039     // @param  _recipient - The destination of the NFT that we are attempting
2040     //         to transfer.
2041     // @return A bool value indicating whether the transfer attempt succeeded.
2042     function _attemptTransfer(address _nftContract, uint256 _nftId, address _recipient) internal returns (bool) {
2043         // @notice Some NFT contracts do not implement transfer(), since it is
2044         //         not a part of the official ERC721 standard, but many
2045         //         prominent NFT projects do implement it (such as
2046         //         Cryptokitties), so we cannot simply call transfer() here, we
2047         //         have to try to call it in a manner that allows the call to
2048         //         fail.
2049         (bool success, ) = _nftContract.call(abi.encodeWithSelector(ICryptoKittiesCore(_nftContract).transfer.selector, _recipient, _nftId));
2050         return success;
2051     }
2052 
2053     /* ***************** */
2054     /* FALLBACK FUNCTION */
2055     /* ***************** */
2056 
2057     // @notice By calling 'revert' in the fallback function, we prevent anyone
2058     //         from accidentally sending funds directly to this contract.
2059     function() external payable {
2060         revert();
2061     }
2062 }
2063 
2064 // @notice The interface for interacting with the CryptoKitties contract. We
2065 //         include this special case because CryptoKitties is one of the most
2066 //         used NFT contracts on Ethereum and will likely be used by NFTfi, but
2067 //         it does not perfectly abide by the ERC721 standard, since it preceded
2068 //         the official standardization of ERC721.
2069 contract ICryptoKittiesCore {
2070     function transfer(address _to, uint256 _tokenId) external;
2071 }