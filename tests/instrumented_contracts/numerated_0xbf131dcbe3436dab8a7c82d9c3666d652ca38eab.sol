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