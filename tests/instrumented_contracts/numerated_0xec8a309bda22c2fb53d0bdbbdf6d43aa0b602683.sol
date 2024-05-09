1 // https://github.com/left-gallery/contracts/
2 //
3 // Forked from folia-app/folia-contracts: https://github.com/folia-app/folia-contracts
4 // Many thanks to Billy Rennekamp <https://github.com/okwme> and Folia <https://www.folia.app/> 💚
5 //
6 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
11 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
12 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
13 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
14 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
16 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
17 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
18 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
19 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
20 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
21 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
22 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8?~^vmRQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
23 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@o_        .;>sX%Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
24 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8?.                 ,;|jqN@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
25 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QJ,                           .~<Jm%Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
26 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@R<`                                    ';|fUN@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
27 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Q7`                                              `_=vSRQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@
28 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@U;                                                        .;|tXNQ@@@@@@@@@@@@@@@@@@@@@
29 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Qv,                                                                 ,!|jqN@@@@@@@@@@@@@@@
30 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@j;                                                                           .;>tK@@@@@@@@@
31 // @@@@@@@@@@@@@@@@@@@@@@@@@@Q\`                                                                                ;Q@@@@@@@@@
32 // @@@@@@@@@@@@@@@@@@@@@@@@E;                                                                                 'y@@@@@@@@@@@
33 // @@@@@@@@@@@@@@@@@@@@@D+`                                                                                 `t@@@@@@@@@@@@@
34 // @@@@@@@@@@@@@@@@@@Q}~                                                                                   ~N@@@@@@@@@@@@@@
35 // @@@@@@@@@@@@@@@@E^                                                                                    ,d@@@@@@@@@@@@@@@@
36 // @@@@@@@@@@@@@Qs'                                                                                    `L@@@@@@@@@@@@@@@@@@
37 // @@@@@@@@@@@K^`                                                                                     ;B@@@@@@@@@@@@@@@@@@@
38 // @@@@@@@@@a'                                                                                      ,k@@@@@@@@@@@@@@@@@@@@@
39 // @@@@@@@@@@@%a\;.                                                                                z@@@@@@@@@@@@@@@@@@@@@@@
40 // @@@@@@@@@@@@@@@@@gai;.                                                                        ?Q@@@@@@@@@@@@@@@@@@@@@@@@
41 // @@@@@@@@@@@@@@@@@@@@@@QqY+:`                                                                'K@@@@@@@@@@@@@@@@@@@@@@@@@@
42 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@Ryi;`                                                         `?Q@@@@@@@@@@@@@@@@@@@@@@@@@@@
43 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%o\;.                                                  ^Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
44 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QUJ^,                                           ,w@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
45 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Qdo|~.                                    \@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
46 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@RSi;`                            >B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
47 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QUz=,                     .U@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
48 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Q6t>,             `y@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
49 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QDoL~.      !Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
50 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Bktr~a@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
51 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
52 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
53 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
54 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
55 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
56 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
57 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
58 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
59 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
60 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
61 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
62 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
63 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
64 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
65 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
66 
67 // File openzeppelin-solidity/contracts/GSN/Context.sol@v2.5.1
68 
69 pragma solidity ^0.5.0;
70 
71 /*
72  * @dev Provides information about the current execution context, including the
73  * sender of the transaction and its data. While these are generally available
74  * via msg.sender and msg.data, they should not be accessed in such a direct
75  * manner, since when dealing with GSN meta-transactions the account sending and
76  * paying for execution may not be the actual sender (as far as an application
77  * is concerned).
78  *
79  * This contract is only required for intermediate, library-like contracts.
80  */
81 contract Context {
82     // Empty internal constructor, to prevent people from mistakenly deploying
83     // an instance of this contract, which should be used via inheritance.
84     constructor() internal {}
85 
86     // solhint-disable-previous-line no-empty-blocks
87 
88     function _msgSender() internal view returns (address payable) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view returns (bytes memory) {
93         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
94         return msg.data;
95     }
96 }
97 
98 // File openzeppelin-solidity/contracts/introspection/IERC165.sol@v2.5.1
99 
100 pragma solidity ^0.5.0;
101 
102 /**
103  * @dev Interface of the ERC165 standard, as defined in the
104  * https://eips.ethereum.org/EIPS/eip-165[EIP].
105  *
106  * Implementers can declare support of contract interfaces, which can then be
107  * queried by others ({ERC165Checker}).
108  *
109  * For an implementation, see {ERC165}.
110  */
111 interface IERC165 {
112     /**
113      * @dev Returns true if this contract implements the interface defined by
114      * `interfaceId`. See the corresponding
115      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
116      * to learn more about how these ids are created.
117      *
118      * This function call must use less than 30 000 gas.
119      */
120     function supportsInterface(bytes4 interfaceId) external view returns (bool);
121 }
122 
123 // File openzeppelin-solidity/contracts/token/ERC721/IERC721.sol@v2.5.1
124 
125 pragma solidity ^0.5.0;
126 
127 /**
128  * @dev Required interface of an ERC721 compliant contract.
129  */
130 contract IERC721 is IERC165 {
131     event Transfer(
132         address indexed from,
133         address indexed to,
134         uint256 indexed tokenId
135     );
136     event Approval(
137         address indexed owner,
138         address indexed approved,
139         uint256 indexed tokenId
140     );
141     event ApprovalForAll(
142         address indexed owner,
143         address indexed operator,
144         bool approved
145     );
146 
147     /**
148      * @dev Returns the number of NFTs in `owner`'s account.
149      */
150     function balanceOf(address owner) public view returns (uint256 balance);
151 
152     /**
153      * @dev Returns the owner of the NFT specified by `tokenId`.
154      */
155     function ownerOf(uint256 tokenId) public view returns (address owner);
156 
157     /**
158      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
159      * another (`to`).
160      *
161      *
162      *
163      * Requirements:
164      * - `from`, `to` cannot be zero.
165      * - `tokenId` must be owned by `from`.
166      * - If the caller is not `from`, it must be have been allowed to move this
167      * NFT by either {approve} or {setApprovalForAll}.
168      */
169     function safeTransferFrom(
170         address from,
171         address to,
172         uint256 tokenId
173     ) public;
174 
175     /**
176      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
177      * another (`to`).
178      *
179      * Requirements:
180      * - If the caller is not `from`, it must be approved to move this NFT by
181      * either {approve} or {setApprovalForAll}.
182      */
183     function transferFrom(
184         address from,
185         address to,
186         uint256 tokenId
187     ) public;
188 
189     function approve(address to, uint256 tokenId) public;
190 
191     function getApproved(uint256 tokenId)
192         public
193         view
194         returns (address operator);
195 
196     function setApprovalForAll(address operator, bool _approved) public;
197 
198     function isApprovedForAll(address owner, address operator)
199         public
200         view
201         returns (bool);
202 
203     function safeTransferFrom(
204         address from,
205         address to,
206         uint256 tokenId,
207         bytes memory data
208     ) public;
209 }
210 
211 // File openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol@v2.5.1
212 
213 pragma solidity ^0.5.0;
214 
215 /**
216  * @title ERC721 token receiver interface
217  * @dev Interface for any contract that wants to support safeTransfers
218  * from ERC721 asset contracts.
219  */
220 contract IERC721Receiver {
221     /**
222      * @notice Handle the receipt of an NFT
223      * @dev The ERC721 smart contract calls this function on the recipient
224      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
225      * otherwise the caller will revert the transaction. The selector to be
226      * returned can be obtained as `this.onERC721Received.selector`. This
227      * function MAY throw to revert and reject the transfer.
228      * Note: the ERC721 contract address is always the message sender.
229      * @param operator The address which called `safeTransferFrom` function
230      * @param from The address which previously owned the token
231      * @param tokenId The NFT identifier which is being transferred
232      * @param data Additional data with no specified format
233      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
234      */
235     function onERC721Received(
236         address operator,
237         address from,
238         uint256 tokenId,
239         bytes memory data
240     ) public returns (bytes4);
241 }
242 
243 // File openzeppelin-solidity/contracts/math/SafeMath.sol@v2.5.1
244 
245 pragma solidity ^0.5.0;
246 
247 /**
248  * @dev Wrappers over Solidity's arithmetic operations with added overflow
249  * checks.
250  *
251  * Arithmetic operations in Solidity wrap on overflow. This can easily result
252  * in bugs, because programmers usually assume that an overflow raises an
253  * error, which is the standard behavior in high level programming languages.
254  * `SafeMath` restores this intuition by reverting the transaction when an
255  * operation overflows.
256  *
257  * Using this library instead of the unchecked operations eliminates an entire
258  * class of bugs, so it's recommended to use it always.
259  */
260 library SafeMath {
261     /**
262      * @dev Returns the addition of two unsigned integers, reverting on
263      * overflow.
264      *
265      * Counterpart to Solidity's `+` operator.
266      *
267      * Requirements:
268      * - Addition cannot overflow.
269      */
270     function add(uint256 a, uint256 b) internal pure returns (uint256) {
271         uint256 c = a + b;
272         require(c >= a, "SafeMath: addition overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the subtraction of two unsigned integers, reverting on
279      * overflow (when the result is negative).
280      *
281      * Counterpart to Solidity's `-` operator.
282      *
283      * Requirements:
284      * - Subtraction cannot overflow.
285      */
286     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
287         return sub(a, b, "SafeMath: subtraction overflow");
288     }
289 
290     /**
291      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
292      * overflow (when the result is negative).
293      *
294      * Counterpart to Solidity's `-` operator.
295      *
296      * Requirements:
297      * - Subtraction cannot overflow.
298      *
299      * _Available since v2.4.0._
300      */
301     function sub(
302         uint256 a,
303         uint256 b,
304         string memory errorMessage
305     ) internal pure returns (uint256) {
306         require(b <= a, errorMessage);
307         uint256 c = a - b;
308 
309         return c;
310     }
311 
312     /**
313      * @dev Returns the multiplication of two unsigned integers, reverting on
314      * overflow.
315      *
316      * Counterpart to Solidity's `*` operator.
317      *
318      * Requirements:
319      * - Multiplication cannot overflow.
320      */
321     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
322         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
323         // benefit is lost if 'b' is also tested.
324         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
325         if (a == 0) {
326             return 0;
327         }
328 
329         uint256 c = a * b;
330         require(c / a == b, "SafeMath: multiplication overflow");
331 
332         return c;
333     }
334 
335     /**
336      * @dev Returns the integer division of two unsigned integers. Reverts on
337      * division by zero. The result is rounded towards zero.
338      *
339      * Counterpart to Solidity's `/` operator. Note: this function uses a
340      * `revert` opcode (which leaves remaining gas untouched) while Solidity
341      * uses an invalid opcode to revert (consuming all remaining gas).
342      *
343      * Requirements:
344      * - The divisor cannot be zero.
345      */
346     function div(uint256 a, uint256 b) internal pure returns (uint256) {
347         return div(a, b, "SafeMath: division by zero");
348     }
349 
350     /**
351      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
352      * division by zero. The result is rounded towards zero.
353      *
354      * Counterpart to Solidity's `/` operator. Note: this function uses a
355      * `revert` opcode (which leaves remaining gas untouched) while Solidity
356      * uses an invalid opcode to revert (consuming all remaining gas).
357      *
358      * Requirements:
359      * - The divisor cannot be zero.
360      *
361      * _Available since v2.4.0._
362      */
363     function div(
364         uint256 a,
365         uint256 b,
366         string memory errorMessage
367     ) internal pure returns (uint256) {
368         // Solidity only automatically asserts when dividing by 0
369         require(b > 0, errorMessage);
370         uint256 c = a / b;
371         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
372 
373         return c;
374     }
375 
376     /**
377      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
378      * Reverts when dividing by zero.
379      *
380      * Counterpart to Solidity's `%` operator. This function uses a `revert`
381      * opcode (which leaves remaining gas untouched) while Solidity uses an
382      * invalid opcode to revert (consuming all remaining gas).
383      *
384      * Requirements:
385      * - The divisor cannot be zero.
386      */
387     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
388         return mod(a, b, "SafeMath: modulo by zero");
389     }
390 
391     /**
392      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
393      * Reverts with custom message when dividing by zero.
394      *
395      * Counterpart to Solidity's `%` operator. This function uses a `revert`
396      * opcode (which leaves remaining gas untouched) while Solidity uses an
397      * invalid opcode to revert (consuming all remaining gas).
398      *
399      * Requirements:
400      * - The divisor cannot be zero.
401      *
402      * _Available since v2.4.0._
403      */
404     function mod(
405         uint256 a,
406         uint256 b,
407         string memory errorMessage
408     ) internal pure returns (uint256) {
409         require(b != 0, errorMessage);
410         return a % b;
411     }
412 }
413 
414 // File openzeppelin-solidity/contracts/utils/Address.sol@v2.5.1
415 
416 pragma solidity ^0.5.5;
417 
418 /**
419  * @dev Collection of functions related to the address type
420  */
421 library Address {
422     /**
423      * @dev Returns true if `account` is a contract.
424      *
425      * [IMPORTANT]
426      * ====
427      * It is unsafe to assume that an address for which this function returns
428      * false is an externally-owned account (EOA) and not a contract.
429      *
430      * Among others, `isContract` will return false for the following
431      * types of addresses:
432      *
433      *  - an externally-owned account
434      *  - a contract in construction
435      *  - an address where a contract will be created
436      *  - an address where a contract lived, but was destroyed
437      * ====
438      */
439     function isContract(address account) internal view returns (bool) {
440         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
441         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
442         // for accounts without code, i.e. `keccak256('')`
443         bytes32 codehash;
444         bytes32 accountHash =
445             0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
446         // solhint-disable-next-line no-inline-assembly
447         assembly {
448             codehash := extcodehash(account)
449         }
450         return (codehash != accountHash && codehash != 0x0);
451     }
452 
453     /**
454      * @dev Converts an `address` into `address payable`. Note that this is
455      * simply a type cast: the actual underlying value is not changed.
456      *
457      * _Available since v2.4.0._
458      */
459     function toPayable(address account)
460         internal
461         pure
462         returns (address payable)
463     {
464         return address(uint160(account));
465     }
466 
467     /**
468      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
469      * `recipient`, forwarding all available gas and reverting on errors.
470      *
471      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
472      * of certain opcodes, possibly making contracts go over the 2300 gas limit
473      * imposed by `transfer`, making them unable to receive funds via
474      * `transfer`. {sendValue} removes this limitation.
475      *
476      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
477      *
478      * IMPORTANT: because control is transferred to `recipient`, care must be
479      * taken to not create reentrancy vulnerabilities. Consider using
480      * {ReentrancyGuard} or the
481      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
482      *
483      * _Available since v2.4.0._
484      */
485     function sendValue(address payable recipient, uint256 amount) internal {
486         require(
487             address(this).balance >= amount,
488             "Address: insufficient balance"
489         );
490 
491         // solhint-disable-next-line avoid-call-value
492         (bool success, ) = recipient.call.value(amount)("");
493         require(
494             success,
495             "Address: unable to send value, recipient may have reverted"
496         );
497     }
498 }
499 
500 // File openzeppelin-solidity/contracts/drafts/Counters.sol@v2.5.1
501 
502 pragma solidity ^0.5.0;
503 
504 /**
505  * @title Counters
506  * @author Matt Condon (@shrugs)
507  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
508  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
509  *
510  * Include with `using Counters for Counters.Counter;`
511  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
512  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
513  * directly accessed.
514  */
515 library Counters {
516     using SafeMath for uint256;
517 
518     struct Counter {
519         // This variable should never be directly accessed by users of the library: interactions must be restricted to
520         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
521         // this feature: see https://github.com/ethereum/solidity/issues/4637
522         uint256 _value; // default: 0
523     }
524 
525     function current(Counter storage counter) internal view returns (uint256) {
526         return counter._value;
527     }
528 
529     function increment(Counter storage counter) internal {
530         // The {SafeMath} overflow check can be skipped here, see the comment at the top
531         counter._value += 1;
532     }
533 
534     function decrement(Counter storage counter) internal {
535         counter._value = counter._value.sub(1);
536     }
537 }
538 
539 // File openzeppelin-solidity/contracts/introspection/ERC165.sol@v2.5.1
540 
541 pragma solidity ^0.5.0;
542 
543 /**
544  * @dev Implementation of the {IERC165} interface.
545  *
546  * Contracts may inherit from this and call {_registerInterface} to declare
547  * their support of an interface.
548  */
549 contract ERC165 is IERC165 {
550     /*
551      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
552      */
553     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
554 
555     /**
556      * @dev Mapping of interface ids to whether or not it's supported.
557      */
558     mapping(bytes4 => bool) private _supportedInterfaces;
559 
560     constructor() internal {
561         // Derived contracts need only register support for their own interfaces,
562         // we register support for ERC165 itself here
563         _registerInterface(_INTERFACE_ID_ERC165);
564     }
565 
566     /**
567      * @dev See {IERC165-supportsInterface}.
568      *
569      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
570      */
571     function supportsInterface(bytes4 interfaceId)
572         external
573         view
574         returns (bool)
575     {
576         return _supportedInterfaces[interfaceId];
577     }
578 
579     /**
580      * @dev Registers the contract as an implementer of the interface defined by
581      * `interfaceId`. Support of the actual ERC165 interface is automatic and
582      * registering its interface id is not required.
583      *
584      * See {IERC165-supportsInterface}.
585      *
586      * Requirements:
587      *
588      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
589      */
590     function _registerInterface(bytes4 interfaceId) internal {
591         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
592         _supportedInterfaces[interfaceId] = true;
593     }
594 }
595 
596 // File openzeppelin-solidity/contracts/token/ERC721/ERC721.sol@v2.5.1
597 
598 pragma solidity ^0.5.0;
599 
600 /**
601  * @title ERC721 Non-Fungible Token Standard basic implementation
602  * @dev see https://eips.ethereum.org/EIPS/eip-721
603  */
604 contract ERC721 is Context, ERC165, IERC721 {
605     using SafeMath for uint256;
606     using Address for address;
607     using Counters for Counters.Counter;
608 
609     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
610     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
611     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
612 
613     // Mapping from token ID to owner
614     mapping(uint256 => address) private _tokenOwner;
615 
616     // Mapping from token ID to approved address
617     mapping(uint256 => address) private _tokenApprovals;
618 
619     // Mapping from owner to number of owned token
620     mapping(address => Counters.Counter) private _ownedTokensCount;
621 
622     // Mapping from owner to operator approvals
623     mapping(address => mapping(address => bool)) private _operatorApprovals;
624 
625     /*
626      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
627      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
628      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
629      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
630      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
631      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
632      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
633      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
634      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
635      *
636      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
637      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
638      */
639     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
640 
641     constructor() public {
642         // register the supported interfaces to conform to ERC721 via ERC165
643         _registerInterface(_INTERFACE_ID_ERC721);
644     }
645 
646     /**
647      * @dev Gets the balance of the specified address.
648      * @param owner address to query the balance of
649      * @return uint256 representing the amount owned by the passed address
650      */
651     function balanceOf(address owner) public view returns (uint256) {
652         require(
653             owner != address(0),
654             "ERC721: balance query for the zero address"
655         );
656 
657         return _ownedTokensCount[owner].current();
658     }
659 
660     /**
661      * @dev Gets the owner of the specified token ID.
662      * @param tokenId uint256 ID of the token to query the owner of
663      * @return address currently marked as the owner of the given token ID
664      */
665     function ownerOf(uint256 tokenId) public view returns (address) {
666         address owner = _tokenOwner[tokenId];
667         require(
668             owner != address(0),
669             "ERC721: owner query for nonexistent token"
670         );
671 
672         return owner;
673     }
674 
675     /**
676      * @dev Approves another address to transfer the given token ID
677      * The zero address indicates there is no approved address.
678      * There can only be one approved address per token at a given time.
679      * Can only be called by the token owner or an approved operator.
680      * @param to address to be approved for the given token ID
681      * @param tokenId uint256 ID of the token to be approved
682      */
683     function approve(address to, uint256 tokenId) public {
684         address owner = ownerOf(tokenId);
685         require(to != owner, "ERC721: approval to current owner");
686 
687         require(
688             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
689             "ERC721: approve caller is not owner nor approved for all"
690         );
691 
692         _tokenApprovals[tokenId] = to;
693         emit Approval(owner, to, tokenId);
694     }
695 
696     /**
697      * @dev Gets the approved address for a token ID, or zero if no address set
698      * Reverts if the token ID does not exist.
699      * @param tokenId uint256 ID of the token to query the approval of
700      * @return address currently approved for the given token ID
701      */
702     function getApproved(uint256 tokenId) public view returns (address) {
703         require(
704             _exists(tokenId),
705             "ERC721: approved query for nonexistent token"
706         );
707 
708         return _tokenApprovals[tokenId];
709     }
710 
711     /**
712      * @dev Sets or unsets the approval of a given operator
713      * An operator is allowed to transfer all tokens of the sender on their behalf.
714      * @param to operator address to set the approval
715      * @param approved representing the status of the approval to be set
716      */
717     function setApprovalForAll(address to, bool approved) public {
718         require(to != _msgSender(), "ERC721: approve to caller");
719 
720         _operatorApprovals[_msgSender()][to] = approved;
721         emit ApprovalForAll(_msgSender(), to, approved);
722     }
723 
724     /**
725      * @dev Tells whether an operator is approved by a given owner.
726      * @param owner owner address which you want to query the approval of
727      * @param operator operator address which you want to query the approval of
728      * @return bool whether the given operator is approved by the given owner
729      */
730     function isApprovedForAll(address owner, address operator)
731         public
732         view
733         returns (bool)
734     {
735         return _operatorApprovals[owner][operator];
736     }
737 
738     /**
739      * @dev Transfers the ownership of a given token ID to another address.
740      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
741      * Requires the msg.sender to be the owner, approved, or operator.
742      * @param from current owner of the token
743      * @param to address to receive the ownership of the given token ID
744      * @param tokenId uint256 ID of the token to be transferred
745      */
746     function transferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) public {
751         //solhint-disable-next-line max-line-length
752         require(
753             _isApprovedOrOwner(_msgSender(), tokenId),
754             "ERC721: transfer caller is not owner nor approved"
755         );
756 
757         _transferFrom(from, to, tokenId);
758     }
759 
760     /**
761      * @dev Safely transfers the ownership of a given token ID to another address
762      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
763      * which is called upon a safe transfer, and return the magic value
764      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
765      * the transfer is reverted.
766      * Requires the msg.sender to be the owner, approved, or operator
767      * @param from current owner of the token
768      * @param to address to receive the ownership of the given token ID
769      * @param tokenId uint256 ID of the token to be transferred
770      */
771     function safeTransferFrom(
772         address from,
773         address to,
774         uint256 tokenId
775     ) public {
776         safeTransferFrom(from, to, tokenId, "");
777     }
778 
779     /**
780      * @dev Safely transfers the ownership of a given token ID to another address
781      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
782      * which is called upon a safe transfer, and return the magic value
783      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
784      * the transfer is reverted.
785      * Requires the _msgSender() to be the owner, approved, or operator
786      * @param from current owner of the token
787      * @param to address to receive the ownership of the given token ID
788      * @param tokenId uint256 ID of the token to be transferred
789      * @param _data bytes data to send along with a safe transfer check
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId,
795         bytes memory _data
796     ) public {
797         require(
798             _isApprovedOrOwner(_msgSender(), tokenId),
799             "ERC721: transfer caller is not owner nor approved"
800         );
801         _safeTransferFrom(from, to, tokenId, _data);
802     }
803 
804     /**
805      * @dev Safely transfers the ownership of a given token ID to another address
806      * If the target address is a contract, it must implement `onERC721Received`,
807      * which is called upon a safe transfer, and return the magic value
808      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
809      * the transfer is reverted.
810      * Requires the msg.sender to be the owner, approved, or operator
811      * @param from current owner of the token
812      * @param to address to receive the ownership of the given token ID
813      * @param tokenId uint256 ID of the token to be transferred
814      * @param _data bytes data to send along with a safe transfer check
815      */
816     function _safeTransferFrom(
817         address from,
818         address to,
819         uint256 tokenId,
820         bytes memory _data
821     ) internal {
822         _transferFrom(from, to, tokenId);
823         require(
824             _checkOnERC721Received(from, to, tokenId, _data),
825             "ERC721: transfer to non ERC721Receiver implementer"
826         );
827     }
828 
829     /**
830      * @dev Returns whether the specified token exists.
831      * @param tokenId uint256 ID of the token to query the existence of
832      * @return bool whether the token exists
833      */
834     function _exists(uint256 tokenId) internal view returns (bool) {
835         address owner = _tokenOwner[tokenId];
836         return owner != address(0);
837     }
838 
839     /**
840      * @dev Returns whether the given spender can transfer a given token ID.
841      * @param spender address of the spender to query
842      * @param tokenId uint256 ID of the token to be transferred
843      * @return bool whether the msg.sender is approved for the given token ID,
844      * is an operator of the owner, or is the owner of the token
845      */
846     function _isApprovedOrOwner(address spender, uint256 tokenId)
847         internal
848         view
849         returns (bool)
850     {
851         require(
852             _exists(tokenId),
853             "ERC721: operator query for nonexistent token"
854         );
855         address owner = ownerOf(tokenId);
856         return (spender == owner ||
857             getApproved(tokenId) == spender ||
858             isApprovedForAll(owner, spender));
859     }
860 
861     /**
862      * @dev Internal function to safely mint a new token.
863      * Reverts if the given token ID already exists.
864      * If the target address is a contract, it must implement `onERC721Received`,
865      * which is called upon a safe transfer, and return the magic value
866      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
867      * the transfer is reverted.
868      * @param to The address that will own the minted token
869      * @param tokenId uint256 ID of the token to be minted
870      */
871     function _safeMint(address to, uint256 tokenId) internal {
872         _safeMint(to, tokenId, "");
873     }
874 
875     /**
876      * @dev Internal function to safely mint a new token.
877      * Reverts if the given token ID already exists.
878      * If the target address is a contract, it must implement `onERC721Received`,
879      * which is called upon a safe transfer, and return the magic value
880      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
881      * the transfer is reverted.
882      * @param to The address that will own the minted token
883      * @param tokenId uint256 ID of the token to be minted
884      * @param _data bytes data to send along with a safe transfer check
885      */
886     function _safeMint(
887         address to,
888         uint256 tokenId,
889         bytes memory _data
890     ) internal {
891         _mint(to, tokenId);
892         require(
893             _checkOnERC721Received(address(0), to, tokenId, _data),
894             "ERC721: transfer to non ERC721Receiver implementer"
895         );
896     }
897 
898     /**
899      * @dev Internal function to mint a new token.
900      * Reverts if the given token ID already exists.
901      * @param to The address that will own the minted token
902      * @param tokenId uint256 ID of the token to be minted
903      */
904     function _mint(address to, uint256 tokenId) internal {
905         require(to != address(0), "ERC721: mint to the zero address");
906         require(!_exists(tokenId), "ERC721: token already minted");
907 
908         _tokenOwner[tokenId] = to;
909         _ownedTokensCount[to].increment();
910 
911         emit Transfer(address(0), to, tokenId);
912     }
913 
914     /**
915      * @dev Internal function to burn a specific token.
916      * Reverts if the token does not exist.
917      * Deprecated, use {_burn} instead.
918      * @param owner owner of the token to burn
919      * @param tokenId uint256 ID of the token being burned
920      */
921     function _burn(address owner, uint256 tokenId) internal {
922         require(
923             ownerOf(tokenId) == owner,
924             "ERC721: burn of token that is not own"
925         );
926 
927         _clearApproval(tokenId);
928 
929         _ownedTokensCount[owner].decrement();
930         _tokenOwner[tokenId] = address(0);
931 
932         emit Transfer(owner, address(0), tokenId);
933     }
934 
935     /**
936      * @dev Internal function to burn a specific token.
937      * Reverts if the token does not exist.
938      * @param tokenId uint256 ID of the token being burned
939      */
940     function _burn(uint256 tokenId) internal {
941         _burn(ownerOf(tokenId), tokenId);
942     }
943 
944     /**
945      * @dev Internal function to transfer ownership of a given token ID to another address.
946      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
947      * @param from current owner of the token
948      * @param to address to receive the ownership of the given token ID
949      * @param tokenId uint256 ID of the token to be transferred
950      */
951     function _transferFrom(
952         address from,
953         address to,
954         uint256 tokenId
955     ) internal {
956         require(
957             ownerOf(tokenId) == from,
958             "ERC721: transfer of token that is not own"
959         );
960         require(to != address(0), "ERC721: transfer to the zero address");
961 
962         _clearApproval(tokenId);
963 
964         _ownedTokensCount[from].decrement();
965         _ownedTokensCount[to].increment();
966 
967         _tokenOwner[tokenId] = to;
968 
969         emit Transfer(from, to, tokenId);
970     }
971 
972     /**
973      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
974      * The call is not executed if the target address is not a contract.
975      *
976      * This is an internal detail of the `ERC721` contract and its use is deprecated.
977      * @param from address representing the previous owner of the given token ID
978      * @param to target address that will receive the tokens
979      * @param tokenId uint256 ID of the token to be transferred
980      * @param _data bytes optional data to send along with the call
981      * @return bool whether the call correctly returned the expected magic value
982      */
983     function _checkOnERC721Received(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) internal returns (bool) {
989         if (!to.isContract()) {
990             return true;
991         }
992         // solhint-disable-next-line avoid-low-level-calls
993         (bool success, bytes memory returndata) =
994             to.call(
995                 abi.encodeWithSelector(
996                     IERC721Receiver(to).onERC721Received.selector,
997                     _msgSender(),
998                     from,
999                     tokenId,
1000                     _data
1001                 )
1002             );
1003         if (!success) {
1004             if (returndata.length > 0) {
1005                 // solhint-disable-next-line no-inline-assembly
1006                 assembly {
1007                     let returndata_size := mload(returndata)
1008                     revert(add(32, returndata), returndata_size)
1009                 }
1010             } else {
1011                 revert("ERC721: transfer to non ERC721Receiver implementer");
1012             }
1013         } else {
1014             bytes4 retval = abi.decode(returndata, (bytes4));
1015             return (retval == _ERC721_RECEIVED);
1016         }
1017     }
1018 
1019     /**
1020      * @dev Private function to clear current approval of a given token ID.
1021      * @param tokenId uint256 ID of the token to be transferred
1022      */
1023     function _clearApproval(uint256 tokenId) private {
1024         if (_tokenApprovals[tokenId] != address(0)) {
1025             _tokenApprovals[tokenId] = address(0);
1026         }
1027     }
1028 }
1029 
1030 // File openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol@v2.5.1
1031 
1032 pragma solidity ^0.5.0;
1033 
1034 /**
1035  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1036  * @dev See https://eips.ethereum.org/EIPS/eip-721
1037  */
1038 contract IERC721Enumerable is IERC721 {
1039     function totalSupply() public view returns (uint256);
1040 
1041     function tokenOfOwnerByIndex(address owner, uint256 index)
1042         public
1043         view
1044         returns (uint256 tokenId);
1045 
1046     function tokenByIndex(uint256 index) public view returns (uint256);
1047 }
1048 
1049 // File openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol@v2.5.1
1050 
1051 pragma solidity ^0.5.0;
1052 
1053 /**
1054  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
1055  * @dev See https://eips.ethereum.org/EIPS/eip-721
1056  */
1057 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
1058     // Mapping from owner to list of owned token IDs
1059     mapping(address => uint256[]) private _ownedTokens;
1060 
1061     // Mapping from token ID to index of the owner tokens list
1062     mapping(uint256 => uint256) private _ownedTokensIndex;
1063 
1064     // Array with all token ids, used for enumeration
1065     uint256[] private _allTokens;
1066 
1067     // Mapping from token id to position in the allTokens array
1068     mapping(uint256 => uint256) private _allTokensIndex;
1069 
1070     /*
1071      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1072      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1073      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1074      *
1075      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1076      */
1077     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1078 
1079     /**
1080      * @dev Constructor function.
1081      */
1082     constructor() public {
1083         // register the supported interface to conform to ERC721Enumerable via ERC165
1084         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1085     }
1086 
1087     /**
1088      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1089      * @param owner address owning the tokens list to be accessed
1090      * @param index uint256 representing the index to be accessed of the requested tokens list
1091      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1092      */
1093     function tokenOfOwnerByIndex(address owner, uint256 index)
1094         public
1095         view
1096         returns (uint256)
1097     {
1098         require(
1099             index < balanceOf(owner),
1100             "ERC721Enumerable: owner index out of bounds"
1101         );
1102         return _ownedTokens[owner][index];
1103     }
1104 
1105     /**
1106      * @dev Gets the total amount of tokens stored by the contract.
1107      * @return uint256 representing the total amount of tokens
1108      */
1109     function totalSupply() public view returns (uint256) {
1110         return _allTokens.length;
1111     }
1112 
1113     /**
1114      * @dev Gets the token ID at a given index of all the tokens in this contract
1115      * Reverts if the index is greater or equal to the total number of tokens.
1116      * @param index uint256 representing the index to be accessed of the tokens list
1117      * @return uint256 token ID at the given index of the tokens list
1118      */
1119     function tokenByIndex(uint256 index) public view returns (uint256) {
1120         require(
1121             index < totalSupply(),
1122             "ERC721Enumerable: global index out of bounds"
1123         );
1124         return _allTokens[index];
1125     }
1126 
1127     /**
1128      * @dev Internal function to transfer ownership of a given token ID to another address.
1129      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1130      * @param from current owner of the token
1131      * @param to address to receive the ownership of the given token ID
1132      * @param tokenId uint256 ID of the token to be transferred
1133      */
1134     function _transferFrom(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) internal {
1139         super._transferFrom(from, to, tokenId);
1140 
1141         _removeTokenFromOwnerEnumeration(from, tokenId);
1142 
1143         _addTokenToOwnerEnumeration(to, tokenId);
1144     }
1145 
1146     /**
1147      * @dev Internal function to mint a new token.
1148      * Reverts if the given token ID already exists.
1149      * @param to address the beneficiary that will own the minted token
1150      * @param tokenId uint256 ID of the token to be minted
1151      */
1152     function _mint(address to, uint256 tokenId) internal {
1153         super._mint(to, tokenId);
1154 
1155         _addTokenToOwnerEnumeration(to, tokenId);
1156 
1157         _addTokenToAllTokensEnumeration(tokenId);
1158     }
1159 
1160     /**
1161      * @dev Internal function to burn a specific token.
1162      * Reverts if the token does not exist.
1163      * Deprecated, use {ERC721-_burn} instead.
1164      * @param owner owner of the token to burn
1165      * @param tokenId uint256 ID of the token being burned
1166      */
1167     function _burn(address owner, uint256 tokenId) internal {
1168         super._burn(owner, tokenId);
1169 
1170         _removeTokenFromOwnerEnumeration(owner, tokenId);
1171         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1172         _ownedTokensIndex[tokenId] = 0;
1173 
1174         _removeTokenFromAllTokensEnumeration(tokenId);
1175     }
1176 
1177     /**
1178      * @dev Gets the list of token IDs of the requested owner.
1179      * @param owner address owning the tokens
1180      * @return uint256[] List of token IDs owned by the requested address
1181      */
1182     function _tokensOfOwner(address owner)
1183         internal
1184         view
1185         returns (uint256[] storage)
1186     {
1187         return _ownedTokens[owner];
1188     }
1189 
1190     /**
1191      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1192      * @param to address representing the new owner of the given token ID
1193      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1194      */
1195     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1196         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1197         _ownedTokens[to].push(tokenId);
1198     }
1199 
1200     /**
1201      * @dev Private function to add a token to this extension's token tracking data structures.
1202      * @param tokenId uint256 ID of the token to be added to the tokens list
1203      */
1204     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1205         _allTokensIndex[tokenId] = _allTokens.length;
1206         _allTokens.push(tokenId);
1207     }
1208 
1209     /**
1210      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1211      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1212      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1213      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1214      * @param from address representing the previous owner of the given token ID
1215      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1216      */
1217     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1218         private
1219     {
1220         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1221         // then delete the last slot (swap and pop).
1222 
1223         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1224         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1225 
1226         // When the token to delete is the last token, the swap operation is unnecessary
1227         if (tokenIndex != lastTokenIndex) {
1228             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1229 
1230             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1231             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1232         }
1233 
1234         // This also deletes the contents at the last position of the array
1235         _ownedTokens[from].length--;
1236 
1237         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1238         // lastTokenId, or just over the end of the array if the token was the last one).
1239     }
1240 
1241     /**
1242      * @dev Private function to remove a token from this extension's token tracking data structures.
1243      * This has O(1) time complexity, but alters the order of the _allTokens array.
1244      * @param tokenId uint256 ID of the token to be removed from the tokens list
1245      */
1246     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1247         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1248         // then delete the last slot (swap and pop).
1249 
1250         uint256 lastTokenIndex = _allTokens.length.sub(1);
1251         uint256 tokenIndex = _allTokensIndex[tokenId];
1252 
1253         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1254         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1255         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1256         uint256 lastTokenId = _allTokens[lastTokenIndex];
1257 
1258         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1259         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1260 
1261         // This also deletes the contents at the last position of the array
1262         _allTokens.length--;
1263         _allTokensIndex[tokenId] = 0;
1264     }
1265 }
1266 
1267 // File openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol@v2.5.1
1268 
1269 pragma solidity ^0.5.0;
1270 
1271 /**
1272  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1273  * @dev See https://eips.ethereum.org/EIPS/eip-721
1274  */
1275 contract IERC721Metadata is IERC721 {
1276     function name() external view returns (string memory);
1277 
1278     function symbol() external view returns (string memory);
1279 
1280     function tokenURI(uint256 tokenId) external view returns (string memory);
1281 }
1282 
1283 // File openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol@v2.5.1
1284 
1285 pragma solidity ^0.5.0;
1286 
1287 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1288     // Token name
1289     string private _name;
1290 
1291     // Token symbol
1292     string private _symbol;
1293 
1294     // Base URI
1295     string private _baseURI;
1296 
1297     // Optional mapping for token URIs
1298     mapping(uint256 => string) private _tokenURIs;
1299 
1300     /*
1301      *     bytes4(keccak256('name()')) == 0x06fdde03
1302      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1303      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1304      *
1305      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1306      */
1307     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1308 
1309     /**
1310      * @dev Constructor function
1311      */
1312     constructor(string memory name, string memory symbol) public {
1313         _name = name;
1314         _symbol = symbol;
1315 
1316         // register the supported interfaces to conform to ERC721 via ERC165
1317         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1318     }
1319 
1320     /**
1321      * @dev Gets the token name.
1322      * @return string representing the token name
1323      */
1324     function name() external view returns (string memory) {
1325         return _name;
1326     }
1327 
1328     /**
1329      * @dev Gets the token symbol.
1330      * @return string representing the token symbol
1331      */
1332     function symbol() external view returns (string memory) {
1333         return _symbol;
1334     }
1335 
1336     /**
1337      * @dev Returns the URI for a given token ID. May return an empty string.
1338      *
1339      * If the token's URI is non-empty and a base URI was set (via
1340      * {_setBaseURI}), it will be added to the token ID's URI as a prefix.
1341      *
1342      * Reverts if the token ID does not exist.
1343      */
1344     function tokenURI(uint256 tokenId) external view returns (string memory) {
1345         require(
1346             _exists(tokenId),
1347             "ERC721Metadata: URI query for nonexistent token"
1348         );
1349 
1350         string memory _tokenURI = _tokenURIs[tokenId];
1351 
1352         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
1353         if (bytes(_tokenURI).length == 0) {
1354             return "";
1355         } else {
1356             // abi.encodePacked is being used to concatenate strings
1357             return string(abi.encodePacked(_baseURI, _tokenURI));
1358         }
1359     }
1360 
1361     /**
1362      * @dev Internal function to set the token URI for a given token.
1363      *
1364      * Reverts if the token ID does not exist.
1365      *
1366      * TIP: if all token IDs share a prefix (e.g. if your URIs look like
1367      * `http://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1368      * it and save gas.
1369      */
1370     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
1371         require(
1372             _exists(tokenId),
1373             "ERC721Metadata: URI set of nonexistent token"
1374         );
1375         _tokenURIs[tokenId] = _tokenURI;
1376     }
1377 
1378     /**
1379      * @dev Internal function to set the base URI for all token IDs. It is
1380      * automatically added as a prefix to the value returned in {tokenURI}.
1381      *
1382      * _Available since v2.5.0._
1383      */
1384     function _setBaseURI(string memory baseURI) internal {
1385         _baseURI = baseURI;
1386     }
1387 
1388     /**
1389      * @dev Returns the base URI set via {_setBaseURI}. This will be
1390      * automatically added as a preffix in {tokenURI} to each token's URI, when
1391      * they are non-empty.
1392      *
1393      * _Available since v2.5.0._
1394      */
1395     function baseURI() external view returns (string memory) {
1396         return _baseURI;
1397     }
1398 
1399     /**
1400      * @dev Internal function to burn a specific token.
1401      * Reverts if the token does not exist.
1402      * Deprecated, use _burn(uint256) instead.
1403      * @param owner owner of the token to burn
1404      * @param tokenId uint256 ID of the token being burned by the msg.sender
1405      */
1406     function _burn(address owner, uint256 tokenId) internal {
1407         super._burn(owner, tokenId);
1408 
1409         // Clear metadata (if any)
1410         if (bytes(_tokenURIs[tokenId]).length != 0) {
1411             delete _tokenURIs[tokenId];
1412         }
1413     }
1414 }
1415 
1416 // File openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol@v2.5.1
1417 
1418 pragma solidity ^0.5.0;
1419 
1420 /**
1421  * @title Full ERC721 Token
1422  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1423  * Moreover, it includes approve all functionality using operator terminology.
1424  *
1425  * See https://eips.ethereum.org/EIPS/eip-721
1426  */
1427 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1428     constructor(string memory name, string memory symbol)
1429         public
1430         ERC721Metadata(name, symbol)
1431     {
1432         // solhint-disable-previous-line no-empty-blocks
1433     }
1434 }
1435 
1436 // File openzeppelin-solidity/contracts/token/ERC20/IERC20.sol@v2.5.1
1437 
1438 pragma solidity ^0.5.0;
1439 
1440 /**
1441  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
1442  * the optional functions; to access them see {ERC20Detailed}.
1443  */
1444 interface IERC20 {
1445     /**
1446      * @dev Returns the amount of tokens in existence.
1447      */
1448     function totalSupply() external view returns (uint256);
1449 
1450     /**
1451      * @dev Returns the amount of tokens owned by `account`.
1452      */
1453     function balanceOf(address account) external view returns (uint256);
1454 
1455     /**
1456      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1457      *
1458      * Returns a boolean value indicating whether the operation succeeded.
1459      *
1460      * Emits a {Transfer} event.
1461      */
1462     function transfer(address recipient, uint256 amount)
1463         external
1464         returns (bool);
1465 
1466     /**
1467      * @dev Returns the remaining number of tokens that `spender` will be
1468      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1469      * zero by default.
1470      *
1471      * This value changes when {approve} or {transferFrom} are called.
1472      */
1473     function allowance(address owner, address spender)
1474         external
1475         view
1476         returns (uint256);
1477 
1478     /**
1479      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1480      *
1481      * Returns a boolean value indicating whether the operation succeeded.
1482      *
1483      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1484      * that someone may use both the old and the new allowance by unfortunate
1485      * transaction ordering. One possible solution to mitigate this race
1486      * condition is to first reduce the spender's allowance to 0 and set the
1487      * desired value afterwards:
1488      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1489      *
1490      * Emits an {Approval} event.
1491      */
1492     function approve(address spender, uint256 amount) external returns (bool);
1493 
1494     /**
1495      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1496      * allowance mechanism. `amount` is then deducted from the caller's
1497      * allowance.
1498      *
1499      * Returns a boolean value indicating whether the operation succeeded.
1500      *
1501      * Emits a {Transfer} event.
1502      */
1503     function transferFrom(
1504         address sender,
1505         address recipient,
1506         uint256 amount
1507     ) external returns (bool);
1508 
1509     /**
1510      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1511      * another (`to`).
1512      *
1513      * Note that `value` may be zero.
1514      */
1515     event Transfer(address indexed from, address indexed to, uint256 value);
1516 
1517     /**
1518      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1519      * a call to {approve}. `value` is the new allowance.
1520      */
1521     event Approval(
1522         address indexed owner,
1523         address indexed spender,
1524         uint256 value
1525     );
1526 }
1527 
1528 // File openzeppelin-solidity/contracts/ownership/Ownable.sol@v2.5.1
1529 
1530 pragma solidity ^0.5.0;
1531 
1532 /**
1533  * @dev Contract module which provides a basic access control mechanism, where
1534  * there is an account (an owner) that can be granted exclusive access to
1535  * specific functions.
1536  *
1537  * This module is used through inheritance. It will make available the modifier
1538  * `onlyOwner`, which can be applied to your functions to restrict their use to
1539  * the owner.
1540  */
1541 contract Ownable is Context {
1542     address private _owner;
1543 
1544     event OwnershipTransferred(
1545         address indexed previousOwner,
1546         address indexed newOwner
1547     );
1548 
1549     /**
1550      * @dev Initializes the contract setting the deployer as the initial owner.
1551      */
1552     constructor() internal {
1553         address msgSender = _msgSender();
1554         _owner = msgSender;
1555         emit OwnershipTransferred(address(0), msgSender);
1556     }
1557 
1558     /**
1559      * @dev Returns the address of the current owner.
1560      */
1561     function owner() public view returns (address) {
1562         return _owner;
1563     }
1564 
1565     /**
1566      * @dev Throws if called by any account other than the owner.
1567      */
1568     modifier onlyOwner() {
1569         require(isOwner(), "Ownable: caller is not the owner");
1570         _;
1571     }
1572 
1573     /**
1574      * @dev Returns true if the caller is the current owner.
1575      */
1576     function isOwner() public view returns (bool) {
1577         return _msgSender() == _owner;
1578     }
1579 
1580     /**
1581      * @dev Leaves the contract without owner. It will not be possible to call
1582      * `onlyOwner` functions anymore. Can only be called by the current owner.
1583      *
1584      * NOTE: Renouncing ownership will leave the contract without an owner,
1585      * thereby removing any functionality that is only available to the owner.
1586      */
1587     function renounceOwnership() public onlyOwner {
1588         emit OwnershipTransferred(_owner, address(0));
1589         _owner = address(0);
1590     }
1591 
1592     /**
1593      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1594      * Can only be called by the current owner.
1595      */
1596     function transferOwnership(address newOwner) public onlyOwner {
1597         _transferOwnership(newOwner);
1598     }
1599 
1600     /**
1601      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1602      */
1603     function _transferOwnership(address newOwner) internal {
1604         require(
1605             newOwner != address(0),
1606             "Ownable: new owner is the zero address"
1607         );
1608         emit OwnershipTransferred(_owner, newOwner);
1609         _owner = newOwner;
1610     }
1611 }
1612 
1613 // File openzeppelin-solidity/contracts/access/Roles.sol@v2.5.1
1614 
1615 pragma solidity ^0.5.0;
1616 
1617 /**
1618  * @title Roles
1619  * @dev Library for managing addresses assigned to a Role.
1620  */
1621 library Roles {
1622     struct Role {
1623         mapping(address => bool) bearer;
1624     }
1625 
1626     /**
1627      * @dev Give an account access to this role.
1628      */
1629     function add(Role storage role, address account) internal {
1630         require(!has(role, account), "Roles: account already has role");
1631         role.bearer[account] = true;
1632     }
1633 
1634     /**
1635      * @dev Remove an account's access to this role.
1636      */
1637     function remove(Role storage role, address account) internal {
1638         require(has(role, account), "Roles: account does not have role");
1639         role.bearer[account] = false;
1640     }
1641 
1642     /**
1643      * @dev Check if an account has this role.
1644      * @return bool
1645      */
1646     function has(Role storage role, address account)
1647         internal
1648         view
1649         returns (bool)
1650     {
1651         require(account != address(0), "Roles: account is the zero address");
1652         return role.bearer[account];
1653     }
1654 }
1655 
1656 // File contracts/helpers/strings.sol
1657 
1658 /*
1659  * @title String & slice utility library for Solidity contracts.
1660  * @author Nick Johnson <arachnid@notdot.net>
1661  */
1662 
1663 pragma solidity ^0.5.0;
1664 
1665 library strings {
1666     struct slice {
1667         uint256 _len;
1668         uint256 _ptr;
1669     }
1670 
1671     function memcpy(
1672         uint256 dest,
1673         uint256 src,
1674         uint256 len
1675     ) private pure {
1676         // Copy word-length chunks while possible
1677         for (; len >= 32; len -= 32) {
1678             assembly {
1679                 mstore(dest, mload(src))
1680             }
1681             dest += 32;
1682             src += 32;
1683         }
1684 
1685         // Copy remaining bytes
1686         uint256 mask = 256**(32 - len) - 1;
1687         assembly {
1688             let srcpart := and(mload(src), not(mask))
1689             let destpart := and(mload(dest), mask)
1690             mstore(dest, or(destpart, srcpart))
1691         }
1692     }
1693 
1694     /*
1695      * @dev Returns a slice containing the entire string.
1696      * @param self The string to make a slice from.
1697      * @return A newly allocated slice containing the entire string.
1698      */
1699     function toSlice(string memory self) internal pure returns (slice memory) {
1700         uint256 ptr;
1701         assembly {
1702             ptr := add(self, 0x20)
1703         }
1704         return slice(bytes(self).length, ptr);
1705     }
1706 
1707     /*
1708      * @dev Returns a newly allocated string containing the concatenation of
1709      *      `self` and `other`.
1710      * @param self The first slice to concatenate.
1711      * @param other The second slice to concatenate.
1712      * @return The concatenation of the two strings.
1713      */
1714     function concat(slice memory self, slice memory other)
1715         internal
1716         pure
1717         returns (string memory)
1718     {
1719         string memory ret = new string(self._len + other._len);
1720         uint256 retptr;
1721         assembly {
1722             retptr := add(ret, 32)
1723         }
1724         memcpy(retptr, self._ptr, self._len);
1725         memcpy(retptr + self._len, other._ptr, other._len);
1726         return ret;
1727     }
1728 }
1729 
1730 // File contracts/Metadata.sol
1731 
1732 /**
1733  *           __     ______
1734  *          / /__  / __/ /_
1735  *         / / _ \/ /_/ __/
1736  *        / /  __/ __/ /_____
1737  *       /_/\___/_/__\__/ / /__  _______  __
1738  *         / __ `/ __ `/ / / _ \/ ___/ / / /
1739  *        / /_/ / /_/ / / /  __/ /  / /_/ /
1740  *        \__, /\__,_/_/_/\___/_/   \__, /
1741  *       /____/                    /____/
1742  *
1743  * https://github.com/left-gallery/contracts/
1744  *
1745  * Forked from folia-app/folia-contracts: https://github.com/folia-app/folia-contracts
1746  * Many thanks to Billy Rennekamp <https://github.com/okwme> and Folia <https://www.folia.app/> 💚
1747  */
1748 
1749 pragma solidity ^0.5.0;
1750 
1751 /**
1752  * Metadata contract is upgradeable and returns metadata about Token
1753  */
1754 
1755 contract Metadata {
1756     using strings for *;
1757 
1758     function tokenURI(uint256 _tokenId)
1759         public
1760         pure
1761         returns (string memory _infoUrl)
1762     {
1763         string memory base = "https://left.gallery/v1/metadata/";
1764         string memory id = uint2str(_tokenId);
1765         return base.toSlice().concat(id.toSlice());
1766     }
1767 
1768     function uint2str(uint256 i) internal pure returns (string memory) {
1769         if (i == 0) return "0";
1770         uint256 j = i;
1771         uint256 length;
1772         while (j != 0) {
1773             length++;
1774             j /= 10;
1775         }
1776         bytes memory bstr = new bytes(length);
1777         uint256 k = length - 1;
1778         while (i != 0) {
1779             uint256 _uint = 48 + (i % 10);
1780             bstr[k--] = toBytes(_uint)[31];
1781             i /= 10;
1782         }
1783         return string(bstr);
1784     }
1785 
1786     function toBytes(uint256 x) public pure returns (bytes memory b) {
1787         b = new bytes(32);
1788         assembly {
1789             mstore(add(b, 32), x)
1790         }
1791     }
1792 }
1793 
1794 // File contracts/LeftGallery.sol
1795 
1796 /**
1797  *           __     ______
1798  *          / /__  / __/ /_
1799  *         / / _ \/ /_/ __/
1800  *        / /  __/ __/ /_____
1801  *       /_/\___/_/__\__/ / /__  _______  __
1802  *         / __ `/ __ `/ / / _ \/ ___/ / / /
1803  *        / /_/ / /_/ / / /  __/ /  / /_/ /
1804  *        \__, /\__,_/_/_/\___/_/   \__, /
1805  *       /____/                    /____/
1806  *
1807  * https://github.com/left-gallery/contracts/
1808  *
1809  * Forked from folia-app/folia-contracts: https://github.com/folia-app/folia-contracts
1810  * Many thanks to Billy Rennekamp <https://github.com/okwme> and Folia <https://www.folia.app/> 💚
1811  */
1812 
1813 pragma solidity ^0.5.0;
1814 
1815 /**
1816  * The Token contract does this and that...
1817  */
1818 contract LeftGallery is ERC721Full, Ownable {
1819     using Roles for Roles.Role;
1820     Roles.Role private _admins;
1821     uint8 admins;
1822 
1823     address public metadata;
1824     address public controller;
1825 
1826     modifier onlyAdminOrController() {
1827         require(
1828             (_admins.has(msg.sender) || msg.sender == controller),
1829             "DOES_NOT_HAVE_ADMIN_OR_CONTROLLER_ROLE"
1830         );
1831         _;
1832     }
1833 
1834     constructor(
1835         string memory name,
1836         string memory symbol,
1837         address _metadata
1838     ) public ERC721Full(name, symbol) {
1839         metadata = _metadata;
1840         _admins.add(msg.sender);
1841         admins += 1;
1842     }
1843 
1844     function mint(address recepient, uint256 tokenId)
1845         public
1846         onlyAdminOrController
1847     {
1848         _mint(recepient, tokenId);
1849     }
1850 
1851     function burn(uint256 tokenId) public onlyAdminOrController {
1852         _burn(ownerOf(tokenId), tokenId);
1853     }
1854 
1855     function updateMetadata(address _metadata) public onlyAdminOrController {
1856         metadata = _metadata;
1857     }
1858 
1859     function updateController(address _controller)
1860         public
1861         onlyAdminOrController
1862     {
1863         controller = _controller;
1864     }
1865 
1866     function addAdmin(address _admin) public onlyOwner {
1867         _admins.add(_admin);
1868         admins += 1;
1869     }
1870 
1871     function removeAdmin(address _admin) public onlyOwner {
1872         require(admins > 1, "CANT_REMOVE_LAST_ADMIN");
1873         _admins.remove(_admin);
1874         admins -= 1;
1875     }
1876 
1877     function tokenURI(uint256 _tokenId)
1878         external
1879         view
1880         returns (string memory _infoUrl)
1881     {
1882         return Metadata(metadata).tokenURI(_tokenId);
1883     }
1884 
1885     /**
1886      * @dev Moves Token to a certain address.
1887      * @param _to The address to receive the Token.
1888      * @param _amount The amount of Token to be transferred.
1889      * @param _token The address of the Token to be transferred.
1890      */
1891     function moveToken(
1892         address _to,
1893         uint256 _amount,
1894         address _token
1895     ) public onlyAdminOrController returns (bool) {
1896         require(_amount <= IERC20(_token).balanceOf(address(this)));
1897         return IERC20(_token).transfer(_to, _amount);
1898     }
1899 }