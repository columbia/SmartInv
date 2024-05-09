1 // Sources flattened with hardhat v2.9.9 https://hardhat.org
2 
3 // File contracts/interfaces/IAxelarGateway.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.9;
8 
9 interface IAxelarGateway {
10     /**********\
11     |* Errors *|
12     \**********/
13 
14     error NotSelf();
15     error NotProxy();
16     error InvalidCodeHash();
17     error SetupFailed();
18     error InvalidAuthModule();
19     error InvalidTokenDeployer();
20     error InvalidAmount();
21     error InvalidChainId();
22     error InvalidCommands();
23     error TokenDoesNotExist(string symbol);
24     error TokenAlreadyExists(string symbol);
25     error TokenDeployFailed(string symbol);
26     error TokenContractDoesNotExist(address token);
27     error BurnFailed(string symbol);
28     error MintFailed(string symbol);
29     error InvalidSetMintLimitsParams();
30     error ExceedMintLimit(string symbol);
31 
32     /**********\
33     |* Events *|
34     \**********/
35 
36     event TokenSent(address indexed sender, string destinationChain, string destinationAddress, string symbol, uint256 amount);
37 
38     event ContractCall(
39         address indexed sender,
40         string destinationChain,
41         string destinationContractAddress,
42         bytes32 indexed payloadHash,
43         bytes payload
44     );
45 
46     event ContractCallWithToken(
47         address indexed sender,
48         string destinationChain,
49         string destinationContractAddress,
50         bytes32 indexed payloadHash,
51         bytes payload,
52         string symbol,
53         uint256 amount
54     );
55 
56     event Executed(bytes32 indexed commandId);
57 
58     event TokenDeployed(string symbol, address tokenAddresses);
59 
60     event ContractCallApproved(
61         bytes32 indexed commandId,
62         string sourceChain,
63         string sourceAddress,
64         address indexed contractAddress,
65         bytes32 indexed payloadHash,
66         bytes32 sourceTxHash,
67         uint256 sourceEventIndex
68     );
69 
70     event ContractCallApprovedWithMint(
71         bytes32 indexed commandId,
72         string sourceChain,
73         string sourceAddress,
74         address indexed contractAddress,
75         bytes32 indexed payloadHash,
76         string symbol,
77         uint256 amount,
78         bytes32 sourceTxHash,
79         uint256 sourceEventIndex
80     );
81 
82     event TokenMintLimitUpdated(string symbol, uint256 limit);
83 
84     event OperatorshipTransferred(bytes newOperatorsData);
85 
86     event Upgraded(address indexed implementation);
87 
88     /********************\
89     |* Public Functions *|
90     \********************/
91 
92     function sendToken(
93         string calldata destinationChain,
94         string calldata destinationAddress,
95         string calldata symbol,
96         uint256 amount
97     ) external;
98 
99     function callContract(
100         string calldata destinationChain,
101         string calldata contractAddress,
102         bytes calldata payload
103     ) external;
104 
105     function callContractWithToken(
106         string calldata destinationChain,
107         string calldata contractAddress,
108         bytes calldata payload,
109         string calldata symbol,
110         uint256 amount
111     ) external;
112 
113     function isContractCallApproved(
114         bytes32 commandId,
115         string calldata sourceChain,
116         string calldata sourceAddress,
117         address contractAddress,
118         bytes32 payloadHash
119     ) external view returns (bool);
120 
121     function isContractCallAndMintApproved(
122         bytes32 commandId,
123         string calldata sourceChain,
124         string calldata sourceAddress,
125         address contractAddress,
126         bytes32 payloadHash,
127         string calldata symbol,
128         uint256 amount
129     ) external view returns (bool);
130 
131     function validateContractCall(
132         bytes32 commandId,
133         string calldata sourceChain,
134         string calldata sourceAddress,
135         bytes32 payloadHash
136     ) external returns (bool);
137 
138     function validateContractCallAndMint(
139         bytes32 commandId,
140         string calldata sourceChain,
141         string calldata sourceAddress,
142         bytes32 payloadHash,
143         string calldata symbol,
144         uint256 amount
145     ) external returns (bool);
146 
147     /***********\
148     |* Getters *|
149     \***********/
150 
151     function authModule() external view returns (address);
152 
153     function tokenDeployer() external view returns (address);
154 
155     function tokenMintLimit(string memory symbol) external view returns (uint256);
156 
157     function tokenMintAmount(string memory symbol) external view returns (uint256);
158 
159     function allTokensFrozen() external view returns (bool);
160 
161     function implementation() external view returns (address);
162 
163     function tokenAddresses(string memory symbol) external view returns (address);
164 
165     function tokenFrozen(string memory symbol) external view returns (bool);
166 
167     function isCommandExecuted(bytes32 commandId) external view returns (bool);
168 
169     function adminEpoch() external view returns (uint256);
170 
171     function adminThreshold(uint256 epoch) external view returns (uint256);
172 
173     function admins(uint256 epoch) external view returns (address[] memory);
174 
175     /*******************\
176     |* Admin Functions *|
177     \*******************/
178 
179     function setTokenMintLimits(string[] calldata symbols, uint256[] calldata limits) external;
180 
181     function upgrade(
182         address newImplementation,
183         bytes32 newImplementationCodeHash,
184         bytes calldata setupParams
185     ) external;
186 
187     /**********************\
188     |* External Functions *|
189     \**********************/
190 
191     function setup(bytes calldata params) external;
192 
193     function execute(bytes calldata input) external;
194 }
195 
196 
197 // File contracts/interfaces/IERC20Burn.sol
198 
199 
200 interface IERC20Burn {
201     function burn(bytes32 salt) external;
202 }
203 
204 
205 // File contracts/interfaces/IERC20BurnFrom.sol
206 
207 
208 interface IERC20BurnFrom {
209     function burnFrom(address account, uint256 amount) external;
210 }
211 
212 
213 // File contracts/interfaces/IERC20.sol
214 
215 
216 /**
217  * @dev Interface of the ERC20 standard as defined in the EIP.
218  */
219 interface IERC20 {
220     error InvalidAccount();
221 
222     /**
223      * @dev Returns the amount of tokens in existence.
224      */
225     function totalSupply() external view returns (uint256);
226 
227     /**
228      * @dev Returns the amount of tokens owned by `account`.
229      */
230     function balanceOf(address account) external view returns (uint256);
231 
232     /**
233      * @dev Moves `amount` tokens from the caller's account to `recipient`.
234      *
235      * Returns a boolean value indicating whether the operation succeeded.
236      *
237      * Emits a {Transfer} event.
238      */
239     function transfer(address recipient, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Returns the remaining number of tokens that `spender` will be
243      * allowed to spend on behalf of `owner` through {transferFrom}. This is
244      * zero by default.
245      *
246      * This value changes when {approve} or {transferFrom} are called.
247      */
248     function allowance(address owner, address spender) external view returns (uint256);
249 
250     /**
251      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
252      *
253      * Returns a boolean value indicating whether the operation succeeded.
254      *
255      * IMPORTANT: Beware that changing an allowance with this method brings the risk
256      * that someone may use both the old and the new allowance by unfortunate
257      * transaction ordering. One possible solution to mitigate this race
258      * condition is to first reduce the spender's allowance to 0 and set the
259      * desired value afterwards:
260      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261      *
262      * Emits an {Approval} event.
263      */
264     function approve(address spender, uint256 amount) external returns (bool);
265 
266     /**
267      * @dev Moves `amount` tokens from `sender` to `recipient` using the
268      * allowance mechanism. `amount` is then deducted from the caller's
269      * allowance.
270      *
271      * Returns a boolean value indicating whether the operation succeeded.
272      *
273      * Emits a {Transfer} event.
274      */
275     function transferFrom(
276         address sender,
277         address recipient,
278         uint256 amount
279     ) external returns (bool);
280 
281     /**
282      * @dev Emitted when `value` tokens are moved from one account (`from`) to
283      * another (`to`).
284      *
285      * Note that `value` may be zero.
286      */
287     event Transfer(address indexed from, address indexed to, uint256 value);
288 
289     /**
290      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
291      * a call to {approve}. `value` is the new allowance.
292      */
293     event Approval(address indexed owner, address indexed spender, uint256 value);
294 }
295 
296 
297 // File contracts/interfaces/IERC20Permit.sol
298 
299 
300 interface IERC20Permit {
301     function DOMAIN_SEPARATOR() external view returns (bytes32);
302 
303     function nonces(address account) external view returns (uint256);
304 
305     function permit(
306         address issuer,
307         address spender,
308         uint256 value,
309         uint256 deadline,
310         uint8 v,
311         bytes32 r,
312         bytes32 s
313     ) external;
314 }
315 
316 
317 // File contracts/interfaces/IOwnable.sol
318 
319 
320 interface IOwnable {
321     error NotOwner();
322     error InvalidOwner();
323 
324     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
325 
326     function owner() external view returns (address);
327 
328     function transferOwnership(address newOwner) external;
329 }
330 
331 
332 // File contracts/interfaces/IMintableCappedERC20.sol
333 
334 
335 
336 
337 interface IMintableCappedERC20 is IERC20, IERC20Permit, IOwnable {
338     error CapExceeded();
339 
340     function cap() external view returns (uint256);
341 
342     function mint(address account, uint256 amount) external;
343 }
344 
345 
346 // File contracts/interfaces/IBurnableMintableCappedERC20.sol
347 
348 
349 interface IBurnableMintableCappedERC20 is IERC20Burn, IERC20BurnFrom, IMintableCappedERC20 {
350     function depositAddress(bytes32 salt) external view returns (address);
351 
352     function burn(bytes32 salt) external;
353 
354     function burnFrom(address account, uint256 amount) external;
355 }
356 
357 
358 // File contracts/ERC20.sol
359 
360 
361 /**
362  * @dev Implementation of the {IERC20} interface.
363  *
364  * This implementation is agnostic to the way tokens are created. This means
365  * that a supply mechanism has to be added in a derived contract using {_mint}.
366  * For a generic mechanism see {ERC20PresetMinterPauser}.
367  *
368  * TIP: For a detailed writeup see our guide
369  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
370  * to implement supply mechanisms].
371  *
372  * We have followed general OpenZeppelin guidelines: functions revert instead
373  * of returning `false` on failure. This behavior is nonetheless conventional
374  * and does not conflict with the expectations of ERC20 applications.
375  *
376  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
377  * This allows applications to reconstruct the allowance for all accounts just
378  * by listening to said events. Other implementations of the EIP may not emit
379  * these events, as it isn't required by the specification.
380  *
381  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
382  * functions have been added to mitigate the well-known issues around setting
383  * allowances. See {IERC20-approve}.
384  */
385 contract ERC20 is IERC20 {
386     mapping(address => uint256) public override balanceOf;
387 
388     mapping(address => mapping(address => uint256)) public override allowance;
389 
390     uint256 public override totalSupply;
391 
392     string public name;
393     string public symbol;
394 
395     uint8 public immutable decimals;
396 
397     /**
398      * @dev Sets the values for {name}, {symbol}, and {decimals}.
399      */
400     constructor(
401         string memory name_,
402         string memory symbol_,
403         uint8 decimals_
404     ) {
405         name = name_;
406         symbol = symbol_;
407         decimals = decimals_;
408     }
409 
410     /**
411      * @dev See {IERC20-transfer}.
412      *
413      * Requirements:
414      *
415      * - `recipient` cannot be the zero address.
416      * - the caller must have a balance of at least `amount`.
417      */
418     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
419         _transfer(msg.sender, recipient, amount);
420         return true;
421     }
422 
423     /**
424      * @dev See {IERC20-approve}.
425      *
426      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
427      * `transferFrom`. This is semantically equivalent to an infinite approval.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      */
433     function approve(address spender, uint256 amount) external virtual override returns (bool) {
434         _approve(msg.sender, spender, amount);
435         return true;
436     }
437 
438     /**
439      * @dev See {IERC20-transferFrom}.
440      *
441      * Emits an {Approval} event indicating the updated allowance. This is not
442      * required by the EIP. See the note at the beginning of {ERC20}.
443      *
444      * Requirements:
445      *
446      * - `sender` and `recipient` cannot be the zero address.
447      * - `sender` must have a balance of at least `amount`.
448      * - the caller must have allowance for ``sender``'s tokens of at least
449      * `amount`.
450      */
451     function transferFrom(
452         address sender,
453         address recipient,
454         uint256 amount
455     ) external virtual override returns (bool) {
456         uint256 _allowance = allowance[sender][msg.sender];
457 
458         if (_allowance != type(uint256).max) {
459             _approve(sender, msg.sender, _allowance - amount);
460         }
461 
462         _transfer(sender, recipient, amount);
463 
464         return true;
465     }
466 
467     /**
468      * @dev Atomically increases the allowance granted to `spender` by the caller.
469      *
470      * This is an alternative to {approve} that can be used as a mitigation for
471      * problems described in {IERC20-approve}.
472      *
473      * Emits an {Approval} event indicating the updated allowance.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      */
479     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
480         _approve(msg.sender, spender, allowance[msg.sender][spender] + addedValue);
481         return true;
482     }
483 
484     /**
485      * @dev Atomically decreases the allowance granted to `spender` by the caller.
486      *
487      * This is an alternative to {approve} that can be used as a mitigation for
488      * problems described in {IERC20-approve}.
489      *
490      * Emits an {Approval} event indicating the updated allowance.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      * - `spender` must have allowance for the caller of at least
496      * `subtractedValue`.
497      */
498     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
499         _approve(msg.sender, spender, allowance[msg.sender][spender] - subtractedValue);
500         return true;
501     }
502 
503     /**
504      * @dev Moves tokens `amount` from `sender` to `recipient`.
505      *
506      * This is internal function is equivalent to {transfer}, and can be used to
507      * e.g. implement automatic token fees, slashing mechanisms, etc.
508      *
509      * Emits a {Transfer} event.
510      *
511      * Requirements:
512      *
513      * - `sender` cannot be the zero address.
514      * - `recipient` cannot be the zero address.
515      * - `sender` must have a balance of at least `amount`.
516      */
517     function _transfer(
518         address sender,
519         address recipient,
520         uint256 amount
521     ) internal virtual {
522         if (sender == address(0) || recipient == address(0)) revert InvalidAccount();
523 
524         balanceOf[sender] -= amount;
525         balanceOf[recipient] += amount;
526         emit Transfer(sender, recipient, amount);
527     }
528 
529     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
530      * the total supply.
531      *
532      * Emits a {Transfer} event with `from` set to the zero address.
533      *
534      * Requirements:
535      *
536      * - `to` cannot be the zero address.
537      */
538     function _mint(address account, uint256 amount) internal virtual {
539         if (account == address(0)) revert InvalidAccount();
540 
541         totalSupply += amount;
542         balanceOf[account] += amount;
543         emit Transfer(address(0), account, amount);
544     }
545 
546     /**
547      * @dev Destroys `amount` tokens from `account`, reducing the
548      * total supply.
549      *
550      * Emits a {Transfer} event with `to` set to the zero address.
551      *
552      * Requirements:
553      *
554      * - `account` cannot be the zero address.
555      * - `account` must have at least `amount` tokens.
556      */
557     function _burn(address account, uint256 amount) internal virtual {
558         if (account == address(0)) revert InvalidAccount();
559 
560         balanceOf[account] -= amount;
561         totalSupply -= amount;
562         emit Transfer(account, address(0), amount);
563     }
564 
565     /**
566      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
567      *
568      * This internal function is equivalent to `approve`, and can be used to
569      * e.g. set automatic allowances for certain subsystems, etc.
570      *
571      * Emits an {Approval} event.
572      *
573      * Requirements:
574      *
575      * - `owner` cannot be the zero address.
576      * - `spender` cannot be the zero address.
577      */
578     function _approve(
579         address owner,
580         address spender,
581         uint256 amount
582     ) internal virtual {
583         if (owner == address(0) || spender == address(0)) revert InvalidAccount();
584 
585         allowance[owner][spender] = amount;
586         emit Approval(owner, spender, amount);
587     }
588 }
589 
590 
591 // File contracts/ERC20Permit.sol
592 
593 
594 abstract contract ERC20Permit is IERC20, IERC20Permit, ERC20 {
595     error PermitExpired();
596     error InvalidS();
597     error InvalidV();
598     error InvalidSignature();
599 
600     bytes32 public immutable DOMAIN_SEPARATOR;
601 
602     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = '\x19\x01';
603 
604     // keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
605     bytes32 private constant DOMAIN_TYPE_SIGNATURE_HASH = bytes32(0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f);
606 
607     // keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)')
608     bytes32 private constant PERMIT_SIGNATURE_HASH = bytes32(0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9);
609 
610     mapping(address => uint256) public nonces;
611 
612     constructor(string memory name) {
613         DOMAIN_SEPARATOR = keccak256(
614             abi.encode(DOMAIN_TYPE_SIGNATURE_HASH, keccak256(bytes(name)), keccak256(bytes('1')), block.chainid, address(this))
615         );
616     }
617 
618     function permit(
619         address issuer,
620         address spender,
621         uint256 value,
622         uint256 deadline,
623         uint8 v,
624         bytes32 r,
625         bytes32 s
626     ) external {
627         if (block.timestamp > deadline) revert PermitExpired();
628 
629         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) revert InvalidS();
630 
631         if (v != 27 && v != 28) revert InvalidV();
632 
633         bytes32 digest = keccak256(
634             abi.encodePacked(
635                 EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA,
636                 DOMAIN_SEPARATOR,
637                 keccak256(abi.encode(PERMIT_SIGNATURE_HASH, issuer, spender, value, nonces[issuer]++, deadline))
638             )
639         );
640 
641         address recoveredAddress = ecrecover(digest, v, r, s);
642 
643         if (recoveredAddress != issuer) revert InvalidSignature();
644 
645         // _approve will revert if issuer is address(0x0)
646         _approve(issuer, spender, value);
647     }
648 }
649 
650 
651 // File contracts/Ownable.sol
652 
653 
654 abstract contract Ownable is IOwnable {
655     address public owner;
656 
657     constructor() {
658         owner = msg.sender;
659         emit OwnershipTransferred(address(0), msg.sender);
660     }
661 
662     modifier onlyOwner() {
663         if (owner != msg.sender) revert NotOwner();
664 
665         _;
666     }
667 
668     function transferOwnership(address newOwner) external virtual onlyOwner {
669         if (newOwner == address(0)) revert InvalidOwner();
670 
671         emit OwnershipTransferred(owner, newOwner);
672         owner = newOwner;
673     }
674 }
675 
676 
677 // File contracts/MintableCappedERC20.sol
678 
679 
680 contract MintableCappedERC20 is IMintableCappedERC20, ERC20, ERC20Permit, Ownable {
681     uint256 public immutable cap;
682 
683     constructor(
684         string memory name,
685         string memory symbol,
686         uint8 decimals,
687         uint256 capacity
688     ) ERC20(name, symbol, decimals) ERC20Permit(name) Ownable() {
689         cap = capacity;
690     }
691 
692     function mint(address account, uint256 amount) external onlyOwner {
693         uint256 capacity = cap;
694 
695         _mint(account, amount);
696 
697         if (capacity == 0) return;
698 
699         if (totalSupply > capacity) revert CapExceeded();
700     }
701 }
702 
703 
704 // File contracts/DepositHandler.sol
705 
706 
707 contract DepositHandler {
708     error IsLocked();
709     error NotContract();
710 
711     uint256 internal constant IS_NOT_LOCKED = uint256(1);
712     uint256 internal constant IS_LOCKED = uint256(2);
713 
714     uint256 internal _lockedStatus = IS_NOT_LOCKED;
715 
716     modifier noReenter() {
717         if (_lockedStatus == IS_LOCKED) revert IsLocked();
718 
719         _lockedStatus = IS_LOCKED;
720         _;
721         _lockedStatus = IS_NOT_LOCKED;
722     }
723 
724     function execute(address callee, bytes calldata data) external noReenter returns (bool success, bytes memory returnData) {
725         if (callee.code.length == 0) revert NotContract();
726         (success, returnData) = callee.call(data);
727     }
728 
729     // NOTE: The gateway should always destroy the `DepositHandler` in the same runtime context that deploys it.
730     function destroy(address etherDestination) external noReenter {
731         selfdestruct(payable(etherDestination));
732     }
733 }
734 
735 
736 // File contracts/BurnableMintableCappedERC20.sol
737 
738 
739 contract BurnableMintableCappedERC20 is IBurnableMintableCappedERC20, MintableCappedERC20 {
740     constructor(
741         string memory name,
742         string memory symbol,
743         uint8 decimals,
744         uint256 capacity
745     ) MintableCappedERC20(name, symbol, decimals, capacity) {}
746 
747     function depositAddress(bytes32 salt) public view returns (address) {
748         /* Convert a hash which is bytes32 to an address which is 20-byte long
749         according to https://docs.soliditylang.org/en/v0.8.1/control-structures.html?highlight=create2#salted-contract-creations-create2 */
750         return
751             address(
752                 uint160(
753                     uint256(
754                         keccak256(
755                             abi.encodePacked(bytes1(0xff), owner, salt, keccak256(abi.encodePacked(type(DepositHandler).creationCode)))
756                         )
757                     )
758                 )
759             );
760     }
761 
762     function burn(bytes32 salt) external onlyOwner {
763         address account = depositAddress(salt);
764         _burn(account, balanceOf[account]);
765     }
766 
767     function burnFrom(address account, uint256 amount) external onlyOwner {
768         uint256 _allowance = allowance[account][msg.sender];
769         if (_allowance != type(uint256).max) {
770             _approve(account, msg.sender, _allowance - amount);
771         }
772         _burn(account, amount);
773     }
774 }