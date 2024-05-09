1 /*
2  * Crypto stamp colors storage
3  * Store colors for connected physical assets
4  *
5  * Developed by capacity.at
6  * for post.at
7  */
8 
9 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
10 
11 pragma solidity ^0.5.0;
12 
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others (`ERC165Checker`).
19  *
20  * For an implementation, see `ERC165`.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
35 
36 pragma solidity ^0.5.0;
37 
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 contract IERC721 is IERC165 {
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
46 
47     /**
48      * @dev Returns the number of NFTs in `owner`'s account.
49      */
50     function balanceOf(address owner) public view returns (uint256 balance);
51 
52     /**
53      * @dev Returns the owner of the NFT specified by `tokenId`.
54      */
55     function ownerOf(uint256 tokenId) public view returns (address owner);
56 
57     /**
58      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
59      * another (`to`).
60      *
61      * 
62      *
63      * Requirements:
64      * - `from`, `to` cannot be zero.
65      * - `tokenId` must be owned by `from`.
66      * - If the caller is not `from`, it must be have been allowed to move this
67      * NFT by either `approve` or `setApproveForAll`.
68      */
69     function safeTransferFrom(address from, address to, uint256 tokenId) public;
70     /**
71      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
72      * another (`to`).
73      *
74      * Requirements:
75      * - If the caller is not `from`, it must be approved to move this NFT by
76      * either `approve` or `setApproveForAll`.
77      */
78     function transferFrom(address from, address to, uint256 tokenId) public;
79     function approve(address to, uint256 tokenId) public;
80     function getApproved(uint256 tokenId) public view returns (address operator);
81 
82     function setApprovalForAll(address operator, bool _approved) public;
83     function isApprovedForAll(address owner, address operator) public view returns (bool);
84 
85 
86     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
87 }
88 
89 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
90 
91 pragma solidity ^0.5.0;
92 
93 
94 /**
95  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
96  * @dev See https://eips.ethereum.org/EIPS/eip-721
97  */
98 contract IERC721Enumerable is IERC721 {
99     function totalSupply() public view returns (uint256);
100     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
101 
102     function tokenByIndex(uint256 index) public view returns (uint256);
103 }
104 
105 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
106 
107 pragma solidity ^0.5.0;
108 
109 
110 /**
111  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
112  * @dev See https://eips.ethereum.org/EIPS/eip-721
113  */
114 contract IERC721Metadata is IERC721 {
115     function name() external view returns (string memory);
116     function symbol() external view returns (string memory);
117     function tokenURI(uint256 tokenId) external view returns (string memory);
118 }
119 
120 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Full.sol
121 
122 pragma solidity ^0.5.0;
123 
124 
125 
126 
127 /**
128  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
129  * @dev See https://eips.ethereum.org/EIPS/eip-721
130  */
131 contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {
132     // solhint-disable-previous-line no-empty-blocks
133 }
134 
135 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
136 
137 pragma solidity ^0.5.0;
138 
139 /**
140  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
141  * the optional functions; to access them see `ERC20Detailed`.
142  */
143 interface IERC20 {
144     /**
145      * @dev Returns the amount of tokens in existence.
146      */
147     function totalSupply() external view returns (uint256);
148 
149     /**
150      * @dev Returns the amount of tokens owned by `account`.
151      */
152     function balanceOf(address account) external view returns (uint256);
153 
154     /**
155      * @dev Moves `amount` tokens from the caller's account to `recipient`.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a `Transfer` event.
160      */
161     function transfer(address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Returns the remaining number of tokens that `spender` will be
165      * allowed to spend on behalf of `owner` through `transferFrom`. This is
166      * zero by default.
167      *
168      * This value changes when `approve` or `transferFrom` are called.
169      */
170     function allowance(address owner, address spender) external view returns (uint256);
171 
172     /**
173      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * > Beware that changing an allowance with this method brings the risk
178      * that someone may use both the old and the new allowance by unfortunate
179      * transaction ordering. One possible solution to mitigate this race
180      * condition is to first reduce the spender's allowance to 0 and set the
181      * desired value afterwards:
182      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183      *
184      * Emits an `Approval` event.
185      */
186     function approve(address spender, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Moves `amount` tokens from `sender` to `recipient` using the
190      * allowance mechanism. `amount` is then deducted from the caller's
191      * allowance.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * Emits a `Transfer` event.
196      */
197     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
198 
199     /**
200      * @dev Emitted when `value` tokens are moved from one account (`from`) to
201      * another (`to`).
202      *
203      * Note that `value` may be zero.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 value);
206 
207     /**
208      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
209      * a call to `approve`. `value` is the new allowance.
210      */
211     event Approval(address indexed owner, address indexed spender, uint256 value);
212 }
213 
214 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
215 
216 pragma solidity ^0.5.0;
217 
218 /**
219  * @dev Wrappers over Solidity's arithmetic operations with added overflow
220  * checks.
221  *
222  * Arithmetic operations in Solidity wrap on overflow. This can easily result
223  * in bugs, because programmers usually assume that an overflow raises an
224  * error, which is the standard behavior in high level programming languages.
225  * `SafeMath` restores this intuition by reverting the transaction when an
226  * operation overflows.
227  *
228  * Using this library instead of the unchecked operations eliminates an entire
229  * class of bugs, so it's recommended to use it always.
230  */
231 library SafeMath {
232     /**
233      * @dev Returns the addition of two unsigned integers, reverting on
234      * overflow.
235      *
236      * Counterpart to Solidity's `+` operator.
237      *
238      * Requirements:
239      * - Addition cannot overflow.
240      */
241     function add(uint256 a, uint256 b) internal pure returns (uint256) {
242         uint256 c = a + b;
243         require(c >= a, "SafeMath: addition overflow");
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the subtraction of two unsigned integers, reverting on
250      * overflow (when the result is negative).
251      *
252      * Counterpart to Solidity's `-` operator.
253      *
254      * Requirements:
255      * - Subtraction cannot overflow.
256      */
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         require(b <= a, "SafeMath: subtraction overflow");
259         uint256 c = a - b;
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the multiplication of two unsigned integers, reverting on
266      * overflow.
267      *
268      * Counterpart to Solidity's `*` operator.
269      *
270      * Requirements:
271      * - Multiplication cannot overflow.
272      */
273     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
274         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
275         // benefit is lost if 'b' is also tested.
276         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
277         if (a == 0) {
278             return 0;
279         }
280 
281         uint256 c = a * b;
282         require(c / a == b, "SafeMath: multiplication overflow");
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers. Reverts on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b) internal pure returns (uint256) {
299         // Solidity only automatically asserts when dividing by 0
300         require(b > 0, "SafeMath: division by zero");
301         uint256 c = a / b;
302         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * Reverts when dividing by zero.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319         require(b != 0, "SafeMath: modulo by zero");
320         return a % b;
321     }
322 }
323 
324 // File: contracts/CryptostampColors.sol
325 
326 /*
327 Implements a color store for crypto stamp
328 */
329 pragma solidity ^0.5.0;
330 
331 
332 
333 
334 contract CryptostampColors {
335     using SafeMath for uint256;
336 
337     IERC721Full internal cryptostamp;
338 
339     address public createControl;
340 
341     address public tokenAssignmentControl;
342 
343     enum Colors {
344         Black,
345         Green,
346         Blue,
347         Yellow,
348         Red
349     }
350 
351     uint256 public constant packFactor = 85;
352     uint256 public constant packBits = 3;
353     uint256[] public packedColors;
354 
355     event SavedColors(uint256 firstId, uint256 lastId);
356 
357     constructor(address _createControl, address _tokenAssignmentControl)
358     public
359     {
360         createControl = _createControl;
361         tokenAssignmentControl = _tokenAssignmentControl;
362     }
363 
364     modifier onlyCreateControl()
365     {
366         require(msg.sender == createControl, "createControl key required for this function.");
367         _;
368     }
369 
370     modifier onlyTokenAssignmentControl() {
371         require(msg.sender == tokenAssignmentControl, "tokenAssignmentControl key required for this function.");
372         _;
373     }
374 
375     modifier requireCryptostamp() {
376         require(address(cryptostamp) != address(0x0), "You need to provide an actual Cryptostamp contract.");
377         _;
378     }
379 
380     /*** Enable adjusting variables after deployment ***/
381 
382     function setCryptostamp(IERC721Full _newCryptostamp)
383     public
384     onlyCreateControl
385     {
386         require(address(_newCryptostamp) != address(0x0), "You need to provide an actual Cryptostamp contract.");
387         cryptostamp = _newCryptostamp;
388     }
389 
390     /*** Actual color storage ***/
391 
392     function calcPackedColors(Colors[] memory _values)
393     public pure
394     returns (uint256)
395     {
396         uint256 valcount = _values.length;
397         require(valcount <= packFactor, "Can only pack values up to a maximum of the packFactor.");
398         uint256 packedVal = 0;
399         for (uint256 i = 0; i < valcount; i++) {
400             packedVal += uint256(_values[i]) * (2 ** (i * packBits));
401         }
402         return packedVal;
403     }
404 
405     function setColorsPacked(uint256 _tokenIdStart, uint256[] memory _packedValues)
406     public
407     onlyCreateControl
408     requireCryptostamp
409     {
410         require(_tokenIdStart == packedColors.length * packFactor, "Values can can only be appended at the end.");
411         require(_tokenIdStart % packFactor == 0, "The starting token ID needs to be aligned with the packing factor.");
412         uint256 valcount = _packedValues.length;
413         for (uint256 i = 0; i < valcount; i++) {
414             packedColors.push(_packedValues[i]);
415         }
416         emit SavedColors(_tokenIdStart, totalSupply() - 1);
417     }
418 
419     // Returns the color of a given token ID
420     function getColor(uint256 tokenId)
421     public view
422     requireCryptostamp
423     returns (Colors)
424     {
425         require(tokenId < totalSupply(), "The token ID has no color stored.");
426         require(tokenId < cryptostamp.totalSupply(), "The token ID is not valid.");
427         uint256 packElement = tokenId / packFactor;
428         uint256 packItem = tokenId % packFactor;
429         uint256 packValue = (packedColors[packElement] >> (packBits * packItem)) % (2 ** packBits);
430         require(packValue < 5, "Error in packed Value.");
431         return Colors(packValue);
432     }
433 
434     // Returns the amount of colors saved.
435     function totalSupply()
436     public view
437     requireCryptostamp
438     returns (uint256)
439     {
440         uint256 maxSupply = packedColors.length * packFactor;
441         uint256 csSupply = cryptostamp.totalSupply();
442         if (csSupply < maxSupply) {
443             return csSupply;
444         }
445         return maxSupply;
446     }
447 
448     /*** Make sure currency or NFT doesn't get stranded in this contract ***/
449 
450     // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.
451     function rescueToken(IERC20 _foreignToken, address _to)
452     external
453     onlyTokenAssignmentControl
454     {
455         _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));
456     }
457 
458     // If this contract gets a balance in some ERC721 contract after it's finished, then we can rescue it.
459     function approveNFTrescue(IERC721 _foreignNFT, address _to)
460     external
461     onlyTokenAssignmentControl
462     {
463         _foreignNFT.setApprovalForAll(_to, true);
464     }
465  
466     // Make sure this contract cannot receive ETH.
467     function()
468     external payable
469     {
470         revert("The contract cannot receive ETH payments.");
471     }
472 }