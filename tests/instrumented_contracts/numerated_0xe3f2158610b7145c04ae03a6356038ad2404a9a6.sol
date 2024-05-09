1 pragma solidity ^0.4.25;
2 
3 library Roles {
4   struct Role {
5     mapping (address => bool) bearer;
6   }
7 
8   /**
9    * @dev give an account access to this role
10    */
11   function add(Role storage role, address account) internal {
12     require(account != address(0));
13     require(!has(role, account));
14 
15     role.bearer[account] = true;
16   }
17 
18   /**
19    * @dev remove an account's access to this role
20    */
21   function remove(Role storage role, address account) internal {
22     require(account != address(0));
23     require(has(role, account));
24 
25     role.bearer[account] = false;
26   }
27 
28   /**
29    * @dev check if an account has this role
30    * @return bool
31    */
32   function has(Role storage role, address account)
33     internal
34     view
35     returns (bool)
36   {
37     require(account != address(0));
38     return role.bearer[account];
39   }
40 }
41 
42 contract MinterRole {
43   using Roles for Roles.Role;
44 
45   event MinterAdded(address indexed account);
46   event MinterRemoved(address indexed account);
47 
48   Roles.Role private minters;
49 
50   constructor() internal {
51     _addMinter(msg.sender);
52   }
53 
54   modifier onlyMinter() {
55     require(isMinter(msg.sender));
56     _;
57   }
58 
59   function isMinter(address account) public view returns (bool) {
60     return minters.has(account);
61   }
62 
63   function addMinter(address account) public onlyMinter {
64     _addMinter(account);
65   }
66 
67   function renounceMinter() public {
68     _removeMinter(msg.sender);
69   }
70 
71   function _addMinter(address account) internal {
72     minters.add(account);
73     emit MinterAdded(account);
74   }
75 
76   function _removeMinter(address account) internal {
77     minters.remove(account);
78     emit MinterRemoved(account);
79   }
80 }
81 
82 library SafeMath {
83 
84   /**
85   * @dev Multiplies two numbers, reverts on overflow.
86   */
87   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89     // benefit is lost if 'b' is also tested.
90     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
91     if (a == 0) {
92       return 0;
93     }
94 
95     uint256 c = a * b;
96     require(c / a == b);
97 
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
103   */
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     require(b > 0); // Solidity only automatically asserts when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109     return c;
110   }
111 
112   /**
113   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
114   */
115   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116     require(b <= a);
117     uint256 c = a - b;
118 
119     return c;
120   }
121 
122   /**
123   * @dev Adds two numbers, reverts on overflow.
124   */
125   function add(uint256 a, uint256 b) internal pure returns (uint256) {
126     uint256 c = a + b;
127     require(c >= a);
128 
129     return c;
130   }
131 
132   /**
133   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
134   * reverts when dividing by zero.
135   */
136   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137     require(b != 0);
138     return a % b;
139   }
140 }
141 
142 interface IERC20 {
143   function totalSupply() external view returns (uint256);
144 
145   function balanceOf(address who) external view returns (uint256);
146 
147   function allowance(address owner, address spender)
148     external view returns (uint256);
149 
150   function transfer(address to, uint256 value) external returns (bool);
151 
152   function approve(address spender, uint256 value)
153     external returns (bool);
154 
155   function transferFrom(address from, address to, uint256 value)
156     external returns (bool);
157 
158   event Transfer(
159     address indexed from,
160     address indexed to,
161     uint256 value
162   );
163 
164   event Approval(
165     address indexed owner,
166     address indexed spender,
167     uint256 value
168   );
169 }
170 
171 contract ERC20 is IERC20 {
172   using SafeMath for uint256;
173 
174   mapping (address => uint256) private _balances;
175 
176   mapping (address => mapping (address => uint256)) private _allowed;
177 
178   uint256 private _totalSupply;
179 
180   /**
181   * @dev Total number of tokens in existence
182   */
183   function totalSupply() public view returns (uint256) {
184     return _totalSupply;
185   }
186 
187   /**
188   * @dev Gets the balance of the specified address.
189   * @param owner The address to query the balance of.
190   * @return An uint256 representing the amount owned by the passed address.
191   */
192   function balanceOf(address owner) public view returns (uint256) {
193     return _balances[owner];
194   }
195 
196   /**
197    * @dev Function to check the amount of tokens that an owner allowed to a spender.
198    * @param owner address The address which owns the funds.
199    * @param spender address The address which will spend the funds.
200    * @return A uint256 specifying the amount of tokens still available for the spender.
201    */
202   function allowance(
203     address owner,
204     address spender
205    )
206     public
207     view
208     returns (uint256)
209   {
210     return _allowed[owner][spender];
211   }
212 
213   /**
214   * @dev Transfer token for a specified address
215   * @param to The address to transfer to.
216   * @param value The amount to be transferred.
217   */
218   function transfer(address to, uint256 value) public returns (bool) {
219     _transfer(msg.sender, to, value);
220     return true;
221   }
222 
223   /**
224    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
225    * Beware that changing an allowance with this method brings the risk that someone may use both the old
226    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
227    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
228    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229    * @param spender The address which will spend the funds.
230    * @param value The amount of tokens to be spent.
231    */
232   function approve(address spender, uint256 value) public returns (bool) {
233     require(spender != address(0));
234 
235     _allowed[msg.sender][spender] = value;
236     emit Approval(msg.sender, spender, value);
237     return true;
238   }
239 
240   /**
241    * @dev Transfer tokens from one address to another
242    * @param from address The address which you want to send tokens from
243    * @param to address The address which you want to transfer to
244    * @param value uint256 the amount of tokens to be transferred
245    */
246   function transferFrom(
247     address from,
248     address to,
249     uint256 value
250   )
251     public
252     returns (bool)
253   {
254     require(value <= _allowed[from][msg.sender]);
255 
256     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
257     _transfer(from, to, value);
258     return true;
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    * approve should be called when allowed_[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param spender The address which will spend the funds.
268    * @param addedValue The amount of tokens to increase the allowance by.
269    */
270   function increaseAllowance(
271     address spender,
272     uint256 addedValue
273   )
274     public
275     returns (bool)
276   {
277     require(spender != address(0));
278 
279     _allowed[msg.sender][spender] = (
280       _allowed[msg.sender][spender].add(addedValue));
281     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
282     return true;
283   }
284 
285   /**
286    * @dev Decrease the amount of tokens that an owner allowed to a spender.
287    * approve should be called when allowed_[_spender] == 0. To decrement
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    * @param spender The address which will spend the funds.
292    * @param subtractedValue The amount of tokens to decrease the allowance by.
293    */
294   function decreaseAllowance(
295     address spender,
296     uint256 subtractedValue
297   )
298     public
299     returns (bool)
300   {
301     require(spender != address(0));
302 
303     _allowed[msg.sender][spender] = (
304       _allowed[msg.sender][spender].sub(subtractedValue));
305     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
306     return true;
307   }
308 
309   /**
310   * @dev Transfer token for a specified addresses
311   * @param from The address to transfer from.
312   * @param to The address to transfer to.
313   * @param value The amount to be transferred.
314   */
315   function _transfer(address from, address to, uint256 value) internal {
316     require(value <= _balances[from]);
317     require(to != address(0));
318 
319     _balances[from] = _balances[from].sub(value);
320     _balances[to] = _balances[to].add(value);
321     emit Transfer(from, to, value);
322   }
323 
324   /**
325    * @dev Internal function that mints an amount of the token and assigns it to
326    * an account. This encapsulates the modification of balances such that the
327    * proper events are emitted.
328    * @param account The account that will receive the created tokens.
329    * @param value The amount that will be created.
330    */
331   function _mint(address account, uint256 value) internal {
332     require(account != 0);
333     _totalSupply = _totalSupply.add(value);
334     _balances[account] = _balances[account].add(value);
335     emit Transfer(address(0), account, value);
336   }
337 
338   /**
339    * @dev Internal function that burns an amount of the token of a given
340    * account.
341    * @param account The account whose tokens will be burnt.
342    * @param value The amount that will be burnt.
343    */
344   function _burn(address account, uint256 value) internal {
345     require(account != 0);
346     require(value <= _balances[account]);
347 
348     _totalSupply = _totalSupply.sub(value);
349     _balances[account] = _balances[account].sub(value);
350     emit Transfer(account, address(0), value);
351   }
352 
353   /**
354    * @dev Internal function that burns an amount of the token of a given
355    * account, deducting from the sender's allowance for said account. Uses the
356    * internal burn function.
357    * @param account The account whose tokens will be burnt.
358    * @param value The amount that will be burnt.
359    */
360   function _burnFrom(address account, uint256 value) internal {
361     require(value <= _allowed[account][msg.sender]);
362 
363     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
364     // this function needs to emit an event with the updated approval.
365     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
366       value);
367     _burn(account, value);
368   }
369 }
370 
371 contract ERC20Mintable is ERC20, MinterRole {
372   /**
373    * @dev Function to mint tokens
374    * @param to The address that will receive the minted tokens.
375    * @param value The amount of tokens to mint.
376    * @return A boolean that indicates if the operation was successful.
377    */
378   function mint(
379     address to,
380     uint256 value
381   )
382     public
383     onlyMinter
384     returns (bool)
385   {
386     _mint(to, value);
387     return true;
388   }
389 }
390 
391 library SafeERC20 {
392 
393   using SafeMath for uint256;
394 
395   function safeTransfer(
396     IERC20 token,
397     address to,
398     uint256 value
399   )
400     internal
401   {
402     require(token.transfer(to, value));
403   }
404 
405   function safeTransferFrom(
406     IERC20 token,
407     address from,
408     address to,
409     uint256 value
410   )
411     internal
412   {
413     require(token.transferFrom(from, to, value));
414   }
415 
416   function safeApprove(
417     IERC20 token,
418     address spender,
419     uint256 value
420   )
421     internal
422   {
423     // safeApprove should only be called when setting an initial allowance, 
424     // or when resetting it to zero. To increase and decrease it, use 
425     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
426     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
427     require(token.approve(spender, value));
428   }
429 
430   function safeIncreaseAllowance(
431     IERC20 token,
432     address spender,
433     uint256 value
434   )
435     internal
436   {
437     uint256 newAllowance = token.allowance(address(this), spender).add(value);
438     require(token.approve(spender, newAllowance));
439   }
440 
441   function safeDecreaseAllowance(
442     IERC20 token,
443     address spender,
444     uint256 value
445   )
446     internal
447   {
448     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
449     require(token.approve(spender, newAllowance));
450   }
451 }
452 
453 contract Modifiable {
454     //
455     // Modifiers
456     // -----------------------------------------------------------------------------------------------------------------
457     modifier notNullAddress(address _address) {
458         require(_address != address(0));
459         _;
460     }
461 
462     modifier notThisAddress(address _address) {
463         require(_address != address(this));
464         _;
465     }
466 
467     modifier notNullOrThisAddress(address _address) {
468         require(_address != address(0));
469         require(_address != address(this));
470         _;
471     }
472 
473     modifier notSameAddresses(address _address1, address _address2) {
474         if (_address1 != _address2)
475             _;
476     }
477 }
478 
479 contract RevenueToken is ERC20Mintable {
480     using SafeMath for uint256;
481 
482     bool public mintingDisabled;
483 
484     address[] public holders;
485 
486     mapping(address => bool) public holdersMap;
487 
488     mapping(address => uint256[]) public balances;
489 
490     mapping(address => uint256[]) public balanceBlocks;
491 
492     mapping(address => uint256[]) public balanceBlockNumbers;
493 
494     event DisableMinting();
495 
496     /**
497      * @notice Disable further minting
498      * @dev This operation can not be undone
499      */
500     function disableMinting()
501     public
502     onlyMinter
503     {
504         mintingDisabled = true;
505 
506         emit DisableMinting();
507     }
508 
509     /**
510      * @notice Mint tokens
511      * @param to The address that will receive the minted tokens.
512      * @param value The amount of tokens to mint.
513      * @return A boolean that indicates if the operation was successful.
514      */
515     function mint(address to, uint256 value)
516     public
517     onlyMinter
518     returns (bool)
519     {
520         require(!mintingDisabled);
521 
522         // Call super's mint, including event emission
523         bool minted = super.mint(to, value);
524 
525         if (minted) {
526             // Adjust balance blocks
527             addBalanceBlocks(to);
528 
529             // Add to the token holders list
530             if (!holdersMap[to]) {
531                 holdersMap[to] = true;
532                 holders.push(to);
533             }
534         }
535 
536         return minted;
537     }
538 
539     /**
540      * @notice Transfer token for a specified address
541      * @param to The address to transfer to.
542      * @param value The amount to be transferred.
543      * @return A boolean that indicates if the operation was successful.
544      */
545     function transfer(address to, uint256 value)
546     public
547     returns (bool)
548     {
549         // Call super's transfer, including event emission
550         bool transferred = super.transfer(to, value);
551 
552         if (transferred) {
553             // Adjust balance blocks
554             addBalanceBlocks(msg.sender);
555             addBalanceBlocks(to);
556 
557             // Add to the token holders list
558             if (!holdersMap[to]) {
559                 holdersMap[to] = true;
560                 holders.push(to);
561             }
562         }
563 
564         return transferred;
565     }
566 
567     /**
568      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
569      * @dev Beware that to change the approve amount you first have to reduce the addresses'
570      * allowance to zero by calling `approve(spender, 0)` if it is not already 0 to mitigate the race
571      * condition described here:
572      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
573      * @param spender The address which will spend the funds.
574      * @param value The amount of tokens to be spent.
575      */
576     function approve(address spender, uint256 value)
577     public
578     returns (bool)
579     {
580         // Prevent the update of non-zero allowance
581         require(0 == value || 0 == allowance(msg.sender, spender));
582 
583         // Call super's approve, including event emission
584         return super.approve(spender, value);
585     }
586 
587     /**
588      * @dev Transfer tokens from one address to another
589      * @param from address The address which you want to send tokens from
590      * @param to address The address which you want to transfer to
591      * @param value uint256 the amount of tokens to be transferred
592      * @return A boolean that indicates if the operation was successful.
593      */
594     function transferFrom(address from, address to, uint256 value)
595     public
596     returns (bool)
597     {
598         // Call super's transferFrom, including event emission
599         bool transferred = super.transferFrom(from, to, value);
600 
601         if (transferred) {
602             // Adjust balance blocks
603             addBalanceBlocks(from);
604             addBalanceBlocks(to);
605 
606             // Add to the token holders list
607             if (!holdersMap[to]) {
608                 holdersMap[to] = true;
609                 holders.push(to);
610             }
611         }
612 
613         return transferred;
614     }
615 
616     /**
617      * @notice Calculate the amount of balance blocks, i.e. the area under the curve (AUC) of
618      * balance as function of block number
619      * @dev The AUC is used as weight for the share of revenue that a token holder may claim
620      * @param account The account address for which calculation is done
621      * @param startBlock The start block number considered
622      * @param endBlock The end block number considered
623      * @return The calculated AUC
624      */
625     function balanceBlocksIn(address account, uint256 startBlock, uint256 endBlock)
626     public
627     view
628     returns (uint256)
629     {
630         require(startBlock < endBlock);
631         require(account != address(0));
632 
633         if (balanceBlockNumbers[account].length == 0 || endBlock < balanceBlockNumbers[account][0])
634             return 0;
635 
636         uint256 i = 0;
637         while (i < balanceBlockNumbers[account].length && balanceBlockNumbers[account][i] < startBlock)
638             i++;
639 
640         uint256 r;
641         if (i >= balanceBlockNumbers[account].length)
642             r = balances[account][balanceBlockNumbers[account].length - 1].mul(endBlock.sub(startBlock));
643 
644         else {
645             uint256 l = (i == 0) ? startBlock : balanceBlockNumbers[account][i - 1];
646 
647             uint256 h = balanceBlockNumbers[account][i];
648             if (h > endBlock)
649                 h = endBlock;
650 
651             h = h.sub(startBlock);
652             r = (h == 0) ? 0 : balanceBlocks[account][i].mul(h).div(balanceBlockNumbers[account][i].sub(l));
653             i++;
654 
655             while (i < balanceBlockNumbers[account].length && balanceBlockNumbers[account][i] < endBlock) {
656                 r = r.add(balanceBlocks[account][i]);
657                 i++;
658             }
659 
660             if (i >= balanceBlockNumbers[account].length)
661                 r = r.add(
662                     balances[account][balanceBlockNumbers[account].length - 1].mul(
663                         endBlock.sub(balanceBlockNumbers[account][balanceBlockNumbers[account].length - 1])
664                     )
665                 );
666 
667             else if (balanceBlockNumbers[account][i - 1] < endBlock)
668                 r = r.add(
669                     balanceBlocks[account][i].mul(
670                         endBlock.sub(balanceBlockNumbers[account][i - 1])
671                     ).div(
672                         balanceBlockNumbers[account][i].sub(balanceBlockNumbers[account][i - 1])
673                     )
674                 );
675         }
676 
677         return r;
678     }
679 
680     /**
681      * @notice Get the count of balance updates for the given account
682      * @return The count of balance updates
683      */
684     function balanceUpdatesCount(address account)
685     public
686     view
687     returns (uint256)
688     {
689         return balanceBlocks[account].length;
690     }
691 
692     /**
693      * @notice Get the count of holders
694      * @return The count of holders
695      */
696     function holdersCount()
697     public
698     view
699     returns (uint256)
700     {
701         return holders.length;
702     }
703 
704     /**
705      * @notice Get the subset of holders (optionally with positive balance only) in the given 0 based index range
706      * @param low The lower inclusive index
707      * @param up The upper inclusive index
708      * @param posOnly List only positive balance holders
709      * @return The subset of positive balance registered holders in the given range
710      */
711     function holdersByIndices(uint256 low, uint256 up, bool posOnly)
712     public
713     view
714     returns (address[])
715     {
716         require(low <= up);
717 
718         up = up > holders.length - 1 ? holders.length - 1 : up;
719 
720         uint256 length = 0;
721         if (posOnly) {
722             for (uint256 i = low; i <= up; i++)
723                 if (0 < balanceOf(holders[i]))
724                     length++;
725         } else
726             length = up - low + 1;
727 
728         address[] memory _holders = new address[](length);
729 
730         uint256 j = 0;
731         for (i = low; i <= up; i++)
732             if (!posOnly || 0 < balanceOf(holders[i]))
733                 _holders[j++] = holders[i];
734 
735         return _holders;
736     }
737 
738     function addBalanceBlocks(address account)
739     private
740     {
741         uint256 length = balanceBlockNumbers[account].length;
742         balances[account].push(balanceOf(account));
743         if (0 < length)
744             balanceBlocks[account].push(
745                 balances[account][length - 1].mul(
746                     block.number.sub(balanceBlockNumbers[account][length - 1])
747                 )
748             );
749         else
750             balanceBlocks[account].push(0);
751         balanceBlockNumbers[account].push(block.number);
752     }
753 }
754 
755 library SafeMathUintLib {
756     function mul(uint256 a, uint256 b)
757     internal
758     pure
759     returns (uint256)
760     {
761         uint256 c = a * b;
762         assert(a == 0 || c / a == b);
763         return c;
764     }
765 
766     function div(uint256 a, uint256 b)
767     internal
768     pure
769     returns (uint256)
770     {
771         // assert(b > 0); // Solidity automatically throws when dividing by 0
772         uint256 c = a / b;
773         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
774         return c;
775     }
776 
777     function sub(uint256 a, uint256 b)
778     internal
779     pure
780     returns (uint256)
781     {
782         assert(b <= a);
783         return a - b;
784     }
785 
786     function add(uint256 a, uint256 b)
787     internal
788     pure
789     returns (uint256)
790     {
791         uint256 c = a + b;
792         assert(c >= a);
793         return c;
794     }
795 
796     //
797     //Clamping functions.
798     //
799     function clamp(uint256 a, uint256 min, uint256 max)
800     public
801     pure
802     returns (uint256)
803     {
804         return (a > max) ? max : ((a < min) ? min : a);
805     }
806 
807     function clampMin(uint256 a, uint256 min)
808     public
809     pure
810     returns (uint256)
811     {
812         return (a < min) ? min : a;
813     }
814 
815     function clampMax(uint256 a, uint256 max)
816     public
817     pure
818     returns (uint256)
819     {
820         return (a > max) ? max : a;
821     }
822 }
823 
824 contract SelfDestructible {
825     //
826     // Variables
827     // -----------------------------------------------------------------------------------------------------------------
828     bool public selfDestructionDisabled;
829 
830     //
831     // Events
832     // -----------------------------------------------------------------------------------------------------------------
833     event SelfDestructionDisabledEvent(address wallet);
834     event TriggerSelfDestructionEvent(address wallet);
835 
836     //
837     // Functions
838     // -----------------------------------------------------------------------------------------------------------------
839     /// @notice Get the address of the destructor role
840     function destructor()
841     public
842     view
843     returns (address);
844 
845     /// @notice Disable self-destruction of this contract
846     /// @dev This operation can not be undone
847     function disableSelfDestruction()
848     public
849     {
850         // Require that sender is the assigned destructor
851         require(destructor() == msg.sender);
852 
853         // Disable self-destruction
854         selfDestructionDisabled = true;
855 
856         // Emit event
857         emit SelfDestructionDisabledEvent(msg.sender);
858     }
859 
860     /// @notice Destroy this contract
861     function triggerSelfDestruction()
862     public
863     {
864         // Require that sender is the assigned destructor
865         require(destructor() == msg.sender);
866 
867         // Require that self-destruction has not been disabled
868         require(!selfDestructionDisabled);
869 
870         // Emit event
871         emit TriggerSelfDestructionEvent(msg.sender);
872 
873         // Self-destruct and reward destructor
874         selfdestruct(msg.sender);
875     }
876 }
877 
878 contract Ownable is Modifiable, SelfDestructible {
879     //
880     // Variables
881     // -----------------------------------------------------------------------------------------------------------------
882     address public deployer;
883     address public operator;
884 
885     //
886     // Events
887     // -----------------------------------------------------------------------------------------------------------------
888     event SetDeployerEvent(address oldDeployer, address newDeployer);
889     event SetOperatorEvent(address oldOperator, address newOperator);
890 
891     //
892     // Constructor
893     // -----------------------------------------------------------------------------------------------------------------
894     constructor(address _deployer) internal notNullOrThisAddress(_deployer) {
895         deployer = _deployer;
896         operator = _deployer;
897     }
898 
899     //
900     // Functions
901     // -----------------------------------------------------------------------------------------------------------------
902     /// @notice Return the address that is able to initiate self-destruction
903     function destructor()
904     public
905     view
906     returns (address)
907     {
908         return deployer;
909     }
910 
911     /// @notice Set the deployer of this contract
912     /// @param newDeployer The address of the new deployer
913     function setDeployer(address newDeployer)
914     public
915     onlyDeployer
916     notNullOrThisAddress(newDeployer)
917     {
918         if (newDeployer != deployer) {
919             // Set new deployer
920             address oldDeployer = deployer;
921             deployer = newDeployer;
922 
923             // Emit event
924             emit SetDeployerEvent(oldDeployer, newDeployer);
925         }
926     }
927 
928     /// @notice Set the operator of this contract
929     /// @param newOperator The address of the new operator
930     function setOperator(address newOperator)
931     public
932     onlyOperator
933     notNullOrThisAddress(newOperator)
934     {
935         if (newOperator != operator) {
936             // Set new operator
937             address oldOperator = operator;
938             operator = newOperator;
939 
940             // Emit event
941             emit SetOperatorEvent(oldOperator, newOperator);
942         }
943     }
944 
945     /// @notice Gauge whether message sender is deployer or not
946     /// @return true if msg.sender is deployer, else false
947     function isDeployer()
948     internal
949     view
950     returns (bool)
951     {
952         return msg.sender == deployer;
953     }
954 
955     /// @notice Gauge whether message sender is operator or not
956     /// @return true if msg.sender is operator, else false
957     function isOperator()
958     internal
959     view
960     returns (bool)
961     {
962         return msg.sender == operator;
963     }
964 
965     /// @notice Gauge whether message sender is operator or deployer on the one hand, or none of these on these on
966     /// on the other hand
967     /// @return true if msg.sender is operator, else false
968     function isDeployerOrOperator()
969     internal
970     view
971     returns (bool)
972     {
973         return isDeployer() || isOperator();
974     }
975 
976     // Modifiers
977     // -----------------------------------------------------------------------------------------------------------------
978     modifier onlyDeployer() {
979         require(isDeployer());
980         _;
981     }
982 
983     modifier notDeployer() {
984         require(!isDeployer());
985         _;
986     }
987 
988     modifier onlyOperator() {
989         require(isOperator());
990         _;
991     }
992 
993     modifier notOperator() {
994         require(!isOperator());
995         _;
996     }
997 
998     modifier onlyDeployerOrOperator() {
999         require(isDeployerOrOperator());
1000         _;
1001     }
1002 
1003     modifier notDeployerOrOperator() {
1004         require(!isDeployerOrOperator());
1005         _;
1006     }
1007 }
1008 
1009 contract TokenMultiTimelock is Ownable {
1010     using SafeERC20 for IERC20;
1011 
1012     //
1013     // Structures
1014     // -----------------------------------------------------------------------------------------------------------------
1015     struct Release {
1016         uint256 earliestReleaseTime;
1017         uint256 amount;
1018         uint256 blockNumber;
1019         bool done;
1020     }
1021 
1022     //
1023     // Variables
1024     // -----------------------------------------------------------------------------------------------------------------
1025     IERC20 public token;
1026     address public beneficiary;
1027 
1028     Release[] public releases;
1029     uint256 public totalLockedAmount;
1030     uint256 public executedReleasesCount;
1031 
1032     //
1033     // Events
1034     // -----------------------------------------------------------------------------------------------------------------
1035     event SetTokenEvent(IERC20 token);
1036     event SetBeneficiaryEvent(address beneficiary);
1037     event DefineReleaseEvent(uint256 earliestReleaseTime, uint256 amount, uint256 blockNumber);
1038     event SetReleaseBlockNumberEvent(uint256 index, uint256 blockNumber);
1039     event ReleaseEvent(uint256 index, uint256 blockNumber, uint256 earliestReleaseTime,
1040         uint256 actualReleaseTime, uint256 amount);
1041 
1042     //
1043     // Constructor
1044     // -----------------------------------------------------------------------------------------------------------------
1045     constructor(address deployer)
1046     Ownable(deployer)
1047     public
1048     {
1049     }
1050 
1051     //
1052     // Functions
1053     // -----------------------------------------------------------------------------------------------------------------
1054     /// @notice Set the address of token
1055     /// @param _token The address of token
1056     function setToken(IERC20 _token)
1057     public
1058     onlyOperator
1059     notNullOrThisAddress(_token)
1060     {
1061         // Require that the token has not previously been set
1062         require(address(token) == address(0));
1063 
1064         // Update beneficiary
1065         token = _token;
1066 
1067         // Emit event
1068         emit SetTokenEvent(token);
1069     }
1070 
1071     /// @notice Set the address of beneficiary
1072     /// @param _beneficiary The new address of beneficiary
1073     function setBeneficiary(address _beneficiary)
1074     public
1075     onlyOperator
1076     notNullAddress(_beneficiary)
1077     {
1078         // Update beneficiary
1079         beneficiary = _beneficiary;
1080 
1081         // Emit event
1082         emit SetBeneficiaryEvent(beneficiary);
1083     }
1084 
1085     /// @notice Define a set of new releases
1086     /// @param earliestReleaseTimes The timestamp after which the corresponding amount may be released
1087     /// @param amounts The amounts to be released
1088     /// @param releaseBlockNumbers The set release block numbers for releases whose earliest release time
1089     /// is in the past
1090     function defineReleases(uint256[] earliestReleaseTimes, uint256[] amounts, uint256[] releaseBlockNumbers)
1091     onlyOperator
1092     public
1093     {
1094         require(earliestReleaseTimes.length == amounts.length);
1095         require(earliestReleaseTimes.length >= releaseBlockNumbers.length);
1096 
1097         // Require that token address has been set
1098         require(address(token) != address(0));
1099 
1100         for (uint256 i = 0; i < earliestReleaseTimes.length; i++) {
1101             // Update the total amount locked by this contract
1102             totalLockedAmount += amounts[i];
1103 
1104             // Require that total amount locked is smaller than or equal to the token balance of
1105             // this contract
1106             require(token.balanceOf(address(this)) >= totalLockedAmount);
1107 
1108             // Retrieve early block number where available
1109             uint256 blockNumber = i < releaseBlockNumbers.length ? releaseBlockNumbers[i] : 0;
1110 
1111             // Add release
1112             releases.push(Release(earliestReleaseTimes[i], amounts[i], blockNumber, false));
1113 
1114             // Emit event
1115             emit DefineReleaseEvent(earliestReleaseTimes[i], amounts[i], blockNumber);
1116         }
1117     }
1118 
1119     /// @notice Get the count of releases
1120     /// @return The number of defined releases
1121     function releasesCount()
1122     public
1123     view
1124     returns (uint256)
1125     {
1126         return releases.length;
1127     }
1128 
1129     /// @notice Set the block number of a release that is not done
1130     /// @param index The index of the release
1131     /// @param blockNumber The updated block number
1132     function setReleaseBlockNumber(uint256 index, uint256 blockNumber)
1133     public
1134     onlyBeneficiary
1135     {
1136         // Require that the release is not done
1137         require(!releases[index].done);
1138 
1139         // Update the release block number
1140         releases[index].blockNumber = blockNumber;
1141 
1142         // Emit event
1143         emit SetReleaseBlockNumberEvent(index, blockNumber);
1144     }
1145 
1146     /// @notice Transfers tokens held in the indicated release to beneficiary.
1147     /// @param index The index of the release
1148     function release(uint256 index)
1149     public
1150     onlyBeneficiary
1151     {
1152         // Get the release object
1153         Release storage _release = releases[index];
1154 
1155         // Require that this release has been properly defined by having non-zero amount
1156         require(0 < _release.amount);
1157 
1158         // Require that this release has not already been executed
1159         require(!_release.done);
1160 
1161         // Require that the current timestamp is beyond the nominal release time
1162         require(block.timestamp >= _release.earliestReleaseTime);
1163 
1164         // Set release done
1165         _release.done = true;
1166 
1167         // Set release block number if not previously set
1168         if (0 == _release.blockNumber)
1169             _release.blockNumber = block.number;
1170 
1171         // Bump number of executed releases
1172         executedReleasesCount++;
1173 
1174         // Decrement the total locked amount
1175         totalLockedAmount -= _release.amount;
1176 
1177         // Execute transfer
1178         token.safeTransfer(beneficiary, _release.amount);
1179 
1180         // Emit event
1181         emit ReleaseEvent(index, _release.blockNumber, _release.earliestReleaseTime, block.timestamp, _release.amount);
1182     }
1183 
1184     // Modifiers
1185     // -----------------------------------------------------------------------------------------------------------------
1186     modifier onlyBeneficiary() {
1187         require(msg.sender == beneficiary);
1188         _;
1189     }
1190 }
1191 
1192 contract RevenueTokenManager is TokenMultiTimelock {
1193     using SafeMathUintLib for uint256;
1194 
1195     //
1196     // Variables
1197     // -----------------------------------------------------------------------------------------------------------------
1198     uint256[] public totalReleasedAmounts;
1199     uint256[] public totalReleasedAmountBlocks;
1200 
1201     //
1202     // Constructor
1203     // -----------------------------------------------------------------------------------------------------------------
1204     constructor(address deployer)
1205     public
1206     TokenMultiTimelock(deployer)
1207     {
1208     }
1209 
1210     //
1211     // Functions
1212     // -----------------------------------------------------------------------------------------------------------------
1213     /// @notice Transfers tokens held in the indicated release to beneficiary
1214     /// and update amount blocks
1215     /// @param index The index of the release
1216     function release(uint256 index)
1217     public
1218     onlyBeneficiary
1219     {
1220         // Call release of multi timelock
1221         super.release(index);
1222 
1223         // Add amount blocks
1224         _addAmountBlocks(index);
1225     }
1226 
1227     /// @notice Calculate the released amount blocks, i.e. the area under the curve (AUC) of
1228     /// release amount as function of block number
1229     /// @param startBlock The start block number considered
1230     /// @param endBlock The end block number considered
1231     /// @return The calculated AUC
1232     function releasedAmountBlocksIn(uint256 startBlock, uint256 endBlock)
1233     public
1234     view
1235     returns (uint256)
1236     {
1237         require(startBlock < endBlock);
1238 
1239         if (executedReleasesCount == 0 || endBlock < releases[0].blockNumber)
1240             return 0;
1241 
1242         uint256 i = 0;
1243         while (i < executedReleasesCount && releases[i].blockNumber < startBlock)
1244             i++;
1245 
1246         uint256 r;
1247         if (i >= executedReleasesCount)
1248             r = totalReleasedAmounts[executedReleasesCount - 1].mul(endBlock.sub(startBlock));
1249 
1250         else {
1251             uint256 l = (i == 0) ? startBlock : releases[i - 1].blockNumber;
1252 
1253             uint256 h = releases[i].blockNumber;
1254             if (h > endBlock)
1255                 h = endBlock;
1256 
1257             h = h.sub(startBlock);
1258             r = (h == 0) ? 0 : totalReleasedAmountBlocks[i].mul(h).div(releases[i].blockNumber.sub(l));
1259             i++;
1260 
1261             while (i < executedReleasesCount && releases[i].blockNumber < endBlock) {
1262                 r = r.add(totalReleasedAmountBlocks[i]);
1263                 i++;
1264             }
1265 
1266             if (i >= executedReleasesCount)
1267                 r = r.add(
1268                     totalReleasedAmounts[executedReleasesCount - 1].mul(
1269                         endBlock.sub(releases[executedReleasesCount - 1].blockNumber)
1270                     )
1271                 );
1272 
1273             else if (releases[i - 1].blockNumber < endBlock)
1274                 r = r.add(
1275                     totalReleasedAmountBlocks[i].mul(
1276                         endBlock.sub(releases[i - 1].blockNumber)
1277                     ).div(
1278                         releases[i].blockNumber.sub(releases[i - 1].blockNumber)
1279                     )
1280                 );
1281         }
1282 
1283         return r;
1284     }
1285 
1286     /// @notice Get the block number of the release
1287     /// @param index The index of the release
1288     /// @return The block number of the release;
1289     function releaseBlockNumbers(uint256 index)
1290     public
1291     view
1292     returns (uint256)
1293     {
1294         return releases[index].blockNumber;
1295     }
1296 
1297     //
1298     // Private functions
1299     // -----------------------------------------------------------------------------------------------------------------
1300     function _addAmountBlocks(uint256 index)
1301     private
1302     {
1303         // Push total amount released and total released amount blocks
1304         if (0 < index) {
1305             totalReleasedAmounts.push(
1306                 totalReleasedAmounts[index - 1] + releases[index].amount
1307             );
1308             totalReleasedAmountBlocks.push(
1309                 totalReleasedAmounts[index - 1].mul(
1310                     releases[index].blockNumber.sub(releases[index - 1].blockNumber)
1311                 )
1312             );
1313 
1314         } else {
1315             totalReleasedAmounts.push(releases[index].amount);
1316             totalReleasedAmountBlocks.push(0);
1317         }
1318     }
1319 }