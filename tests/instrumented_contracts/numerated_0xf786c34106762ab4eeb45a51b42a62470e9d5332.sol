1 /**
2  *Submitted for verification at BscScan.com on 2021-02-28
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 
8 pragma solidity ^0.8.1;
9 library EnumerableSet {
10     // To implement this library for multiple types with as little code
11     // repetition as possible, we write it in terms of a generic Set type with
12     // bytes32 values.
13     // The Set implementation uses private functions, and user-facing
14     // implementations (such as AddressSet) are just wrappers around the
15     // underlying Set.
16     // This means that we can only create new EnumerableSets for types that fit
17     // in bytes32.
18 
19     struct Set {
20         // Storage of set values
21         bytes32[] _values;
22 
23         // Position of the value in the `values` array, plus 1 because index 0
24         // means a value is not in the set.
25         mapping (bytes32 => uint256) _indexes;
26     }
27 
28     /**
29      * @dev Add a value to a set. O(1).
30      *
31      * Returns true if the value was added to the set, that is if it was not
32      * already present.
33      */
34     function _add(Set storage set, bytes32 value) private returns (bool) {
35         if (!_contains(set, value)) {
36             set._values.push(value);
37             // The value is stored at length-1, but we add 1 to all indexes
38             // and use 0 as a sentinel value
39             set._indexes[value] = set._values.length;
40             return true;
41         } else {
42             return false;
43         }
44     }
45 
46     /**
47      * @dev Removes a value from a set. O(1).
48      *
49      * Returns true if the value was removed from the set, that is if it was
50      * present.
51      */
52     function _remove(Set storage set, bytes32 value) private returns (bool) {
53         // We read and store the value's index to prevent multiple reads from the same storage slot
54         uint256 valueIndex = set._indexes[value];
55 
56         if (valueIndex != 0) { // Equivalent to contains(set, value)
57             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
58             // the array, and then remove the last element (sometimes called as 'swap and pop').
59             // This modifies the order of the array, as noted in {at}.
60 
61             uint256 toDeleteIndex = valueIndex - 1;
62             uint256 lastIndex = set._values.length - 1;
63 
64             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
65             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
66 
67             bytes32 lastvalue = set._values[lastIndex];
68 
69             // Move the last value to the index where the value to delete is
70             set._values[toDeleteIndex] = lastvalue;
71             // Update the index for the moved value
72             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
73 
74             // Delete the slot where the moved value was stored
75             set._values.pop();
76 
77             // Delete the index for the deleted slot
78             delete set._indexes[value];
79 
80             return true;
81         } else {
82             return false;
83         }
84     }
85 
86     /**
87      * @dev Returns true if the value is in the set. O(1).
88      */
89     function _contains(Set storage set, bytes32 value) private view returns (bool) {
90         return set._indexes[value] != 0;
91     }
92 
93     /**
94      * @dev Returns the number of values on the set. O(1).
95      */
96     function _length(Set storage set) private view returns (uint256) {
97         return set._values.length;
98     }
99 
100    /**
101     * @dev Returns the value stored at position `index` in the set. O(1).
102     *
103     * Note that there are no guarantees on the ordering of values inside the
104     * array, and it may change when more values are added or removed.
105     *
106     * Requirements:
107     *
108     * - `index` must be strictly less than {length}.
109     */
110     function _at(Set storage set, uint256 index) private view returns (bytes32) {
111         require(set._values.length > index, "EnumerableSet: index out of bounds");
112         return set._values[index];
113     }
114 
115     // Bytes32Set
116 
117     struct Bytes32Set {
118         Set _inner;
119     }
120 
121     /**
122      * @dev Add a value to a set. O(1).
123      *
124      * Returns true if the value was added to the set, that is if it was not
125      * already present.
126      */
127     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
128         return _add(set._inner, value);
129     }
130 
131     /**
132      * @dev Removes a value from a set. O(1).
133      *
134      * Returns true if the value was removed from the set, that is if it was
135      * present.
136      */
137     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
138         return _remove(set._inner, value);
139     }
140 
141     /**
142      * @dev Returns true if the value is in the set. O(1).
143      */
144     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
145         return _contains(set._inner, value);
146     }
147 
148     /**
149      * @dev Returns the number of values in the set. O(1).
150      */
151     function length(Bytes32Set storage set) internal view returns (uint256) {
152         return _length(set._inner);
153     }
154 
155    /**
156     * @dev Returns the value stored at position `index` in the set. O(1).
157     *
158     * Note that there are no guarantees on the ordering of values inside the
159     * array, and it may change when more values are added or removed.
160     *
161     * Requirements:
162     *
163     * - `index` must be strictly less than {length}.
164     */
165     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
166         return _at(set._inner, index);
167     }
168 
169     // AddressSet
170 
171     struct AddressSet {
172         Set _inner;
173     }
174 
175     /**
176      * @dev Add a value to a set. O(1).
177      *
178      * Returns true if the value was added to the set, that is if it was not
179      * already present.
180      */
181     function add(AddressSet storage set, address value) internal returns (bool) {
182         return _add(set._inner, bytes32(uint256(uint160(value))));
183     }
184 
185     /**
186      * @dev Removes a value from a set. O(1).
187      *
188      * Returns true if the value was removed from the set, that is if it was
189      * present.
190      */
191     function remove(AddressSet storage set, address value) internal returns (bool) {
192         return _remove(set._inner, bytes32(uint256(uint160(value))));
193     }
194 
195     /**
196      * @dev Returns true if the value is in the set. O(1).
197      */
198     function contains(AddressSet storage set, address value) internal view returns (bool) {
199         return _contains(set._inner, bytes32(uint256(uint160(value))));
200     }
201 
202     /**
203      * @dev Returns the number of values in the set. O(1).
204      */
205     function length(AddressSet storage set) internal view returns (uint256) {
206         return _length(set._inner);
207     }
208 
209    /**
210     * @dev Returns the value stored at position `index` in the set. O(1).
211     *
212     * Note that there are no guarantees on the ordering of values inside the
213     * array, and it may change when more values are added or removed.
214     *
215     * Requirements:
216     *
217     * - `index` must be strictly less than {length}.
218     */
219     function at(AddressSet storage set, uint256 index) internal view returns (address) {
220         return address(uint160(uint256(_at(set._inner, index))));
221     }
222 
223 
224     // UintSet
225 
226     struct UintSet {
227         Set _inner;
228     }
229 
230     /**
231      * @dev Add a value to a set. O(1).
232      *
233      * Returns true if the value was added to the set, that is if it was not
234      * already present.
235      */
236     function add(UintSet storage set, uint256 value) internal returns (bool) {
237         return _add(set._inner, bytes32(value));
238     }
239 
240     /**
241      * @dev Removes a value from a set. O(1).
242      *
243      * Returns true if the value was removed from the set, that is if it was
244      * present.
245      */
246     function remove(UintSet storage set, uint256 value) internal returns (bool) {
247         return _remove(set._inner, bytes32(value));
248     }
249 
250     /**
251      * @dev Returns true if the value is in the set. O(1).
252      */
253     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
254         return _contains(set._inner, bytes32(value));
255     }
256 
257     /**
258      * @dev Returns the number of values on the set. O(1).
259      */
260     function length(UintSet storage set) internal view returns (uint256) {
261         return _length(set._inner);
262     }
263 
264    /**
265     * @dev Returns the value stored at position `index` in the set. O(1).
266     *
267     * Note that there are no guarantees on the ordering of values inside the
268     * array, and it may change when more values are added or removed.
269     *
270     * Requirements:
271     *
272     * - `index` must be strictly less than {length}.
273     */
274     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
275         return uint256(_at(set._inner, index));
276     }
277 }
278 
279 
280 
281 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
282 
283 /**
284  * @dev Interface of the ERC20 standard as defined in the EIP.
285  */
286 interface IERC20 {
287     /**
288      * @dev Returns the amount of tokens in existence.
289      */
290     function totalSupply() external view returns (uint256);
291 
292     /**
293      * @dev Returns the amount of tokens owned by `account`.
294      */
295     function balanceOf(address account) external view returns (uint256);
296 
297     /**
298      * @dev Moves `amount` tokens from the caller's account to `recipient`.
299      *
300      * Returns a boolean value indicating whether the operation succeeded.
301      *
302      * Emits a {Transfer} event.
303      */
304     function transfer(address recipient, uint256 amount) external returns (bool);
305 
306     /**
307      * @dev Returns the remaining number of tokens that `spender` will be
308      * allowed to spend on behalf of `owner` through {transferFrom}. This is
309      * zero by default.
310      *
311      * This value changes when {approve} or {transferFrom} are called.
312      */
313     function allowance(address owner, address spender) external view returns (uint256);
314 
315     /**
316      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
317      *
318      * Returns a boolean value indicating whether the operation succeeded.
319      *
320      * IMPORTANT: Beware that changing an allowance with this method brings the risk
321      * that someone may use both the old and the new allowance by unfortunate
322      * transaction ordering. One possible solution to mitigate this race
323      * condition is to first reduce the spender's allowance to 0 and set the
324      * desired value afterwards:
325      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
326      *
327      * Emits an {Approval} event.
328      */
329     function approve(address spender, uint256 amount) external returns (bool);
330 
331     /**
332      * @dev Moves `amount` tokens from `sender` to `recipient` using the
333      * allowance mechanism. `amount` is then deducted from the caller's
334      * allowance.
335      *
336      * Returns a boolean value indicating whether the operation succeeded.
337      *
338      * Emits a {Transfer} event.
339      */
340     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
341 
342     /**
343      * @dev Emitted when `value` tokens are moved from one account (`from`) to
344      * another (`to`).
345      *
346      * Note that `value` may be zero.
347      */
348     event Transfer(address indexed from, address indexed to, uint256 value);
349 
350     /**
351      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
352      * a call to {approve}. `value` is the new allowance.
353      */
354     event Approval(address indexed owner, address indexed spender, uint256 value);
355 }
356 
357 // File: openzeppelin-solidity\contracts\utils\Address.sol
358 
359 
360 /**
361  * @dev Collection of functions related to the address type
362  */
363 library Address {
364     /**
365      * @dev Returns true if `account` is a contract.
366      *
367      * [IMPORTANT]
368      * ====
369      * It is unsafe to assume that an address for which this function returns
370      * false is an externally-owned account (EOA) and not a contract.
371      *
372      * Among others, `isContract` will return false for the following
373      * types of addresses:
374      *
375      *  - an externally-owned account
376      *  - a contract in construction
377      *  - an address where a contract will be created
378      *  - an address where a contract lived, but was destroyed
379      * ====
380      */
381     function isContract(address account) internal view returns (bool) {
382         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
383         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
384         // for accounts without code, i.e. `keccak256('')`
385         bytes32 codehash;
386         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
387         // solhint-disable-next-line no-inline-assembly
388         assembly { codehash := extcodehash(account) }
389         return (codehash != accountHash && codehash != 0x0);
390     }
391 
392     /**
393      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
394      * `recipient`, forwarding all available gas and reverting on errors.
395      *
396      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
397      * of certain opcodes, possibly making contracts go over the 2300 gas limit
398      * imposed by `transfer`, making them unable to receive funds via
399      * `transfer`. {sendValue} removes this limitation.
400      *
401      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
402      *
403      * IMPORTANT: because control is transferred to `recipient`, care must be
404      * taken to not create reentrancy vulnerabilities. Consider using
405      * {ReentrancyGuard} or the
406      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
407      */
408     function sendValue(address payable recipient, uint256 amount) internal {
409         require(address(this).balance >= amount, "Address: insufficient balance");
410 
411         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
412         (bool success, ) = recipient.call{ value: amount }("");
413         require(success, "Address: unable to send value, recipient may have reverted");
414     }
415 
416     /**
417      * @dev Performs a Solidity function call using a low level `call`. A
418      * plain`call` is an unsafe replacement for a function call: use this
419      * function instead.
420      *
421      * If `target` reverts with a revert reason, it is bubbled up by this
422      * function (like regular Solidity function calls).
423      *
424      * Returns the raw returned data. To convert to the expected return value,
425      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
426      *
427      * Requirements:
428      *
429      * - `target` must be a contract.
430      * - calling `target` with `data` must not revert.
431      *
432      * _Available since v3.1._
433      */
434     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
435       return functionCall(target, data, "Address: low-level call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
440      * `errorMessage` as a fallback revert reason when `target` reverts.
441      *
442      * _Available since v3.1._
443      */
444     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
445         return _functionCallWithValue(target, data, 0, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but also transferring `value` wei to `target`.
451      *
452      * Requirements:
453      *
454      * - the calling contract must have an ETH balance of at least `value`.
455      * - the called Solidity function must be `payable`.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
460         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
465      * with `errorMessage` as a fallback revert reason when `target` reverts.
466      *
467      * _Available since v3.1._
468      */
469     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
470         require(address(this).balance >= value, "Address: insufficient balance for call");
471         return _functionCallWithValue(target, data, value, errorMessage);
472     }
473 
474     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
475         require(isContract(target), "Address: call to non-contract");
476 
477         // solhint-disable-next-line avoid-low-level-calls
478         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
479         if (success) {
480             return returndata;
481         } else {
482             // Look for revert reason and bubble it up if present
483             if (returndata.length > 0) {
484                 // The easiest way to bubble the revert reason is using memory via assembly
485 
486                 // solhint-disable-next-line no-inline-assembly
487                 assembly {
488                     let returndata_size := mload(returndata)
489                     revert(add(32, returndata), returndata_size)
490                 }
491             } else {
492                 revert(errorMessage);
493             }
494         }
495     }
496 }
497 
498 
499 contract fETH is IERC20 {
500     using Address for address;
501     enum TxType { FromExcluded, ToExcluded, BothExcluded, Standard }
502 
503     mapping (address => uint256) private rBnbBalance;
504     mapping (address => uint256) private tBnbBalance;
505     mapping (address => mapping (address => uint256)) private _allowances;
506 
507     EnumerableSet.AddressSet excluded;
508 
509     uint256 private tBnbSupply;
510     uint256 private rBnbSupply;
511     uint256 private feesAccrued;
512  
513     string private _name = 'FEG Wrapped ETH'; 
514     string private _symbol = 'fETH';
515     uint8  private _decimals = 18;
516     
517     address private op;
518     address private op2;
519     
520     event  Deposit(address indexed dst, uint amount);
521     event  Withdrawal(address indexed src, uint amount);
522 
523     receive() external payable {
524         deposit();
525     }
526 
527     constructor () {
528         op = address(0x4c9BC793716e8dC05d1F48D8cA8f84318Ec3043C);
529         op2 = op;
530         EnumerableSet.add(excluded, address(0)); // stablity - zen.
531         emit Transfer(address(0), msg.sender, 0);
532     }
533 
534     function name() public view returns (string memory) {
535         return _name;
536     }
537 
538     function symbol() public view returns (string memory) {
539         return _symbol;
540     }
541 
542     function decimals() public view returns (uint8) {
543         return _decimals;
544     }
545 
546     function totalSupply() public view override returns (uint256) {
547         return tBnbSupply;
548     }
549 
550     function balanceOf(address account) public view override returns (uint256) {
551         if (EnumerableSet.contains(excluded, account)) return tBnbBalance[account];
552         (uint256 r, uint256 t) = currentSupply();
553         return (rBnbBalance[account] * t)  / r;
554     }
555 
556     function transfer(address recipient, uint256 amount) public override returns (bool) {
557         _transfer(msg.sender, recipient, amount);
558         return true;
559     }
560 
561     function allowance(address owner, address spender) public view override returns (uint256) {
562         return _allowances[owner][spender];
563     }
564 
565     function approve(address spender, uint256 amount) public override returns (bool) {
566         _approve(msg.sender, spender, amount);
567         return true;
568     }
569 
570     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
571         _transfer(sender, recipient, amount);
572         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
573         return true;
574     }
575 
576     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
577         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
578         return true;
579     }
580 
581     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
582         _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
583         return true;
584     }
585 
586     function isExcluded(address account) public view returns (bool) {
587         return EnumerableSet.contains(excluded, account);
588     }
589 
590     function totalFees() public view returns (uint256) {
591         return feesAccrued;
592     }
593     
594     function deposit() public payable {
595         require(msg.value > 0, "can't deposit nothing");
596         (uint256 r, uint256 t) = currentSupply();
597         tBnbSupply += msg.value;
598         uint256 fee = msg.value / 100; 
599         uint256 df = fee / 10;
600         uint256 net = fee != 0 ? (msg.value - (fee)) : msg.value;
601         if(isExcluded(msg.sender)){
602             tBnbBalance[msg.sender] += (msg.value - fee);
603         } 
604         feesAccrued += fee;
605         rBnbBalance[op] += ((df * r) / t);
606         rBnbSupply += (((net + df) * r) / t);
607         rBnbBalance[msg.sender] += ((net * r) / t);
608         emit Deposit(msg.sender, msg.value);
609     }
610 
611     function withdraw(uint amt) public {
612         require(balanceOf(msg.sender) >= amt && amt <= totalSupply(), "invalid amt");
613         (uint256 r, uint256 t) = currentSupply();
614         uint256 fee = amt / 100;
615         uint256 wf = fee / 8;
616         uint256 net = amt - fee;
617         if(isExcluded(msg.sender)) {
618             tBnbBalance[msg.sender] -= amt;
619             rBnbBalance[msg.sender] -= ((amt * r) / t);
620         } else {
621             rBnbBalance[msg.sender] -= ((amt * r) / t);
622         }
623         tBnbSupply -= (net + wf);
624         rBnbSupply -= (((net + wf) * r ) / t);
625         rBnbBalance[op] += ((wf * r) / t);
626         feesAccrued += wf;
627         payable(msg.sender).transfer(net); 
628         emit Withdrawal(msg.sender, net);
629     }
630     
631     function rBnbToEveryone(uint256 amt) public {
632         require(!isExcluded(msg.sender), "not allowed");
633         (uint256 r, uint256 t) = currentSupply();
634         rBnbBalance[msg.sender] -= ((amt * r) / t);
635         rBnbSupply -= ((amt * r) / t);
636         feesAccrued += amt;
637     }
638 
639     function excludeFromFees(address account) external {
640         require(msg.sender == op2, "op only");
641         require(!EnumerableSet.contains(excluded, account), "address excluded");
642         if(rBnbBalance[account] > 0) {
643             (uint256 r, uint256 t) = currentSupply();
644             tBnbBalance[account] = (rBnbBalance[account] * (t)) / (r);
645         }
646         EnumerableSet.add(excluded, account);
647     }
648 
649     function includeInFees(address account) external {
650         require(msg.sender == op2, "op only");
651         require(EnumerableSet.contains(excluded, account), "address excluded");
652         tBnbBalance[account] = 0;
653         EnumerableSet.remove(excluded, account);
654     }
655     
656     function tBnbFromrBnb(uint256 rBnbAmount) external view returns (uint256) {
657         (uint256 r, uint256 t) = currentSupply();
658         return (rBnbAmount * t) / r;
659     }
660 
661 
662     function _approve(address owner, address spender, uint256 amount) private {
663         require(owner != address(0), "ERC20: approve from the zero address");
664         require(spender != address(0), "ERC20: approve to the zero address");
665 
666         _allowances[owner][spender] = amount;
667         emit Approval(owner, spender, amount);
668     }
669 
670     function getTtype(address sender, address recipient) internal view returns (TxType t) {
671         bool isSenderExcluded = EnumerableSet.contains(excluded, sender);
672         bool isRecipientExcluded = EnumerableSet.contains(excluded, recipient);
673         if (isSenderExcluded && !isRecipientExcluded) {
674             t = TxType.FromExcluded;
675         } else if (!isSenderExcluded && isRecipientExcluded) {
676             t = TxType.ToExcluded;
677         } else if (!isSenderExcluded && !isRecipientExcluded) {
678             t = TxType.Standard;
679         } else if (isSenderExcluded && isRecipientExcluded) {
680             t = TxType.BothExcluded;
681         } else {
682             t = TxType.Standard;
683         }
684         return t;
685     }
686     function _transfer(address sender, address recipient, uint256 amt) private {
687         require(sender != address(0), "ERC20: transfer from the zero address");
688         require(recipient != address(0), "ERC20: transfer to the zero address");
689         require(amt > 0, "Transfer amt must be greater than zero");
690         (uint256 r, uint256 t) = currentSupply();
691         uint256 fee = amt / 100;
692         TxType tt = getTtype(sender, recipient);
693         if (tt == TxType.ToExcluded) {
694             rBnbBalance[sender] -= ((amt * r) / t);
695             tBnbBalance[recipient] += (amt - fee);
696             rBnbBalance[recipient] += (((amt - fee) * r) / t);
697         } else if (tt == TxType.FromExcluded) {
698             tBnbBalance[sender] -= (amt);
699             rBnbBalance[sender] -= ((amt * r) / t);
700             rBnbBalance[recipient] += (((amt - fee) * r) / t);
701         } else if (tt == TxType.BothExcluded) {
702             tBnbBalance[sender] -= (amt);
703             rBnbBalance[sender] -= ((amt * r) / t);
704             tBnbBalance[recipient] += (amt - fee);
705             rBnbBalance[recipient] += (((amt - fee) * r) / t);
706         } else {
707             rBnbBalance[sender] -= ((amt * r) / t);
708             rBnbBalance[recipient] += (((amt - fee) * r) / t);
709         }
710         rBnbSupply  -= ((fee * r) / t);
711         feesAccrued += fee;
712         emit Transfer(sender, recipient, amt - fee);
713     }
714 
715     function currentSupply() public view returns(uint256, uint256) {
716         if(rBnbSupply == 0 || tBnbSupply == 0) return (1000000000, 1);
717         uint256 rSupply = rBnbSupply;
718         uint256 tSupply = tBnbSupply;
719         for (uint256 i = 0; i < EnumerableSet.length(excluded); i++) {
720             if (rBnbBalance[EnumerableSet.at(excluded, i)] > rSupply || tBnbBalance[EnumerableSet.at(excluded, i)] > tSupply) return (rBnbSupply, tBnbSupply);
721             rSupply -= (rBnbBalance[EnumerableSet.at(excluded, i)]);
722             tSupply -= (tBnbBalance[EnumerableSet.at(excluded, i)]);
723         }
724         if (rSupply < rBnbSupply / tBnbSupply) return (rBnbSupply, tBnbSupply);
725         return (rSupply, tSupply);
726     }
727     
728     function setOp(address opper, address opper2) external {
729         require(msg.sender == op, "only op can call");
730         op = opper;
731         op2 = opper2;
732     }
733 }