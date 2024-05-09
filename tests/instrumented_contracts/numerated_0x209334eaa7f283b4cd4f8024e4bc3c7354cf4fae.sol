1 // Sources flattened with hardhat v2.6.7 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.2
4 
5 //SPDX-License-Identifier: Unlicense
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.2
32 
33 
34 pragma solidity >=0.6.0 <0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor () internal {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 
101 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2
102 
103 
104 pragma solidity >=0.6.0 <0.8.0;
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, with an overflow flag.
122      *
123      * _Available since v3.4._
124      */
125     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         uint256 c = a + b;
127         if (c < a) return (false, 0);
128         return (true, c);
129     }
130 
131     /**
132      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
133      *
134      * _Available since v3.4._
135      */
136     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         if (b > a) return (false, 0);
138         return (true, a - b);
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
143      *
144      * _Available since v3.4._
145      */
146     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) return (true, 0);
151         uint256 c = a * b;
152         if (c / a != b) return (false, 0);
153         return (true, c);
154     }
155 
156     /**
157      * @dev Returns the division of two unsigned integers, with a division by zero flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162         if (b == 0) return (false, 0);
163         return (true, a / b);
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
168      *
169      * _Available since v3.4._
170      */
171     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172         if (b == 0) return (false, 0);
173         return (true, a % b);
174     }
175 
176     /**
177      * @dev Returns the addition of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `+` operator.
181      *
182      * Requirements:
183      *
184      * - Addition cannot overflow.
185      */
186     function add(uint256 a, uint256 b) internal pure returns (uint256) {
187         uint256 c = a + b;
188         require(c >= a, "SafeMath: addition overflow");
189         return c;
190     }
191 
192     /**
193      * @dev Returns the subtraction of two unsigned integers, reverting on
194      * overflow (when the result is negative).
195      *
196      * Counterpart to Solidity's `-` operator.
197      *
198      * Requirements:
199      *
200      * - Subtraction cannot overflow.
201      */
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         require(b <= a, "SafeMath: subtraction overflow");
204         return a - b;
205     }
206 
207     /**
208      * @dev Returns the multiplication of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `*` operator.
212      *
213      * Requirements:
214      *
215      * - Multiplication cannot overflow.
216      */
217     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218         if (a == 0) return 0;
219         uint256 c = a * b;
220         require(c / a == b, "SafeMath: multiplication overflow");
221         return c;
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers, reverting on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
237         require(b > 0, "SafeMath: division by zero");
238         return a / b;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * reverting when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         require(b > 0, "SafeMath: modulo by zero");
255         return a % b;
256     }
257 
258     /**
259      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
260      * overflow (when the result is negative).
261      *
262      * CAUTION: This function is deprecated because it requires allocating memory for the error
263      * message unnecessarily. For custom revert reasons use {trySub}.
264      *
265      * Counterpart to Solidity's `-` operator.
266      *
267      * Requirements:
268      *
269      * - Subtraction cannot overflow.
270      */
271     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b <= a, errorMessage);
273         return a - b;
274     }
275 
276     /**
277      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
278      * division by zero. The result is rounded towards zero.
279      *
280      * CAUTION: This function is deprecated because it requires allocating memory for the error
281      * message unnecessarily. For custom revert reasons use {tryDiv}.
282      *
283      * Counterpart to Solidity's `/` operator. Note: this function uses a
284      * `revert` opcode (which leaves remaining gas untouched) while Solidity
285      * uses an invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         require(b > 0, errorMessage);
293         return a / b;
294     }
295 
296     /**
297      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
298      * reverting with custom message when dividing by zero.
299      *
300      * CAUTION: This function is deprecated because it requires allocating memory for the error
301      * message unnecessarily. For custom revert reasons use {tryMod}.
302      *
303      * Counterpart to Solidity's `%` operator. This function uses a `revert`
304      * opcode (which leaves remaining gas untouched) while Solidity uses an
305      * invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
312         require(b > 0, errorMessage);
313         return a % b;
314     }
315 }
316 
317 
318 // File contracts/ILootSkinMintable.sol
319 
320 
321 pragma solidity 0.6.12;
322 
323 interface ILootSkinMintable {
324     function mint(
325         address _to,
326         uint256 _tokenId,
327         uint256 _amount,
328         bytes memory _data
329     ) external;
330 
331     function mintBatch(
332         address _to,
333         uint256[] memory _ids,
334         uint256[] memory _amounts,
335         bytes memory _data
336     ) external;
337 }
338 
339 
340 // File contracts/StartingMint.sol
341 
342 
343 
344 pragma solidity 0.6.12;
345 
346 
347 
348 contract StartingMint is Ownable {
349     using SafeMath for uint256;
350 
351     //remaining box to public sale
352     uint256 public publicAvailable;
353     //remaining box which owner can mint
354     uint256 public privateAvailable;
355 
356     //ETH per box
357     uint256 public price = 0.05 ether;
358 
359     uint256 public startTime;
360 
361     //1. In the opening phase, 8 skins can be randomly opened for each box
362     uint256 public skinsInBox = 8;
363     //2. Total number of skins
364     uint256 public allSkins = 119;
365     //3. randomly skin id in (baseId + 0) to (baseId+allSkins) and
366     //4. randomly number will be generated by the segments of hash
367     uint256 public baseId = 1;
368     bytes32 mask4 =
369         0xffffffff00000000000000000000000000000000000000000000000000000000;
370 
371     ILootSkinMintable public lootSkin;
372 
373     constructor(ILootSkinMintable _lootSkin) public {
374         lootSkin = _lootSkin;
375     }
376 
377     function claim() public payable onlyEOA {
378         require(startTime > 0 && block.timestamp > startTime, "not start");
379         require(publicAvailable > 0, "mint out");
380         //pay eth
381         require(msg.value == price, "invalid value");
382         _claim(msg.sender);
383         publicAvailable = publicAvailable.sub(1);
384     }
385 
386     function ownerClaim(address _receiveAddress) public onlyOwner {
387         require(privateAvailable > 0, "private mint out");
388         _claim(_receiveAddress);
389         privateAvailable = privateAvailable.sub(1);
390     }
391 
392     function _claim(address _receiveAddress) internal {
393         _mintLoot(_receiveAddress);
394     }
395 
396     function _mintLoot(address _receiveAddress) internal {
397         bytes32 seed = keccak256(abi.encode(_receiveAddress, block.number));
398         //value is available id
399         uint256[] memory availableIds = new uint256[](allSkins);
400         uint256 length = availableIds.length;
401         //result, user will get $skinsInBox skins
402         uint256[] memory selectedIds = new uint256[](skinsInBox);
403         uint256[] memory amounts = new uint256[](skinsInBox);
404 
405         for (uint256 i = 0; i < skinsInBox; i++) {
406             //offset 4 bytes very time to generate random id
407             bytes4 n = bytes4((seed << (i * 4 * 8)) & mask4);
408             uint256 index = uint32(n) % length;
409             uint256 value;
410 
411             if (availableIds[index] == 0) {
412                 value = index;
413             } else {
414                 value = availableIds[index];
415             }
416 
417             if (availableIds[length - 1] == 0) {
418                 availableIds[index] = length - 1;
419             } else {
420                 availableIds[index] = availableIds[length - 1];
421             }
422 
423             selectedIds[i] = baseId + value;
424             amounts[i] = 1;
425 
426             length--;
427         }
428         //batch mint
429         lootSkin.mintBatch(_receiveAddress, selectedIds, amounts, "");
430     }
431 
432     modifier onlyEOA() {
433         require(msg.sender == tx.origin, "only EOA");
434         _;
435     }
436 
437     function setMintLootParams(
438         uint256 _allSkins,
439         uint256 _skinsInBox,
440         uint256 _baseId
441     ) public onlyOwner {
442         allSkins = _allSkins;
443         skinsInBox = _skinsInBox;
444         baseId = _baseId;
445     }
446 
447     function setPrice(uint256 _price) public onlyOwner {
448         price = _price;
449     }
450 
451     function setAvailable(uint256 _publicAvailable, uint256 _privateAvailable)
452         public
453         onlyOwner
454     {
455         publicAvailable = _publicAvailable;
456         privateAvailable = _privateAvailable;
457     }
458 
459     function setStartTime(uint256 _startTime) public onlyOwner {
460         require(startTime == 0, "can not reset");
461         require(block.timestamp < _startTime, "invilid startTime");
462         startTime = _startTime;
463     }
464 
465     function withdraw(
466         address _to,
467         address _token,
468         uint256 _value
469     ) public onlyOwner {
470         if (_token == address(0)) {
471             (bool success, ) = _to.call{value: _value}(new bytes(0));
472             require(success, "!safeTransferETH");
473         } else {
474             // bytes4(keccak256(bytes('transfer(address,uint256)')));
475             (bool success, bytes memory data) = _token.call(
476                 abi.encodeWithSelector(0xa9059cbb, _to, _value)
477             );
478             require(
479                 success && (data.length == 0 || abi.decode(data, (bool))),
480                 "!safeTransfer"
481             );
482         }
483     }
484 }