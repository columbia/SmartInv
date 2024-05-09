1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 contract BoringOwnableData {
6     address public owner;
7     address public pendingOwner;
8 }
9 
10 contract BoringOwnable is BoringOwnableData {
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /// @notice `owner` defaults to msg.sender on construction.
14     constructor() {
15         owner = msg.sender;
16         emit OwnershipTransferred(address(0), msg.sender);
17     }
18 
19     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
20     /// Can only be invoked by the current `owner`.
21     /// @param newOwner Address of the new owner.
22     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
23     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
24     function transferOwnership(
25         address newOwner,
26         bool direct,
27         bool renounce
28     ) public onlyOwner {
29         if (direct) {
30             // Checks
31             require(newOwner != address(0) || renounce, "Ownable: zero address");
32 
33             // Effects
34             emit OwnershipTransferred(owner, newOwner);
35             owner = newOwner;
36             pendingOwner = address(0);
37         } else {
38             // Effects
39             pendingOwner = newOwner;
40         }
41     }
42 
43     /// @notice Needs to be called by `pendingOwner` to claim ownership.
44     function claimOwnership() public {
45         address _pendingOwner = pendingOwner;
46 
47         // Checks
48         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
49 
50         // Effects
51         emit OwnershipTransferred(owner, _pendingOwner);
52         owner = _pendingOwner;
53         pendingOwner = address(0);
54     }
55 
56     /// @notice Only allows the `owner` to execute the function.
57     modifier onlyOwner() {
58         require(msg.sender == owner, "Ownable: caller is not the owner");
59         _;
60     }
61 }
62 
63 contract Domain {
64     bytes32 private constant DOMAIN_SEPARATOR_SIGNATURE_HASH = keccak256("EIP712Domain(uint256 chainId,address verifyingContract)");
65     // See https://eips.ethereum.org/EIPS/eip-191
66     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
67 
68     // solhint-disable var-name-mixedcase
69     bytes32 private immutable _DOMAIN_SEPARATOR;
70     uint256 private immutable DOMAIN_SEPARATOR_CHAIN_ID;
71 
72     /// @dev Calculate the DOMAIN_SEPARATOR
73     function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
74         return keccak256(
75             abi.encode(
76                 DOMAIN_SEPARATOR_SIGNATURE_HASH,
77                 chainId,
78                 address(this)
79             )
80         );
81     }
82 
83     constructor() {
84         uint256 chainId; assembly {chainId := chainid()}
85         _DOMAIN_SEPARATOR = _calculateDomainSeparator(DOMAIN_SEPARATOR_CHAIN_ID = chainId);
86     }
87 
88     /// @dev Return the DOMAIN_SEPARATOR
89     // It's named internal to allow making it public from the contract that uses it by creating a simple view function
90     // with the desired public name, such as DOMAIN_SEPARATOR or domainSeparator.
91     // solhint-disable-next-line func-name-mixedcase
92     function _domainSeparator() internal view returns (bytes32) {
93         uint256 chainId; assembly {chainId := chainid()}
94         return chainId == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);
95     }
96 
97     function _getDigest(bytes32 dataHash) internal view returns (bytes32 digest) {
98         digest =
99             keccak256(
100                 abi.encodePacked(
101                     EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA,
102                     _domainSeparator(),
103                     dataHash
104                 )
105             );
106     }
107 }
108 
109 interface IERC20 {
110     function totalSupply() external view returns (uint256);
111 
112     function balanceOf(address account) external view returns (uint256);
113 
114     function allowance(address owner, address spender) external view returns (uint256);
115 
116     function approve(address spender, uint256 amount) external returns (bool);
117 
118     event Transfer(address indexed from, address indexed to, uint256 value);
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 
121     /// @notice EIP 2612
122     function permit(
123         address owner,
124         address spender,
125         uint256 value,
126         uint256 deadline,
127         uint8 v,
128         bytes32 r,
129         bytes32 s
130     ) external;
131 }
132 
133 // Data part taken out for building of contracts that receive delegate calls
134 contract ERC20Data {
135     /// @notice owner > balance mapping.
136     mapping(address => uint256) public balanceOf;
137     /// @notice owner > spender > allowance mapping.
138     mapping(address => mapping(address => uint256)) public allowance;
139     /// @notice owner > nonce mapping. Used in `permit`.
140     mapping(address => uint256) public nonces;
141 }
142 
143 abstract contract ERC20 is IERC20, Domain {
144     /// @notice owner > balance mapping.
145     mapping(address => uint256) public override balanceOf;
146     /// @notice owner > spender > allowance mapping.
147     mapping(address => mapping(address => uint256)) public override allowance;
148     /// @notice owner > nonce mapping. Used in `permit`.
149     mapping(address => uint256) public nonces;
150 
151     /// @notice Transfers `amount` tokens from `msg.sender` to `to`.
152     /// @param to The address to move the tokens.
153     /// @param amount of the tokens to move.
154     /// @return (bool) Returns True if succeeded.
155     function transfer(address to, uint256 amount) public returns (bool) {
156         // If `amount` is 0, or `msg.sender` is `to` nothing happens
157         if (amount != 0 || msg.sender == to) {
158             uint256 srcBalance = balanceOf[msg.sender];
159             require(srcBalance >= amount, "ERC20: balance too low");
160             if (msg.sender != to) {
161                 require(to != address(0), "ERC20: no zero address"); // Moved down so low balance calls safe some gas
162 
163                 balanceOf[msg.sender] = srcBalance - amount; // Underflow is checked
164                 balanceOf[to] += amount;
165             }
166         }
167         emit Transfer(msg.sender, to, amount);
168         return true;
169     }
170 
171     /// @notice Transfers `amount` tokens from `from` to `to`. Caller needs approval for `from`.
172     /// @param from Address to draw tokens from.
173     /// @param to The address to move the tokens.
174     /// @param amount The token amount to move.
175     /// @return (bool) Returns True if succeeded.
176     function transferFrom(
177         address from,
178         address to,
179         uint256 amount
180     ) public returns (bool) {
181         // If `amount` is 0, or `from` is `to` nothing happens
182         if (amount != 0) {
183             uint256 srcBalance = balanceOf[from];
184             require(srcBalance >= amount, "ERC20: balance too low");
185 
186             if (from != to) {
187                 uint256 spenderAllowance = allowance[from][msg.sender];
188                 // If allowance is infinite, don't decrease it to save on gas (breaks with EIP-20).
189                 if (spenderAllowance != type(uint256).max) {
190                     require(spenderAllowance >= amount, "ERC20: allowance too low");
191                     allowance[from][msg.sender] = spenderAllowance - amount; // Underflow is checked
192                 }
193                 require(to != address(0), "ERC20: no zero address"); // Moved down so other failed calls safe some gas
194 
195                 balanceOf[from] = srcBalance - amount; // Underflow is checked
196                 balanceOf[to] += amount;
197             }
198         }
199         emit Transfer(from, to, amount);
200         return true;
201     }
202 
203     /// @notice Approves `amount` from sender to be spend by `spender`.
204     /// @param spender Address of the party that can draw from msg.sender's account.
205     /// @param amount The maximum collective amount that `spender` can draw.
206     /// @return (bool) Returns True if approved.
207     function approve(address spender, uint256 amount) public override returns (bool) {
208         allowance[msg.sender][spender] = amount;
209         emit Approval(msg.sender, spender, amount);
210         return true;
211     }
212 
213     // solhint-disable-next-line func-name-mixedcase
214     function DOMAIN_SEPARATOR() external view returns (bytes32) {
215         return _domainSeparator();
216     }
217 
218     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
219     bytes32 private constant PERMIT_SIGNATURE_HASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
220 
221     /// @notice Approves `value` from `owner_` to be spend by `spender`.
222     /// @param owner_ Address of the owner.
223     /// @param spender The address of the spender that gets approved to draw from `owner_`.
224     /// @param value The maximum collective amount that `spender` can draw.
225     /// @param deadline This permit must be redeemed before this deadline (UTC timestamp in seconds).
226     function permit(
227         address owner_,
228         address spender,
229         uint256 value,
230         uint256 deadline,
231         uint8 v,
232         bytes32 r,
233         bytes32 s
234     ) external override {
235         require(owner_ != address(0), "ERC20: Owner cannot be 0");
236         require(block.timestamp < deadline, "ERC20: Expired");
237         require(
238             ecrecover(_getDigest(keccak256(abi.encode(PERMIT_SIGNATURE_HASH, owner_, spender, value, nonces[owner_]++, deadline))), v, r, s) ==
239                 owner_,
240             "ERC20: Invalid Signature"
241         );
242         allowance[owner_][spender] = value;
243         emit Approval(owner_, spender, value);
244     }
245 }
246 
247 library BoringMath {
248     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
249         require((c = a + b) >= b, "BoringMath: Add Overflow");
250     }
251 
252     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
253         require((c = a - b) <= a, "BoringMath: Underflow");
254     }
255 
256     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
257         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
258     }
259 }
260 
261 library EnumerableSet {
262     // To implement this library for multiple types with as little code
263     // repetition as possible, we write it in terms of a generic Set type with
264     // bytes32 values.
265     // The Set implementation uses private functions, and user-facing
266     // implementations (such as AddressSet) are just wrappers around the
267     // underlying Set.
268     // This means that we can only create new EnumerableSets for types that fit
269     // in bytes32.
270 
271     struct Set {
272         // Storage of set values
273         bytes32[] _values;
274         // Position of the value in the `values` array, plus 1 because index 0
275         // means a value is not in the set.
276         mapping(bytes32 => uint256) _indexes;
277     }
278 
279     /**
280      * @dev Add a value to a set. O(1).
281      *
282      * Returns true if the value was added to the set, that is if it was not
283      * already present.
284      */
285     function _add(Set storage set, bytes32 value) private returns (bool) {
286         if (!_contains(set, value)) {
287             set._values.push(value);
288             // The value is stored at length-1, but we add 1 to all indexes
289             // and use 0 as a sentinel value
290             set._indexes[value] = set._values.length;
291             return true;
292         } else {
293             return false;
294         }
295     }
296 
297     /**
298      * @dev Removes a value from a set. O(1).
299      *
300      * Returns true if the value was removed from the set, that is if it was
301      * present.
302      */
303     function _remove(Set storage set, bytes32 value) private returns (bool) {
304         // We read and store the value's index to prevent multiple reads from the same storage slot
305         uint256 valueIndex = set._indexes[value];
306 
307         if (valueIndex != 0) {
308             // Equivalent to contains(set, value)
309             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
310             // the array, and then remove the last element (sometimes called as 'swap and pop').
311             // This modifies the order of the array, as noted in {at}.
312 
313             uint256 toDeleteIndex = valueIndex - 1;
314             uint256 lastIndex = set._values.length - 1;
315 
316             if (lastIndex != toDeleteIndex) {
317                 bytes32 lastValue = set._values[lastIndex];
318 
319                 // Move the last value to the index where the value to delete is
320                 set._values[toDeleteIndex] = lastValue;
321                 // Update the index for the moved value
322                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
323             }
324 
325             // Delete the slot where the moved value was stored
326             set._values.pop();
327 
328             // Delete the index for the deleted slot
329             delete set._indexes[value];
330 
331             return true;
332         } else {
333             return false;
334         }
335     }
336 
337     /**
338      * @dev Returns true if the value is in the set. O(1).
339      */
340     function _contains(Set storage set, bytes32 value) private view returns (bool) {
341         return set._indexes[value] != 0;
342     }
343 
344     /**
345      * @dev Returns the number of values on the set. O(1).
346      */
347     function _length(Set storage set) private view returns (uint256) {
348         return set._values.length;
349     }
350 
351     /**
352      * @dev Returns the value stored at position `index` in the set. O(1).
353      *
354      * Note that there are no guarantees on the ordering of values inside the
355      * array, and it may change when more values are added or removed.
356      *
357      * Requirements:
358      *
359      * - `index` must be strictly less than {length}.
360      */
361     function _at(Set storage set, uint256 index) private view returns (bytes32) {
362         return set._values[index];
363     }
364 
365     /**
366      * @dev Return the entire set in an array
367      *
368      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
369      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
370      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
371      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
372      */
373     function _values(Set storage set) private view returns (bytes32[] memory) {
374         return set._values;
375     }
376 
377     // Bytes32Set
378 
379     struct Bytes32Set {
380         Set _inner;
381     }
382 
383     /**
384      * @dev Add a value to a set. O(1).
385      *
386      * Returns true if the value was added to the set, that is if it was not
387      * already present.
388      */
389     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
390         return _add(set._inner, value);
391     }
392 
393     /**
394      * @dev Removes a value from a set. O(1).
395      *
396      * Returns true if the value was removed from the set, that is if it was
397      * present.
398      */
399     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
400         return _remove(set._inner, value);
401     }
402 
403     /**
404      * @dev Returns true if the value is in the set. O(1).
405      */
406     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
407         return _contains(set._inner, value);
408     }
409 
410     /**
411      * @dev Returns the number of values in the set. O(1).
412      */
413     function length(Bytes32Set storage set) internal view returns (uint256) {
414         return _length(set._inner);
415     }
416 
417     /**
418      * @dev Returns the value stored at position `index` in the set. O(1).
419      *
420      * Note that there are no guarantees on the ordering of values inside the
421      * array, and it may change when more values are added or removed.
422      *
423      * Requirements:
424      *
425      * - `index` must be strictly less than {length}.
426      */
427     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
428         return _at(set._inner, index);
429     }
430 
431     /**
432      * @dev Return the entire set in an array
433      *
434      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
435      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
436      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
437      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
438      */
439     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
440         return _values(set._inner);
441     }
442 
443     // AddressSet
444 
445     struct AddressSet {
446         Set _inner;
447     }
448 
449     /**
450      * @dev Add a value to a set. O(1).
451      *
452      * Returns true if the value was added to the set, that is if it was not
453      * already present.
454      */
455     function add(AddressSet storage set, address value) internal returns (bool) {
456         return _add(set._inner, bytes32(uint256(uint160(value))));
457     }
458 
459     /**
460      * @dev Removes a value from a set. O(1).
461      *
462      * Returns true if the value was removed from the set, that is if it was
463      * present.
464      */
465     function remove(AddressSet storage set, address value) internal returns (bool) {
466         return _remove(set._inner, bytes32(uint256(uint160(value))));
467     }
468 
469     /**
470      * @dev Returns true if the value is in the set. O(1).
471      */
472     function contains(AddressSet storage set, address value) internal view returns (bool) {
473         return _contains(set._inner, bytes32(uint256(uint160(value))));
474     }
475 
476     /**
477      * @dev Returns the number of values in the set. O(1).
478      */
479     function length(AddressSet storage set) internal view returns (uint256) {
480         return _length(set._inner);
481     }
482 
483     /**
484      * @dev Returns the value stored at position `index` in the set. O(1).
485      *
486      * Note that there are no guarantees on the ordering of values inside the
487      * array, and it may change when more values are added or removed.
488      *
489      * Requirements:
490      *
491      * - `index` must be strictly less than {length}.
492      */
493     function at(AddressSet storage set, uint256 index) internal view returns (address) {
494         return address(uint160(uint256(_at(set._inner, index))));
495     }
496 
497     /**
498      * @dev Return the entire set in an array
499      *
500      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
501      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
502      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
503      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
504      */
505     function values(AddressSet storage set) internal view returns (address[] memory) {
506         bytes32[] memory store = _values(set._inner);
507         address[] memory result;
508 
509         /// @solidity memory-safe-assembly
510         assembly {
511             result := store
512         }
513 
514         return result;
515     }
516 
517     // UintSet
518 
519     struct UintSet {
520         Set _inner;
521     }
522 
523     /**
524      * @dev Add a value to a set. O(1).
525      *
526      * Returns true if the value was added to the set, that is if it was not
527      * already present.
528      */
529     function add(UintSet storage set, uint256 value) internal returns (bool) {
530         return _add(set._inner, bytes32(value));
531     }
532 
533     /**
534      * @dev Removes a value from a set. O(1).
535      *
536      * Returns true if the value was removed from the set, that is if it was
537      * present.
538      */
539     function remove(UintSet storage set, uint256 value) internal returns (bool) {
540         return _remove(set._inner, bytes32(value));
541     }
542 
543     /**
544      * @dev Returns true if the value is in the set. O(1).
545      */
546     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
547         return _contains(set._inner, bytes32(value));
548     }
549 
550     /**
551      * @dev Returns the number of values on the set. O(1).
552      */
553     function length(UintSet storage set) internal view returns (uint256) {
554         return _length(set._inner);
555     }
556 
557     /**
558      * @dev Returns the value stored at position `index` in the set. O(1).
559      *
560      * Note that there are no guarantees on the ordering of values inside the
561      * array, and it may change when more values are added or removed.
562      *
563      * Requirements:
564      *
565      * - `index` must be strictly less than {length}.
566      */
567     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
568         return uint256(_at(set._inner, index));
569     }
570 
571     /**
572      * @dev Return the entire set in an array
573      *
574      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
575      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
576      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
577      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
578      */
579     function values(UintSet storage set) internal view returns (uint256[] memory) {
580         bytes32[] memory store = _values(set._inner);
581         uint256[] memory result;
582 
583         /// @solidity memory-safe-assembly
584         assembly {
585             result := store
586         }
587 
588         return result;
589     }
590 }
591 
592 /// @title UwU
593 /// @author 0xForklend
594 contract UwU is ERC20, BoringOwnable {
595     using BoringMath for uint256;
596     using EnumerableSet for EnumerableSet.AddressSet;
597 
598     string public constant symbol = "UwU";
599     string public constant name = "UwU Lend";
600     uint8 public constant decimals = 18;
601     uint256 public override totalSupply;
602     uint256 public constant MAX_SUPPLY = 16 * 1e24;
603     EnumerableSet.AddressSet private minters;
604     EnumerableSet.AddressSet private burners;
605 
606     function mint(address to, uint256 amount) public isMinter {
607       _mint(to, amount);
608     }
609 
610     function burn(address to, uint256 amount) public isBurner {
611       _burn(to, amount);
612     }
613 
614     function _mint(address to, uint256 amount) internal {
615       require(to != address(0), "UwU: no mint to zero address");
616       require(MAX_SUPPLY >= totalSupply.add(amount), "UwU: Don't go over MAX");
617       totalSupply = totalSupply + amount;
618       balanceOf[to] += amount;
619       emit Transfer(address(0), to, amount);
620     }
621 
622     function _burn(address to, uint256 amount) internal {
623       require(balanceOf[to] >= amount, "Burn too much");
624       totalSupply -= amount;
625       balanceOf[to] -= amount;
626       emit Transfer(to, address(0), amount);
627     }
628 
629     function addMinter(address who) public onlyOwner {
630       require(!minters.contains(who), 'exists');
631       minters.add(who);
632     }
633 
634     function removeMinter(address who) public onlyOwner {
635       require(minters.contains(who), '!exists');
636       minters.remove(who);
637     }
638 
639     function getMinters() public view returns(address[] memory) {
640       return minters.values();
641     }
642 
643     function addBurner(address who) public onlyOwner {
644       require(!burners.contains(who), 'exists');
645       burners.add(who);
646     }
647 
648     function removeBurner(address who) public onlyOwner {
649       require(burners.contains(who), '!exists');
650       burners.remove(who);
651     }
652 
653     function getBurners() public view returns(address[] memory) {
654       return burners.values();
655     }
656 
657     modifier isMinter() {
658       require(minters.contains(msg.sender), '!minter');
659       _;
660     }
661 
662     modifier isBurner() {
663       require(burners.contains(msg.sender), '!burner');
664       _;
665     }
666 }