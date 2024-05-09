1 // File: SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: ERC20.sol
112 
113 pragma solidity ^0.5.10;
114 
115 /// @title ERC20 interface is a subset of the ERC20 specification.
116 /// @notice see https://github.com/ethereum/EIPs/issues/20
117 interface ERC20 {
118     function allowance(address _owner, address _spender) external view returns (uint256);
119     function approve(address _spender, uint256 _value) external returns (bool);
120     function balanceOf(address _who) external view returns (uint256);
121     function totalSupply() external view returns (uint256);
122     function transfer(address _to, uint256 _value) external returns (bool);
123     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
124 }
125 
126 // File: Address.sol
127 
128 pragma solidity ^0.5.0;
129 
130 /**
131  * @dev Collection of functions related to the address type,
132  */
133 library Address {
134     /**
135      * @dev Returns true if `account` is a contract.
136      *
137      * This test is non-exhaustive, and there may be false-negatives: during the
138      * execution of a contract's constructor, its address will be reported as
139      * not containing a contract.
140      *
141      * > It is unsafe to assume that an address for which this function returns
142      * false is an externally-owned account (EOA) and not a contract.
143      */
144     function isContract(address account) internal view returns (bool) {
145         // This method relies in extcodesize, which returns 0 for contracts in
146         // construction, since the code is only stored at the end of the
147         // constructor execution.
148 
149         uint256 size;
150         // solhint-disable-next-line no-inline-assembly
151         assembly { size := extcodesize(account) }
152         return size > 0;
153     }
154 }
155 
156 // File: SafeERC20.sol
157 
158 /**
159  * The MIT License (MIT)
160  *
161  * Copyright (c) 2016-2019 zOS Global Limited
162  *
163  * Permission is hereby granted, free of charge, to any person obtaining
164  * a copy of this software and associated documentation files (the
165  * "Software"), to deal in the Software without restriction, including
166  * without limitation the rights to use, copy, modify, merge, publish,
167  * distribute, sublicense, and/or sell copies of the Software, and to
168  * permit persons to whom the Software is furnished to do so, subject to
169  * the following conditions:
170  *
171  * The above copyright notice and this permission notice shall be included
172  * in all copies or substantial portions of the Software.
173  *
174  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
175  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
176  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
177  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
178  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
179  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
180  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
181  */
182 
183 pragma solidity ^0.5.0;
184 
185 
186 
187 
188 /**
189  * @title SafeERC20
190  * @dev Wrappers around ERC20 operations that throw on failure (when the token
191  * contract returns false). Tokens that return no value (and instead revert or
192  * throw on failure) are also supported, non-reverting calls are assumed to be
193  * successful.
194  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
195  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
196  */
197 library SafeERC20 {
198     using SafeMath for uint256;
199     using Address for address;
200 
201     function safeTransfer(ERC20 token, address to, uint256 value) internal {
202         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
203     }
204 
205     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
206         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
207     }
208 
209     function safeApprove(ERC20 token, address spender, uint256 value) internal {
210         // safeApprove should only be called when setting an initial allowance,
211         // or when resetting it to zero. To increase and decrease it, use
212         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
213         // solhint-disable-next-line max-line-length
214         require((value == 0) || (token.allowance(address(this), spender) == 0),
215             "SafeERC20: approve from non-zero to non-zero allowance"
216         );
217         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
218     }
219 
220     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
221         uint256 newAllowance = token.allowance(address(this), spender).add(value);
222         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
223     }
224 
225     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
226         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
227         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
228     }
229 
230     /**
231      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
232      * on the return value: the return value is optional (but if data is returned, it must not be false).
233      * @param token The token targeted by the call.
234      * @param data The call data (encoded using abi.encode or one of its variants).
235      */
236     function callOptionalReturn(ERC20 token, bytes memory data) internal {
237         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
238         // we're implementing it ourselves.
239 
240         // A Solidity high level call has three parts:
241         //  1. The target address is checked to verify it contains contract code
242         //  2. The call itself is made, and success asserted
243         //  3. The return value is decoded, which in turn checks the size of the returned data.
244         // solhint-disable-next-line max-line-length
245         require(address(token).isContract(), "SafeERC20: call to non-contract");
246 
247         // solhint-disable-next-line avoid-low-level-calls
248         (bool success, bytes memory returndata) = address(token).call(data);
249         require(success, "SafeERC20: low-level call failed");
250 
251         if (returndata.length > 0) { // Return data is optional
252             // solhint-disable-next-line max-line-length
253             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
254         }
255     }
256 }
257 
258 // File: ownable.sol
259 
260 /**
261  *  Ownable - The Consumer Contract Wallet
262  *  Copyright (C) 2019 The Contract Wallet Company Limited
263  *
264  *  This program is free software: you can redistribute it and/or modify
265  *  it under the terms of the GNU General Public License as published by
266  *  the Free Software Foundation, either version 3 of the License, or
267  *  (at your option) any later version.
268 
269  *  This program is distributed in the hope that it will be useful,
270  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
271  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
272  *  GNU General Public License for more details.
273 
274  *  You should have received a copy of the GNU General Public License
275  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
276  */
277 
278 pragma solidity ^0.5.10;
279 
280 
281 /// @title Ownable has an owner address and provides basic authorization control functions.
282 /// This contract is modified version of the MIT OpenZepplin Ownable contract
283 /// This contract allows for the transferOwnership operation to be made impossible
284 /// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
285 contract Ownable {
286     event TransferredOwnership(address _from, address _to);
287     event LockedOwnership(address _locked);
288 
289     address payable private _owner;
290     bool private _isTransferable;
291 
292     /// @notice Constructor sets the original owner of the contract and whether or not it is one time transferable.
293     constructor(address payable _account_, bool _transferable_) internal {
294         _owner = _account_;
295         _isTransferable = _transferable_;
296         // Emit the LockedOwnership event if no longer transferable.
297         if (!_isTransferable) {
298             emit LockedOwnership(_account_);
299         }
300         emit TransferredOwnership(address(0), _account_);
301     }
302 
303     /// @notice Reverts if called by any account other than the owner.
304     modifier onlyOwner() {
305         require(_isOwner(msg.sender), "sender is not an owner");
306         _;
307     }
308 
309     /// @notice Allows the current owner to transfer control of the contract to a new address.
310     /// @param _account address to transfer ownership to.
311     /// @param _transferable indicates whether to keep the ownership transferable.
312     function transferOwnership(address payable _account, bool _transferable) external onlyOwner {
313         // Require that the ownership is transferable.
314         require(_isTransferable, "ownership is not transferable");
315         // Require that the new owner is not the zero address.
316         require(_account != address(0), "owner cannot be set to zero address");
317         // Set the transferable flag to the value _transferable passed in.
318         _isTransferable = _transferable;
319         // Emit the LockedOwnership event if no longer transferable.
320         if (!_transferable) {
321             emit LockedOwnership(_account);
322         }
323         // Emit the ownership transfer event.
324         emit TransferredOwnership(_owner, _account);
325         // Set the owner to the provided address.
326         _owner = _account;
327     }
328 
329     /// @notice check if the ownership is transferable.
330     /// @return true if the ownership is transferable.
331     function isTransferable() external view returns (bool) {
332         return _isTransferable;
333     }
334 
335     /// @notice Allows the current owner to relinquish control of the contract.
336     /// @dev Renouncing to ownership will leave the contract without an owner and unusable.
337     /// @dev It will not be possible to call the functions with the `onlyOwner` modifier anymore.
338     function renounceOwnership() external onlyOwner {
339         // Require that the ownership is transferable.
340         require(_isTransferable, "ownership is not transferable");
341         // note that this could be terminal
342         _owner = address(0);
343 
344         emit TransferredOwnership(_owner, address(0));
345     }
346 
347     /// @notice Find out owner address
348     /// @return address of the owner.
349     function owner() public view returns (address payable) {
350         return _owner;
351     }
352 
353     /// @notice Check if owner address
354     /// @return true if sender is the owner of the contract.
355     function _isOwner(address _address) internal view returns (bool) {
356         return _address == _owner;
357     }
358 }
359 
360 // File: transferrable.sol
361 
362 /**
363  *  Transferrable - The Consumer Contract Wallet
364  *  Copyright (C) 2019 The Contract Wallet Company Limited
365  *
366  *  This program is free software: you can redistribute it and/or modify
367  *  it under the terms of the GNU General Public License as published by
368  *  the Free Software Foundation, either version 3 of the License, or
369  *  (at your option) any later version.
370 
371  *  This program is distributed in the hope that it will be useful,
372  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
373  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
374  *  GNU General Public License for more details.
375 
376  *  You should have received a copy of the GNU General Public License
377  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
378  */
379 
380 pragma solidity ^0.5.10;
381 
382 
383 
384 
385 /// @title SafeTransfer, allowing contract to withdraw tokens accidentally sent to itself
386 contract Transferrable {
387 
388     using SafeERC20 for ERC20;
389 
390 
391     /// @dev This function is used to move tokens sent accidentally to this contract method.
392     /// @dev The owner can chose the new destination address
393     /// @param _to is the recipient's address.
394     /// @param _asset is the address of an ERC20 token or 0x0 for ether.
395     /// @param _amount is the amount to be transferred in base units.
396     function _safeTransfer(address payable _to, address _asset, uint _amount) internal {
397         // address(0) is used to denote ETH
398         if (_asset == address(0)) {
399             _to.transfer(_amount);
400         } else {
401             ERC20(_asset).safeTransfer(_to, _amount);
402         }
403     }
404 }
405 
406 // File: controller.sol
407 
408 /**
409  *  Controller - The Consumer Contract Wallet
410  *  Copyright (C) 2019 The Contract Wallet Company Limited
411  *
412  *  This program is free software: you can redistribute it and/or modify
413  *  it under the terms of the GNU General Public License as published by
414  *  the Free Software Foundation, either version 3 of the License, or
415  *  (at your option) any later version.
416 
417  *  This program is distributed in the hope that it will be useful,
418  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
419  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
420  *  GNU General Public License for more details.
421 
422  *  You should have received a copy of the GNU General Public License
423  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
424  */
425 
426 pragma solidity ^0.5.10;
427 
428 
429 
430 /// @title The IController interface provides access to the isController and isAdmin checks.
431 interface IController {
432     function isController(address) external view returns (bool);
433     function isAdmin(address) external view returns (bool);
434 }
435 
436 
437 /// @title Controller stores a list of controller addresses that can be used for authentication in other contracts.
438 /// @notice The Controller implements a hierarchy of concepts, Owner, Admin, and the Controllers.
439 /// @dev Owner can change the Admins
440 /// @dev Admins and can the Controllers
441 /// @dev Controllers are used by the application.
442 contract Controller is IController, Ownable, Transferrable {
443 
444     event AddedController(address _sender, address _controller);
445     event RemovedController(address _sender, address _controller);
446 
447     event AddedAdmin(address _sender, address _admin);
448     event RemovedAdmin(address _sender, address _admin);
449 
450     event Claimed(address _to, address _asset, uint _amount);
451 
452     event Stopped(address _sender);
453     event Started(address _sender);
454 
455     mapping (address => bool) private _isAdmin;
456     uint private _adminCount;
457 
458     mapping (address => bool) private _isController;
459     uint private _controllerCount;
460 
461     bool private _stopped;
462 
463     /// @notice Constructor initializes the owner with the provided address.
464     /// @param _ownerAddress_ address of the owner.
465     constructor(address payable _ownerAddress_) Ownable(_ownerAddress_, false) public {}
466 
467     /// @notice Checks if message sender is an admin.
468     modifier onlyAdmin() {
469         require(isAdmin(msg.sender), "sender is not an admin");
470         _;
471     }
472 
473     /// @notice Check if Owner or Admin
474     modifier onlyAdminOrOwner() {
475         require(_isOwner(msg.sender) || isAdmin(msg.sender), "sender is not an admin");
476         _;
477     }
478 
479     /// @notice Check if controller is stopped
480     modifier notStopped() {
481         require(!isStopped(), "controller is stopped");
482         _;
483     }
484 
485     /// @notice Add a new admin to the list of admins.
486     /// @param _account address to add to the list of admins.
487     function addAdmin(address _account) external onlyOwner notStopped {
488         _addAdmin(_account);
489     }
490 
491     /// @notice Remove a admin from the list of admins.
492     /// @param _account address to remove from the list of admins.
493     function removeAdmin(address _account) external onlyOwner {
494         _removeAdmin(_account);
495     }
496 
497     /// @return the current number of admins.
498     function adminCount() external view returns (uint) {
499         return _adminCount;
500     }
501 
502     /// @notice Add a new controller to the list of controllers.
503     /// @param _account address to add to the list of controllers.
504     function addController(address _account) external onlyAdminOrOwner notStopped {
505         _addController(_account);
506     }
507 
508     /// @notice Remove a controller from the list of controllers.
509     /// @param _account address to remove from the list of controllers.
510     function removeController(address _account) external onlyAdminOrOwner {
511         _removeController(_account);
512     }
513 
514     /// @notice count the Controllers
515     /// @return the current number of controllers.
516     function controllerCount() external view returns (uint) {
517         return _controllerCount;
518     }
519 
520     /// @notice is an address an Admin?
521     /// @return true if the provided account is an admin.
522     function isAdmin(address _account) public view notStopped returns (bool) {
523         return _isAdmin[_account];
524     }
525 
526     /// @notice is an address a Controller?
527     /// @return true if the provided account is a controller.
528     function isController(address _account) public view notStopped returns (bool) {
529         return _isController[_account];
530     }
531 
532     /// @notice this function can be used to see if the controller has been stopped
533     /// @return true is the Controller has been stopped
534     function isStopped() public view returns (bool) {
535         return _stopped;
536     }
537 
538     /// @notice Internal-only function that adds a new admin.
539     function _addAdmin(address _account) private {
540         require(!_isAdmin[_account], "provided account is already an admin");
541         require(!_isController[_account], "provided account is already a controller");
542         require(!_isOwner(_account), "provided account is already the owner");
543         require(_account != address(0), "provided account is the zero address");
544         _isAdmin[_account] = true;
545         _adminCount++;
546         emit AddedAdmin(msg.sender, _account);
547     }
548 
549     /// @notice Internal-only function that removes an existing admin.
550     function _removeAdmin(address _account) private {
551         require(_isAdmin[_account], "provided account is not an admin");
552         _isAdmin[_account] = false;
553         _adminCount--;
554         emit RemovedAdmin(msg.sender, _account);
555     }
556 
557     /// @notice Internal-only function that adds a new controller.
558     function _addController(address _account) private {
559         require(!_isAdmin[_account], "provided account is already an admin");
560         require(!_isController[_account], "provided account is already a controller");
561         require(!_isOwner(_account), "provided account is already the owner");
562         require(_account != address(0), "provided account is the zero address");
563         _isController[_account] = true;
564         _controllerCount++;
565         emit AddedController(msg.sender, _account);
566     }
567 
568     /// @notice Internal-only function that removes an existing controller.
569     function _removeController(address _account) private {
570         require(_isController[_account], "provided account is not a controller");
571         _isController[_account] = false;
572         _controllerCount--;
573         emit RemovedController(msg.sender, _account);
574     }
575 
576     /// @notice stop our controllers and admins from being useable
577     function stop() external onlyAdminOrOwner {
578         _stopped = true;
579         emit Stopped(msg.sender);
580     }
581 
582     /// @notice start our controller again
583     function start() external onlyOwner {
584         _stopped = false;
585         emit Started(msg.sender);
586     }
587 
588     //// @notice Withdraw tokens from the smart contract to the specified account.
589     function claim(address payable _to, address _asset, uint _amount) external onlyAdmin notStopped {
590         _safeTransfer(_to, _asset, _amount);
591         emit Claimed(_to, _asset, _amount);
592     }
593 }
594 
595 // File: ENS.sol
596 
597 /**
598  * BSD 2-Clause License
599  *
600  * Copyright (c) 2018, True Names Limited
601  * All rights reserved.
602  *
603  * Redistribution and use in source and binary forms, with or without
604  * modification, are permitted provided that the following conditions are met:
605  *
606  * * Redistributions of source code must retain the above copyright notice, this
607  *   list of conditions and the following disclaimer.
608  *
609  * * Redistributions in binary form must reproduce the above copyright notice,
610  *   this list of conditions and the following disclaimer in the documentation
611  *   and/or other materials provided with the distribution.
612  *
613  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
614  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
615  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
616  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
617  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
618  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
619  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
620  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
621  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
622  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
623 */
624 pragma solidity ^0.5.0;
625 
626 interface ENS {
627 
628     // Logged when the owner of a node assigns a new owner to a subnode.
629     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
630 
631     // Logged when the owner of a node transfers ownership to a new account.
632     event Transfer(bytes32 indexed node, address owner);
633 
634     // Logged when the resolver for a node changes.
635     event NewResolver(bytes32 indexed node, address resolver);
636 
637     // Logged when the TTL of a node changes
638     event NewTTL(bytes32 indexed node, uint64 ttl);
639 
640 
641     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
642     function setResolver(bytes32 node, address resolver) external;
643     function setOwner(bytes32 node, address owner) external;
644     function setTTL(bytes32 node, uint64 ttl) external;
645     function owner(bytes32 node) external view returns (address);
646     function resolver(bytes32 node) external view returns (address);
647     function ttl(bytes32 node) external view returns (uint64);
648 
649 }
650 
651 // File: ResolverBase.sol
652 
653 pragma solidity ^0.5.0;
654 
655 contract ResolverBase {
656     bytes4 private constant INTERFACE_META_ID = 0x01ffc9a7;
657 
658     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
659         return interfaceID == INTERFACE_META_ID;
660     }
661 
662     function isAuthorised(bytes32 node) internal view returns(bool);
663 
664     modifier authorised(bytes32 node) {
665         require(isAuthorised(node));
666         _;
667     }
668 }
669 
670 // File: ABIResolver.sol
671 
672 pragma solidity ^0.5.0;
673 
674 
675 contract ABIResolver is ResolverBase {
676     bytes4 constant private ABI_INTERFACE_ID = 0x2203ab56;
677 
678     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
679 
680     mapping(bytes32=>mapping(uint256=>bytes)) abis;
681 
682     /**
683      * Sets the ABI associated with an ENS node.
684      * Nodes may have one ABI of each content type. To remove an ABI, set it to
685      * the empty string.
686      * @param node The node to update.
687      * @param contentType The content type of the ABI
688      * @param data The ABI data.
689      */
690     function setABI(bytes32 node, uint256 contentType, bytes calldata data) external authorised(node) {
691         // Content types must be powers of 2
692         require(((contentType - 1) & contentType) == 0);
693 
694         abis[node][contentType] = data;
695         emit ABIChanged(node, contentType);
696     }
697 
698     /**
699      * Returns the ABI associated with an ENS node.
700      * Defined in EIP205.
701      * @param node The ENS node to query
702      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
703      * @return contentType The content type of the return value
704      * @return data The ABI data
705      */
706     function ABI(bytes32 node, uint256 contentTypes) external view returns (uint256, bytes memory) {
707         mapping(uint256=>bytes) storage abiset = abis[node];
708 
709         for (uint256 contentType = 1; contentType <= contentTypes; contentType <<= 1) {
710             if ((contentType & contentTypes) != 0 && abiset[contentType].length > 0) {
711                 return (contentType, abiset[contentType]);
712             }
713         }
714 
715         return (0, bytes(""));
716     }
717 
718     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
719         return interfaceID == ABI_INTERFACE_ID || super.supportsInterface(interfaceID);
720     }
721 }
722 
723 // File: AddrResolver.sol
724 
725 pragma solidity ^0.5.0;
726 
727 
728 contract AddrResolver is ResolverBase {
729     bytes4 constant private ADDR_INTERFACE_ID = 0x3b3b57de;
730 
731     event AddrChanged(bytes32 indexed node, address a);
732 
733     mapping(bytes32=>address) addresses;
734 
735     /**
736      * Sets the address associated with an ENS node.
737      * May only be called by the owner of that node in the ENS registry.
738      * @param node The node to update.
739      * @param addr The address to set.
740      */
741     function setAddr(bytes32 node, address addr) external authorised(node) {
742         addresses[node] = addr;
743         emit AddrChanged(node, addr);
744     }
745 
746     /**
747      * Returns the address associated with an ENS node.
748      * @param node The ENS node to query.
749      * @return The associated address.
750      */
751     function addr(bytes32 node) public view returns (address) {
752         return addresses[node];
753     }
754 
755     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
756         return interfaceID == ADDR_INTERFACE_ID || super.supportsInterface(interfaceID);
757     }
758 }
759 
760 // File: ContentHashResolver.sol
761 
762 pragma solidity ^0.5.0;
763 
764 
765 contract ContentHashResolver is ResolverBase {
766     bytes4 constant private CONTENT_HASH_INTERFACE_ID = 0xbc1c58d1;
767 
768     event ContenthashChanged(bytes32 indexed node, bytes hash);
769 
770     mapping(bytes32=>bytes) hashes;
771 
772     /**
773      * Sets the contenthash associated with an ENS node.
774      * May only be called by the owner of that node in the ENS registry.
775      * @param node The node to update.
776      * @param hash The contenthash to set
777      */
778     function setContenthash(bytes32 node, bytes calldata hash) external authorised(node) {
779         hashes[node] = hash;
780         emit ContenthashChanged(node, hash);
781     }
782 
783     /**
784      * Returns the contenthash associated with an ENS node.
785      * @param node The ENS node to query.
786      * @return The associated contenthash.
787      */
788     function contenthash(bytes32 node) external view returns (bytes memory) {
789         return hashes[node];
790     }
791 
792     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
793         return interfaceID == CONTENT_HASH_INTERFACE_ID || super.supportsInterface(interfaceID);
794     }
795 }
796 
797 // File: InterfaceResolver.sol
798 
799 pragma solidity ^0.5.0;
800 
801 
802 
803 contract InterfaceResolver is ResolverBase, AddrResolver {
804     bytes4 constant private INTERFACE_INTERFACE_ID = bytes4(keccak256("interfaceImplementer(bytes32,bytes4)"));
805     bytes4 private constant INTERFACE_META_ID = 0x01ffc9a7;
806 
807     event InterfaceChanged(bytes32 indexed node, bytes4 indexed interfaceID, address implementer);
808 
809     mapping(bytes32=>mapping(bytes4=>address)) interfaces;
810 
811     /**
812      * Sets an interface associated with a name.
813      * Setting the address to 0 restores the default behaviour of querying the contract at `addr()` for interface support.
814      * @param node The node to update.
815      * @param interfaceID The EIP 168 interface ID.
816      * @param implementer The address of a contract that implements this interface for this node.
817      */
818     function setInterface(bytes32 node, bytes4 interfaceID, address implementer) external authorised(node) {
819         interfaces[node][interfaceID] = implementer;
820         emit InterfaceChanged(node, interfaceID, implementer);
821     }
822 
823     /**
824      * Returns the address of a contract that implements the specified interface for this name.
825      * If an implementer has not been set for this interfaceID and name, the resolver will query
826      * the contract at `addr()`. If `addr()` is set, a contract exists at that address, and that
827      * contract implements EIP168 and returns `true` for the specified interfaceID, its address
828      * will be returned.
829      * @param node The ENS node to query.
830      * @param interfaceID The EIP 168 interface ID to check for.
831      * @return The address that implements this interface, or 0 if the interface is unsupported.
832      */
833     function interfaceImplementer(bytes32 node, bytes4 interfaceID) external view returns (address) {
834         address implementer = interfaces[node][interfaceID];
835         if(implementer != address(0)) {
836             return implementer;
837         }
838 
839         address a = addr(node);
840         if(a == address(0)) {
841             return address(0);
842         }
843 
844         (bool success, bytes memory returnData) = a.staticcall(abi.encodeWithSignature("supportsInterface(bytes4)", INTERFACE_META_ID));
845         if(!success || returnData.length < 32 || returnData[31] == 0) {
846             // EIP 168 not supported by target
847             return address(0);
848         }
849 
850         (success, returnData) = a.staticcall(abi.encodeWithSignature("supportsInterface(bytes4)", interfaceID));
851         if(!success || returnData.length < 32 || returnData[31] == 0) {
852             // Specified interface not supported by target
853             return address(0);
854         }
855 
856         return a;
857     }
858 
859     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
860         return interfaceID == INTERFACE_INTERFACE_ID || super.supportsInterface(interfaceID);
861     }
862 }
863 
864 // File: NameResolver.sol
865 
866 pragma solidity ^0.5.0;
867 
868 
869 contract NameResolver is ResolverBase {
870     bytes4 constant private NAME_INTERFACE_ID = 0x691f3431;
871 
872     event NameChanged(bytes32 indexed node, string name);
873 
874     mapping(bytes32=>string) names;
875 
876     /**
877      * Sets the name associated with an ENS node, for reverse records.
878      * May only be called by the owner of that node in the ENS registry.
879      * @param node The node to update.
880      * @param name The name to set.
881      */
882     function setName(bytes32 node, string calldata name) external authorised(node) {
883         names[node] = name;
884         emit NameChanged(node, name);
885     }
886 
887     /**
888      * Returns the name associated with an ENS node, for reverse records.
889      * Defined in EIP181.
890      * @param node The ENS node to query.
891      * @return The associated name.
892      */
893     function name(bytes32 node) external view returns (string memory) {
894         return names[node];
895     }
896 
897     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
898         return interfaceID == NAME_INTERFACE_ID || super.supportsInterface(interfaceID);
899     }
900 }
901 
902 // File: PubkeyResolver.sol
903 
904 pragma solidity ^0.5.0;
905 
906 
907 contract PubkeyResolver is ResolverBase {
908     bytes4 constant private PUBKEY_INTERFACE_ID = 0xc8690233;
909 
910     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
911 
912     struct PublicKey {
913         bytes32 x;
914         bytes32 y;
915     }
916 
917     mapping(bytes32=>PublicKey) pubkeys;
918 
919     /**
920      * Sets the SECP256k1 public key associated with an ENS node.
921      * @param node The ENS node to query
922      * @param x the X coordinate of the curve point for the public key.
923      * @param y the Y coordinate of the curve point for the public key.
924      */
925     function setPubkey(bytes32 node, bytes32 x, bytes32 y) external authorised(node) {
926         pubkeys[node] = PublicKey(x, y);
927         emit PubkeyChanged(node, x, y);
928     }
929 
930     /**
931      * Returns the SECP256k1 public key associated with an ENS node.
932      * Defined in EIP 619.
933      * @param node The ENS node to query
934      * @return x, y the X and Y coordinates of the curve point for the public key.
935      */
936     function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y) {
937         return (pubkeys[node].x, pubkeys[node].y);
938     }
939 
940     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
941         return interfaceID == PUBKEY_INTERFACE_ID || super.supportsInterface(interfaceID);
942     }
943 }
944 
945 // File: TextResolver.sol
946 
947 pragma solidity ^0.5.0;
948 
949 
950 contract TextResolver is ResolverBase {
951     bytes4 constant private TEXT_INTERFACE_ID = 0x59d1d43c;
952 
953     event TextChanged(bytes32 indexed node, string indexedKey, string key);
954 
955     mapping(bytes32=>mapping(string=>string)) texts;
956 
957     /**
958      * Sets the text data associated with an ENS node and key.
959      * May only be called by the owner of that node in the ENS registry.
960      * @param node The node to update.
961      * @param key The key to set.
962      * @param value The text data value to set.
963      */
964     function setText(bytes32 node, string calldata key, string calldata value) external authorised(node) {
965         texts[node][key] = value;
966         emit TextChanged(node, key, key);
967     }
968 
969     /**
970      * Returns the text data associated with an ENS node and key.
971      * @param node The ENS node to query.
972      * @param key The text data key to query.
973      * @return The associated text data.
974      */
975     function text(bytes32 node, string calldata key) external view returns (string memory) {
976         return texts[node][key];
977     }
978 
979     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
980         return interfaceID == TEXT_INTERFACE_ID || super.supportsInterface(interfaceID);
981     }
982 }
983 
984 // File: PublicResolver.sol
985 
986 /**
987  * BSD 2-Clause License
988  *
989  * Copyright (c) 2018, True Names Limited
990  * All rights reserved.
991  *
992  * Redistribution and use in source and binary forms, with or without
993  * modification, are permitted provided that the following conditions are met:
994  *
995  * * Redistributions of source code must retain the above copyright notice, this
996  *   list of conditions and the following disclaimer.
997  *
998  * * Redistributions in binary form must reproduce the above copyright notice,
999  *   this list of conditions and the following disclaimer in the documentation
1000  *   and/or other materials provided with the distribution.
1001  *
1002  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
1003  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
1004  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
1005  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
1006  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
1007  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
1008  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
1009  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
1010  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
1011  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
1012 */
1013 
1014 pragma solidity ^0.5.0;
1015 
1016 
1017 
1018 
1019 
1020 
1021 
1022 
1023 
1024 /**
1025  * A simple resolver anyone can use; only allows the owner of a node to set its
1026  * address.
1027  */
1028 contract PublicResolver is ABIResolver, AddrResolver, ContentHashResolver, InterfaceResolver, NameResolver, PubkeyResolver, TextResolver {
1029     ENS ens;
1030 
1031     /**
1032      * A mapping of authorisations. An address that is authorised for a name
1033      * may make any changes to the name that the owner could, but may not update
1034      * the set of authorisations.
1035      * (node, owner, caller) => isAuthorised
1036      */
1037     mapping(bytes32=>mapping(address=>mapping(address=>bool))) public authorisations;
1038 
1039     event AuthorisationChanged(bytes32 indexed node, address indexed owner, address indexed target, bool isAuthorised);
1040 
1041     constructor(ENS _ens) public {
1042         ens = _ens;
1043     }
1044 
1045     /**
1046      * @dev Sets or clears an authorisation.
1047      * Authorisations are specific to the caller. Any account can set an authorisation
1048      * for any name, but the authorisation that is checked will be that of the
1049      * current owner of a name. Thus, transferring a name effectively clears any
1050      * existing authorisations, and new authorisations can be set in advance of
1051      * an ownership transfer if desired.
1052      *
1053      * @param node The name to change the authorisation on.
1054      * @param target The address that is to be authorised or deauthorised.
1055      * @param isAuthorised True if the address should be authorised, or false if it should be deauthorised.
1056      */
1057     function setAuthorisation(bytes32 node, address target, bool isAuthorised) external {
1058         authorisations[node][msg.sender][target] = isAuthorised;
1059         emit AuthorisationChanged(node, msg.sender, target, isAuthorised);
1060     }
1061 
1062     function isAuthorised(bytes32 node) internal view returns(bool) {
1063         address owner = ens.owner(node);
1064         return owner == msg.sender || authorisations[node][owner][msg.sender];
1065     }
1066 }
1067 
1068 // File: ensResolvable.sol
1069 
1070 /**
1071  *  ENSResolvable - The Consumer Contract Wallet
1072  *  Copyright (C) 2019 The Contract Wallet Company Limited
1073  *
1074  *  This program is free software: you can redistribute it and/or modify
1075  *  it under the terms of the GNU General Public License as published by
1076  *  the Free Software Foundation, either version 3 of the License, or
1077  *  (at your option) any later version.
1078 
1079  *  This program is distributed in the hope that it will be useful,
1080  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
1081  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1082  *  GNU General Public License for more details.
1083 
1084  *  You should have received a copy of the GNU General Public License
1085  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
1086  */
1087 
1088 pragma solidity ^0.5.10;
1089 
1090 
1091 
1092 
1093 ///@title ENSResolvable - Ethereum Name Service Resolver
1094 ///@notice contract should be used to get an address for an ENS node
1095 contract ENSResolvable {
1096     /// @notice _ens is an instance of ENS
1097     ENS private _ens;
1098 
1099     /// @notice _ensRegistry points to the ENS registry smart contract.
1100     address private _ensRegistry;
1101 
1102     /// @param _ensReg_ is the ENS registry used
1103     constructor(address _ensReg_) internal {
1104         _ensRegistry = _ensReg_;
1105         _ens = ENS(_ensRegistry);
1106     }
1107 
1108     /// @notice this is used to that one can observe which ENS registry is being used
1109     function ensRegistry() external view returns (address) {
1110         return _ensRegistry;
1111     }
1112 
1113     /// @notice helper function used to get the address of a node
1114     /// @param _node of the ENS entry that needs resolving
1115     /// @return the address of the said node
1116     function _ensResolve(bytes32 _node) internal view returns (address) {
1117         return PublicResolver(_ens.resolver(_node)).addr(_node);
1118     }
1119 
1120 }
1121 
1122 // File: controllable.sol
1123 
1124 /**
1125  *  Controllable - The Consumer Contract Wallet
1126  *  Copyright (C) 2019 The Contract Wallet Company Limited
1127  *
1128  *  This program is free software: you can redistribute it and/or modify
1129  *  it under the terms of the GNU General Public License as published by
1130  *  the Free Software Foundation, either version 3 of the License, or
1131  *  (at your option) any later version.
1132 
1133  *  This program is distributed in the hope that it will be useful,
1134  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
1135  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1136  *  GNU General Public License for more details.
1137 
1138  *  You should have received a copy of the GNU General Public License
1139  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
1140  */
1141 
1142 pragma solidity ^0.5.10;
1143 
1144 
1145 
1146 
1147 /// @title Controllable implements access control functionality of the Controller found via ENS.
1148 contract Controllable is ENSResolvable {
1149     /// @dev Is the registered ENS node identifying the controller contract.
1150     bytes32 private _controllerNode;
1151 
1152     /// @notice Constructor initializes the controller contract object.
1153     /// @param _controllerNode_ is the ENS node of the Controller.
1154     constructor(bytes32 _controllerNode_) internal {
1155         _controllerNode = _controllerNode_;
1156     }
1157 
1158     /// @notice Checks if message sender is a controller.
1159     modifier onlyController() {
1160         require(_isController(msg.sender), "sender is not a controller");
1161         _;
1162     }
1163 
1164     /// @notice Checks if message sender is an admin.
1165     modifier onlyAdmin() {
1166         require(_isAdmin(msg.sender), "sender is not an admin");
1167         _;
1168     }
1169 
1170     /// @return the controller node registered in ENS.
1171     function controllerNode() external view returns (bytes32) {
1172         return _controllerNode;
1173     }
1174 
1175     /// @return true if the provided account is a controller.
1176     function _isController(address _account) internal view returns (bool) {
1177         return IController(_ensResolve(_controllerNode)).isController(_account);
1178     }
1179 
1180     /// @return true if the provided account is an admin.
1181     function _isAdmin(address _account) internal view returns (bool) {
1182         return IController(_ensResolve(_controllerNode)).isAdmin(_account);
1183     }
1184 
1185 }
1186 
1187 // File: licence.sol
1188 
1189 /**
1190  *  Licence - The Consumer Contract Wallet
1191  *  Copyright (C) 2019 The Contract Wallet Company Limited
1192  *
1193  *  This program is free software: you can redistribute it and/or modify
1194  *  it under the terms of the GNU General Public License as published by
1195  *  the Free Software Foundation, either version 3 of the License, or
1196  *  (at your option) any later version.
1197 
1198  *  This program is distributed in the hope that it will be useful,
1199  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
1200  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1201  *  GNU General Public License for more details.
1202 
1203  *  You should have received a copy of the GNU General Public License
1204  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
1205  */
1206 
1207 pragma solidity ^0.5.10;
1208 
1209 
1210 
1211 
1212 
1213 
1214 /// @title ILicence interface describes methods for loading a TokenCard and updating licence amount.
1215 interface ILicence {
1216     function load(address, uint) external payable;
1217     function updateLicenceAmount(uint) external;
1218 }
1219 
1220 
1221 /// @title Licence loads the TokenCard and transfers the licence amout to the TKN Holder Contract.
1222 /// @notice the rest of the amount gets sent to the CryptoFloat
1223 contract Licence is Transferrable, ENSResolvable, Controllable {
1224 
1225     using SafeMath for uint256;
1226     using SafeERC20 for ERC20;
1227 
1228     /*******************/
1229     /*     Events     */
1230     /*****************/
1231 
1232     event UpdatedLicenceDAO(address _newDAO);
1233     event UpdatedCryptoFloat(address _newFloat);
1234     event UpdatedTokenHolder(address _newHolder);
1235     event UpdatedTKNContractAddress(address _newTKN);
1236     event UpdatedLicenceAmount(uint _newAmount);
1237 
1238     event TransferredToTokenHolder(address _from, address _to, address _asset, uint _amount);
1239     event TransferredToCryptoFloat(address _from, address _to, address _asset, uint _amount);
1240 
1241     event Claimed(address _to, address _asset, uint _amount);
1242 
1243     /// @notice This is 100% scaled up by a factor of 10 to give us an extra 1 decimal place of precision
1244     uint constant public MAX_AMOUNT_SCALE = 1000;
1245     uint constant public MIN_AMOUNT_SCALE = 1;
1246 
1247     address private _tknContractAddress = 0xaAAf91D9b90dF800Df4F55c205fd6989c977E73a; // solium-disable-line uppercase
1248 
1249     address payable private _cryptoFloat;
1250     address payable private _tokenHolder;
1251     address private _licenceDAO;
1252 
1253     bool private _lockedCryptoFloat;
1254     bool private _lockedTokenHolder;
1255     bool private _lockedLicenceDAO;
1256     bool private _lockedTKNContractAddress;
1257 
1258     /// @notice This is the _licenceAmountScaled by a factor of 10
1259     /// @dev i.e. 1% is 10 _licenceAmountScaled, 0.1% is 1 _licenceAmountScaled
1260     uint private _licenceAmountScaled;
1261 
1262     /// @notice Reverts if called by any address other than the DAO contract.
1263     modifier onlyDAO() {
1264         require(msg.sender == _licenceDAO, "the sender isn't the DAO");
1265         _;
1266     }
1267 
1268     /// @notice Constructor initializes the card licence contract.
1269     /// @param _licence_ is the initial card licence amount. this number is scaled 10 = 1%, 9 = 0.9%
1270     /// @param _float_ is the address of the multi-sig cryptocurrency float contract.
1271     /// @param _holder_ is the address of the token holder contract
1272     /// @param _tknAddress_ is the address of the TKN ERC20 contract
1273     /// @param _ens_ is the address of the ENS Registry
1274     /// @param _controllerNode_ is the ENS node corresponding to the controller
1275     constructor(uint _licence_, address payable _float_, address payable _holder_, address _tknAddress_, address _ens_, bytes32 _controllerNode_) ENSResolvable(_ens_) Controllable(_controllerNode_) public {
1276         require(MIN_AMOUNT_SCALE <= _licence_ && _licence_ <= MAX_AMOUNT_SCALE, "licence amount out of range");
1277         _licenceAmountScaled = _licence_;
1278         _cryptoFloat = _float_;
1279         _tokenHolder = _holder_;
1280         if (_tknAddress_ != address(0)) {
1281             _tknContractAddress = _tknAddress_;
1282         }
1283     }
1284 
1285     /// @notice Ether can be deposited from any source, so this contract should be payable by anyone.
1286     function() external payable {}
1287 
1288     /// @notice this allows for people to see the scaled licence amount
1289     /// @return the scaled licence amount, used to calculate the split when loading.
1290     function licenceAmountScaled() external view returns (uint) {
1291         return _licenceAmountScaled;
1292     }
1293 
1294     /// @notice allows one to see the address of the CryptoFloat
1295     /// @return the address of the multi-sig cryptocurrency float contract.
1296     function cryptoFloat() external view returns (address) {
1297         return _cryptoFloat;
1298     }
1299 
1300     /// @notice allows one to see the address TKN holder contract
1301     /// @return the address of the token holder contract.
1302     function tokenHolder() external view returns (address) {
1303         return _tokenHolder;
1304     }
1305 
1306     /// @notice allows one to see the address of the DAO
1307     /// @return the address of the DAO contract.
1308     function licenceDAO() external view returns (address) {
1309         return _licenceDAO;
1310     }
1311 
1312     /// @notice The address of the TKN token
1313     /// @return the address of the TKN contract.
1314     function tknContractAddress() external view returns (address) {
1315         return _tknContractAddress;
1316     }
1317 
1318     /// @notice This locks the cryptoFloat address
1319     /// @dev so that it can no longer be updated
1320     function lockFloat() external onlyAdmin {
1321         _lockedCryptoFloat = true;
1322     }
1323 
1324     /// @notice This locks the TokenHolder address
1325     /// @dev so that it can no longer be updated
1326     function lockHolder() external onlyAdmin {
1327         _lockedTokenHolder = true;
1328     }
1329 
1330     /// @notice This locks the DAO address
1331     /// @dev so that it can no longer be updated
1332     function lockLicenceDAO() external onlyAdmin {
1333         _lockedLicenceDAO = true;
1334     }
1335 
1336     /// @notice This locks the TKN address
1337     /// @dev so that it can no longer be updated
1338     function lockTKNContractAddress() external onlyAdmin {
1339         _lockedTKNContractAddress = true;
1340     }
1341 
1342     /// @notice Updates the address of the cyptoFloat.
1343     /// @param _newFloat This is the new address for the CryptoFloat
1344     function updateFloat(address payable _newFloat) external onlyAdmin {
1345         require(!floatLocked(), "float is locked");
1346         _cryptoFloat = _newFloat;
1347         emit UpdatedCryptoFloat(_newFloat);
1348     }
1349 
1350     /// @notice Updates the address of the Holder contract.
1351     /// @param _newHolder This is the new address for the TokenHolder
1352     function updateHolder(address payable _newHolder) external onlyAdmin {
1353         require(!holderLocked(), "holder contract is locked");
1354         _tokenHolder = _newHolder;
1355         emit UpdatedTokenHolder(_newHolder);
1356     }
1357 
1358     /// @notice Updates the address of the DAO contract.
1359     /// @param _newDAO This is the new address for the Licence DAO
1360     function updateLicenceDAO(address _newDAO) external onlyAdmin {
1361         require(!licenceDAOLocked(), "DAO is locked");
1362         _licenceDAO = _newDAO;
1363         emit UpdatedLicenceDAO(_newDAO);
1364     }
1365 
1366     /// @notice Updates the address of the TKN contract.
1367     /// @param _newTKN This is the new address for the TKN contract
1368     function updateTKNContractAddress(address _newTKN) external onlyAdmin {
1369         require(!tknContractAddressLocked(), "TKN is locked");
1370         _tknContractAddress = _newTKN;
1371         emit UpdatedTKNContractAddress(_newTKN);
1372     }
1373 
1374     /// @notice Updates the TKN licence amount
1375     /// @param _newAmount is a number between MIN_AMOUNT_SCALE (1) and MAX_AMOUNT_SCALE
1376     function updateLicenceAmount(uint _newAmount) external onlyDAO {
1377         require(MIN_AMOUNT_SCALE <= _newAmount && _newAmount <= MAX_AMOUNT_SCALE, "licence amount out of range");
1378         _licenceAmountScaled = _newAmount;
1379         emit UpdatedLicenceAmount(_newAmount);
1380     }
1381 
1382     /// @notice Load the holder and float contracts based on the licence amount and asset amount.
1383     /// @param _asset is the address of an ERC20 token or 0x0 for ether.
1384     /// @param _amount is the amount of assets to be transferred including the licence amount.
1385     function load(address _asset, uint _amount) external payable {
1386         uint loadAmount = _amount;
1387         // If TKN then no licence to be paid
1388         if (_asset == _tknContractAddress) {
1389             ERC20(_asset).safeTransferFrom(msg.sender, _cryptoFloat, loadAmount);
1390         } else {
1391             loadAmount = _amount.mul(MAX_AMOUNT_SCALE).div(_licenceAmountScaled + MAX_AMOUNT_SCALE);
1392             uint licenceAmount = _amount.sub(loadAmount);
1393 
1394             if (_asset != address(0)) {
1395                 ERC20(_asset).safeTransferFrom(msg.sender, _tokenHolder, licenceAmount);
1396                 ERC20(_asset).safeTransferFrom(msg.sender, _cryptoFloat, loadAmount);
1397             } else {
1398                 require(msg.value == _amount, "ETH sent is not equal to amount");
1399                 _tokenHolder.transfer(licenceAmount);
1400                 _cryptoFloat.transfer(loadAmount);
1401             }
1402 
1403             emit TransferredToTokenHolder(msg.sender, _tokenHolder, _asset, licenceAmount);
1404         }
1405 
1406         emit TransferredToCryptoFloat(msg.sender, _cryptoFloat, _asset, loadAmount);
1407     }
1408 
1409     //// @notice Withdraw tokens from the smart contract to the specified account.
1410     function claim(address payable _to, address _asset, uint _amount) external onlyAdmin {
1411         _safeTransfer(_to, _asset, _amount);
1412         emit Claimed(_to, _asset, _amount);
1413     }
1414 
1415     /// @notice returns whether or not the CryptoFloat address is locked
1416     function floatLocked() public view returns (bool) {
1417         return _lockedCryptoFloat;
1418     }
1419 
1420     /// @notice returns whether or not the TokenHolder address is locked
1421     function holderLocked() public view returns (bool) {
1422         return _lockedTokenHolder;
1423     }
1424 
1425     /// @notice returns whether or not the Licence DAO address is locked
1426     function licenceDAOLocked() public view returns (bool) {
1427         return _lockedLicenceDAO;
1428     }
1429 
1430     /// @notice returns whether or not the TKN address is locked
1431     function tknContractAddressLocked() public view returns (bool) {
1432         return _lockedTKNContractAddress;
1433     }
1434 }