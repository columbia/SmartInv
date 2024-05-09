1 // File: contracts/interfaces/IKARMAAntiBot.sol
2 
3 
4 pragma solidity ^0.8.17;
5 
6 interface IKARMAAntiBot {
7   function setTokenOwner(address owner) external;
8   function launch(address pair, address router) external;
9 
10   function onPreTransferCheck(
11     address from,
12     address to,
13     uint256 amount
14   ) external;
15 }
16 // File: contracts/ERC1363/IERC1363Spender.sol
17 
18 
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @title IERC1363Spender Interface
24  * @author Vittorio Minacori (https://github.com/vittominacori)
25  * @dev Interface for any contract that wants to support approveAndCall
26  *  from ERC1363 token contracts as defined in
27  *  https://eips.ethereum.org/EIPS/eip-1363
28  */
29 interface IERC1363Spender {
30     /**
31      * @notice Handle the approval of ERC1363 tokens
32      * @dev Any ERC1363 smart contract calls this function on the recipient
33      * after an `approve`. This function MAY throw to revert and reject the
34      * approval. Return of other than the magic value MUST result in the
35      * transaction being reverted.
36      * Note: the token contract address is always the message sender.
37      * @param sender address The address which called `approveAndCall` function
38      * @param amount uint256 The amount of tokens to be spent
39      * @param data bytes Additional data with no specified format
40      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
41      */
42     function onApprovalReceived(
43         address sender,
44         uint256 amount,
45         bytes calldata data
46     ) external returns (bytes4);
47 }
48 
49 // File: contracts/ERC1363/IERC1363Receiver.sol
50 
51 
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @title IERC1363Receiver Interface
57  * @author Vittorio Minacori (https://github.com/vittominacori)
58  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
59  *  from ERC1363 token contracts as defined in
60  *  https://eips.ethereum.org/EIPS/eip-1363
61  */
62 interface IERC1363Receiver {
63     /**
64      * @notice Handle the receipt of ERC1363 tokens
65      * @dev Any ERC1363 smart contract calls this function on the recipient
66      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
67      * transfer. Return of other than the magic value MUST result in the
68      * transaction being reverted.
69      * Note: the token contract address is always the message sender.
70      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
71      * @param sender address The address which are token transferred from
72      * @param amount uint256 The amount of tokens transferred
73      * @param data bytes Additional data with no specified format
74      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
75      */
76     function onTransferReceived(
77         address operator,
78         address sender,
79         uint256 amount,
80         bytes calldata data
81     ) external returns (bytes4);
82 }
83 
84 // File: @openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Interface of the ERC165 standard, as defined in the
93  * https://eips.ethereum.org/EIPS/eip-165[EIP].
94  *
95  * Implementers can declare support of contract interfaces, which can then be
96  * queried by others ({ERC165Checker}).
97  *
98  * For an implementation, see {ERC165}.
99  */
100 interface IERC165Upgradeable {
101     /**
102      * @dev Returns true if this contract implements the interface defined by
103      * `interfaceId`. See the corresponding
104      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
105      * to learn more about how these ids are created.
106      *
107      * This function call must use less than 30 000 gas.
108      */
109     function supportsInterface(bytes4 interfaceId) external view returns (bool);
110 }
111 
112 // File: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20PermitUpgradeable.sol
113 
114 
115 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
121  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
122  *
123  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
124  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
125  * need to send a transaction, and thus is not required to hold Ether at all.
126  */
127 interface IERC20PermitUpgradeable {
128     /**
129      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
130      * given ``owner``'s signed approval.
131      *
132      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
133      * ordering also apply here.
134      *
135      * Emits an {Approval} event.
136      *
137      * Requirements:
138      *
139      * - `spender` cannot be the zero address.
140      * - `deadline` must be a timestamp in the future.
141      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
142      * over the EIP712-formatted function arguments.
143      * - the signature must use ``owner``'s current nonce (see {nonces}).
144      *
145      * For more information on the signature format, see the
146      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
147      * section].
148      */
149     function permit(
150         address owner,
151         address spender,
152         uint256 value,
153         uint256 deadline,
154         uint8 v,
155         bytes32 r,
156         bytes32 s
157     ) external;
158 
159     /**
160      * @dev Returns the current nonce for `owner`. This value must be
161      * included whenever a signature is generated for {permit}.
162      *
163      * Every successful call to {permit} increases ``owner``'s nonce by one. This
164      * prevents a signature from being used multiple times.
165      */
166     function nonces(address owner) external view returns (uint256);
167 
168     /**
169      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
170      */
171     // solhint-disable-next-line func-name-mixedcase
172     function DOMAIN_SEPARATOR() external view returns (bytes32);
173 }
174 
175 // File: @openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol
176 
177 
178 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 // CAUTION
183 // This version of SafeMath should only be used with Solidity 0.8 or later,
184 // because it relies on the compiler's built in overflow checks.
185 
186 /**
187  * @dev Wrappers over Solidity's arithmetic operations.
188  *
189  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
190  * now has built in overflow checking.
191  */
192 library SafeMathUpgradeable {
193     /**
194      * @dev Returns the addition of two unsigned integers, with an overflow flag.
195      *
196      * _Available since v3.4._
197      */
198     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
199         unchecked {
200             uint256 c = a + b;
201             if (c < a) return (false, 0);
202             return (true, c);
203         }
204     }
205 
206     /**
207      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
208      *
209      * _Available since v3.4._
210      */
211     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
212         unchecked {
213             if (b > a) return (false, 0);
214             return (true, a - b);
215         }
216     }
217 
218     /**
219      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
220      *
221      * _Available since v3.4._
222      */
223     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
224         unchecked {
225             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
226             // benefit is lost if 'b' is also tested.
227             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
228             if (a == 0) return (true, 0);
229             uint256 c = a * b;
230             if (c / a != b) return (false, 0);
231             return (true, c);
232         }
233     }
234 
235     /**
236      * @dev Returns the division of two unsigned integers, with a division by zero flag.
237      *
238      * _Available since v3.4._
239      */
240     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
241         unchecked {
242             if (b == 0) return (false, 0);
243             return (true, a / b);
244         }
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
249      *
250      * _Available since v3.4._
251      */
252     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
253         unchecked {
254             if (b == 0) return (false, 0);
255             return (true, a % b);
256         }
257     }
258 
259     /**
260      * @dev Returns the addition of two unsigned integers, reverting on
261      * overflow.
262      *
263      * Counterpart to Solidity's `+` operator.
264      *
265      * Requirements:
266      *
267      * - Addition cannot overflow.
268      */
269     function add(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a + b;
271     }
272 
273     /**
274      * @dev Returns the subtraction of two unsigned integers, reverting on
275      * overflow (when the result is negative).
276      *
277      * Counterpart to Solidity's `-` operator.
278      *
279      * Requirements:
280      *
281      * - Subtraction cannot overflow.
282      */
283     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
284         return a - b;
285     }
286 
287     /**
288      * @dev Returns the multiplication of two unsigned integers, reverting on
289      * overflow.
290      *
291      * Counterpart to Solidity's `*` operator.
292      *
293      * Requirements:
294      *
295      * - Multiplication cannot overflow.
296      */
297     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a * b;
299     }
300 
301     /**
302      * @dev Returns the integer division of two unsigned integers, reverting on
303      * division by zero. The result is rounded towards zero.
304      *
305      * Counterpart to Solidity's `/` operator.
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function div(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a / b;
313     }
314 
315     /**
316      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
317      * reverting when dividing by zero.
318      *
319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
320      * opcode (which leaves remaining gas untouched) while Solidity uses an
321      * invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
328         return a % b;
329     }
330 
331     /**
332      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
333      * overflow (when the result is negative).
334      *
335      * CAUTION: This function is deprecated because it requires allocating memory for the error
336      * message unnecessarily. For custom revert reasons use {trySub}.
337      *
338      * Counterpart to Solidity's `-` operator.
339      *
340      * Requirements:
341      *
342      * - Subtraction cannot overflow.
343      */
344     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
345         unchecked {
346             require(b <= a, errorMessage);
347             return a - b;
348         }
349     }
350 
351     /**
352      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
353      * division by zero. The result is rounded towards zero.
354      *
355      * Counterpart to Solidity's `/` operator. Note: this function uses a
356      * `revert` opcode (which leaves remaining gas untouched) while Solidity
357      * uses an invalid opcode to revert (consuming all remaining gas).
358      *
359      * Requirements:
360      *
361      * - The divisor cannot be zero.
362      */
363     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
364         unchecked {
365             require(b > 0, errorMessage);
366             return a / b;
367         }
368     }
369 
370     /**
371      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
372      * reverting with custom message when dividing by zero.
373      *
374      * CAUTION: This function is deprecated because it requires allocating memory for the error
375      * message unnecessarily. For custom revert reasons use {tryMod}.
376      *
377      * Counterpart to Solidity's `%` operator. This function uses a `revert`
378      * opcode (which leaves remaining gas untouched) while Solidity uses an
379      * invalid opcode to revert (consuming all remaining gas).
380      *
381      * Requirements:
382      *
383      * - The divisor cannot be zero.
384      */
385     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
386         unchecked {
387             require(b > 0, errorMessage);
388             return a % b;
389         }
390     }
391 }
392 
393 // File: @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol
394 
395 
396 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @dev Interface of the ERC20 standard as defined in the EIP.
402  */
403 interface IERC20Upgradeable {
404     /**
405      * @dev Emitted when `value` tokens are moved from one account (`from`) to
406      * another (`to`).
407      *
408      * Note that `value` may be zero.
409      */
410     event Transfer(address indexed from, address indexed to, uint256 value);
411 
412     /**
413      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
414      * a call to {approve}. `value` is the new allowance.
415      */
416     event Approval(address indexed owner, address indexed spender, uint256 value);
417 
418     /**
419      * @dev Returns the amount of tokens in existence.
420      */
421     function totalSupply() external view returns (uint256);
422 
423     /**
424      * @dev Returns the amount of tokens owned by `account`.
425      */
426     function balanceOf(address account) external view returns (uint256);
427 
428     /**
429      * @dev Moves `amount` tokens from the caller's account to `to`.
430      *
431      * Returns a boolean value indicating whether the operation succeeded.
432      *
433      * Emits a {Transfer} event.
434      */
435     function transfer(address to, uint256 amount) external returns (bool);
436 
437     /**
438      * @dev Returns the remaining number of tokens that `spender` will be
439      * allowed to spend on behalf of `owner` through {transferFrom}. This is
440      * zero by default.
441      *
442      * This value changes when {approve} or {transferFrom} are called.
443      */
444     function allowance(address owner, address spender) external view returns (uint256);
445 
446     /**
447      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
448      *
449      * Returns a boolean value indicating whether the operation succeeded.
450      *
451      * IMPORTANT: Beware that changing an allowance with this method brings the risk
452      * that someone may use both the old and the new allowance by unfortunate
453      * transaction ordering. One possible solution to mitigate this race
454      * condition is to first reduce the spender's allowance to 0 and set the
455      * desired value afterwards:
456      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
457      *
458      * Emits an {Approval} event.
459      */
460     function approve(address spender, uint256 amount) external returns (bool);
461 
462     /**
463      * @dev Moves `amount` tokens from `from` to `to` using the
464      * allowance mechanism. `amount` is then deducted from the caller's
465      * allowance.
466      *
467      * Returns a boolean value indicating whether the operation succeeded.
468      *
469      * Emits a {Transfer} event.
470      */
471     function transferFrom(address from, address to, uint256 amount) external returns (bool);
472 }
473 
474 // File: contracts/ERC1363/IERC1363.sol
475 
476 
477 
478 pragma solidity ^0.8.0;
479 
480 
481 
482 /**
483  * @title IERC1363 Interface
484  * @author Vittorio Minacori (https://github.com/vittominacori)
485  * @dev Interface for a Payable Token contract as defined in
486  *  https://eips.ethereum.org/EIPS/eip-1363
487  */
488 interface IERC1363 is IERC165Upgradeable, IERC20Upgradeable {
489     /**
490      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
491      * @param recipient address The address which you want to transfer to
492      * @param amount uint256 The amount of tokens to be transferred
493      * @return true unless throwing
494      */
495     function transferAndCall(address recipient, uint256 amount) external returns (bool);
496 
497     /**
498      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
499      * @param recipient address The address which you want to transfer to
500      * @param amount uint256 The amount of tokens to be transferred
501      * @param data bytes Additional data with no specified format, sent in call to `recipient`
502      * @return true unless throwing
503      */
504     function transferAndCall(
505         address recipient,
506         uint256 amount,
507         bytes calldata data
508     ) external returns (bool);
509 
510     /**
511      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
512      * @param sender address The address which you want to send tokens from
513      * @param recipient address The address which you want to transfer to
514      * @param amount uint256 The amount of tokens to be transferred
515      * @return true unless throwing
516      */
517     function transferFromAndCall(
518         address sender,
519         address recipient,
520         uint256 amount
521     ) external returns (bool);
522 
523     /**
524      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
525      * @param sender address The address which you want to send tokens from
526      * @param recipient address The address which you want to transfer to
527      * @param amount uint256 The amount of tokens to be transferred
528      * @param data bytes Additional data with no specified format, sent in call to `recipient`
529      * @return true unless throwing
530      */
531     function transferFromAndCall(
532         address sender,
533         address recipient,
534         uint256 amount,
535         bytes calldata data
536     ) external returns (bool);
537 
538     /**
539      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
540      * and then call `onApprovalReceived` on spender.
541      * Beware that changing an allowance with this method brings the risk that someone may use both the old
542      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
543      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
544      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
545      * @param spender address The address which will spend the funds
546      * @param amount uint256 The amount of tokens to be spent
547      */
548     function approveAndCall(address spender, uint256 amount) external returns (bool);
549 
550     /**
551      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
552      * and then call `onApprovalReceived` on spender.
553      * Beware that changing an allowance with this method brings the risk that someone may use both the old
554      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
555      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
556      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
557      * @param spender address The address which will spend the funds
558      * @param amount uint256 The amount of tokens to be spent
559      * @param data bytes Additional data with no specified format, sent in call to `spender`
560      */
561     function approveAndCall(
562         address spender,
563         uint256 amount,
564         bytes calldata data
565     ) external returns (bool);
566 }
567 
568 // File: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @dev Interface for the optional metadata functions from the ERC20 standard.
578  *
579  * _Available since v4.1._
580  */
581 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
582     /**
583      * @dev Returns the name of the token.
584      */
585     function name() external view returns (string memory);
586 
587     /**
588      * @dev Returns the symbol of the token.
589      */
590     function symbol() external view returns (string memory);
591 
592     /**
593      * @dev Returns the decimals places of the token.
594      */
595     function decimals() external view returns (uint8);
596 }
597 
598 // File: contracts/interfaces/IToken.sol
599 
600 
601 
602 pragma solidity ^0.8.0;
603 
604 
605 interface IToken is IERC20MetadataUpgradeable {
606 
607     struct Taxes {
608         uint256 marketing;
609         uint256 reflection;
610     }
611 
612     struct TokenData {
613         string name;
614         string symbol;
615         uint8 decimals;
616         uint256 supply;
617         uint256 maxTx;
618         uint256 maxWallet;
619         address routerAddress;
620         address karmaDeployer;
621         Taxes buyTax;
622         Taxes sellTax;
623         address marketingWallet;
624         address rewardToken;
625         address antiBot;
626         address limitedOwner;
627         address karmaCampaignFactory;
628     }
629 
630     function initialize(TokenData memory tokenData) external;
631 
632     function updateExcludedFromFees(address _address, bool state) external;
633     function excludedFromFees(address _address) external view returns (bool);
634 
635     function getOwner() external view returns (address);
636     
637 }
638 
639 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
640 
641 
642 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
643 
644 pragma solidity ^0.8.1;
645 
646 /**
647  * @dev Collection of functions related to the address type
648  */
649 library AddressUpgradeable {
650     /**
651      * @dev Returns true if `account` is a contract.
652      *
653      * [IMPORTANT]
654      * ====
655      * It is unsafe to assume that an address for which this function returns
656      * false is an externally-owned account (EOA) and not a contract.
657      *
658      * Among others, `isContract` will return false for the following
659      * types of addresses:
660      *
661      *  - an externally-owned account
662      *  - a contract in construction
663      *  - an address where a contract will be created
664      *  - an address where a contract lived, but was destroyed
665      *
666      * Furthermore, `isContract` will also return true if the target contract within
667      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
668      * which only has an effect at the end of a transaction.
669      * ====
670      *
671      * [IMPORTANT]
672      * ====
673      * You shouldn't rely on `isContract` to protect against flash loan attacks!
674      *
675      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
676      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
677      * constructor.
678      * ====
679      */
680     function isContract(address account) internal view returns (bool) {
681         // This method relies on extcodesize/address.code.length, which returns 0
682         // for contracts in construction, since the code is only stored at the end
683         // of the constructor execution.
684 
685         return account.code.length > 0;
686     }
687 
688     /**
689      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
690      * `recipient`, forwarding all available gas and reverting on errors.
691      *
692      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
693      * of certain opcodes, possibly making contracts go over the 2300 gas limit
694      * imposed by `transfer`, making them unable to receive funds via
695      * `transfer`. {sendValue} removes this limitation.
696      *
697      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
698      *
699      * IMPORTANT: because control is transferred to `recipient`, care must be
700      * taken to not create reentrancy vulnerabilities. Consider using
701      * {ReentrancyGuard} or the
702      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
703      */
704     function sendValue(address payable recipient, uint256 amount) internal {
705         require(address(this).balance >= amount, "Address: insufficient balance");
706 
707         (bool success, ) = recipient.call{value: amount}("");
708         require(success, "Address: unable to send value, recipient may have reverted");
709     }
710 
711     /**
712      * @dev Performs a Solidity function call using a low level `call`. A
713      * plain `call` is an unsafe replacement for a function call: use this
714      * function instead.
715      *
716      * If `target` reverts with a revert reason, it is bubbled up by this
717      * function (like regular Solidity function calls).
718      *
719      * Returns the raw returned data. To convert to the expected return value,
720      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
721      *
722      * Requirements:
723      *
724      * - `target` must be a contract.
725      * - calling `target` with `data` must not revert.
726      *
727      * _Available since v3.1._
728      */
729     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
730         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
735      * `errorMessage` as a fallback revert reason when `target` reverts.
736      *
737      * _Available since v3.1._
738      */
739     function functionCall(
740         address target,
741         bytes memory data,
742         string memory errorMessage
743     ) internal returns (bytes memory) {
744         return functionCallWithValue(target, data, 0, errorMessage);
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
749      * but also transferring `value` wei to `target`.
750      *
751      * Requirements:
752      *
753      * - the calling contract must have an ETH balance of at least `value`.
754      * - the called Solidity function must be `payable`.
755      *
756      * _Available since v3.1._
757      */
758     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
759         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
764      * with `errorMessage` as a fallback revert reason when `target` reverts.
765      *
766      * _Available since v3.1._
767      */
768     function functionCallWithValue(
769         address target,
770         bytes memory data,
771         uint256 value,
772         string memory errorMessage
773     ) internal returns (bytes memory) {
774         require(address(this).balance >= value, "Address: insufficient balance for call");
775         (bool success, bytes memory returndata) = target.call{value: value}(data);
776         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
781      * but performing a static call.
782      *
783      * _Available since v3.3._
784      */
785     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
786         return functionStaticCall(target, data, "Address: low-level static call failed");
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
791      * but performing a static call.
792      *
793      * _Available since v3.3._
794      */
795     function functionStaticCall(
796         address target,
797         bytes memory data,
798         string memory errorMessage
799     ) internal view returns (bytes memory) {
800         (bool success, bytes memory returndata) = target.staticcall(data);
801         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
802     }
803 
804     /**
805      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
806      * but performing a delegate call.
807      *
808      * _Available since v3.4._
809      */
810     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
811         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
812     }
813 
814     /**
815      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
816      * but performing a delegate call.
817      *
818      * _Available since v3.4._
819      */
820     function functionDelegateCall(
821         address target,
822         bytes memory data,
823         string memory errorMessage
824     ) internal returns (bytes memory) {
825         (bool success, bytes memory returndata) = target.delegatecall(data);
826         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
827     }
828 
829     /**
830      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
831      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
832      *
833      * _Available since v4.8._
834      */
835     function verifyCallResultFromTarget(
836         address target,
837         bool success,
838         bytes memory returndata,
839         string memory errorMessage
840     ) internal view returns (bytes memory) {
841         if (success) {
842             if (returndata.length == 0) {
843                 // only check isContract if the call was successful and the return data is empty
844                 // otherwise we already know that it was a contract
845                 require(isContract(target), "Address: call to non-contract");
846             }
847             return returndata;
848         } else {
849             _revert(returndata, errorMessage);
850         }
851     }
852 
853     /**
854      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
855      * revert reason or using the provided one.
856      *
857      * _Available since v4.3._
858      */
859     function verifyCallResult(
860         bool success,
861         bytes memory returndata,
862         string memory errorMessage
863     ) internal pure returns (bytes memory) {
864         if (success) {
865             return returndata;
866         } else {
867             _revert(returndata, errorMessage);
868         }
869     }
870 
871     function _revert(bytes memory returndata, string memory errorMessage) private pure {
872         // Look for revert reason and bubble it up if present
873         if (returndata.length > 0) {
874             // The easiest way to bubble the revert reason is using memory via assembly
875             /// @solidity memory-safe-assembly
876             assembly {
877                 let returndata_size := mload(returndata)
878                 revert(add(32, returndata), returndata_size)
879             }
880         } else {
881             revert(errorMessage);
882         }
883     }
884 }
885 
886 // File: @openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol
887 
888 
889 // OpenZeppelin Contracts (last updated v4.9.3) (token/ERC20/utils/SafeERC20.sol)
890 
891 pragma solidity ^0.8.0;
892 
893 
894 
895 
896 /**
897  * @title SafeERC20
898  * @dev Wrappers around ERC20 operations that throw on failure (when the token
899  * contract returns false). Tokens that return no value (and instead revert or
900  * throw on failure) are also supported, non-reverting calls are assumed to be
901  * successful.
902  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
903  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
904  */
905 library SafeERC20Upgradeable {
906     using AddressUpgradeable for address;
907 
908     /**
909      * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
910      * non-reverting calls are assumed to be successful.
911      */
912     function safeTransfer(IERC20Upgradeable token, address to, uint256 value) internal {
913         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
914     }
915 
916     /**
917      * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
918      * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
919      */
920     function safeTransferFrom(IERC20Upgradeable token, address from, address to, uint256 value) internal {
921         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
922     }
923 
924     /**
925      * @dev Deprecated. This function has issues similar to the ones found in
926      * {IERC20-approve}, and its usage is discouraged.
927      *
928      * Whenever possible, use {safeIncreaseAllowance} and
929      * {safeDecreaseAllowance} instead.
930      */
931     function safeApprove(IERC20Upgradeable token, address spender, uint256 value) internal {
932         // safeApprove should only be called when setting an initial allowance,
933         // or when resetting it to zero. To increase and decrease it, use
934         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
935         require(
936             (value == 0) || (token.allowance(address(this), spender) == 0),
937             "SafeERC20: approve from non-zero to non-zero allowance"
938         );
939         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
940     }
941 
942     /**
943      * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
944      * non-reverting calls are assumed to be successful.
945      */
946     function safeIncreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
947         uint256 oldAllowance = token.allowance(address(this), spender);
948         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
949     }
950 
951     /**
952      * @dev Decrease the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
953      * non-reverting calls are assumed to be successful.
954      */
955     function safeDecreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
956         unchecked {
957             uint256 oldAllowance = token.allowance(address(this), spender);
958             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
959             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
960         }
961     }
962 
963     /**
964      * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
965      * non-reverting calls are assumed to be successful. Meant to be used with tokens that require the approval
966      * to be set to zero before setting it to a non-zero value, such as USDT.
967      */
968     function forceApprove(IERC20Upgradeable token, address spender, uint256 value) internal {
969         bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);
970 
971         if (!_callOptionalReturnBool(token, approvalCall)) {
972             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
973             _callOptionalReturn(token, approvalCall);
974         }
975     }
976 
977     /**
978      * @dev Use a ERC-2612 signature to set the `owner` approval toward `spender` on `token`.
979      * Revert on invalid signature.
980      */
981     function safePermit(
982         IERC20PermitUpgradeable token,
983         address owner,
984         address spender,
985         uint256 value,
986         uint256 deadline,
987         uint8 v,
988         bytes32 r,
989         bytes32 s
990     ) internal {
991         uint256 nonceBefore = token.nonces(owner);
992         token.permit(owner, spender, value, deadline, v, r, s);
993         uint256 nonceAfter = token.nonces(owner);
994         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
995     }
996 
997     /**
998      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
999      * on the return value: the return value is optional (but if data is returned, it must not be false).
1000      * @param token The token targeted by the call.
1001      * @param data The call data (encoded using abi.encode or one of its variants).
1002      */
1003     function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
1004         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1005         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1006         // the target address contains contract code and also asserts for success in the low-level call.
1007 
1008         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1009         require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1010     }
1011 
1012     /**
1013      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1014      * on the return value: the return value is optional (but if data is returned, it must not be false).
1015      * @param token The token targeted by the call.
1016      * @param data The call data (encoded using abi.encode or one of its variants).
1017      *
1018      * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
1019      */
1020     function _callOptionalReturnBool(IERC20Upgradeable token, bytes memory data) private returns (bool) {
1021         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1022         // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
1023         // and not revert is the subcall reverts.
1024 
1025         (bool success, bytes memory returndata) = address(token).call(data);
1026         return
1027             success && (returndata.length == 0 || abi.decode(returndata, (bool))) && AddressUpgradeable.isContract(address(token));
1028     }
1029 }
1030 
1031 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
1032 
1033 
1034 // OpenZeppelin Contracts (last updated v4.9.0) (proxy/utils/Initializable.sol)
1035 
1036 pragma solidity ^0.8.2;
1037 
1038 
1039 /**
1040  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
1041  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
1042  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
1043  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
1044  *
1045  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
1046  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
1047  * case an upgrade adds a module that needs to be initialized.
1048  *
1049  * For example:
1050  *
1051  * [.hljs-theme-light.nopadding]
1052  * ```solidity
1053  * contract MyToken is ERC20Upgradeable {
1054  *     function initialize() initializer public {
1055  *         __ERC20_init("MyToken", "MTK");
1056  *     }
1057  * }
1058  *
1059  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
1060  *     function initializeV2() reinitializer(2) public {
1061  *         __ERC20Permit_init("MyToken");
1062  *     }
1063  * }
1064  * ```
1065  *
1066  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
1067  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
1068  *
1069  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
1070  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
1071  *
1072  * [CAUTION]
1073  * ====
1074  * Avoid leaving a contract uninitialized.
1075  *
1076  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
1077  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
1078  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
1079  *
1080  * [.hljs-theme-light.nopadding]
1081  * ```
1082  * /// @custom:oz-upgrades-unsafe-allow constructor
1083  * constructor() {
1084  *     _disableInitializers();
1085  * }
1086  * ```
1087  * ====
1088  */
1089 abstract contract Initializable {
1090     /**
1091      * @dev Indicates that the contract has been initialized.
1092      * @custom:oz-retyped-from bool
1093      */
1094     uint8 private _initialized;
1095 
1096     /**
1097      * @dev Indicates that the contract is in the process of being initialized.
1098      */
1099     bool private _initializing;
1100 
1101     /**
1102      * @dev Triggered when the contract has been initialized or reinitialized.
1103      */
1104     event Initialized(uint8 version);
1105 
1106     /**
1107      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
1108      * `onlyInitializing` functions can be used to initialize parent contracts.
1109      *
1110      * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
1111      * constructor.
1112      *
1113      * Emits an {Initialized} event.
1114      */
1115     modifier initializer() {
1116         bool isTopLevelCall = !_initializing;
1117         require(
1118             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
1119             "Initializable: contract is already initialized"
1120         );
1121         _initialized = 1;
1122         if (isTopLevelCall) {
1123             _initializing = true;
1124         }
1125         _;
1126         if (isTopLevelCall) {
1127             _initializing = false;
1128             emit Initialized(1);
1129         }
1130     }
1131 
1132     /**
1133      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
1134      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
1135      * used to initialize parent contracts.
1136      *
1137      * A reinitializer may be used after the original initialization step. This is essential to configure modules that
1138      * are added through upgrades and that require initialization.
1139      *
1140      * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
1141      * cannot be nested. If one is invoked in the context of another, execution will revert.
1142      *
1143      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
1144      * a contract, executing them in the right order is up to the developer or operator.
1145      *
1146      * WARNING: setting the version to 255 will prevent any future reinitialization.
1147      *
1148      * Emits an {Initialized} event.
1149      */
1150     modifier reinitializer(uint8 version) {
1151         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
1152         _initialized = version;
1153         _initializing = true;
1154         _;
1155         _initializing = false;
1156         emit Initialized(version);
1157     }
1158 
1159     /**
1160      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
1161      * {initializer} and {reinitializer} modifiers, directly or indirectly.
1162      */
1163     modifier onlyInitializing() {
1164         require(_initializing, "Initializable: contract is not initializing");
1165         _;
1166     }
1167 
1168     /**
1169      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
1170      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
1171      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
1172      * through proxies.
1173      *
1174      * Emits an {Initialized} event the first time it is successfully executed.
1175      */
1176     function _disableInitializers() internal virtual {
1177         require(!_initializing, "Initializable: contract is initializing");
1178         if (_initialized != type(uint8).max) {
1179             _initialized = type(uint8).max;
1180             emit Initialized(type(uint8).max);
1181         }
1182     }
1183 
1184     /**
1185      * @dev Returns the highest version that has been initialized. See {reinitializer}.
1186      */
1187     function _getInitializedVersion() internal view returns (uint8) {
1188         return _initialized;
1189     }
1190 
1191     /**
1192      * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
1193      */
1194     function _isInitializing() internal view returns (bool) {
1195         return _initializing;
1196     }
1197 }
1198 
1199 // File: @openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol
1200 
1201 
1202 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1203 
1204 pragma solidity ^0.8.0;
1205 
1206 
1207 
1208 /**
1209  * @dev Implementation of the {IERC165} interface.
1210  *
1211  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1212  * for the additional interface id that will be supported. For example:
1213  *
1214  * ```solidity
1215  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1216  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1217  * }
1218  * ```
1219  *
1220  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1221  */
1222 abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
1223     function __ERC165_init() internal onlyInitializing {
1224     }
1225 
1226     function __ERC165_init_unchained() internal onlyInitializing {
1227     }
1228     /**
1229      * @dev See {IERC165-supportsInterface}.
1230      */
1231     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1232         return interfaceId == type(IERC165Upgradeable).interfaceId;
1233     }
1234 
1235     /**
1236      * @dev This empty reserved space is put in place to allow future versions to add new
1237      * variables without shifting down storage in the inheritance chain.
1238      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1239      */
1240     uint256[50] private __gap;
1241 }
1242 
1243 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
1244 
1245 
1246 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1247 
1248 pragma solidity ^0.8.0;
1249 
1250 
1251 /**
1252  * @dev Provides information about the current execution context, including the
1253  * sender of the transaction and its data. While these are generally available
1254  * via msg.sender and msg.data, they should not be accessed in such a direct
1255  * manner, since when dealing with meta-transactions the account sending and
1256  * paying for execution may not be the actual sender (as far as an application
1257  * is concerned).
1258  *
1259  * This contract is only required for intermediate, library-like contracts.
1260  */
1261 abstract contract ContextUpgradeable is Initializable {
1262     function __Context_init() internal onlyInitializing {
1263     }
1264 
1265     function __Context_init_unchained() internal onlyInitializing {
1266     }
1267     function _msgSender() internal view virtual returns (address) {
1268         return msg.sender;
1269     }
1270 
1271     function _msgData() internal view virtual returns (bytes calldata) {
1272         return msg.data;
1273     }
1274 
1275     /**
1276      * @dev This empty reserved space is put in place to allow future versions to add new
1277      * variables without shifting down storage in the inheritance chain.
1278      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1279      */
1280     uint256[50] private __gap;
1281 }
1282 
1283 // File: @openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol
1284 
1285 
1286 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1287 
1288 pragma solidity ^0.8.0;
1289 
1290 
1291 
1292 
1293 
1294 /**
1295  * @dev Implementation of the {IERC20} interface.
1296  *
1297  * This implementation is agnostic to the way tokens are created. This means
1298  * that a supply mechanism has to be added in a derived contract using {_mint}.
1299  * For a generic mechanism see {ERC20PresetMinterPauser}.
1300  *
1301  * TIP: For a detailed writeup see our guide
1302  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1303  * to implement supply mechanisms].
1304  *
1305  * The default value of {decimals} is 18. To change this, you should override
1306  * this function so it returns a different value.
1307  *
1308  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1309  * instead returning `false` on failure. This behavior is nonetheless
1310  * conventional and does not conflict with the expectations of ERC20
1311  * applications.
1312  *
1313  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1314  * This allows applications to reconstruct the allowance for all accounts just
1315  * by listening to said events. Other implementations of the EIP may not emit
1316  * these events, as it isn't required by the specification.
1317  *
1318  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1319  * functions have been added to mitigate the well-known issues around setting
1320  * allowances. See {IERC20-approve}.
1321  */
1322 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
1323     mapping(address => uint256) private _balances;
1324 
1325     mapping(address => mapping(address => uint256)) private _allowances;
1326 
1327     uint256 private _totalSupply;
1328 
1329     string private _name;
1330     string private _symbol;
1331 
1332     /**
1333      * @dev Sets the values for {name} and {symbol}.
1334      *
1335      * All two of these values are immutable: they can only be set once during
1336      * construction.
1337      */
1338     function __ERC20_init(string memory name_, string memory symbol_) internal onlyInitializing {
1339         __ERC20_init_unchained(name_, symbol_);
1340     }
1341 
1342     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
1343         _name = name_;
1344         _symbol = symbol_;
1345     }
1346 
1347     /**
1348      * @dev Returns the name of the token.
1349      */
1350     function name() public view virtual override returns (string memory) {
1351         return _name;
1352     }
1353 
1354     /**
1355      * @dev Returns the symbol of the token, usually a shorter version of the
1356      * name.
1357      */
1358     function symbol() public view virtual override returns (string memory) {
1359         return _symbol;
1360     }
1361 
1362     /**
1363      * @dev Returns the number of decimals used to get its user representation.
1364      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1365      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1366      *
1367      * Tokens usually opt for a value of 18, imitating the relationship between
1368      * Ether and Wei. This is the default value returned by this function, unless
1369      * it's overridden.
1370      *
1371      * NOTE: This information is only used for _display_ purposes: it in
1372      * no way affects any of the arithmetic of the contract, including
1373      * {IERC20-balanceOf} and {IERC20-transfer}.
1374      */
1375     function decimals() public view virtual override returns (uint8) {
1376         return 18;
1377     }
1378 
1379     /**
1380      * @dev See {IERC20-totalSupply}.
1381      */
1382     function totalSupply() public view virtual override returns (uint256) {
1383         return _totalSupply;
1384     }
1385 
1386     /**
1387      * @dev See {IERC20-balanceOf}.
1388      */
1389     function balanceOf(address account) public view virtual override returns (uint256) {
1390         return _balances[account];
1391     }
1392 
1393     /**
1394      * @dev See {IERC20-transfer}.
1395      *
1396      * Requirements:
1397      *
1398      * - `to` cannot be the zero address.
1399      * - the caller must have a balance of at least `amount`.
1400      */
1401     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1402         address owner = _msgSender();
1403         _transfer(owner, to, amount);
1404         return true;
1405     }
1406 
1407     /**
1408      * @dev See {IERC20-allowance}.
1409      */
1410     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1411         return _allowances[owner][spender];
1412     }
1413 
1414     /**
1415      * @dev See {IERC20-approve}.
1416      *
1417      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1418      * `transferFrom`. This is semantically equivalent to an infinite approval.
1419      *
1420      * Requirements:
1421      *
1422      * - `spender` cannot be the zero address.
1423      */
1424     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1425         address owner = _msgSender();
1426         _approve(owner, spender, amount);
1427         return true;
1428     }
1429 
1430     /**
1431      * @dev See {IERC20-transferFrom}.
1432      *
1433      * Emits an {Approval} event indicating the updated allowance. This is not
1434      * required by the EIP. See the note at the beginning of {ERC20}.
1435      *
1436      * NOTE: Does not update the allowance if the current allowance
1437      * is the maximum `uint256`.
1438      *
1439      * Requirements:
1440      *
1441      * - `from` and `to` cannot be the zero address.
1442      * - `from` must have a balance of at least `amount`.
1443      * - the caller must have allowance for ``from``'s tokens of at least
1444      * `amount`.
1445      */
1446     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1447         address spender = _msgSender();
1448         _spendAllowance(from, spender, amount);
1449         _transfer(from, to, amount);
1450         return true;
1451     }
1452 
1453     /**
1454      * @dev Atomically increases the allowance granted to `spender` by the caller.
1455      *
1456      * This is an alternative to {approve} that can be used as a mitigation for
1457      * problems described in {IERC20-approve}.
1458      *
1459      * Emits an {Approval} event indicating the updated allowance.
1460      *
1461      * Requirements:
1462      *
1463      * - `spender` cannot be the zero address.
1464      */
1465     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1466         address owner = _msgSender();
1467         _approve(owner, spender, allowance(owner, spender) + addedValue);
1468         return true;
1469     }
1470 
1471     /**
1472      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1473      *
1474      * This is an alternative to {approve} that can be used as a mitigation for
1475      * problems described in {IERC20-approve}.
1476      *
1477      * Emits an {Approval} event indicating the updated allowance.
1478      *
1479      * Requirements:
1480      *
1481      * - `spender` cannot be the zero address.
1482      * - `spender` must have allowance for the caller of at least
1483      * `subtractedValue`.
1484      */
1485     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1486         address owner = _msgSender();
1487         uint256 currentAllowance = allowance(owner, spender);
1488         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1489         unchecked {
1490             _approve(owner, spender, currentAllowance - subtractedValue);
1491         }
1492 
1493         return true;
1494     }
1495 
1496     /**
1497      * @dev Moves `amount` of tokens from `from` to `to`.
1498      *
1499      * This internal function is equivalent to {transfer}, and can be used to
1500      * e.g. implement automatic token fees, slashing mechanisms, etc.
1501      *
1502      * Emits a {Transfer} event.
1503      *
1504      * Requirements:
1505      *
1506      * - `from` cannot be the zero address.
1507      * - `to` cannot be the zero address.
1508      * - `from` must have a balance of at least `amount`.
1509      */
1510     function _transfer(address from, address to, uint256 amount) internal virtual {
1511         require(from != address(0), "ERC20: transfer from the zero address");
1512         require(to != address(0), "ERC20: transfer to the zero address");
1513 
1514         _beforeTokenTransfer(from, to, amount);
1515 
1516         uint256 fromBalance = _balances[from];
1517         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1518         unchecked {
1519             _balances[from] = fromBalance - amount;
1520             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1521             // decrementing then incrementing.
1522             _balances[to] += amount;
1523         }
1524 
1525         emit Transfer(from, to, amount);
1526 
1527         _afterTokenTransfer(from, to, amount);
1528     }
1529 
1530     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1531      * the total supply.
1532      *
1533      * Emits a {Transfer} event with `from` set to the zero address.
1534      *
1535      * Requirements:
1536      *
1537      * - `account` cannot be the zero address.
1538      */
1539     function _mint(address account, uint256 amount) internal virtual {
1540         require(account != address(0), "ERC20: mint to the zero address");
1541 
1542         _beforeTokenTransfer(address(0), account, amount);
1543 
1544         _totalSupply += amount;
1545         unchecked {
1546             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1547             _balances[account] += amount;
1548         }
1549         emit Transfer(address(0), account, amount);
1550 
1551         _afterTokenTransfer(address(0), account, amount);
1552     }
1553 
1554     /**
1555      * @dev Destroys `amount` tokens from `account`, reducing the
1556      * total supply.
1557      *
1558      * Emits a {Transfer} event with `to` set to the zero address.
1559      *
1560      * Requirements:
1561      *
1562      * - `account` cannot be the zero address.
1563      * - `account` must have at least `amount` tokens.
1564      */
1565     function _burn(address account, uint256 amount) internal virtual {
1566         require(account != address(0), "ERC20: burn from the zero address");
1567 
1568         _beforeTokenTransfer(account, address(0), amount);
1569 
1570         uint256 accountBalance = _balances[account];
1571         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1572         unchecked {
1573             _balances[account] = accountBalance - amount;
1574             // Overflow not possible: amount <= accountBalance <= totalSupply.
1575             _totalSupply -= amount;
1576         }
1577 
1578         emit Transfer(account, address(0), amount);
1579 
1580         _afterTokenTransfer(account, address(0), amount);
1581     }
1582 
1583     /**
1584      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1585      *
1586      * This internal function is equivalent to `approve`, and can be used to
1587      * e.g. set automatic allowances for certain subsystems, etc.
1588      *
1589      * Emits an {Approval} event.
1590      *
1591      * Requirements:
1592      *
1593      * - `owner` cannot be the zero address.
1594      * - `spender` cannot be the zero address.
1595      */
1596     function _approve(address owner, address spender, uint256 amount) internal virtual {
1597         require(owner != address(0), "ERC20: approve from the zero address");
1598         require(spender != address(0), "ERC20: approve to the zero address");
1599 
1600         _allowances[owner][spender] = amount;
1601         emit Approval(owner, spender, amount);
1602     }
1603 
1604     /**
1605      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1606      *
1607      * Does not update the allowance amount in case of infinite allowance.
1608      * Revert if not enough allowance is available.
1609      *
1610      * Might emit an {Approval} event.
1611      */
1612     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1613         uint256 currentAllowance = allowance(owner, spender);
1614         if (currentAllowance != type(uint256).max) {
1615             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1616             unchecked {
1617                 _approve(owner, spender, currentAllowance - amount);
1618             }
1619         }
1620     }
1621 
1622     /**
1623      * @dev Hook that is called before any transfer of tokens. This includes
1624      * minting and burning.
1625      *
1626      * Calling conditions:
1627      *
1628      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1629      * will be transferred to `to`.
1630      * - when `from` is zero, `amount` tokens will be minted for `to`.
1631      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1632      * - `from` and `to` are never both zero.
1633      *
1634      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1635      */
1636     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1637 
1638     /**
1639      * @dev Hook that is called after any transfer of tokens. This includes
1640      * minting and burning.
1641      *
1642      * Calling conditions:
1643      *
1644      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1645      * has been transferred to `to`.
1646      * - when `from` is zero, `amount` tokens have been minted for `to`.
1647      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1648      * - `from` and `to` are never both zero.
1649      *
1650      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1651      */
1652     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1653 
1654     /**
1655      * @dev This empty reserved space is put in place to allow future versions to add new
1656      * variables without shifting down storage in the inheritance chain.
1657      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1658      */
1659     uint256[45] private __gap;
1660 }
1661 
1662 // File: contracts/ERC1363/ERC1363.sol
1663 
1664 
1665 
1666 pragma solidity ^0.8.0;
1667 
1668 
1669 
1670 
1671 
1672 
1673 
1674 /**
1675  * @title ERC1363
1676  * @author Vittorio Minacori (https://github.com/vittominacori)
1677  * @dev Implementation of an ERC1363 interface
1678  */
1679 abstract contract ERC1363 is IERC1363, ERC165Upgradeable, ERC20Upgradeable {
1680     using AddressUpgradeable for address;
1681 
1682     /**
1683      * @dev See {IERC165-supportsInterface}.
1684      */
1685     function supportsInterface(bytes4 interfaceId)
1686         public
1687         view
1688         virtual
1689         override(ERC165Upgradeable, IERC165Upgradeable)
1690         returns (bool)
1691     {
1692         return interfaceId == type(IERC1363).interfaceId || super.supportsInterface(interfaceId);
1693     }
1694 
1695     /**
1696      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1697      * @param recipient The address to transfer to.
1698      * @param amount The amount to be transferred.
1699      * @return A boolean that indicates if the operation was successful.
1700      */
1701     function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
1702         return transferAndCall(recipient, amount, '');
1703     }
1704 
1705     /**
1706      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1707      * @param recipient The address to transfer to
1708      * @param amount The amount to be transferred
1709      * @param data Additional data with no specified format
1710      * @return A boolean that indicates if the operation was successful.
1711      */
1712     function transferAndCall(
1713         address recipient,
1714         uint256 amount,
1715         bytes memory data
1716     ) public virtual override returns (bool) {
1717         transfer(recipient, amount);
1718         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), 'ERC1363: _checkAndCallTransfer reverts');
1719         return true;
1720     }
1721 
1722     /**
1723      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1724      * @param sender The address which you want to send tokens from
1725      * @param recipient The address which you want to transfer to
1726      * @param amount The amount of tokens to be transferred
1727      * @return A boolean that indicates if the operation was successful.
1728      */
1729     function transferFromAndCall(
1730         address sender,
1731         address recipient,
1732         uint256 amount
1733     ) public virtual override returns (bool) {
1734         return transferFromAndCall(sender, recipient, amount, '');
1735     }
1736 
1737     /**
1738      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1739      * @param sender The address which you want to send tokens from
1740      * @param recipient The address which you want to transfer to
1741      * @param amount The amount of tokens to be transferred
1742      * @param data Additional data with no specified format
1743      * @return A boolean that indicates if the operation was successful.
1744      */
1745     function transferFromAndCall(
1746         address sender,
1747         address recipient,
1748         uint256 amount,
1749         bytes memory data
1750     ) public virtual override returns (bool) {
1751         transferFrom(sender, recipient, amount);
1752         require(_checkAndCallTransfer(sender, recipient, amount, data), 'ERC1363: _checkAndCallTransfer reverts');
1753         return true;
1754     }
1755 
1756     /**
1757      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1758      * @param spender The address allowed to transfer to
1759      * @param amount The amount allowed to be transferred
1760      * @return A boolean that indicates if the operation was successful.
1761      */
1762     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
1763         return approveAndCall(spender, amount, '');
1764     }
1765 
1766     /**
1767      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1768      * @param spender The address allowed to transfer to.
1769      * @param amount The amount allowed to be transferred.
1770      * @param data Additional data with no specified format.
1771      * @return A boolean that indicates if the operation was successful.
1772      */
1773     function approveAndCall(
1774         address spender,
1775         uint256 amount,
1776         bytes memory data
1777     ) public virtual override returns (bool) {
1778         approve(spender, amount);
1779         require(_checkAndCallApprove(spender, amount, data), 'ERC1363: _checkAndCallApprove reverts');
1780         return true;
1781     }
1782 
1783     /**
1784      * @dev Internal function to invoke `onTransferReceived` on a target address
1785      *  The call is not executed if the target address is not a contract
1786      * @param sender address Representing the previous owner of the given token value
1787      * @param recipient address Target address that will receive the tokens
1788      * @param amount uint256 The amount mount of tokens to be transferred
1789      * @param data bytes Optional data to send along with the call
1790      * @return whether the call correctly returned the expected magic value
1791      */
1792     function _checkAndCallTransfer(
1793         address sender,
1794         address recipient,
1795         uint256 amount,
1796         bytes memory data
1797     ) internal virtual returns (bool) {
1798         if (!recipient.isContract()) {
1799             return false;
1800         }
1801         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(_msgSender(), sender, amount, data);
1802         return (retval == IERC1363Receiver(recipient).onTransferReceived.selector);
1803     }
1804 
1805     /**
1806      * @dev Internal function to invoke `onApprovalReceived` on a target address
1807      *  The call is not executed if the target address is not a contract
1808      * @param spender address The address which will spend the funds
1809      * @param amount uint256 The amount of tokens to be spent
1810      * @param data bytes Optional data to send along with the call
1811      * @return whether the call correctly returned the expected magic value
1812      */
1813     function _checkAndCallApprove(
1814         address spender,
1815         uint256 amount,
1816         bytes memory data
1817     ) internal virtual returns (bool) {
1818         if (!spender.isContract()) {
1819             return false;
1820         }
1821         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(_msgSender(), amount, data);
1822         return (retval == IERC1363Spender(spender).onApprovalReceived.selector);
1823     }
1824 }
1825 
1826 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
1827 
1828 
1829 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1830 
1831 pragma solidity ^0.8.0;
1832 
1833 
1834 
1835 /**
1836  * @dev Contract module which provides a basic access control mechanism, where
1837  * there is an account (an owner) that can be granted exclusive access to
1838  * specific functions.
1839  *
1840  * By default, the owner account will be the one that deploys the contract. This
1841  * can later be changed with {transferOwnership}.
1842  *
1843  * This module is used through inheritance. It will make available the modifier
1844  * `onlyOwner`, which can be applied to your functions to restrict their use to
1845  * the owner.
1846  */
1847 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1848     address private _owner;
1849 
1850     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1851 
1852     /**
1853      * @dev Initializes the contract setting the deployer as the initial owner.
1854      */
1855     function __Ownable_init() internal onlyInitializing {
1856         __Ownable_init_unchained();
1857     }
1858 
1859     function __Ownable_init_unchained() internal onlyInitializing {
1860         _transferOwnership(_msgSender());
1861     }
1862 
1863     /**
1864      * @dev Throws if called by any account other than the owner.
1865      */
1866     modifier onlyOwner() {
1867         _checkOwner();
1868         _;
1869     }
1870 
1871     /**
1872      * @dev Returns the address of the current owner.
1873      */
1874     function owner() public view virtual returns (address) {
1875         return _owner;
1876     }
1877 
1878     /**
1879      * @dev Throws if the sender is not the owner.
1880      */
1881     function _checkOwner() internal view virtual {
1882         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1883     }
1884 
1885     /**
1886      * @dev Leaves the contract without owner. It will not be possible to call
1887      * `onlyOwner` functions. Can only be called by the current owner.
1888      *
1889      * NOTE: Renouncing ownership will leave the contract without an owner,
1890      * thereby disabling any functionality that is only available to the owner.
1891      */
1892     function renounceOwnership() public virtual onlyOwner {
1893         _transferOwnership(address(0));
1894     }
1895 
1896     /**
1897      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1898      * Can only be called by the current owner.
1899      */
1900     function transferOwnership(address newOwner) public virtual onlyOwner {
1901         require(newOwner != address(0), "Ownable: new owner is the zero address");
1902         _transferOwnership(newOwner);
1903     }
1904 
1905     /**
1906      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1907      * Internal function without access restriction.
1908      */
1909     function _transferOwnership(address newOwner) internal virtual {
1910         address oldOwner = _owner;
1911         _owner = newOwner;
1912         emit OwnershipTransferred(oldOwner, newOwner);
1913     }
1914 
1915     /**
1916      * @dev This empty reserved space is put in place to allow future versions to add new
1917      * variables without shifting down storage in the inheritance chain.
1918      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1919      */
1920     uint256[49] private __gap;
1921 }
1922 
1923 // File: contracts/abstract/LimitedOwner.sol
1924 
1925 
1926 pragma solidity ^0.8.0;
1927 
1928 
1929 /**
1930  * @title Secondary
1931  * @dev A Secondary contract can only be used by its Limited Owner account (the one that created it / not KARMATokenDeployer)
1932  */
1933 contract LimitedOwner is OwnableUpgradeable {
1934   address private _limitedOwner;
1935   address public karmaCampaignFactory;
1936 
1937   event LimitedOwnerTransferred(
1938     address recipient
1939   );
1940 
1941   /**
1942    * @dev Reverts if called from any account other than the LimitedOwner.
1943    */
1944   modifier onlyLimitedOrOwner() { 
1945     require(msg.sender == _limitedOwner || msg.sender == karmaCampaignFactory || msg.sender == owner());
1946     _;
1947   }
1948 
1949   /**
1950    * @return the address of the Limited Owner.
1951    */
1952   function limitedOwner() public view returns (address) {
1953     return _limitedOwner;
1954   }
1955   
1956   /**
1957    * @dev Transfers contract to a new Limited Owner.
1958    * @param recipient The address of new Limited Owner. 
1959    */
1960   function transferLimitedOwner(address recipient) public onlyLimitedOrOwner {
1961     require(recipient != address(0));
1962     _limitedOwner = recipient;
1963     emit LimitedOwnerTransferred(_limitedOwner);
1964   }
1965 }
1966 // File: contracts/extensions/ERC20TokenRecover.sol
1967 
1968 
1969 
1970 pragma solidity ^0.8.0;
1971 
1972 
1973 
1974 
1975 /**
1976  * @title ERC20TokenRecover
1977  * @author Henk ter Harmsel
1978  * @dev Allows owner to recover any ERC20 or ETH sent into the contract
1979  * based on https://github.com/vittominacori/eth-token-recover by Vittorio Minacori
1980  */
1981 contract ERC20TokenRecover is OwnableUpgradeable {
1982     using SafeERC20Upgradeable for IERC20Upgradeable;
1983 
1984     /**
1985      * @notice function that transfers an token amount from this contract to the owner when accidentally sent
1986      * @param tokenAddress The token contract address
1987      * @param tokenAmount Number of tokens to be sent
1988      */
1989     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
1990         IERC20Upgradeable(tokenAddress).safeTransfer(owner(), tokenAmount);
1991     }
1992 
1993     /**
1994      * @notice function that transfers an eth amount from this contract to the owner when accidentally sent
1995      * @param amount Number of eth to be sent
1996      */
1997     function recoverETH(uint256 amount) public virtual onlyOwner {
1998         (bool sent, ) = owner().call{value: amount}('');
1999         require(sent, 'ERC20TokenRecover: SENDING_ETHER_FAILED');
2000     }
2001 }
2002 
2003 // File: contracts/abstract/BaseToken.sol
2004 
2005 
2006 
2007 pragma solidity ^0.8.0;
2008 
2009 
2010 
2011 
2012 
2013 
2014 
2015 
2016 
2017 
2018 
2019 // import "hardhat/console.sol";
2020 
2021 interface IFactory {
2022 	function createPair(
2023 		address tokenA,
2024 		address tokenB
2025 	) external returns (address pair);
2026 }
2027 
2028 interface IRouter {
2029 	function factory() external pure returns (address);
2030 
2031 	function WETH() external pure returns (address);
2032 
2033 	function addLiquidityETH(
2034 		address token,
2035 		uint amountTokenDesired,
2036 		uint amountTokenMin,
2037 		uint amountETHMin,
2038 		address to,
2039 		uint deadline
2040 	)
2041 		external
2042 		payable
2043 		returns (uint amountToken, uint amountETH, uint liquidity);
2044 
2045 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
2046 		uint amountIn,
2047 		uint amountOutMin,
2048 		address[] calldata path,
2049 		address to,
2050 		uint deadline
2051 	) external;
2052 }
2053 
2054 abstract contract BaseToken is
2055 	Initializable,
2056 	ContextUpgradeable,
2057 	OwnableUpgradeable,
2058 	LimitedOwner,
2059 	IToken,
2060 	ERC20Upgradeable,
2061 	ERC20TokenRecover,
2062 	ERC1363
2063 {
2064 
2065 	address public deployer;
2066 
2067 	address public constant DEAD = address(0xdead);
2068 
2069 	mapping(address => uint256) private _balances;
2070 	mapping(address => bool) public excludedFromFees;
2071 
2072 	IRouter public router;
2073 	address public pair;
2074 
2075 	bool public tradingEnabled;
2076 
2077 	uint256 public maxTxAmount;
2078 	uint256 public maxWalletAmount;
2079 
2080 	IKARMAAntiBot public antibot;
2081 	bool public enableAntiBot;
2082 	address public karmaDeployer;
2083 
2084 	uint8 _decimals;
2085 
2086 	uint256[50] __gap;
2087 
2088 	constructor() {
2089 		deployer = _msgSender();
2090 	}
2091 
2092 	function __BaseToken_init(
2093 		string memory name,
2094 		string memory symbol,
2095 		uint8 decim,
2096 		uint256 supply,
2097 		address limitedOwner
2098 	) public virtual {
2099 		// msg.sender = address(0) when using Clone.
2100 		require(
2101 			deployer == address(0) || _msgSender() == deployer,
2102 			"UNAUTHORIZED"
2103 		);
2104 		require(decim > 3 && decim < 19, "DECIM");
2105 
2106 		deployer = _msgSender();
2107 
2108 		super.__ERC20_init(name, symbol);
2109 		super.__Ownable_init_unchained();
2110 		// super.__ERC20Capped_init_unchained(supply);
2111 		// super.__ERC20Burnable_init_unchained(true);
2112 		_decimals = decim;
2113 
2114 		_mint(_msgSender(), supply);
2115 		transferLimitedOwner(limitedOwner);
2116 		transferOwnership(tx.origin);
2117 	}
2118 
2119 	function decimals()
2120 		public
2121 		view
2122 		virtual
2123 		override(ERC20Upgradeable, IERC20MetadataUpgradeable)
2124 		returns (uint8)
2125 	{
2126 		return _decimals;
2127 	}
2128 
2129 	//== BEP20 owner function ==
2130 	function getOwner() public view override returns (address) {
2131 		return owner();
2132 	}
2133 
2134 	//== Mandatory overrides ==/
2135 	/**
2136 	 * @dev See {IERC165-supportsInterface}.
2137 	 */
2138 	function supportsInterface(
2139 		bytes4 interfaceId
2140 	) public view virtual override(ERC1363) returns (bool) {
2141 		return super.supportsInterface(interfaceId);
2142 	}
2143 
2144 	function _mint(
2145 		address account,
2146 		uint256 amount
2147 	) internal virtual override(ERC20Upgradeable) {
2148 		super._mint(account, amount);
2149 	}
2150 
2151 	function disableAntiBot(
2152 	) external onlyLimitedOrOwner {
2153 		require(enableAntiBot == true, "ALREADY_DISABLED");
2154 		enableAntiBot = false;
2155 	}
2156 
2157 	function updateExcludedFromFees(
2158 		address _address,
2159 		bool state
2160 	) external onlyLimitedOrOwner {
2161 		excludedFromFees[_address] = state;
2162 	}
2163 
2164 	function updateMaxTxAmount(uint256 amount) external onlyLimitedOrOwner {
2165 		require(amount > (totalSupply() / 10000), "maxTxAmount < 0.01%");
2166 		require(
2167 			(amount > maxTxAmount && msg.sender == limitedOwner()) ||
2168 				(msg.sender == karmaDeployer && owner() == karmaDeployer),
2169 			"Only Karma deployer"
2170 		);
2171 		maxTxAmount = amount;
2172 	}
2173 
2174 	function updateMaxWalletAmount(uint256 amount) external onlyLimitedOrOwner {
2175 		require(amount > (totalSupply() / 10000), "maxWalletAmount < 0.01%");
2176 		require(
2177 			(amount > maxWalletAmount && msg.sender == limitedOwner()) ||
2178 				(msg.sender == karmaDeployer && owner() == karmaDeployer),
2179 			"Only Karma deployer"
2180 		);
2181 		maxWalletAmount = amount;
2182 	}
2183 
2184 	function enableTrading() external onlyLimitedOrOwner {
2185 		require(!tradingEnabled, "Trading already active");
2186 
2187 		tradingEnabled = true;
2188 		if (enableAntiBot) {
2189 			antibot.launch(pair, address(router));
2190 		}
2191 	}
2192 
2193 	function disableTrading() external onlyOwner {
2194 		require(
2195 			msg.sender == karmaDeployer && owner() == karmaDeployer,
2196 			"Only karma deployer can disable"
2197 		);
2198 		tradingEnabled = false;
2199 	}
2200 
2201 	function setEnableAntiBot(bool _enable) external onlyOwner {
2202 		enableAntiBot = _enable;
2203 	}
2204 
2205 	// fallbacks
2206 	receive() external payable {}
2207 }
2208 // File: contracts/StandardToken.sol
2209 
2210 //SPDX-License-Identifier: BUSL-1.1
2211 
2212 
2213 pragma solidity ^0.8.0;
2214 pragma abicoder v2;
2215 
2216 contract StandardToken is BaseToken {
2217 	using SafeMathUpgradeable for uint256;
2218 	using AddressUpgradeable for address payable;
2219 
2220 	mapping(address => uint256) private _balances;
2221 
2222 	bool private swapping;
2223 	bool public swapEnabled;
2224 
2225 	uint256 public swapThreshold;
2226 
2227 	address public marketingWallet;
2228 
2229 	uint256 public sellTax = 0;
2230 	uint256 public buyTax = 0;
2231 
2232 	modifier inSwap() {
2233 		if (!swapping) {
2234 			swapping = true;
2235 			_;
2236 			swapping = false;
2237 		}
2238 	}
2239 
2240 	function initialize(
2241 		TokenData calldata tokenData
2242 	) public virtual override initializer {
2243 		__BaseToken_init(
2244 			tokenData.name,
2245 			tokenData.symbol,
2246 			tokenData.decimals,
2247 			tokenData.supply,
2248 			tokenData.limitedOwner
2249 		);
2250 		require(tokenData.maxTx > totalSupply() / 10000, "maxTxAmount < 0.01%");
2251 		require(
2252 			tokenData.maxWallet > totalSupply() / 10000,
2253 			"maxWalletAmount < 0.01%"
2254 		);
2255 
2256 		karmaDeployer = tokenData.karmaDeployer;
2257 		karmaCampaignFactory = tokenData.karmaCampaignFactory;
2258 		excludedFromFees[msg.sender] = true;
2259 		excludedFromFees[karmaDeployer] = true;
2260 		excludedFromFees[DEAD] = true;
2261 		excludedFromFees[tokenData.routerAddress] = true;
2262 		excludedFromFees[tokenData.karmaDeployer] = true;
2263 
2264 		router = IRouter(tokenData.routerAddress);
2265 		pair = IFactory(router.factory()).createPair(
2266 			address(this),
2267 			router.WETH()
2268 		);
2269 
2270 		swapThreshold = tokenData.supply / 100; // 1% by default
2271 		maxTxAmount = tokenData.maxTx;
2272 		maxWalletAmount = tokenData.maxWallet;
2273 
2274 		buyTax = tokenData.buyTax.marketing;
2275 		sellTax = tokenData.sellTax.marketing;
2276 
2277 		marketingWallet = tokenData.marketingWallet;
2278 
2279 		excludedFromFees[address(this)] = true;
2280 		excludedFromFees[marketingWallet] = true;
2281 
2282 		if (tokenData.antiBot != address(0x0) && tokenData.antiBot != DEAD) {
2283 			antibot = IKARMAAntiBot(tokenData.antiBot);
2284 			antibot.setTokenOwner(msg.sender);
2285 			enableAntiBot = true;
2286 		}
2287 	}
2288 
2289 	function _transfer(
2290 		address sender,
2291 		address recipient,
2292 		uint256 amount
2293 	) internal override {
2294 		require(amount > 0, "Transfer amount must be greater than zero");
2295 
2296 		if (
2297 			!excludedFromFees[sender] &&
2298 			!excludedFromFees[recipient] &&
2299 			!swapping
2300 		) {
2301 			require(tradingEnabled, "Trading not active yet");
2302 			require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
2303 			if (recipient != pair) {
2304 				require(
2305 					balanceOf(recipient) + amount <= maxWalletAmount,
2306 					"You are exceeding maxWalletAmount"
2307 				);
2308 			}
2309 		}
2310 
2311 		if (enableAntiBot) {
2312 			antibot.onPreTransferCheck(sender, recipient, amount);
2313 		}
2314 
2315 		uint256 fee;
2316 
2317 		//set fee to zero if fees in contract are handled or exempted
2318 		if (swapping || excludedFromFees[sender] || excludedFromFees[recipient])
2319 			fee = 0;
2320 
2321 			//calculate fee
2322 		else {
2323 			if (recipient == pair) {
2324 				fee = (amount * sellTax) / 1000;
2325 			} else {
2326 				fee = (amount * buyTax) / 1000;
2327 			}
2328 		}
2329 
2330 		//send fees if threshold has been reached
2331 		//don't do this on buys, breaks swap
2332 		if (swapEnabled && !swapping && sender != pair && fee > 0)
2333 			swapForFees();
2334 
2335 		super._transfer(sender, recipient, amount - fee);
2336 		if (fee > 0) super._transfer(sender, address(this), fee);
2337 	}
2338 
2339 	function swapForFees() private inSwap {
2340 		uint256 contractBalance = balanceOf(address(this));
2341 		if (contractBalance >= swapThreshold) {
2342 			swapTokensForETH(contractBalance);
2343 			uint256 marketingAmt = address(this).balance;
2344 			if (marketingAmt > 0) {
2345 				payable(marketingWallet).sendValue(marketingAmt);
2346 			}
2347 		}
2348 	}
2349 
2350 	function swapTokensForETH(uint256 tokenAmount) private {
2351 		address[] memory path = new address[](2);
2352 		path[0] = address(this);
2353 		path[1] = router.WETH();
2354 
2355 		_approve(address(this), address(router), tokenAmount);
2356 
2357 		// make the swap
2358 		router.swapExactTokensForETHSupportingFeeOnTransferTokens(
2359 			tokenAmount,
2360 			0,
2361 			path,
2362 			address(this),
2363 			block.timestamp
2364 		);
2365 	}
2366 
2367 	function setSwapEnabled(bool state) external onlyOwner {
2368 		swapEnabled = state;
2369 	}
2370 
2371 	function setSwapThreshold(uint256 new_amount) external onlyOwner {
2372 		swapThreshold = new_amount;
2373 	}
2374 
2375 	function setTaxes(uint256 _buy, uint256 _sell) external onlyLimitedOrOwner {
2376 		require(_buy <= 150, "Buy > 15%");
2377 		require(_sell <= 150, "Sell > 15%");
2378 		require(
2379 			(_buy < buyTax && msg.sender == limitedOwner()) ||
2380 				(msg.sender == karmaDeployer && owner() == karmaDeployer),
2381 			"Only Karma deployer can increase buy taxes"
2382 		);
2383 		require(
2384 			(_sell < sellTax && msg.sender == limitedOwner()) ||
2385 				(msg.sender == karmaDeployer && owner() == karmaDeployer),
2386 			"Only Karma deployer can increase sell taxes"
2387 		);
2388 		buyTax = _buy;
2389 		sellTax = _sell;
2390 	}
2391 
2392 	function updateMarketingWallet(address newWallet) external onlyOwner {
2393 		marketingWallet = newWallet;
2394 	}
2395 
2396 	function manualSwap(uint256 amount) external onlyOwner {
2397 		swapTokensForETH(amount);
2398 		payable(marketingWallet).sendValue(address(this).balance);
2399 	}
2400 }