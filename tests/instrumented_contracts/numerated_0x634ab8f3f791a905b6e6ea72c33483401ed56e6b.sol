1 // File: internals/ownable.sol
2 
3 /**
4  *  Ownable - The Consumer Contract Wallet
5  *  Copyright (C) 2019 The Contract Wallet Company Limited
6  *
7  *  This program is free software: you can redistribute it and/or modify
8  *  it under the terms of the GNU General Public License as published by
9  *  the Free Software Foundation, either version 3 of the License, or
10  *  (at your option) any later version.
11 
12  *  This program is distributed in the hope that it will be useful,
13  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
14  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15  *  GNU General Public License for more details.
16 
17  *  You should have received a copy of the GNU General Public License
18  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
19  */
20 
21 pragma solidity ^0.5.10;
22 
23 
24 /// @title Ownable has an owner address and provides basic authorization control functions.
25 /// This contract is modified version of the MIT OpenZepplin Ownable contract
26 /// This contract allows for the transferOwnership operation to be made impossible
27 /// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
28 contract Ownable {
29     event TransferredOwnership(address _from, address _to);
30     event LockedOwnership(address _locked);
31 
32     address payable private _owner;
33     bool private _isTransferable;
34 
35     /// @notice Constructor sets the original owner of the contract and whether or not it is one time transferable.
36     constructor(address payable _account_, bool _transferable_) internal {
37         _owner = _account_;
38         _isTransferable = _transferable_;
39         // Emit the LockedOwnership event if no longer transferable.
40         if (!_isTransferable) {
41             emit LockedOwnership(_account_);
42         }
43         emit TransferredOwnership(address(0), _account_);
44     }
45 
46     /// @notice Reverts if called by any account other than the owner.
47     modifier onlyOwner() {
48         require(_isOwner(msg.sender), "sender is not an owner");
49         _;
50     }
51 
52     /// @notice Allows the current owner to transfer control of the contract to a new address.
53     /// @param _account address to transfer ownership to.
54     /// @param _transferable indicates whether to keep the ownership transferable.
55     function transferOwnership(address payable _account, bool _transferable) external onlyOwner {
56         // Require that the ownership is transferable.
57         require(_isTransferable, "ownership is not transferable");
58         // Require that the new owner is not the zero address.
59         require(_account != address(0), "owner cannot be set to zero address");
60         // Set the transferable flag to the value _transferable passed in.
61         _isTransferable = _transferable;
62         // Emit the LockedOwnership event if no longer transferable.
63         if (!_transferable) {
64             emit LockedOwnership(_account);
65         }
66         // Emit the ownership transfer event.
67         emit TransferredOwnership(_owner, _account);
68         // Set the owner to the provided address.
69         _owner = _account;
70     }
71 
72     /// @notice check if the ownership is transferable.
73     /// @return true if the ownership is transferable.
74     function isTransferable() external view returns (bool) {
75         return _isTransferable;
76     }
77 
78     /// @notice Allows the current owner to relinquish control of the contract.
79     /// @dev Renouncing to ownership will leave the contract without an owner and unusable.
80     /// @dev It will not be possible to call the functions with the `onlyOwner` modifier anymore.
81     function renounceOwnership() external onlyOwner {
82         // Require that the ownership is transferable.
83         require(_isTransferable, "ownership is not transferable");
84         // note that this could be terminal
85         _owner = address(0);
86 
87         emit TransferredOwnership(_owner, address(0));
88     }
89 
90     /// @notice Find out owner address
91     /// @return address of the owner.
92     function owner() public view returns (address payable) {
93         return _owner;
94     }
95 
96     /// @notice Check if owner address
97     /// @return true if sender is the owner of the contract.
98     function _isOwner(address _address) internal view returns (bool) {
99         return _address == _owner;
100     }
101 }
102 
103 // File: externals/ERC20.sol
104 
105 pragma solidity ^0.5.10;
106 
107 /// @title ERC20 interface is a subset of the ERC20 specification.
108 /// @notice see https://github.com/ethereum/EIPs/issues/20
109 interface ERC20 {
110     function allowance(address _owner, address _spender) external view returns (uint256);
111     function approve(address _spender, uint256 _value) external returns (bool);
112     function balanceOf(address _who) external view returns (uint256);
113     function totalSupply() external view returns (uint256);
114     function transfer(address _to, uint256 _value) external returns (bool);
115     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
116 }
117 
118 // File: externals/SafeMath.sol
119 
120 pragma solidity ^0.5.0;
121 
122 /**
123  * @dev Wrappers over Solidity's arithmetic operations with added overflow
124  * checks.
125  *
126  * Arithmetic operations in Solidity wrap on overflow. This can easily result
127  * in bugs, because programmers usually assume that an overflow raises an
128  * error, which is the standard behavior in high level programming languages.
129  * `SafeMath` restores this intuition by reverting the transaction when an
130  * operation overflows.
131  *
132  * Using this library instead of the unchecked operations eliminates an entire
133  * class of bugs, so it's recommended to use it always.
134  */
135 library SafeMath {
136     /**
137      * @dev Returns the addition of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `+` operator.
141      *
142      * Requirements:
143      * - Addition cannot overflow.
144      */
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         require(c >= a, "SafeMath: addition overflow");
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162         require(b <= a, "SafeMath: subtraction overflow");
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         // Solidity only automatically asserts when dividing by 0
204         require(b > 0, "SafeMath: division by zero");
205         uint256 c = a / b;
206         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223         require(b != 0, "SafeMath: modulo by zero");
224         return a % b;
225     }
226 }
227 
228 // File: externals/Address.sol
229 
230 pragma solidity ^0.5.0;
231 
232 /**
233  * @dev Collection of functions related to the address type,
234  */
235 library Address {
236     /**
237      * @dev Returns true if `account` is a contract.
238      *
239      * This test is non-exhaustive, and there may be false-negatives: during the
240      * execution of a contract's constructor, its address will be reported as
241      * not containing a contract.
242      *
243      * > It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      */
246     function isContract(address account) internal view returns (bool) {
247         // This method relies in extcodesize, which returns 0 for contracts in
248         // construction, since the code is only stored at the end of the
249         // constructor execution.
250 
251         uint256 size;
252         // solhint-disable-next-line no-inline-assembly
253         assembly { size := extcodesize(account) }
254         return size > 0;
255     }
256 }
257 
258 // File: externals/SafeERC20.sol
259 
260 /**
261  * The MIT License (MIT)
262  *
263  * Copyright (c) 2016-2019 zOS Global Limited
264  *
265  * Permission is hereby granted, free of charge, to any person obtaining
266  * a copy of this software and associated documentation files (the
267  * "Software"), to deal in the Software without restriction, including
268  * without limitation the rights to use, copy, modify, merge, publish,
269  * distribute, sublicense, and/or sell copies of the Software, and to
270  * permit persons to whom the Software is furnished to do so, subject to
271  * the following conditions:
272  *
273  * The above copyright notice and this permission notice shall be included
274  * in all copies or substantial portions of the Software.
275  *
276  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
277  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
278  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
279  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
280  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
281  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
282  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
283  */
284 
285 pragma solidity ^0.5.0;
286 
287 
288 
289 
290 /**
291  * @title SafeERC20
292  * @dev Wrappers around ERC20 operations that throw on failure (when the token
293  * contract returns false). Tokens that return no value (and instead revert or
294  * throw on failure) are also supported, non-reverting calls are assumed to be
295  * successful.
296  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
297  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
298  */
299 library SafeERC20 {
300     using SafeMath for uint256;
301     using Address for address;
302 
303     function safeTransfer(ERC20 token, address to, uint256 value) internal {
304         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
305     }
306 
307     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
308         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
309     }
310 
311     function safeApprove(ERC20 token, address spender, uint256 value) internal {
312         // safeApprove should only be called when setting an initial allowance,
313         // or when resetting it to zero. To increase and decrease it, use
314         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
315         // solhint-disable-next-line max-line-length
316         require((value == 0) || (token.allowance(address(this), spender) == 0),
317             "SafeERC20: approve from non-zero to non-zero allowance"
318         );
319         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
320     }
321 
322     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
323         uint256 newAllowance = token.allowance(address(this), spender).add(value);
324         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
325     }
326 
327     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
328         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
329         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
330     }
331 
332     /**
333      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
334      * on the return value: the return value is optional (but if data is returned, it must not be false).
335      * @param token The token targeted by the call.
336      * @param data The call data (encoded using abi.encode or one of its variants).
337      */
338     function callOptionalReturn(ERC20 token, bytes memory data) internal {
339         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
340         // we're implementing it ourselves.
341 
342         // A Solidity high level call has three parts:
343         //  1. The target address is checked to verify it contains contract code
344         //  2. The call itself is made, and success asserted
345         //  3. The return value is decoded, which in turn checks the size of the returned data.
346         // solhint-disable-next-line max-line-length
347         require(address(token).isContract(), "SafeERC20: call to non-contract");
348 
349         // solhint-disable-next-line avoid-low-level-calls
350         (bool success, bytes memory returndata) = address(token).call(data);
351         require(success, "SafeERC20: low-level call failed");
352 
353         if (returndata.length > 0) { // Return data is optional
354             // solhint-disable-next-line max-line-length
355             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
356         }
357     }
358 }
359 
360 // File: internals/transferrable.sol
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
595 // File: externals/ens/ENS.sol
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
651 // File: externals/ens/ResolverBase.sol
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
670 // File: externals/ens/profiles/ABIResolver.sol
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
723 // File: externals/ens/profiles/AddrResolver.sol
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
760 // File: externals/ens/profiles/ContentHashResolver.sol
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
797 // File: externals/ens/profiles/InterfaceResolver.sol
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
864 // File: externals/ens/profiles/NameResolver.sol
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
902 // File: externals/ens/profiles/PubkeyResolver.sol
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
945 // File: externals/ens/profiles/TextResolver.sol
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
984 // File: externals/ens/PublicResolver.sol
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
1068 // File: internals/ensResolvable.sol
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
1122 // File: internals/controllable.sol
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
1187 // File: internals/date.sol
1188 
1189 /**
1190  *  Date - The Consumer Contract Wallet
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
1210 /// @title Date provides redimentary date parsing functionality.
1211 /// @notice This method parses months found in an ISO date to a number
1212 contract Date {
1213 
1214     bytes32 constant private _JANUARY = keccak256("Jan");
1215     bytes32 constant private _FEBRUARY = keccak256("Feb");
1216     bytes32 constant private _MARCH = keccak256("Mar");
1217     bytes32 constant private _APRIL = keccak256("Apr");
1218     bytes32 constant private _MAY = keccak256("May");
1219     bytes32 constant private _JUNE = keccak256("Jun");
1220     bytes32 constant private _JULY = keccak256("Jul");
1221     bytes32 constant private _AUGUST = keccak256("Aug");
1222     bytes32 constant private _SEPTEMBER = keccak256("Sep");
1223     bytes32 constant private _OCTOBER = keccak256("Oct");
1224     bytes32 constant private _NOVEMBER = keccak256("Nov");
1225     bytes32 constant private _DECEMBER = keccak256("Dec");
1226 
1227     /// @return the number of the month based on its name.
1228     /// @param _month the first three letters of a month's name e.g. "Jan".
1229     function _monthToNumber(string memory _month) internal pure returns (uint8) {
1230         bytes32 month = keccak256(abi.encodePacked(_month));
1231         if (month == _JANUARY) {
1232             return 1;
1233         } else if (month == _FEBRUARY) {
1234             return 2;
1235         } else if (month == _MARCH) {
1236             return 3;
1237         } else if (month == _APRIL) {
1238             return 4;
1239         } else if (month == _MAY) {
1240             return 5;
1241         } else if (month == _JUNE) {
1242             return 6;
1243         } else if (month == _JULY) {
1244             return 7;
1245         } else if (month == _AUGUST) {
1246             return 8;
1247         } else if (month == _SEPTEMBER) {
1248             return 9;
1249         } else if (month == _OCTOBER) {
1250             return 10;
1251         } else if (month == _NOVEMBER) {
1252             return 11;
1253         } else if (month == _DECEMBER) {
1254             return 12;
1255         } else {
1256             revert("not a valid month");
1257         }
1258     }
1259 }
1260 
1261 // File: internals/parseIntScientific.sol
1262 
1263 /**
1264  *  ParseIntScientific - The Consumer Contract Wallet
1265  *  Copyright (C) 2019 The Contract Wallet Company Limited
1266  *
1267  *  This program is free software: you can redistribute it and/or modify
1268  *  it under the terms of the GNU General Public License as published by
1269  *  the Free Software Foundation, either version 3 of the License, or
1270  *  (at your option) any later version.
1271 
1272  *  This program is distributed in the hope that it will be useful,
1273  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
1274  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1275  *  GNU General Public License for more details.
1276 
1277  *  You should have received a copy of the GNU General Public License
1278  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
1279 */
1280 
1281 pragma solidity ^0.5.10;
1282 
1283 
1284 
1285 /// @title ParseIntScientific provides floating point in scientific notation (e.g. e-5) parsing functionality.
1286 contract ParseIntScientific {
1287 
1288     using SafeMath for uint256;
1289 
1290     byte constant private _PLUS_ASCII = byte(uint8(43)); //decimal value of '+'
1291     byte constant private _DASH_ASCII = byte(uint8(45)); //decimal value of '-'
1292     byte constant private _DOT_ASCII = byte(uint8(46)); //decimal value of '.'
1293     byte constant private _ZERO_ASCII = byte(uint8(48)); //decimal value of '0'
1294     byte constant private _NINE_ASCII = byte(uint8(57)); //decimal value of '9'
1295     byte constant private _E_ASCII = byte(uint8(69)); //decimal value of 'E'
1296     byte constant private _LOWERCASE_E_ASCII = byte(uint8(101)); //decimal value of 'e'
1297 
1298     /// @notice ParseIntScientific delegates the call to _parseIntScientific(string, uint) with the 2nd argument being 0.
1299     function _parseIntScientific(string memory _inString) internal pure returns (uint) {
1300         return _parseIntScientific(_inString, 0);
1301     }
1302 
1303     /// @notice ParseIntScientificWei parses a rate expressed in ETH and returns its wei denomination
1304     function _parseIntScientificWei(string memory _inString) internal pure returns (uint) {
1305         return _parseIntScientific(_inString, 18);
1306     }
1307 
1308     /// @notice ParseIntScientific parses a JSON standard - floating point number.
1309     /// @param _inString is input string.
1310     /// @param _magnitudeMult multiplies the number with 10^_magnitudeMult.
1311     function _parseIntScientific(string memory _inString, uint _magnitudeMult) internal pure returns (uint) {
1312 
1313         bytes memory inBytes = bytes(_inString);
1314         uint mint = 0; // the final uint returned
1315         uint mintDec = 0; // the uint following the decimal point
1316         uint mintExp = 0; // the exponent
1317         uint decMinted = 0; // how many decimals were 'minted'.
1318         uint expIndex = 0; // the position in the byte array that 'e' was found (if found)
1319         bool integral = false; // indicates the existence of the integral part, it should always exist (even if 0) e.g. 'e+1'  or '.1' is not valid
1320         bool decimals = false; // indicates a decimal number, set to true if '.' is found
1321         bool exp = false; // indicates if the number being parsed has an exponential representation
1322         bool minus = false; // indicated if the exponent is negative
1323         bool plus = false; // indicated if the exponent is positive
1324         uint i;
1325         for (i = 0; i < inBytes.length; i++) {
1326             if ((inBytes[i] >= _ZERO_ASCII) && (inBytes[i] <= _NINE_ASCII) && (!exp)) {
1327                 // 'e' not encountered yet, minting integer part or decimals
1328                 if (decimals) {
1329                     // '.' encountered
1330                     // use safeMath in case there is an overflow
1331                     mintDec = mintDec.mul(10);
1332                     mintDec = mintDec.add(uint8(inBytes[i]) - uint8(_ZERO_ASCII));
1333                     decMinted++; //keep track of the #decimals
1334                 } else {
1335                     // integral part (before '.')
1336                     integral = true;
1337                     // use safeMath in case there is an overflow
1338                     mint = mint.mul(10);
1339                     mint = mint.add(uint8(inBytes[i]) - uint8(_ZERO_ASCII));
1340                 }
1341             } else if ((inBytes[i] >= _ZERO_ASCII) && (inBytes[i] <= _NINE_ASCII) && (exp)) {
1342                 //exponential notation (e-/+) has been detected, mint the exponent
1343                 mintExp = mintExp.mul(10);
1344                 mintExp = mintExp.add(uint8(inBytes[i]) - uint8(_ZERO_ASCII));
1345             } else if (inBytes[i] == _DOT_ASCII) {
1346                 //an integral part before should always exist before '.'
1347                 require(integral, "missing integral part");
1348                 // an extra decimal point makes the format invalid
1349                 require(!decimals, "duplicate decimal point");
1350                 //the decimal point should always be before the exponent
1351                 require(!exp, "decimal after exponent");
1352                 decimals = true;
1353             } else if (inBytes[i] == _DASH_ASCII) {
1354                 // an extra '-' should be considered an invalid character
1355                 require(!minus, "duplicate -");
1356                 require(!plus, "extra sign");
1357                 require(expIndex + 1 == i, "- sign not immediately after e");
1358                 minus = true;
1359             } else if (inBytes[i] == _PLUS_ASCII) {
1360                 // an extra '+' should be considered an invalid character
1361                 require(!plus, "duplicate +");
1362                 require(!minus, "extra sign");
1363                 require(expIndex + 1 == i, "+ sign not immediately after e");
1364                 plus = true;
1365             } else if ((inBytes[i] == _E_ASCII) || (inBytes[i] == _LOWERCASE_E_ASCII)) {
1366                 //an integral part before should always exist before 'e'
1367                 require(integral, "missing integral part");
1368                 // an extra 'e' or 'E' should be considered an invalid character
1369                 require(!exp, "duplicate exponent symbol");
1370                 exp = true;
1371                 expIndex = i;
1372             } else {
1373                 revert("invalid digit");
1374             }
1375         }
1376 
1377         if (minus || plus) {
1378             // end of string e[x|-] without specifying the exponent
1379             require(i > expIndex + 2);
1380         } else if (exp) {
1381             // end of string (e) without specifying the exponent
1382             require(i > expIndex + 1);
1383         }
1384 
1385         if (minus) {
1386             // e^(-x)
1387             if (mintExp >= _magnitudeMult) {
1388                 // the (negative) exponent is bigger than the given parameter for "shifting left".
1389                 // use integer division to reduce the precision.
1390                 require(mintExp - _magnitudeMult < 78, "exponent > 77"); //
1391                 mint /= 10 ** (mintExp - _magnitudeMult);
1392                 return mint;
1393 
1394             } else {
1395                 // the (negative) exponent is smaller than the given parameter for "shifting left".
1396                 //no need for underflow check
1397                 _magnitudeMult = _magnitudeMult - mintExp;
1398             }
1399         } else {
1400             // e^(+x), positive exponent or no exponent
1401             // just shift left as many times as indicated by the exponent and the shift parameter
1402             _magnitudeMult = _magnitudeMult.add(mintExp);
1403         }
1404 
1405         if (_magnitudeMult >= decMinted) {
1406             // the decimals are fewer or equal than the shifts: use all of them
1407             // shift number and add the decimals at the end
1408             // include decimals if present in the original input
1409             require(decMinted < 78, "more than 77 decimal digits parsed"); //
1410             mint = mint.mul(10 ** (decMinted));
1411             mint = mint.add(mintDec);
1412             //// add zeros at the end if the decimals were fewer than #_magnitudeMult
1413             require(_magnitudeMult - decMinted < 78, "exponent > 77"); //
1414             mint = mint.mul(10 ** (_magnitudeMult - decMinted));
1415         } else {
1416             // the decimals are more than the #_magnitudeMult shifts
1417             // use only the ones needed, discard the rest
1418             decMinted -= _magnitudeMult;
1419             require(decMinted < 78, "more than 77 decimal digits parsed"); //
1420             mintDec /= 10 ** (decMinted);
1421             // shift number and add the decimals at the end
1422             require(_magnitudeMult < 78, "more than 77 decimal digits parsed"); //
1423             mint = mint.mul(10 ** (_magnitudeMult));
1424             mint = mint.add(mintDec);
1425         }
1426         return mint;
1427     }
1428 }
1429 
1430 // File: internals/bytesUtils.sol
1431 
1432 /**
1433  *  BytesUtils - The Consumer Contract Wallet
1434  *  Copyright (C) 2019 The Contract Wallet Company Limited
1435  *
1436  *  This program is free software: you can redistribute it and/or modify
1437  *  it under the terms of the GNU General Public License as published by
1438  *  the Free Software Foundation, either version 3 of the License, or
1439  *  (at your option) any later version.
1440 
1441  *  This program is distributed in the hope that it will be useful,
1442  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
1443  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1444  *  GNU General Public License for more details.
1445 
1446  *  You should have received a copy of the GNU General Public License
1447  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
1448  */
1449 
1450 pragma solidity ^0.5.10;
1451 
1452 
1453 /// @title BytesUtils provides basic byte slicing and casting functionality.
1454 library BytesUtils {
1455 
1456     using SafeMath for uint256;
1457 
1458     /// @dev This function converts to an address
1459     /// @param _bts bytes
1460     /// @param _from start position
1461     function _bytesToAddress(bytes memory _bts, uint _from) internal pure returns (address) {
1462 
1463         require(_bts.length >= _from.add(20), "slicing out of range");
1464 
1465         bytes20 convertedAddress;
1466         uint startByte = _from.add(32); //first 32 bytes denote the array length
1467 
1468         assembly {
1469             convertedAddress := mload(add(_bts, startByte))
1470         }
1471 
1472         return address(convertedAddress);
1473     }
1474 
1475     /// @dev This function slices bytes into bytes4
1476     /// @param _bts some bytes
1477     /// @param _from start position
1478     function _bytesToBytes4(bytes memory _bts, uint _from) internal pure returns (bytes4) {
1479         require(_bts.length >= _from.add(4), "slicing out of range");
1480 
1481         bytes4 slicedBytes4;
1482         uint startByte = _from.add(32); //first 32 bytes denote the array length
1483 
1484         assembly {
1485             slicedBytes4 := mload(add(_bts, startByte))
1486         }
1487 
1488         return slicedBytes4;
1489 
1490     }
1491 
1492     /// @dev This function slices a uint
1493     /// @param _bts some bytes
1494     /// @param _from start position
1495     // credit to https://ethereum.stackexchange.com/questions/51229/how-to-convert-bytes-to-uint-in-solidity
1496     // and Nick Johnson https://ethereum.stackexchange.com/questions/4170/how-to-convert-a-uint-to-bytes-in-solidity/4177#4177
1497     function _bytesToUint256(bytes memory _bts, uint _from) internal pure returns (uint) {
1498         require(_bts.length >= _from.add(32), "slicing out of range");
1499 
1500         uint convertedUint256;
1501         uint startByte = _from.add(32); //first 32 bytes denote the array length
1502         
1503         assembly {
1504             convertedUint256 := mload(add(_bts, startByte))
1505         }
1506 
1507         return convertedUint256;
1508     }
1509 }
1510 
1511 // File: externals/strings.sol
1512 
1513 /*
1514  * Copyright 2016 Nick Johnson
1515  *
1516  * Licensed under the Apache License, Version 2.0 (the "License");
1517  * you may not use this file except in compliance with the License.
1518  * You may obtain a copy of the License at
1519  *
1520  *     http://www.apache.org/licenses/LICENSE-2.0
1521  *
1522  * Unless required by applicable law or agreed to in writing, software
1523  * distributed under the License is distributed on an "AS IS" BASIS,
1524  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1525  * See the License for the specific language governing permissions and
1526  * limitations under the License.
1527  */
1528 
1529 /*
1530  * @title String & slice utility library for Solidity contracts.
1531  * @author Nick Johnson <arachnid@notdot.net>
1532  *
1533  * @dev Functionality in this library is largely implemented using an
1534  *      abstraction called a 'slice'. A slice represents a part of a string -
1535  *      anything from the entire string to a single character, or even no
1536  *      characters at all (a 0-length slice). Since a slice only has to specify
1537  *      an offset and a length, copying and manipulating slices is a lot less
1538  *      expensive than copying and manipulating the strings they reference.
1539  *
1540  *      To further reduce gas costs, most functions on slice that need to return
1541  *      a slice modify the original one instead of allocating a new one; for
1542  *      instance, `s.split(".")` will return the text up to the first '.',
1543  *      modifying s to only contain the remainder of the string after the '.'.
1544  *      In situations where you do not want to modify the original slice, you
1545  *      can make a copy first with `.copy()`, for example:
1546  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1547  *      Solidity has no memory management, it will result in allocating many
1548  *      short-lived slices that are later discarded.
1549  *
1550  *      Functions that return two slices come in two versions: a non-allocating
1551  *      version that takes the second slice as an argument, modifying it in
1552  *      place, and an allocating version that allocates and returns the second
1553  *      slice; see `nextRune` for example.
1554  *
1555  *      Functions that have to copy string data will return strings rather than
1556  *      slices; these can be cast back to slices for further processing if
1557  *      required.
1558  *
1559  *      For convenience, some functions are provided with non-modifying
1560  *      variants that create a new slice and return both; for instance,
1561  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1562  *      corresponding to the left and right parts of the string.
1563  */
1564 
1565 pragma solidity ^0.5.0;
1566 
1567 library strings {
1568     struct slice {
1569         uint _len;
1570         uint _ptr;
1571     }
1572 
1573     function memcpy(uint dest, uint src, uint len) private pure {
1574         // Copy word-length chunks while possible
1575         for(; len >= 32; len -= 32) {
1576             assembly {
1577                 mstore(dest, mload(src))
1578             }
1579             dest += 32;
1580             src += 32;
1581         }
1582 
1583         // Copy remaining bytes
1584         uint mask = 256 ** (32 - len) - 1;
1585         assembly {
1586             let srcpart := and(mload(src), not(mask))
1587             let destpart := and(mload(dest), mask)
1588             mstore(dest, or(destpart, srcpart))
1589         }
1590     }
1591 
1592     /*
1593      * @dev Returns a slice containing the entire string.
1594      * @param self The string to make a slice from.
1595      * @return A newly allocated slice containing the entire string.
1596      */
1597     function toSlice(string memory self) internal pure returns (slice memory) {
1598         uint ptr;
1599         assembly {
1600             ptr := add(self, 0x20)
1601         }
1602         return slice(bytes(self).length, ptr);
1603     }
1604 
1605     /*
1606      * @dev Returns the length of a null-terminated bytes32 string.
1607      * @param self The value to find the length of.
1608      * @return The length of the string, from 0 to 32.
1609      */
1610     function len(bytes32 self) internal pure returns (uint) {
1611         uint ret;
1612         if (self == 0)
1613             return 0;
1614         if (uint(self) & 0xffffffffffffffffffffffffffffffff == 0) {
1615             ret += 16;
1616             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1617         }
1618         if (uint(self) & 0xffffffffffffffff == 0) {
1619             ret += 8;
1620             self = bytes32(uint(self) / 0x10000000000000000);
1621         }
1622         if (uint(self) & 0xffffffff == 0) {
1623             ret += 4;
1624             self = bytes32(uint(self) / 0x100000000);
1625         }
1626         if (uint(self) & 0xffff == 0) {
1627             ret += 2;
1628             self = bytes32(uint(self) / 0x10000);
1629         }
1630         if (uint(self) & 0xff == 0) {
1631             ret += 1;
1632         }
1633         return 32 - ret;
1634     }
1635 
1636     /*
1637      * @dev Returns a slice containing the entire bytes32, interpreted as a
1638      *      null-terminated utf-8 string.
1639      * @param self The bytes32 value to convert to a slice.
1640      * @return A new slice containing the value of the input argument up to the
1641      *         first null.
1642      */
1643     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
1644         // Allocate space for `self` in memory, copy it there, and point ret at it
1645         assembly {
1646             let ptr := mload(0x40)
1647             mstore(0x40, add(ptr, 0x20))
1648             mstore(ptr, self)
1649             mstore(add(ret, 0x20), ptr)
1650         }
1651         ret._len = len(self);
1652     }
1653 
1654     /*
1655      * @dev Returns a new slice containing the same data as the current slice.
1656      * @param self The slice to copy.
1657      * @return A new slice containing the same data as `self`.
1658      */
1659     function copy(slice memory self) internal pure returns (slice memory) {
1660         return slice(self._len, self._ptr);
1661     }
1662 
1663     /*
1664      * @dev Copies a slice to a new string.
1665      * @param self The slice to copy.
1666      * @return A newly allocated string containing the slice's text.
1667      */
1668     function toString(slice memory self) internal pure returns (string memory) {
1669         string memory ret = new string(self._len);
1670         uint retptr;
1671         assembly { retptr := add(ret, 32) }
1672 
1673         memcpy(retptr, self._ptr, self._len);
1674         return ret;
1675     }
1676 
1677     /*
1678      * @dev Returns the length in runes of the slice. Note that this operation
1679      *      takes time proportional to the length of the slice; avoid using it
1680      *      in loops, and call `slice.empty()` if you only need to know whether
1681      *      the slice is empty or not.
1682      * @param self The slice to operate on.
1683      * @return The length of the slice in runes.
1684      */
1685     function len(slice memory self) internal pure returns (uint l) {
1686         // Starting at ptr-31 means the LSB will be the byte we care about
1687         uint ptr = self._ptr - 31;
1688         uint end = ptr + self._len;
1689         for (l = 0; ptr < end; l++) {
1690             uint8 b;
1691             assembly { b := and(mload(ptr), 0xFF) }
1692             if (b < 0x80) {
1693                 ptr += 1;
1694             } else if (b < 0xE0) {
1695                 ptr += 2;
1696             } else if (b < 0xF0) {
1697                 ptr += 3;
1698             } else if (b < 0xF8) {
1699                 ptr += 4;
1700             } else if (b < 0xFC) {
1701                 ptr += 5;
1702             } else {
1703                 ptr += 6;
1704             }
1705         }
1706     }
1707 
1708     /*
1709      * @dev Returns true if the slice is empty (has a length of 0).
1710      * @param self The slice to operate on.
1711      * @return True if the slice is empty, False otherwise.
1712      */
1713     function empty(slice memory self) internal pure returns (bool) {
1714         return self._len == 0;
1715     }
1716 
1717     /*
1718      * @dev Returns a positive number if `other` comes lexicographically after
1719      *      `self`, a negative number if it comes before, or zero if the
1720      *      contents of the two slices are equal. Comparison is done per-rune,
1721      *      on unicode codepoints.
1722      * @param self The first slice to compare.
1723      * @param other The second slice to compare.
1724      * @return The result of the comparison.
1725      */
1726     function compare(slice memory self, slice memory other) internal pure returns (int) {
1727         uint shortest = self._len;
1728         if (other._len < self._len)
1729             shortest = other._len;
1730 
1731         uint selfptr = self._ptr;
1732         uint otherptr = other._ptr;
1733         for (uint idx = 0; idx < shortest; idx += 32) {
1734             uint a;
1735             uint b;
1736             assembly {
1737                 a := mload(selfptr)
1738                 b := mload(otherptr)
1739             }
1740             if (a != b) {
1741                 // Mask out irrelevant bytes and check again
1742                 uint256 mask = uint256(-1); // 0xffff...
1743                 if (shortest < 32) {
1744                     mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1745                 }
1746                 uint256 diff = (a & mask) - (b & mask);
1747                 if (diff != 0)
1748                     return int(diff);
1749             }
1750             selfptr += 32;
1751             otherptr += 32;
1752         }
1753         return int(self._len) - int(other._len);
1754     }
1755 
1756     /*
1757      * @dev Returns true if the two slices contain the same text.
1758      * @param self The first slice to compare.
1759      * @param self The second slice to compare.
1760      * @return True if the slices are equal, false otherwise.
1761      */
1762     function equals(slice memory self, slice memory other) internal pure returns (bool) {
1763         return compare(self, other) == 0;
1764     }
1765 
1766     /*
1767      * @dev Extracts the first rune in the slice into `rune`, advancing the
1768      *      slice to point to the next rune and returning `self`.
1769      * @param self The slice to operate on.
1770      * @param rune The slice that will contain the first rune.
1771      * @return `rune`.
1772      */
1773     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
1774         rune._ptr = self._ptr;
1775 
1776         if (self._len == 0) {
1777             rune._len = 0;
1778             return rune;
1779         }
1780 
1781         uint l;
1782         uint b;
1783         // Load the first byte of the rune into the LSBs of b
1784         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1785         if (b < 0x80) {
1786             l = 1;
1787         } else if (b < 0xE0) {
1788             l = 2;
1789         } else if (b < 0xF0) {
1790             l = 3;
1791         } else {
1792             l = 4;
1793         }
1794 
1795         // Check for truncated codepoints
1796         if (l > self._len) {
1797             rune._len = self._len;
1798             self._ptr += self._len;
1799             self._len = 0;
1800             return rune;
1801         }
1802 
1803         self._ptr += l;
1804         self._len -= l;
1805         rune._len = l;
1806         return rune;
1807     }
1808 
1809     /*
1810      * @dev Returns the first rune in the slice, advancing the slice to point
1811      *      to the next rune.
1812      * @param self The slice to operate on.
1813      * @return A slice containing only the first rune from `self`.
1814      */
1815     function nextRune(slice memory self) internal pure returns (slice memory ret) {
1816         nextRune(self, ret);
1817     }
1818 
1819     /*
1820      * @dev Returns the number of the first codepoint in the slice.
1821      * @param self The slice to operate on.
1822      * @return The number of the first codepoint in the slice.
1823      */
1824     function ord(slice memory self) internal pure returns (uint ret) {
1825         if (self._len == 0) {
1826             return 0;
1827         }
1828 
1829         uint word;
1830         uint length;
1831         uint divisor = 2 ** 248;
1832 
1833         // Load the rune into the MSBs of b
1834         assembly { word:= mload(mload(add(self, 32))) }
1835         uint b = word / divisor;
1836         if (b < 0x80) {
1837             ret = b;
1838             length = 1;
1839         } else if (b < 0xE0) {
1840             ret = b & 0x1F;
1841             length = 2;
1842         } else if (b < 0xF0) {
1843             ret = b & 0x0F;
1844             length = 3;
1845         } else {
1846             ret = b & 0x07;
1847             length = 4;
1848         }
1849 
1850         // Check for truncated codepoints
1851         if (length > self._len) {
1852             return 0;
1853         }
1854 
1855         for (uint i = 1; i < length; i++) {
1856             divisor = divisor / 256;
1857             b = (word / divisor) & 0xFF;
1858             if (b & 0xC0 != 0x80) {
1859                 // Invalid UTF-8 sequence
1860                 return 0;
1861             }
1862             ret = (ret * 64) | (b & 0x3F);
1863         }
1864 
1865         return ret;
1866     }
1867 
1868     /*
1869      * @dev Returns the keccak-256 hash of the slice.
1870      * @param self The slice to hash.
1871      * @return The hash of the slice.
1872      */
1873     function keccak(slice memory self) internal pure returns (bytes32 ret) {
1874         assembly {
1875             ret := keccak256(mload(add(self, 32)), mload(self))
1876         }
1877     }
1878 
1879     /*
1880      * @dev Returns true if `self` starts with `needle`.
1881      * @param self The slice to operate on.
1882      * @param needle The slice to search for.
1883      * @return True if the slice starts with the provided text, false otherwise.
1884      */
1885     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1886         if (self._len < needle._len) {
1887             return false;
1888         }
1889 
1890         if (self._ptr == needle._ptr) {
1891             return true;
1892         }
1893 
1894         bool equal;
1895         assembly {
1896             let length := mload(needle)
1897             let selfptr := mload(add(self, 0x20))
1898             let needleptr := mload(add(needle, 0x20))
1899             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1900         }
1901         return equal;
1902     }
1903 
1904     /*
1905      * @dev If `self` starts with `needle`, `needle` is removed from the
1906      *      beginning of `self`. Otherwise, `self` is unmodified.
1907      * @param self The slice to operate on.
1908      * @param needle The slice to search for.
1909      * @return `self`
1910      */
1911     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
1912         if (self._len < needle._len) {
1913             return self;
1914         }
1915 
1916         bool equal = true;
1917         if (self._ptr != needle._ptr) {
1918             assembly {
1919                 let length := mload(needle)
1920                 let selfptr := mload(add(self, 0x20))
1921                 let needleptr := mload(add(needle, 0x20))
1922                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1923             }
1924         }
1925 
1926         if (equal) {
1927             self._len -= needle._len;
1928             self._ptr += needle._len;
1929         }
1930 
1931         return self;
1932     }
1933 
1934     /*
1935      * @dev Returns true if the slice ends with `needle`.
1936      * @param self The slice to operate on.
1937      * @param needle The slice to search for.
1938      * @return True if the slice starts with the provided text, false otherwise.
1939      */
1940     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1941         if (self._len < needle._len) {
1942             return false;
1943         }
1944 
1945         uint selfptr = self._ptr + self._len - needle._len;
1946 
1947         if (selfptr == needle._ptr) {
1948             return true;
1949         }
1950 
1951         bool equal;
1952         assembly {
1953             let length := mload(needle)
1954             let needleptr := mload(add(needle, 0x20))
1955             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1956         }
1957 
1958         return equal;
1959     }
1960 
1961     /*
1962      * @dev If `self` ends with `needle`, `needle` is removed from the
1963      *      end of `self`. Otherwise, `self` is unmodified.
1964      * @param self The slice to operate on.
1965      * @param needle The slice to search for.
1966      * @return `self`
1967      */
1968     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
1969         if (self._len < needle._len) {
1970             return self;
1971         }
1972 
1973         uint selfptr = self._ptr + self._len - needle._len;
1974         bool equal = true;
1975         if (selfptr != needle._ptr) {
1976             assembly {
1977                 let length := mload(needle)
1978                 let needleptr := mload(add(needle, 0x20))
1979                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1980             }
1981         }
1982 
1983         if (equal) {
1984             self._len -= needle._len;
1985         }
1986 
1987         return self;
1988     }
1989 
1990     // Returns the memory address of the first byte of the first occurrence of
1991     // `needle` in `self`, or the first byte after `self` if not found.
1992     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1993         uint ptr = selfptr;
1994         uint idx;
1995 
1996         if (needlelen <= selflen) {
1997             if (needlelen <= 32) {
1998                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1999 
2000                 bytes32 needledata;
2001                 assembly { needledata := and(mload(needleptr), mask) }
2002 
2003                 uint end = selfptr + selflen - needlelen;
2004                 bytes32 ptrdata;
2005                 assembly { ptrdata := and(mload(ptr), mask) }
2006 
2007                 while (ptrdata != needledata) {
2008                     if (ptr >= end)
2009                         return selfptr + selflen;
2010                     ptr++;
2011                     assembly { ptrdata := and(mload(ptr), mask) }
2012                 }
2013                 return ptr;
2014             } else {
2015                 // For long needles, use hashing
2016                 bytes32 hash;
2017                 assembly { hash := keccak256(needleptr, needlelen) }
2018 
2019                 for (idx = 0; idx <= selflen - needlelen; idx++) {
2020                     bytes32 testHash;
2021                     assembly { testHash := keccak256(ptr, needlelen) }
2022                     if (hash == testHash)
2023                         return ptr;
2024                     ptr += 1;
2025                 }
2026             }
2027         }
2028         return selfptr + selflen;
2029     }
2030 
2031     // Returns the memory address of the first byte after the last occurrence of
2032     // `needle` in `self`, or the address of `self` if not found.
2033     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
2034         uint ptr;
2035 
2036         if (needlelen <= selflen) {
2037             if (needlelen <= 32) {
2038                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
2039 
2040                 bytes32 needledata;
2041                 assembly { needledata := and(mload(needleptr), mask) }
2042 
2043                 ptr = selfptr + selflen - needlelen;
2044                 bytes32 ptrdata;
2045                 assembly { ptrdata := and(mload(ptr), mask) }
2046 
2047                 while (ptrdata != needledata) {
2048                     if (ptr <= selfptr)
2049                         return selfptr;
2050                     ptr--;
2051                     assembly { ptrdata := and(mload(ptr), mask) }
2052                 }
2053                 return ptr + needlelen;
2054             } else {
2055                 // For long needles, use hashing
2056                 bytes32 hash;
2057                 assembly { hash := keccak256(needleptr, needlelen) }
2058                 ptr = selfptr + (selflen - needlelen);
2059                 while (ptr >= selfptr) {
2060                     bytes32 testHash;
2061                     assembly { testHash := keccak256(ptr, needlelen) }
2062                     if (hash == testHash)
2063                         return ptr + needlelen;
2064                     ptr -= 1;
2065                 }
2066             }
2067         }
2068         return selfptr;
2069     }
2070 
2071     /*
2072      * @dev Modifies `self` to contain everything from the first occurrence of
2073      *      `needle` to the end of the slice. `self` is set to the empty slice
2074      *      if `needle` is not found.
2075      * @param self The slice to search and modify.
2076      * @param needle The text to search for.
2077      * @return `self`.
2078      */
2079     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
2080         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2081         self._len -= ptr - self._ptr;
2082         self._ptr = ptr;
2083         return self;
2084     }
2085 
2086     /*
2087      * @dev Modifies `self` to contain the part of the string from the start of
2088      *      `self` to the end of the first occurrence of `needle`. If `needle`
2089      *      is not found, `self` is set to the empty slice.
2090      * @param self The slice to search and modify.
2091      * @param needle The text to search for.
2092      * @return `self`.
2093      */
2094     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
2095         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2096         self._len = ptr - self._ptr;
2097         return self;
2098     }
2099 
2100     /*
2101      * @dev Splits the slice, setting `self` to everything after the first
2102      *      occurrence of `needle`, and `token` to everything before it. If
2103      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2104      *      and `token` is set to the entirety of `self`.
2105      * @param self The slice to split.
2106      * @param needle The text to search for in `self`.
2107      * @param token An output parameter to which the first token is written.
2108      * @return `token`.
2109      */
2110     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
2111         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2112         token._ptr = self._ptr;
2113         token._len = ptr - self._ptr;
2114         if (ptr == self._ptr + self._len) {
2115             // Not found
2116             self._len = 0;
2117         } else {
2118             self._len -= token._len + needle._len;
2119             self._ptr = ptr + needle._len;
2120         }
2121         return token;
2122     }
2123 
2124     /*
2125      * @dev Splits the slice, setting `self` to everything after the first
2126      *      occurrence of `needle`, and returning everything before it. If
2127      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2128      *      and the entirety of `self` is returned.
2129      * @param self The slice to split.
2130      * @param needle The text to search for in `self`.
2131      * @return The part of `self` up to the first occurrence of `delim`.
2132      */
2133     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
2134         split(self, needle, token);
2135     }
2136 
2137     /*
2138      * @dev Splits the slice, setting `self` to everything before the last
2139      *      occurrence of `needle`, and `token` to everything after it. If
2140      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2141      *      and `token` is set to the entirety of `self`.
2142      * @param self The slice to split.
2143      * @param needle The text to search for in `self`.
2144      * @param token An output parameter to which the first token is written.
2145      * @return `token`.
2146      */
2147     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
2148         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2149         token._ptr = ptr;
2150         token._len = self._len - (ptr - self._ptr);
2151         if (ptr == self._ptr) {
2152             // Not found
2153             self._len = 0;
2154         } else {
2155             self._len -= token._len + needle._len;
2156         }
2157         return token;
2158     }
2159 
2160     /*
2161      * @dev Splits the slice, setting `self` to everything before the last
2162      *      occurrence of `needle`, and returning everything after it. If
2163      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2164      *      and the entirety of `self` is returned.
2165      * @param self The slice to split.
2166      * @param needle The text to search for in `self`.
2167      * @return The part of `self` after the last occurrence of `delim`.
2168      */
2169     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
2170         rsplit(self, needle, token);
2171     }
2172 
2173     /*
2174      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
2175      * @param self The slice to search.
2176      * @param needle The text to search for in `self`.
2177      * @return The number of occurrences of `needle` found in `self`.
2178      */
2179     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
2180         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
2181         while (ptr <= self._ptr + self._len) {
2182             cnt++;
2183             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
2184         }
2185     }
2186 
2187     /*
2188      * @dev Returns True if `self` contains `needle`.
2189      * @param self The slice to search.
2190      * @param needle The text to search for in `self`.
2191      * @return True if `needle` is found in `self`, false otherwise.
2192      */
2193     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
2194         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
2195     }
2196 
2197     /*
2198      * @dev Returns a newly allocated string containing the concatenation of
2199      *      `self` and `other`.
2200      * @param self The first slice to concatenate.
2201      * @param other The second slice to concatenate.
2202      * @return The concatenation of the two strings.
2203      */
2204     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
2205         string memory ret = new string(self._len + other._len);
2206         uint retptr;
2207         assembly { retptr := add(ret, 32) }
2208         memcpy(retptr, self._ptr, self._len);
2209         memcpy(retptr + self._len, other._ptr, other._len);
2210         return ret;
2211     }
2212 
2213     /*
2214      * @dev Joins an array of slices, using `self` as a delimiter, returning a
2215      *      newly allocated string.
2216      * @param self The delimiter to use.
2217      * @param parts A list of slices to join.
2218      * @return A newly allocated string containing all the slices in `parts`,
2219      *         joined with `self`.
2220      */
2221     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
2222         if (parts.length == 0)
2223             return "";
2224 
2225         uint length = self._len * (parts.length - 1);
2226         for (uint i = 0; i < parts.length; i++) {
2227             length += parts[i]._len;
2228         }
2229 
2230         string memory ret = new string(length);
2231         uint retptr;
2232         assembly { retptr := add(ret, 32) }
2233 
2234         for (uint i = 0; i < parts.length; i++) {
2235             memcpy(retptr, parts[i]._ptr, parts[i]._len);
2236             retptr += parts[i]._len;
2237             if (i < parts.length - 1) {
2238                 memcpy(retptr, self._ptr, self._len);
2239                 retptr += self._len;
2240             }
2241         }
2242 
2243         return ret;
2244     }
2245 }
2246 
2247 // File: tokenWhitelist.sol
2248 
2249 /**
2250  *  TokenWhitelist - The Consumer Contract Wallet
2251  *  Copyright (C) 2019 The Contract Wallet Company Limited
2252  *
2253  *  This program is free software: you can redistribute it and/or modify
2254  *  it under the terms of the GNU General Public License as published by
2255  *  the Free Software Foundation, either version 3 of the License, or
2256  *  (at your option) any later version.
2257 
2258  *  This program is distributed in the hope that it will be useful,
2259  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
2260  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2261  *  GNU General Public License for more details.
2262 
2263  *  You should have received a copy of the GNU General Public License
2264  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
2265  */
2266 
2267 pragma solidity ^0.5.10;
2268 
2269 
2270 
2271 
2272 
2273 
2274 /// @title The ITokenWhitelist interface provides access to a whitelist of tokens.
2275 interface ITokenWhitelist {
2276     function getTokenInfo(address) external view returns (string memory, uint256, uint256, bool, bool, bool, uint256);
2277     function getStablecoinInfo() external view returns (string memory, uint256, uint256, bool, bool, bool, uint256);
2278     function tokenAddressArray() external view returns (address[] memory);
2279     function redeemableTokens() external view returns (address[] memory);
2280     function methodIdWhitelist(bytes4) external view returns (bool);
2281     function getERC20RecipientAndAmount(address, bytes calldata) external view returns (address, uint);
2282     function stablecoin() external view returns (address);
2283     function updateTokenRate(address, uint, uint) external;
2284 }
2285 
2286 
2287 /// @title TokenWhitelist stores a list of tokens used by the Consumer Contract Wallet, the Oracle, the TKN Holder and the TKN Licence Contract
2288 contract TokenWhitelist is ENSResolvable, Controllable, Transferrable {
2289     using strings for *;
2290     using SafeMath for uint256;
2291     using BytesUtils for bytes;
2292 
2293     event UpdatedTokenRate(address _sender, address _token, uint _rate);
2294 
2295     event UpdatedTokenLoadable(address _sender, address _token, bool _loadable);
2296     event UpdatedTokenRedeemable(address _sender, address _token, bool _redeemable);
2297 
2298     event AddedToken(address _sender, address _token, string _symbol, uint _magnitude, bool _loadable, bool _redeemable);
2299     event RemovedToken(address _sender, address _token);
2300 
2301     event AddedMethodId(bytes4 _methodId);
2302     event RemovedMethodId(bytes4 _methodId);
2303     event AddedExclusiveMethod(address _token, bytes4 _methodId);
2304     event RemovedExclusiveMethod(address _token, bytes4 _methodId);
2305 
2306     event Claimed(address _to, address _asset, uint _amount);
2307 
2308     /// @dev these are the methods whitelisted by default in executeTransaction() for protected tokens
2309     bytes4 private constant _APPROVE = 0x095ea7b3; // keccak256(approve(address,uint256)) => 0x095ea7b3
2310     bytes4 private constant _BURN = 0x42966c68; // keccak256(burn(uint256)) => 0x42966c68
2311     bytes4 private constant _TRANSFER= 0xa9059cbb; // keccak256(transfer(address,uint256)) => 0xa9059cbb
2312     bytes4 private constant _TRANSFER_FROM = 0x23b872dd; // keccak256(transferFrom(address,address,uint256)) => 0x23b872dd
2313 
2314     struct Token {
2315         string symbol;    // Token symbol
2316         uint magnitude;   // 10^decimals
2317         uint rate;        // Token exchange rate in wei
2318         bool available;   // Flags if the token is available or not
2319         bool loadable;    // Flags if token is loadable to the TokenCard
2320         bool redeemable;    // Flags if token is redeemable in the TKN Holder contract
2321         uint lastUpdate;  // Time of the last rate update
2322     }
2323 
2324     mapping(address => Token) private _tokenInfoMap;
2325 
2326     // @notice specifies whitelisted methodIds for protected tokens in wallet's excuteTranaction() e.g. keccak256(transfer(address,uint256)) => 0xa9059cbb
2327     mapping(bytes4 => bool) private _methodIdWhitelist;
2328 
2329     address[] private _tokenAddressArray;
2330 
2331     /// @notice keeping track of how many redeemable tokens are in the tokenWhitelist
2332     uint private _redeemableCounter;
2333 
2334     /// @notice Address of the stablecoin.
2335     address private _stablecoin;
2336 
2337     /// @notice is registered ENS node identifying the oracle contract.
2338     bytes32 private _oracleNode;
2339 
2340     /// @notice Constructor initializes ENSResolvable, and Controllable.
2341     /// @param _ens_ is the ENS registry address.
2342     /// @param _oracleNode_ is the ENS node of the Oracle.
2343     /// @param _controllerNode_ is our Controllers node.
2344     /// @param _stablecoinAddress_ is the address of the stablecoint used by the wallet for the card load limit.
2345     constructor(address _ens_, bytes32 _oracleNode_, bytes32 _controllerNode_, address _stablecoinAddress_) ENSResolvable(_ens_) Controllable(_controllerNode_) public {
2346         _oracleNode = _oracleNode_;
2347         _stablecoin = _stablecoinAddress_;
2348         //a priori ERC20 whitelisted methods
2349         _methodIdWhitelist[_APPROVE] = true;
2350         _methodIdWhitelist[_BURN] = true;
2351         _methodIdWhitelist[_TRANSFER] = true;
2352         _methodIdWhitelist[_TRANSFER_FROM] = true;
2353     }
2354 
2355     modifier onlyAdminOrOracle() {
2356         address oracleAddress = _ensResolve(_oracleNode);
2357         require (_isAdmin(msg.sender) || msg.sender == oracleAddress, "either oracle or admin");
2358         _;
2359     }
2360 
2361     /// @notice Add ERC20 tokens to the list of whitelisted tokens.
2362     /// @param _tokens ERC20 token contract addresses.
2363     /// @param _symbols ERC20 token names.
2364     /// @param _magnitude 10 to the power of number of decimal places used by each ERC20 token.
2365     /// @param _loadable is a bool that states whether or not a token is loadable to the TokenCard.
2366     /// @param _redeemable is a bool that states whether or not a token is redeemable in the TKN Holder Contract.
2367     /// @param _lastUpdate is a unit representing an ISO datetime e.g. 20180913153211.
2368     function addTokens(address[] calldata _tokens, bytes32[] calldata _symbols, uint[] calldata _magnitude, bool[] calldata _loadable, bool[] calldata _redeemable, uint _lastUpdate) external onlyAdmin {
2369         // Require that all parameters have the same length.
2370         require(_tokens.length == _symbols.length && _tokens.length == _magnitude.length && _tokens.length == _loadable.length && _tokens.length == _loadable.length, "parameter lengths do not match");
2371         // Add each token to the list of supported tokens.
2372         for (uint i = 0; i < _tokens.length; i++) {
2373             // Require that the token isn't already available.
2374             require(!_tokenInfoMap[_tokens[i]].available, "token already available");
2375             // Store the intermediate values.
2376             string memory symbol = _symbols[i].toSliceB32().toString();
2377             // Add the token to the token list.
2378             _tokenInfoMap[_tokens[i]] = Token({
2379                 symbol : symbol,
2380                 magnitude : _magnitude[i],
2381                 rate : 0,
2382                 available : true,
2383                 loadable : _loadable[i],
2384                 redeemable: _redeemable[i],
2385                 lastUpdate : _lastUpdate
2386                 });
2387             // Add the token address to the address list.
2388             _tokenAddressArray.push(_tokens[i]);
2389             //if the token is redeemable increase the redeemableCounter
2390             if (_redeemable[i]){
2391                 _redeemableCounter = _redeemableCounter.add(1);
2392             }
2393             // Emit token addition event.
2394             emit AddedToken(msg.sender, _tokens[i], symbol, _magnitude[i], _loadable[i], _redeemable[i]);
2395         }
2396     }
2397 
2398     /// @notice Remove ERC20 tokens from the whitelist of tokens.
2399     /// @param _tokens ERC20 token contract addresses.
2400     function removeTokens(address[] calldata _tokens) external onlyAdmin {
2401         // Delete each token object from the list of supported tokens based on the addresses provided.
2402         for (uint i = 0; i < _tokens.length; i++) {
2403             // Store the token address.
2404             address token = _tokens[i];
2405             //token must be available, reverts on duplicates as well
2406             require(_tokenInfoMap[token].available, "token is not available");
2407             //if the token is redeemable decrease the redeemableCounter
2408             if (_tokenInfoMap[token].redeemable){
2409                 _redeemableCounter = _redeemableCounter.sub(1);
2410             }
2411             // Delete the token object.
2412             delete _tokenInfoMap[token];
2413             // Remove the token address from the address list.
2414             for (uint j = 0; j < _tokenAddressArray.length.sub(1); j++) {
2415                 if (_tokenAddressArray[j] == token) {
2416                     _tokenAddressArray[j] = _tokenAddressArray[_tokenAddressArray.length.sub(1)];
2417                     break;
2418                 }
2419             }
2420             _tokenAddressArray.length--;
2421             // Emit token removal event.
2422             emit RemovedToken(msg.sender, token);
2423         }
2424     }
2425 
2426     /// @notice based on the method it returns the recipient address and amount/value, ERC20 specific.
2427     /// @param _data is the transaction payload.
2428     function getERC20RecipientAndAmount(address _token, bytes calldata _data) external view returns (address, uint) {
2429         // Require that there exist enough bytes for encoding at least a method signature + data in the transaction payload:
2430         // 4 (signature)  + 32(address or uint256)
2431         require(_data.length >= 4 + 32, "not enough method-encoding bytes");
2432         // Get the method signature
2433         bytes4 signature = _data._bytesToBytes4(0);
2434         // Check if method Id is supported
2435         require(isERC20MethodSupported(_token, signature), "unsupported method");
2436         // returns the recipient's address and amount is the value to be transferred
2437         if (signature == _BURN) {
2438             // 4 (signature) + 32(uint256)
2439             return (_token, _data._bytesToUint256(4));
2440         } else if (signature == _TRANSFER_FROM) {
2441             // 4 (signature) + 32(address) + 32(address) + 32(uint256)
2442             require(_data.length >= 4 + 32 + 32 + 32, "not enough data for transferFrom");
2443             return ( _data._bytesToAddress(4 + 32 + 12), _data._bytesToUint256(4 + 32 + 32));
2444         } else { //transfer or approve
2445             // 4 (signature) + 32(address) + 32(uint)
2446             require(_data.length >= 4 + 32 + 32, "not enough data for transfer/appprove");
2447             return (_data._bytesToAddress(4 + 12), _data._bytesToUint256(4 + 32));
2448         }
2449     }
2450 
2451     /// @notice Toggles whether or not a token is loadable or not.
2452     function setTokenLoadable(address _token, bool _loadable) external onlyAdmin {
2453         // Require that the token exists.
2454         require(_tokenInfoMap[_token].available, "token is not available");
2455 
2456         // this sets the loadable flag to the value passed in
2457         _tokenInfoMap[_token].loadable = _loadable;
2458 
2459         emit UpdatedTokenLoadable(msg.sender, _token, _loadable);
2460     }
2461 
2462     /// @notice Toggles whether or not a token is redeemable or not.
2463     function setTokenRedeemable(address _token, bool _redeemable) external onlyAdmin {
2464         // Require that the token exists.
2465         require(_tokenInfoMap[_token].available, "token is not available");
2466 
2467         // this sets the redeemable flag to the value passed in
2468         _tokenInfoMap[_token].redeemable = _redeemable;
2469 
2470         emit UpdatedTokenRedeemable(msg.sender, _token, _redeemable);
2471     }
2472 
2473     /// @notice Update ERC20 token exchange rate.
2474     /// @param _token ERC20 token contract address.
2475     /// @param _rate ERC20 token exchange rate in wei.
2476     /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.
2477     function updateTokenRate(address _token, uint _rate, uint _updateDate) external onlyAdminOrOracle {
2478         // Require that the token exists.
2479         require(_tokenInfoMap[_token].available, "token is not available");
2480         // Update the token's rate.
2481         _tokenInfoMap[_token].rate = _rate;
2482         // Update the token's last update timestamp.
2483         _tokenInfoMap[_token].lastUpdate = _updateDate;
2484         // Emit the rate update event.
2485         emit UpdatedTokenRate(msg.sender, _token, _rate);
2486     }
2487 
2488     //// @notice Withdraw tokens from the smart contract to the specified account.
2489     function claim(address payable _to, address _asset, uint _amount) external onlyAdmin {
2490         _safeTransfer(_to, _asset, _amount);
2491         emit Claimed(_to, _asset, _amount);
2492     }
2493 
2494     /// @notice This returns all of the fields for a given token.
2495     /// @param _a is the address of a given token.
2496     /// @return string of the token's symbol.
2497     /// @return uint of the token's magnitude.
2498     /// @return uint of the token's exchange rate to ETH.
2499     /// @return bool whether the token is available.
2500     /// @return bool whether the token is loadable to the TokenCard.
2501     /// @return bool whether the token is redeemable to the TKN Holder Contract.
2502     /// @return uint of the lastUpdated time of the token's exchange rate.
2503     function getTokenInfo(address _a) external view returns (string memory, uint256, uint256, bool, bool, bool, uint256) {
2504         Token storage tokenInfo = _tokenInfoMap[_a];
2505         return (tokenInfo.symbol, tokenInfo.magnitude, tokenInfo.rate, tokenInfo.available, tokenInfo.loadable, tokenInfo.redeemable, tokenInfo.lastUpdate);
2506     }
2507 
2508     /// @notice This returns all of the fields for our StableCoin.
2509     /// @return string of the token's symbol.
2510     /// @return uint of the token's magnitude.
2511     /// @return uint of the token's exchange rate to ETH.
2512     /// @return bool whether the token is available.
2513     /// @return bool whether the token is loadable to the TokenCard.
2514     /// @return bool whether the token is redeemable to the TKN Holder Contract.
2515     /// @return uint of the lastUpdated time of the token's exchange rate.
2516     function getStablecoinInfo() external view returns (string memory, uint256, uint256, bool, bool, bool, uint256) {
2517         Token storage stablecoinInfo = _tokenInfoMap[_stablecoin];
2518         return (stablecoinInfo.symbol, stablecoinInfo.magnitude, stablecoinInfo.rate, stablecoinInfo.available, stablecoinInfo.loadable, stablecoinInfo.redeemable, stablecoinInfo.lastUpdate);
2519     }
2520 
2521     /// @notice This returns an array of all whitelisted token addresses.
2522     /// @return address[] of whitelisted tokens.
2523     function tokenAddressArray() external view returns (address[] memory) {
2524         return _tokenAddressArray;
2525     }
2526 
2527     /// @notice This returns an array of all redeemable token addresses.
2528     /// @return address[] of redeemable tokens.
2529     function redeemableTokens() external view returns (address[] memory) {
2530         address[] memory redeemableAddresses = new address[](_redeemableCounter);
2531         uint redeemableIndex = 0;
2532         for (uint i = 0; i < _tokenAddressArray.length; i++) {
2533             address token = _tokenAddressArray[i];
2534             if (_tokenInfoMap[token].redeemable){
2535                 redeemableAddresses[redeemableIndex] = token;
2536                 redeemableIndex += 1;
2537             }
2538         }
2539         return redeemableAddresses;
2540     }
2541 
2542 
2543     /// @notice This returns true if a method Id is supported for the specific token.
2544     /// @return true if _methodId is supported in general or just for the specific token.
2545     function isERC20MethodSupported(address _token, bytes4 _methodId) public view returns (bool) {
2546         require(_tokenInfoMap[_token].available, "non-existing token");
2547         return (_methodIdWhitelist[_methodId]);
2548     }
2549 
2550     /// @notice This returns true if the method is supported for all protected tokens.
2551     /// @return true if _methodId is in the method whitelist.
2552     function isERC20MethodWhitelisted(bytes4 _methodId) external view returns (bool) {
2553         return (_methodIdWhitelist[_methodId]);
2554     }
2555 
2556     /// @notice This returns the number of redeemable tokens.
2557     /// @return current # of redeemables.
2558     function redeemableCounter() external view returns (uint) {
2559         return _redeemableCounter;
2560     }
2561 
2562     /// @notice This returns the address of our stablecoin of choice.
2563     /// @return the address of the stablecoin contract.
2564     function stablecoin() external view returns (address) {
2565         return _stablecoin;
2566     }
2567 
2568     /// @notice this returns the node hash of our Oracle.
2569     /// @return the oracle node registered in ENS.
2570     function oracleNode() external view returns (bytes32) {
2571         return _oracleNode;
2572     }
2573 }
2574 
2575 // File: internals/tokenWhitelistable.sol
2576 
2577 /**
2578  *  TokenWhitelistable - The Consumer Contract Wallet
2579  *  Copyright (C) 2019 The Contract Wallet Company Limited
2580  *
2581  *  This program is free software: you can redistribute it and/or modify
2582  *  it under the terms of the GNU General Public License as published by
2583  *  the Free Software Foundation, either version 3 of the License, or
2584  *  (at your option) any later version.
2585 
2586  *  This program is distributed in the hope that it will be useful,
2587  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
2588  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2589  *  GNU General Public License for more details.
2590 
2591  *  You should have received a copy of the GNU General Public License
2592  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
2593  */
2594 
2595 pragma solidity ^0.5.10;
2596 
2597 
2598 
2599 
2600 /// @title TokenWhitelistable implements access to the TokenWhitelist located behind ENS.
2601 contract TokenWhitelistable is ENSResolvable {
2602 
2603     /// @notice Is the registered ENS node identifying the tokenWhitelist contract
2604     bytes32 private _tokenWhitelistNode;
2605 
2606     /// @notice Constructor initializes the TokenWhitelistable object.
2607     /// @param _tokenWhitelistNode_ is the ENS node of the TokenWhitelist.
2608     constructor(bytes32 _tokenWhitelistNode_) internal {
2609         _tokenWhitelistNode = _tokenWhitelistNode_;
2610     }
2611 
2612     /// @notice This shows what TokenWhitelist is being used
2613     /// @return TokenWhitelist's node registered in ENS.
2614     function tokenWhitelistNode() external view returns (bytes32) {
2615         return _tokenWhitelistNode;
2616     }
2617 
2618     /// @notice This returns all of the fields for a given token.
2619     /// @param _a is the address of a given token.
2620     /// @return string of the token's symbol.
2621     /// @return uint of the token's magnitude.
2622     /// @return uint of the token's exchange rate to ETH.
2623     /// @return bool whether the token is available.
2624     /// @return bool whether the token is loadable to the TokenCard.
2625     /// @return bool whether the token is redeemable to the TKN Holder Contract.
2626     /// @return uint of the lastUpdated time of the token's exchange rate.
2627     function _getTokenInfo(address _a) internal view returns (string memory, uint256, uint256, bool, bool, bool, uint256) {
2628         return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).getTokenInfo(_a);
2629     }
2630 
2631     /// @notice This returns all of the fields for our stablecoin token.
2632     /// @return string of the token's symbol.
2633     /// @return uint of the token's magnitude.
2634     /// @return uint of the token's exchange rate to ETH.
2635     /// @return bool whether the token is available.
2636     /// @return bool whether the token is loadable to the TokenCard.
2637     /// @return bool whether the token is redeemable to the TKN Holder Contract.
2638     /// @return uint of the lastUpdated time of the token's exchange rate.
2639     function _getStablecoinInfo() internal view returns (string memory, uint256, uint256, bool, bool, bool, uint256) {
2640         return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).getStablecoinInfo();
2641     }
2642 
2643     /// @notice This returns an array of our whitelisted addresses.
2644     /// @return address[] of our whitelisted tokens.
2645     function _tokenAddressArray() internal view returns (address[] memory) {
2646         return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).tokenAddressArray();
2647     }
2648 
2649     /// @notice This returns an array of all redeemable token addresses.
2650     /// @return address[] of redeemable tokens.
2651     function _redeemableTokens() internal view returns (address[] memory) {
2652         return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).redeemableTokens();
2653     }
2654 
2655     /// @notice Update ERC20 token exchange rate.
2656     /// @param _token ERC20 token contract address.
2657     /// @param _rate ERC20 token exchange rate in wei.
2658     /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.
2659     function _updateTokenRate(address _token, uint _rate, uint _updateDate) internal {
2660         ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).updateTokenRate(_token, _rate, _updateDate);
2661     }
2662 
2663     /// @notice based on the method it returns the recipient address and amount/value, ERC20 specific.
2664     /// @param _data is the transaction payload.
2665     function _getERC20RecipientAndAmount(address _destination, bytes memory _data) internal view returns (address, uint) {
2666         return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).getERC20RecipientAndAmount(_destination, _data);
2667     }
2668 
2669     /// @notice Checks whether a token is available.
2670     /// @return bool available or not.
2671     function _isTokenAvailable(address _a) internal view returns (bool) {
2672         ( , , , bool available, , , ) = _getTokenInfo(_a);
2673         return available;
2674     }
2675 
2676     /// @notice Checks whether a token is redeemable.
2677     /// @return bool redeemable or not.
2678     function _isTokenRedeemable(address _a) internal view returns (bool) {
2679         ( , , , , , bool redeemable, ) = _getTokenInfo(_a);
2680         return redeemable;
2681     }
2682 
2683     /// @notice Checks whether a token is loadable.
2684     /// @return bool loadable or not.
2685     function _isTokenLoadable(address _a) internal view returns (bool) {
2686         ( , , , , bool loadable, , ) = _getTokenInfo(_a);
2687         return loadable;
2688     }
2689 
2690     /// @notice This gets the address of the stablecoin.
2691     /// @return the address of the stablecoin contract.
2692     function _stablecoin() internal view returns (address) {
2693         return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).stablecoin();
2694     }
2695 
2696 }
2697 
2698 // File: externals/oraclizeAPI_0.5.sol
2699 
2700 /*
2701 
2702 ORACLIZE_API
2703 
2704 Copyright (c) 2015-2016 Oraclize SRL
2705 Copyright (c) 2016 Oraclize LTD
2706 
2707 Permission is hereby granted, free of charge, to any person obtaining a copy
2708 of this software and associated documentation files (the "Software"), to deal
2709 in the Software without restriction, including without limitation the rights
2710 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2711 copies of the Software, and to permit persons to whom the Software is
2712 furnished to do so, subject to the following conditions:
2713 
2714 The above copyright notice and this permission notice shall be included in
2715 all copies or substantial portions of the Software.
2716 
2717 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2718 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2719 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
2720 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2721 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2722 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
2723 THE SOFTWARE.
2724 
2725 */
2726 pragma solidity >= 0.5.0 < 0.6.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
2727 
2728 // Dummy contract only used to emit to end-user they are using wrong solc
2729 contract solcChecker {
2730 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
2731 }
2732 
2733 contract OraclizeI {
2734 
2735     address public cbAddress;
2736 
2737     function setProofType(byte _proofType) external;
2738     function setCustomGasPrice(uint _gasPrice) external;
2739     function getPrice(string memory _datasource) public returns (uint _dsprice);
2740     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
2741     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
2742     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
2743     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
2744     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
2745     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
2746     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
2747     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
2748 }
2749 
2750 contract OraclizeAddrResolverI {
2751     function getAddress() public returns (address _address);
2752 }
2753 /*
2754 
2755 Begin solidity-cborutils
2756 
2757 https://github.com/smartcontractkit/solidity-cborutils
2758 
2759 MIT License
2760 
2761 Copyright (c) 2018 SmartContract ChainLink, Ltd.
2762 
2763 Permission is hereby granted, free of charge, to any person obtaining a copy
2764 of this software and associated documentation files (the "Software"), to deal
2765 in the Software without restriction, including without limitation the rights
2766 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2767 copies of the Software, and to permit persons to whom the Software is
2768 furnished to do so, subject to the following conditions:
2769 
2770 The above copyright notice and this permission notice shall be included in all
2771 copies or substantial portions of the Software.
2772 
2773 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2774 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2775 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2776 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2777 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2778 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2779 SOFTWARE.
2780 
2781 */
2782 library Buffer {
2783 
2784     struct buffer {
2785         bytes buf;
2786         uint capacity;
2787     }
2788 
2789     function init(buffer memory _buf, uint _capacity) internal pure {
2790         uint capacity = _capacity;
2791         if (capacity % 32 != 0) {
2792             capacity += 32 - (capacity % 32);
2793         }
2794         _buf.capacity = capacity; // Allocate space for the buffer data
2795         assembly {
2796             let ptr := mload(0x40)
2797             mstore(_buf, ptr)
2798             mstore(ptr, 0)
2799             mstore(0x40, add(ptr, capacity))
2800         }
2801     }
2802 
2803     function resize(buffer memory _buf, uint _capacity) private pure {
2804         bytes memory oldbuf = _buf.buf;
2805         init(_buf, _capacity);
2806         append(_buf, oldbuf);
2807     }
2808 
2809     function max(uint _a, uint _b) private pure returns (uint _max) {
2810         if (_a > _b) {
2811             return _a;
2812         }
2813         return _b;
2814     }
2815     /**
2816       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
2817       *      would exceed the capacity of the buffer.
2818       * @param _buf The buffer to append to.
2819       * @param _data The data to append.
2820       * @return The original buffer.
2821       *
2822       */
2823     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
2824         if (_data.length + _buf.buf.length > _buf.capacity) {
2825             resize(_buf, max(_buf.capacity, _data.length) * 2);
2826         }
2827         uint dest;
2828         uint src;
2829         uint len = _data.length;
2830         assembly {
2831             let bufptr := mload(_buf) // Memory address of the buffer data
2832             let buflen := mload(bufptr) // Length of existing buffer data
2833             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
2834             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
2835             src := add(_data, 32)
2836         }
2837         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
2838             assembly {
2839                 mstore(dest, mload(src))
2840             }
2841             dest += 32;
2842             src += 32;
2843         }
2844         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
2845         assembly {
2846             let srcpart := and(mload(src), not(mask))
2847             let destpart := and(mload(dest), mask)
2848             mstore(dest, or(destpart, srcpart))
2849         }
2850         return _buf;
2851     }
2852     /**
2853       *
2854       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
2855       * exceed the capacity of the buffer.
2856       * @param _buf The buffer to append to.
2857       * @param _data The data to append.
2858       * @return The original buffer.
2859       *
2860       */
2861     function append(buffer memory _buf, uint8 _data) internal pure {
2862         if (_buf.buf.length + 1 > _buf.capacity) {
2863             resize(_buf, _buf.capacity * 2);
2864         }
2865         assembly {
2866             let bufptr := mload(_buf) // Memory address of the buffer data
2867             let buflen := mload(bufptr) // Length of existing buffer data
2868             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
2869             mstore8(dest, _data)
2870             mstore(bufptr, add(buflen, 1)) // Update buffer length
2871         }
2872     }
2873     /**
2874       *
2875       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
2876       * exceed the capacity of the buffer.
2877       * @param _buf The buffer to append to.
2878       * @param _data The data to append.
2879       * @return The original buffer.
2880       *
2881       */
2882     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
2883         if (_len + _buf.buf.length > _buf.capacity) {
2884             resize(_buf, max(_buf.capacity, _len) * 2);
2885         }
2886         uint mask = 256 ** _len - 1;
2887         assembly {
2888             let bufptr := mload(_buf) // Memory address of the buffer data
2889             let buflen := mload(bufptr) // Length of existing buffer data
2890             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
2891             mstore(dest, or(and(mload(dest), not(mask)), _data))
2892             mstore(bufptr, add(buflen, _len)) // Update buffer length
2893         }
2894         return _buf;
2895     }
2896 }
2897 
2898 library CBOR {
2899 
2900     using Buffer for Buffer.buffer;
2901 
2902     uint8 private constant MAJOR_TYPE_INT = 0;
2903     uint8 private constant MAJOR_TYPE_MAP = 5;
2904     uint8 private constant MAJOR_TYPE_BYTES = 2;
2905     uint8 private constant MAJOR_TYPE_ARRAY = 4;
2906     uint8 private constant MAJOR_TYPE_STRING = 3;
2907     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
2908     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
2909 
2910     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
2911         if (_value <= 23) {
2912             _buf.append(uint8((_major << 5) | _value));
2913         } else if (_value <= 0xFF) {
2914             _buf.append(uint8((_major << 5) | 24));
2915             _buf.appendInt(_value, 1);
2916         } else if (_value <= 0xFFFF) {
2917             _buf.append(uint8((_major << 5) | 25));
2918             _buf.appendInt(_value, 2);
2919         } else if (_value <= 0xFFFFFFFF) {
2920             _buf.append(uint8((_major << 5) | 26));
2921             _buf.appendInt(_value, 4);
2922         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
2923             _buf.append(uint8((_major << 5) | 27));
2924             _buf.appendInt(_value, 8);
2925         }
2926     }
2927 
2928     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
2929         _buf.append(uint8((_major << 5) | 31));
2930     }
2931 
2932     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
2933         encodeType(_buf, MAJOR_TYPE_INT, _value);
2934     }
2935 
2936     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
2937         if (_value >= 0) {
2938             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
2939         } else {
2940             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
2941         }
2942     }
2943 
2944     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
2945         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
2946         _buf.append(_value);
2947     }
2948 
2949     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
2950         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
2951         _buf.append(bytes(_value));
2952     }
2953 
2954     function startArray(Buffer.buffer memory _buf) internal pure {
2955         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
2956     }
2957 
2958     function startMap(Buffer.buffer memory _buf) internal pure {
2959         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
2960     }
2961 
2962     function endSequence(Buffer.buffer memory _buf) internal pure {
2963         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
2964     }
2965 }
2966 /*
2967 
2968 End solidity-cborutils
2969 
2970 */
2971 contract usingOraclize {
2972 
2973     using CBOR for Buffer.buffer;
2974 
2975     OraclizeI oraclize;
2976     OraclizeAddrResolverI OAR;
2977 
2978     uint constant day = 60 * 60 * 24;
2979     uint constant week = 60 * 60 * 24 * 7;
2980     uint constant month = 60 * 60 * 24 * 30;
2981 
2982     byte constant proofType_NONE = 0x00;
2983     byte constant proofType_Ledger = 0x30;
2984     byte constant proofType_Native = 0xF0;
2985     byte constant proofStorage_IPFS = 0x01;
2986     byte constant proofType_Android = 0x40;
2987     byte constant proofType_TLSNotary = 0x10;
2988 
2989     string oraclize_network_name;
2990     uint8 constant networkID_auto = 0;
2991     uint8 constant networkID_morden = 2;
2992     uint8 constant networkID_mainnet = 1;
2993     uint8 constant networkID_testnet = 2;
2994     uint8 constant networkID_consensys = 161;
2995 
2996     mapping(bytes32 => bytes32) oraclize_randomDS_args;
2997     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
2998 
2999     modifier oraclizeAPI {
3000         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
3001             oraclize_setNetwork(networkID_auto);
3002         }
3003         if (address(oraclize) != OAR.getAddress()) {
3004             oraclize = OraclizeI(OAR.getAddress());
3005         }
3006         _;
3007     }
3008 
3009     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
3010         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
3011         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
3012         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
3013         require(proofVerified);
3014         _;
3015     }
3016 
3017     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
3018       _networkID; // NOTE: Silence the warning and remain backwards compatible
3019       return oraclize_setNetwork();
3020     }
3021 
3022     function oraclize_setNetworkName(string memory _network_name) internal {
3023         oraclize_network_name = _network_name;
3024     }
3025 
3026     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
3027         return oraclize_network_name;
3028     }
3029 
3030     function oraclize_setNetwork() internal returns (bool _networkSet) {
3031         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
3032             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
3033             oraclize_setNetworkName("eth_mainnet");
3034             return true;
3035         }
3036         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
3037             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
3038             oraclize_setNetworkName("eth_ropsten3");
3039             return true;
3040         }
3041         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
3042             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
3043             oraclize_setNetworkName("eth_kovan");
3044             return true;
3045         }
3046         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
3047             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
3048             oraclize_setNetworkName("eth_rinkeby");
3049             return true;
3050         }
3051         if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet
3052             OAR = OraclizeAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
3053             oraclize_setNetworkName("eth_goerli");
3054             return true;
3055         }
3056         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
3057             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
3058             return true;
3059         }
3060         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
3061             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
3062             return true;
3063         }
3064         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
3065             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
3066             return true;
3067         }
3068         return false;
3069     }
3070     /**
3071      * @dev The following `__callback` functions are just placeholders ideally
3072      *      meant to be defined in child contract when proofs are used.
3073      *      The function bodies simply silence compiler warnings.
3074      */
3075     function __callback(bytes32 _myid, string memory _result) public {
3076         __callback(_myid, _result, new bytes(0));
3077     }
3078 
3079     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
3080       _myid; _result; _proof;
3081       oraclize_randomDS_args[bytes32(0)] = bytes32(0);
3082     }
3083 
3084     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
3085         return oraclize.getPrice(_datasource);
3086     }
3087 
3088     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
3089         return oraclize.getPrice(_datasource, _gasLimit);
3090     }
3091 
3092     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
3093         uint price = oraclize.getPrice(_datasource);
3094         if (price > 1 ether + tx.gasprice * 200000) {
3095             return 0; // Unexpectedly high price
3096         }
3097         return oraclize.query.value(price)(0, _datasource, _arg);
3098     }
3099 
3100     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
3101         uint price = oraclize.getPrice(_datasource);
3102         if (price > 1 ether + tx.gasprice * 200000) {
3103             return 0; // Unexpectedly high price
3104         }
3105         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
3106     }
3107 
3108     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3109         uint price = oraclize.getPrice(_datasource,_gasLimit);
3110         if (price > 1 ether + tx.gasprice * _gasLimit) {
3111             return 0; // Unexpectedly high price
3112         }
3113         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
3114     }
3115 
3116     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3117         uint price = oraclize.getPrice(_datasource, _gasLimit);
3118         if (price > 1 ether + tx.gasprice * _gasLimit) {
3119            return 0; // Unexpectedly high price
3120         }
3121         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
3122     }
3123 
3124     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
3125         uint price = oraclize.getPrice(_datasource);
3126         if (price > 1 ether + tx.gasprice * 200000) {
3127             return 0; // Unexpectedly high price
3128         }
3129         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
3130     }
3131 
3132     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
3133         uint price = oraclize.getPrice(_datasource);
3134         if (price > 1 ether + tx.gasprice * 200000) {
3135             return 0; // Unexpectedly high price
3136         }
3137         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
3138     }
3139 
3140     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3141         uint price = oraclize.getPrice(_datasource, _gasLimit);
3142         if (price > 1 ether + tx.gasprice * _gasLimit) {
3143             return 0; // Unexpectedly high price
3144         }
3145         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
3146     }
3147 
3148     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3149         uint price = oraclize.getPrice(_datasource, _gasLimit);
3150         if (price > 1 ether + tx.gasprice * _gasLimit) {
3151             return 0; // Unexpectedly high price
3152         }
3153         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
3154     }
3155 
3156     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
3157         uint price = oraclize.getPrice(_datasource);
3158         if (price > 1 ether + tx.gasprice * 200000) {
3159             return 0; // Unexpectedly high price
3160         }
3161         bytes memory args = stra2cbor(_argN);
3162         return oraclize.queryN.value(price)(0, _datasource, args);
3163     }
3164 
3165     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
3166         uint price = oraclize.getPrice(_datasource);
3167         if (price > 1 ether + tx.gasprice * 200000) {
3168             return 0; // Unexpectedly high price
3169         }
3170         bytes memory args = stra2cbor(_argN);
3171         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
3172     }
3173 
3174     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3175         uint price = oraclize.getPrice(_datasource, _gasLimit);
3176         if (price > 1 ether + tx.gasprice * _gasLimit) {
3177             return 0; // Unexpectedly high price
3178         }
3179         bytes memory args = stra2cbor(_argN);
3180         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
3181     }
3182 
3183     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3184         uint price = oraclize.getPrice(_datasource, _gasLimit);
3185         if (price > 1 ether + tx.gasprice * _gasLimit) {
3186             return 0; // Unexpectedly high price
3187         }
3188         bytes memory args = stra2cbor(_argN);
3189         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
3190     }
3191 
3192     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3193         string[] memory dynargs = new string[](1);
3194         dynargs[0] = _args[0];
3195         return oraclize_query(_datasource, dynargs);
3196     }
3197 
3198     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3199         string[] memory dynargs = new string[](1);
3200         dynargs[0] = _args[0];
3201         return oraclize_query(_timestamp, _datasource, dynargs);
3202     }
3203 
3204     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3205         string[] memory dynargs = new string[](1);
3206         dynargs[0] = _args[0];
3207         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
3208     }
3209 
3210     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3211         string[] memory dynargs = new string[](1);
3212         dynargs[0] = _args[0];
3213         return oraclize_query(_datasource, dynargs, _gasLimit);
3214     }
3215 
3216     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3217         string[] memory dynargs = new string[](2);
3218         dynargs[0] = _args[0];
3219         dynargs[1] = _args[1];
3220         return oraclize_query(_datasource, dynargs);
3221     }
3222 
3223     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3224         string[] memory dynargs = new string[](2);
3225         dynargs[0] = _args[0];
3226         dynargs[1] = _args[1];
3227         return oraclize_query(_timestamp, _datasource, dynargs);
3228     }
3229 
3230     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3231         string[] memory dynargs = new string[](2);
3232         dynargs[0] = _args[0];
3233         dynargs[1] = _args[1];
3234         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
3235     }
3236 
3237     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3238         string[] memory dynargs = new string[](2);
3239         dynargs[0] = _args[0];
3240         dynargs[1] = _args[1];
3241         return oraclize_query(_datasource, dynargs, _gasLimit);
3242     }
3243 
3244     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3245         string[] memory dynargs = new string[](3);
3246         dynargs[0] = _args[0];
3247         dynargs[1] = _args[1];
3248         dynargs[2] = _args[2];
3249         return oraclize_query(_datasource, dynargs);
3250     }
3251 
3252     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3253         string[] memory dynargs = new string[](3);
3254         dynargs[0] = _args[0];
3255         dynargs[1] = _args[1];
3256         dynargs[2] = _args[2];
3257         return oraclize_query(_timestamp, _datasource, dynargs);
3258     }
3259 
3260     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3261         string[] memory dynargs = new string[](3);
3262         dynargs[0] = _args[0];
3263         dynargs[1] = _args[1];
3264         dynargs[2] = _args[2];
3265         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
3266     }
3267 
3268     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3269         string[] memory dynargs = new string[](3);
3270         dynargs[0] = _args[0];
3271         dynargs[1] = _args[1];
3272         dynargs[2] = _args[2];
3273         return oraclize_query(_datasource, dynargs, _gasLimit);
3274     }
3275 
3276     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3277         string[] memory dynargs = new string[](4);
3278         dynargs[0] = _args[0];
3279         dynargs[1] = _args[1];
3280         dynargs[2] = _args[2];
3281         dynargs[3] = _args[3];
3282         return oraclize_query(_datasource, dynargs);
3283     }
3284 
3285     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3286         string[] memory dynargs = new string[](4);
3287         dynargs[0] = _args[0];
3288         dynargs[1] = _args[1];
3289         dynargs[2] = _args[2];
3290         dynargs[3] = _args[3];
3291         return oraclize_query(_timestamp, _datasource, dynargs);
3292     }
3293 
3294     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3295         string[] memory dynargs = new string[](4);
3296         dynargs[0] = _args[0];
3297         dynargs[1] = _args[1];
3298         dynargs[2] = _args[2];
3299         dynargs[3] = _args[3];
3300         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
3301     }
3302 
3303     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3304         string[] memory dynargs = new string[](4);
3305         dynargs[0] = _args[0];
3306         dynargs[1] = _args[1];
3307         dynargs[2] = _args[2];
3308         dynargs[3] = _args[3];
3309         return oraclize_query(_datasource, dynargs, _gasLimit);
3310     }
3311 
3312     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3313         string[] memory dynargs = new string[](5);
3314         dynargs[0] = _args[0];
3315         dynargs[1] = _args[1];
3316         dynargs[2] = _args[2];
3317         dynargs[3] = _args[3];
3318         dynargs[4] = _args[4];
3319         return oraclize_query(_datasource, dynargs);
3320     }
3321 
3322     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3323         string[] memory dynargs = new string[](5);
3324         dynargs[0] = _args[0];
3325         dynargs[1] = _args[1];
3326         dynargs[2] = _args[2];
3327         dynargs[3] = _args[3];
3328         dynargs[4] = _args[4];
3329         return oraclize_query(_timestamp, _datasource, dynargs);
3330     }
3331 
3332     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3333         string[] memory dynargs = new string[](5);
3334         dynargs[0] = _args[0];
3335         dynargs[1] = _args[1];
3336         dynargs[2] = _args[2];
3337         dynargs[3] = _args[3];
3338         dynargs[4] = _args[4];
3339         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
3340     }
3341 
3342     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3343         string[] memory dynargs = new string[](5);
3344         dynargs[0] = _args[0];
3345         dynargs[1] = _args[1];
3346         dynargs[2] = _args[2];
3347         dynargs[3] = _args[3];
3348         dynargs[4] = _args[4];
3349         return oraclize_query(_datasource, dynargs, _gasLimit);
3350     }
3351 
3352     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
3353         uint price = oraclize.getPrice(_datasource);
3354         if (price > 1 ether + tx.gasprice * 200000) {
3355             return 0; // Unexpectedly high price
3356         }
3357         bytes memory args = ba2cbor(_argN);
3358         return oraclize.queryN.value(price)(0, _datasource, args);
3359     }
3360 
3361     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
3362         uint price = oraclize.getPrice(_datasource);
3363         if (price > 1 ether + tx.gasprice * 200000) {
3364             return 0; // Unexpectedly high price
3365         }
3366         bytes memory args = ba2cbor(_argN);
3367         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
3368     }
3369 
3370     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3371         uint price = oraclize.getPrice(_datasource, _gasLimit);
3372         if (price > 1 ether + tx.gasprice * _gasLimit) {
3373             return 0; // Unexpectedly high price
3374         }
3375         bytes memory args = ba2cbor(_argN);
3376         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
3377     }
3378 
3379     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3380         uint price = oraclize.getPrice(_datasource, _gasLimit);
3381         if (price > 1 ether + tx.gasprice * _gasLimit) {
3382             return 0; // Unexpectedly high price
3383         }
3384         bytes memory args = ba2cbor(_argN);
3385         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
3386     }
3387 
3388     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3389         bytes[] memory dynargs = new bytes[](1);
3390         dynargs[0] = _args[0];
3391         return oraclize_query(_datasource, dynargs);
3392     }
3393 
3394     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3395         bytes[] memory dynargs = new bytes[](1);
3396         dynargs[0] = _args[0];
3397         return oraclize_query(_timestamp, _datasource, dynargs);
3398     }
3399 
3400     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3401         bytes[] memory dynargs = new bytes[](1);
3402         dynargs[0] = _args[0];
3403         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
3404     }
3405 
3406     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3407         bytes[] memory dynargs = new bytes[](1);
3408         dynargs[0] = _args[0];
3409         return oraclize_query(_datasource, dynargs, _gasLimit);
3410     }
3411 
3412     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3413         bytes[] memory dynargs = new bytes[](2);
3414         dynargs[0] = _args[0];
3415         dynargs[1] = _args[1];
3416         return oraclize_query(_datasource, dynargs);
3417     }
3418 
3419     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3420         bytes[] memory dynargs = new bytes[](2);
3421         dynargs[0] = _args[0];
3422         dynargs[1] = _args[1];
3423         return oraclize_query(_timestamp, _datasource, dynargs);
3424     }
3425 
3426     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3427         bytes[] memory dynargs = new bytes[](2);
3428         dynargs[0] = _args[0];
3429         dynargs[1] = _args[1];
3430         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
3431     }
3432 
3433     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3434         bytes[] memory dynargs = new bytes[](2);
3435         dynargs[0] = _args[0];
3436         dynargs[1] = _args[1];
3437         return oraclize_query(_datasource, dynargs, _gasLimit);
3438     }
3439 
3440     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3441         bytes[] memory dynargs = new bytes[](3);
3442         dynargs[0] = _args[0];
3443         dynargs[1] = _args[1];
3444         dynargs[2] = _args[2];
3445         return oraclize_query(_datasource, dynargs);
3446     }
3447 
3448     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3449         bytes[] memory dynargs = new bytes[](3);
3450         dynargs[0] = _args[0];
3451         dynargs[1] = _args[1];
3452         dynargs[2] = _args[2];
3453         return oraclize_query(_timestamp, _datasource, dynargs);
3454     }
3455 
3456     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3457         bytes[] memory dynargs = new bytes[](3);
3458         dynargs[0] = _args[0];
3459         dynargs[1] = _args[1];
3460         dynargs[2] = _args[2];
3461         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
3462     }
3463 
3464     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3465         bytes[] memory dynargs = new bytes[](3);
3466         dynargs[0] = _args[0];
3467         dynargs[1] = _args[1];
3468         dynargs[2] = _args[2];
3469         return oraclize_query(_datasource, dynargs, _gasLimit);
3470     }
3471 
3472     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3473         bytes[] memory dynargs = new bytes[](4);
3474         dynargs[0] = _args[0];
3475         dynargs[1] = _args[1];
3476         dynargs[2] = _args[2];
3477         dynargs[3] = _args[3];
3478         return oraclize_query(_datasource, dynargs);
3479     }
3480 
3481     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3482         bytes[] memory dynargs = new bytes[](4);
3483         dynargs[0] = _args[0];
3484         dynargs[1] = _args[1];
3485         dynargs[2] = _args[2];
3486         dynargs[3] = _args[3];
3487         return oraclize_query(_timestamp, _datasource, dynargs);
3488     }
3489 
3490     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3491         bytes[] memory dynargs = new bytes[](4);
3492         dynargs[0] = _args[0];
3493         dynargs[1] = _args[1];
3494         dynargs[2] = _args[2];
3495         dynargs[3] = _args[3];
3496         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
3497     }
3498 
3499     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3500         bytes[] memory dynargs = new bytes[](4);
3501         dynargs[0] = _args[0];
3502         dynargs[1] = _args[1];
3503         dynargs[2] = _args[2];
3504         dynargs[3] = _args[3];
3505         return oraclize_query(_datasource, dynargs, _gasLimit);
3506     }
3507 
3508     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3509         bytes[] memory dynargs = new bytes[](5);
3510         dynargs[0] = _args[0];
3511         dynargs[1] = _args[1];
3512         dynargs[2] = _args[2];
3513         dynargs[3] = _args[3];
3514         dynargs[4] = _args[4];
3515         return oraclize_query(_datasource, dynargs);
3516     }
3517 
3518     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
3519         bytes[] memory dynargs = new bytes[](5);
3520         dynargs[0] = _args[0];
3521         dynargs[1] = _args[1];
3522         dynargs[2] = _args[2];
3523         dynargs[3] = _args[3];
3524         dynargs[4] = _args[4];
3525         return oraclize_query(_timestamp, _datasource, dynargs);
3526     }
3527 
3528     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3529         bytes[] memory dynargs = new bytes[](5);
3530         dynargs[0] = _args[0];
3531         dynargs[1] = _args[1];
3532         dynargs[2] = _args[2];
3533         dynargs[3] = _args[3];
3534         dynargs[4] = _args[4];
3535         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
3536     }
3537 
3538     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
3539         bytes[] memory dynargs = new bytes[](5);
3540         dynargs[0] = _args[0];
3541         dynargs[1] = _args[1];
3542         dynargs[2] = _args[2];
3543         dynargs[3] = _args[3];
3544         dynargs[4] = _args[4];
3545         return oraclize_query(_datasource, dynargs, _gasLimit);
3546     }
3547 
3548     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
3549         return oraclize.setProofType(_proofP);
3550     }
3551 
3552 
3553     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
3554         return oraclize.cbAddress();
3555     }
3556 
3557     function getCodeSize(address _addr) view internal returns (uint _size) {
3558         assembly {
3559             _size := extcodesize(_addr)
3560         }
3561     }
3562 
3563     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
3564         return oraclize.setCustomGasPrice(_gasPrice);
3565     }
3566 
3567     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
3568         return oraclize.randomDS_getSessionPubKeyHash();
3569     }
3570 
3571     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
3572         bytes memory tmp = bytes(_a);
3573         uint160 iaddr = 0;
3574         uint160 b1;
3575         uint160 b2;
3576         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
3577             iaddr *= 256;
3578             b1 = uint160(uint8(tmp[i]));
3579             b2 = uint160(uint8(tmp[i + 1]));
3580             if ((b1 >= 97) && (b1 <= 102)) {
3581                 b1 -= 87;
3582             } else if ((b1 >= 65) && (b1 <= 70)) {
3583                 b1 -= 55;
3584             } else if ((b1 >= 48) && (b1 <= 57)) {
3585                 b1 -= 48;
3586             }
3587             if ((b2 >= 97) && (b2 <= 102)) {
3588                 b2 -= 87;
3589             } else if ((b2 >= 65) && (b2 <= 70)) {
3590                 b2 -= 55;
3591             } else if ((b2 >= 48) && (b2 <= 57)) {
3592                 b2 -= 48;
3593             }
3594             iaddr += (b1 * 16 + b2);
3595         }
3596         return address(iaddr);
3597     }
3598 
3599     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
3600         bytes memory a = bytes(_a);
3601         bytes memory b = bytes(_b);
3602         uint minLength = a.length;
3603         if (b.length < minLength) {
3604             minLength = b.length;
3605         }
3606         for (uint i = 0; i < minLength; i ++) {
3607             if (a[i] < b[i]) {
3608                 return -1;
3609             } else if (a[i] > b[i]) {
3610                 return 1;
3611             }
3612         }
3613         if (a.length < b.length) {
3614             return -1;
3615         } else if (a.length > b.length) {
3616             return 1;
3617         } else {
3618             return 0;
3619         }
3620     }
3621 
3622     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
3623         bytes memory h = bytes(_haystack);
3624         bytes memory n = bytes(_needle);
3625         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
3626             return -1;
3627         } else if (h.length > (2 ** 128 - 1)) {
3628             return -1;
3629         } else {
3630             uint subindex = 0;
3631             for (uint i = 0; i < h.length; i++) {
3632                 if (h[i] == n[0]) {
3633                     subindex = 1;
3634                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
3635                         subindex++;
3636                     }
3637                     if (subindex == n.length) {
3638                         return int(i);
3639                     }
3640                 }
3641             }
3642             return -1;
3643         }
3644     }
3645 
3646     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
3647         return strConcat(_a, _b, "", "", "");
3648     }
3649 
3650     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
3651         return strConcat(_a, _b, _c, "", "");
3652     }
3653 
3654     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
3655         return strConcat(_a, _b, _c, _d, "");
3656     }
3657 
3658     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
3659         bytes memory _ba = bytes(_a);
3660         bytes memory _bb = bytes(_b);
3661         bytes memory _bc = bytes(_c);
3662         bytes memory _bd = bytes(_d);
3663         bytes memory _be = bytes(_e);
3664         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
3665         bytes memory babcde = bytes(abcde);
3666         uint k = 0;
3667         uint i = 0;
3668         for (i = 0; i < _ba.length; i++) {
3669             babcde[k++] = _ba[i];
3670         }
3671         for (i = 0; i < _bb.length; i++) {
3672             babcde[k++] = _bb[i];
3673         }
3674         for (i = 0; i < _bc.length; i++) {
3675             babcde[k++] = _bc[i];
3676         }
3677         for (i = 0; i < _bd.length; i++) {
3678             babcde[k++] = _bd[i];
3679         }
3680         for (i = 0; i < _be.length; i++) {
3681             babcde[k++] = _be[i];
3682         }
3683         return string(babcde);
3684     }
3685 
3686     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
3687         return safeParseInt(_a, 0);
3688     }
3689 
3690     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
3691         bytes memory bresult = bytes(_a);
3692         uint mint = 0;
3693         bool decimals = false;
3694         for (uint i = 0; i < bresult.length; i++) {
3695             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
3696                 if (decimals) {
3697                    if (_b == 0) break;
3698                     else _b--;
3699                 }
3700                 mint *= 10;
3701                 mint += uint(uint8(bresult[i])) - 48;
3702             } else if (uint(uint8(bresult[i])) == 46) {
3703                 require(!decimals, 'More than one decimal encountered in string!');
3704                 decimals = true;
3705             } else {
3706                 revert("Non-numeral character encountered in string!");
3707             }
3708         }
3709         if (_b > 0) {
3710             mint *= 10 ** _b;
3711         }
3712         return mint;
3713     }
3714 
3715     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
3716         return parseInt(_a, 0);
3717     }
3718 
3719     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
3720         bytes memory bresult = bytes(_a);
3721         uint mint = 0;
3722         bool decimals = false;
3723         for (uint i = 0; i < bresult.length; i++) {
3724             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
3725                 if (decimals) {
3726                    if (_b == 0) {
3727                        break;
3728                    } else {
3729                        _b--;
3730                    }
3731                 }
3732                 mint *= 10;
3733                 mint += uint(uint8(bresult[i])) - 48;
3734             } else if (uint(uint8(bresult[i])) == 46) {
3735                 decimals = true;
3736             }
3737         }
3738         if (_b > 0) {
3739             mint *= 10 ** _b;
3740         }
3741         return mint;
3742     }
3743 
3744     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
3745         if (_i == 0) {
3746             return "0";
3747         }
3748         uint j = _i;
3749         uint len;
3750         while (j != 0) {
3751             len++;
3752             j /= 10;
3753         }
3754         bytes memory bstr = new bytes(len);
3755         uint k = len - 1;
3756         while (_i != 0) {
3757             bstr[k--] = byte(uint8(48 + _i % 10));
3758             _i /= 10;
3759         }
3760         return string(bstr);
3761     }
3762 
3763     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
3764         safeMemoryCleaner();
3765         Buffer.buffer memory buf;
3766         Buffer.init(buf, 1024);
3767         buf.startArray();
3768         for (uint i = 0; i < _arr.length; i++) {
3769             buf.encodeString(_arr[i]);
3770         }
3771         buf.endSequence();
3772         return buf.buf;
3773     }
3774 
3775     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
3776         safeMemoryCleaner();
3777         Buffer.buffer memory buf;
3778         Buffer.init(buf, 1024);
3779         buf.startArray();
3780         for (uint i = 0; i < _arr.length; i++) {
3781             buf.encodeBytes(_arr[i]);
3782         }
3783         buf.endSequence();
3784         return buf.buf;
3785     }
3786 
3787     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
3788         require((_nbytes > 0) && (_nbytes <= 32));
3789         _delay *= 10; // Convert from seconds to ledger timer ticks
3790         bytes memory nbytes = new bytes(1);
3791         nbytes[0] = byte(uint8(_nbytes));
3792         bytes memory unonce = new bytes(32);
3793         bytes memory sessionKeyHash = new bytes(32);
3794         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
3795         assembly {
3796             mstore(unonce, 0x20)
3797             /*
3798              The following variables can be relaxed.
3799              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
3800              for an idea on how to override and replace commit hash variables.
3801             */
3802             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
3803             mstore(sessionKeyHash, 0x20)
3804             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
3805         }
3806         bytes memory delay = new bytes(32);
3807         assembly {
3808             mstore(add(delay, 0x20), _delay)
3809         }
3810         bytes memory delay_bytes8 = new bytes(8);
3811         copyBytes(delay, 24, 8, delay_bytes8, 0);
3812         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
3813         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
3814         bytes memory delay_bytes8_left = new bytes(8);
3815         assembly {
3816             let x := mload(add(delay_bytes8, 0x20))
3817             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
3818             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
3819             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
3820             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
3821             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
3822             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
3823             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
3824             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
3825         }
3826         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
3827         return queryId;
3828     }
3829 
3830     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
3831         oraclize_randomDS_args[_queryId] = _commitment;
3832     }
3833 
3834     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
3835         bool sigok;
3836         address signer;
3837         bytes32 sigr;
3838         bytes32 sigs;
3839         bytes memory sigr_ = new bytes(32);
3840         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
3841         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
3842         bytes memory sigs_ = new bytes(32);
3843         offset += 32 + 2;
3844         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
3845         assembly {
3846             sigr := mload(add(sigr_, 32))
3847             sigs := mload(add(sigs_, 32))
3848         }
3849         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
3850         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
3851             return true;
3852         } else {
3853             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
3854             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
3855         }
3856     }
3857 
3858     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
3859         bool sigok;
3860         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
3861         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
3862         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
3863         bytes memory appkey1_pubkey = new bytes(64);
3864         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
3865         bytes memory tosign2 = new bytes(1 + 65 + 32);
3866         tosign2[0] = byte(uint8(1)); //role
3867         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
3868         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
3869         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
3870         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
3871         if (!sigok) {
3872             return false;
3873         }
3874         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
3875         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
3876         bytes memory tosign3 = new bytes(1 + 65);
3877         tosign3[0] = 0xFE;
3878         copyBytes(_proof, 3, 65, tosign3, 1);
3879         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
3880         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
3881         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
3882         return sigok;
3883     }
3884 
3885     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
3886         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
3887         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
3888             return 1;
3889         }
3890         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
3891         if (!proofVerified) {
3892             return 2;
3893         }
3894         return 0;
3895     }
3896 
3897     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
3898         bool match_ = true;
3899         require(_prefix.length == _nRandomBytes);
3900         for (uint256 i = 0; i< _nRandomBytes; i++) {
3901             if (_content[i] != _prefix[i]) {
3902                 match_ = false;
3903             }
3904         }
3905         return match_;
3906     }
3907 
3908     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
3909         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
3910         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
3911         bytes memory keyhash = new bytes(32);
3912         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
3913         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
3914             return false;
3915         }
3916         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
3917         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
3918         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
3919         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
3920             return false;
3921         }
3922         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
3923         // This is to verify that the computed args match with the ones specified in the query.
3924         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
3925         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
3926         bytes memory sessionPubkey = new bytes(64);
3927         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
3928         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
3929         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
3930         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
3931             delete oraclize_randomDS_args[_queryId];
3932         } else return false;
3933         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
3934         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
3935         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
3936         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
3937             return false;
3938         }
3939         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
3940         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
3941             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
3942         }
3943         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
3944     }
3945     /*
3946      The following function has been written by Alex Beregszaszi, use it under the terms of the MIT license
3947     */
3948     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
3949         uint minLength = _length + _toOffset;
3950         require(_to.length >= minLength); // Buffer too small. Should be a better way?
3951         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
3952         uint j = 32 + _toOffset;
3953         while (i < (32 + _fromOffset + _length)) {
3954             assembly {
3955                 let tmp := mload(add(_from, i))
3956                 mstore(add(_to, j), tmp)
3957             }
3958             i += 32;
3959             j += 32;
3960         }
3961         return _to;
3962     }
3963     /*
3964      The following function has been written by Alex Beregszaszi, use it under the terms of the MIT license
3965      Duplicate Solidity's ecrecover, but catching the CALL return value
3966     */
3967     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
3968         /*
3969          We do our own memory management here. Solidity uses memory offset
3970          0x40 to store the current end of memory. We write past it (as
3971          writes are memory extensions), but don't update the offset so
3972          Solidity will reuse it. The memory used here is only needed for
3973          this context.
3974          FIXME: inline assembly can't access return values
3975         */
3976         bool ret;
3977         address addr;
3978         assembly {
3979             let size := mload(0x40)
3980             mstore(size, _hash)
3981             mstore(add(size, 32), _v)
3982             mstore(add(size, 64), _r)
3983             mstore(add(size, 96), _s)
3984             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
3985             addr := mload(size)
3986         }
3987         return (ret, addr);
3988     }
3989     /*
3990      The following function has been written by Alex Beregszaszi, use it under the terms of the MIT license
3991     */
3992     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
3993         bytes32 r;
3994         bytes32 s;
3995         uint8 v;
3996         if (_sig.length != 65) {
3997             return (false, address(0));
3998         }
3999         /*
4000          The signature format is a compact form of:
4001            {bytes32 r}{bytes32 s}{uint8 v}
4002          Compact means, uint8 is not padded to 32 bytes.
4003         */
4004         assembly {
4005             r := mload(add(_sig, 32))
4006             s := mload(add(_sig, 64))
4007             /*
4008              Here we are loading the last 32 bytes. We exploit the fact that
4009              'mload' will pad with zeroes if we overread.
4010              There is no 'mload8' to do this, but that would be nicer.
4011             */
4012             v := byte(0, mload(add(_sig, 96)))
4013             /*
4014               Alternative solution:
4015               'byte' is not working due to the Solidity parser, so lets
4016               use the second best option, 'and'
4017               v := and(mload(add(_sig, 65)), 255)
4018             */
4019         }
4020         /*
4021          albeit non-transactional signatures are not specified by the YP, one would expect it
4022          to match the YP range of [27, 28]
4023          geth uses [0, 1] and some clients have followed. This might change, see:
4024          https://github.com/ethereum/go-ethereum/issues/2053
4025         */
4026         if (v < 27) {
4027             v += 27;
4028         }
4029         if (v != 27 && v != 28) {
4030             return (false, address(0));
4031         }
4032         return safer_ecrecover(_hash, v, r, s);
4033     }
4034 
4035     function safeMemoryCleaner() internal pure {
4036         assembly {
4037             let fmem := mload(0x40)
4038             codecopy(fmem, codesize, sub(msize, fmem))
4039         }
4040     }
4041 }
4042 /*
4043 
4044 END ORACLIZE_API
4045 
4046 */
4047 
4048 // File: externals/base64.sol
4049 
4050 pragma solidity ^0.5.10;
4051 
4052 /**
4053  * This method was modified from the GPLv3 solidity code found in this repository
4054  * https://github.com/vcealicu/melonport-price-feed/blob/master/pricefeed/PriceFeed.sol
4055  */
4056 
4057 /// @title Base64 provides base 64 decoding functionality.
4058 contract Base64 {
4059     bytes constant BASE64_DECODE_CHAR = hex"000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e003e003f3435363738393a3b3c3d00000000000000000102030405060708090a0b0c0d0e0f10111213141516171819000000003f001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f30313233";
4060 
4061     /// @return decoded array of bytes.
4062     /// @param _encoded base 64 encoded array of bytes.
4063     function _base64decode(bytes memory _encoded) internal pure returns (bytes memory) {
4064         byte v1;
4065         byte v2;
4066         byte v3;
4067         byte v4;
4068         uint length = _encoded.length;
4069         bytes memory result = new bytes(length);
4070         uint index;
4071 
4072         // base64 encoded strings can't be length 0 and they must be divisble by 4
4073         require(length > 0  && length % 4 == 0, "invalid base64 encoding");
4074 
4075         if (keccak256(abi.encodePacked(_encoded[length - 2])) == keccak256("=")) {
4076             length -= 2;
4077         } else if (keccak256(abi.encodePacked(_encoded[length - 1])) == keccak256("=")) {
4078             length -= 1;
4079         }
4080 
4081         uint count = length >> 2 << 2;
4082         uint i;
4083 
4084         for (i = 0; i < count;) {
4085             v1 = BASE64_DECODE_CHAR[uint8(_encoded[i++])];
4086             v2 = BASE64_DECODE_CHAR[uint8(_encoded[i++])];
4087             v3 = BASE64_DECODE_CHAR[uint8(_encoded[i++])];
4088             v4 = BASE64_DECODE_CHAR[uint8(_encoded[i++])];
4089 
4090             result[index++] = (v1 << 2 | v2 >> 4) & 0xff;
4091             result[index++] = (v2 << 4 | v3 >> 2) & 0xff;
4092             result[index++] = (v3 << 6 | v4) & 0xff;
4093         }
4094 
4095         if (length - count == 2) {
4096             v1 = BASE64_DECODE_CHAR[uint8(_encoded[i++])];
4097             v2 = BASE64_DECODE_CHAR[uint8(_encoded[i++])];
4098 
4099             result[index++] = (v1 << 2 | v2 >> 4) & 0xff;
4100         } else if (length - count == 3) {
4101             v1 = BASE64_DECODE_CHAR[uint8(_encoded[i++])];
4102             v2 = BASE64_DECODE_CHAR[uint8(_encoded[i++])];
4103             v3 = BASE64_DECODE_CHAR[uint8(_encoded[i++])];
4104 
4105             result[index++] = (v1 << 2 | v2 >> 4) & 0xff;
4106             result[index++] = (v2 << 4 | v3 >> 2) & 0xff;
4107         }
4108 
4109         // Set to correct length.
4110         assembly {
4111             mstore(result, index)
4112         }
4113 
4114         return result;
4115     }
4116 }
4117 
4118 // File: oracle.sol
4119 
4120 /**
4121  *  Oracle - The Consumer Contract Wallet
4122  *  Copyright (C) 2019 The Contract Wallet Company Limited
4123  *
4124  *  This program is free software: you can redistribute it and/or modify
4125  *  it under the terms of the GNU General Public License as published by
4126  *  the Free Software Foundation, either version 3 of the License, or
4127  *  (at your option) any later version.
4128  *
4129  *  This program is distributed in the hope that it will be useful,
4130  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
4131  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
4132  *  GNU General Public License for more details.
4133  *
4134  *  You should have received a copy of the GNU General Public License
4135  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
4136  */
4137 
4138 pragma solidity ^0.5.10;
4139 
4140 
4141 
4142 
4143 
4144 
4145 
4146 
4147 
4148 
4149 
4150 /// @title Oracle provides asset exchange rates and conversion functionality.
4151 contract Oracle is ENSResolvable, usingOraclize, Transferrable, Base64, Date, Controllable, ParseIntScientific, TokenWhitelistable {
4152     using strings for *;
4153     using SafeMath for uint256;
4154 
4155 
4156     /*******************/
4157     /*     Events     */
4158     /*****************/
4159 
4160     event SetGasPrice(address _sender, uint _gasPrice);
4161 
4162     event RequestedUpdate(string _symbol, bytes32 _queryID);
4163     event FailedUpdateRequest(string _reason);
4164 
4165     event VerifiedProof(bytes _publicKey, string _result);
4166 
4167     event SetCryptoComparePublicKey(address _sender, bytes _publicKey);
4168 
4169     event Claimed(address _to, address _asset, uint _amount);
4170 
4171     /**********************/
4172     /*     Constants     */
4173     /********************/
4174 
4175     uint constant private _PROOF_LEN = 165;
4176     uint constant private _ECDSA_SIG_LEN = 65;
4177     uint constant private _ENCODING_BYTES = 2;
4178     uint constant private _HEADERS_LEN = _PROOF_LEN - 2 * _ENCODING_BYTES - _ECDSA_SIG_LEN; // 2 bytes encoding headers length + 2 for signature.
4179     uint constant private _DIGEST_BASE64_LEN = 44; //base64 encoding of the SHA256 hash (32-bytes) of the result: fixed length.
4180     uint constant private _DIGEST_OFFSET = _HEADERS_LEN - _DIGEST_BASE64_LEN; // the starting position of the result hash in the headers string.
4181 
4182     uint constant private _MAX_BYTE_SIZE = 256; //for calculating length encoding
4183 
4184     // This is how the cryptocompare json begins
4185     bytes32 constant private _PREFIX_HASH = keccak256("{\"ETH\":");
4186 
4187     bytes public cryptoCompareAPIPublicKey;
4188     mapping(bytes32 => address) private _queryToToken;
4189 
4190     /// @notice Construct the oracle with multiple controllers, address resolver and custom gas price.
4191     /// @param _resolver_ is the address of the oraclize resolver
4192     /// @param _ens_ is the address of the ENS.
4193     /// @param _controllerNode_ is the ENS node corresponding to the Controller.
4194     /// @param _tokenWhitelistNode_ is the ENS corresponding to the Token Whitelist.
4195     constructor(address _resolver_, address _ens_, bytes32 _controllerNode_, bytes32 _tokenWhitelistNode_) ENSResolvable(_ens_) Controllable(_controllerNode_) TokenWhitelistable(_tokenWhitelistNode_) public {
4196         cryptoCompareAPIPublicKey = hex"a0f4f688350018ad1b9785991c0bde5f704b005dc79972b114dbed4a615a983710bfc647ebe5a320daa28771dce6a2d104f5efa2e4a85ba3760b76d46f8571ca";
4197         OAR = OraclizeAddrResolverI(_resolver_);
4198         oraclize_setCustomGasPrice(10000000000);
4199         oraclize_setProof(proofType_Native);
4200     }
4201 
4202     /// @notice Updates the Crypto Compare public API key.
4203     /// @param _publicKey new Crypto Compare public API key
4204     function updateCryptoCompareAPIPublicKey(bytes calldata _publicKey) external onlyAdmin {
4205         cryptoCompareAPIPublicKey = _publicKey;
4206         emit SetCryptoComparePublicKey(msg.sender, _publicKey);
4207     }
4208 
4209     /// @notice Sets the gas price used by Oraclize query.
4210     /// @param _gasPrice in wei for Oraclize
4211     function setCustomGasPrice(uint _gasPrice) external onlyController {
4212         oraclize_setCustomGasPrice(_gasPrice);
4213         emit SetGasPrice(msg.sender, _gasPrice);
4214     }
4215 
4216     /// @notice Update ERC20 token exchange rates for all supported tokens.
4217     /// @param _gasLimit the gas limit is passed, this is used for the Oraclize callback
4218     function updateTokenRates(uint _gasLimit) external payable onlyController {
4219         _updateTokenRates(_gasLimit);
4220     }
4221 
4222     /// @notice Update ERC20 token exchange rates for the list of tokens provided.
4223     /// @param _gasLimit the gas limit is passed, this is used for the Oraclize callback
4224     /// @param _tokenList the list of tokens that need to be updated
4225     function updateTokenRatesList(uint _gasLimit, address[] calldata _tokenList) external payable onlyController {
4226         _updateTokenRatesList(_gasLimit, _tokenList);
4227     }
4228 
4229     /// @notice Withdraw tokens from the smart contract to the specified account.
4230     function claim(address payable _to, address _asset, uint _amount) external onlyAdmin {
4231         _safeTransfer(_to, _asset, _amount);
4232         emit Claimed(_to, _asset, _amount);
4233     }
4234 
4235     /// @notice Handle Oraclize query callback and verifiy the provided origin proof.
4236     /// @param _queryID Oraclize query ID.
4237     /// @param _result query result in JSON format.
4238     /// @param _proof origin proof from crypto compare.
4239     // solium-disable-next-line mixedcase
4240     function __callback(bytes32 _queryID, string memory _result, bytes memory _proof) public {
4241         // Require that the caller is the Oraclize contract.
4242         require(msg.sender == oraclize_cbAddress(), "sender is not oraclize");
4243         // Use the query ID to find the matching token address.
4244         address token = _queryToToken[_queryID];
4245         // Get the corresponding token object.
4246         ( , , , bool available, , , uint256 lastUpdate) = _getTokenInfo(token);
4247         require(available, "token must be available");
4248 
4249         bool valid;
4250         uint timestamp;
4251         (valid, timestamp) = _verifyProof(_result, _proof, cryptoCompareAPIPublicKey, lastUpdate);
4252 
4253         // Require that the proof is valid.
4254         if (valid) {
4255             // Parse the JSON result to get the rate in wei.
4256             uint256 parsedRate = _parseIntScientificWei(parseRate(_result));
4257             // Set the update time of the token rate.
4258             uint256 parsedLastUpdate = timestamp;
4259             // Remove query from the list.
4260             delete _queryToToken[_queryID];
4261 
4262             _updateTokenRate(token, parsedRate, parsedLastUpdate);
4263         }
4264     }
4265 
4266     /// @notice Extracts JSON rate value from the response object.
4267     /// @param _json body of the JSON response from the CryptoCompare API.
4268     function parseRate(string memory _json) internal pure returns (string memory) {
4269 
4270         uint jsonLen = abi.encodePacked(_json).length;
4271         //{"ETH":}.length = 8, assuming a (maximum of) 18 digit prevision
4272         require(jsonLen > 8 && jsonLen <= 28, "misformatted input");
4273 
4274         bytes memory jsonPrefix = new bytes(7);
4275         copyBytes(abi.encodePacked(_json), 0, 7, jsonPrefix, 0);
4276         require(keccak256(jsonPrefix) == _PREFIX_HASH, "prefix mismatch");
4277 
4278         strings.slice memory body = _json.toSlice();
4279         body.split(":".toSlice());
4280         //we are sure that ':' is included in the string, body now contains the rate+'}'
4281         jsonLen = body._len;
4282         body.until("}".toSlice());
4283         require(body._len == jsonLen - 1, "not json format");
4284         //ensure that the json is properly terminated with a '}'
4285         return body.toString();
4286     }
4287 
4288     /// @notice Re-usable helper function that performs the Oraclize Query.
4289     /// @param _gasLimit the gas limit is passed, this is used for the Oraclize callback
4290     function _updateTokenRates(uint _gasLimit) private {
4291         address[] memory tokenAddresses = _tokenAddressArray();
4292         // Check if there are any existing tokens.
4293         if (tokenAddresses.length == 0) {
4294             // Emit a query failure event.
4295             emit FailedUpdateRequest("no tokens");
4296             // Check if the contract has enough Ether to pay for the query.
4297         } else if (oraclize_getPrice("URL") * tokenAddresses.length > address(this).balance) {
4298             // Emit a query failure event.
4299             emit FailedUpdateRequest("insufficient balance");
4300         } else {
4301             // Set up the cryptocompare API query strings.
4302             strings.slice memory apiPrefix = "https://min-api.cryptocompare.com/data/price?fsym=".toSlice();
4303             strings.slice memory apiSuffix = "&tsyms=ETH&sign=true".toSlice();
4304 
4305             // Create a new oraclize query for each supported token.
4306             for (uint i = 0; i < tokenAddresses.length; i++) {
4307                 // Store the token symbol used in the query.
4308                 (string memory symbol, , , , , , ) = _getTokenInfo(tokenAddresses[i]);
4309 
4310                 strings.slice memory sym = symbol.toSlice();
4311                 // Create a new oraclize query from the component strings.
4312                 bytes32 queryID = oraclize_query("URL", apiPrefix.concat(sym).toSlice().concat(apiSuffix), _gasLimit);
4313                 // Store the query ID together with the associated token address.
4314                 _queryToToken[queryID] = tokenAddresses[i];
4315                 // Emit the query success event.
4316                 emit RequestedUpdate(sym.toString(), queryID);
4317             }
4318         }
4319     }
4320 
4321     /// @notice Re-usable helper function that performs the Oraclize Query for a specific list of tokens.
4322     /// @param _gasLimit the gas limit is passed, this is used for the Oraclize callback.
4323     /// @param _tokenList the list of tokens that need to be updated.
4324     function _updateTokenRatesList(uint _gasLimit, address[] memory _tokenList) private {
4325         // Check if there are any existing tokens.
4326         if (_tokenList.length == 0) {
4327             // Emit a query failure event.
4328             emit FailedUpdateRequest("empty token list");
4329         // Check if the contract has enough Ether to pay for the query.
4330         } else if (oraclize_getPrice("URL") * _tokenList.length > address(this).balance) {
4331             // Emit a query failure event.
4332             emit FailedUpdateRequest("insufficient balance");
4333         } else {
4334             // Set up the cryptocompare API query strings.
4335             strings.slice memory apiPrefix = "https://min-api.cryptocompare.com/data/price?fsym=".toSlice();
4336             strings.slice memory apiSuffix = "&tsyms=ETH&sign=true".toSlice();
4337 
4338             // Create a new oraclize query for each supported token.
4339             for (uint i = 0; i < _tokenList.length; i++) {
4340                 //token must exist, revert if it doesn't
4341                 (string memory tokenSymbol, , , bool available , , , ) = _getTokenInfo(_tokenList[i]);
4342                 require(available, "token must be available");
4343                 // Store the token symbol used in the query.
4344                 strings.slice memory symbol = tokenSymbol.toSlice();
4345                 // Create a new oraclize query from the component strings.
4346                 bytes32 queryID = oraclize_query("URL", apiPrefix.concat(symbol).toSlice().concat(apiSuffix), _gasLimit);
4347                 // Store the query ID together with the associated token address.
4348                 _queryToToken[queryID] = _tokenList[i];
4349                 // Emit the query success event.
4350                 emit RequestedUpdate(symbol.toString(), queryID);
4351             }
4352         }
4353     }
4354 
4355     /// @notice Verify the origin proof returned by the cryptocompare API.
4356     /// @param _result query result in JSON format.
4357     /// @param _proof origin proof from cryptocompare.
4358     /// @param _publicKey cryptocompare public key.
4359     /// @param _lastUpdate timestamp of the last time the requested token was updated.
4360     function _verifyProof(string memory _result, bytes memory _proof, bytes memory _publicKey, uint _lastUpdate) private returns (bool, uint) {
4361 
4362         // expecting fixed length proofs
4363         if (_proof.length != _PROOF_LEN) {
4364             revert("invalid proof length");
4365         }
4366 
4367         // proof should be 65 bytes long: R (32 bytes) + S (32 bytes) + v (1 byte)
4368         if (uint(uint8(_proof[1])) != _ECDSA_SIG_LEN) {
4369             revert("invalid signature length");
4370         }
4371 
4372         bytes memory signature = new bytes(_ECDSA_SIG_LEN);
4373 
4374         signature = copyBytes(_proof, 2, _ECDSA_SIG_LEN, signature, 0);
4375 
4376         // Extract the headers, big endian encoding of headers length
4377         if (uint(uint8(_proof[_ENCODING_BYTES + _ECDSA_SIG_LEN])) * _MAX_BYTE_SIZE + uint(uint8(_proof[_ENCODING_BYTES + _ECDSA_SIG_LEN + 1])) != _HEADERS_LEN) {
4378             revert("invalid headers length");
4379         }
4380 
4381         bytes memory headers = new bytes(_HEADERS_LEN);
4382         headers = copyBytes(_proof, 2 * _ENCODING_BYTES + _ECDSA_SIG_LEN, _HEADERS_LEN, headers, 0);
4383 
4384         // Check if the signature is valid and if the signer address is matching.
4385         if (!_verifySignature(headers, signature, _publicKey)) {
4386             revert("invalid signature");
4387         }
4388 
4389         // Check if the date is valid.
4390         bytes memory dateHeader = new bytes(20);
4391         // keep only the relevant string(e.g. "16 Nov 2018 16:22:18")
4392         dateHeader = copyBytes(headers, 11, 20, dateHeader, 0);
4393 
4394         bool dateValid;
4395         uint timestamp;
4396         (dateValid, timestamp) = _verifyDate(string(dateHeader), _lastUpdate);
4397 
4398         // Check whether the date returned is valid or not
4399         if (!dateValid) {
4400             revert("invalid date");
4401         }
4402 
4403         // Check if the signed digest hash matches the result hash.
4404         bytes memory digest = new bytes(_DIGEST_BASE64_LEN);
4405         digest = copyBytes(headers, _DIGEST_OFFSET, _DIGEST_BASE64_LEN, digest, 0);
4406 
4407         if (keccak256(abi.encodePacked(sha256(abi.encodePacked(_result)))) != keccak256(_base64decode(digest))) {
4408             revert("result hash not matching");
4409         }
4410 
4411         emit VerifiedProof(_publicKey, _result);
4412         return (true, timestamp);
4413     }
4414 
4415     /// @notice Verify the HTTP headers and the signature
4416     /// @param _headers HTTP headers provided by the cryptocompare api
4417     /// @param _signature signature provided by the cryptocompare api
4418     /// @param _publicKey cryptocompare public key.
4419     function _verifySignature(bytes memory _headers, bytes memory _signature, bytes memory _publicKey) private returns (bool) {
4420         address signer;
4421         bool signatureOK;
4422 
4423         // Checks if the signature is valid by hashing the headers
4424         (signatureOK, signer) = ecrecovery(sha256(_headers), _signature);
4425         return signatureOK && signer == address(uint160(uint256(keccak256(_publicKey))));
4426     }
4427 
4428     /// @notice Verify the signed HTTP date header.
4429     /// @param _dateHeader extracted date string e.g. Wed, 12 Sep 2018 15:18:14 GMT.
4430     /// @param _lastUpdate timestamp of the last time the requested token was updated.
4431     function _verifyDate(string memory _dateHeader, uint _lastUpdate) private pure returns (bool, uint) {
4432 
4433         // called by verifyProof(), _dateHeader is always a string of length = 20
4434         assert(abi.encodePacked(_dateHeader).length == 20);
4435 
4436         // Split the date string and get individual date components.
4437         strings.slice memory date = _dateHeader.toSlice();
4438         strings.slice memory timeDelimiter = ":".toSlice();
4439         strings.slice memory dateDelimiter = " ".toSlice();
4440 
4441         uint day = _parseIntScientific(date.split(dateDelimiter).toString());
4442         require(day > 0 && day < 32, "day error");
4443 
4444         uint month = _monthToNumber(date.split(dateDelimiter).toString());
4445         require(month > 0 && month < 13, "month error");
4446 
4447         uint year = _parseIntScientific(date.split(dateDelimiter).toString());
4448         require(year > 2017 && year < 3000, "year error");
4449 
4450         uint hour = _parseIntScientific(date.split(timeDelimiter).toString());
4451         require(hour < 25, "hour error");
4452 
4453         uint minute = _parseIntScientific(date.split(timeDelimiter).toString());
4454         require(minute < 60, "minute error");
4455 
4456         uint second = _parseIntScientific(date.split(timeDelimiter).toString());
4457         require(second < 60, "second error");
4458 
4459         uint timestamp = year * (10 ** 10) + month * (10 ** 8) + day * (10 ** 6) + hour * (10 ** 4) + minute * (10 ** 2) + second;
4460 
4461         return (timestamp > _lastUpdate, timestamp);
4462     }
4463 
4464 }