1 pragma solidity ^0.6.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address account) external view returns (uint256);
7 
8     function transfer(address recipient, uint256 amount)
9         external
10         returns (bool);
11 
12     function allowance(address owner, address spender)
13         external
14         view
15         returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(
20         address sender,
21         address recipient,
22         uint256 amount
23     ) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32 }
33 
34 pragma solidity ^0.6.0;
35 
36 library SafeMath {
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(
49         uint256 a,
50         uint256 b,
51         string memory errorMessage
52     ) internal pure returns (uint256) {
53         require(b <= a, errorMessage);
54         uint256 c = a - b;
55 
56         return c;
57     }
58 
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return div(a, b, "SafeMath: division by zero");
75     }
76 
77     function div(
78         uint256 a,
79         uint256 b,
80         string memory errorMessage
81     ) internal pure returns (uint256) {
82         require(b > 0, errorMessage);
83         uint256 c = a / b;
84         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85 
86         return c;
87     }
88 
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         return mod(a, b, "SafeMath: modulo by zero");
91     }
92 
93     function mod(
94         uint256 a,
95         uint256 b,
96         string memory errorMessage
97     ) internal pure returns (uint256) {
98         require(b != 0, errorMessage);
99         return a % b;
100     }
101 }
102 
103 pragma solidity ^0.6.2;
104 
105 library Address {
106     function isContract(address account) internal view returns (bool) {
107         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
108         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
109         // for accounts without code, i.e. `keccak256('')`
110         bytes32 codehash;
111 
112 
113             bytes32 accountHash
114          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
115         // solhint-disable-next-line no-inline-assembly
116         assembly {
117             codehash := extcodehash(account)
118         }
119         return (codehash != accountHash && codehash != 0x0);
120     }
121 
122     function sendValue(address payable recipient, uint256 amount) internal {
123         require(
124             address(this).balance >= amount,
125             "Address: insufficient balance"
126         );
127 
128         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
129         (bool success, ) = recipient.call{value: amount}("");
130         require(
131             success,
132             "Address: unable to send value, recipient may have reverted"
133         );
134     }
135 
136     function functionCall(address target, bytes memory data)
137         internal
138         returns (bytes memory)
139     {
140         return functionCall(target, data, "Address: low-level call failed");
141     }
142 
143     function functionCall(
144         address target,
145         bytes memory data,
146         string memory errorMessage
147     ) internal returns (bytes memory) {
148         return _functionCallWithValue(target, data, 0, errorMessage);
149     }
150 
151     function functionCallWithValue(
152         address target,
153         bytes memory data,
154         uint256 value
155     ) internal returns (bytes memory) {
156         return
157             functionCallWithValue(
158                 target,
159                 data,
160                 value,
161                 "Address: low-level call with value failed"
162             );
163     }
164 
165     function functionCallWithValue(
166         address target,
167         bytes memory data,
168         uint256 value,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         require(
172             address(this).balance >= value,
173             "Address: insufficient balance for call"
174         );
175         return _functionCallWithValue(target, data, value, errorMessage);
176     }
177 
178     function _functionCallWithValue(
179         address target,
180         bytes memory data,
181         uint256 weiValue,
182         string memory errorMessage
183     ) private returns (bytes memory) {
184         require(isContract(target), "Address: call to non-contract");
185 
186         // solhint-disable-next-line avoid-low-level-calls
187         (bool success, bytes memory returndata) = target.call{value: weiValue}(
188             data
189         );
190         if (success) {
191             return returndata;
192         } else {
193             // Look for revert reason and bubble it up if present
194             if (returndata.length > 0) {
195                 // The easiest way to bubble the revert reason is using memory via assembly
196 
197                 // solhint-disable-next-line no-inline-assembly
198                 assembly {
199                     let returndata_size := mload(returndata)
200                     revert(add(32, returndata), returndata_size)
201                 }
202             } else {
203                 revert(errorMessage);
204             }
205         }
206     }
207 }
208 
209 pragma solidity ^0.6.0;
210 
211 library SafeERC20 {
212     using SafeMath for uint256;
213     using Address for address;
214 
215     function safeTransfer(
216         IERC20 token,
217         address to,
218         uint256 value
219     ) internal {
220         _callOptionalReturn(
221             token,
222             abi.encodeWithSelector(token.transfer.selector, to, value)
223         );
224     }
225 
226     function safeTransferFrom(
227         IERC20 token,
228         address from,
229         address to,
230         uint256 value
231     ) internal {
232         _callOptionalReturn(
233             token,
234             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
235         );
236     }
237 
238     function safeApprove(
239         IERC20 token,
240         address spender,
241         uint256 value
242     ) internal {
243         // safeApprove should only be called when setting an initial allowance,
244         // or when resetting it to zero. To increase and decrease it, use
245         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
246         // solhint-disable-next-line max-line-length
247         require(
248             (value == 0) || (token.allowance(address(this), spender) == 0),
249             "SafeERC20: approve from non-zero to non-zero allowance"
250         );
251         _callOptionalReturn(
252             token,
253             abi.encodeWithSelector(token.approve.selector, spender, value)
254         );
255     }
256 
257     function safeIncreaseAllowance(
258         IERC20 token,
259         address spender,
260         uint256 value
261     ) internal {
262         uint256 newAllowance = token.allowance(address(this), spender).add(
263             value
264         );
265         _callOptionalReturn(
266             token,
267             abi.encodeWithSelector(
268                 token.approve.selector,
269                 spender,
270                 newAllowance
271             )
272         );
273     }
274 
275     function safeDecreaseAllowance(
276         IERC20 token,
277         address spender,
278         uint256 value
279     ) internal {
280         uint256 newAllowance = token.allowance(address(this), spender).sub(
281             value,
282             "SafeERC20: decreased allowance below zero"
283         );
284         _callOptionalReturn(
285             token,
286             abi.encodeWithSelector(
287                 token.approve.selector,
288                 spender,
289                 newAllowance
290             )
291         );
292     }
293 
294     function _callOptionalReturn(IERC20 token, bytes memory data) private {
295         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
296         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
297         // the target address contains contract code and also asserts for success in the low-level call.
298 
299         bytes memory returndata = address(token).functionCall(
300             data,
301             "SafeERC20: low-level call failed"
302         );
303         if (returndata.length > 0) {
304             // Return data is optional
305             // solhint-disable-next-line max-line-length
306             require(
307                 abi.decode(returndata, (bool)),
308                 "SafeERC20: ERC20 operation did not succeed"
309             );
310         }
311     }
312 }
313 
314 pragma solidity ^0.6.0;
315 
316 library EnumerableSet {
317     // To implement this library for multiple types with as little code
318     // repetition as possible, we write it in terms of a generic Set type with
319     // bytes32 values.
320     // The Set implementation uses private functions, and user-facing
321     // implementations (such as AddressSet) are just wrappers around the
322     // underlying Set.
323     // This means that we can only create new EnumerableSets for types that fit
324     // in bytes32.
325 
326     struct Set {
327         // Storage of set values
328         bytes32[] _values;
329         // Position of the value in the `values` array, plus 1 because index 0
330         // means a value is not in the set.
331         mapping(bytes32 => uint256) _indexes;
332     }
333 
334     function _add(Set storage set, bytes32 value) private returns (bool) {
335         if (!_contains(set, value)) {
336             set._values.push(value);
337             // The value is stored at length-1, but we add 1 to all indexes
338             // and use 0 as a sentinel value
339             set._indexes[value] = set._values.length;
340             return true;
341         } else {
342             return false;
343         }
344     }
345 
346     function _remove(Set storage set, bytes32 value) private returns (bool) {
347         // We read and store the value's index to prevent multiple reads from the same storage slot
348         uint256 valueIndex = set._indexes[value];
349 
350         if (valueIndex != 0) {
351             // Equivalent to contains(set, value)
352             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
353             // the array, and then remove the last element (sometimes called as 'swap and pop').
354             // This modifies the order of the array, as noted in {at}.
355 
356             uint256 toDeleteIndex = valueIndex - 1;
357             uint256 lastIndex = set._values.length - 1;
358 
359             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
360             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
361 
362             bytes32 lastvalue = set._values[lastIndex];
363 
364             // Move the last value to the index where the value to delete is
365             set._values[toDeleteIndex] = lastvalue;
366             // Update the index for the moved value
367             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
368 
369             // Delete the slot where the moved value was stored
370             set._values.pop();
371 
372             // Delete the index for the deleted slot
373             delete set._indexes[value];
374 
375             return true;
376         } else {
377             return false;
378         }
379     }
380 
381     function _contains(Set storage set, bytes32 value)
382         private
383         view
384         returns (bool)
385     {
386         return set._indexes[value] != 0;
387     }
388 
389     function _length(Set storage set) private view returns (uint256) {
390         return set._values.length;
391     }
392 
393     function _at(Set storage set, uint256 index)
394         private
395         view
396         returns (bytes32)
397     {
398         require(
399             set._values.length > index,
400             "EnumerableSet: index out of bounds"
401         );
402         return set._values[index];
403     }
404 
405     struct AddressSet {
406         Set _inner;
407     }
408 
409     function add(AddressSet storage set, address value)
410         internal
411         returns (bool)
412     {
413         return _add(set._inner, bytes32(uint256(value)));
414     }
415 
416     function remove(AddressSet storage set, address value)
417         internal
418         returns (bool)
419     {
420         return _remove(set._inner, bytes32(uint256(value)));
421     }
422 
423     function contains(AddressSet storage set, address value)
424         internal
425         view
426         returns (bool)
427     {
428         return _contains(set._inner, bytes32(uint256(value)));
429     }
430 
431     function length(AddressSet storage set) internal view returns (uint256) {
432         return _length(set._inner);
433     }
434 
435     function at(AddressSet storage set, uint256 index)
436         internal
437         view
438         returns (address)
439     {
440         return address(uint256(_at(set._inner, index)));
441     }
442 
443     struct UintSet {
444         Set _inner;
445     }
446 
447     function add(UintSet storage set, uint256 value) internal returns (bool) {
448         return _add(set._inner, bytes32(value));
449     }
450 
451     function remove(UintSet storage set, uint256 value)
452         internal
453         returns (bool)
454     {
455         return _remove(set._inner, bytes32(value));
456     }
457 
458     function contains(UintSet storage set, uint256 value)
459         internal
460         view
461         returns (bool)
462     {
463         return _contains(set._inner, bytes32(value));
464     }
465 
466     function length(UintSet storage set) internal view returns (uint256) {
467         return _length(set._inner);
468     }
469 
470     function at(UintSet storage set, uint256 index)
471         internal
472         view
473         returns (uint256)
474     {
475         return uint256(_at(set._inner, index));
476     }
477 }
478 
479 pragma solidity ^0.6.0;
480 
481 abstract contract Context {
482     function _msgSender() internal virtual view returns (address payable) {
483         return msg.sender;
484     }
485 
486     function _msgData() internal virtual view returns (bytes memory) {
487         this;
488         return msg.data;
489     }
490 }
491 
492 pragma solidity ^0.6.0;
493 
494 contract Ownable is Context {
495     address private _owner;
496 
497     event OwnershipTransferred(
498         address indexed previousOwner,
499         address indexed newOwner
500     );
501 
502     constructor() internal {
503         address msgSender = _msgSender();
504         _owner = msgSender;
505         emit OwnershipTransferred(address(0), msgSender);
506     }
507 
508     function owner() public view returns (address) {
509         return _owner;
510     }
511 
512     modifier onlyOwner() {
513         require(_owner == _msgSender(), "Ownable: caller is not the owner");
514         _;
515     }
516 
517     function renounceOwnership() public virtual onlyOwner {
518         emit OwnershipTransferred(_owner, address(0));
519         _owner = address(0);
520     }
521 
522     function transferOwnership(address newOwner) public virtual onlyOwner {
523         require(
524             newOwner != address(0),
525             "Ownable: new owner is the zero address"
526         );
527         emit OwnershipTransferred(_owner, newOwner);
528         _owner = newOwner;
529     }
530 }
531 
532 pragma solidity ^0.6.0;
533 
534 contract ERC20 is Context, IERC20 {
535     using SafeMath for uint256;
536     using Address for address;
537 
538     mapping(address => uint256) private _balances;
539 
540     mapping(address => mapping(address => uint256)) private _allowances;
541 
542     uint256 private _totalSupply;
543 
544     string private _name;
545     string private _symbol;
546     uint8 private _decimals;
547 
548     constructor(string memory name, string memory symbol) public {
549         _name = name;
550         _symbol = symbol;
551         _decimals = 18;
552     }
553 
554     function name() public view returns (string memory) {
555         return _name;
556     }
557 
558     function symbol() public view returns (string memory) {
559         return _symbol;
560     }
561 
562     function decimals() public view returns (uint8) {
563         return _decimals;
564     }
565 
566     function totalSupply() public override view returns (uint256) {
567         return _totalSupply;
568     }
569 
570     function balanceOf(address account) public override view returns (uint256) {
571         return _balances[account];
572     }
573 
574     function transfer(address recipient, uint256 amount)
575         public
576         virtual
577         override
578         returns (bool)
579     {
580         _transfer(_msgSender(), recipient, amount);
581         return true;
582     }
583 
584     function allowance(address owner, address spender)
585         public
586         virtual
587         override
588         view
589         returns (uint256)
590     {
591         return _allowances[owner][spender];
592     }
593 
594     function approve(address spender, uint256 amount)
595         public
596         virtual
597         override
598         returns (bool)
599     {
600         _approve(_msgSender(), spender, amount);
601         return true;
602     }
603 
604     function transferFrom(
605         address sender,
606         address recipient,
607         uint256 amount
608     ) public virtual override returns (bool) {
609         _transfer(sender, recipient, amount);
610         _approve(
611             sender,
612             _msgSender(),
613             _allowances[sender][_msgSender()].sub(
614                 amount,
615                 "ERC20: transfer amount exceeds allowance"
616             )
617         );
618         return true;
619     }
620 
621     function increaseAllowance(address spender, uint256 addedValue)
622         public
623         virtual
624         returns (bool)
625     {
626         _approve(
627             _msgSender(),
628             spender,
629             _allowances[_msgSender()][spender].add(addedValue)
630         );
631         return true;
632     }
633 
634     function decreaseAllowance(address spender, uint256 subtractedValue)
635         public
636         virtual
637         returns (bool)
638     {
639         _approve(
640             _msgSender(),
641             spender,
642             _allowances[_msgSender()][spender].sub(
643                 subtractedValue,
644                 "ERC20: decreased allowance below zero"
645             )
646         );
647         return true;
648     }
649 
650     function _transfer(
651         address sender,
652         address recipient,
653         uint256 amount
654     ) internal virtual {
655         require(sender != address(0), "ERC20: transfer from the zero address");
656         require(recipient != address(0), "ERC20: transfer to the zero address");
657 
658         _beforeTokenTransfer(sender, recipient, amount);
659 
660         _balances[sender] = _balances[sender].sub(
661             amount,
662             "ERC20: transfer amount exceeds balance"
663         );
664         _balances[recipient] = _balances[recipient].add(amount);
665         emit Transfer(sender, recipient, amount);
666     }
667 
668     function _mint(address account, uint256 amount) internal virtual {
669         require(account != address(0), "ERC20: mint to the zero address");
670 
671         _beforeTokenTransfer(address(0), account, amount);
672 
673         _totalSupply = _totalSupply.add(amount);
674         _balances[account] = _balances[account].add(amount);
675         emit Transfer(address(0), account, amount);
676     }
677 
678     function _burn(address account, uint256 amount) internal virtual {
679         require(account != address(0), "ERC20: burn from the zero address");
680 
681         _beforeTokenTransfer(account, address(0), amount);
682 
683         _balances[account] = _balances[account].sub(
684             amount,
685             "ERC20: burn amount exceeds balance"
686         );
687         _totalSupply = _totalSupply.sub(amount);
688         emit Transfer(account, address(0), amount);
689     }
690 
691     function _approve(
692         address owner,
693         address spender,
694         uint256 amount
695     ) internal virtual {
696         require(owner != address(0), "ERC20: approve from the zero address");
697         require(spender != address(0), "ERC20: approve to the zero address");
698 
699         _allowances[owner][spender] = amount;
700         emit Approval(owner, spender, amount);
701     }
702 
703     function _setupDecimals(uint8 decimals_) internal {
704         _decimals = decimals_;
705     }
706 
707     function _beforeTokenTransfer(
708         address from,
709         address to,
710         uint256 amount
711     ) internal virtual {}
712 }
713 
714 pragma solidity 0.6.12;
715 
716 contract MOAR is ERC20("MOAR", "MOAR"), Ownable {
717     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
718     function mint(address _to, uint256 _amount) public onlyOwner {
719         _mint(_to, _amount);
720     }
721 }
722 
723 pragma solidity 0.6.12;
724 
725 // MasterChef is the master of Sushi. He can make Sushi and he is a fair guy.
726 //
727 // Note that it's ownable and the owner wields tremendous power. The ownership
728 // will be transferred to a governance smart contract once SUSHI is sufficiently
729 // distributed and the community can show to govern itself.
730 //
731 // Have fun reading it. Hopefully it's bug-free. God bless.
732 contract MasterChef is Ownable {
733     using SafeMath for uint256;
734     using SafeERC20 for IERC20;
735 
736     // Info of each user.
737     struct UserInfo {
738         uint256 amount; // How many LP tokens the user has provided.
739         uint256 rewardDebt; // Reward debt. See explanation below.
740         //
741         // We do some fancy math here. Basically, any point in time, the amount of SUSHIs
742         // entitled to a user but is pending to be distributed is:
743         //
744         //   pending reward = (user.amount * pool.accSushiPerShare) - user.rewardDebt
745         //
746         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
747         //   1. The pool's `accSushiPerShare` (and `lastRewardBlock`) gets updated.
748         //   2. User receives the pending reward sent to his/her address.
749         //   3. User's `amount` gets updated.
750         //   4. User's `rewardDebt` gets updated.
751     }
752 
753     // Info of each pool.
754     struct PoolInfo {
755         IERC20 lpToken; // Address of LP token contract.
756         uint256 allocPoint; // How many allocation points assigned to this pool. SUSHIs to distribute per block.
757         uint256 lastRewardBlock; // Last block number that SUSHIs distribution occurs.
758         uint256 accSushiPerShare; // Accumulated SUSHIs per share, times 1e12. See below.
759     }
760 
761     // The SUSHI TOKEN!
762     MOAR public sushi;
763     // Dev address.
764     address public devaddr;
765     // Block number when bonus SUSHI period ends.
766     uint256 public bonusEndBlock;
767     // SUSHI tokens created per block.
768     uint256 public sushiPerBlock;
769     // Bonus muliplier for early sushi makers.
770     uint256 public constant BONUS_MULTIPLIER = 1;
771 
772     // Info of each pool.
773     PoolInfo[] public poolInfo;
774     // Info of each user that stakes LP tokens.
775     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
776     // Total allocation poitns. Must be the sum of all allocation points in all pools.
777     uint256 public totalAllocPoint = 0;
778     // The block number when SUSHI mining starts.
779     uint256 public startBlock;
780 
781     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
782     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
783     event EmergencyWithdraw(
784         address indexed user,
785         uint256 indexed pid,
786         uint256 amount
787     );
788 
789     constructor(
790         MOAR _sushi,
791         address _devaddr,
792         uint256 _sushiPerBlock,
793         uint256 _startBlock,
794         uint256 _bonusEndBlock
795     ) public {
796         sushi = _sushi;
797         devaddr = _devaddr;
798         sushiPerBlock = _sushiPerBlock;
799         bonusEndBlock = _bonusEndBlock;
800         startBlock = _startBlock;
801     }
802 
803     function poolLength() external view returns (uint256) {
804         return poolInfo.length;
805     }
806 
807     // Add a new lp to the pool. Can only be called by the owner.
808     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
809     function add(
810         uint256 _allocPoint,
811         IERC20 _lpToken,
812         bool _withUpdate
813     ) public onlyOwner {
814         if (_withUpdate) {
815             massUpdatePools();
816         }
817         uint256 lastRewardBlock = block.number > startBlock
818             ? block.number
819             : startBlock;
820         totalAllocPoint = totalAllocPoint.add(_allocPoint);
821         poolInfo.push(
822             PoolInfo({
823                 lpToken: _lpToken,
824                 allocPoint: _allocPoint,
825                 lastRewardBlock: lastRewardBlock,
826                 accSushiPerShare: 0
827             })
828         );
829     }
830 
831     // Update the given pool's SUSHI allocation point. Can only be called by the owner.
832     function set(
833         uint256 _pid,
834         uint256 _allocPoint,
835         bool _withUpdate
836     ) public onlyOwner {
837         if (_withUpdate) {
838             massUpdatePools();
839         }
840         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
841             _allocPoint
842         );
843         poolInfo[_pid].allocPoint = _allocPoint;
844     }
845 
846     // Return reward multiplier over the given _from to _to block.
847     function getMultiplier(uint256 _from, uint256 _to)
848         public
849         view
850         returns (uint256)
851     {
852         if (_to <= bonusEndBlock) {
853             return _to.sub(_from).mul(BONUS_MULTIPLIER);
854         } else if (_from >= bonusEndBlock) {
855             return _to.sub(_from);
856         } else {
857             return
858                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
859                     _to.sub(bonusEndBlock)
860                 );
861         }
862     }
863 
864     // View function to see pending SUSHIs on frontend.
865     function pendingSushi(uint256 _pid, address _user)
866         external
867         view
868         returns (uint256)
869     {
870         PoolInfo storage pool = poolInfo[_pid];
871         UserInfo storage user = userInfo[_pid][_user];
872         uint256 accSushiPerShare = pool.accSushiPerShare;
873         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
874         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
875             uint256 multiplier = getMultiplier(
876                 pool.lastRewardBlock,
877                 block.number
878             );
879             uint256 sushiReward = multiplier
880                 .mul(sushiPerBlock)
881                 .mul(pool.allocPoint)
882                 .div(totalAllocPoint);
883             accSushiPerShare = accSushiPerShare.add(
884                 sushiReward.mul(1e12).div(lpSupply)
885             );
886         }
887         return user.amount.mul(accSushiPerShare).div(1e12).sub(user.rewardDebt);
888     }
889 
890     // Update reward vairables for all pools. Be careful of gas spending!
891     function massUpdatePools() public {
892         uint256 length = poolInfo.length;
893         for (uint256 pid = 0; pid < length; ++pid) {
894             updatePool(pid);
895         }
896     }
897 
898     // Update reward variables of the given pool to be up-to-date.
899     function updatePool(uint256 _pid) public {
900         PoolInfo storage pool = poolInfo[_pid];
901         if (block.number <= pool.lastRewardBlock) {
902             return;
903         }
904         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
905         if (lpSupply == 0) {
906             pool.lastRewardBlock = block.number;
907             return;
908         }
909         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
910         uint256 sushiReward = multiplier
911             .mul(sushiPerBlock)
912             .mul(pool.allocPoint)
913             .div(totalAllocPoint);
914         sushi.mint(address(this), sushiReward);
915         pool.accSushiPerShare = pool.accSushiPerShare.add(
916             sushiReward.mul(1e12).div(lpSupply)
917         );
918         pool.lastRewardBlock = block.number;
919     }
920 
921     // Deposit LP tokens to MasterChef for SUSHI allocation.
922     function deposit(uint256 _pid, uint256 _amount) public {
923         PoolInfo storage pool = poolInfo[_pid];
924         UserInfo storage user = userInfo[_pid][msg.sender];
925         updatePool(_pid);
926         if (user.amount > 0) {
927             uint256 pending = user
928                 .amount
929                 .mul(pool.accSushiPerShare)
930                 .div(1e12)
931                 .sub(user.rewardDebt);
932             safeSushiTransfer(msg.sender, pending);
933         }
934         pool.lpToken.safeTransferFrom(
935             address(msg.sender),
936             address(this),
937             _amount
938         );
939         user.amount = user.amount.add(_amount);
940         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
941         emit Deposit(msg.sender, _pid, _amount);
942     }
943 
944     // Withdraw LP tokens from MasterChef.
945     function withdraw(uint256 _pid, uint256 _amount) public {
946         PoolInfo storage pool = poolInfo[_pid];
947         UserInfo storage user = userInfo[_pid][msg.sender];
948         require(user.amount >= _amount, "withdraw: not good");
949         updatePool(_pid);
950         uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(
951             user.rewardDebt
952         );
953         safeSushiTransfer(msg.sender, pending);
954         user.amount = user.amount.sub(_amount);
955         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
956         pool.lpToken.safeTransfer(address(msg.sender), _amount);
957         emit Withdraw(msg.sender, _pid, _amount);
958     }
959 
960     // Withdraw without caring about rewards. EMERGENCY ONLY.
961     function emergencyWithdraw(uint256 _pid) public {
962         PoolInfo storage pool = poolInfo[_pid];
963         UserInfo storage user = userInfo[_pid][msg.sender];
964         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
965         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
966         user.amount = 0;
967         user.rewardDebt = 0;
968     }
969 
970     // Safe sushi transfer function, just in case if rounding error causes pool to not have enough SUSHIs.
971     function safeSushiTransfer(address _to, uint256 _amount) internal {
972         uint256 sushiBal = sushi.balanceOf(address(this));
973         if (_amount > sushiBal) {
974             sushi.transfer(_to, sushiBal);
975         } else {
976             sushi.transfer(_to, _amount);
977         }
978     }
979 
980     // Update dev address by the previous dev.
981     function dev(address _devaddr) public {
982         require(msg.sender == devaddr, "dev: wut?");
983         devaddr = _devaddr;
984     }
985 }