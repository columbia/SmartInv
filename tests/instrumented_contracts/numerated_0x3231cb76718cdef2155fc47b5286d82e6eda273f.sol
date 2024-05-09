1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 
74 /**
75  * @title Claimable
76  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
77  * This allows the new owner to accept the transfer.
78  */
79 contract Claimable is Ownable {
80   address public pendingOwner;
81 
82   /**
83    * @dev Modifier throws if called by any account other than the pendingOwner.
84    */
85   modifier onlyPendingOwner() {
86     require(msg.sender == pendingOwner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to set the pendingOwner address.
92    * @param newOwner The address to transfer ownership to.
93    */
94   function transferOwnership(address newOwner) public onlyOwner {
95     pendingOwner = newOwner;
96   }
97 
98   /**
99    * @dev Allows the pendingOwner address to finalize the transfer.
100    */
101   function claimOwnership() public onlyPendingOwner {
102     emit OwnershipTransferred(owner, pendingOwner);
103     owner = pendingOwner;
104     pendingOwner = address(0);
105   }
106 }
107 
108 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
109 
110 pragma solidity ^0.4.24;
111 
112 
113 /**
114  * @title ERC20Basic
115  * @dev Simpler version of ERC20 interface
116  * See https://github.com/ethereum/EIPs/issues/179
117  */
118 contract ERC20Basic {
119   function totalSupply() public view returns (uint256);
120   function balanceOf(address _who) public view returns (uint256);
121   function transfer(address _to, uint256 _value) public returns (bool);
122   event Transfer(address indexed from, address indexed to, uint256 value);
123 }
124 
125 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
126 
127 pragma solidity ^0.4.24;
128 
129 
130 
131 /**
132  * @title ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/20
134  */
135 contract ERC20 is ERC20Basic {
136   function allowance(address _owner, address _spender)
137     public view returns (uint256);
138 
139   function transferFrom(address _from, address _to, uint256 _value)
140     public returns (bool);
141 
142   function approve(address _spender, uint256 _value) public returns (bool);
143   event Approval(
144     address indexed owner,
145     address indexed spender,
146     uint256 value
147   );
148 }
149 
150 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
151 
152 pragma solidity ^0.4.24;
153 
154 
155 
156 
157 /**
158  * @title SafeERC20
159  * @dev Wrappers around ERC20 operations that throw on failure.
160  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
161  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
162  */
163 library SafeERC20 {
164   function safeTransfer(
165     ERC20Basic _token,
166     address _to,
167     uint256 _value
168   )
169     internal
170   {
171     require(_token.transfer(_to, _value));
172   }
173 
174   function safeTransferFrom(
175     ERC20 _token,
176     address _from,
177     address _to,
178     uint256 _value
179   )
180     internal
181   {
182     require(_token.transferFrom(_from, _to, _value));
183   }
184 
185   function safeApprove(
186     ERC20 _token,
187     address _spender,
188     uint256 _value
189   )
190     internal
191   {
192     require(_token.approve(_spender, _value));
193   }
194 }
195 
196 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
197 
198 pragma solidity ^0.4.24;
199 
200 
201 
202 
203 
204 /**
205  * @title Contracts that should be able to recover tokens
206  * @author SylTi
207  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
208  * This will prevent any accidental loss of tokens.
209  */
210 contract CanReclaimToken is Ownable {
211   using SafeERC20 for ERC20Basic;
212 
213   /**
214    * @dev Reclaim all ERC20Basic compatible tokens
215    * @param _token ERC20Basic The address of the token contract
216    */
217   function reclaimToken(ERC20Basic _token) external onlyOwner {
218     uint256 balance = _token.balanceOf(this);
219     _token.safeTransfer(owner, balance);
220   }
221 
222 }
223 
224 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
225 
226 pragma solidity ^0.4.24;
227 
228 
229 
230 /**
231  * @title Contracts that should not own Ether
232  * @author Remco Bloemen <remco@2π.com>
233  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
234  * in the contract, it will allow the owner to reclaim this Ether.
235  * @notice Ether can still be sent to this contract by:
236  * calling functions labeled `payable`
237  * `selfdestruct(contract_address)`
238  * mining directly to the contract address
239  */
240 contract HasNoEther is Ownable {
241 
242   /**
243   * @dev Constructor that rejects incoming Ether
244   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
245   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
246   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
247   * we could use assembly to access msg.value.
248   */
249   constructor() public payable {
250     require(msg.value == 0);
251   }
252 
253   /**
254    * @dev Disallows direct send by setting a default function without the `payable` flag.
255    */
256   function() external {
257   }
258 
259   /**
260    * @dev Transfer all Ether held by the contract to the owner.
261    */
262   function reclaimEther() external onlyOwner {
263     owner.transfer(address(this).balance);
264   }
265 }
266 
267 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
268 
269 pragma solidity ^0.4.24;
270 
271 
272 
273 /**
274  * @title Contracts that should not own Tokens
275  * @author Remco Bloemen <remco@2π.com>
276  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
277  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
278  * owner to reclaim the tokens.
279  */
280 contract HasNoTokens is CanReclaimToken {
281 
282  /**
283   * @dev Reject all ERC223 compatible tokens
284   * @param _from address The address that is transferring the tokens
285   * @param _value uint256 the amount of the specified token
286   * @param _data Bytes The data passed from the caller.
287   */
288   function tokenFallback(
289     address _from,
290     uint256 _value,
291     bytes _data
292   )
293     external
294     pure
295   {
296     _from;
297     _value;
298     _data;
299     revert();
300   }
301 
302 }
303 
304 // File: openzeppelin-solidity/contracts/ownership/HasNoContracts.sol
305 
306 pragma solidity ^0.4.24;
307 
308 
309 
310 /**
311  * @title Contracts that should not own Contracts
312  * @author Remco Bloemen <remco@2π.com>
313  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
314  * of this contract to reclaim ownership of the contracts.
315  */
316 contract HasNoContracts is Ownable {
317 
318   /**
319    * @dev Reclaim ownership of Ownable contracts
320    * @param _contractAddr The address of the Ownable to be reclaimed.
321    */
322   function reclaimContract(address _contractAddr) external onlyOwner {
323     Ownable contractInst = Ownable(_contractAddr);
324     contractInst.transferOwnership(owner);
325   }
326 }
327 
328 // File: openzeppelin-solidity/contracts/ownership/NoOwner.sol
329 
330 pragma solidity ^0.4.24;
331 
332 
333 
334 
335 
336 /**
337  * @title Base contract for contracts that should not own things.
338  * @author Remco Bloemen <remco@2π.com>
339  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
340  * Owned contracts. See respective base contracts for details.
341  */
342 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
343 }
344 
345 // File: openzeppelin-solidity/contracts/lifecycle/Destructible.sol
346 
347 pragma solidity ^0.4.24;
348 
349 
350 
351 /**
352  * @title Destructible
353  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
354  */
355 contract Destructible is Ownable {
356   /**
357    * @dev Transfers the current balance to the owner and terminates the contract.
358    */
359   function destroy() public onlyOwner {
360     selfdestruct(owner);
361   }
362 
363   function destroyAndSend(address _recipient) public onlyOwner {
364     selfdestruct(_recipient);
365   }
366 }
367 
368 // File: contracts/IERC20.sol
369 
370 /**
371  * Copyright 2019 Monerium ehf.
372  *
373  * Licensed under the Apache License, Version 2.0 (the "License");
374  * you may not use this file except in compliance with the License.
375  * You may obtain a copy of the License at
376  *
377  *     http://www.apache.org/licenses/LICENSE-2.0
378  *
379  * Unless required by applicable law or agreed to in writing, software
380  * distributed under the License is distributed on an "AS IS" BASIS,
381  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
382  * See the License for the specific language governing permissions and
383  * limitations under the License.
384  */
385 
386 pragma solidity 0.4.24;
387 
388 /**
389  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
390  * the optional functions; to access them see `ERC20Detailed`.
391  */
392 interface IERC20 {
393     /**
394      * @dev Returns the amount of tokens in existence.
395      */
396     function totalSupply() external view returns (uint256);
397 
398     /**
399      * @dev Returns the amount of tokens owned by `account`.
400      */
401     function balanceOf(address account) external view returns (uint256);
402 
403     /**
404      * @dev Moves `amount` tokens from the caller's account to `recipient`.
405      *
406      * Returns a boolean value indicating whether the operation succeeded.
407      *
408      * Emits a `Transfer` event.
409      */
410     function transfer(address recipient, uint256 amount) external returns (bool);
411 
412     /**
413      * @dev Returns the remaining number of tokens that `spender` will be
414      * allowed to spend on behalf of `owner` through `transferFrom`. This is
415      * zero by default.
416      *
417      * This value changes when `approve` or `transferFrom` are called.
418      */
419     function allowance(address owner, address spender) external view returns (uint256);
420 
421     /**
422      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
423      *
424      * Returns a boolean value indicating whether the operation succeeded.
425      *
426      * > Beware that changing an allowance with this method brings the risk
427      * that someone may use both the old and the new allowance by unfortunate
428      * transaction ordering. One possible solution to mitigate this race
429      * condition is to first reduce the spender's allowance to 0 and set the
430      * desired value afterwards:
431      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
432      *
433      * Emits an `Approval` event.
434      */
435     function approve(address spender, uint256 amount) external returns (bool);
436 
437     /**
438      * @dev Moves `amount` tokens from `sender` to `recipient` using the
439      * allowance mechanism. `amount` is then deducted from the caller's
440      * allowance.
441      *
442      * Returns a boolean value indicating whether the operation succeeded.
443      *
444      * Emits a `Transfer` event.
445      */
446     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
447 
448     /**
449      * @dev Emitted when `value` tokens are moved from one account (`from`) to
450      * another (`to`).
451      *
452      * Note that `value` may be zero.
453      */
454     event Transfer(address indexed from, address indexed to, uint256 value);
455 
456     /**
457      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
458      * a call to `approve`. `value` is the new allowance.
459      */
460     event Approval(address indexed owner, address indexed spender, uint256 value);
461 }
462 
463 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
464 
465 pragma solidity ^0.4.24;
466 
467 
468 /**
469  * @title SafeMath
470  * @dev Math operations with safety checks that throw on error
471  */
472 library SafeMath {
473 
474   /**
475   * @dev Multiplies two numbers, throws on overflow.
476   */
477   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
478     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
479     // benefit is lost if 'b' is also tested.
480     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
481     if (_a == 0) {
482       return 0;
483     }
484 
485     c = _a * _b;
486     assert(c / _a == _b);
487     return c;
488   }
489 
490   /**
491   * @dev Integer division of two numbers, truncating the quotient.
492   */
493   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
494     // assert(_b > 0); // Solidity automatically throws when dividing by 0
495     // uint256 c = _a / _b;
496     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
497     return _a / _b;
498   }
499 
500   /**
501   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
502   */
503   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
504     assert(_b <= _a);
505     return _a - _b;
506   }
507 
508   /**
509   * @dev Adds two numbers, throws on overflow.
510   */
511   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
512     c = _a + _b;
513     assert(c >= _a);
514     return c;
515   }
516 }
517 
518 // File: contracts/TokenStorageLib.sol
519 
520 /**
521  * Copyright 2019 Monerium ehf.
522  *
523  * Licensed under the Apache License, Version 2.0 (the "License");
524  * you may not use this file except in compliance with the License.
525  * You may obtain a copy of the License at
526  *
527  *     http://www.apache.org/licenses/LICENSE-2.0
528  *
529  * Unless required by applicable law or agreed to in writing, software
530  * distributed under the License is distributed on an "AS IS" BASIS,
531  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
532  * See the License for the specific language governing permissions and
533  * limitations under the License.
534  */
535 
536 pragma solidity 0.4.24;
537 
538 
539 /** @title TokenStorageLib
540  * @dev Implementation of an[external storage for tokens.
541  */
542 library TokenStorageLib {
543 
544     using SafeMath for uint;
545 
546     struct TokenStorage {
547         mapping (address => uint) balances;
548         mapping (address => mapping (address => uint)) allowed;
549         uint totalSupply;
550     }
551 
552     /**
553      * @dev Increases balance of an address.
554      * @param self Token storage to operate on.
555      * @param to Address to increase.
556      * @param amount Number of units to add.
557      */
558     function addBalance(TokenStorage storage self, address to, uint amount)
559         external
560     {
561         self.totalSupply = self.totalSupply.add(amount);
562         self.balances[to] = self.balances[to].add(amount);
563     }
564 
565     /**
566      * @dev Decreases balance of an address.
567      * @param self Token storage to operate on.
568      * @param from Address to decrease.
569      * @param amount Number of units to subtract.
570      */
571     function subBalance(TokenStorage storage self, address from, uint amount)
572         external
573     {
574         self.totalSupply = self.totalSupply.sub(amount);
575         self.balances[from] = self.balances[from].sub(amount);
576     }
577 
578     /**
579      * @dev Sets the allowance for a spender.
580      * @param self Token storage to operate on.
581      * @param owner Address of the owner of the tokens to spend.
582      * @param spender Address of the spender.
583      * @param amount Qunatity of allowance.
584      */
585     function setAllowed(TokenStorage storage self, address owner, address spender, uint amount)
586         external
587     {
588         self.allowed[owner][spender] = amount;
589     }
590 
591     /**
592      * @dev Returns the supply of tokens.
593      * @param self Token storage to operate on.
594      * @return Total supply.
595      */
596     function getSupply(TokenStorage storage self)
597         external
598         view
599         returns (uint)
600     {
601         return self.totalSupply;
602     }
603 
604     /**
605      * @dev Returns the balance of an address.
606      * @param self Token storage to operate on.
607      * @param who Address to lookup.
608      * @return Number of units.
609      */
610     function getBalance(TokenStorage storage self, address who)
611         external
612         view
613         returns (uint)
614     {
615         return self.balances[who];
616     }
617 
618     /**
619      * @dev Returns the allowance for a spender.
620      * @param self Token storage to operate on.
621      * @param owner Address of the owner of the tokens to spend.
622      * @param spender Address of the spender.
623      * @return Number of units.
624      */
625     function getAllowed(TokenStorage storage self, address owner, address spender)
626         external
627         view
628         returns (uint)
629     {
630         return self.allowed[owner][spender];
631     }
632 
633 }
634 
635 // File: contracts/TokenStorage.sol
636 
637 /**
638  * Copyright 2019 Monerium ehf.
639  *
640  * Licensed under the Apache License, Version 2.0 (the "License");
641  * you may not use this file except in compliance with the License.
642  * You may obtain a copy of the License at
643  *
644  *     http://www.apache.org/licenses/LICENSE-2.0
645  *
646  * Unless required by applicable law or agreed to in writing, software
647  * distributed under the License is distributed on an "AS IS" BASIS,
648  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
649  * See the License for the specific language governing permissions and
650  * limitations under the License.
651  */
652 
653 pragma solidity 0.4.24;
654 
655 
656 
657 
658 
659 /**
660  * @title TokenStorage
661  * @dev External storage for tokens.
662  * The storage is implemented in a separate contract to maintain state
663  * between token upgrades.
664  */
665 contract TokenStorage is Claimable, CanReclaimToken, NoOwner {
666 
667     using TokenStorageLib for TokenStorageLib.TokenStorage;
668 
669     TokenStorageLib.TokenStorage internal tokenStorage;
670 
671     /**
672      * @dev Increases balance of an address.
673      * @param to Address to increase.
674      * @param amount Number of units to add.
675      */
676     function addBalance(address to, uint amount) external onlyOwner {
677         tokenStorage.addBalance(to, amount);
678     }
679 
680     /**
681      * @dev Decreases balance of an address.
682      * @param from Address to decrease.
683      * @param amount Number of units to subtract.
684      */
685     function subBalance(address from, uint amount) external onlyOwner {
686         tokenStorage.subBalance(from, amount);
687     }
688 
689     /**
690      * @dev Sets the allowance for a spender.
691      * @param owner Address of the owner of the tokens to spend.
692      * @param spender Address of the spender.
693      * @param amount Qunatity of allowance.
694      */
695     function setAllowed(address owner, address spender, uint amount) external onlyOwner {
696         tokenStorage.setAllowed(owner, spender, amount);
697     }
698 
699     /**
700      * @dev Returns the supply of tokens.
701      * @return Total supply.
702      */
703     function getSupply() external view returns (uint) {
704         return tokenStorage.getSupply();
705     }
706 
707     /**
708      * @dev Returns the balance of an address.
709      * @param who Address to lookup.
710      * @return Number of units.
711      */
712     function getBalance(address who) external view returns (uint) {
713         return tokenStorage.getBalance(who);
714     }
715 
716     /**
717      * @dev Returns the allowance for a spender.
718      * @param owner Address of the owner of the tokens to spend.
719      * @param spender Address of the spender.
720      * @return Number of units.
721      */
722     function getAllowed(address owner, address spender)
723         external
724         view
725         returns (uint)
726     {
727         return tokenStorage.getAllowed(owner, spender);
728     }
729 
730 }
731 
732 // File: contracts/ERC20Lib.sol
733 
734 /**
735  * Copyright 2019 Monerium ehf.
736  *
737  * Licensed under the Apache License, Version 2.0 (the "License");
738  * you may not use this file except in compliance with the License.
739  * You may obtain a copy of the License at
740  *
741  *     http://www.apache.org/licenses/LICENSE-2.0
742  *
743  * Unless required by applicable law or agreed to in writing, software
744  * distributed under the License is distributed on an "AS IS" BASIS,
745  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
746  * See the License for the specific language governing permissions and
747  * limitations under the License.
748  */
749 
750 pragma solidity 0.4.24;
751 
752 
753 
754 /**
755  * @title ERC20Lib
756  * @dev Standard ERC20 token functionality.
757  * https://github.com/ethereum/EIPs/issues/20
758  */
759 library ERC20Lib {
760 
761     using SafeMath for uint;
762 
763     /**
764      * @dev Transfers tokens [ERC20].
765      * @param db Token storage to operate on.
766      * @param caller Address of the caller passed through the frontend.
767      * @param to Recipient address.
768      * @param amount Number of tokens to transfer.
769      */
770     function transfer(TokenStorage db, address caller, address to, uint amount)
771         external
772         returns (bool success)
773     {
774         db.subBalance(caller, amount);
775         db.addBalance(to, amount);
776         return true;
777     }
778 
779     /**
780      * @dev Transfers tokens from a specific address [ERC20].
781      * The address owner has to approve the spender beforehand.
782      * @param db Token storage to operate on.
783      * @param caller Address of the caller passed through the frontend.
784      * @param from Address to debet the tokens from.
785      * @param to Recipient address.
786      * @param amount Number of tokens to transfer.
787      */
788     function transferFrom(
789         TokenStorage db,
790         address caller,
791         address from,
792         address to,
793         uint amount
794     )
795         external
796         returns (bool success)
797     {
798         uint allowance = db.getAllowed(from, caller);
799         db.subBalance(from, amount);
800         db.addBalance(to, amount);
801         db.setAllowed(from, caller, allowance.sub(amount));
802         return true;
803     }
804 
805     /**
806      * @dev Approves a spender [ERC20].
807      * Note that using the approve/transferFrom presents a possible
808      * security vulnerability described in:
809      * https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#heading=h.quou09mcbpzw
810      * Use transferAndCall to mitigate.
811      * @param db Token storage to operate on.
812      * @param caller Address of the caller passed through the frontend.
813      * @param spender The address of the future spender.
814      * @param amount The allowance of the spender.
815      */
816     function approve(TokenStorage db, address caller, address spender, uint amount)
817         public
818         returns (bool success)
819     {
820         db.setAllowed(caller, spender, amount);
821         return true;
822     }
823 
824     /**
825      * @dev Returns the number tokens associated with an address.
826      * @param db Token storage to operate on.
827      * @param who Address to lookup.
828      * @return Balance of address.
829      */
830     function balanceOf(TokenStorage db, address who)
831         external
832         view
833         returns (uint balance)
834     {
835         return db.getBalance(who);
836     }
837 
838     /**
839      * @dev Returns the allowance for a spender
840      * @param db Token storage to operate on.
841      * @param owner The address of the owner of the tokens.
842      * @param spender The address of the spender.
843      * @return Number of tokens the spender is allowed to spend.
844      */
845     function allowance(TokenStorage db, address owner, address spender)
846         external
847         view
848         returns (uint remaining)
849     {
850         return db.getAllowed(owner, spender);
851     }
852 
853 }
854 
855 // File: contracts/MintableTokenLib.sol
856 
857 /**
858  * Copyright 2019 Monerium ehf.
859  *
860  * Licensed under the Apache License, Version 2.0 (the "License");
861  * you may not use this file except in compliance with the License.
862  * You may obtain a copy of the License at
863  *
864  *     http://www.apache.org/licenses/LICENSE-2.0
865  *
866  * Unless required by applicable law or agreed to in writing, software
867  * distributed under the License is distributed on an "AS IS" BASIS,
868  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
869  * See the License for the specific language governing permissions and
870  * limitations under the License.
871  */
872 
873 pragma solidity 0.4.24;
874 
875 
876 
877 
878 /**
879  * @title Mintable token
880  * @dev Simple ERC20 Token example, with mintable token creation
881  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
882  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
883  */
884 
885 library MintableTokenLib {
886 
887     using SafeMath for uint;
888 
889     /**
890      * @dev Mints new tokens.
891      * @param db Token storage to operate on.
892      * @param to The address that will recieve the minted tokens.
893      * @param amount The amount of tokens to mint.
894      */
895     function mint(
896         TokenStorage db,
897         address to,
898         uint amount
899     )
900         external
901         returns (bool)
902     {
903         db.addBalance(to, amount);
904         return true;
905     }
906 
907     /**
908      * @dev Burns tokens.
909      * @param db Token storage to operate on.
910      * @param from The address holding tokens.
911      * @param amount The amount of tokens to burn.
912      */
913     function burn(
914         TokenStorage db,
915         address from,
916         uint amount
917     )
918         public
919         returns (bool)
920     {
921         db.subBalance(from, amount);
922         return true;
923     }
924 
925     /**
926      * @dev Burns tokens from a specific address.
927      * To burn the tokens the caller needs to provide a signature
928      * proving that the caller is authorized by the token owner to do so.
929      * @param db Token storage to operate on.
930      * @param from The address holding tokens.
931      * @param amount The amount of tokens to burn.
932      * @param h Hash which the token owner signed.
933      * @param v Signature component.
934      * @param r Signature component.
935      * @param s Sigature component.
936      */
937     function burn(
938         TokenStorage db,
939         address from,
940         uint amount,
941         bytes32 h,
942         uint8 v,
943         bytes32 r,
944         bytes32 s
945     )
946         external
947         returns (bool)
948     {
949         require(
950             ecrecover(h, v, r, s) == from,
951             "signature/hash does not match"
952         );
953         return burn(db, from, amount);
954     }
955 
956 }
957 
958 // File: contracts/IValidator.sol
959 
960 /**
961  * Copyright 2019 Monerium ehf.
962  *
963  * Licensed under the Apache License, Version 2.0 (the "License");
964  * you may not use this file except in compliance with the License.
965  * You may obtain a copy of the License at
966  *
967  *     http://www.apache.org/licenses/LICENSE-2.0
968  *
969  * Unless required by applicable law or agreed to in writing, software
970  * distributed under the License is distributed on an "AS IS" BASIS,
971  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
972  * See the License for the specific language governing permissions and
973  * limitations under the License.
974  */
975 
976 pragma solidity 0.4.24;
977 
978 /**
979  * @title IValidator
980  * @dev Contracts implementing this interface validate token transfers.
981  */
982 interface IValidator {
983 
984     /**
985      * @dev Emitted when a validator makes a decision.
986      * @param from Sender address.
987      * @param to Recipient address.
988      * @param amount Number of tokens.
989      * @param valid True if transfer approved, false if rejected.
990      */
991     event Decision(address indexed from, address indexed to, uint amount, bool valid);
992 
993     /**
994      * @dev Validates token transfer.
995      * If the sender is on the blacklist the transfer is denied.
996      * @param from Sender address.
997      * @param to Recipient address.
998      * @param amount Number of tokens.
999      */
1000     function validate(address from, address to, uint amount) external returns (bool valid);
1001 
1002 }
1003 
1004 // File: contracts/SmartTokenLib.sol
1005 
1006 /**
1007  * Copyright 2019 Monerium ehf.
1008  *
1009  * Licensed under the Apache License, Version 2.0 (the "License");
1010  * you may not use this file except in compliance with the License.
1011  * You may obtain a copy of the License at
1012  *
1013  *     http://www.apache.org/licenses/LICENSE-2.0
1014  *
1015  * Unless required by applicable law or agreed to in writing, software
1016  * distributed under the License is distributed on an "AS IS" BASIS,
1017  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1018  * See the License for the specific language governing permissions and
1019  * limitations under the License.
1020  */
1021 
1022 pragma solidity 0.4.24;
1023 
1024 
1025 
1026 
1027 /**
1028  * @title SmartTokenLib
1029  * @dev This library provides functionality which is required from a regulatory perspective.
1030  */
1031 library SmartTokenLib {
1032 
1033     using ERC20Lib for TokenStorage;
1034     using MintableTokenLib for TokenStorage;
1035 
1036     struct SmartStorage {
1037         IValidator validator;
1038     }
1039 
1040     /**
1041      * @dev Emitted when the contract owner recovers tokens.
1042      * @param from Sender address.
1043      * @param to Recipient address.
1044      * @param amount Number of tokens.
1045      */
1046     event Recovered(address indexed from, address indexed to, uint amount);
1047 
1048     /**
1049      * @dev Emitted when updating the validator.
1050      * @param old Address of the old validator.
1051      * @param current Address of the new validator.
1052      */
1053     event Validator(address indexed old, address indexed current);
1054 
1055     /**
1056      * @dev Sets a new validator.
1057      * @param self Smart storage to operate on.
1058      * @param validator Address of validator.
1059      */
1060     function setValidator(SmartStorage storage self, address validator)
1061         external
1062     {
1063         emit Validator(self.validator, validator);
1064         self.validator = IValidator(validator);
1065     }
1066 
1067 
1068     /**
1069      * @dev Approves or rejects a transfer request.
1070      * The request is forwarded to a validator which implements
1071      * the actual business logic.
1072      * @param self Smart storage to operate on.
1073      * @param from Sender address.
1074      * @param to Recipient address.
1075      * @param amount Number of tokens.
1076      */
1077     function validate(SmartStorage storage self, address from, address to, uint amount)
1078         external
1079         returns (bool valid)
1080     {
1081         return self.validator.validate(from, to, amount);
1082     }
1083 
1084     /**
1085      * @dev Recovers tokens from an address and reissues them to another address.
1086      * In case a user loses its private key the tokens can be recovered by burning
1087      * the tokens from that address and reissuing to a new address.
1088      * To recover tokens the contract owner needs to provide a signature
1089      * proving that the token owner has authorized the owner to do so.
1090      * @param from Address to burn tokens from.
1091      * @param to Address to mint tokens to.
1092      * @param h Hash which the token owner signed.
1093      * @param v Signature component.
1094      * @param r Signature component.
1095      * @param s Sigature component.
1096      * @return Amount recovered.
1097      */
1098     function recover(
1099         TokenStorage token,
1100         address from,
1101         address to,
1102         bytes32 h,
1103         uint8 v,
1104         bytes32 r,
1105         bytes32 s
1106     )
1107         external
1108         returns (uint)
1109     {
1110         require(
1111             ecrecover(h, v, r, s) == from,
1112             "signature/hash does not recover from address"
1113         );
1114         uint amount = token.balanceOf(from);
1115         token.burn(from, amount);
1116         token.mint(to, amount);
1117         emit Recovered(from, to, amount);
1118         return amount;
1119     }
1120 
1121     /**
1122      * @dev Gets the current validator.
1123      * @param self Smart storage to operate on.
1124      * @return Address of validator.
1125      */
1126     function getValidator(SmartStorage storage self)
1127         external
1128         view
1129         returns (address)
1130     {
1131         return address(self.validator);
1132     }
1133 
1134 }
1135 
1136 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
1137 
1138 pragma solidity ^0.4.24;
1139 
1140 
1141 
1142 /**
1143  * @title Pausable
1144  * @dev Base contract which allows children to implement an emergency stop mechanism.
1145  */
1146 contract Pausable is Ownable {
1147   event Pause();
1148   event Unpause();
1149 
1150   bool public paused = false;
1151 
1152 
1153   /**
1154    * @dev Modifier to make a function callable only when the contract is not paused.
1155    */
1156   modifier whenNotPaused() {
1157     require(!paused);
1158     _;
1159   }
1160 
1161   /**
1162    * @dev Modifier to make a function callable only when the contract is paused.
1163    */
1164   modifier whenPaused() {
1165     require(paused);
1166     _;
1167   }
1168 
1169   /**
1170    * @dev called by the owner to pause, triggers stopped state
1171    */
1172   function pause() public onlyOwner whenNotPaused {
1173     paused = true;
1174     emit Pause();
1175   }
1176 
1177   /**
1178    * @dev called by the owner to unpause, returns to normal state
1179    */
1180   function unpause() public onlyOwner whenPaused {
1181     paused = false;
1182     emit Unpause();
1183   }
1184 }
1185 
1186 // File: openzeppelin-solidity/contracts/AddressUtils.sol
1187 
1188 pragma solidity ^0.4.24;
1189 
1190 
1191 /**
1192  * Utility library of inline functions on addresses
1193  */
1194 library AddressUtils {
1195 
1196   /**
1197    * Returns whether the target address is a contract
1198    * @dev This function will return false if invoked during the constructor of a contract,
1199    * as the code is not actually created until after the constructor finishes.
1200    * @param _addr address to check
1201    * @return whether the target address is a contract
1202    */
1203   function isContract(address _addr) internal view returns (bool) {
1204     uint256 size;
1205     // XXX Currently there is no better way to check if there is a contract in an address
1206     // than to check the size of the code at that address.
1207     // See https://ethereum.stackexchange.com/a/14016/36603
1208     // for more details about how this works.
1209     // TODO Check this again before the Serenity release, because all addresses will be
1210     // contracts then.
1211     // solium-disable-next-line security/no-inline-assembly
1212     assembly { size := extcodesize(_addr) }
1213     return size > 0;
1214   }
1215 
1216 }
1217 
1218 // File: contracts/IERC677Recipient.sol
1219 
1220 /**
1221  * Copyright 2019 Monerium ehf.
1222  *
1223  * Licensed under the Apache License, Version 2.0 (the "License");
1224  * you may not use this file except in compliance with the License.
1225  * You may obtain a copy of the License at
1226  *
1227  *     http://www.apache.org/licenses/LICENSE-2.0
1228  *
1229  * Unless required by applicable law or agreed to in writing, software
1230  * distributed under the License is distributed on an "AS IS" BASIS,
1231  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1232  * See the License for the specific language governing permissions and
1233  * limitations under the License.
1234  */
1235 
1236 pragma solidity 0.4.24;
1237 
1238 /**
1239  * @title IERC677Recipient
1240  * @dev Contracts implementing this interface can participate in [ERC677].
1241  */
1242 interface IERC677Recipient {
1243 
1244     /**
1245      * @dev Receives notification from [ERC677] transferAndCall.
1246      * @param from Sender address.
1247      * @param amount Number of tokens.
1248      * @param data Additional data.
1249      */
1250     function onTokenTransfer(address from, uint256 amount, bytes data) external returns (bool);
1251 
1252 }
1253 
1254 // File: contracts/ERC677Lib.sol
1255 
1256 /**
1257  * Copyright 2019 Monerium ehf.
1258  *
1259  * Licensed under the Apache License, Version 2.0 (the "License");
1260  * you may not use this file except in compliance with the License.
1261  * You may obtain a copy of the License at
1262  *
1263  *     http://www.apache.org/licenses/LICENSE-2.0
1264  *
1265  * Unless required by applicable law or agreed to in writing, software
1266  * distributed under the License is distributed on an "AS IS" BASIS,
1267  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1268  * See the License for the specific language governing permissions and
1269  * limitations under the License.
1270  */
1271 
1272 pragma solidity 0.4.24;
1273 
1274 
1275 
1276 
1277 
1278 /**
1279  * @title ERC677
1280  * @dev ERC677 token functionality.
1281  * https://github.com/ethereum/EIPs/issues/677
1282  */
1283 library ERC677Lib {
1284 
1285     using ERC20Lib for TokenStorage;
1286     using AddressUtils for address;
1287 
1288     /**
1289      * @dev Transfers tokens and subsequently calls a method on the recipient [ERC677].
1290      * If the recipient is a non-contract address this method behaves just like transfer.
1291      * @notice db.transfer either returns true or reverts.
1292      * @param db Token storage to operate on.
1293      * @param caller Address of the caller passed through the frontend.
1294      * @param to Recipient address.
1295      * @param amount Number of tokens to transfer.
1296      * @param data Additional data passed to the recipient's tokenFallback method.
1297      */
1298     function transferAndCall(
1299         TokenStorage db,
1300         address caller,
1301         address to,
1302         uint256 amount,
1303         bytes data
1304     )
1305         external
1306         returns (bool)
1307     {
1308         require(
1309             db.transfer(caller, to, amount), 
1310             "unable to transfer"
1311         );
1312         if (to.isContract()) {
1313             IERC677Recipient recipient = IERC677Recipient(to);
1314             require(
1315                 recipient.onTokenTransfer(caller, amount, data),
1316                 "token handler returns false"
1317             );
1318         }
1319         return true;
1320     }
1321 
1322 }
1323 
1324 // File: contracts/StandardController.sol
1325 
1326 /**
1327  * Copyright 2019 Monerium ehf.
1328  *
1329  * Licensed under the Apache License, Version 2.0 (the "License");
1330  * you may not use this file except in compliance with the License.
1331  * You may obtain a copy of the License at
1332  *
1333  *     http://www.apache.org/licenses/LICENSE-2.0
1334  *
1335  * Unless required by applicable law or agreed to in writing, software
1336  * distributed under the License is distributed on an "AS IS" BASIS,
1337  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1338  * See the License for the specific language governing permissions and
1339  * limitations under the License.
1340  */
1341 
1342 pragma solidity 0.4.24;
1343 
1344 
1345 
1346 
1347 
1348 
1349 
1350 
1351 /**
1352  * @title StandardController
1353  * @dev This is the base contract which delegates token methods [ERC20 and ERC677]
1354  * to their respective library implementations.
1355  * The controller is primarily intended to be interacted with via a token frontend.
1356  */
1357 contract StandardController is Pausable, Destructible, Claimable {
1358 
1359     using ERC20Lib for TokenStorage;
1360     using ERC677Lib for TokenStorage;
1361 
1362     TokenStorage internal token;
1363     address internal frontend;
1364 
1365     string public name;
1366     string public symbol;
1367     uint public decimals = 18;
1368 
1369     /**
1370      * @dev Emitted when updating the frontend.
1371      * @param old Address of the old frontend.
1372      * @param current Address of the new frontend.
1373      */
1374     event Frontend(address indexed old, address indexed current);
1375 
1376     /**
1377      * @dev Emitted when updating the storage.
1378      * @param old Address of the old storage.
1379      * @param current Address of the new storage.
1380      */
1381     event Storage(address indexed old, address indexed current);
1382 
1383     /**
1384      * @dev Modifier which prevents the function from being called by unauthorized parties.
1385      * The caller must either be the sender or the function must be
1386      * called via the frontend, otherwise the call is reverted.
1387      * @param caller The address of the passed-in caller. Used to preserve the original caller.
1388      */
1389     modifier guarded(address caller) {
1390         require(
1391             msg.sender == caller || msg.sender == frontend,
1392             "either caller must be sender or calling via frontend"
1393         );
1394         _;
1395     }
1396 
1397     /**
1398      * @dev Contract constructor.
1399      * @param storage_ Address of the token storage for the controller.
1400      * @param initialSupply The amount of tokens to mint upon creation.
1401      * @param frontend_ Address of the authorized frontend.
1402      */
1403     constructor(address storage_, uint initialSupply, address frontend_) public {
1404         require(
1405             storage_ == 0x0 || initialSupply == 0,
1406             "either a token storage must be initialized or no initial supply"
1407         );
1408         if (storage_ == 0x0) {
1409             token = new TokenStorage();
1410             token.addBalance(msg.sender, initialSupply);
1411         } else {
1412             token = TokenStorage(storage_);
1413         }
1414         frontend = frontend_;
1415     }
1416 
1417     /**
1418      * @dev Prevents tokens to be sent to well known blackholes by throwing on known blackholes.
1419      * @param to The address of the intended recipient.
1420      */
1421     function avoidBlackholes(address to) internal view {
1422         require(to != 0x0, "must not send to 0x0");
1423         require(to != address(this), "must not send to controller");
1424         require(to != address(token), "must not send to token storage");
1425         require(to != frontend, "must not send to frontend");
1426     }
1427 
1428     /**
1429      * @dev Returns the current frontend.
1430      * @return Address of the frontend.
1431      */
1432     function getFrontend() external view returns (address) {
1433         return frontend;
1434     }
1435 
1436     /**
1437      * @dev Returns the current storage.
1438      * @return Address of the storage.
1439      */
1440     function getStorage() external view returns (address) {
1441         return address(token);
1442     }
1443 
1444     /**
1445      * @dev Sets a new frontend.
1446      * @param frontend_ Address of the new frontend.
1447      */
1448     function setFrontend(address frontend_) public onlyOwner {
1449         emit Frontend(frontend, frontend_);
1450         frontend = frontend_;
1451     }
1452 
1453     /**
1454      * @dev Sets a new storage.
1455      * @param storage_ Address of the new storage.
1456      */
1457     function setStorage(address storage_) external onlyOwner {
1458         emit Storage(address(token), storage_);
1459         token = TokenStorage(storage_);
1460     }
1461 
1462     /**
1463      * @dev Transfers the ownership of the storage.
1464      * @param newOwner Address of the new storage owner.
1465      */
1466     function transferStorageOwnership(address newOwner) public onlyOwner {
1467         token.transferOwnership(newOwner);
1468     }
1469 
1470     /**
1471      * @dev Claims the ownership of the storage.
1472      */
1473     function claimStorageOwnership() public onlyOwner {
1474         token.claimOwnership();
1475     }
1476 
1477     /**
1478      * @dev Transfers tokens [ERC20].
1479      * @param caller Address of the caller passed through the frontend.
1480      * @param to Recipient address.
1481      * @param amount Number of tokens to transfer.
1482      */
1483     function transfer_withCaller(address caller, address to, uint amount)
1484         public
1485         guarded(caller)
1486         whenNotPaused
1487         returns (bool ok)
1488     {
1489         avoidBlackholes(to);
1490         return token.transfer(caller, to, amount);
1491     }
1492 
1493     /**
1494      * @dev Transfers tokens from a specific address [ERC20].
1495      * The address owner has to approve the spender beforehand.
1496      * @param caller Address of the caller passed through the frontend.
1497      * @param from Address to debet the tokens from.
1498      * @param to Recipient address.
1499      * @param amount Number of tokens to transfer.
1500      */
1501     function transferFrom_withCaller(address caller, address from, address to, uint amount)
1502         public
1503         guarded(caller)
1504         whenNotPaused
1505         returns (bool ok)
1506     {
1507         avoidBlackholes(to);
1508         return token.transferFrom(caller, from, to, amount);
1509     }
1510 
1511     /**
1512      * @dev Approves a spender [ERC20].
1513      * Note that using the approve/transferFrom presents a possible
1514      * security vulnerability described in:
1515      * https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#heading=h.quou09mcbpzw
1516      * Use transferAndCall to mitigate.
1517      * @param caller Address of the caller passed through the frontend.
1518      * @param spender The address of the future spender.
1519      * @param amount The allowance of the spender.
1520      */
1521     function approve_withCaller(address caller, address spender, uint amount)
1522         public
1523         guarded(caller)
1524         whenNotPaused
1525         returns (bool ok)
1526     {
1527         return token.approve(caller, spender, amount);
1528     }
1529 
1530     /**
1531      * @dev Transfers tokens and subsequently calls a method on the recipient [ERC677].
1532      * If the recipient is a non-contract address this method behaves just like transfer.
1533      * @param caller Address of the caller passed through the frontend.
1534      * @param to Recipient address.
1535      * @param amount Number of tokens to transfer.
1536      * @param data Additional data passed to the recipient's tokenFallback method.
1537      */
1538     function transferAndCall_withCaller(
1539         address caller,
1540         address to,
1541         uint256 amount,
1542         bytes data
1543     )
1544         public
1545         guarded(caller)
1546         whenNotPaused
1547         returns (bool ok)
1548     {
1549         avoidBlackholes(to);
1550         return token.transferAndCall(caller, to, amount, data);
1551     }
1552 
1553     /**
1554      * @dev Returns the total supply.
1555      * @return Number of tokens.
1556      */
1557     function totalSupply() external view returns (uint) {
1558         return token.getSupply();
1559     }
1560 
1561     /**
1562      * @dev Returns the number tokens associated with an address.
1563      * @param who Address to lookup.
1564      * @return Balance of address.
1565      */
1566     function balanceOf(address who) external view returns (uint) {
1567         return token.getBalance(who);
1568     }
1569 
1570     /**
1571      * @dev Returns the allowance for a spender
1572      * @param owner The address of the owner of the tokens.
1573      * @param spender The address of the spender.
1574      * @return Number of tokens the spender is allowed to spend.
1575      */
1576     function allowance(address owner, address spender) external view returns (uint) {
1577         return token.allowance(owner, spender);
1578     }
1579 
1580 }
1581 
1582 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
1583 
1584 pragma solidity ^0.4.24;
1585 
1586 
1587 /**
1588  * @title Roles
1589  * @author Francisco Giordano (@frangio)
1590  * @dev Library for managing addresses assigned to a Role.
1591  * See RBAC.sol for example usage.
1592  */
1593 library Roles {
1594   struct Role {
1595     mapping (address => bool) bearer;
1596   }
1597 
1598   /**
1599    * @dev give an address access to this role
1600    */
1601   function add(Role storage _role, address _addr)
1602     internal
1603   {
1604     _role.bearer[_addr] = true;
1605   }
1606 
1607   /**
1608    * @dev remove an address' access to this role
1609    */
1610   function remove(Role storage _role, address _addr)
1611     internal
1612   {
1613     _role.bearer[_addr] = false;
1614   }
1615 
1616   /**
1617    * @dev check if an address has this role
1618    * // reverts
1619    */
1620   function check(Role storage _role, address _addr)
1621     internal
1622     view
1623   {
1624     require(has(_role, _addr));
1625   }
1626 
1627   /**
1628    * @dev check if an address has this role
1629    * @return bool
1630    */
1631   function has(Role storage _role, address _addr)
1632     internal
1633     view
1634     returns (bool)
1635   {
1636     return _role.bearer[_addr];
1637   }
1638 }
1639 
1640 // File: contracts/SystemRole.sol
1641 
1642 /**
1643  * Copyright 2019 Monerium ehf.
1644  *
1645  * Licensed under the Apache License, Version 2.0 (the "License");
1646  * you may not use this file except in compliance with the License.
1647  * You may obtain a copy of the License at
1648  *
1649  *     http://www.apache.org/licenses/LICENSE-2.0
1650  *
1651  * Unless required by applicable law or agreed to in writing, software
1652  * distributed under the License is distributed on an "AS IS" BASIS,
1653  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1654  * See the License for the specific language governing permissions and
1655  * limitations under the License.
1656  */
1657 
1658 pragma solidity 0.4.24;
1659 
1660 
1661 /**
1662  * @title SystemRole
1663  * @dev SystemRole accounts have been approved to perform operational actions (e.g. mint and burn).
1664  * @notice addSystemAccount and removeSystemAccount are unprotected by default, i.e. anyone can call them.
1665  * @notice Contracts inheriting SystemRole *should* authorize the caller by overriding them.
1666  */
1667 contract SystemRole {
1668 
1669     using Roles for Roles.Role;
1670     Roles.Role private systemAccounts;
1671 
1672     /**
1673      * @dev Emitted when system account is added.
1674      * @param account is a new system account.
1675      */
1676     event SystemAccountAdded(address indexed account);
1677 
1678     /**
1679      * @dev Emitted when system account is removed.
1680      * @param account is the old system account.
1681      */
1682     event SystemAccountRemoved(address indexed account);
1683 
1684     /**
1685      * @dev Modifier which prevents non-system accounts from calling protected functions.
1686      */
1687     modifier onlySystemAccounts() {
1688         require(isSystemAccount(msg.sender));
1689         _;
1690     }
1691 
1692     /**
1693      * @dev Modifier which prevents non-system accounts from being passed to the guard.
1694      * @param account The account to check.
1695      */
1696     modifier onlySystemAccount(address account) {
1697         require(
1698             isSystemAccount(account),
1699             "must be a system account"
1700         );
1701         _;
1702     }
1703 
1704     /**
1705      * @dev System Role constructor.
1706      * @notice The contract is an abstract contract as a result of the internal modifier.
1707      */
1708     constructor() internal {}
1709 
1710     /**
1711      * @dev Checks whether an address is a system account.
1712      * @param account the address to check.
1713      * @return true if system account.
1714      */
1715     function isSystemAccount(address account) public view returns (bool) {
1716         return systemAccounts.has(account);
1717     }
1718 
1719     /**
1720      * @dev Assigns the system role to an account.
1721      * @notice This method is unprotected and should be authorized in the child contract.
1722      */
1723     function addSystemAccount(address account) public {
1724         systemAccounts.add(account);
1725         emit SystemAccountAdded(account);
1726     }
1727 
1728     /**
1729      * @dev Removes the system role from an account.
1730      * @notice This method is unprotected and should be authorized in the child contract.
1731      */
1732     function removeSystemAccount(address account) public {
1733         systemAccounts.remove(account);
1734         emit SystemAccountRemoved(account);
1735     }
1736 
1737 }
1738 
1739 // File: contracts/MintableController.sol
1740 
1741 /**
1742  * Copyright 2019 Monerium ehf.
1743  *
1744  * Licensed under the Apache License, Version 2.0 (the "License");
1745  * you may not use this file except in compliance with the License.
1746  * You may obtain a copy of the License at
1747  *
1748  *     http://www.apache.org/licenses/LICENSE-2.0
1749  *
1750  * Unless required by applicable law or agreed to in writing, software
1751  * distributed under the License is distributed on an "AS IS" BASIS,
1752  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1753  * See the License for the specific language governing permissions and
1754  * limitations under the License.
1755  */
1756 
1757 pragma solidity 0.4.24;
1758 
1759 
1760 
1761 
1762 /**
1763 * @title MintableController
1764 * @dev This contracts implements functionality allowing for minting and burning of tokens.
1765 */
1766 contract MintableController is SystemRole, StandardController {
1767 
1768     using MintableTokenLib for TokenStorage;
1769 
1770     /**
1771      * @dev Contract constructor.
1772      * @param storage_ Address of the token storage for the controller.
1773      * @param initialSupply The amount of tokens to mint upon creation.
1774      * @param frontend_ Address of the authorized frontend.
1775      */
1776     constructor(address storage_, uint initialSupply, address frontend_)
1777         public
1778         StandardController(storage_, initialSupply, frontend_)
1779     { }
1780 
1781     /**
1782      * @dev Assigns the system role to an account.
1783      */
1784     function addSystemAccount(address account) public onlyOwner {
1785         super.addSystemAccount(account);
1786     }
1787 
1788     /**
1789      * @dev Removes the system role from an account.
1790      */
1791     function removeSystemAccount(address account) public onlyOwner {
1792         super.removeSystemAccount(account);
1793     }
1794 
1795     /**
1796      * @dev Mints new tokens.
1797      * @param caller Address of the caller passed through the frontend.
1798      * @param to Address to credit the tokens.
1799      * @param amount Number of tokens to mint.
1800      */
1801     function mintTo_withCaller(address caller, address to, uint amount)
1802         public
1803         guarded(caller)
1804         onlySystemAccount(caller)
1805         returns (bool)
1806     {
1807         avoidBlackholes(to);
1808         return token.mint(to, amount);
1809     }
1810 
1811     /**
1812      * @dev Burns tokens from token owner.
1813      * This removfes the burned tokens from circulation.
1814      * @param caller Address of the caller passed through the frontend.
1815      * @param from Address of the token owner.
1816      * @param amount Number of tokens to burn.
1817      * @param h Hash which the token owner signed.
1818      * @param v Signature component.
1819      * @param r Signature component.
1820      * @param s Sigature component.
1821      */
1822     function burnFrom_withCaller(address caller, address from, uint amount, bytes32 h, uint8 v, bytes32 r, bytes32 s)
1823         public
1824         guarded(caller)
1825         onlySystemAccount(caller)
1826         returns (bool)
1827     {
1828         return token.burn(from, amount, h, v, r, s);
1829     }
1830 
1831 }
1832 
1833 // File: contracts/SmartController.sol
1834 
1835 /**
1836  * Copyright 2019 Monerium ehf.
1837  *
1838  * Licensed under the Apache License, Version 2.0 (the "License");
1839  * you may not use this file except in compliance with the License.
1840  * You may obtain a copy of the License at
1841  *
1842  *     http://www.apache.org/licenses/LICENSE-2.0
1843  *
1844  * Unless required by applicable law or agreed to in writing, software
1845  * distributed under the License is distributed on an "AS IS" BASIS,
1846  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1847  * See the License for the specific language governing permissions and
1848  * limitations under the License.
1849  */
1850 
1851 pragma solidity 0.4.24;
1852 
1853 
1854 
1855 
1856 /**
1857  * @title SmartController
1858  * @dev This contract adds "smart" functionality which is required from a regulatory perspective.
1859  */
1860 contract SmartController is MintableController {
1861 
1862     using SmartTokenLib for SmartTokenLib.SmartStorage;
1863 
1864     SmartTokenLib.SmartStorage internal smartToken;
1865 
1866     bytes3 public ticker;
1867     uint constant public INITIAL_SUPPLY = 0;
1868 
1869     /**
1870      * @dev Contract constructor.
1871      * @param storage_ Address of the token storage for the controller.
1872      * @param validator Address of validator.
1873      * @param ticker_ 3 letter currency ticker.
1874      * @param frontend_ Address of the authorized frontend.
1875      */
1876     constructor(address storage_, address validator, bytes3 ticker_, address frontend_)
1877         public
1878         MintableController(storage_, INITIAL_SUPPLY, frontend_)
1879     {
1880         require(validator != 0x0, "validator cannot be the null address");
1881         smartToken.setValidator(validator);
1882         ticker = ticker_;
1883     }
1884 
1885     /**
1886      * @dev Sets a new validator.
1887      * @param validator Address of validator.
1888      */
1889     function setValidator(address validator) external onlySystemAccounts {
1890         smartToken.setValidator(validator);
1891     }
1892 
1893     /**
1894      * @dev Recovers tokens from an address and reissues them to another address.
1895      * In case a user loses its private key the tokens can be recovered by burning
1896      * the tokens from that address and reissuing to a new address.
1897      * To recover tokens the contract owner needs to provide a signature
1898      * proving that the token owner has authorized the owner to do so.
1899      * @param caller Address of the caller passed through the frontend.
1900      * @param from Address to burn tokens from.
1901      * @param to Address to mint tokens to.
1902      * @param h Hash which the token owner signed.
1903      * @param v Signature component.
1904      * @param r Signature component.
1905      * @param s Sigature component.
1906      * @return Amount recovered.
1907      */
1908     function recover_withCaller(address caller, address from, address to, bytes32 h, uint8 v, bytes32 r, bytes32 s)
1909         external
1910         guarded(caller)
1911         onlySystemAccount(caller)
1912         returns (uint)
1913     {
1914         avoidBlackholes(to);
1915         return SmartTokenLib.recover(token, from, to, h, v, r, s);
1916     }
1917 
1918     /**
1919      * @dev Transfers tokens [ERC20].
1920      * The caller, to address and amount are validated before executing method.
1921      * Prior to transfering tokens the validator needs to approve.
1922      * @notice Overrides method in a parent.
1923      * @param caller Address of the caller passed through the frontend.
1924      * @param to Recipient address.
1925      * @param amount Number of tokens to transfer.
1926      */
1927     function transfer_withCaller(address caller, address to, uint amount)
1928         public
1929         guarded(caller)
1930         whenNotPaused
1931         returns (bool)
1932     {
1933         require(smartToken.validate(caller, to, amount), "transfer request not valid");
1934         return super.transfer_withCaller(caller, to, amount);
1935     }
1936 
1937     /**
1938      * @dev Transfers tokens from a specific address [ERC20].
1939      * The address owner has to approve the spender beforehand.
1940      * The from address, to address and amount are validated before executing method.
1941      * @notice Overrides method in a parent.
1942      * Prior to transfering tokens the validator needs to approve.
1943      * @param caller Address of the caller passed through the frontend.
1944      * @param from Address to debet the tokens from.
1945      * @param to Recipient address.
1946      * @param amount Number of tokens to transfer.
1947      */
1948     function transferFrom_withCaller(address caller, address from, address to, uint amount)
1949         public
1950         guarded(caller)
1951         whenNotPaused
1952         returns (bool)
1953     {
1954         require(smartToken.validate(from, to, amount), "transferFrom request not valid");
1955         return super.transferFrom_withCaller(caller, from, to, amount);
1956     }
1957 
1958     /**
1959      * @dev Transfers tokens and subsequently calls a method on the recipient [ERC677].
1960      * If the recipient is a non-contract address this method behaves just like transfer.
1961      * The caller, to address and amount are validated before executing method.
1962      * @notice Overrides method in a parent.
1963      * @param caller Address of the caller passed through the frontend.
1964      * @param to Recipient address.
1965      * @param amount Number of tokens to transfer.
1966      * @param data Additional data passed to the recipient's tokenFallback method.
1967      */
1968     function transferAndCall_withCaller(
1969         address caller,
1970         address to,
1971         uint256 amount,
1972         bytes data
1973     )
1974         public
1975         guarded(caller)
1976         whenNotPaused
1977         returns (bool)
1978     {
1979         require(smartToken.validate(caller, to, amount), "transferAndCall request not valid");
1980         return super.transferAndCall_withCaller(caller, to, amount, data);
1981     }
1982 
1983     /**
1984      * @dev Gets the current validator.
1985      * @return Address of validator.
1986      */
1987     function getValidator() external view returns (address) {
1988         return smartToken.getValidator();
1989     }
1990 
1991 }
1992 
1993 // File: contracts/TokenFrontend.sol
1994 
1995 /**
1996  * Copyright 2019 Monerium ehf.
1997  *
1998  * Licensed under the Apache License, Version 2.0 (the "License");
1999  * you may not use this file except in compliance with the License.
2000  * You may obtain a copy of the License at
2001  *
2002  *     http://www.apache.org/licenses/LICENSE-2.0
2003  *
2004  * Unless required by applicable law or agreed to in writing, software
2005  * distributed under the License is distributed on an "AS IS" BASIS,
2006  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2007  * See the License for the specific language governing permissions and
2008  * limitations under the License.
2009  */
2010 
2011 pragma solidity 0.4.24;
2012 
2013 
2014 
2015 
2016 
2017 
2018 
2019 /**
2020  * @title TokenFrontend
2021  * @dev This contract implements a token forwarder.
2022  * The token frontend is [ERC20 and ERC677] compliant and forwards
2023  * standard methods to a controller. The primary function is to allow
2024  * for a statically deployed contract for users to interact with while
2025  * simultaneously allow the controllers to be upgraded when bugs are
2026  * discovered or new functionality needs to be added.
2027  */
2028 contract TokenFrontend is Destructible, Claimable, CanReclaimToken, NoOwner, IERC20 {
2029 
2030     SmartController internal controller;
2031 
2032     string public name;
2033     string public symbol;
2034     bytes3 public ticker;
2035 
2036     /**
2037      * @dev Emitted when tokens are transferred.
2038      * @param from Sender address.
2039      * @param to Recipient address.
2040      * @param amount Number of tokens transferred.
2041      */
2042     event Transfer(address indexed from, address indexed to, uint amount);
2043 
2044     /**
2045      * @dev Emitted when tokens are transferred.
2046      * @param from Sender address.
2047      * @param to Recipient address.
2048      * @param amount Number of tokens transferred.
2049      * @param data Additional data passed to the recipient's tokenFallback method.
2050      */
2051     event Transfer(address indexed from, address indexed to, uint amount, bytes data);
2052 
2053     /**
2054      * @dev Emitted when spender is granted an allowance.
2055      * @param owner Address of the owner of the tokens to spend.
2056      * @param spender The address of the future spender.
2057      * @param amount The allowance of the spender.
2058      */
2059     event Approval(address indexed owner, address indexed spender, uint amount);
2060 
2061     /**
2062      * @dev Emitted when updating the controller.
2063      * @param ticker Three letter ticker representing the currency.
2064      * @param old Address of the old controller.
2065      * @param current Address of the new controller.
2066      */
2067     event Controller(bytes3 indexed ticker, address indexed old, address indexed current);
2068 
2069     /**
2070      * @dev Contract constructor.
2071      * @notice The contract is an abstract contract as a result of the internal modifier.
2072      * @param name_ Token name.
2073      * @param symbol_ Token symbol.
2074      * @param ticker_ 3 letter currency ticker.
2075      */
2076     constructor(string name_, string symbol_, bytes3 ticker_) internal {
2077         name = name_;
2078         symbol = symbol_;
2079         ticker = ticker_;
2080     }
2081 
2082     /**
2083      * @dev Sets a new controller.
2084      * @param address_ Address of the controller.
2085      */
2086     function setController(address address_) external onlyOwner {
2087         require(address_ != 0x0, "controller address cannot be the null address");
2088         emit Controller(ticker, controller, address_);
2089         controller = SmartController(address_);
2090         require(controller.getFrontend() == address(this), "controller frontend does not point back");
2091         require(controller.ticker() == ticker, "ticker does not match controller ticket");
2092     }
2093 
2094     /**
2095      * @dev Transfers tokens [ERC20].
2096      * @param to Recipient address.
2097      * @param amount Number of tokens to transfer.
2098      */
2099     function transfer(address to, uint amount) external returns (bool ok) {
2100         ok = controller.transfer_withCaller(msg.sender, to, amount);
2101         emit Transfer(msg.sender, to, amount);
2102     }
2103 
2104     /**
2105      * @dev Transfers tokens from a specific address [ERC20].
2106      * The address owner has to approve the spender beforehand.
2107      * @param from Address to debet the tokens from.
2108      * @param to Recipient address.
2109      * @param amount Number of tokens to transfer.
2110      */
2111     function transferFrom(address from, address to, uint amount) external returns (bool ok) {
2112         ok = controller.transferFrom_withCaller(msg.sender, from, to, amount);
2113         emit Transfer(from, to, amount);
2114     }
2115 
2116     /**
2117      * @dev Approves a spender [ERC20].
2118      * Note that using the approve/transferFrom presents a possible
2119      * security vulnerability described in:
2120      * https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#heading=h.quou09mcbpzw
2121      * Use transferAndCall to mitigate.
2122      * @param spender The address of the future spender.
2123      * @param amount The allowance of the spender.
2124      */
2125     function approve(address spender, uint amount) external returns (bool ok) {
2126         ok = controller.approve_withCaller(msg.sender, spender, amount);
2127         emit Approval(msg.sender, spender, amount);
2128     }
2129 
2130     /**
2131      * @dev Transfers tokens and subsequently calls a method on the recipient [ERC677].
2132      * If the recipient is a non-contract address this method behaves just like transfer.
2133      * @param to Recipient address.
2134      * @param amount Number of tokens to transfer.
2135      * @param data Additional data passed to the recipient's tokenFallback method.
2136      */
2137     function transferAndCall(address to, uint256 amount, bytes data)
2138         external
2139         returns (bool ok)
2140     {
2141         ok = controller.transferAndCall_withCaller(msg.sender, to, amount, data);
2142         emit Transfer(msg.sender, to, amount);
2143         emit Transfer(msg.sender, to, amount, data);
2144     }
2145 
2146     /**
2147      * @dev Mints new tokens.
2148      * @param to Address to credit the tokens.
2149      * @param amount Number of tokens to mint.
2150      */
2151     function mintTo(address to, uint amount)
2152         external
2153         returns (bool ok)
2154     {
2155         ok = controller.mintTo_withCaller(msg.sender, to, amount);
2156         emit Transfer(0x0, to, amount);
2157     }
2158 
2159     /**
2160      * @dev Burns tokens from token owner.
2161      * This removfes the burned tokens from circulation.
2162      * @param from Address of the token owner.
2163      * @param amount Number of tokens to burn.
2164      * @param h Hash which the token owner signed.
2165      * @param v Signature component.
2166      * @param r Signature component.
2167      * @param s Sigature component.
2168      */
2169     function burnFrom(address from, uint amount, bytes32 h, uint8 v, bytes32 r, bytes32 s)
2170         external
2171         returns (bool ok)
2172     {
2173         ok = controller.burnFrom_withCaller(msg.sender, from, amount, h, v, r, s);
2174         emit Transfer(from, 0x0, amount);
2175     }
2176 
2177     /**
2178      * @dev Recovers tokens from an address and reissues them to another address.
2179      * In case a user loses its private key the tokens can be recovered by burning
2180      * the tokens from that address and reissuing to a new address.
2181      * To recover tokens the contract owner needs to provide a signature
2182      * proving that the token owner has authorized the owner to do so.
2183      * @param from Address to burn tokens from.
2184      * @param to Address to mint tokens to.
2185      * @param h Hash which the token owner signed.
2186      * @param v Signature component.
2187      * @param r Signature component.
2188      * @param s Sigature component.
2189      * @return Amount recovered.
2190      */
2191     function recover(address from, address to, bytes32 h, uint8 v, bytes32 r, bytes32 s)
2192         external
2193         returns (uint amount)
2194     {
2195         amount = controller.recover_withCaller(msg.sender, from, to, h ,v, r, s);
2196         emit Transfer(from, to, amount);
2197     }
2198 
2199     /**
2200      * @dev Gets the current controller.
2201      * @return Address of the controller.
2202      */
2203     function getController() external view returns (address) {
2204         return address(controller);
2205     }
2206 
2207     /**
2208      * @dev Returns the total supply.
2209      * @return Number of tokens.
2210      */
2211     function totalSupply() external view returns (uint) {
2212         return controller.totalSupply();
2213     }
2214 
2215     /**
2216      * @dev Returns the number tokens associated with an address.
2217      * @param who Address to lookup.
2218      * @return Balance of address.
2219      */
2220     function balanceOf(address who) external view returns (uint) {
2221         return controller.balanceOf(who);
2222     }
2223 
2224     /**
2225      * @dev Returns the allowance for a spender
2226      * @param owner The address of the owner of the tokens.
2227      * @param spender The address of the spender.
2228      * @return Number of tokens the spender is allowed to spend.
2229      */
2230     function allowance(address owner, address spender) external view returns (uint) {
2231         return controller.allowance(owner, spender);
2232     }
2233 
2234     /**
2235      * @dev Returns the number of decimals in one token.
2236      * @return Number of decimals.
2237      */
2238     function decimals() external view returns (uint) {
2239         return controller.decimals();
2240     }
2241 
2242 }
2243 
2244 // File: contracts/EUR.sol
2245 
2246 /**
2247  * Copyright 2019 Monerium ehf.
2248  *
2249  * Licensed under the Apache License, Version 2.0 (the "License");
2250  * you may not use this file except in compliance with the License.
2251  * You may obtain a copy of the License at
2252  *
2253  *     http://www.apache.org/licenses/LICENSE-2.0
2254  *
2255  * Unless required by applicable law or agreed to in writing, software
2256  * distributed under the License is distributed on an "AS IS" BASIS,
2257  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2258  * See the License for the specific language governing permissions and
2259  * limitations under the License.
2260  */
2261 
2262 pragma solidity 0.4.24;
2263 
2264 
2265 contract EUR is TokenFrontend {
2266 
2267     constructor()
2268         public
2269         TokenFrontend("Monerium EUR emoney", "EURe", "EUR")
2270     { }
2271 
2272 }