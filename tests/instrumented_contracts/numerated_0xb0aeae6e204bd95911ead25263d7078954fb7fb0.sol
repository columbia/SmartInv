1 // File contracts/interfaces/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.7.4;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address account) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function approve(address spender, uint256 amount) external returns (bool);
15 
16     function transfer(address recipient, uint256 amount) external returns (bool);
17 
18     function transferFrom(
19         address sender,
20         address recipient,
21         uint256 amount
22     ) external returns (bool);
23 
24     function burn(uint256 value) external returns (bool);
25 
26     function permit(
27         address owner,
28         address spender,
29         uint256 value,
30         uint256 deadline,
31         uint8 v,
32         bytes32 r,
33         bytes32 s
34     ) external;
35 }
36 
37 
38 // File contracts/interfaces/IFlashReceiver.sol
39 
40 
41 pragma solidity 0.7.4;
42 
43 interface IFlashReceiver {
44     function receiveFlash(
45         bytes32 _id,
46         uint256 _amountIn,
47         uint256 _expireAfter,
48         uint256 _mintedAmount,
49         address _staker,
50         bytes calldata _data
51     ) external returns (uint256);
52 }
53 
54 
55 // File contracts/interfaces/IFlashProtocol.sol
56 
57 
58 pragma solidity 0.7.4;
59 
60 interface IFlashProtocol {
61     function stake(
62         uint256 _amountIn,
63         uint256 _days,
64         address _receiver,
65         bytes calldata _data
66     )
67         external
68         returns (
69             uint256 mintedAmount,
70             uint256 matchedAmount,
71             bytes32 id
72         );
73 
74     function unstake(bytes32 _id) external returns (uint256 withdrawAmount);
75 
76     function getFPY(uint256 _amountIn) external view returns (uint256);
77 }
78 
79 
80 // File contracts/libraries/SafeMath.sol
81 
82 
83 pragma solidity 0.7.4;
84 
85 // A library for performing overflow-safe math, courtesy of DappHub: https://github.com/dapphub/ds-math/blob/d0ef6d6a5f/src/math.sol
86 // Modified to include only the essentials
87 library SafeMath {
88     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
89         require((z = x + y) >= x, "MATH:: ADD_OVERFLOW");
90     }
91 
92     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
93         require((z = x - y) <= x, "MATH:: SUB_UNDERFLOW");
94     }
95 
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
98         // benefit is lost if 'b' is also tested.
99         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
100         if (a == 0) {
101             return 0;
102         }
103 
104         uint256 c = a * b;
105         require(c / a == b, "MATH:: MUL_OVERFLOW");
106 
107         return c;
108     }
109 
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b > 0, "MATH:: DIVISION_BY_ZERO");
112         uint256 c = a / b;
113         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114 
115         return c;
116     }
117 
118     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
119         z = x < y ? x : y;
120     }
121 
122     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
123     function sqrt(uint256 y) internal pure returns (uint256 z) {
124         if (y > 3) {
125             z = y;
126             uint256 x = y / 2 + 1;
127             while (x < z) {
128                 z = x;
129                 x = (y / x + x) / 2;
130             }
131         } else if (y != 0) {
132             z = 1;
133         }
134     }
135 }
136 
137 
138 // File contracts/libraries/Address.sol
139 
140 
141 pragma solidity 0.7.4;
142 
143 /**
144  * @dev Collection of functions related to the address type
145  */
146 library Address {
147     /**
148      * @dev Returns true if `account` is a contract.
149      *
150      * [IMPORTANT]
151      * ====
152      * It is unsafe to assume that an address for which this function returns
153      * false is an externally-owned account (EOA) and not a contract.
154      *
155      * Among others, `isContract` will return false for the following
156      * types of addresses:
157      *
158      *  - an externally-owned account
159      *  - a contract in construction
160      *  - an address where a contract will be created
161      *  - an address where a contract lived, but was destroyed
162      * ====
163      */
164     function isContract(address account) internal view returns (bool) {
165         // This method relies on extcodesize, which returns 0 for contracts in
166         // construction, since the code is only stored at the end of the
167         // constructor execution.
168 
169         uint256 size;
170         // solhint-disable-next-line no-inline-assembly
171         assembly {
172             size := extcodesize(account)
173         }
174         return size > 0;
175     }
176 
177     /**
178      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
179      * `recipient`, forwarding all available gas and reverting on errors.
180      *
181      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
182      * of certain opcodes, possibly making contracts go over the 2300 gas limit
183      * imposed by `transfer`, making them unable to receive funds via
184      * `transfer`. {sendValue} removes this limitation.
185      *
186      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
187      *
188      * IMPORTANT: because control is transferred to `recipient`, care must be
189      * taken to not create reentrancy vulnerabilities. Consider using
190      * {ReentrancyGuard} or the
191      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
192      */
193     function sendValue(address payable recipient, uint256 amount) internal {
194         require(address(this).balance >= amount, "Address: insufficient balance");
195 
196         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
197         (bool success, ) = recipient.call{ value: amount }("");
198         require(success, "Address: unable to send value, recipient may have reverted");
199     }
200 
201     /**
202      * @dev Performs a Solidity function call using a low level `call`. A
203      * plain`call` is an unsafe replacement for a function call: use this
204      * function instead.
205      *
206      * If `target` reverts with a revert reason, it is bubbled up by this
207      * function (like regular Solidity function calls).
208      *
209      * Returns the raw returned data. To convert to the expected return value,
210      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
211      *
212      * Requirements:
213      *
214      * - `target` must be a contract.
215      * - calling `target` with `data` must not revert.
216      *
217      * _Available since v3.1._
218      */
219     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
220         return functionCall(target, data, "Address: low-level call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
225      * `errorMessage` as a fallback revert reason when `target` reverts.
226      *
227      * _Available since v3.1._
228      */
229     function functionCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal returns (bytes memory) {
234         return functionCallWithValue(target, data, 0, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but also transferring `value` wei to `target`.
240      *
241      * Requirements:
242      *
243      * - the calling contract must have an ETH balance of at least `value`.
244      * - the called Solidity function must be `payable`.
245      *
246      * _Available since v3.1._
247      */
248     function functionCallWithValue(
249         address target,
250         bytes memory data,
251         uint256 value
252     ) internal returns (bytes memory) {
253         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
258      * with `errorMessage` as a fallback revert reason when `target` reverts.
259      *
260      * _Available since v3.1._
261      */
262     function functionCallWithValue(
263         address target,
264         bytes memory data,
265         uint256 value,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(address(this).balance >= value, "Address: insufficient balance for call");
269         require(isContract(target), "Address: call to non-contract");
270 
271         // solhint-disable-next-line avoid-low-level-calls
272         (bool success, bytes memory returndata) = target.call{ value: value }(data);
273         return _verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but performing a static call.
279      *
280      * _Available since v3.3._
281      */
282     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
283         return functionStaticCall(target, data, "Address: low-level static call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a static call.
289      *
290      * _Available since v3.3._
291      */
292     function functionStaticCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal view returns (bytes memory) {
297         require(isContract(target), "Address: static call to non-contract");
298 
299         // solhint-disable-next-line avoid-low-level-calls
300         (bool success, bytes memory returndata) = target.staticcall(data);
301         return _verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but performing a delegate call.
307      *
308      * _Available since v3.4._
309      */
310     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
316      * but performing a delegate call.
317      *
318      * _Available since v3.4._
319      */
320     function functionDelegateCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         require(isContract(target), "Address: delegate call to non-contract");
326 
327         // solhint-disable-next-line avoid-low-level-calls
328         (bool success, bytes memory returndata) = target.delegatecall(data);
329         return _verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     function _verifyCallResult(
333         bool success,
334         bytes memory returndata,
335         string memory errorMessage
336     ) private pure returns (bytes memory) {
337         if (success) {
338             return returndata;
339         } else {
340             // Look for revert reason and bubble it up if present
341             if (returndata.length > 0) {
342                 // The easiest way to bubble the revert reason is using memory via assembly
343 
344                 // solhint-disable-next-line no-inline-assembly
345                 assembly {
346                     let returndata_size := mload(returndata)
347                     revert(add(32, returndata), returndata_size)
348                 }
349             } else {
350                 revert(errorMessage);
351             }
352         }
353     }
354 }
355 
356 
357 // File contracts/libraries/Create2.sol
358 
359 
360 pragma solidity 0.7.4;
361 
362 /**
363  * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
364  * `CREATE2` can be used to compute in advance the address where a smart
365  * contract will be deployed, which allows for interesting new mechanisms known
366  * as 'counterfactual interactions'.
367  *
368  * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
369  * information.
370  */
371 library Create2 {
372     /**
373      * @dev Deploys a contract using `CREATE2`. The address where the contract
374      * will be deployed can be known in advance via {computeAddress}.
375      *
376      * The bytecode for a contract can be obtained from Solidity with
377      * `type(contractName).creationCode`.
378      *
379      * Requirements:
380      *
381      * - `bytecode` must not be empty.
382      * - `salt` must have not been used for `bytecode` already.
383      * - the factory must have a balance of at least `amount`.
384      * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.
385      */
386     function deploy(
387         uint256 amount,
388         bytes32 salt,
389         bytes memory bytecode
390     ) internal returns (address) {
391         address addr;
392         require(address(this).balance >= amount, "Create2: insufficient balance");
393         require(bytecode.length != 0, "Create2: bytecode length is zero");
394         // solhint-disable-next-line no-inline-assembly
395         assembly {
396             addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)
397         }
398         require(addr != address(0), "Create2: Failed on deploy");
399         return addr;
400     }
401 
402     /**
403      * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the
404      * `bytecodeHash` or `salt` will result in a new destination address.
405      */
406     function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {
407         return computeAddress(salt, bytecodeHash, address(this));
408     }
409 
410     /**
411      * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
412      * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
413      */
414     function computeAddress(
415         bytes32 salt,
416         bytes32 bytecodeHash,
417         address deployer
418     ) internal pure returns (address) {
419         bytes32 _data = keccak256(abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash));
420         return address(uint256(_data));
421     }
422 }
423 
424 
425 // File contracts/libraries/SafeERC20.sol
426 
427 
428 pragma solidity 0.7.4;
429 
430 
431 
432 /**
433  * @title SafeERC20
434  * @dev Wrappers around ERC20 operations that throw on failure (when the token
435  * contract returns false). Tokens that return no value (and instead revert or
436  * throw on failure) are also supported, non-reverting calls are assumed to be
437  * successful.
438  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
439  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
440  */
441 library SafeERC20 {
442     using SafeMath for uint256;
443     using Address for address;
444 
445     function safeTransfer(
446         IERC20 token,
447         address to,
448         uint256 value
449     ) internal {
450         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
451     }
452 
453     function safeTransferFrom(
454         IERC20 token,
455         address from,
456         address to,
457         uint256 value
458     ) internal {
459         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
460     }
461 
462     /**
463      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
464      * on the return value: the return value is optional (but if data is returned, it must not be false).
465      * @param token The token targeted by the call.
466      * @param data The call data (encoded using abi.encode or one of its variants).
467      */
468     function _callOptionalReturn(IERC20 token, bytes memory data) private {
469         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
470         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
471         // the target address contains contract code and also asserts for success in the low-level call.
472 
473         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
474         if (returndata.length > 0) {
475             // Return data is optional
476             // solhint-disable-next-line max-line-length
477             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
478         }
479     }
480 }
481 
482 
483 // File contracts/pool/interfaces/IPool.sol
484 
485 
486 pragma solidity 0.7.4;
487 
488 interface IPool {
489     function initialize(address _token) external;
490 
491     function stakeWithFeeRewardDistribution(
492         uint256 _amountIn,
493         address _staker,
494         uint256 _expectedOutput
495     ) external returns (uint256 result);
496 
497     function addLiquidity(
498         uint256 _amountFLASH,
499         uint256 _amountALT,
500         uint256 _amountFLASHMin,
501         uint256 _amountALTMin,
502         address _maker
503     )
504         external
505         returns (
506             uint256,
507             uint256,
508             uint256
509         );
510 
511     function removeLiquidity(address _maker) external returns (uint256, uint256);
512 
513     function swapWithFeeRewardDistribution(
514         uint256 _amountIn,
515         address _staker,
516         uint256 _expectedOutput
517     ) external returns (uint256 result);
518 }
519 
520 
521 // File contracts/pool/contracts/PoolERC20.sol
522 
523 
524 pragma solidity 0.7.4;
525 
526 
527 // Lightweight token modelled after UNI-LP:
528 // https://github.com/Uniswap/uniswap-v2-core/blob/v1.0.1/contracts/UniswapV2ERC20.sol
529 // Adds:
530 //   - An exposed `mint()` with minting role
531 //   - An exposed `burn()`
532 //   - ERC-3009 (`transferWithAuthorization()`)
533 //   - flashMint() - allows to flashMint an arbitrary amount of FLASH, with the
534 //     condition that it is burned before the end of the transaction.
535 contract PoolERC20 is IERC20 {
536     using SafeMath for uint256;
537 
538     // bytes32 private constant EIP712DOMAIN_HASH =
539     // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
540     bytes32 private constant EIP712DOMAIN_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
541 
542     // bytes32 private constant NAME_HASH = keccak256("FLASH-ALT-LP Token")
543     bytes32 private constant NAME_HASH = 0xfdde3a7807889787f51ab17062704a0d81341ba7debe5a9773b58a1b5e5f422c;
544 
545     // bytes32 private constant VERSION_HASH = keccak256("2")
546     bytes32 private constant VERSION_HASH = 0xad7c5bef027816a800da1736444fb58a807ef4c9603b7848673f7e3a68eb14a5;
547 
548     // bytes32 public constant PERMIT_TYPEHASH =
549     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
550     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
551 
552     // bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =
553     // keccak256("TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)");
554     bytes32
555         public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH = 0x7c7c6cdb67a18743f49ec6fa9b35f50d52ed05cbed4cc592e13b44501c1a2267;
556 
557     string public constant name = "FLASH-ALT-LP Token";
558     string public constant symbol = "FLASH-ALT-LP";
559     uint8 public constant decimals = 18;
560 
561     uint256 public override totalSupply;
562 
563     address public minter;
564 
565     mapping(address => uint256) public override balanceOf;
566     mapping(address => mapping(address => uint256)) public override allowance;
567 
568     // ERC-2612, ERC-3009 state
569     mapping(address => uint256) public nonces;
570     mapping(address => mapping(bytes32 => bool)) public authorizationState;
571 
572     event Approval(address indexed owner, address indexed spender, uint256 value);
573     event Transfer(address indexed from, address indexed to, uint256 value);
574     event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);
575 
576     function _validateSignedData(
577         address signer,
578         bytes32 encodeData,
579         uint8 v,
580         bytes32 r,
581         bytes32 s
582     ) internal view {
583         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", getDomainSeparator(), encodeData));
584         address recoveredAddress = ecrecover(digest, v, r, s);
585         // Explicitly disallow authorizations for address(0) as ecrecover returns address(0) on malformed messages
586         require(recoveredAddress != address(0) && recoveredAddress == signer, "FLASH-ALT-LP Token:: INVALID_SIGNATURE");
587     }
588 
589     function _mint(address to, uint256 value) internal {
590         totalSupply = totalSupply.add(value);
591         balanceOf[to] = balanceOf[to].add(value);
592         emit Transfer(address(0), to, value);
593     }
594 
595     function _burn(address from, uint256 value) internal {
596         // Balance is implicitly checked with SafeMath's underflow protection
597         balanceOf[from] = balanceOf[from].sub(value);
598         totalSupply = totalSupply.sub(value);
599         emit Transfer(from, address(0), value);
600     }
601 
602     function _approve(
603         address owner,
604         address spender,
605         uint256 value
606     ) private {
607         allowance[owner][spender] = value;
608         emit Approval(owner, spender, value);
609     }
610 
611     function _transfer(
612         address from,
613         address to,
614         uint256 value
615     ) private {
616         require(to != address(0), "FLASH-ALT-LP Token:: RECEIVER_IS_TOKEN_OR_ZERO");
617         // Balance is implicitly checked with SafeMath's underflow protection
618         balanceOf[from] = balanceOf[from].sub(value);
619         balanceOf[to] = balanceOf[to].add(value);
620         emit Transfer(from, to, value);
621     }
622 
623     function getChainId() public pure returns (uint256 chainId) {
624         // solhint-disable-next-line no-inline-assembly
625         assembly {
626             chainId := chainid()
627         }
628     }
629 
630     function getDomainSeparator() public view returns (bytes32) {
631         return keccak256(abi.encode(EIP712DOMAIN_HASH, NAME_HASH, VERSION_HASH, getChainId(), address(this)));
632     }
633 
634     function burn(uint256 value) external override returns (bool) {
635         _burn(msg.sender, value);
636         return true;
637     }
638 
639     function approve(address spender, uint256 value) external override returns (bool) {
640         _approve(msg.sender, spender, value);
641         return true;
642     }
643 
644     function transfer(address to, uint256 value) external override returns (bool) {
645         _transfer(msg.sender, to, value);
646         return true;
647     }
648 
649     function transferFrom(
650         address from,
651         address to,
652         uint256 value
653     ) external override returns (bool) {
654         uint256 fromAllowance = allowance[from][msg.sender];
655         if (fromAllowance != uint256(-1)) {
656             // Allowance is implicitly checked with SafeMath's underflow protection
657             allowance[from][msg.sender] = fromAllowance.sub(value);
658         }
659         _transfer(from, to, value);
660         return true;
661     }
662 
663     function permit(
664         address owner,
665         address spender,
666         uint256 value,
667         uint256 deadline,
668         uint8 v,
669         bytes32 r,
670         bytes32 s
671     ) external override {
672         require(deadline >= block.timestamp, "FLASH-ALT-LP Token:: AUTH_EXPIRED");
673 
674         bytes32 encodeData = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner], deadline));
675         nonces[owner] = nonces[owner].add(1);
676         _validateSignedData(owner, encodeData, v, r, s);
677 
678         _approve(owner, spender, value);
679     }
680 
681     function transferWithAuthorization(
682         address from,
683         address to,
684         uint256 value,
685         uint256 validAfter,
686         uint256 validBefore,
687         bytes32 nonce,
688         uint8 v,
689         bytes32 r,
690         bytes32 s
691     ) external {
692         require(block.timestamp > validAfter, "FLASH-ALT-LP Token:: AUTH_NOT_YET_VALID");
693         require(block.timestamp < validBefore, "FLASH-ALT-LP Token:: AUTH_EXPIRED");
694         require(!authorizationState[from][nonce], "FLASH-ALT-LP Token:: AUTH_ALREADY_USED");
695 
696         bytes32 encodeData = keccak256(
697             abi.encode(TRANSFER_WITH_AUTHORIZATION_TYPEHASH, from, to, value, validAfter, validBefore, nonce)
698         );
699         _validateSignedData(from, encodeData, v, r, s);
700 
701         authorizationState[from][nonce] = true;
702         emit AuthorizationUsed(from, nonce);
703 
704         _transfer(from, to, value);
705     }
706 }
707 
708 
709 // File contracts/pool/contracts/Pool.sol
710 
711 
712 pragma solidity 0.7.4;
713 
714 
715 
716 
717 contract Pool is PoolERC20, IPool {
718     using SafeMath for uint256;
719     using SafeERC20 for IERC20;
720 
721     uint256 public constant MINIMUM_LIQUIDITY = 10**3;
722 
723     address public constant FLASH_TOKEN = 0x20398aD62bb2D930646d45a6D4292baa0b860C1f;
724     address public constant FLASH_PROTOCOL = 0x15EB0c763581329C921C8398556EcFf85Cc48275;
725 
726     uint256 public reserveFlashAmount;
727     uint256 public reserveAltAmount;
728     uint256 private unlocked = 1;
729 
730     address public token;
731     address public factory;
732 
733     modifier lock() {
734         require(unlocked == 1, "Pool: LOCKED");
735         unlocked = 0;
736         _;
737         unlocked = 1;
738     }
739 
740     modifier onlyFactory() {
741         require(msg.sender == factory, "Pool:: ONLY_FACTORY");
742         _;
743     }
744 
745     constructor() {
746         factory = msg.sender;
747     }
748 
749     function initialize(address _token) public override onlyFactory {
750         token = _token;
751     }
752 
753     function swapWithFeeRewardDistribution(
754         uint256 _amountIn,
755         address _staker,
756         uint256 _expectedOutput
757     ) public override lock onlyFactory returns (uint256 result) {
758         result = getAPYSwap(_amountIn);
759         require(_expectedOutput <= result, "Pool:: EXPECTED_IS_GREATER");
760         calcNewReserveSwap(_amountIn, result);
761         IERC20(FLASH_TOKEN).safeTransfer(_staker, result);
762     }
763 
764     function stakeWithFeeRewardDistribution(
765         uint256 _amountIn,
766         address _staker,
767         uint256 _expectedOutput
768     ) public override lock onlyFactory returns (uint256 result) {
769         result = getAPYStake(_amountIn);
770         require(_expectedOutput <= result, "Pool:: EXPECTED_IS_GREATER");
771         calcNewReserveStake(_amountIn, result);
772         IERC20(token).safeTransfer(_staker, result);
773     }
774 
775     function addLiquidity(
776         uint256 _amountFLASH,
777         uint256 _amountALT,
778         uint256 _amountFLASHMin,
779         uint256 _amountALTMin,
780         address _maker
781     )
782         public
783         override
784         onlyFactory
785         returns (
786             uint256 amountFLASH,
787             uint256 amountALT,
788             uint256 liquidity
789         )
790     {
791         (amountFLASH, amountALT) = _addLiquidity(_amountFLASH, _amountALT, _amountFLASHMin, _amountALTMin);
792         liquidity = mintLiquidityTokens(_maker, amountFLASH, amountALT);
793         calcNewReserveAddLiquidity(amountFLASH, amountALT);
794     }
795 
796     function removeLiquidity(address _maker)
797         public
798         override
799         onlyFactory
800         returns (uint256 amountFLASH, uint256 amountALT)
801     {
802         (amountFLASH, amountALT) = burn(_maker);
803     }
804 
805     function getAPYStake(uint256 _amountIn) public view returns (uint256 result) {
806         uint256 amountInWithFee = _amountIn.mul(getLPFee());
807         uint256 num = amountInWithFee.mul(reserveAltAmount);
808         uint256 den = (reserveFlashAmount.mul(1000)).add(amountInWithFee);
809         result = num.div(den);
810     }
811 
812     function getAPYSwap(uint256 _amountIn) public view returns (uint256 result) {
813         uint256 amountInWithFee = _amountIn.mul(getLPFee());
814         uint256 num = amountInWithFee.mul(reserveFlashAmount);
815         uint256 den = (reserveAltAmount.mul(1000)).add(amountInWithFee);
816         result = num.div(den);
817     }
818 
819     function getLPFee() public view returns (uint256) {
820         uint256 fpy = IFlashProtocol(FLASH_PROTOCOL).getFPY(0);
821         return uint256(1000).sub(fpy.div(5e15));
822     }
823 
824     function quote(
825         uint256 _amountA,
826         uint256 _reserveA,
827         uint256 _reserveB
828     ) public pure returns (uint256 amountB) {
829         require(_amountA > 0, "Pool:: INSUFFICIENT_AMOUNT");
830         require(_reserveA > 0 && _reserveB > 0, "Pool:: INSUFFICIENT_LIQUIDITY");
831         amountB = _amountA.mul(_reserveB).div(_reserveA);
832     }
833 
834     function burn(address to) private lock returns (uint256 amountFLASH, uint256 amountALT) {
835         uint256 balanceFLASH = IERC20(FLASH_TOKEN).balanceOf(address(this));
836         uint256 balanceALT = IERC20(token).balanceOf(address(this));
837         uint256 liquidity = balanceOf[address(this)];
838 
839         amountFLASH = liquidity.mul(balanceFLASH) / totalSupply;
840         amountALT = liquidity.mul(balanceALT) / totalSupply;
841 
842         require(amountFLASH > 0 && amountALT > 0, "Pool:: INSUFFICIENT_LIQUIDITY_BURNED");
843 
844         _burn(address(this), liquidity);
845 
846         IERC20(FLASH_TOKEN).safeTransfer(to, amountFLASH);
847         IERC20(token).safeTransfer(to, amountALT);
848 
849         balanceFLASH = balanceFLASH.sub(IERC20(FLASH_TOKEN).balanceOf(address(this)));
850         balanceALT = balanceALT.sub(IERC20(token).balanceOf(address(this)));
851 
852         calcNewReserveRemoveLiquidity(balanceFLASH, balanceALT);
853     }
854 
855     function _addLiquidity(
856         uint256 _amountFLASH,
857         uint256 _amountALT,
858         uint256 _amountFLASHMin,
859         uint256 _amountALTMin
860     ) private view returns (uint256 amountFLASH, uint256 amountALT) {
861         if (reserveAltAmount == 0 && reserveFlashAmount == 0) {
862             (amountFLASH, amountALT) = (_amountFLASH, _amountALT);
863         } else {
864             uint256 amountALTQuote = quote(_amountFLASH, reserveFlashAmount, reserveAltAmount);
865             if (amountALTQuote <= _amountALT) {
866                 require(amountALTQuote >= _amountALTMin, "Pool:: INSUFFICIENT_B_AMOUNT");
867                 (amountFLASH, amountALT) = (_amountFLASH, amountALTQuote);
868             } else {
869                 uint256 amountFLASHQuote = quote(_amountALT, reserveAltAmount, reserveFlashAmount);
870                 require(
871                     (amountFLASHQuote <= _amountFLASH) && (amountFLASHQuote >= _amountFLASHMin),
872                     "Pool:: INSUFFICIENT_A_AMOUNT"
873                 );
874                 (amountFLASH, amountALT) = (amountFLASHQuote, _amountALT);
875             }
876         }
877     }
878 
879     function mintLiquidityTokens(
880         address _to,
881         uint256 _flashAmount,
882         uint256 _altAmount
883     ) private returns (uint256 liquidity) {
884         if (totalSupply == 0) {
885             liquidity = SafeMath.sqrt(_flashAmount.mul(_altAmount)).sub(MINIMUM_LIQUIDITY);
886             _mint(address(0), MINIMUM_LIQUIDITY);
887         } else {
888             liquidity = SafeMath.min(
889                 _flashAmount.mul(totalSupply) / reserveFlashAmount,
890                 _altAmount.mul(totalSupply) / reserveAltAmount
891             );
892         }
893         require(liquidity > 0, "Pool:: INSUFFICIENT_LIQUIDITY_MINTED");
894         _mint(_to, liquidity);
895     }
896 
897     function calcNewReserveStake(uint256 _amountIn, uint256 _amountOut) private {
898         reserveFlashAmount = reserveFlashAmount.add(_amountIn);
899         reserveAltAmount = reserveAltAmount.sub(_amountOut);
900     }
901 
902     function calcNewReserveSwap(uint256 _amountIn, uint256 _amountOut) private {
903         reserveFlashAmount = reserveFlashAmount.sub(_amountOut);
904         reserveAltAmount = reserveAltAmount.add(_amountIn);
905     }
906 
907     function calcNewReserveAddLiquidity(uint256 _amountFLASH, uint256 _amountALT) private {
908         reserveFlashAmount = reserveFlashAmount.add(_amountFLASH);
909         reserveAltAmount = reserveAltAmount.add(_amountALT);
910     }
911 
912     function calcNewReserveRemoveLiquidity(uint256 _amountFLASH, uint256 _amountALT) private {
913         reserveFlashAmount = reserveFlashAmount.sub(_amountFLASH);
914         reserveAltAmount = reserveAltAmount.sub(_amountALT);
915     }
916 }
917 
918 
919 // File contracts/FlashApp.sol
920 
921 
922 pragma solidity 0.7.4;
923 
924 
925 
926 
927 
928 
929 
930 contract FlashApp is IFlashReceiver {
931     using SafeMath for uint256;
932     using SafeERC20 for IERC20;
933 
934     address public constant FLASH_TOKEN = 0x20398aD62bb2D930646d45a6D4292baa0b860C1f;
935     address public constant FLASH_PROTOCOL = 0x15EB0c763581329C921C8398556EcFf85Cc48275;
936 
937     mapping(bytes32 => uint256) public stakerReward;
938     mapping(address => address) public pools; // token -> pools
939 
940     event PoolCreated(address _pool, address _token);
941 
942     event Staked(bytes32 _id, uint256 _rewardAmount, address _pool);
943 
944     event LiquidityAdded(address _pool, uint256 _amountFLASH, uint256 _amountALT, uint256 _liquidity, address _sender);
945 
946     event LiquidityRemoved(
947         address _pool,
948         uint256 _amountFLASH,
949         uint256 _amountALT,
950         uint256 _liquidity,
951         address _sender
952     );
953 
954     event Swapped(address _sender, uint256 _swapAmount, uint256 _flashReceived, address _pool);
955 
956     modifier onlyProtocol() {
957         require(msg.sender == FLASH_PROTOCOL, "FlashApp:: ONLY_PROTOCOL");
958         _;
959     }
960 
961     function createPool(address _token) external returns (address poolAddress) {
962         require(_token != address(0), "FlashApp:: INVALID_TOKEN_ADDRESS");
963         require(pools[_token] == address(0), "FlashApp:: POOL_ALREADY_EXISTS");
964         bytes memory bytecode = type(Pool).creationCode;
965         bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
966         poolAddress = Create2.deploy(0, salt, bytecode);
967         pools[_token] = poolAddress;
968         IPool(poolAddress).initialize(_token);
969         emit PoolCreated(poolAddress, _token);
970     }
971 
972     function receiveFlash(
973         bytes32 _id,
974         uint256 _amountIn, //unused
975         uint256 _expireAfter, //unused
976         uint256 _mintedAmount,
977         address _staker,
978         bytes calldata _data
979     ) external override onlyProtocol returns (uint256) {
980         (address token, uint256 expectedOutput) = abi.decode(_data, (address, uint256));
981         address pool = pools[token];
982         IERC20(FLASH_TOKEN).safeTransfer(pool, _mintedAmount);
983         uint256 reward = IPool(pool).stakeWithFeeRewardDistribution(_mintedAmount, _staker, expectedOutput);
984         stakerReward[_id] = reward;
985         emit Staked(_id, reward, pool);
986     }
987 
988     function unstake(bytes32[] memory _expiredIds) public {
989         for (uint256 i = 0; i < _expiredIds.length; i = i.add(1)) {
990             IFlashProtocol(FLASH_PROTOCOL).unstake(_expiredIds[i]);
991         }
992     }
993 
994     function swap(
995         uint256 _altQuantity,
996         address _token,
997         uint256 _expectedOutput
998     ) public returns (uint256 result) {
999         address user = msg.sender;
1000         address pool = pools[_token];
1001 
1002         require(pool != address(0), "FlashApp:: POOL_DOESNT_EXIST");
1003         require(_altQuantity > 0, "FlashApp:: INVALID_AMOUNT");
1004 
1005         IERC20(_token).safeTransferFrom(user, address(this), _altQuantity);
1006         IERC20(_token).safeTransfer(pool, _altQuantity);
1007 
1008         result = IPool(pool).swapWithFeeRewardDistribution(_altQuantity, user, _expectedOutput);
1009 
1010         emit Swapped(user, _altQuantity, result, pool);
1011     }
1012 
1013     function addLiquidityInPool(
1014         uint256 _amountFLASH,
1015         uint256 _amountALT,
1016         uint256 _amountFLASHMin,
1017         uint256 _amountALTMin,
1018         address _token
1019     ) public {
1020         address maker = msg.sender;
1021         address pool = pools[_token];
1022 
1023         require(pool != address(0), "FlashApp:: POOL_DOESNT_EXIST");
1024         require(_amountFLASH > 0 && _amountALT > 0, "FlashApp:: INVALID_AMOUNT");
1025 
1026         (uint256 amountFLASH, uint256 amountALT, uint256 liquidity) = IPool(pool).addLiquidity(
1027             _amountFLASH,
1028             _amountALT,
1029             _amountFLASHMin,
1030             _amountALTMin,
1031             maker
1032         );
1033 
1034         IERC20(FLASH_TOKEN).safeTransferFrom(maker, address(this), amountFLASH);
1035         IERC20(FLASH_TOKEN).safeTransfer(pool, amountFLASH);
1036 
1037         IERC20(_token).safeTransferFrom(maker, address(this), amountALT);
1038         IERC20(_token).safeTransfer(pool, amountALT);
1039 
1040         emit LiquidityAdded(pool, amountFLASH, amountALT, liquidity, maker);
1041     }
1042 
1043     function removeLiquidityInPool(uint256 _liquidity, address _token) public {
1044         address maker = msg.sender;
1045 
1046         address pool = pools[_token];
1047 
1048         require(pool != address(0), "FlashApp:: POOL_DOESNT_EXIST");
1049 
1050         IERC20(pool).safeTransferFrom(maker, address(this), _liquidity);
1051         IERC20(pool).safeTransfer(pool, _liquidity);
1052 
1053         (uint256 amountFLASH, uint256 amountALT) = IPool(pool).removeLiquidity(maker);
1054 
1055         emit LiquidityRemoved(pool, amountFLASH, amountALT, _liquidity, maker);
1056     }
1057 
1058     function removeLiquidityInPoolWithPermit(
1059         uint256 _liquidity,
1060         address _token,
1061         uint256 _deadline,
1062         uint8 _v,
1063         bytes32 _r,
1064         bytes32 _s
1065     ) public {
1066         address maker = msg.sender;
1067 
1068         address pool = pools[_token];
1069 
1070         require(pool != address(0), "FlashApp:: POOL_DOESNT_EXIST");
1071 
1072         IERC20(pool).permit(maker, pool, type(uint256).max, _deadline, _v, _r, _s);
1073 
1074         IERC20(pool).safeTransferFrom(maker, pool, _liquidity);
1075 
1076         (uint256 amountFLASH, uint256 amountALT) = IPool(pool).removeLiquidity(maker);
1077 
1078         emit LiquidityRemoved(pool, amountFLASH, amountALT, _liquidity, maker);
1079     }
1080 }