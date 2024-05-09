1 pragma solidity ^0.7.0;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor () internal {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(_owner == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 /**
90  * @dev Library for managing
91  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
92  * types.
93  *
94  * Sets have the following properties:
95  *
96  * - Elements are added, removed, and checked for existence in constant time
97  * (O(1)).
98  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
99  *
100  * ```
101  * contract Example {
102  *     // Add the library methods
103  *     using EnumerableSet for EnumerableSet.AddressSet;
104  *
105  *     // Declare a set state variable
106  *     EnumerableSet.AddressSet private mySet;
107  * }
108  * ```
109  *
110  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
111  * and `uint256` (`UintSet`) are supported.
112  */
113 library EnumerableSet {
114     // To implement this library for multiple types with as little code
115     // repetition as possible, we write it in terms of a generic Set type with
116     // bytes32 values.
117     // The Set implementation uses private functions, and user-facing
118     // implementations (such as AddressSet) are just wrappers around the
119     // underlying Set.
120     // This means that we can only create new EnumerableSets for types that fit
121     // in bytes32.
122 
123     struct Set {
124         // Storage of set values
125         bytes32[] _values;
126 
127         // Position of the value in the `values` array, plus 1 because index 0
128         // means a value is not in the set.
129         mapping (bytes32 => uint256) _indexes;
130     }
131 
132     /**
133      * @dev Add a value to a set. O(1).
134      *
135      * Returns true if the value was added to the set, that is if it was not
136      * already present.
137      */
138     function _add(Set storage set, bytes32 value) private returns (bool) {
139         if (!_contains(set, value)) {
140             set._values.push(value);
141             // The value is stored at length-1, but we add 1 to all indexes
142             // and use 0 as a sentinel value
143             set._indexes[value] = set._values.length;
144             return true;
145         } else {
146             return false;
147         }
148     }
149 
150     /**
151      * @dev Removes a value from a set. O(1).
152      *
153      * Returns true if the value was removed from the set, that is if it was
154      * present.
155      */
156     function _remove(Set storage set, bytes32 value) private returns (bool) {
157         // We read and store the value's index to prevent multiple reads from the same storage slot
158         uint256 valueIndex = set._indexes[value];
159 
160         if (valueIndex != 0) { // Equivalent to contains(set, value)
161             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
162             // the array, and then remove the last element (sometimes called as 'swap and pop').
163             // This modifies the order of the array, as noted in {at}.
164 
165             uint256 toDeleteIndex = valueIndex - 1;
166             uint256 lastIndex = set._values.length - 1;
167 
168             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
169             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
170 
171             bytes32 lastvalue = set._values[lastIndex];
172 
173             // Move the last value to the index where the value to delete is
174             set._values[toDeleteIndex] = lastvalue;
175             // Update the index for the moved value
176             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
177 
178             // Delete the slot where the moved value was stored
179             set._values.pop();
180 
181             // Delete the index for the deleted slot
182             delete set._indexes[value];
183 
184             return true;
185         } else {
186             return false;
187         }
188     }
189 
190     /**
191      * @dev Returns true if the value is in the set. O(1).
192      */
193     function _contains(Set storage set, bytes32 value) private view returns (bool) {
194         return set._indexes[value] != 0;
195     }
196 
197     /**
198      * @dev Returns the number of values on the set. O(1).
199      */
200     function _length(Set storage set) private view returns (uint256) {
201         return set._values.length;
202     }
203 
204    /**
205     * @dev Returns the value stored at position `index` in the set. O(1).
206     *
207     * Note that there are no guarantees on the ordering of values inside the
208     * array, and it may change when more values are added or removed.
209     *
210     * Requirements:
211     *
212     * - `index` must be strictly less than {length}.
213     */
214     function _at(Set storage set, uint256 index) private view returns (bytes32) {
215         require(set._values.length > index, "EnumerableSet: index out of bounds");
216         return set._values[index];
217     }
218 
219     // Bytes32Set
220 
221     struct Bytes32Set {
222         Set _inner;
223     }
224 
225     /**
226      * @dev Add a value to a set. O(1).
227      *
228      * Returns true if the value was added to the set, that is if it was not
229      * already present.
230      */
231     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
232         return _add(set._inner, value);
233     }
234 
235     /**
236      * @dev Removes a value from a set. O(1).
237      *
238      * Returns true if the value was removed from the set, that is if it was
239      * present.
240      */
241     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
242         return _remove(set._inner, value);
243     }
244 
245     /**
246      * @dev Returns true if the value is in the set. O(1).
247      */
248     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
249         return _contains(set._inner, value);
250     }
251 
252     /**
253      * @dev Returns the number of values in the set. O(1).
254      */
255     function length(Bytes32Set storage set) internal view returns (uint256) {
256         return _length(set._inner);
257     }
258 
259    /**
260     * @dev Returns the value stored at position `index` in the set. O(1).
261     *
262     * Note that there are no guarantees on the ordering of values inside the
263     * array, and it may change when more values are added or removed.
264     *
265     * Requirements:
266     *
267     * - `index` must be strictly less than {length}.
268     */
269     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
270         return _at(set._inner, index);
271     }
272 
273     // AddressSet
274 
275     struct AddressSet {
276         Set _inner;
277     }
278 
279     /**
280      * @dev Add a value to a set. O(1).
281      *
282      * Returns true if the value was added to the set, that is if it was not
283      * already present.
284      */
285     function add(AddressSet storage set, address value) internal returns (bool) {
286         return _add(set._inner, bytes32(uint256(value)));
287     }
288 
289     /**
290      * @dev Removes a value from a set. O(1).
291      *
292      * Returns true if the value was removed from the set, that is if it was
293      * present.
294      */
295     function remove(AddressSet storage set, address value) internal returns (bool) {
296         return _remove(set._inner, bytes32(uint256(value)));
297     }
298 
299     /**
300      * @dev Returns true if the value is in the set. O(1).
301      */
302     function contains(AddressSet storage set, address value) internal view returns (bool) {
303         return _contains(set._inner, bytes32(uint256(value)));
304     }
305 
306     /**
307      * @dev Returns the number of values in the set. O(1).
308      */
309     function length(AddressSet storage set) internal view returns (uint256) {
310         return _length(set._inner);
311     }
312 
313    /**
314     * @dev Returns the value stored at position `index` in the set. O(1).
315     *
316     * Note that there are no guarantees on the ordering of values inside the
317     * array, and it may change when more values are added or removed.
318     *
319     * Requirements:
320     *
321     * - `index` must be strictly less than {length}.
322     */
323     function at(AddressSet storage set, uint256 index) internal view returns (address) {
324         return address(uint256(_at(set._inner, index)));
325     }
326 
327 
328     // UintSet
329 
330     struct UintSet {
331         Set _inner;
332     }
333 
334     /**
335      * @dev Add a value to a set. O(1).
336      *
337      * Returns true if the value was added to the set, that is if it was not
338      * already present.
339      */
340     function add(UintSet storage set, uint256 value) internal returns (bool) {
341         return _add(set._inner, bytes32(value));
342     }
343 
344     /**
345      * @dev Removes a value from a set. O(1).
346      *
347      * Returns true if the value was removed from the set, that is if it was
348      * present.
349      */
350     function remove(UintSet storage set, uint256 value) internal returns (bool) {
351         return _remove(set._inner, bytes32(value));
352     }
353 
354     /**
355      * @dev Returns true if the value is in the set. O(1).
356      */
357     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
358         return _contains(set._inner, bytes32(value));
359     }
360 
361     /**
362      * @dev Returns the number of values on the set. O(1).
363      */
364     function length(UintSet storage set) internal view returns (uint256) {
365         return _length(set._inner);
366     }
367 
368    /**
369     * @dev Returns the value stored at position `index` in the set. O(1).
370     *
371     * Note that there are no guarantees on the ordering of values inside the
372     * array, and it may change when more values are added or removed.
373     *
374     * Requirements:
375     *
376     * - `index` must be strictly less than {length}.
377     */
378     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
379         return uint256(_at(set._inner, index));
380     }
381 }
382 
383 /**
384  * @dev interface of MomijiToken
385  *
386  */
387 interface IMomijiToken {
388     function tokenQuantityWithId(uint256 tokenId) view external returns(uint256);
389     function tokenMaxQuantityWithId(uint256 tokenId) view external returns(uint256);
390     function mintManuallyQuantityWithId(uint256 tokenId) view external returns(uint256);
391     function creators(uint256 tokenId) view external returns(address);
392     function removeMintManuallyQuantity(uint256 tokenId, uint256 amount) external;
393     function addMintManuallyQuantity(uint256 tokenId, uint256 amount) external;
394     function create(uint256 tokenId, uint256 maxSupply, string memory uri, bytes calldata data) external;
395     function mint(uint256 tokenId, address to, uint256 quantity, bytes memory data) external;
396     function balanceOf(address account, uint256 id) external view returns (uint256);
397     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) external;
398     function transferCreator(uint256 id, address account) external;
399     function addMinter(uint256 id, address account) external;
400 }
401 
402 /**
403  Author: DokiDoki Dev: Kaki
404  */
405 contract MomijiTokenManager is Ownable {
406     using EnumerableSet for EnumerableSet.UintSet;
407 
408     IMomijiToken public momijiToken;
409     mapping(address => EnumerableSet.UintSet) private _tokensForCreator;
410     mapping(address => bool) public whitelist;
411     uint256 whitelistCount;
412 
413     bool public onlyForWhitelist = true;
414 
415     constructor(IMomijiToken _momijiToken) {
416         momijiToken = _momijiToken;
417     }
418 
419     // After creating a new card, will mint it automatically.
420     function create(uint256 tokenId, uint256 maxSupply, string memory uri, bytes calldata data) public {
421         if (onlyForWhitelist) {
422             require(whitelist[msg.sender], "Open to only whitelist.");
423         }
424         momijiToken.create(tokenId, maxSupply, uri, data);
425         momijiToken.addMinter(tokenId, address(this));
426         momijiToken.mint(tokenId, msg.sender, maxSupply, data);
427         momijiToken.removeMintManuallyQuantity(tokenId, maxSupply);
428         momijiToken.transferCreator(tokenId, msg.sender);
429         _tokensForCreator[msg.sender].add(tokenId);
430     }
431 
432     // Get how many cards of a creator.
433     function getTokenAmountOfCreator(address account) view public returns(uint256) {
434         return _tokensForCreator[account].length();
435     }
436 
437     // Get tokenid of the creator with an index
438     function getTokenIdOfCreator(address account, uint256 index) view public returns(uint256) {
439         return _tokensForCreator[account].at(index);
440     }
441 
442     // Add a new card to this creator
443     function addCardManually(uint256 cardId) public {
444         require(msg.sender == momijiToken.creators(cardId), "You are not the creator of this NFT.");
445         _tokensForCreator[msg.sender].add(cardId);
446     }
447 
448     // Remove a card from set of creator.
449     function removeCardManually(uint256 cardId) public {
450         require(_tokensForCreator[msg.sender].contains(cardId), "This NFT is not in your creation.");
451         _tokensForCreator[msg.sender].remove(cardId);
452     }
453 
454     // add a new artist
455     function addToWhitelist(address account) public onlyOwner {
456         whitelist[account] = true;
457         whitelistCount += 1;
458     }
459 
460     // Remove an artist
461     function removeFromWhitelist(address account) public onlyOwner {
462         whitelist[account] = false;
463     }
464 
465     function openToEveryone() public onlyOwner {
466         onlyForWhitelist = false;
467     }
468 
469     function openOnlyToWhitelist() public onlyOwner {
470         onlyForWhitelist = true;
471     }
472 }