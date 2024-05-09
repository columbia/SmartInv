1 /**
2  * SPDX-License-Identifier: UNLICENSED
3  */
4 
5 pragma solidity 0.6.10;
6 
7 pragma experimental ABIEncoderV2;
8 
9 
10 // File: contracts/external/canonical-weth/WETH9.sol
11 
12 // Copyright (C) 2015, 2016, 2017 Dapphub
13 
14 // This program is free software: you can redistribute it and/or modify
15 // it under the terms of the GNU General Public License as published by
16 // the Free Software Foundation, either version 3 of the License, or
17 // (at your option) any later version.
18 
19 // This program is distributed in the hope that it will be useful,
20 // but WITHOUT ANY WARRANTY; without even the implied warranty of
21 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
22 // GNU General Public License for more details.
23 
24 // You should have received a copy of the GNU General Public License
25 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
26 
27 /**
28  * @title WETH contract
29  * @author Opyn Team
30  * @dev A wrapper to use ETH as collateral
31  */
32 contract WETH9 {
33     string public name = "Wrapped Ether";
34     string public symbol = "WETH";
35     uint8 public decimals = 18;
36 
37     /// @notice emits an event when a sender approves WETH
38     event Approval(address indexed src, address indexed guy, uint256 wad);
39     /// @notice emits an event when a sender transfers WETH
40     event Transfer(address indexed src, address indexed dst, uint256 wad);
41     /// @notice emits an event when a sender deposits ETH into this contract
42     event Deposit(address indexed dst, uint256 wad);
43     /// @notice emits an event when a sender withdraws ETH from this contract
44     event Withdrawal(address indexed src, uint256 wad);
45 
46     /// @notice mapping between address and WETH balance
47     mapping(address => uint256) public balanceOf;
48     /// @notice mapping between addresses and allowance amount
49     mapping(address => mapping(address => uint256)) public allowance;
50 
51     /**
52      * @notice fallback function that receives ETH
53      * @dev will get called in a tx with ETH
54      */
55     receive() external payable {
56         deposit();
57     }
58 
59     /**
60      * @notice wrap deposited ETH into WETH
61      */
62     function deposit() public payable {
63         balanceOf[msg.sender] += msg.value;
64         emit Deposit(msg.sender, msg.value);
65     }
66 
67     /**
68      * @notice withdraw ETH from contract
69      * @dev Unwrap from WETH to ETH
70      * @param _wad amount WETH to unwrap and withdraw
71      */
72     function withdraw(uint256 _wad) public {
73         require(balanceOf[msg.sender] >= _wad, "WETH9: insufficient sender balance");
74         balanceOf[msg.sender] -= _wad;
75         msg.sender.transfer(_wad);
76         emit Withdrawal(msg.sender, _wad);
77     }
78 
79     /**
80      * @notice get ETH total supply
81      * @return total supply
82      */
83     function totalSupply() public view returns (uint256) {
84         return address(this).balance;
85     }
86 
87     /**
88      * @notice approve transfer
89      * @param _guy address to approve
90      * @param _wad amount of WETH
91      * @return True if tx succeeds, False if not
92      */
93     function approve(address _guy, uint256 _wad) public returns (bool) {
94         allowance[msg.sender][_guy] = _wad;
95         emit Approval(msg.sender, _guy, _wad);
96         return true;
97     }
98 
99     /**
100      * @notice transfer WETH
101      * @param _dst destination address
102      * @param _wad amount to transfer
103      * @return True if tx succeeds, False if not
104      */
105     function transfer(address _dst, uint256 _wad) public returns (bool) {
106         return transferFrom(msg.sender, _dst, _wad);
107     }
108 
109     /**
110      * @notice transfer from address
111      * @param _src source address
112      * @param _dst destination address
113      * @param _wad amount to transfer
114      * @return True if tx succeeds, False if not
115      */
116     function transferFrom(
117         address _src,
118         address _dst,
119         uint256 _wad
120     ) public returns (bool) {
121         require(balanceOf[_src] >= _wad, "WETH9: insufficient source balance");
122 
123         if (_src != msg.sender && allowance[_src][msg.sender] != uint256(-1)) {
124             require(allowance[_src][msg.sender] >= _wad, "WETH9: invalid allowance");
125             allowance[_src][msg.sender] -= _wad;
126         }
127 
128         balanceOf[_src] -= _wad;
129         balanceOf[_dst] += _wad;
130 
131         emit Transfer(_src, _dst, _wad);
132 
133         return true;
134     }
135 }
136 
137 // File: contracts/packages/oz/ReentrancyGuard.sol
138 
139 
140 /**
141  * @dev Contract module that helps prevent reentrant calls to a function.
142  *
143  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
144  * available, which can be applied to functions to make sure there are no nested
145  * (reentrant) calls to them.
146  *
147  * Note that because there is a single `nonReentrant` guard, functions marked as
148  * `nonReentrant` may not call one another. This can be worked around by making
149  * those functions `private`, and then adding `external` `nonReentrant` entry
150  * points to them.
151  *
152  * TIP: If you would like to learn more about reentrancy and alternative ways
153  * to protect against it, check out our blog post
154  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
155  */
156 contract ReentrancyGuard {
157     // Booleans are more expensive than uint256 or any type that takes up a full
158     // word because each write operation emits an extra SLOAD to first read the
159     // slot's contents, replace the bits taken up by the boolean, and then write
160     // back. This is the compiler's defense against contract upgrades and
161     // pointer aliasing, and it cannot be disabled.
162 
163     // The values being non-zero value makes deployment a bit more expensive,
164     // but in exchange the refund on every call to nonReentrant will be lower in
165     // amount. Since refunds are capped to a percentage of the total
166     // transaction's gas, it is best to keep them low in cases like this one, to
167     // increase the likelihood of the full refund coming into effect.
168     uint256 private constant _NOT_ENTERED = 1;
169     uint256 private constant _ENTERED = 2;
170 
171     uint256 private _status;
172 
173     constructor() internal {
174         _status = _NOT_ENTERED;
175     }
176 
177     /**
178      * @dev Prevents a contract from calling itself, directly or indirectly.
179      * Calling a `nonReentrant` function from another `nonReentrant`
180      * function is not supported. It is possible to prevent this from happening
181      * by making the `nonReentrant` function external, and make it call a
182      * `private` function that does the actual work.
183      */
184     modifier nonReentrant() {
185         // On the first call to nonReentrant, _notEntered will be true
186         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
187 
188         // Any calls to nonReentrant after this point will fail
189         _status = _ENTERED;
190 
191         _;
192 
193         // By storing the original value once again, a refund is triggered (see
194         // https://eips.ethereum.org/EIPS/eip-2200)
195         _status = _NOT_ENTERED;
196     }
197 }
198 
199 // File: contracts/interfaces/ERC20Interface.sol
200 
201 /**
202  * @dev Interface of the ERC20 standard as defined in the EIP.
203  */
204 interface ERC20Interface {
205     /**
206      * @dev Returns the amount of tokens in existence.
207      */
208     function totalSupply() external view returns (uint256);
209 
210     /**
211      * @dev Returns the amount of tokens owned by `account`.
212      */
213     function balanceOf(address account) external view returns (uint256);
214 
215     /**
216      * @dev Moves `amount` tokens from the caller's account to `recipient`.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transfer(address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Returns the remaining number of tokens that `spender` will be
226      * allowed to spend on behalf of `owner` through {transferFrom}. This is
227      * zero by default.
228      *
229      * This value changes when {approve} or {transferFrom} are called.
230      */
231     function allowance(address owner, address spender) external view returns (uint256);
232 
233     /**
234      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * IMPORTANT: Beware that changing an allowance with this method brings the risk
239      * that someone may use both the old and the new allowance by unfortunate
240      * transaction ordering. One possible solution to mitigate this race
241      * condition is to first reduce the spender's allowance to 0 and set the
242      * desired value afterwards:
243      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244      *
245      * Emits an {Approval} event.
246      */
247     function approve(address spender, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Moves `amount` tokens from `sender` to `recipient` using the
251      * allowance mechanism. `amount` is then deducted from the caller's
252      * allowance.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transferFrom(
259         address sender,
260         address recipient,
261         uint256 amount
262     ) external returns (bool);
263 
264     function decimals() external view returns (uint8);
265 
266     /**
267      * @dev Emitted when `value` tokens are moved from one account (`from`) to
268      * another (`to`).
269      *
270      * Note that `value` may be zero.
271      */
272     event Transfer(address indexed from, address indexed to, uint256 value);
273 
274     /**
275      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
276      * a call to {approve}. `value` is the new allowance.
277      */
278     event Approval(address indexed owner, address indexed spender, uint256 value);
279 }
280 
281 // File: contracts/packages/oz/SafeMath.sol
282 
283 
284 /**
285  * @dev Wrappers over Solidity's arithmetic operations with added overflow
286  * checks.
287  *
288  * Arithmetic operations in Solidity wrap on overflow. This can easily result
289  * in bugs, because programmers usually assume that an overflow raises an
290  * error, which is the standard behavior in high level programming languages.
291  * `SafeMath` restores this intuition by reverting the transaction when an
292  * operation overflows.
293  *
294  * Using this library instead of the unchecked operations eliminates an entire
295  * class of bugs, so it's recommended to use it always.
296  */
297 library SafeMath {
298     /**
299      * @dev Returns the addition of two unsigned integers, reverting on
300      * overflow.
301      *
302      * Counterpart to Solidity's `+` operator.
303      *
304      * Requirements:
305      * - Addition cannot overflow.
306      */
307     function add(uint256 a, uint256 b) internal pure returns (uint256) {
308         uint256 c = a + b;
309         require(c >= a, "SafeMath: addition overflow");
310 
311         return c;
312     }
313 
314     /**
315      * @dev Returns the subtraction of two unsigned integers, reverting on
316      * overflow (when the result is negative).
317      *
318      * Counterpart to Solidity's `-` operator.
319      *
320      * Requirements:
321      * - Subtraction cannot overflow.
322      */
323     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
324         return sub(a, b, "SafeMath: subtraction overflow");
325     }
326 
327     /**
328      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
329      * overflow (when the result is negative).
330      *
331      * Counterpart to Solidity's `-` operator.
332      *
333      * Requirements:
334      * - Subtraction cannot overflow.
335      */
336     function sub(
337         uint256 a,
338         uint256 b,
339         string memory errorMessage
340     ) internal pure returns (uint256) {
341         require(b <= a, errorMessage);
342         uint256 c = a - b;
343 
344         return c;
345     }
346 
347     /**
348      * @dev Returns the multiplication of two unsigned integers, reverting on
349      * overflow.
350      *
351      * Counterpart to Solidity's `*` operator.
352      *
353      * Requirements:
354      * - Multiplication cannot overflow.
355      */
356     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
357         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
358         // benefit is lost if 'b' is also tested.
359         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
360         if (a == 0) {
361             return 0;
362         }
363 
364         uint256 c = a * b;
365         require(c / a == b, "SafeMath: multiplication overflow");
366 
367         return c;
368     }
369 
370     /**
371      * @dev Returns the integer division of two unsigned integers. Reverts on
372      * division by zero. The result is rounded towards zero.
373      *
374      * Counterpart to Solidity's `/` operator. Note: this function uses a
375      * `revert` opcode (which leaves remaining gas untouched) while Solidity
376      * uses an invalid opcode to revert (consuming all remaining gas).
377      *
378      * Requirements:
379      * - The divisor cannot be zero.
380      */
381     function div(uint256 a, uint256 b) internal pure returns (uint256) {
382         return div(a, b, "SafeMath: division by zero");
383     }
384 
385     /**
386      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
387      * division by zero. The result is rounded towards zero.
388      *
389      * Counterpart to Solidity's `/` operator. Note: this function uses a
390      * `revert` opcode (which leaves remaining gas untouched) while Solidity
391      * uses an invalid opcode to revert (consuming all remaining gas).
392      *
393      * Requirements:
394      * - The divisor cannot be zero.
395      */
396     function div(
397         uint256 a,
398         uint256 b,
399         string memory errorMessage
400     ) internal pure returns (uint256) {
401         // Solidity only automatically asserts when dividing by 0
402         require(b > 0, errorMessage);
403         uint256 c = a / b;
404         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
405 
406         return c;
407     }
408 
409     /**
410      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
411      * Reverts when dividing by zero.
412      *
413      * Counterpart to Solidity's `%` operator. This function uses a `revert`
414      * opcode (which leaves remaining gas untouched) while Solidity uses an
415      * invalid opcode to revert (consuming all remaining gas).
416      *
417      * Requirements:
418      * - The divisor cannot be zero.
419      */
420     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
421         return mod(a, b, "SafeMath: modulo by zero");
422     }
423 
424     /**
425      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
426      * Reverts with custom message when dividing by zero.
427      *
428      * Counterpart to Solidity's `%` operator. This function uses a `revert`
429      * opcode (which leaves remaining gas untouched) while Solidity uses an
430      * invalid opcode to revert (consuming all remaining gas).
431      *
432      * Requirements:
433      * - The divisor cannot be zero.
434      */
435     function mod(
436         uint256 a,
437         uint256 b,
438         string memory errorMessage
439     ) internal pure returns (uint256) {
440         require(b != 0, errorMessage);
441         return a % b;
442     }
443 }
444 
445 // File: contracts/packages/oz/Address.sol
446 
447 /**
448  * @dev Collection of functions related to the address type
449  */
450 library Address {
451     /**
452      * @dev Returns true if `account` is a contract.
453      *
454      * [IMPORTANT]
455      * ====
456      * It is unsafe to assume that an address for which this function returns
457      * false is an externally-owned account (EOA) and not a contract.
458      *
459      * Among others, `isContract` will return false for the following
460      * types of addresses:
461      *
462      *  - an externally-owned account
463      *  - a contract in construction
464      *  - an address where a contract will be created
465      *  - an address where a contract lived, but was destroyed
466      * ====
467      */
468     function isContract(address account) internal view returns (bool) {
469         // This method relies on extcodesize, which returns 0 for contracts in
470         // construction, since the code is only stored at the end of the
471         // constructor execution.
472 
473         uint256 size;
474         // solhint-disable-next-line no-inline-assembly
475         assembly {
476             size := extcodesize(account)
477         }
478         return size > 0;
479     }
480 
481     /**
482      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
483      * `recipient`, forwarding all available gas and reverting on errors.
484      *
485      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
486      * of certain opcodes, possibly making contracts go over the 2300 gas limit
487      * imposed by `transfer`, making them unable to receive funds via
488      * `transfer`. {sendValue} removes this limitation.
489      *
490      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
491      *
492      * IMPORTANT: because control is transferred to `recipient`, care must be
493      * taken to not create reentrancy vulnerabilities. Consider using
494      * {ReentrancyGuard} or the
495      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
496      */
497     function sendValue(address payable recipient, uint256 amount) internal {
498         require(address(this).balance >= amount, "Address: insufficient balance");
499 
500         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
501         (bool success, ) = recipient.call{value: amount}("");
502         require(success, "Address: unable to send value, recipient may have reverted");
503     }
504 
505     /**
506      * @dev Performs a Solidity function call using a low level `call`. A
507      * plain`call` is an unsafe replacement for a function call: use this
508      * function instead.
509      *
510      * If `target` reverts with a revert reason, it is bubbled up by this
511      * function (like regular Solidity function calls).
512      *
513      * Returns the raw returned data. To convert to the expected return value,
514      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
515      *
516      * Requirements:
517      *
518      * - `target` must be a contract.
519      * - calling `target` with `data` must not revert.
520      *
521      * _Available since v3.1._
522      */
523     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
524         return functionCall(target, data, "Address: low-level call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
529      * `errorMessage` as a fallback revert reason when `target` reverts.
530      *
531      * _Available since v3.1._
532      */
533     function functionCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         return _functionCallWithValue(target, data, 0, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but also transferring `value` wei to `target`.
544      *
545      * Requirements:
546      *
547      * - the calling contract must have an ETH balance of at least `value`.
548      * - the called Solidity function must be `payable`.
549      *
550      * _Available since v3.1._
551      */
552     function functionCallWithValue(
553         address target,
554         bytes memory data,
555         uint256 value
556     ) internal returns (bytes memory) {
557         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
562      * with `errorMessage` as a fallback revert reason when `target` reverts.
563      *
564      * _Available since v3.1._
565      */
566     function functionCallWithValue(
567         address target,
568         bytes memory data,
569         uint256 value,
570         string memory errorMessage
571     ) internal returns (bytes memory) {
572         require(address(this).balance >= value, "Address: insufficient balance for call");
573         return _functionCallWithValue(target, data, value, errorMessage);
574     }
575 
576     function _functionCallWithValue(
577         address target,
578         bytes memory data,
579         uint256 weiValue,
580         string memory errorMessage
581     ) private returns (bytes memory) {
582         require(isContract(target), "Address: call to non-contract");
583 
584         // solhint-disable-next-line avoid-low-level-calls
585         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
586         if (success) {
587             return returndata;
588         } else {
589             // Look for revert reason and bubble it up if present
590             if (returndata.length > 0) {
591                 // The easiest way to bubble the revert reason is using memory via assembly
592 
593                 // solhint-disable-next-line no-inline-assembly
594                 assembly {
595                     let returndata_size := mload(returndata)
596                     revert(add(32, returndata), returndata_size)
597                 }
598             } else {
599                 revert(errorMessage);
600             }
601         }
602     }
603 }
604 
605 // File: contracts/packages/oz/SafeERC20.sol
606 
607 
608 
609 
610 /**
611  * @title SafeERC20
612  * @dev Wrappers around ERC20 operations that throw on failure (when the token
613  * contract returns false). Tokens that return no value (and instead revert or
614  * throw on failure) are also supported, non-reverting calls are assumed to be
615  * successful.
616  * To use this library you can add a `using SafeERC20 for ERC20Interface;` statement to your contract,
617  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
618  */
619 library SafeERC20 {
620     using SafeMath for uint256;
621     using Address for address;
622 
623     function safeTransfer(
624         ERC20Interface token,
625         address to,
626         uint256 value
627     ) internal {
628         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
629     }
630 
631     function safeTransferFrom(
632         ERC20Interface token,
633         address from,
634         address to,
635         uint256 value
636     ) internal {
637         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
638     }
639 
640     /**
641      * @dev Deprecated. This function has issues similar to the ones found in
642      * {ERC20Interface-approve}, and its usage is discouraged.
643      *
644      * Whenever possible, use {safeIncreaseAllowance} and
645      * {safeDecreaseAllowance} instead.
646      */
647     function safeApprove(
648         ERC20Interface token,
649         address spender,
650         uint256 value
651     ) internal {
652         // safeApprove should only be called when setting an initial allowance,
653         // or when resetting it to zero. To increase and decrease it, use
654         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
655         // solhint-disable-next-line max-line-length
656         require(
657             (value == 0) || (token.allowance(address(this), spender) == 0),
658             "SafeERC20: approve from non-zero to non-zero allowance"
659         );
660         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
661     }
662 
663     function safeIncreaseAllowance(
664         ERC20Interface token,
665         address spender,
666         uint256 value
667     ) internal {
668         uint256 newAllowance = token.allowance(address(this), spender).add(value);
669         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
670     }
671 
672     function safeDecreaseAllowance(
673         ERC20Interface token,
674         address spender,
675         uint256 value
676     ) internal {
677         uint256 newAllowance = token.allowance(address(this), spender).sub(
678             value,
679             "SafeERC20: decreased allowance below zero"
680         );
681         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
682     }
683 
684     /**
685      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
686      * on the return value: the return value is optional (but if data is returned, it must not be false).
687      * @param token The token targeted by the call.
688      * @param data The call data (encoded using abi.encode or one of its variants).
689      */
690     function _callOptionalReturn(ERC20Interface token, bytes memory data) private {
691         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
692         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
693         // the target address contains contract code and also asserts for success in the low-level call.
694 
695         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
696         if (returndata.length > 0) {
697             // Return data is optional
698             // solhint-disable-next-line max-line-length
699             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
700         }
701     }
702 }
703 
704 // File: contracts/libs/MarginVault.sol
705 
706 
707 
708 /**
709  * @title MarginVault
710  * @author Opyn Team
711  * @notice A library that provides the Controller with a Vault struct and the functions that manipulate vaults.
712  * Vaults describe discrete position combinations of long options, short options, and collateral assets that a user can have.
713  */
714 library MarginVault {
715     using SafeMath for uint256;
716 
717     // vault is a struct of 6 arrays that describe a position a user has, a user can have multiple vaults.
718     struct Vault {
719         // addresses of oTokens a user has shorted (i.e. written) against this vault
720         address[] shortOtokens;
721         // addresses of oTokens a user has bought and deposited in this vault
722         // user can be long oTokens without opening a vault (e.g. by buying on a DEX)
723         // generally, long oTokens will be 'deposited' in vaults to act as collateral in order to write oTokens against (i.e. in spreads)
724         address[] longOtokens;
725         // addresses of other ERC-20s a user has deposited as collateral in this vault
726         address[] collateralAssets;
727         // quantity of oTokens minted/written for each oToken address in shortOtokens
728         uint256[] shortAmounts;
729         // quantity of oTokens owned and held in the vault for each oToken address in longOtokens
730         uint256[] longAmounts;
731         // quantity of ERC-20 deposited as collateral in the vault for each ERC-20 address in collateralAssets
732         uint256[] collateralAmounts;
733     }
734 
735     /**
736      * @dev increase the short oToken balance in a vault when a new oToken is minted
737      * @param _vault vault to add or increase the short position in
738      * @param _shortOtoken address of the _shortOtoken being minted from the user's vault
739      * @param _amount number of _shortOtoken being minted from the user's vault
740      * @param _index index of _shortOtoken in the user's vault.shortOtokens array
741      */
742     function addShort(
743         Vault storage _vault,
744         address _shortOtoken,
745         uint256 _amount,
746         uint256 _index
747     ) external {
748         require(_amount > 0, "MarginVault: invalid short otoken amount");
749 
750         // valid indexes in any array are between 0 and array.length - 1.
751         // if adding an amount to an preexisting short oToken, check that _index is in the range of 0->length-1
752         if ((_index == _vault.shortOtokens.length) && (_index == _vault.shortAmounts.length)) {
753             _vault.shortOtokens.push(_shortOtoken);
754             _vault.shortAmounts.push(_amount);
755         } else {
756             require(
757                 (_index < _vault.shortOtokens.length) && (_index < _vault.shortAmounts.length),
758                 "MarginVault: invalid short otoken index"
759             );
760             require(
761                 (_vault.shortOtokens[_index] == _shortOtoken) || (_vault.shortOtokens[_index] == address(0)),
762                 "MarginVault: short otoken address mismatch"
763             );
764 
765             _vault.shortAmounts[_index] = _vault.shortAmounts[_index].add(_amount);
766             _vault.shortOtokens[_index] = _shortOtoken;
767         }
768     }
769 
770     /**
771      * @dev decrease the short oToken balance in a vault when an oToken is burned
772      * @param _vault vault to decrease short position in
773      * @param _shortOtoken address of the _shortOtoken being reduced in the user's vault
774      * @param _amount number of _shortOtoken being reduced in the user's vault
775      * @param _index index of _shortOtoken in the user's vault.shortOtokens array
776      */
777     function removeShort(
778         Vault storage _vault,
779         address _shortOtoken,
780         uint256 _amount,
781         uint256 _index
782     ) external {
783         // check that the removed short oToken exists in the vault at the specified index
784         require(_index < _vault.shortOtokens.length, "MarginVault: invalid short otoken index");
785         require(_vault.shortOtokens[_index] == _shortOtoken, "MarginVault: short otoken address mismatch");
786 
787         _vault.shortAmounts[_index] = _vault.shortAmounts[_index].sub(_amount);
788 
789         if (_vault.shortAmounts[_index] == 0) {
790             delete _vault.shortOtokens[_index];
791         }
792     }
793 
794     /**
795      * @dev increase the long oToken balance in a vault when an oToken is deposited
796      * @param _vault vault to add a long position to
797      * @param _longOtoken address of the _longOtoken being added to the user's vault
798      * @param _amount number of _longOtoken the protocol is adding to the user's vault
799      * @param _index index of _longOtoken in the user's vault.longOtokens array
800      */
801     function addLong(
802         Vault storage _vault,
803         address _longOtoken,
804         uint256 _amount,
805         uint256 _index
806     ) external {
807         require(_amount > 0, "MarginVault: invalid long otoken amount");
808 
809         // valid indexes in any array are between 0 and array.length - 1.
810         // if adding an amount to an preexisting short oToken, check that _index is in the range of 0->length-1
811         if ((_index == _vault.longOtokens.length) && (_index == _vault.longAmounts.length)) {
812             _vault.longOtokens.push(_longOtoken);
813             _vault.longAmounts.push(_amount);
814         } else {
815             require(
816                 (_index < _vault.longOtokens.length) && (_index < _vault.longAmounts.length),
817                 "MarginVault: invalid long otoken index"
818             );
819             require(
820                 (_vault.longOtokens[_index] == _longOtoken) || (_vault.longOtokens[_index] == address(0)),
821                 "MarginVault: long otoken address mismatch"
822             );
823 
824             _vault.longAmounts[_index] = _vault.longAmounts[_index].add(_amount);
825             _vault.longOtokens[_index] = _longOtoken;
826         }
827     }
828 
829     /**
830      * @dev decrease the long oToken balance in a vault when an oToken is withdrawn
831      * @param _vault vault to remove a long position from
832      * @param _longOtoken address of the _longOtoken being removed from the user's vault
833      * @param _amount number of _longOtoken the protocol is removing from the user's vault
834      * @param _index index of _longOtoken in the user's vault.longOtokens array
835      */
836     function removeLong(
837         Vault storage _vault,
838         address _longOtoken,
839         uint256 _amount,
840         uint256 _index
841     ) external {
842         // check that the removed long oToken exists in the vault at the specified index
843         require(_index < _vault.longOtokens.length, "MarginVault: invalid long otoken index");
844         require(_vault.longOtokens[_index] == _longOtoken, "MarginVault: long otoken address mismatch");
845 
846         _vault.longAmounts[_index] = _vault.longAmounts[_index].sub(_amount);
847 
848         if (_vault.longAmounts[_index] == 0) {
849             delete _vault.longOtokens[_index];
850         }
851     }
852 
853     /**
854      * @dev increase the collateral balance in a vault
855      * @param _vault vault to add collateral to
856      * @param _collateralAsset address of the _collateralAsset being added to the user's vault
857      * @param _amount number of _collateralAsset being added to the user's vault
858      * @param _index index of _collateralAsset in the user's vault.collateralAssets array
859      */
860     function addCollateral(
861         Vault storage _vault,
862         address _collateralAsset,
863         uint256 _amount,
864         uint256 _index
865     ) external {
866         require(_amount > 0, "MarginVault: invalid collateral amount");
867 
868         // valid indexes in any array are between 0 and array.length - 1.
869         // if adding an amount to an preexisting short oToken, check that _index is in the range of 0->length-1
870         if ((_index == _vault.collateralAssets.length) && (_index == _vault.collateralAmounts.length)) {
871             _vault.collateralAssets.push(_collateralAsset);
872             _vault.collateralAmounts.push(_amount);
873         } else {
874             require(
875                 (_index < _vault.collateralAssets.length) && (_index < _vault.collateralAmounts.length),
876                 "MarginVault: invalid collateral token index"
877             );
878             require(
879                 (_vault.collateralAssets[_index] == _collateralAsset) ||
880                     (_vault.collateralAssets[_index] == address(0)),
881                 "MarginVault: collateral token address mismatch"
882             );
883 
884             _vault.collateralAmounts[_index] = _vault.collateralAmounts[_index].add(_amount);
885             _vault.collateralAssets[_index] = _collateralAsset;
886         }
887     }
888 
889     /**
890      * @dev decrease the collateral balance in a vault
891      * @param _vault vault to remove collateral from
892      * @param _collateralAsset address of the _collateralAsset being removed from the user's vault
893      * @param _amount number of _collateralAsset being removed from the user's vault
894      * @param _index index of _collateralAsset in the user's vault.collateralAssets array
895      */
896     function removeCollateral(
897         Vault storage _vault,
898         address _collateralAsset,
899         uint256 _amount,
900         uint256 _index
901     ) external {
902         // check that the removed collateral exists in the vault at the specified index
903         require(_index < _vault.collateralAssets.length, "MarginVault: invalid collateral asset index");
904         require(_vault.collateralAssets[_index] == _collateralAsset, "MarginVault: collateral token address mismatch");
905 
906         _vault.collateralAmounts[_index] = _vault.collateralAmounts[_index].sub(_amount);
907 
908         if (_vault.collateralAmounts[_index] == 0) {
909             delete _vault.collateralAssets[_index];
910         }
911     }
912 }
913 
914 // File: contracts/libs/Actions.sol
915 
916 
917 /**
918  * @title Actions
919  * @author Opyn Team
920  * @notice A library that provides a ActionArgs struct, sub types of Action structs, and functions to parse ActionArgs into specific Actions.
921  */
922 library Actions {
923     // possible actions that can be performed
924     enum ActionType {
925         OpenVault,
926         MintShortOption,
927         BurnShortOption,
928         DepositLongOption,
929         WithdrawLongOption,
930         DepositCollateral,
931         WithdrawCollateral,
932         SettleVault,
933         Redeem,
934         Call
935     }
936 
937     struct ActionArgs {
938         // type of action that is being performed on the system
939         ActionType actionType;
940         // address of the account owner
941         address owner;
942         // address which we move assets from or to (depending on the action type)
943         address secondAddress;
944         // asset that is to be transfered
945         address asset;
946         // index of the vault that is to be modified (if any)
947         uint256 vaultId;
948         // amount of asset that is to be transfered
949         uint256 amount;
950         // each vault can hold multiple short / long / collateral assets but we are restricting the scope to only 1 of each in this version
951         // in future versions this would be the index of the short / long / collateral asset that needs to be modified
952         uint256 index;
953         // any other data that needs to be passed in for arbitrary function calls
954         bytes data;
955     }
956 
957     struct MintArgs {
958         // address of the account owner
959         address owner;
960         // index of the vault from which the asset will be minted
961         uint256 vaultId;
962         // address to which we transfer the minted oTokens
963         address to;
964         // oToken that is to be minted
965         address otoken;
966         // each vault can hold multiple short / long / collateral assets but we are restricting the scope to only 1 of each in this version
967         // in future versions this would be the index of the short / long / collateral asset that needs to be modified
968         uint256 index;
969         // amount of oTokens that is to be minted
970         uint256 amount;
971     }
972 
973     struct BurnArgs {
974         // address of the account owner
975         address owner;
976         // index of the vault from which the oToken will be burned
977         uint256 vaultId;
978         // address from which we transfer the oTokens
979         address from;
980         // oToken that is to be burned
981         address otoken;
982         // each vault can hold multiple short / long / collateral assets but we are restricting the scope to only 1 of each in this version
983         // in future versions this would be the index of the short / long / collateral asset that needs to be modified
984         uint256 index;
985         // amount of oTokens that is to be burned
986         uint256 amount;
987     }
988 
989     struct OpenVaultArgs {
990         // address of the account owner
991         address owner;
992         // vault id to create
993         uint256 vaultId;
994     }
995 
996     struct DepositArgs {
997         // address of the account owner
998         address owner;
999         // index of the vault to which the asset will be added
1000         uint256 vaultId;
1001         // address from which we transfer the asset
1002         address from;
1003         // asset that is to be deposited
1004         address asset;
1005         // each vault can hold multiple short / long / collateral assets but we are restricting the scope to only 1 of each in this version
1006         // in future versions this would be the index of the short / long / collateral asset that needs to be modified
1007         uint256 index;
1008         // amount of asset that is to be deposited
1009         uint256 amount;
1010     }
1011 
1012     struct RedeemArgs {
1013         // address to which we pay out the oToken proceeds
1014         address receiver;
1015         // oToken that is to be redeemed
1016         address otoken;
1017         // amount of oTokens that is to be redeemed
1018         uint256 amount;
1019     }
1020 
1021     struct WithdrawArgs {
1022         // address of the account owner
1023         address owner;
1024         // index of the vault from which the asset will be withdrawn
1025         uint256 vaultId;
1026         // address to which we transfer the asset
1027         address to;
1028         // asset that is to be withdrawn
1029         address asset;
1030         // each vault can hold multiple short / long / collateral assets but we are restricting the scope to only 1 of each in this version
1031         // in future versions this would be the index of the short / long / collateral asset that needs to be modified
1032         uint256 index;
1033         // amount of asset that is to be withdrawn
1034         uint256 amount;
1035     }
1036 
1037     struct SettleVaultArgs {
1038         // address of the account owner
1039         address owner;
1040         // index of the vault to which is to be settled
1041         uint256 vaultId;
1042         // address to which we transfer the remaining collateral
1043         address to;
1044     }
1045 
1046     struct CallArgs {
1047         // address of the callee contract
1048         address callee;
1049         // data field for external calls
1050         bytes data;
1051     }
1052 
1053     /**
1054      * @notice parses the passed in action arguments to get the arguments for an open vault action
1055      * @param _args general action arguments structure
1056      * @return arguments for a open vault action
1057      */
1058     function _parseOpenVaultArgs(ActionArgs memory _args) internal pure returns (OpenVaultArgs memory) {
1059         require(_args.actionType == ActionType.OpenVault, "Actions: can only parse arguments for open vault actions");
1060         require(_args.owner != address(0), "Actions: cannot open vault for an invalid account");
1061 
1062         return OpenVaultArgs({owner: _args.owner, vaultId: _args.vaultId});
1063     }
1064 
1065     /**
1066      * @notice parses the passed in action arguments to get the arguments for a mint action
1067      * @param _args general action arguments structure
1068      * @return arguments for a mint action
1069      */
1070     function _parseMintArgs(ActionArgs memory _args) internal pure returns (MintArgs memory) {
1071         require(_args.actionType == ActionType.MintShortOption, "Actions: can only parse arguments for mint actions");
1072         require(_args.owner != address(0), "Actions: cannot mint from an invalid account");
1073 
1074         return
1075             MintArgs({
1076                 owner: _args.owner,
1077                 vaultId: _args.vaultId,
1078                 to: _args.secondAddress,
1079                 otoken: _args.asset,
1080                 index: _args.index,
1081                 amount: _args.amount
1082             });
1083     }
1084 
1085     /**
1086      * @notice parses the passed in action arguments to get the arguments for a burn action
1087      * @param _args general action arguments structure
1088      * @return arguments for a burn action
1089      */
1090     function _parseBurnArgs(ActionArgs memory _args) internal pure returns (BurnArgs memory) {
1091         require(_args.actionType == ActionType.BurnShortOption, "Actions: can only parse arguments for burn actions");
1092         require(_args.owner != address(0), "Actions: cannot burn from an invalid account");
1093 
1094         return
1095             BurnArgs({
1096                 owner: _args.owner,
1097                 vaultId: _args.vaultId,
1098                 from: _args.secondAddress,
1099                 otoken: _args.asset,
1100                 index: _args.index,
1101                 amount: _args.amount
1102             });
1103     }
1104 
1105     /**
1106      * @notice parses the passed in action arguments to get the arguments for a deposit action
1107      * @param _args general action arguments structure
1108      * @return arguments for a deposit action
1109      */
1110     function _parseDepositArgs(ActionArgs memory _args) internal pure returns (DepositArgs memory) {
1111         require(
1112             (_args.actionType == ActionType.DepositLongOption) || (_args.actionType == ActionType.DepositCollateral),
1113             "Actions: can only parse arguments for deposit actions"
1114         );
1115         require(_args.owner != address(0), "Actions: cannot deposit to an invalid account");
1116 
1117         return
1118             DepositArgs({
1119                 owner: _args.owner,
1120                 vaultId: _args.vaultId,
1121                 from: _args.secondAddress,
1122                 asset: _args.asset,
1123                 index: _args.index,
1124                 amount: _args.amount
1125             });
1126     }
1127 
1128     /**
1129      * @notice parses the passed in action arguments to get the arguments for a withdraw action
1130      * @param _args general action arguments structure
1131      * @return arguments for a withdraw action
1132      */
1133     function _parseWithdrawArgs(ActionArgs memory _args) internal pure returns (WithdrawArgs memory) {
1134         require(
1135             (_args.actionType == ActionType.WithdrawLongOption) || (_args.actionType == ActionType.WithdrawCollateral),
1136             "Actions: can only parse arguments for withdraw actions"
1137         );
1138         require(_args.owner != address(0), "Actions: cannot withdraw from an invalid account");
1139         require(_args.secondAddress != address(0), "Actions: cannot withdraw to an invalid account");
1140 
1141         return
1142             WithdrawArgs({
1143                 owner: _args.owner,
1144                 vaultId: _args.vaultId,
1145                 to: _args.secondAddress,
1146                 asset: _args.asset,
1147                 index: _args.index,
1148                 amount: _args.amount
1149             });
1150     }
1151 
1152     /**
1153      * @notice parses the passed in action arguments to get the arguments for an redeem action
1154      * @param _args general action arguments structure
1155      * @return arguments for a redeem action
1156      */
1157     function _parseRedeemArgs(ActionArgs memory _args) internal pure returns (RedeemArgs memory) {
1158         require(_args.actionType == ActionType.Redeem, "Actions: can only parse arguments for redeem actions");
1159         require(_args.secondAddress != address(0), "Actions: cannot redeem to an invalid account");
1160 
1161         return RedeemArgs({receiver: _args.secondAddress, otoken: _args.asset, amount: _args.amount});
1162     }
1163 
1164     /**
1165      * @notice parses the passed in action arguments to get the arguments for a settle vault action
1166      * @param _args general action arguments structure
1167      * @return arguments for a settle vault action
1168      */
1169     function _parseSettleVaultArgs(ActionArgs memory _args) internal pure returns (SettleVaultArgs memory) {
1170         require(
1171             _args.actionType == ActionType.SettleVault,
1172             "Actions: can only parse arguments for settle vault actions"
1173         );
1174         require(_args.owner != address(0), "Actions: cannot settle vault for an invalid account");
1175         require(_args.secondAddress != address(0), "Actions: cannot withdraw payout to an invalid account");
1176 
1177         return SettleVaultArgs({owner: _args.owner, vaultId: _args.vaultId, to: _args.secondAddress});
1178     }
1179 
1180     /**
1181      * @notice parses the passed in action arguments to get the arguments for a call action
1182      * @param _args general action arguments structure
1183      * @return arguments for a call action
1184      */
1185     function _parseCallArgs(ActionArgs memory _args) internal pure returns (CallArgs memory) {
1186         require(_args.actionType == ActionType.Call, "Actions: can only parse arguments for call actions");
1187         require(_args.secondAddress != address(0), "Actions: target address cannot be address(0)");
1188 
1189         return CallArgs({callee: _args.secondAddress, data: _args.data});
1190     }
1191 }
1192 
1193 // File: contracts/packages/oz/upgradeability/Initializable.sol
1194 
1195 /**
1196  * @title Initializable
1197  *
1198  * @dev Helper contract to support initializer functions. To use it, replace
1199  * the constructor with a function that has the `initializer` modifier.
1200  * WARNING: Unlike constructors, initializer functions must be manually
1201  * invoked. This applies both to deploying an Initializable contract, as well
1202  * as extending an Initializable contract via inheritance.
1203  * WARNING: When used with inheritance, manual care must be taken to not invoke
1204  * a parent initializer twice, or ensure that all initializers are idempotent,
1205  * because this is not dealt with automatically as with constructors.
1206  */
1207 contract Initializable {
1208     /**
1209      * @dev Indicates that the contract has been initialized.
1210      */
1211     bool private initialized;
1212 
1213     /**
1214      * @dev Indicates that the contract is in the process of being initialized.
1215      */
1216     bool private initializing;
1217 
1218     /**
1219      * @dev Modifier to use in the initializer function of a contract.
1220      */
1221     modifier initializer() {
1222         require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
1223 
1224         bool isTopLevelCall = !initializing;
1225         if (isTopLevelCall) {
1226             initializing = true;
1227             initialized = true;
1228         }
1229 
1230         _;
1231 
1232         if (isTopLevelCall) {
1233             initializing = false;
1234         }
1235     }
1236 
1237     /// @dev Returns true if and only if the function is running in the constructor
1238     function isConstructor() private view returns (bool) {
1239         // extcodesize checks the size of the code stored in an address, and
1240         // address returns the current address. Since the code is still not
1241         // deployed when running a constructor, any checks on its code size will
1242         // yield zero, making it an effective way to detect if a contract is
1243         // under construction or not.
1244         address self = address(this);
1245         uint256 cs;
1246         assembly {
1247             cs := extcodesize(self)
1248         }
1249         return cs == 0;
1250     }
1251 
1252     // Reserved storage space to allow for layout changes in the future.
1253     uint256[50] private ______gap;
1254 }
1255 
1256 // File: contracts/packages/oz/upgradeability/ContextUpgradeSafe.sol
1257 
1258 
1259 /*
1260  * @dev Provides information about the current execution context, including the
1261  * sender of the transaction and its data. While these are generally available
1262  * via msg.sender and msg.data, they should not be accessed in such a direct
1263  * manner, since when dealing with GSN meta-transactions the account sending and
1264  * paying for execution may not be the actual sender (as far as an application
1265  * is concerned).
1266  *
1267  * This contract is only required for intermediate, library-like contracts.
1268  */
1269 contract ContextUpgradeSafe is Initializable {
1270     // Empty internal constructor, to prevent people from mistakenly deploying
1271     // an instance of this contract, which should be used via inheritance.
1272 
1273     function __Context_init() internal initializer {
1274         __Context_init_unchained();
1275     }
1276 
1277     function __Context_init_unchained() internal initializer {}
1278 
1279     function _msgSender() internal virtual view returns (address payable) {
1280         return msg.sender;
1281     }
1282 
1283     function _msgData() internal virtual view returns (bytes memory) {
1284         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1285         return msg.data;
1286     }
1287 
1288     uint256[50] private __gap;
1289 }
1290 
1291 // File: contracts/packages/oz/upgradeability/OwnableUpgradeSafe.sol
1292 
1293 /**
1294  * @dev Contract module which provides a basic access control mechanism, where
1295  * there is an account (an owner) that can be granted exclusive access to
1296  * specific functions.
1297  *
1298  * By default, the owner account will be the one that deploys the contract. This
1299  * can later be changed with {transferOwnership}.
1300  *
1301  * This module is used through inheritance. It will make available the modifier
1302  * `onlyOwner`, which can be applied to your functions to restrict their use to
1303  * the owner.
1304  */
1305 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
1306     address private _owner;
1307 
1308     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1309 
1310     /**
1311      * @dev Initializes the contract setting the deployer as the initial owner.
1312      */
1313 
1314     function __Ownable_init(address _sender) internal initializer {
1315         __Context_init_unchained();
1316         __Ownable_init_unchained(_sender);
1317     }
1318 
1319     function __Ownable_init_unchained(address _sender) internal initializer {
1320         _owner = _sender;
1321         emit OwnershipTransferred(address(0), _sender);
1322     }
1323 
1324     /**
1325      * @dev Returns the address of the current owner.
1326      */
1327     function owner() public view returns (address) {
1328         return _owner;
1329     }
1330 
1331     /**
1332      * @dev Throws if called by any account other than the owner.
1333      */
1334     modifier onlyOwner() {
1335         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1336         _;
1337     }
1338 
1339     /**
1340      * @dev Leaves the contract without owner. It will not be possible to call
1341      * `onlyOwner` functions anymore. Can only be called by the current owner.
1342      *
1343      * NOTE: Renouncing ownership will leave the contract without an owner,
1344      * thereby removing any functionality that is only available to the owner.
1345      */
1346     function renounceOwnership() public virtual onlyOwner {
1347         emit OwnershipTransferred(_owner, address(0));
1348         _owner = address(0);
1349     }
1350 
1351     /**
1352      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1353      * Can only be called by the current owner.
1354      */
1355     function transferOwnership(address newOwner) public virtual onlyOwner {
1356         require(newOwner != address(0), "Ownable: new owner is the zero address");
1357         emit OwnershipTransferred(_owner, newOwner);
1358         _owner = newOwner;
1359     }
1360 
1361     uint256[49] private __gap;
1362 }
1363 
1364 // File: contracts/packages/oz/upgradeability/ReentrancyGuardUpgradeSafe.sol
1365 
1366 
1367 
1368 /**
1369  * @dev Contract module that helps prevent reentrant calls to a function.
1370  *
1371  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1372  * available, which can be applied to functions to make sure there are no nested
1373  * (reentrant) calls to them.
1374  *
1375  * Note that because there is a single `nonReentrant` guard, functions marked as
1376  * `nonReentrant` may not call one another. This can be worked around by making
1377  * those functions `private`, and then adding `external` `nonReentrant` entry
1378  * points to them.
1379  *
1380  * TIP: If you would like to learn more about reentrancy and alternative ways
1381  * to protect against it, check out our blog post
1382  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1383  */
1384 contract ReentrancyGuardUpgradeSafe is Initializable {
1385     bool private _notEntered;
1386 
1387     function __ReentrancyGuard_init() internal initializer {
1388         __ReentrancyGuard_init_unchained();
1389     }
1390 
1391     function __ReentrancyGuard_init_unchained() internal initializer {
1392         // Storing an initial non-zero value makes deployment a bit more
1393         // expensive, but in exchange the refund on every call to nonReentrant
1394         // will be lower in amount. Since refunds are capped to a percetange of
1395         // the total transaction's gas, it is best to keep them low in cases
1396         // like this one, to increase the likelihood of the full refund coming
1397         // into effect.
1398         _notEntered = true;
1399     }
1400 
1401     /**
1402      * @dev Prevents a contract from calling itself, directly or indirectly.
1403      * Calling a `nonReentrant` function from another `nonReentrant`
1404      * function is not supported. It is possible to prevent this from happening
1405      * by making the `nonReentrant` function external, and make it call a
1406      * `private` function that does the actual work.
1407      */
1408     modifier nonReentrant() {
1409         // On the first call to nonReentrant, _notEntered will be true
1410         require(_notEntered, "ReentrancyGuard: reentrant call");
1411 
1412         // Any calls to nonReentrant after this point will fail
1413         _notEntered = false;
1414 
1415         _;
1416 
1417         // By storing the original value once again, a refund is triggered (see
1418         // https://eips.ethereum.org/EIPS/eip-2200)
1419         _notEntered = true;
1420     }
1421 
1422     uint256[49] private __gap;
1423 }
1424 
1425 // File: contracts/interfaces/AddressBookInterface.sol
1426 
1427 
1428 interface AddressBookInterface {
1429     /* Getters */
1430 
1431     function getOtokenImpl() external view returns (address);
1432 
1433     function getOtokenFactory() external view returns (address);
1434 
1435     function getWhitelist() external view returns (address);
1436 
1437     function getController() external view returns (address);
1438 
1439     function getOracle() external view returns (address);
1440 
1441     function getMarginPool() external view returns (address);
1442 
1443     function getMarginCalculator() external view returns (address);
1444 
1445     function getLiquidationManager() external view returns (address);
1446 
1447     function getAddress(bytes32 _id) external view returns (address);
1448 
1449     /* Setters */
1450 
1451     function setOtokenImpl(address _otokenImpl) external;
1452 
1453     function setOtokenFactory(address _factory) external;
1454 
1455     function setOracleImpl(address _otokenImpl) external;
1456 
1457     function setWhitelist(address _whitelist) external;
1458 
1459     function setController(address _controller) external;
1460 
1461     function setMarginPool(address _marginPool) external;
1462 
1463     function setMarginCalculator(address _calculator) external;
1464 
1465     function setLiquidationManager(address _liquidationManager) external;
1466 
1467     function setAddress(bytes32 _id, address _newImpl) external;
1468 }
1469 
1470 // File: contracts/interfaces/OtokenInterface.sol
1471 
1472 
1473 interface OtokenInterface {
1474     function addressBook() external view returns (address);
1475 
1476     function underlyingAsset() external view returns (address);
1477 
1478     function strikeAsset() external view returns (address);
1479 
1480     function collateralAsset() external view returns (address);
1481 
1482     function strikePrice() external view returns (uint256);
1483 
1484     function expiryTimestamp() external view returns (uint256);
1485 
1486     function isPut() external view returns (bool);
1487 
1488     function init(
1489         address _addressBook,
1490         address _underlyingAsset,
1491         address _strikeAsset,
1492         address _collateralAsset,
1493         uint256 _strikePrice,
1494         uint256 _expiry,
1495         bool _isPut
1496     ) external;
1497 
1498     function mintOtoken(address account, uint256 amount) external;
1499 
1500     function burnOtoken(address account, uint256 amount) external;
1501 }
1502 
1503 // File: contracts/interfaces/MarginCalculatorInterface.sol
1504 
1505 
1506 
1507 interface MarginCalculatorInterface {
1508     function addressBook() external view returns (address);
1509 
1510     function getExpiredPayoutRate(address _otoken) external view returns (uint256);
1511 
1512     function getExcessCollateral(MarginVault.Vault calldata _vault)
1513         external
1514         view
1515         returns (uint256 netValue, bool isExcess);
1516 }
1517 
1518 // File: contracts/interfaces/OracleInterface.sol
1519 
1520 
1521 interface OracleInterface {
1522     function isLockingPeriodOver(address _asset, uint256 _expiryTimestamp) external view returns (bool);
1523 
1524     function isDisputePeriodOver(address _asset, uint256 _expiryTimestamp) external view returns (bool);
1525 
1526     function getExpiryPrice(address _asset, uint256 _expiryTimestamp) external view returns (uint256, bool);
1527 
1528     function getDisputer() external view returns (address);
1529 
1530     function getPricer(address _asset) external view returns (address);
1531 
1532     function getPrice(address _asset) external view returns (uint256);
1533 
1534     function getPricerLockingPeriod(address _pricer) external view returns (uint256);
1535 
1536     function getPricerDisputePeriod(address _pricer) external view returns (uint256);
1537 
1538     // Non-view function
1539 
1540     function setAssetPricer(address _asset, address _pricer) external;
1541 
1542     function setLockingPeriod(address _pricer, uint256 _lockingPeriod) external;
1543 
1544     function setDisputePeriod(address _pricer, uint256 _disputePeriod) external;
1545 
1546     function setExpiryPrice(
1547         address _asset,
1548         uint256 _expiryTimestamp,
1549         uint256 _price
1550     ) external;
1551 
1552     function disputeExpiryPrice(
1553         address _asset,
1554         uint256 _expiryTimestamp,
1555         uint256 _price
1556     ) external;
1557 
1558     function setDisputer(address _disputer) external;
1559 }
1560 
1561 // File: contracts/interfaces/WhitelistInterface.sol
1562 
1563 
1564 interface WhitelistInterface {
1565     /* View functions */
1566 
1567     function addressBook() external view returns (address);
1568 
1569     function isWhitelistedProduct(
1570         address _underlying,
1571         address _strike,
1572         address _collateral,
1573         bool _isPut
1574     ) external view returns (bool);
1575 
1576     function isWhitelistedCollateral(address _collateral) external view returns (bool);
1577 
1578     function isWhitelistedOtoken(address _otoken) external view returns (bool);
1579 
1580     function isWhitelistedCallee(address _callee) external view returns (bool);
1581 
1582     /* Admin / factory only functions */
1583     function whitelistProduct(
1584         address _underlying,
1585         address _strike,
1586         address _collateral,
1587         bool _isPut
1588     ) external;
1589 
1590     function blacklistProduct(
1591         address _underlying,
1592         address _strike,
1593         address _collateral,
1594         bool _isPut
1595     ) external;
1596 
1597     function whitelistCollateral(address _collateral) external;
1598 
1599     function blacklistCollateral(address _collateral) external;
1600 
1601     function whitelistOtoken(address _otoken) external;
1602 
1603     function blacklistOtoken(address _otoken) external;
1604 
1605     function whitelistCallee(address _callee) external;
1606 
1607     function blacklistCallee(address _callee) external;
1608 }
1609 
1610 // File: contracts/interfaces/MarginPoolInterface.sol
1611 
1612 
1613 interface MarginPoolInterface {
1614     /* Getters */
1615     function addressBook() external view returns (address);
1616 
1617     function farmer() external view returns (address);
1618 
1619     function getStoredBalance(address _asset) external view returns (uint256);
1620 
1621     /* Admin-only functions */
1622     function setFarmer(address _farmer) external;
1623 
1624     function farm(
1625         address _asset,
1626         address _receiver,
1627         uint256 _amount
1628     ) external;
1629 
1630     /* Controller-only functions */
1631     function transferToPool(
1632         address _asset,
1633         address _user,
1634         uint256 _amount
1635     ) external;
1636 
1637     function transferToUser(
1638         address _asset,
1639         address _user,
1640         uint256 _amount
1641     ) external;
1642 
1643     function batchTransferToPool(
1644         address[] calldata _asset,
1645         address[] calldata _user,
1646         uint256[] calldata _amount
1647     ) external;
1648 
1649     function batchTransferToUser(
1650         address[] calldata _asset,
1651         address[] calldata _user,
1652         uint256[] calldata _amount
1653     ) external;
1654 }
1655 
1656 // File: contracts/interfaces/CalleeInterface.sol
1657 
1658 
1659 /**
1660  * @dev Contract interface that can be called from Controller as a call action.
1661  */
1662 interface CalleeInterface {
1663     /**
1664      * Allows users to send this contract arbitrary data.
1665      * @param _sender The msg.sender to Controller
1666      * @param _data Arbitrary data given by the sender
1667      */
1668     function callFunction(address payable _sender, bytes memory _data) external;
1669 }
1670 
1671 // File: contracts/Controller.sol
1672 
1673 /**
1674 
1675 
1676 
1677 
1678 
1679 
1680 
1681 
1682 
1683 
1684 
1685 
1686 
1687 
1688 /**
1689  * @title Controller
1690  * @author Opyn Team
1691  * @notice Contract that controls the Gamma Protocol and the interaction of all sub contracts
1692  */
1693 contract Controller is Initializable, OwnableUpgradeSafe, ReentrancyGuardUpgradeSafe {
1694     using MarginVault for MarginVault.Vault;
1695     using SafeMath for uint256;
1696 
1697     AddressBookInterface public addressbook;
1698     WhitelistInterface public whitelist;
1699     OracleInterface public oracle;
1700     MarginCalculatorInterface public calculator;
1701     MarginPoolInterface public pool;
1702 
1703     ///@dev scale used in MarginCalculator
1704     uint256 internal constant BASE = 8;
1705 
1706     /// @notice address that has permission to partially pause the system, where system functionality is paused
1707     /// except redeem and settleVault
1708     address public partialPauser;
1709 
1710     /// @notice address that has permission to fully pause the system, where all system functionality is paused
1711     address public fullPauser;
1712 
1713     /// @notice True if all system functionality is paused other than redeem and settle vault
1714     bool public systemPartiallyPaused;
1715 
1716     /// @notice True if all system functionality is paused
1717     bool public systemFullyPaused;
1718 
1719     /// @notice True if a call action can only be executed to a whitelisted callee
1720     bool public callRestricted;
1721 
1722     /// @dev mapping between an owner address and the number of owner address vaults
1723     mapping(address => uint256) internal accountVaultCounter;
1724     /// @dev mapping between an owner address and a specific vault using a vault id
1725     mapping(address => mapping(uint256 => MarginVault.Vault)) internal vaults;
1726     /// @dev mapping between an account owner and their approved or unapproved account operators
1727     mapping(address => mapping(address => bool)) internal operators;
1728 
1729     /// @notice emits an event when an account operator is updated for a specific account owner
1730     event AccountOperatorUpdated(address indexed accountOwner, address indexed operator, bool isSet);
1731     /// @notice emits an event when a new vault is opened
1732     event VaultOpened(address indexed accountOwner, uint256 vaultId);
1733     /// @notice emits an event when a long oToken is deposited into a vault
1734     event LongOtokenDeposited(
1735         address indexed otoken,
1736         address indexed accountOwner,
1737         address indexed from,
1738         uint256 vaultId,
1739         uint256 amount
1740     );
1741     /// @notice emits an event when a long oToken is withdrawn from a vault
1742     event LongOtokenWithdrawed(
1743         address indexed otoken,
1744         address indexed AccountOwner,
1745         address indexed to,
1746         uint256 vaultId,
1747         uint256 amount
1748     );
1749     /// @notice emits an event when a collateral asset is deposited into a vault
1750     event CollateralAssetDeposited(
1751         address indexed asset,
1752         address indexed accountOwner,
1753         address indexed from,
1754         uint256 vaultId,
1755         uint256 amount
1756     );
1757     /// @notice emits an event when a collateral asset is withdrawn from a vault
1758     event CollateralAssetWithdrawed(
1759         address indexed asset,
1760         address indexed AccountOwner,
1761         address indexed to,
1762         uint256 vaultId,
1763         uint256 amount
1764     );
1765     /// @notice emits an event when a short oToken is minted from a vault
1766     event ShortOtokenMinted(
1767         address indexed otoken,
1768         address indexed AccountOwner,
1769         address indexed to,
1770         uint256 vaultId,
1771         uint256 amount
1772     );
1773     /// @notice emits an event when a short oToken is burned
1774     event ShortOtokenBurned(
1775         address indexed otoken,
1776         address indexed AccountOwner,
1777         address indexed from,
1778         uint256 vaultId,
1779         uint256 amount
1780     );
1781     /// @notice emits an event when an oToken is redeemed
1782     event Redeem(
1783         address indexed otoken,
1784         address indexed redeemer,
1785         address indexed receiver,
1786         address collateralAsset,
1787         uint256 otokenBurned,
1788         uint256 payout
1789     );
1790     /// @notice emits an event when a vault is settled
1791     event VaultSettled(
1792         address indexed AccountOwner,
1793         address indexed to,
1794         address indexed otoken,
1795         uint256 vaultId,
1796         uint256 payout
1797     );
1798     /// @notice emits an event when a call action is executed
1799     event CallExecuted(address indexed from, address indexed to, bytes data);
1800     /// @notice emits an event when the fullPauser address changes
1801     event FullPauserUpdated(address indexed oldFullPauser, address indexed newFullPauser);
1802     /// @notice emits an event when the partialPauser address changes
1803     event PartialPauserUpdated(address indexed oldPartialPauser, address indexed newPartialPauser);
1804     /// @notice emits an event when the system partial paused status changes
1805     event SystemPartiallyPaused(bool isPaused);
1806     /// @notice emits an event when the system fully paused status changes
1807     event SystemFullyPaused(bool isPaused);
1808     /// @notice emits an event when the call action restriction changes
1809     event CallRestricted(bool isRestricted);
1810 
1811     /**
1812      * @notice modifier to check if the system is not partially paused, where only redeem and settleVault is allowed
1813      */
1814     modifier notPartiallyPaused {
1815         _isNotPartiallyPaused();
1816 
1817         _;
1818     }
1819 
1820     /**
1821      * @notice modifier to check if the system is not fully paused, where no functionality is allowed
1822      */
1823     modifier notFullyPaused {
1824         _isNotFullyPaused();
1825 
1826         _;
1827     }
1828 
1829     /**
1830      * @notice modifier to check if sender is the fullPauser address
1831      */
1832     modifier onlyFullPauser {
1833         require(msg.sender == fullPauser, "Controller: sender is not fullPauser");
1834 
1835         _;
1836     }
1837 
1838     /**
1839      * @notice modifier to check if the sender is the partialPauser address
1840      */
1841     modifier onlyPartialPauser {
1842         require(msg.sender == partialPauser, "Controller: sender is not partialPauser");
1843 
1844         _;
1845     }
1846 
1847     /**
1848      * @notice modifier to check if the sender is the account owner or an approved account operator
1849      * @param _sender sender address
1850      * @param _accountOwner account owner address
1851      */
1852     modifier onlyAuthorized(address _sender, address _accountOwner) {
1853         _isAuthorized(_sender, _accountOwner);
1854 
1855         _;
1856     }
1857 
1858     /**
1859      * @notice modifier to check if the called address is a whitelisted callee address
1860      * @param _callee called address
1861      */
1862     modifier onlyWhitelistedCallee(address _callee) {
1863         if (callRestricted) {
1864             require(_isCalleeWhitelisted(_callee), "Controller: callee is not a whitelisted address");
1865         }
1866 
1867         _;
1868     }
1869 
1870     /**
1871      * @dev check if the system is not in a partiallyPaused state
1872      */
1873     function _isNotPartiallyPaused() internal view {
1874         require(!systemPartiallyPaused, "Controller: system is partially paused");
1875     }
1876 
1877     /**
1878      * @dev check if the system is not in an fullyPaused state
1879      */
1880     function _isNotFullyPaused() internal view {
1881         require(!systemFullyPaused, "Controller: system is fully paused");
1882     }
1883 
1884     /**
1885      * @dev check if the sender is an authorized operator
1886      * @param _sender msg.sender
1887      * @param _accountOwner owner of a vault
1888      */
1889     function _isAuthorized(address _sender, address _accountOwner) internal view {
1890         require(
1891             (_sender == _accountOwner) || (operators[_accountOwner][_sender]),
1892             "Controller: msg.sender is not authorized to run action"
1893         );
1894     }
1895 
1896     /**
1897      * @notice initalize the deployed contract
1898      * @param _addressBook addressbook module
1899      * @param _owner account owner address
1900      */
1901     function initialize(address _addressBook, address _owner) external initializer {
1902         require(_addressBook != address(0), "Controller: invalid addressbook address");
1903         require(_owner != address(0), "Controller: invalid owner address");
1904 
1905         __Ownable_init(_owner);
1906         __ReentrancyGuard_init_unchained();
1907 
1908         addressbook = AddressBookInterface(_addressBook);
1909         _refreshConfigInternal();
1910     }
1911 
1912     /**
1913      * @notice allows the partialPauser to toggle the systemPartiallyPaused variable and partially pause or partially unpause the system
1914      * @dev can only be called by the partialPauser
1915      * @param _partiallyPaused new boolean value to set systemPartiallyPaused to
1916      */
1917     function setSystemPartiallyPaused(bool _partiallyPaused) external onlyPartialPauser {
1918         require(systemPartiallyPaused != _partiallyPaused, "Controller: invalid input");
1919 
1920         systemPartiallyPaused = _partiallyPaused;
1921 
1922         emit SystemPartiallyPaused(systemPartiallyPaused);
1923     }
1924 
1925     /**
1926      * @notice allows the fullPauser to toggle the systemFullyPaused variable and fully pause or fully unpause the system
1927      * @dev can only be called by the fullPauser
1928      * @param _fullyPaused new boolean value to set systemFullyPaused to
1929      */
1930     function setSystemFullyPaused(bool _fullyPaused) external onlyFullPauser {
1931         require(systemFullyPaused != _fullyPaused, "Controller: invalid input");
1932 
1933         systemFullyPaused = _fullyPaused;
1934 
1935         emit SystemFullyPaused(systemFullyPaused);
1936     }
1937 
1938     /**
1939      * @notice allows the owner to set the fullPauser address
1940      * @dev can only be called by the owner
1941      * @param _fullPauser new fullPauser address
1942      */
1943     function setFullPauser(address _fullPauser) external onlyOwner {
1944         require(_fullPauser != address(0), "Controller: fullPauser cannot be set to address zero");
1945         require(fullPauser != _fullPauser, "Controller: invalid input");
1946 
1947         emit FullPauserUpdated(fullPauser, _fullPauser);
1948 
1949         fullPauser = _fullPauser;
1950     }
1951 
1952     /**
1953      * @notice allows the owner to set the partialPauser address
1954      * @dev can only be called by the owner
1955      * @param _partialPauser new partialPauser address
1956      */
1957     function setPartialPauser(address _partialPauser) external onlyOwner {
1958         require(_partialPauser != address(0), "Controller: partialPauser cannot be set to address zero");
1959         require(partialPauser != _partialPauser, "Controller: invalid input");
1960 
1961         emit PartialPauserUpdated(partialPauser, _partialPauser);
1962 
1963         partialPauser = _partialPauser;
1964     }
1965 
1966     /**
1967      * @notice allows the owner to toggle the restriction on whitelisted call actions and only allow whitelisted
1968      * call addresses or allow any arbitrary call addresses
1969      * @dev can only be called by the owner
1970      * @param _isRestricted new call restriction state
1971      */
1972     function setCallRestriction(bool _isRestricted) external onlyOwner {
1973         require(callRestricted != _isRestricted, "Controller: invalid input");
1974 
1975         callRestricted = _isRestricted;
1976 
1977         emit CallRestricted(callRestricted);
1978     }
1979 
1980     /**
1981      * @notice allows a user to give or revoke privileges to an operator which can act on their behalf on their vaults
1982      * @dev can only be updated by the vault owner
1983      * @param _operator operator that the sender wants to give privileges to or revoke them from
1984      * @param _isOperator new boolean value that expresses if the sender is giving or revoking privileges for _operator
1985      */
1986     function setOperator(address _operator, bool _isOperator) external {
1987         require(operators[msg.sender][_operator] != _isOperator, "Controller: invalid input");
1988 
1989         operators[msg.sender][_operator] = _isOperator;
1990 
1991         emit AccountOperatorUpdated(msg.sender, _operator, _isOperator);
1992     }
1993 
1994     /**
1995      * @dev updates the configuration of the controller. can only be called by the owner
1996      */
1997     function refreshConfiguration() external onlyOwner {
1998         _refreshConfigInternal();
1999     }
2000 
2001     /**
2002      * @notice execute a number of actions on specific vaults
2003      * @dev can only be called when the system is not fully paused
2004      * @param _actions array of actions arguments
2005      */
2006     function operate(Actions.ActionArgs[] memory _actions) external nonReentrant notFullyPaused {
2007         (bool vaultUpdated, address vaultOwner, uint256 vaultId) = _runActions(_actions);
2008         if (vaultUpdated) _verifyFinalState(vaultOwner, vaultId);
2009     }
2010 
2011     /**
2012      * @notice check if a specific address is an operator for an owner account
2013      * @param _owner account owner address
2014      * @param _operator account operator address
2015      * @return True if the _operator is an approved operator for the _owner account
2016      */
2017     function isOperator(address _owner, address _operator) external view returns (bool) {
2018         return operators[_owner][_operator];
2019     }
2020 
2021     /**
2022      * @notice returns the current controller configuration
2023      * @return whitelist, the address of the whitelist module
2024      * @return oracle, the address of the oracle module
2025      * @return calculator, the address of the calculator module
2026      * @return pool, the address of the pool module
2027      */
2028     function getConfiguration()
2029         external
2030         view
2031         returns (
2032             address,
2033             address,
2034             address,
2035             address
2036         )
2037     {
2038         return (address(whitelist), address(oracle), address(calculator), address(pool));
2039     }
2040 
2041     /**
2042      * @notice return a vault's proceeds pre or post expiry, the amount of collateral that can be removed from a vault
2043      * @param _owner account owner of the vault
2044      * @param _vaultId vaultId to return balances for
2045      * @return amount of collateral that can be taken out
2046      */
2047     function getProceed(address _owner, uint256 _vaultId) external view returns (uint256) {
2048         MarginVault.Vault memory vault = getVault(_owner, _vaultId);
2049 
2050         (uint256 netValue, ) = calculator.getExcessCollateral(vault);
2051         return netValue;
2052     }
2053 
2054     /**
2055      * @notice get an oToken's payout/cash value after expiry, in the collateral asset
2056      * @param _otoken oToken address
2057      * @param _amount amount of the oToken to calculate the payout for, always represented in 1e8
2058      * @return amount of collateral to pay out
2059      */
2060     function getPayout(address _otoken, uint256 _amount) public view returns (uint256) {
2061         uint256 rate = calculator.getExpiredPayoutRate(_otoken);
2062         return rate.mul(_amount).div(10**BASE);
2063     }
2064 
2065     /**
2066      * @dev return if an expired oToken contract’s settlement price has been finalized
2067      * @param _otoken address of the oToken
2068      * @return True if the oToken has expired AND all oracle prices at the expiry timestamp have been finalized, False if not
2069      */
2070     function isSettlementAllowed(address _otoken) public view returns (bool) {
2071         OtokenInterface otoken = OtokenInterface(_otoken);
2072 
2073         address underlying = otoken.underlyingAsset();
2074         address strike = otoken.strikeAsset();
2075         address collateral = otoken.collateralAsset();
2076 
2077         uint256 expiry = otoken.expiryTimestamp();
2078 
2079         bool isUnderlyingFinalized = oracle.isDisputePeriodOver(underlying, expiry);
2080         bool isStrikeFinalized = oracle.isDisputePeriodOver(strike, expiry);
2081         bool isCollateralFinalized = oracle.isDisputePeriodOver(collateral, expiry);
2082 
2083         return isUnderlyingFinalized && isStrikeFinalized && isCollateralFinalized;
2084     }
2085 
2086     /**
2087      * @notice get the number of vaults for a specified account owner
2088      * @param _accountOwner account owner address
2089      * @return number of vaults
2090      */
2091     function getAccountVaultCounter(address _accountOwner) external view returns (uint256) {
2092         return accountVaultCounter[_accountOwner];
2093     }
2094 
2095     /**
2096      * @notice check if an oToken has expired
2097      * @param _otoken oToken address
2098      * @return True if the otoken has expired, False if not
2099      */
2100     function hasExpired(address _otoken) external view returns (bool) {
2101         uint256 otokenExpiryTimestamp = OtokenInterface(_otoken).expiryTimestamp();
2102 
2103         return now >= otokenExpiryTimestamp;
2104     }
2105 
2106     /**
2107      * @notice return a specific vault
2108      * @param _owner account owner
2109      * @param _vaultId vault id of vault to return
2110      * @return Vault struct that corresponds to the _vaultId of _owner
2111      */
2112     function getVault(address _owner, uint256 _vaultId) public view returns (MarginVault.Vault memory) {
2113         return vaults[_owner][_vaultId];
2114     }
2115 
2116     /**
2117      * @notice execute a variety of actions
2118      * @dev for each action in the action array, execute the corresponding action, only one vault can be modified
2119      * for all actions except SettleVault, Redeem, and Call
2120      * @param _actions array of type Actions.ActionArgs[], which expresses which actions the user wants to execute
2121      * @return vaultUpdated, indicates if a vault has changed
2122      * @return owner, the vault owner if a vault has changed
2123      * @return vaultId, the vault Id if a vault has changed
2124      */
2125     function _runActions(Actions.ActionArgs[] memory _actions)
2126         internal
2127         returns (
2128             bool,
2129             address,
2130             uint256
2131         )
2132     {
2133         address vaultOwner;
2134         uint256 vaultId;
2135         bool vaultUpdated;
2136 
2137         for (uint256 i = 0; i < _actions.length; i++) {
2138             Actions.ActionArgs memory action = _actions[i];
2139             Actions.ActionType actionType = action.actionType;
2140 
2141             if (
2142                 (actionType != Actions.ActionType.SettleVault) &&
2143                 (actionType != Actions.ActionType.Redeem) &&
2144                 (actionType != Actions.ActionType.Call)
2145             ) {
2146                 // check if this action is manipulating the same vault as all other actions, if a vault has already been updated
2147                 if (vaultUpdated) {
2148                     require(vaultOwner == action.owner, "Controller: can not run actions for different owners");
2149                     require(vaultId == action.vaultId, "Controller: can not run actions on different vaults");
2150                 }
2151                 vaultUpdated = true;
2152                 vaultId = action.vaultId;
2153                 vaultOwner = action.owner;
2154             }
2155 
2156             if (actionType == Actions.ActionType.OpenVault) {
2157                 _openVault(Actions._parseOpenVaultArgs(action));
2158             } else if (actionType == Actions.ActionType.DepositLongOption) {
2159                 _depositLong(Actions._parseDepositArgs(action));
2160             } else if (actionType == Actions.ActionType.WithdrawLongOption) {
2161                 _withdrawLong(Actions._parseWithdrawArgs(action));
2162             } else if (actionType == Actions.ActionType.DepositCollateral) {
2163                 _depositCollateral(Actions._parseDepositArgs(action));
2164             } else if (actionType == Actions.ActionType.WithdrawCollateral) {
2165                 _withdrawCollateral(Actions._parseWithdrawArgs(action));
2166             } else if (actionType == Actions.ActionType.MintShortOption) {
2167                 _mintOtoken(Actions._parseMintArgs(action));
2168             } else if (actionType == Actions.ActionType.BurnShortOption) {
2169                 _burnOtoken(Actions._parseBurnArgs(action));
2170             } else if (actionType == Actions.ActionType.Redeem) {
2171                 _redeem(Actions._parseRedeemArgs(action));
2172             } else if (actionType == Actions.ActionType.SettleVault) {
2173                 _settleVault(Actions._parseSettleVaultArgs(action));
2174             } else if (actionType == Actions.ActionType.Call) {
2175                 _call(Actions._parseCallArgs(action));
2176             }
2177         }
2178 
2179         return (vaultUpdated, vaultOwner, vaultId);
2180     }
2181 
2182     /**
2183      * @notice verify the vault final state after executing all actions
2184      * @param _owner account owner address
2185      * @param _vaultId vault id of the final vault
2186      */
2187     function _verifyFinalState(address _owner, uint256 _vaultId) internal view {
2188         MarginVault.Vault memory _vault = getVault(_owner, _vaultId);
2189         (, bool isValidVault) = calculator.getExcessCollateral(_vault);
2190 
2191         require(isValidVault, "Controller: invalid final vault state");
2192     }
2193 
2194     /**
2195      * @notice open a new vault inside an account
2196      * @dev only the account owner or operator can open a vault, cannot be called when system is partiallyPaused or fullyPaused
2197      * @param _args OpenVaultArgs structure
2198      */
2199     function _openVault(Actions.OpenVaultArgs memory _args)
2200         internal
2201         notPartiallyPaused
2202         onlyAuthorized(msg.sender, _args.owner)
2203     {
2204         accountVaultCounter[_args.owner] = accountVaultCounter[_args.owner].add(1);
2205 
2206         require(
2207             _args.vaultId == accountVaultCounter[_args.owner],
2208             "Controller: can not run actions on inexistent vault"
2209         );
2210 
2211         emit VaultOpened(_args.owner, accountVaultCounter[_args.owner]);
2212     }
2213 
2214     /**
2215      * @notice deposit a long oToken into a vault
2216      * @dev only the account owner or operator can deposit a long oToken, cannot be called when system is partiallyPaused or fullyPaused
2217      * @param _args DepositArgs structure
2218      */
2219     function _depositLong(Actions.DepositArgs memory _args)
2220         internal
2221         notPartiallyPaused
2222         onlyAuthorized(msg.sender, _args.owner)
2223     {
2224         require(_checkVaultId(_args.owner, _args.vaultId), "Controller: invalid vault id");
2225         require(
2226             (_args.from == msg.sender) || (_args.from == _args.owner),
2227             "Controller: cannot deposit long otoken from this address"
2228         );
2229 
2230         require(
2231             whitelist.isWhitelistedOtoken(_args.asset),
2232             "Controller: otoken is not whitelisted to be used as collateral"
2233         );
2234 
2235         OtokenInterface otoken = OtokenInterface(_args.asset);
2236 
2237         require(now < otoken.expiryTimestamp(), "Controller: otoken used as collateral is already expired");
2238 
2239         vaults[_args.owner][_args.vaultId].addLong(_args.asset, _args.amount, _args.index);
2240 
2241         pool.transferToPool(_args.asset, _args.from, _args.amount);
2242 
2243         emit LongOtokenDeposited(_args.asset, _args.owner, _args.from, _args.vaultId, _args.amount);
2244     }
2245 
2246     /**
2247      * @notice withdraw a long oToken from a vault
2248      * @dev only the account owner or operator can withdraw a long oToken, cannot be called when system is partiallyPaused or fullyPaused
2249      * @param _args WithdrawArgs structure
2250      */
2251     function _withdrawLong(Actions.WithdrawArgs memory _args)
2252         internal
2253         notPartiallyPaused
2254         onlyAuthorized(msg.sender, _args.owner)
2255     {
2256         require(_checkVaultId(_args.owner, _args.vaultId), "Controller: invalid vault id");
2257 
2258         OtokenInterface otoken = OtokenInterface(_args.asset);
2259 
2260         require(now < otoken.expiryTimestamp(), "Controller: can not withdraw an expired otoken");
2261 
2262         vaults[_args.owner][_args.vaultId].removeLong(_args.asset, _args.amount, _args.index);
2263 
2264         pool.transferToUser(_args.asset, _args.to, _args.amount);
2265 
2266         emit LongOtokenWithdrawed(_args.asset, _args.owner, _args.to, _args.vaultId, _args.amount);
2267     }
2268 
2269     /**
2270      * @notice deposit a collateral asset into a vault
2271      * @dev only the account owner or operator can deposit collateral, cannot be called when system is partiallyPaused or fullyPaused
2272      * @param _args DepositArgs structure
2273      */
2274     function _depositCollateral(Actions.DepositArgs memory _args)
2275         internal
2276         notPartiallyPaused
2277         onlyAuthorized(msg.sender, _args.owner)
2278     {
2279         require(_checkVaultId(_args.owner, _args.vaultId), "Controller: invalid vault id");
2280         require(
2281             (_args.from == msg.sender) || (_args.from == _args.owner),
2282             "Controller: cannot deposit collateral from this address"
2283         );
2284 
2285         require(
2286             whitelist.isWhitelistedCollateral(_args.asset),
2287             "Controller: asset is not whitelisted to be used as collateral"
2288         );
2289 
2290         vaults[_args.owner][_args.vaultId].addCollateral(_args.asset, _args.amount, _args.index);
2291 
2292         pool.transferToPool(_args.asset, _args.from, _args.amount);
2293 
2294         emit CollateralAssetDeposited(_args.asset, _args.owner, _args.from, _args.vaultId, _args.amount);
2295     }
2296 
2297     /**
2298      * @notice withdraw a collateral asset from a vault
2299      * @dev only the account owner or operator can withdraw collateral, cannot be called when system is partiallyPaused or fullyPaused
2300      * @param _args WithdrawArgs structure
2301      */
2302     function _withdrawCollateral(Actions.WithdrawArgs memory _args)
2303         internal
2304         notPartiallyPaused
2305         onlyAuthorized(msg.sender, _args.owner)
2306     {
2307         require(_checkVaultId(_args.owner, _args.vaultId), "Controller: invalid vault id");
2308 
2309         MarginVault.Vault memory vault = getVault(_args.owner, _args.vaultId);
2310         if (_isNotEmpty(vault.shortOtokens)) {
2311             OtokenInterface otoken = OtokenInterface(vault.shortOtokens[0]);
2312 
2313             require(
2314                 now < otoken.expiryTimestamp(),
2315                 "Controller: can not withdraw collateral from a vault with an expired short otoken"
2316             );
2317         }
2318 
2319         vaults[_args.owner][_args.vaultId].removeCollateral(_args.asset, _args.amount, _args.index);
2320 
2321         pool.transferToUser(_args.asset, _args.to, _args.amount);
2322 
2323         emit CollateralAssetWithdrawed(_args.asset, _args.owner, _args.to, _args.vaultId, _args.amount);
2324     }
2325 
2326     /**
2327      * @notice mint short oTokens from a vault which creates an obligation that is recorded in the vault
2328      * @dev only the account owner or operator can mint an oToken, cannot be called when system is partiallyPaused or fullyPaused
2329      * @param _args MintArgs structure
2330      */
2331     function _mintOtoken(Actions.MintArgs memory _args)
2332         internal
2333         notPartiallyPaused
2334         onlyAuthorized(msg.sender, _args.owner)
2335     {
2336         require(_checkVaultId(_args.owner, _args.vaultId), "Controller: invalid vault id");
2337 
2338         require(whitelist.isWhitelistedOtoken(_args.otoken), "Controller: otoken is not whitelisted to be minted");
2339 
2340         OtokenInterface otoken = OtokenInterface(_args.otoken);
2341 
2342         require(now < otoken.expiryTimestamp(), "Controller: can not mint expired otoken");
2343 
2344         vaults[_args.owner][_args.vaultId].addShort(_args.otoken, _args.amount, _args.index);
2345 
2346         otoken.mintOtoken(_args.to, _args.amount);
2347 
2348         emit ShortOtokenMinted(_args.otoken, _args.owner, _args.to, _args.vaultId, _args.amount);
2349     }
2350 
2351     /**
2352      * @notice burn oTokens to reduce or remove the minted oToken obligation recorded in a vault
2353      * @dev only the account owner or operator can burn an oToken, cannot be called when system is partiallyPaused or fullyPaused
2354      * @param _args MintArgs structure
2355      */
2356     function _burnOtoken(Actions.BurnArgs memory _args)
2357         internal
2358         notPartiallyPaused
2359         onlyAuthorized(msg.sender, _args.owner)
2360     {
2361         require(_checkVaultId(_args.owner, _args.vaultId), "Controller: invalid vault id");
2362         require((_args.from == msg.sender) || (_args.from == _args.owner), "Controller: cannot burn from this address");
2363 
2364         OtokenInterface otoken = OtokenInterface(_args.otoken);
2365 
2366         require(now < otoken.expiryTimestamp(), "Controller: can not burn expired otoken");
2367 
2368         vaults[_args.owner][_args.vaultId].removeShort(_args.otoken, _args.amount, _args.index);
2369 
2370         otoken.burnOtoken(_args.from, _args.amount);
2371 
2372         emit ShortOtokenBurned(_args.otoken, _args.owner, _args.from, _args.vaultId, _args.amount);
2373     }
2374 
2375     /**
2376      * @notice redeem an oToken after expiry, receiving the payout of the oToken in the collateral asset
2377      * @dev cannot be called when system is fullyPaused
2378      * @param _args RedeemArgs structure
2379      */
2380     function _redeem(Actions.RedeemArgs memory _args) internal {
2381         OtokenInterface otoken = OtokenInterface(_args.otoken);
2382 
2383         require(whitelist.isWhitelistedOtoken(_args.otoken), "Controller: otoken is not whitelisted to be redeemed");
2384 
2385         require(now >= otoken.expiryTimestamp(), "Controller: can not redeem un-expired otoken");
2386 
2387         require(isSettlementAllowed(_args.otoken), "Controller: asset prices not finalized yet");
2388 
2389         uint256 payout = getPayout(_args.otoken, _args.amount);
2390 
2391         otoken.burnOtoken(msg.sender, _args.amount);
2392 
2393         pool.transferToUser(otoken.collateralAsset(), _args.receiver, payout);
2394 
2395         emit Redeem(_args.otoken, msg.sender, _args.receiver, otoken.collateralAsset(), _args.amount, payout);
2396     }
2397 
2398     /**
2399      * @notice settle a vault after expiry, removing the net proceeds/collateral after both long and short oToken payouts have settled
2400      * @dev deletes a vault of vaultId after net proceeds/collateral is removed, cannot be called when system is fullyPaused
2401      * @param _args SettleVaultArgs structure
2402      */
2403     function _settleVault(Actions.SettleVaultArgs memory _args) internal onlyAuthorized(msg.sender, _args.owner) {
2404         require(_checkVaultId(_args.owner, _args.vaultId), "Controller: invalid vault id");
2405 
2406         MarginVault.Vault memory vault = getVault(_args.owner, _args.vaultId);
2407         bool hasShort = _isNotEmpty(vault.shortOtokens);
2408         bool hasLong = _isNotEmpty(vault.longOtokens);
2409 
2410         require(hasShort || hasLong, "Controller: Can't settle vault with no otoken");
2411 
2412         OtokenInterface otoken = hasShort
2413             ? OtokenInterface(vault.shortOtokens[0])
2414             : OtokenInterface(vault.longOtokens[0]);
2415 
2416         require(now >= otoken.expiryTimestamp(), "Controller: can not settle vault with un-expired otoken");
2417         require(isSettlementAllowed(address(otoken)), "Controller: asset prices not finalized yet");
2418 
2419         (uint256 payout, ) = calculator.getExcessCollateral(vault);
2420 
2421         if (hasLong) {
2422             OtokenInterface longOtoken = OtokenInterface(vault.longOtokens[0]);
2423 
2424             longOtoken.burnOtoken(address(pool), vault.longAmounts[0]);
2425         }
2426 
2427         delete vaults[_args.owner][_args.vaultId];
2428 
2429         pool.transferToUser(otoken.collateralAsset(), _args.to, payout);
2430 
2431         emit VaultSettled(_args.owner, _args.to, address(otoken), _args.vaultId, payout);
2432     }
2433 
2434     /**
2435      * @notice execute arbitrary calls
2436      * @dev cannot be called when system is partiallyPaused or fullyPaused
2437      * @param _args Call action
2438      */
2439     function _call(Actions.CallArgs memory _args)
2440         internal
2441         notPartiallyPaused
2442         onlyWhitelistedCallee(_args.callee)
2443         returns (uint256)
2444     {
2445         CalleeInterface(_args.callee).callFunction(msg.sender, _args.data);
2446 
2447         emit CallExecuted(msg.sender, _args.callee, _args.data);
2448     }
2449 
2450     /**
2451      * @notice check if a vault id is valid for a given account owner address
2452      * @param _accountOwner account owner address
2453      * @param _vaultId vault id to check
2454      * @return True if the _vaultId is valid, False if not
2455      */
2456     function _checkVaultId(address _accountOwner, uint256 _vaultId) internal view returns (bool) {
2457         return ((_vaultId > 0) && (_vaultId <= accountVaultCounter[_accountOwner]));
2458     }
2459 
2460     function _isNotEmpty(address[] memory _array) internal pure returns (bool) {
2461         return (_array.length > 0) && (_array[0] != address(0));
2462     }
2463 
2464     /**
2465      * @notice return if a callee address is whitelisted or not
2466      * @param _callee callee address
2467      * @return True if callee address is whitelisted, False if not
2468      */
2469     function _isCalleeWhitelisted(address _callee) internal view returns (bool) {
2470         return whitelist.isWhitelistedCallee(_callee);
2471     }
2472 
2473     /**
2474      * @dev updates the internal configuration of the controller
2475      */
2476     function _refreshConfigInternal() internal {
2477         whitelist = WhitelistInterface(addressbook.getWhitelist());
2478         oracle = OracleInterface(addressbook.getOracle());
2479         calculator = MarginCalculatorInterface(addressbook.getMarginCalculator());
2480         pool = MarginPoolInterface(addressbook.getMarginPool());
2481     }
2482 }
2483 
2484 // File: contracts/external/proxies/PayableProxyController.sol
2485 
2486 
2487 
2488 
2489 
2490 
2491 
2492 
2493 
2494 /**
2495  * @title PayableProxyController
2496  * @author Opyn Team
2497  * @dev Contract for wrapping/unwrapping ETH before/after interacting with the Gamma Protocol
2498  */
2499 contract PayableProxyController is ReentrancyGuard {
2500     using SafeERC20 for ERC20Interface;
2501     using Address for address payable;
2502 
2503     WETH9 public weth;
2504     Controller public controller;
2505 
2506     constructor(
2507         address _controller,
2508         address _marginPool,
2509         address payable _weth
2510     ) public {
2511         controller = Controller(_controller);
2512         weth = WETH9(_weth);
2513         ERC20Interface(address(weth)).safeApprove(_marginPool, uint256(-1));
2514     }
2515 
2516     /**
2517      * @notice fallback function which disallows ETH to be sent to this contract without data except when unwrapping WETH
2518      */
2519     fallback() external payable {
2520         require(msg.sender == address(weth), "PayableProxyController: Cannot receive ETH");
2521     }
2522 
2523     /**
2524      * @notice execute a number of actions
2525      * @dev a wrapper for the Controller operate function, to wrap WETH and the beginning and unwrap WETH at the end of the execution
2526      * @param _actions array of actions arguments
2527      * @param _sendEthTo address to send the remaining eth to
2528      */
2529     function operate(Actions.ActionArgs[] memory _actions, address payable _sendEthTo) external payable nonReentrant {
2530         // create WETH from ETH
2531         if (msg.value != 0) {
2532             weth.deposit{value: msg.value}();
2533         }
2534 
2535         // verify sender
2536         for (uint256 i = 0; i < _actions.length; i++) {
2537             Actions.ActionArgs memory action = _actions[i];
2538 
2539             // check that msg.sender is an owner or operator
2540             if (action.owner != address(0)) {
2541                 require(
2542                     (msg.sender == action.owner) || (controller.isOperator(action.owner, msg.sender)),
2543                     "PayableProxyController: cannot execute action "
2544                 );
2545             }
2546 
2547             if (action.actionType == Actions.ActionType.Call) {
2548                 // our PayableProxy could ends up approving amount > total eth received.
2549                 ERC20Interface(address(weth)).safeIncreaseAllowance(action.secondAddress, msg.value);
2550             }
2551         }
2552 
2553         controller.operate(_actions);
2554 
2555         // return all remaining WETH to the sendEthTo address as ETH
2556         uint256 remainingWeth = weth.balanceOf(address(this));
2557         if (remainingWeth != 0) {
2558             require(_sendEthTo != address(0), "PayableProxyController: cannot send ETH to address zero");
2559 
2560             weth.withdraw(remainingWeth);
2561             _sendEthTo.sendValue(remainingWeth);
2562         }
2563     }
2564 }