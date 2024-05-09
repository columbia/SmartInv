1 pragma solidity 0.6.12;
2 
3     //https://www.idmoswap.com
4 
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34 
35     function approve(address spender, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Moves `amount` tokens from `sender` to `recipient` using the
39      * allowance mechanism. `amount` is then deducted from the caller's
40      * allowance.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Emitted when `value` tokens are moved from one account (`from`) to
50      * another (`to`).
51      *
52      * Note that `value` may be zero.
53      */
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     /**
57      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
58      * a call to {approve}. `value` is the new allowance.
59      */
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 
64 library SafeMath {
65     /**
66      * @dev Returns the addition of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `+` operator.
70      *
71      * Requirements:
72      *
73      * - Addition cannot overflow.
74      */
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         require(c >= a, "SafeMath: addition overflow");
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the subtraction of two unsigned integers, reverting on
84      * overflow (when the result is negative).
85      *
86      * Counterpart to Solidity's `-` operator.
87      *
88      * Requirements:
89      *
90      * - Subtraction cannot overflow.
91      */
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      *
104      * - Subtraction cannot overflow.
105      */
106     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b <= a, errorMessage);
108         uint256 c = a - b;
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124 
125         if (a == 0) {
126             return 0;
127         }
128 
129         uint256 c = a * b;
130         require(c / a == b, "SafeMath: multiplication overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the integer division of two unsigned integers. Reverts on
137      * division by zero. The result is rounded towards zero.
138      *
139      * Counterpart to Solidity's `/` operator. Note: this function uses a
140      * `revert` opcode (which leaves remaining gas untouched) while Solidity
141      * uses an invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      *
145      * - The divisor cannot be zero.
146      */
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         return div(a, b, "SafeMath: division by zero");
149     }
150 
151     /**
152      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator. Note: this function uses a
156      * `revert` opcode (which leaves remaining gas untouched) while Solidity
157      * uses an invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      *
161      * - The divisor cannot be zero.
162      */
163     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b > 0, errorMessage);
165         uint256 c = a / b;
166         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
184         return mod(a, b, "SafeMath: modulo by zero");
185     }
186 
187 
188     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b != 0, errorMessage);
190         return a % b;
191     }
192 }
193 
194 
195 library Address {
196 
197     function isContract(address account) internal view returns (bool) {
198         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
199         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
200         // for accounts without code, i.e. `keccak256('')`
201         bytes32 codehash;
202         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
203         // solhint-disable-next-line no-inline-assembly
204         assembly { codehash := extcodehash(account) }
205         return (codehash != accountHash && codehash != 0x0);
206     }
207 
208 
209     function sendValue(address payable recipient, uint256 amount) internal {
210         require(address(this).balance >= amount, "Address: insufficient balance");
211 
212         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
213         (bool success, ) = recipient.call{ value: amount }("");
214         require(success, "Address: unable to send value, recipient may have reverted");
215     }
216 
217 
218     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
219       return functionCall(target, data, "Address: low-level call failed");
220     }
221 
222 
223     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
224         return _functionCallWithValue(target, data, 0, errorMessage);
225     }
226 
227 
228     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
229         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
230     }
231 
232 
233     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
234         require(address(this).balance >= value, "Address: insufficient balance for call");
235         return _functionCallWithValue(target, data, value, errorMessage);
236     }
237 
238     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
239         require(isContract(target), "Address: call to non-contract");
240 
241         // solhint-disable-next-line avoid-low-level-calls
242         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
243         if (success) {
244             return returndata;
245         } else {
246             // Look for revert reason and bubble it up if present
247             if (returndata.length > 0) {
248                 // The easiest way to bubble the revert reason is using memory via assembly
249 
250                 // solhint-disable-next-line no-inline-assembly
251                 assembly {
252                     let returndata_size := mload(returndata)
253                     revert(add(32, returndata), returndata_size)
254                 }
255             } else {
256                 revert(errorMessage);
257             }
258         }
259     }
260 }
261 
262 
263 library SafeERC20 {
264     using SafeMath for uint256;
265     using Address for address;
266 
267     function safeTransfer(IERC20 token, address to, uint256 value) internal {
268         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
269     }
270 
271     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
272         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
273     }
274 
275 
276     function safeApprove(IERC20 token, address spender, uint256 value) internal {
277 
278         require((value == 0) || (token.allowance(address(this), spender) == 0),
279             "SafeERC20: approve from non-zero to non-zero allowance"
280         );
281         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
282     }
283 
284     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
285         uint256 newAllowance = token.allowance(address(this), spender).add(value);
286         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
287     }
288 
289     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
290         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
291         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
292     }
293 
294 
295     function _callOptionalReturn(IERC20 token, bytes memory data) private {
296         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
297         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
298         // the target address contains contract code and also asserts for success in the low-level call.
299 
300         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
301         if (returndata.length > 0) { // Return data is optional
302             // solhint-disable-next-line max-line-length
303             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
304         }
305     }
306 }
307 
308 
309 library EnumerableSet {
310 
311 
312     struct Set {
313         // Storage of set values
314         bytes32[] _values;
315 
316         // Position of the value in the `values` array, plus 1 because index 0
317         // means a value is not in the set.
318         mapping (bytes32 => uint256) _indexes;
319     }
320 
321 
322     function _add(Set storage set, bytes32 value) private returns (bool) {
323         if (!_contains(set, value)) {
324             set._values.push(value);
325             // The value is stored at length-1, but we add 1 to all indexes
326             // and use 0 as a sentinel value
327             set._indexes[value] = set._values.length;
328             return true;
329         } else {
330             return false;
331         }
332     }
333 
334     /**
335      * @dev Removes a value from a set. O(1).
336      *
337      * Returns true if the value was removed from the set, that is if it was
338      * present.
339      */
340     function _remove(Set storage set, bytes32 value) private returns (bool) {
341         // We read and store the value's index to prevent multiple reads from the same storage slot
342         uint256 valueIndex = set._indexes[value];
343 
344         if (valueIndex != 0) { // Equivalent to contains(set, value)
345             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
346             // the array, and then remove the last element (sometimes called as 'swap and pop').
347             // This modifies the order of the array, as noted in {at}.
348 
349             uint256 toDeleteIndex = valueIndex - 1;
350             uint256 lastIndex = set._values.length - 1;
351 
352             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
353             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
354 
355             bytes32 lastvalue = set._values[lastIndex];
356 
357             // Move the last value to the index where the value to delete is
358             set._values[toDeleteIndex] = lastvalue;
359             // Update the index for the moved value
360             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
361 
362             // Delete the slot where the moved value was stored
363             set._values.pop();
364 
365             // Delete the index for the deleted slot
366             delete set._indexes[value];
367 
368             return true;
369         } else {
370             return false;
371         }
372     }
373 
374 
375     function _contains(Set storage set, bytes32 value) private view returns (bool) {
376         return set._indexes[value] != 0;
377     }
378 
379 
380     function _length(Set storage set) private view returns (uint256) {
381         return set._values.length;
382     }
383 
384 
385     function _at(Set storage set, uint256 index) private view returns (bytes32) {
386         require(set._values.length > index, "EnumerableSet: index out of bounds");
387         return set._values[index];
388     }
389 
390 
391 
392     struct AddressSet {
393         Set _inner;
394     }
395 
396 
397     function add(AddressSet storage set, address value) internal returns (bool) {
398         return _add(set._inner, bytes32(uint256(value)));
399     }
400 
401 
402     function remove(AddressSet storage set, address value) internal returns (bool) {
403         return _remove(set._inner, bytes32(uint256(value)));
404     }
405 
406 
407     function contains(AddressSet storage set, address value) internal view returns (bool) {
408         return _contains(set._inner, bytes32(uint256(value)));
409     }
410 
411 
412     function length(AddressSet storage set) internal view returns (uint256) {
413         return _length(set._inner);
414     }
415 
416 
417     function at(AddressSet storage set, uint256 index) internal view returns (address) {
418         return address(uint256(_at(set._inner, index)));
419     }
420 
421 
422 
423     struct UintSet {
424         Set _inner;
425     }
426 
427 
428     function add(UintSet storage set, uint256 value) internal returns (bool) {
429         return _add(set._inner, bytes32(value));
430     }
431 
432 
433     function remove(UintSet storage set, uint256 value) internal returns (bool) {
434         return _remove(set._inner, bytes32(value));
435     }
436 
437 
438     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
439         return _contains(set._inner, bytes32(value));
440     }
441 
442 
443     function length(UintSet storage set) internal view returns (uint256) {
444         return _length(set._inner);
445     }
446 
447     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
448         return uint256(_at(set._inner, index));
449     }
450 }
451 
452 
453 abstract contract Context {
454     function _msgSender() internal view virtual returns (address payable) {
455         return msg.sender;
456     }
457 
458     function _msgData() internal view virtual returns (bytes memory) {
459         this; 
460         return msg.data;
461     }
462 }
463 
464 
465 contract Ownable is Context {
466     address private _owner;
467 
468     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
469 
470 
471     constructor () internal {
472         address msgSender = _msgSender();
473         _owner = msgSender;
474         emit OwnershipTransferred(address(0), msgSender);
475     }
476 
477 
478     function owner() public view returns (address) {
479         return _owner;
480     }
481 
482 
483     modifier onlyOwner() {
484         require(_owner == _msgSender(), "Ownable: caller is not the owner");
485         _;
486     }
487 
488 
489     function renounceOwnership() public virtual onlyOwner {
490         emit OwnershipTransferred(_owner, address(0));
491         _owner = address(0);
492     }
493 
494 
495     function transferOwnership(address newOwner) public virtual onlyOwner {
496         require(newOwner != address(0), "Ownable: new owner is the zero address");
497         emit OwnershipTransferred(_owner, newOwner);
498         _owner = newOwner;
499     }
500 }
501 
502 
503 contract ERC20 is Context, IERC20 {
504     using SafeMath for uint256;
505     using Address for address;
506 
507     mapping (address => uint256) private _balances;
508 
509     mapping (address => mapping (address => uint256)) private _allowances;
510 
511     uint256 private _totalSupply;
512 
513     string private _name;
514     string private _symbol;
515     uint8 private _decimals;
516 
517 
518     constructor (string memory name, string memory symbol) public {
519         _name = name;
520         _symbol = symbol;
521         _decimals = 18;
522     }
523 
524 
525     function name() public view returns (string memory) {
526         return _name;
527     }
528 
529 
530     function symbol() public view returns (string memory) {
531         return _symbol;
532     }
533 
534 
535     function decimals() public view returns (uint8) {
536         return _decimals;
537     }
538 
539 
540     function totalSupply() public view override returns (uint256) {
541         return _totalSupply;
542     }
543 
544     function balanceOf(address account) public view override returns (uint256) {
545         return _balances[account];
546     }
547 
548 
549     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
550         _transfer(_msgSender(), recipient, amount);
551         return true;
552     }
553 
554     function allowance(address owner, address spender) public view virtual override returns (uint256) {
555         return _allowances[owner][spender];
556     }
557 
558 
559     function approve(address spender, uint256 amount) public virtual override returns (bool) {
560         _approve(_msgSender(), spender, amount);
561         return true;
562     }
563 
564 
565     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
566         _transfer(sender, recipient, amount);
567         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
568         return true;
569     }
570 
571 
572     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
573         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
574         return true;
575     }
576 
577 
578     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
580         return true;
581     }
582 
583 
584     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
585         require(sender != address(0), "ERC20: transfer from the zero address");
586         require(recipient != address(0), "ERC20: transfer to the zero address");
587 
588         _beforeTokenTransfer(sender, recipient, amount);
589 
590         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
591         _balances[recipient] = _balances[recipient].add(amount);
592         emit Transfer(sender, recipient, amount);
593     }
594 
595 
596     function _mint(address account, uint256 amount) internal virtual {
597         require(account != address(0), "ERC20: mint to the zero address");
598 
599         _beforeTokenTransfer(address(0), account, amount);
600 
601         _totalSupply = _totalSupply.add(amount);
602         _balances[account] = _balances[account].add(amount);
603         emit Transfer(address(0), account, amount);
604     }
605 
606 
607     function _burn(address account, uint256 amount) internal virtual {
608         require(account != address(0), "ERC20: burn from the zero address");
609 
610         _beforeTokenTransfer(account, address(0), amount);
611 
612         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
613         _totalSupply = _totalSupply.sub(amount);
614         emit Transfer(account, address(0), amount);
615     }
616 
617 
618     function _approve(address owner, address spender, uint256 amount) internal virtual {
619         require(owner != address(0), "ERC20: approve from the zero address");
620         require(spender != address(0), "ERC20: approve to the zero address");
621 
622         _allowances[owner][spender] = amount;
623         emit Approval(owner, spender, amount);
624     }
625 
626 
627     function _setupDecimals(uint8 decimals_) internal {
628         _decimals = decimals_;
629     }
630     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
631 }
632 
633 
634 contract MyToken is ERC20("IDMOToken", "IDMO"), Ownable {
635     function mint(address _to, uint256 _amount) public onlyOwner {
636         _mint(_to, _amount);
637     }
638 }
639 pragma experimental ABIEncoderV2;