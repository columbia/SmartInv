1 pragma solidity 0.4.24;
2 pragma experimental "v0.5.0";
3 
4 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (_a == 0) {
20       return 0;
21     }
22 
23     c = _a * _b;
24     assert(c / _a == _b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
32     // assert(_b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = _a / _b;
34     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
35     return _a / _b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     assert(_b <= _a);
43     return _a - _b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     c = _a + _b;
51     assert(c >= _a);
52     return c;
53   }
54 }
55 
56 // File: openzeppelin-solidity/contracts/math/Math.sol
57 
58 /**
59  * @title Math
60  * @dev Assorted math operations
61  */
62 library Math {
63   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
64     return _a >= _b ? _a : _b;
65   }
66 
67   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
68     return _a < _b ? _a : _b;
69   }
70 
71   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
72     return _a >= _b ? _a : _b;
73   }
74 
75   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     return _a < _b ? _a : _b;
77   }
78 }
79 
80 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
81 
82 /**
83  * @title Ownable
84  * @dev The Ownable contract has an owner address, and provides basic authorization control
85  * functions, this simplifies the implementation of "user permissions".
86  */
87 contract Ownable {
88   address public owner;
89 
90 
91   event OwnershipRenounced(address indexed previousOwner);
92   event OwnershipTransferred(
93     address indexed previousOwner,
94     address indexed newOwner
95   );
96 
97 
98   /**
99    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100    * account.
101    */
102   constructor() public {
103     owner = msg.sender;
104   }
105 
106   /**
107    * @dev Throws if called by any account other than the owner.
108    */
109   modifier onlyOwner() {
110     require(msg.sender == owner);
111     _;
112   }
113 
114   /**
115    * @dev Allows the current owner to relinquish control of the contract.
116    * @notice Renouncing to ownership will leave the contract without an owner.
117    * It will not be possible to call the functions with the `onlyOwner`
118    * modifier anymore.
119    */
120   function renounceOwnership() public onlyOwner {
121     emit OwnershipRenounced(owner);
122     owner = address(0);
123   }
124 
125   /**
126    * @dev Allows the current owner to transfer control of the contract to a newOwner.
127    * @param _newOwner The address to transfer ownership to.
128    */
129   function transferOwnership(address _newOwner) public onlyOwner {
130     _transferOwnership(_newOwner);
131   }
132 
133   /**
134    * @dev Transfers control of the contract to a newOwner.
135    * @param _newOwner The address to transfer ownership to.
136    */
137   function _transferOwnership(address _newOwner) internal {
138     require(_newOwner != address(0));
139     emit OwnershipTransferred(owner, _newOwner);
140     owner = _newOwner;
141   }
142 }
143 
144 // File: contracts/lib/AccessControlledBase.sol
145 
146 /*
147 
148     Copyright 2018 dYdX Trading Inc.
149 
150     Licensed under the Apache License, Version 2.0 (the "License");
151     you may not use this file except in compliance with the License.
152     You may obtain a copy of the License at
153 
154     http://www.apache.org/licenses/LICENSE-2.0
155 
156     Unless required by applicable law or agreed to in writing, software
157     distributed under the License is distributed on an "AS IS" BASIS,
158     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
159     See the License for the specific language governing permissions and
160     limitations under the License.
161 
162 */
163 
164 
165 /**
166  * @title AccessControlledBase
167  * @author dYdX
168  *
169  * Base functionality for access control. Requires an implementation to
170  * provide a way to grant and optionally revoke access
171  */
172 contract AccessControlledBase {
173     // ============ State Variables ============
174 
175     mapping (address => bool) public authorized;
176 
177     // ============ Events ============
178 
179     event AccessGranted(
180         address who
181     );
182 
183     event AccessRevoked(
184         address who
185     );
186 
187     // ============ Modifiers ============
188 
189     modifier requiresAuthorization() {
190         require(
191             authorized[msg.sender],
192             "AccessControlledBase#requiresAuthorization: Sender not authorized"
193         );
194         _;
195     }
196 }
197 
198 // File: contracts/lib/StaticAccessControlled.sol
199 
200 /*
201 
202     Copyright 2018 dYdX Trading Inc.
203 
204     Licensed under the Apache License, Version 2.0 (the "License");
205     you may not use this file except in compliance with the License.
206     You may obtain a copy of the License at
207 
208     http://www.apache.org/licenses/LICENSE-2.0
209 
210     Unless required by applicable law or agreed to in writing, software
211     distributed under the License is distributed on an "AS IS" BASIS,
212     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
213     See the License for the specific language governing permissions and
214     limitations under the License.
215 
216 */
217 
218 
219 /**
220  * @title StaticAccessControlled
221  * @author dYdX
222  *
223  * Allows for functions to be access controled
224  * Permissions cannot be changed after a grace period
225  */
226 contract StaticAccessControlled is AccessControlledBase, Ownable {
227     using SafeMath for uint256;
228 
229     // ============ State Variables ============
230 
231     // Timestamp after which no additional access can be granted
232     uint256 public GRACE_PERIOD_EXPIRATION;
233 
234     // ============ Constructor ============
235 
236     constructor(
237         uint256 gracePeriod
238     )
239         public
240         Ownable()
241     {
242         GRACE_PERIOD_EXPIRATION = block.timestamp.add(gracePeriod);
243     }
244 
245     // ============ Owner-Only State-Changing Functions ============
246 
247     function grantAccess(
248         address who
249     )
250         external
251         onlyOwner
252     {
253         require(
254             block.timestamp < GRACE_PERIOD_EXPIRATION,
255             "StaticAccessControlled#grantAccess: Cannot grant access after grace period"
256         );
257 
258         emit AccessGranted(who);
259         authorized[who] = true;
260     }
261 }
262 
263 // File: contracts/lib/GeneralERC20.sol
264 
265 /*
266 
267     Copyright 2018 dYdX Trading Inc.
268 
269     Licensed under the Apache License, Version 2.0 (the "License");
270     you may not use this file except in compliance with the License.
271     You may obtain a copy of the License at
272 
273     http://www.apache.org/licenses/LICENSE-2.0
274 
275     Unless required by applicable law or agreed to in writing, software
276     distributed under the License is distributed on an "AS IS" BASIS,
277     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
278     See the License for the specific language governing permissions and
279     limitations under the License.
280 
281 */
282 
283 
284 /**
285  * @title GeneralERC20
286  * @author dYdX
287  *
288  * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
289  * that we dont automatically revert when calling non-compliant tokens that have no return value for
290  * transfer(), transferFrom(), or approve().
291  */
292 interface GeneralERC20 {
293     function totalSupply(
294     )
295         external
296         view
297         returns (uint256);
298 
299     function balanceOf(
300         address who
301     )
302         external
303         view
304         returns (uint256);
305 
306     function allowance(
307         address owner,
308         address spender
309     )
310         external
311         view
312         returns (uint256);
313 
314     function transfer(
315         address to,
316         uint256 value
317     )
318         external;
319 
320 
321     function transferFrom(
322         address from,
323         address to,
324         uint256 value
325     )
326         external;
327 
328     function approve(
329         address spender,
330         uint256 value
331     )
332         external;
333 }
334 
335 // File: contracts/lib/TokenInteract.sol
336 
337 /*
338 
339     Copyright 2018 dYdX Trading Inc.
340 
341     Licensed under the Apache License, Version 2.0 (the "License");
342     you may not use this file except in compliance with the License.
343     You may obtain a copy of the License at
344 
345     http://www.apache.org/licenses/LICENSE-2.0
346 
347     Unless required by applicable law or agreed to in writing, software
348     distributed under the License is distributed on an "AS IS" BASIS,
349     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
350     See the License for the specific language governing permissions and
351     limitations under the License.
352 
353 */
354 
355 
356 /**
357  * @title TokenInteract
358  * @author dYdX
359  *
360  * This library contains functions for interacting with ERC20 tokens
361  */
362 library TokenInteract {
363     function balanceOf(
364         address token,
365         address owner
366     )
367         internal
368         view
369         returns (uint256)
370     {
371         return GeneralERC20(token).balanceOf(owner);
372     }
373 
374     function allowance(
375         address token,
376         address owner,
377         address spender
378     )
379         internal
380         view
381         returns (uint256)
382     {
383         return GeneralERC20(token).allowance(owner, spender);
384     }
385 
386     function approve(
387         address token,
388         address spender,
389         uint256 amount
390     )
391         internal
392     {
393         GeneralERC20(token).approve(spender, amount);
394 
395         require(
396             checkSuccess(),
397             "TokenInteract#approve: Approval failed"
398         );
399     }
400 
401     function transfer(
402         address token,
403         address to,
404         uint256 amount
405     )
406         internal
407     {
408         address from = address(this);
409         if (
410             amount == 0
411             || from == to
412         ) {
413             return;
414         }
415 
416         GeneralERC20(token).transfer(to, amount);
417 
418         require(
419             checkSuccess(),
420             "TokenInteract#transfer: Transfer failed"
421         );
422     }
423 
424     function transferFrom(
425         address token,
426         address from,
427         address to,
428         uint256 amount
429     )
430         internal
431     {
432         if (
433             amount == 0
434             || from == to
435         ) {
436             return;
437         }
438 
439         GeneralERC20(token).transferFrom(from, to, amount);
440 
441         require(
442             checkSuccess(),
443             "TokenInteract#transferFrom: TransferFrom failed"
444         );
445     }
446 
447     // ============ Private Helper-Functions ============
448 
449     /**
450      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
451      * function returned 0 bytes or 32 bytes that are not all-zero.
452      */
453     function checkSuccess(
454     )
455         private
456         pure
457         returns (bool)
458     {
459         uint256 returnValue = 0;
460 
461         /* solium-disable-next-line security/no-inline-assembly */
462         assembly {
463             // check number of bytes returned from last function call
464             switch returndatasize
465 
466             // no bytes returned: assume success
467             case 0x0 {
468                 returnValue := 1
469             }
470 
471             // 32 bytes returned: check if non-zero
472             case 0x20 {
473                 // copy 32 bytes into scratch space
474                 returndatacopy(0x0, 0x0, 0x20)
475 
476                 // load those bytes into returnValue
477                 returnValue := mload(0x0)
478             }
479 
480             // not sure what was returned: dont mark as success
481             default { }
482         }
483 
484         return returnValue != 0;
485     }
486 }
487 
488 // File: contracts/margin/TokenProxy.sol
489 
490 /*
491 
492     Copyright 2018 dYdX Trading Inc.
493 
494     Licensed under the Apache License, Version 2.0 (the "License");
495     you may not use this file except in compliance with the License.
496     You may obtain a copy of the License at
497 
498     http://www.apache.org/licenses/LICENSE-2.0
499 
500     Unless required by applicable law or agreed to in writing, software
501     distributed under the License is distributed on an "AS IS" BASIS,
502     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
503     See the License for the specific language governing permissions and
504     limitations under the License.
505 
506 */
507 
508 
509 /**
510  * @title TokenProxy
511  * @author dYdX
512  *
513  * Used to transfer tokens between addresses which have set allowance on this contract.
514  */
515 contract TokenProxy is StaticAccessControlled {
516     using SafeMath for uint256;
517 
518     // ============ Constructor ============
519 
520     constructor(
521         uint256 gracePeriod
522     )
523         public
524         StaticAccessControlled(gracePeriod)
525     {}
526 
527     // ============ Authorized-Only State Changing Functions ============
528 
529     /**
530      * Transfers tokens from an address (that has set allowance on the proxy) to another address.
531      *
532      * @param  token  The address of the ERC20 token
533      * @param  from   The address to transfer token from
534      * @param  to     The address to transfer tokens to
535      * @param  value  The number of tokens to transfer
536      */
537     function transferTokens(
538         address token,
539         address from,
540         address to,
541         uint256 value
542     )
543         external
544         requiresAuthorization
545     {
546         TokenInteract.transferFrom(
547             token,
548             from,
549             to,
550             value
551         );
552     }
553 
554     // ============ Public Constant Functions ============
555 
556     /**
557      * Getter function to get the amount of token that the proxy is able to move for a particular
558      * address. The minimum of 1) the balance of that address and 2) the allowance given to proxy.
559      *
560      * @param  who    The owner of the tokens
561      * @param  token  The address of the ERC20 token
562      * @return        The number of tokens able to be moved by the proxy from the address specified
563      */
564     function available(
565         address who,
566         address token
567     )
568         external
569         view
570         returns (uint256)
571     {
572         return Math.min256(
573             TokenInteract.allowance(token, who, address(this)),
574             TokenInteract.balanceOf(token, who)
575         );
576     }
577 }
578 
579 // File: contracts/margin/Vault.sol
580 
581 /*
582 
583     Copyright 2018 dYdX Trading Inc.
584 
585     Licensed under the Apache License, Version 2.0 (the "License");
586     you may not use this file except in compliance with the License.
587     You may obtain a copy of the License at
588 
589     http://www.apache.org/licenses/LICENSE-2.0
590 
591     Unless required by applicable law or agreed to in writing, software
592     distributed under the License is distributed on an "AS IS" BASIS,
593     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
594     See the License for the specific language governing permissions and
595     limitations under the License.
596 
597 */
598 
599 
600 /**
601  * @title Vault
602  * @author dYdX
603  *
604  * Holds and transfers tokens in vaults denominated by id
605  *
606  * Vault only supports ERC20 tokens, and will not accept any tokens that require
607  * a tokenFallback or equivalent function (See ERC223, ERC777, etc.)
608  */
609 contract Vault is StaticAccessControlled
610 {
611     using SafeMath for uint256;
612 
613     // ============ Events ============
614 
615     event ExcessTokensWithdrawn(
616         address indexed token,
617         address indexed to,
618         address caller
619     );
620 
621     // ============ State Variables ============
622 
623     // Address of the TokenProxy contract. Used for moving tokens.
624     address public TOKEN_PROXY;
625 
626     // Map from vault ID to map from token address to amount of that token attributed to the
627     // particular vault ID.
628     mapping (bytes32 => mapping (address => uint256)) public balances;
629 
630     // Map from token address to total amount of that token attributed to some account.
631     mapping (address => uint256) public totalBalances;
632 
633     // ============ Constructor ============
634 
635     constructor(
636         address proxy,
637         uint256 gracePeriod
638     )
639         public
640         StaticAccessControlled(gracePeriod)
641     {
642         TOKEN_PROXY = proxy;
643     }
644 
645     // ============ Owner-Only State-Changing Functions ============
646 
647     /**
648      * Allows the owner to withdraw any excess tokens sent to the vault by unconventional means,
649      * including (but not limited-to) token airdrops. Any tokens moved to the vault by TOKEN_PROXY
650      * will be accounted for and will not be withdrawable by this function.
651      *
652      * @param  token  ERC20 token address
653      * @param  to     Address to transfer tokens to
654      * @return        Amount of tokens withdrawn
655      */
656     function withdrawExcessToken(
657         address token,
658         address to
659     )
660         external
661         onlyOwner
662         returns (uint256)
663     {
664         uint256 actualBalance = TokenInteract.balanceOf(token, address(this));
665         uint256 accountedBalance = totalBalances[token];
666         uint256 withdrawableBalance = actualBalance.sub(accountedBalance);
667 
668         require(
669             withdrawableBalance != 0,
670             "Vault#withdrawExcessToken: Withdrawable token amount must be non-zero"
671         );
672 
673         TokenInteract.transfer(token, to, withdrawableBalance);
674 
675         emit ExcessTokensWithdrawn(token, to, msg.sender);
676 
677         return withdrawableBalance;
678     }
679 
680     // ============ Authorized-Only State-Changing Functions ============
681 
682     /**
683      * Transfers tokens from an address (that has approved the proxy) to the vault.
684      *
685      * @param  id      The vault which will receive the tokens
686      * @param  token   ERC20 token address
687      * @param  from    Address from which the tokens will be taken
688      * @param  amount  Number of the token to be sent
689      */
690     function transferToVault(
691         bytes32 id,
692         address token,
693         address from,
694         uint256 amount
695     )
696         external
697         requiresAuthorization
698     {
699         // First send tokens to this contract
700         TokenProxy(TOKEN_PROXY).transferTokens(
701             token,
702             from,
703             address(this),
704             amount
705         );
706 
707         // Then increment balances
708         balances[id][token] = balances[id][token].add(amount);
709         totalBalances[token] = totalBalances[token].add(amount);
710 
711         // This should always be true. If not, something is very wrong
712         assert(totalBalances[token] >= balances[id][token]);
713 
714         validateBalance(token);
715     }
716 
717     /**
718      * Transfers a certain amount of funds to an address.
719      *
720      * @param  id      The vault from which to send the tokens
721      * @param  token   ERC20 token address
722      * @param  to      Address to transfer tokens to
723      * @param  amount  Number of the token to be sent
724      */
725     function transferFromVault(
726         bytes32 id,
727         address token,
728         address to,
729         uint256 amount
730     )
731         external
732         requiresAuthorization
733     {
734         // Next line also asserts that (balances[id][token] >= amount);
735         balances[id][token] = balances[id][token].sub(amount);
736 
737         // Next line also asserts that (totalBalances[token] >= amount);
738         totalBalances[token] = totalBalances[token].sub(amount);
739 
740         // This should always be true. If not, something is very wrong
741         assert(totalBalances[token] >= balances[id][token]);
742 
743         // Do the sending
744         TokenInteract.transfer(token, to, amount); // asserts transfer succeeded
745 
746         // Final validation
747         validateBalance(token);
748     }
749 
750     // ============ Private Helper-Functions ============
751 
752     /**
753      * Verifies that this contract is in control of at least as many tokens as accounted for
754      *
755      * @param  token  Address of ERC20 token
756      */
757     function validateBalance(
758         address token
759     )
760         private
761         view
762     {
763         // The actual balance could be greater than totalBalances[token] because anyone
764         // can send tokens to the contract's address which cannot be accounted for
765         assert(TokenInteract.balanceOf(token, address(this)) >= totalBalances[token]);
766     }
767 }