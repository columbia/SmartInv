1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: @gnosis.pm/util-contracts/contracts/Fixed192x64Math.sol
70 
71 pragma solidity >=0.4.24 ^0.5.1;
72 
73 
74 /// @title Fixed192x64Math library - Allows calculation of logarithmic and exponential functions
75 /// @author Alan Lu - <alan.lu@gnosis.pm>
76 /// @author Stefan George - <stefan@gnosis.pm>
77 library Fixed192x64Math {
78 
79     enum EstimationMode { LowerBound, UpperBound, Midpoint }
80 
81     /*
82      *  Constants
83      */
84     // This is equal to 1 in our calculations
85     uint public constant ONE =  0x10000000000000000;
86     uint public constant LN2 = 0xb17217f7d1cf79ac;
87     uint public constant LOG2_E = 0x171547652b82fe177;
88 
89     /*
90      *  Public functions
91      */
92     /// @dev Returns natural exponential function value of given x
93     /// @param x x
94     /// @return e**x
95     function exp(int x)
96         public
97         pure
98         returns (uint)
99     {
100         // revert if x is > MAX_POWER, where
101         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
102         require(x <= 2454971259878909886679);
103         // return 0 if exp(x) is tiny, using
104         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
105         if (x <= -818323753292969962227)
106             return 0;
107 
108         // Transform so that e^x -> 2^x
109         (uint lower, uint upper) = pow2Bounds(x * int(ONE) / int(LN2));
110         return (upper - lower) / 2 + lower;
111     }
112 
113     /// @dev Returns estimate of 2**x given x
114     /// @param x exponent in fixed point
115     /// @param estimationMode whether to return a lower bound, upper bound, or a midpoint
116     /// @return estimate of 2**x in fixed point
117     function pow2(int x, EstimationMode estimationMode)
118         public
119         pure
120         returns (uint)
121     {
122         (uint lower, uint upper) = pow2Bounds(x);
123         if(estimationMode == EstimationMode.LowerBound) {
124             return lower;
125         }
126         if(estimationMode == EstimationMode.UpperBound) {
127             return upper;
128         }
129         if(estimationMode == EstimationMode.Midpoint) {
130             return (upper - lower) / 2 + lower;
131         }
132         revert();
133     }
134 
135     /// @dev Returns bounds for value of 2**x given x
136     /// @param x exponent in fixed point
137     /// @return {
138     ///   "lower": "lower bound of 2**x in fixed point",
139     ///   "upper": "upper bound of 2**x in fixed point"
140     /// }
141     function pow2Bounds(int x)
142         public
143         pure
144         returns (uint lower, uint upper)
145     {
146         // revert if x is > MAX_POWER, where
147         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE, 2) * ONE))
148         require(x <= 3541774862152233910271);
149         // return 0 if exp(x) is tiny, using
150         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE, 2) * ONE))
151         if (x < -1180591620717411303424)
152             return (0, 1);
153 
154         // 2^x = 2^(floor(x)) * 2^(x-floor(x))
155         //       ^^^^^^^^^^^^^^ is a bit shift of ceil(x)
156         // so Taylor expand on z = x-floor(x), z in [0, 1)
157         int shift;
158         int z;
159         if (x >= 0) {
160             shift = x / int(ONE);
161             z = x % int(ONE);
162         }
163         else {
164             shift = (x+1) / int(ONE) - 1;
165             z = x - (int(ONE) * shift);
166         }
167         assert(z >= 0);
168         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
169         //
170         // Can generate the z coefficients using mpmath and the following lines
171         // >>> from mpmath import mp
172         // >>> mp.dps = 100
173         // >>> coeffs = [mp.log(2)**i / mp.factorial(i) for i in range(1, 21)]
174         // >>> shifts = [64 - int(mp.log(c, 2)) for c in coeffs]
175         // >>> print('\n'.join(hex(int(c * (1 << s))) + ', ' + str(s) for c, s in zip(coeffs, shifts)))
176         int result = int(ONE) << 64;
177         int zpow = z;
178         result += 0xb17217f7d1cf79ab * zpow;
179         zpow = zpow * z / int(ONE);
180         result += 0xf5fdeffc162c7543 * zpow >> (66 - 64);
181         zpow = zpow * z / int(ONE);
182         result += 0xe35846b82505fc59 * zpow >> (68 - 64);
183         zpow = zpow * z / int(ONE);
184         result += 0x9d955b7dd273b94e * zpow >> (70 - 64);
185         zpow = zpow * z / int(ONE);
186         result += 0xaec3ff3c53398883 * zpow >> (73 - 64);
187         zpow = zpow * z / int(ONE);
188         result += 0xa184897c363c3b7a * zpow >> (76 - 64);
189         zpow = zpow * z / int(ONE);
190         result += 0xffe5fe2c45863435 * zpow >> (80 - 64);
191         zpow = zpow * z / int(ONE);
192         result += 0xb160111d2e411fec * zpow >> (83 - 64);
193         zpow = zpow * z / int(ONE);
194         result += 0xda929e9caf3e1ed2 * zpow >> (87 - 64);
195         zpow = zpow * z / int(ONE);
196         result += 0xf267a8ac5c764fb7 * zpow >> (91 - 64);
197         zpow = zpow * z / int(ONE);
198         result += 0xf465639a8dd92607 * zpow >> (95 - 64);
199         zpow = zpow * z / int(ONE);
200         result += 0xe1deb287e14c2f15 * zpow >> (99 - 64);
201         zpow = zpow * z / int(ONE);
202         result += 0xc0b0c98b3687cb14 * zpow >> (103 - 64);
203         zpow = zpow * z / int(ONE);
204         result += 0x98a4b26ac3c54b9f * zpow >> (107 - 64);
205         zpow = zpow * z / int(ONE);
206         result += 0xe1b7421d82010f33 * zpow >> (112 - 64);
207         zpow = zpow * z / int(ONE);
208         result += 0x9c744d73cfc59c91 * zpow >> (116 - 64);
209         zpow = zpow * z / int(ONE);
210         result += 0xcc2225a0e12d3eab * zpow >> (121 - 64);
211         zpow = zpow * z / int(ONE);
212         zpow = 0xfb8bb5eda1b4aeb9 * zpow >> (126 - 64);
213         result += zpow;
214         zpow = int(8 * ONE);
215 
216         shift -= 64;
217         if (shift >= 0) {
218             if (result >> (256-shift) == 0) {
219                 lower = uint(result) << shift;
220                 zpow <<= shift; // todo: is this safe?
221                 if (lower + uint(zpow) >= lower)
222                     upper = lower + uint(zpow);
223                 else
224                     upper = 2**256-1;
225                 return (lower, upper);
226             }
227             else
228                 return (2**256-1, 2**256-1);
229         }
230         zpow = (zpow >> (-shift)) + 1;
231         lower = uint(result) >> (-shift);
232         upper = lower + uint(zpow);
233         return (lower, upper);
234     }
235 
236     /// @dev Returns natural logarithm value of given x
237     /// @param x x
238     /// @return ln(x)
239     function ln(uint x)
240         public
241         pure
242         returns (int)
243     {
244         (int lower, int upper) = log2Bounds(x);
245         return ((upper - lower) / 2 + lower) * int(ONE) / int(LOG2_E);
246     }
247 
248     /// @dev Returns estimate of binaryLog(x) given x
249     /// @param x logarithm argument in fixed point
250     /// @param estimationMode whether to return a lower bound, upper bound, or a midpoint
251     /// @return estimate of binaryLog(x) in fixed point
252     function binaryLog(uint x, EstimationMode estimationMode)
253         public
254         pure
255         returns (int)
256     {
257         (int lower, int upper) = log2Bounds(x);
258         if(estimationMode == EstimationMode.LowerBound) {
259             return lower;
260         }
261         if(estimationMode == EstimationMode.UpperBound) {
262             return upper;
263         }
264         if(estimationMode == EstimationMode.Midpoint) {
265             return (upper - lower) / 2 + lower;
266         }
267         revert();
268     }
269 
270     /// @dev Returns bounds for value of binaryLog(x) given x
271     /// @param x logarithm argument in fixed point
272     /// @return {
273     ///   "lower": "lower bound of binaryLog(x) in fixed point",
274     ///   "upper": "upper bound of binaryLog(x) in fixed point"
275     /// }
276     function log2Bounds(uint x)
277         public
278         pure
279         returns (int lower, int upper)
280     {
281         require(x > 0);
282         // compute ⌊log₂x⌋
283         lower = floorLog2(x);
284 
285         uint y;
286         if (lower < 0)
287             y = x << uint(-lower);
288         else
289             y = x >> uint(lower);
290 
291         lower *= int(ONE);
292 
293         // y = x * 2^(-⌊log₂x⌋)
294         // so 1 <= y < 2
295         // and log₂x = ⌊log₂x⌋ + log₂y
296         for (int m = 1; m <= 64; m++) {
297             if(y == ONE) {
298                 break;
299             }
300             y = y * y / ONE;
301             if(y >= 2 * ONE) {
302                 lower += int(ONE >> m);
303                 y /= 2;
304             }
305         }
306 
307         return (lower, lower + 4);
308     }
309 
310     /// @dev Returns base 2 logarithm value of given x
311     /// @param x x
312     /// @return logarithmic value
313     function floorLog2(uint x)
314         public
315         pure
316         returns (int lo)
317     {
318         lo = -64;
319         int hi = 193;
320         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
321         int mid = (hi + lo) >> 1;
322         while((lo + 1) < hi) {
323             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE)
324                 hi = mid;
325             else
326                 lo = mid;
327             mid = (hi + lo) >> 1;
328         }
329     }
330 
331     /// @dev Returns maximum of an array
332     /// @param nums Numbers to look through
333     /// @return Maximum number
334     function max(int[] memory nums)
335         public
336         pure
337         returns (int maxNum)
338     {
339         require(nums.length > 0);
340         maxNum = -2**255;
341         for (uint i = 0; i < nums.length; i++)
342             if (nums[i] > maxNum)
343                 maxNum = nums[i];
344     }
345 }
346 
347 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
348 
349 pragma solidity ^0.5.0;
350 
351 /**
352  * @title ERC20 interface
353  * @dev see https://github.com/ethereum/EIPs/issues/20
354  */
355 interface IERC20 {
356     function transfer(address to, uint256 value) external returns (bool);
357 
358     function approve(address spender, uint256 value) external returns (bool);
359 
360     function transferFrom(address from, address to, uint256 value) external returns (bool);
361 
362     function totalSupply() external view returns (uint256);
363 
364     function balanceOf(address who) external view returns (uint256);
365 
366     function allowance(address owner, address spender) external view returns (uint256);
367 
368     event Transfer(address indexed from, address indexed to, uint256 value);
369 
370     event Approval(address indexed owner, address indexed spender, uint256 value);
371 }
372 
373 // File: openzeppelin-solidity/contracts/utils/Address.sol
374 
375 pragma solidity ^0.5.0;
376 
377 /**
378  * Utility library of inline functions on addresses
379  */
380 library Address {
381     /**
382      * Returns whether the target address is a contract
383      * @dev This function will return false if invoked during the constructor of a contract,
384      * as the code is not actually created until after the constructor finishes.
385      * @param account address of the account to check
386      * @return whether the target address is a contract
387      */
388     function isContract(address account) internal view returns (bool) {
389         uint256 size;
390         // XXX Currently there is no better way to check if there is a contract in an address
391         // than to check the size of the code at that address.
392         // See https://ethereum.stackexchange.com/a/14016/36603
393         // for more details about how this works.
394         // TODO Check this again before the Serenity release, because all addresses will be
395         // contracts then.
396         // solhint-disable-next-line no-inline-assembly
397         assembly { size := extcodesize(account) }
398         return size > 0;
399     }
400 }
401 
402 // File: erc-1155/contracts/IERC1155TokenReceiver.sol
403 
404 pragma solidity ^0.5.0;
405 
406 interface IERC1155TokenReceiver {
407     /**
408         @notice Handle the receipt of a single ERC1155 token type
409         @dev The smart contract calls this function on the recipient
410         after a `safeTransferFrom`. This function MAY throw to revert and reject the
411         transfer. Return of other than the magic value MUST result in the
412         transaction being reverted
413         Note: the contract address is always the message sender
414         @param _operator  The address which called `safeTransferFrom` function
415         @param _from      The address which previously owned the token
416         @param _id        An array containing the ids of the token being transferred
417         @param _value     An array containing the amount of tokens being transferred
418         @param _data      Additional data with no specified format
419         @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
420     */
421     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);
422 
423     /**
424         @notice Handle the receipt of multiple ERC1155 token types
425         @dev The smart contract calls this function on the recipient
426         after a `safeTransferFrom`. This function MAY throw to revert and reject the
427         transfer. Return of other than the magic value MUST result in the
428         transaction being reverted
429         Note: the contract address is always the message sender
430         @param _operator  The address which called `safeTransferFrom` function
431         @param _from      The address which previously owned the token
432         @param _ids       An array containing ids of each token being transferred
433         @param _values    An array containing amounts of each token being transferred
434         @param _data      Additional data with no specified format
435         @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
436     */
437     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);
438 }
439 
440 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
441 
442 pragma solidity ^0.5.0;
443 
444 /**
445  * @title IERC165
446  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
447  */
448 interface IERC165 {
449     /**
450      * @notice Query if a contract implements an interface
451      * @param interfaceId The interface identifier, as specified in ERC-165
452      * @dev Interface identification is specified in ERC-165. This function
453      * uses less than 30,000 gas.
454      */
455     function supportsInterface(bytes4 interfaceId) external view returns (bool);
456 }
457 
458 // File: erc-1155/contracts/IERC1155.sol
459 
460 pragma solidity ^0.5.0;
461 
462 
463 /**
464     @title ERC-1155 Multi Token Standard
465     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
466     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
467  */
468 /*interface*/ contract IERC1155 is IERC165 {
469     /**
470         @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero value transfers as well as minting or burning.
471         Either event from address `0x0` signifies a minting operation.
472         An event to address `0x0` signifies a burning or melting operation.
473         The total value transferred from address 0x0 minus the total value transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
474         This MAY emit a 0 value, from `0x0` to `0x0` with `_operator` assuming the role of the token creator to define a token ID with no initial balance at the time of creation.
475     */
476     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
477     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
478 
479     /**
480         @dev MUST emit when an approval is updated.
481     */
482     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
483 
484     /**
485         @dev MUST emit when the URI is updated for a token ID.
486         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema".
487     */
488     event URI(string _value, uint256 indexed _id);
489 
490     /**
491         @dev MUST emit when the Name is updated for a token ID.
492     */
493     event Name(string _value, uint256 indexed _id);
494 
495     /**
496         @notice Transfers value amount of an _id from the _from address to the _to addresses specified. Each parameter array should be the same length, with each index correlating.
497         @dev MUST emit TransferSingle event on success.
498         Caller must be approved to manage the _from account's tokens (see isApprovedForAll).
499         MUST Throw if `_to` is the zero address.
500         MUST Throw if `_id` is not a valid token ID.
501         MUST Throw on any other error.
502         When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return value is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`.
503         @param _from    Source addresses
504         @param _to      Target addresses
505         @param _id      ID of the token type
506         @param _value   Transfer amount
507         @param _data    Additional data with no specified format, sent in call to `_to`
508     */
509     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
510 
511     /**
512         @notice Send multiple types of Tokens from a 3rd party in one transfer (with safety call).
513         @dev MUST emit TransferBatch event on success.
514         Caller must be approved to manage the _from account's tokens (see isApprovedForAll).
515         MUST Throw if `_to` is the zero address.
516         MUST Throw if any of the `_ids` is not a valid token ID.
517         MUST Throw on any other error.
518         When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return value is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`.
519         @param _from    Source address
520         @param _to      Target address
521         @param _ids     IDs of each token type
522         @param _values  Transfer amounts per token type
523         @param _data    Additional data with no specified format, sent in call to `_to`
524     */
525     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;
526 
527     /**
528         @notice Get the balance of an account's Tokens.
529         @param _owner  The address of the token holder
530         @param _id     ID of the Token
531         @return        The _owner's balance of the Token type requested
532      */
533     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
534 
535     /**
536         @notice Get the balance of multiple account/token pairs
537         @param _owners The addresses of the token holders
538         @param _ids    ID of the Tokens
539         @return        The _owner's balance of the Token types requested
540      */
541     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
542 
543     /**
544         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
545         @dev MUST emit the ApprovalForAll event on success.
546         @param _operator  Address to add to the set of authorized operators
547         @param _approved  True if the operator is approved, false to revoke approval
548     */
549     function setApprovalForAll(address _operator, bool _approved) external;
550 
551     /**
552         @notice Queries the approval status of an operator for a given owner.
553         @param _owner     The owner of the Tokens
554         @param _operator  Address of authorized operator
555         @return           True if the operator is approved, false if not
556     */
557     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
558 }
559 
560 // File: erc-1155/contracts/ERC1155.sol
561 
562 pragma solidity ^0.5.0;
563 
564 
565 
566 
567 
568 // A sample implementation of core ERC1155 function.
569 contract ERC1155 is IERC1155
570 {
571     using SafeMath for uint256;
572     using Address for address;
573 
574     bytes4 constant public ERC1155_RECEIVED       = 0xf23a6e61;
575     bytes4 constant public ERC1155_BATCH_RECEIVED = 0xbc197c81;
576 
577     // id => (owner => balance)
578     mapping (uint256 => mapping(address => uint256)) internal balances;
579 
580     // owner => (operator => approved)
581     mapping (address => mapping(address => bool)) internal operatorApproval;
582 
583 /////////////////////////////////////////// ERC165 //////////////////////////////////////////////
584 
585     /*
586         bytes4(keccak256('supportsInterface(bytes4)'));
587     */
588     bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
589 
590     /*
591         bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
592         bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
593         bytes4(keccak256("balanceOf(address,uint256)")) ^
594         bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
595         bytes4(keccak256("setApprovalForAll(address,bool)")) ^
596         bytes4(keccak256("isApprovedForAll(address,address)"));
597     */
598     bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
599 
600     function supportsInterface(bytes4 _interfaceId)
601     external
602     view
603     returns (bool) {
604          if (_interfaceId == INTERFACE_SIGNATURE_ERC165 ||
605              _interfaceId == INTERFACE_SIGNATURE_ERC1155) {
606             return true;
607          }
608 
609          return false;
610     }
611 
612 /////////////////////////////////////////// ERC1155 //////////////////////////////////////////////
613 
614     /**
615         @notice Transfers value amount of an _id from the _from address to the _to addresses specified. Each parameter array should be the same length, with each index correlating.
616         @dev MUST emit TransferSingle event on success.
617         Caller must be approved to manage the _from account's tokens (see isApprovedForAll).
618         MUST Throw if `_to` is the zero address.
619         MUST Throw if `_id` is not a valid token ID.
620         MUST Throw on any other error.
621         When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return value is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`.
622         @param _from    Source addresses
623         @param _to      Target addresses
624         @param _id      ID of the token type
625         @param _value   Transfer amount
626         @param _data    Additional data with no specified format, sent in call to `_to`
627     */
628     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external {
629 
630         require(_to != address(0), "_to must be non-zero.");
631         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
632 
633         // SafeMath will throw with insuficient funds _from
634         // or if _id is not valid (balance will be 0)
635         balances[_id][_from] = balances[_id][_from].sub(_value);
636         balances[_id][_to]   = _value.add(balances[_id][_to]);
637 
638         emit TransferSingle(msg.sender, _from, _to, _id, _value);
639 
640         if (_to.isContract()) {
641             require(IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _value, _data) == ERC1155_RECEIVED);
642         }
643     }
644 
645     /**
646         @notice Send multiple types of Tokens from a 3rd party in one transfer (with safety call).
647         @dev MUST emit TransferBatch event on success.
648         Caller must be approved to manage the _from account's tokens (see isApprovedForAll).
649         MUST Throw if `_to` is the zero address.
650         MUST Throw if any of the `_ids` is not a valid token ID.
651         MUST Throw on any other error.
652         When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return value is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`.
653         @param _from    Source address
654         @param _to      Target address
655         @param _ids     IDs of each token type
656         @param _values  Transfer amounts per token type
657         @param _data    Additional data with no specified format, sent in call to `_to`
658     */
659     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external {
660 
661         // MUST Throw on errors
662         require(_to != address(0), "_to must be non-zero.");
663         require(_ids.length == _values.length, "_ids and _values array lenght must match.");
664         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
665 
666         for (uint256 i = 0; i < _ids.length; ++i) {
667             uint256 id = _ids[i];
668             uint256 value = _values[i];
669 
670             // SafeMath will throw with insuficient funds _from
671             // or if _id is not valid (balance will be 0)
672             balances[id][_from] = balances[id][_from].sub(value);
673             balances[id][_to]   = value.add(balances[id][_to]);
674         }
675 
676         // MUST emit event
677         emit TransferBatch(msg.sender, _from, _to, _ids, _values);
678 
679         // Now that the balances are updated,
680         // call onERC1155BatchReceived if the destination is a contract
681         if (_to.isContract()) {
682             require(IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _values, _data) == ERC1155_BATCH_RECEIVED);
683         }
684     }
685 
686     /**
687         @notice Get the balance of an account's Tokens.
688         @param _owner  The address of the token holder
689         @param _id     ID of the Token
690         @return        The _owner's balance of the Token type requested
691      */
692     function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
693         // The balance of any account can be calculated from the Transfer events history.
694         // However, since we need to keep the balances to validate transfer request,
695         // there is no extra cost to also privide a querry function.
696         return balances[_id][_owner];
697     }
698 
699 
700     /**
701         @notice Get the balance of multiple account/token pairs
702         @param _owners The addresses of the token holders
703         @param _ids    ID of the Tokens
704         @return        The _owner's balance of the Token types requested
705      */
706     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {
707 
708         require(_owners.length == _ids.length);
709 
710         uint256[] memory balances_ = new uint256[](_owners.length);
711 
712         for (uint256 i = 0; i < _owners.length; ++i) {
713             balances_[i] = balances[_ids[i]][_owners[i]];
714         }
715 
716         return balances_;
717     }
718 
719     /**
720         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
721         @dev MUST emit the ApprovalForAll event on success.
722         @param _operator  Address to add to the set of authorized operators
723         @param _approved  True if the operator is approved, false to revoke approval
724     */
725     function setApprovalForAll(address _operator, bool _approved) external {
726         operatorApproval[msg.sender][_operator] = _approved;
727         emit ApprovalForAll(msg.sender, _operator, _approved);
728     }
729 
730     /**
731         @notice Queries the approval status of an operator for a given owner.
732         @param _owner     The owner of the Tokens
733         @param _operator  Address of authorized operator
734         @return           True if the operator is approved, false if not
735     */
736     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
737         return operatorApproval[_owner][_operator];
738     }
739 }
740 
741 // File: @gnosis.pm/hg-contracts/contracts/OracleConsumer.sol
742 
743 pragma solidity ^0.5.1;
744 
745 
746 interface OracleConsumer {
747     function receiveResult(bytes32 id, bytes calldata result) external;
748 }
749 
750 // File: @gnosis.pm/hg-contracts/contracts/PredictionMarketSystem.sol
751 
752 pragma solidity ^0.5.1;
753 
754 
755 
756 
757 
758 contract PredictionMarketSystem is OracleConsumer, ERC1155 {
759 
760     /// @dev Emitted upon the successful preparation of a condition.
761     /// @param conditionId The condition's ID. This ID may be derived from the other three parameters via ``keccak256(abi.encodePacked(oracle, questionId, outcomeSlotCount))``.
762     /// @param oracle The account assigned to report the result for the prepared condition.
763     /// @param questionId An identifier for the question to be answered by the oracle.
764     /// @param outcomeSlotCount The number of outcome slots which should be used for this condition. Must not exceed 256.
765     event ConditionPreparation(bytes32 indexed conditionId, address indexed oracle, bytes32 indexed questionId, uint outcomeSlotCount);
766 
767     event ConditionResolution(bytes32 indexed conditionId, address indexed oracle, bytes32 indexed questionId, uint outcomeSlotCount, uint[] payoutNumerators);
768 
769     /// @dev Emitted when a position is successfully split.
770     event PositionSplit(address indexed stakeholder, IERC20 collateralToken, bytes32 indexed parentCollectionId, bytes32 indexed conditionId, uint[] partition, uint amount);
771     /// @dev Emitted when positions are successfully merged.
772     event PositionsMerge(address indexed stakeholder, IERC20 collateralToken, bytes32 indexed parentCollectionId, bytes32 indexed conditionId, uint[] partition, uint amount);
773     event PayoutRedemption(address indexed redeemer, IERC20 indexed collateralToken, bytes32 indexed parentCollectionId, uint payout);
774 
775     /// Mapping key is an condition ID. Value represents numerators of the payout vector associated with the condition. This array is initialized with a length equal to the outcome slot count.
776     mapping(bytes32 => uint[]) public payoutNumerators;
777     mapping(bytes32 => uint) public payoutDenominator;
778 
779     /// @dev This function prepares a condition by initializing a payout vector associated with the condition.
780     /// @param oracle The account assigned to report the result for the prepared condition.
781     /// @param questionId An identifier for the question to be answered by the oracle.
782     /// @param outcomeSlotCount The number of outcome slots which should be used for this condition. Must not exceed 256.
783     function prepareCondition(address oracle, bytes32 questionId, uint outcomeSlotCount) external {
784         require(outcomeSlotCount <= 256, "too many outcome slots");
785         bytes32 conditionId = keccak256(abi.encodePacked(oracle, questionId, outcomeSlotCount));
786         require(payoutNumerators[conditionId].length == 0, "condition already prepared");
787         payoutNumerators[conditionId] = new uint[](outcomeSlotCount);
788         emit ConditionPreparation(conditionId, oracle, questionId, outcomeSlotCount);
789     }
790 
791     /// @dev Called by the oracle for reporting results of conditions. Will set the payout vector for the condition with the ID ``keccak256(abi.encodePacked(oracle, questionId, outcomeSlotCount))``, where oracle is the message sender, questionId is one of the parameters of this function, and outcomeSlotCount is derived from result, which is the result of serializing 32-byte EVM words representing payoutNumerators for each outcome slot of the condition.
792     /// @param questionId The question ID the oracle is answering for
793     /// @param result The oracle's answer
794     function receiveResult(bytes32 questionId, bytes calldata result) external {
795         require(result.length > 0, "results empty");
796         require(result.length % 32 == 0, "results not 32-byte aligned");
797         uint outcomeSlotCount = result.length / 32;
798         require(outcomeSlotCount <= 256, "too many outcome slots");
799         bytes32 conditionId = keccak256(abi.encodePacked(msg.sender, questionId, outcomeSlotCount));
800         require(payoutNumerators[conditionId].length == outcomeSlotCount, "number of outcomes mismatch");
801         require(payoutDenominator[conditionId] == 0, "payout denominator already set");
802         for (uint i = 0; i < outcomeSlotCount; i++) {
803             uint payoutNum;
804             // solhint-disable-next-line no-inline-assembly
805             assembly {
806                 payoutNum := calldataload(add(0x64, mul(0x20, i)))
807             }
808             payoutDenominator[conditionId] = payoutDenominator[conditionId].add(payoutNum);
809 
810             require(payoutNumerators[conditionId][i] == 0, "payout numerator already set");
811             payoutNumerators[conditionId][i] = payoutNum;
812         }
813         require(payoutDenominator[conditionId] > 0, "payout is all zeroes");
814         emit ConditionResolution(conditionId, msg.sender, questionId, outcomeSlotCount, payoutNumerators[conditionId]);
815     }
816 
817     /// @dev This function splits a position. If splitting from the collateral, this contract will attempt to transfer `amount` collateral from the message sender to itself. Otherwise, this contract will burn `amount` stake held by the message sender in the position being split. Regardless, if successful, `amount` stake will be minted in the split target positions. If any of the transfers, mints, or burns fail, the transaction will revert. The transaction will also revert if the given partition is trivial, invalid, or refers to more slots than the condition is prepared with.
818     /// @param collateralToken The address of the positions' backing collateral token.
819     /// @param parentCollectionId The ID of the outcome collections common to the position being split and the split target positions. May be null, in which only the collateral is shared.
820     /// @param conditionId The ID of the condition to split on.
821     /// @param partition An array of disjoint index sets representing a nontrivial partition of the outcome slots of the given condition.
822     /// @param amount The amount of collateral or stake to split.
823     function splitPosition(IERC20 collateralToken, bytes32 parentCollectionId, bytes32 conditionId, uint[] calldata partition, uint amount) external {
824         uint outcomeSlotCount = payoutNumerators[conditionId].length;
825         require(outcomeSlotCount > 0, "condition not prepared yet");
826 
827         bytes32 key;
828 
829         uint fullIndexSet = (1 << outcomeSlotCount) - 1;
830         uint freeIndexSet = fullIndexSet;
831         for (uint i = 0; i < partition.length; i++) {
832             uint indexSet = partition[i];
833             require(indexSet > 0 && indexSet < fullIndexSet, "got invalid index set");
834             require((indexSet & freeIndexSet) == indexSet, "partition not disjoint");
835             freeIndexSet ^= indexSet;
836             key = keccak256(abi.encodePacked(collateralToken, getCollectionId(parentCollectionId, conditionId, indexSet)));
837             balances[uint(key)][msg.sender] = balances[uint(key)][msg.sender].add(amount);
838         }
839 
840         if (freeIndexSet == 0) {
841             if (parentCollectionId == bytes32(0)) {
842                 require(collateralToken.transferFrom(msg.sender, address(this), amount), "could not receive collateral tokens");
843             } else {
844                 key = keccak256(abi.encodePacked(collateralToken, parentCollectionId));
845                 balances[uint(key)][msg.sender] = balances[uint(key)][msg.sender].sub(amount);
846             }
847         } else {
848             key = keccak256(abi.encodePacked(collateralToken, getCollectionId(parentCollectionId, conditionId, fullIndexSet ^ freeIndexSet)));
849             balances[uint(key)][msg.sender] = balances[uint(key)][msg.sender].sub(amount);
850         }
851 
852         emit PositionSplit(msg.sender, collateralToken, parentCollectionId, conditionId, partition, amount);
853     }
854 
855     function mergePositions(IERC20 collateralToken, bytes32 parentCollectionId, bytes32 conditionId, uint[] calldata partition, uint amount) external {
856         uint outcomeSlotCount = payoutNumerators[conditionId].length;
857         require(outcomeSlotCount > 0, "condition not prepared yet");
858 
859         bytes32 key;
860 
861         uint fullIndexSet = (1 << outcomeSlotCount) - 1;
862         uint freeIndexSet = fullIndexSet;
863         for (uint i = 0; i < partition.length; i++) {
864             uint indexSet = partition[i];
865             require(indexSet > 0 && indexSet < fullIndexSet, "got invalid index set");
866             require((indexSet & freeIndexSet) == indexSet, "partition not disjoint");
867             freeIndexSet ^= indexSet;
868             key = keccak256(abi.encodePacked(collateralToken, getCollectionId(parentCollectionId, conditionId, indexSet)));
869             balances[uint(key)][msg.sender] = balances[uint(key)][msg.sender].sub(amount);
870         }
871 
872         if (freeIndexSet == 0) {
873             if (parentCollectionId == bytes32(0)) {
874                 require(collateralToken.transfer(msg.sender, amount), "could not send collateral tokens");
875             } else {
876                 key = keccak256(abi.encodePacked(collateralToken, parentCollectionId));
877                 balances[uint(key)][msg.sender] = balances[uint(key)][msg.sender].add(amount);
878             }
879         } else {
880             key = keccak256(abi.encodePacked(collateralToken, getCollectionId(parentCollectionId, conditionId, fullIndexSet ^ freeIndexSet)));
881             balances[uint(key)][msg.sender] = balances[uint(key)][msg.sender].add(amount);
882         }
883 
884         emit PositionsMerge(msg.sender, collateralToken, parentCollectionId, conditionId, partition, amount);
885     }
886 
887     function redeemPositions(IERC20 collateralToken, bytes32 parentCollectionId, bytes32 conditionId, uint[] calldata indexSets) external {
888         require(payoutDenominator[conditionId] > 0, "result for condition not received yet");
889         uint outcomeSlotCount = payoutNumerators[conditionId].length;
890         require(outcomeSlotCount > 0, "condition not prepared yet");
891 
892         uint totalPayout = 0;
893         bytes32 key;
894 
895         uint fullIndexSet = (1 << outcomeSlotCount) - 1;
896         for (uint i = 0; i < indexSets.length; i++) {
897             uint indexSet = indexSets[i];
898             require(indexSet > 0 && indexSet < fullIndexSet, "got invalid index set");
899             key = keccak256(abi.encodePacked(collateralToken, getCollectionId(parentCollectionId, conditionId, indexSet)));
900 
901             uint payoutNumerator = 0;
902             for (uint j = 0; j < outcomeSlotCount; j++) {
903                 if (indexSet & (1 << j) != 0) {
904                     payoutNumerator = payoutNumerator.add(payoutNumerators[conditionId][j]);
905                 }
906             }
907 
908             uint payoutStake = balances[uint(key)][msg.sender];
909             if (payoutStake > 0) {
910                 totalPayout = totalPayout.add(payoutStake.mul(payoutNumerator).div(payoutDenominator[conditionId]));
911                 balances[uint(key)][msg.sender] = 0;
912             }
913         }
914 
915         if (totalPayout > 0) {
916             if (parentCollectionId == bytes32(0)) {
917                 require(collateralToken.transfer(msg.sender, totalPayout), "could not transfer payout to message sender");
918             } else {
919                 key = keccak256(abi.encodePacked(collateralToken, parentCollectionId));
920                 balances[uint(key)][msg.sender] = balances[uint(key)][msg.sender].add(totalPayout);
921             }
922         }
923         emit PayoutRedemption(msg.sender, collateralToken, parentCollectionId, totalPayout);
924     }
925 
926     /// @dev Gets the outcome slot count of a condition.
927     /// @param conditionId ID of the condition.
928     /// @return Number of outcome slots associated with a condition, or zero if condition has not been prepared yet.
929     function getOutcomeSlotCount(bytes32 conditionId) external view returns (uint) {
930         return payoutNumerators[conditionId].length;
931     }
932 
933     function getCollectionId(bytes32 parentCollectionId, bytes32 conditionId, uint indexSet) private pure returns (bytes32) {
934         return bytes32(
935             uint(parentCollectionId) +
936             uint(keccak256(abi.encodePacked(conditionId, indexSet)))
937         );
938     }
939 }
940 
941 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
942 
943 pragma solidity ^0.5.0;
944 
945 /**
946  * @title Ownable
947  * @dev The Ownable contract has an owner address, and provides basic authorization control
948  * functions, this simplifies the implementation of "user permissions".
949  */
950 contract Ownable {
951     address private _owner;
952 
953     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
954 
955     /**
956      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
957      * account.
958      */
959     constructor () internal {
960         _owner = msg.sender;
961         emit OwnershipTransferred(address(0), _owner);
962     }
963 
964     /**
965      * @return the address of the owner.
966      */
967     function owner() public view returns (address) {
968         return _owner;
969     }
970 
971     /**
972      * @dev Throws if called by any account other than the owner.
973      */
974     modifier onlyOwner() {
975         require(isOwner());
976         _;
977     }
978 
979     /**
980      * @return true if `msg.sender` is the owner of the contract.
981      */
982     function isOwner() public view returns (bool) {
983         return msg.sender == _owner;
984     }
985 
986     /**
987      * @dev Allows the current owner to relinquish control of the contract.
988      * @notice Renouncing to ownership will leave the contract without an owner.
989      * It will not be possible to call the functions with the `onlyOwner`
990      * modifier anymore.
991      */
992     function renounceOwnership() public onlyOwner {
993         emit OwnershipTransferred(_owner, address(0));
994         _owner = address(0);
995     }
996 
997     /**
998      * @dev Allows the current owner to transfer control of the contract to a newOwner.
999      * @param newOwner The address to transfer ownership to.
1000      */
1001     function transferOwnership(address newOwner) public onlyOwner {
1002         _transferOwnership(newOwner);
1003     }
1004 
1005     /**
1006      * @dev Transfers control of the contract to a newOwner.
1007      * @param newOwner The address to transfer ownership to.
1008      */
1009     function _transferOwnership(address newOwner) internal {
1010         require(newOwner != address(0));
1011         emit OwnershipTransferred(_owner, newOwner);
1012         _owner = newOwner;
1013     }
1014 }
1015 
1016 // File: @gnosis.pm/util-contracts/contracts/SignedSafeMath.sol
1017 
1018 pragma solidity >=0.4.24 ^0.5.1;
1019 
1020 
1021 /**
1022  * @title SignedSafeMath
1023  * @dev Math operations with safety checks that throw on error
1024  */
1025 library SignedSafeMath {
1026   int256 constant INT256_MIN = int256((uint256(1) << 255));
1027 
1028   /**
1029   * @dev Multiplies two signed integers, throws on overflow.
1030   */
1031   function mul(int256 a, int256 b) internal pure returns (int256 c) {
1032     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1033     // benefit is lost if 'b' is also tested.
1034     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1035     if (a == 0) {
1036       return 0;
1037     }
1038     c = a * b;
1039     assert((a != -1 || b != INT256_MIN) && c / a == b);
1040   }
1041 
1042   /**
1043   * @dev Integer division of two signed integers, truncating the quotient.
1044   */
1045   function div(int256 a, int256 b) internal pure returns (int256) {
1046     // assert(b != 0); // Solidity automatically throws when dividing by 0
1047     // Overflow only happens when the smallest negative int is multiplied by -1.
1048     assert(a != INT256_MIN || b != -1);
1049     return a / b;
1050   }
1051 
1052   /**
1053   * @dev Subtracts two signed integers, throws on overflow.
1054   */
1055   function sub(int256 a, int256 b) internal pure returns (int256 c) {
1056     c = a - b;
1057     assert((b >= 0 && c <= a) || (b < 0 && c > a));
1058   }
1059 
1060   /**
1061   * @dev Adds two signed integers, throws on overflow.
1062   */
1063   function add(int256 a, int256 b) internal pure returns (int256 c) {
1064     c = a + b;
1065     assert((b >= 0 && c >= a) || (b < 0 && c < a));
1066   }
1067 }
1068 
1069 // File: @gnosis.pm/hg-market-makers/contracts/MarketMaker.sol
1070 
1071 pragma solidity ^0.5.1;
1072 
1073 
1074 
1075 
1076 
1077 
1078 contract MarketMaker is Ownable, IERC1155TokenReceiver {
1079     using SignedSafeMath for int;
1080     using SafeMath for uint;
1081     /*
1082      *  Constants
1083      */    
1084     uint64 public constant FEE_RANGE = 10**18;
1085 
1086     /*
1087      *  Events
1088      */
1089     event AMMCreated(uint initialFunding);
1090     event AMMPaused();
1091     event AMMResumed();
1092     event AMMClosed();
1093     event AMMFundingChanged(int fundingChange);
1094     event AMMFeeChanged(uint64 newFee);
1095     event AMMFeeWithdrawal(uint fees);
1096     event AMMOutcomeTokenTrade(address indexed transactor, int[] outcomeTokenAmounts, int outcomeTokenNetCost, uint marketFees);
1097     
1098     /*
1099      *  Storage
1100      */
1101     PredictionMarketSystem public pmSystem;
1102     IERC20 public collateralToken;
1103     bytes32[] public conditionIds;
1104     uint public atomicOutcomeSlotCount;
1105     uint64 public fee;
1106     uint public funding;
1107     Stage public stage;
1108     enum Stage {
1109         Running,
1110         Paused,
1111         Closed
1112     }
1113 
1114     /*
1115      *  Modifiers
1116      */
1117     modifier atStage(Stage _stage) {
1118         // Contract has to be in given stage
1119         require(stage == _stage);
1120         _;
1121     }
1122 
1123     constructor(PredictionMarketSystem _pmSystem, IERC20 _collateralToken, bytes32[] memory _conditionIds, uint64 _fee, uint initialFunding, address marketOwner)
1124         public
1125     {
1126         // Validate inputs
1127         require(address(_pmSystem) != address(0) && _fee < FEE_RANGE);
1128         pmSystem = _pmSystem;
1129         collateralToken = _collateralToken;
1130         conditionIds = _conditionIds;
1131         fee = _fee;
1132 
1133         atomicOutcomeSlotCount = 1;
1134         for (uint i = 0; i < conditionIds.length; i++) {
1135             atomicOutcomeSlotCount *= pmSystem.getOutcomeSlotCount(conditionIds[i]);
1136         }
1137         require(atomicOutcomeSlotCount > 1, "conditions must be valid");
1138 
1139         require(collateralToken.transferFrom(marketOwner, address(this), initialFunding) && collateralToken.approve(address(pmSystem), initialFunding));
1140 
1141         splitPositionThroughAllConditions(initialFunding, conditionIds.length, 0);
1142 
1143         funding = initialFunding;
1144 
1145         stage = Stage.Running;
1146         emit AMMCreated(funding);
1147     }
1148 
1149     function calcNetCost(int[] memory outcomeTokenAmounts) public view returns (int netCost);
1150 
1151     /// @dev Allows to fund the market with collateral tokens converting them into outcome tokens
1152     /// Note for the future: should combine splitPosition and mergePositions into one function, as code duplication causes things like this to happen.
1153     function changeFunding(int fundingChange)
1154         public
1155         onlyOwner
1156         atStage(Stage.Paused)
1157     {
1158         require(fundingChange != 0, "A fundingChange of zero is not a fundingChange at all. It is unacceptable.");
1159         // Either add or subtract funding based off whether the fundingChange parameter is negative or positive
1160         if (fundingChange > 0) {
1161             require(collateralToken.transferFrom(msg.sender, address(this), uint(fundingChange)) && collateralToken.approve(address(pmSystem), uint(fundingChange)));
1162             splitPositionThroughAllConditions(uint(fundingChange), conditionIds.length, 0);
1163             funding = funding.add(uint(fundingChange));
1164             emit AMMFundingChanged(fundingChange);
1165         }
1166         if (fundingChange < 0) {
1167             mergePositionsThroughAllConditions(uint(-fundingChange), conditionIds.length, 0);
1168             funding = funding.sub(uint(-fundingChange));
1169             require(collateralToken.transfer(owner(), uint(-fundingChange)));
1170             emit AMMFundingChanged(fundingChange);
1171         }
1172     }
1173 
1174     function pause() public onlyOwner atStage(Stage.Running) {
1175         stage = Stage.Paused;
1176         emit AMMPaused();
1177     }
1178     
1179     function resume() public onlyOwner atStage(Stage.Paused) {
1180         stage = Stage.Running;
1181         emit AMMResumed();
1182     }
1183 
1184     function changeFee(uint64 _fee) public onlyOwner atStage(Stage.Paused) {
1185         fee = _fee;
1186         emit AMMFeeChanged(fee);
1187     }
1188 
1189     /// @dev Allows market owner to close the markets by transferring all remaining outcome tokens to the owner
1190     function close()
1191         public
1192         onlyOwner
1193     {
1194         require(stage == Stage.Running || stage == Stage.Paused, "This Market has already been closed");
1195         for (uint i = 0; i < atomicOutcomeSlotCount; i++) {
1196             uint positionId = generateAtomicPositionId(i);
1197             pmSystem.safeTransferFrom(address(this), owner(), positionId, pmSystem.balanceOf(address(this), positionId), "");
1198         }
1199         stage = Stage.Closed;
1200         emit AMMClosed();
1201     }
1202 
1203     /// @dev Allows market owner to withdraw fees generated by trades
1204     /// @return Fee amount
1205     function withdrawFees()
1206         public
1207         onlyOwner
1208         returns (uint fees)
1209     {
1210         fees = collateralToken.balanceOf(address(this));
1211         // Transfer fees
1212         require(collateralToken.transfer(owner(), fees));
1213         emit AMMFeeWithdrawal(fees);
1214     }
1215 
1216     /// @dev Allows to trade outcome tokens and collateral with the market maker
1217     /// @param outcomeTokenAmounts Amounts of each atomic outcome token to buy or sell. If positive, will buy this amount of outcome token from the market. If negative, will sell this amount back to the market instead. The indices of this array range from 0 to product(all conditions' outcomeSlotCounts)-1. For example, with two conditions with three outcome slots each and one condition with two outcome slots, you will have 3*3*2=18 total atomic outcome tokens, and the indices will range from 0 to 17. The indices map to atomic outcome slots depending on the order of the conditionIds. Let's say the first condition has slots A, B, C the second has slots X, Y, and the third has slots I, J, K. We can associate each atomic outcome token with indices by this map:
1218     /// A&X&I == 0
1219     /// B&X&I == 1
1220     /// C&X&I == 2
1221     /// A&Y&I == 3
1222     /// B&Y&I == 4
1223     /// C&Y&I == 5
1224     /// A&X&J == 6
1225     /// B&X&J == 7
1226     /// C&X&J == 8
1227     /// A&Y&J == 9
1228     /// B&Y&J == 10
1229     /// C&Y&J == 11
1230     /// A&X&K == 12
1231     /// B&X&K == 13
1232     /// C&X&K == 14
1233     /// A&Y&K == 15
1234     /// B&Y&K == 16
1235     /// C&Y&K == 17
1236     /// This order is calculated via the generateAtomicPositionId function below: C&Y&I -> (2, 1, 0) -> 2 + 3 * (1 + 2 * (0 + 3 * (0 + 0)))
1237     /// @param collateralLimit If positive, this is the limit for the amount of collateral tokens which will be sent to the market to conduct the trade. If negative, this is the minimum amount of collateral tokens which will be received from the market for the trade. If zero, there is no limit.
1238     /// @return If positive, the amount of collateral sent to the market. If negative, the amount of collateral received from the market. If zero, no collateral was sent or received.
1239     function trade(int[] memory outcomeTokenAmounts, int collateralLimit)
1240         public
1241         atStage(Stage.Running)
1242         returns (int netCost)
1243     {
1244         require(outcomeTokenAmounts.length == atomicOutcomeSlotCount);
1245 
1246         // Calculate net cost for executing trade
1247         int outcomeTokenNetCost = calcNetCost(outcomeTokenAmounts);
1248         int fees;
1249         if(outcomeTokenNetCost < 0)
1250             fees = int(calcMarketFee(uint(-outcomeTokenNetCost)));
1251         else
1252             fees = int(calcMarketFee(uint(outcomeTokenNetCost)));
1253 
1254         require(fees >= 0);
1255         netCost = outcomeTokenNetCost.add(fees);
1256 
1257         require(
1258             (collateralLimit != 0 && netCost <= collateralLimit) ||
1259             collateralLimit == 0
1260         );
1261 
1262         if(outcomeTokenNetCost > 0) {
1263             require(
1264                 collateralToken.transferFrom(msg.sender, address(this), uint(netCost)) &&
1265                 collateralToken.approve(address(pmSystem), uint(outcomeTokenNetCost))
1266             );
1267 
1268             splitPositionThroughAllConditions(uint(outcomeTokenNetCost), conditionIds.length, 0);
1269         }
1270 
1271         for (uint i = 0; i < atomicOutcomeSlotCount; i++) {
1272             if(outcomeTokenAmounts[i] != 0) {
1273                 uint positionId = generateAtomicPositionId(i);
1274                 if(outcomeTokenAmounts[i] < 0) {
1275                     pmSystem.safeTransferFrom(msg.sender, address(this), positionId, uint(-outcomeTokenAmounts[i]), "");
1276                 } else {
1277                     pmSystem.safeTransferFrom(address(this), msg.sender, positionId, uint(outcomeTokenAmounts[i]), "");
1278                 }
1279 
1280             }
1281         }
1282 
1283         if(outcomeTokenNetCost < 0) {
1284             // This is safe since
1285             // 0x8000000000000000000000000000000000000000000000000000000000000000 ==
1286             // uint(-int(-0x8000000000000000000000000000000000000000000000000000000000000000))
1287             mergePositionsThroughAllConditions(uint(-outcomeTokenNetCost), conditionIds.length, 0);
1288             if(netCost < 0) {
1289                 require(collateralToken.transfer(msg.sender, uint(-netCost)));
1290             }
1291         }
1292 
1293         emit AMMOutcomeTokenTrade(msg.sender, outcomeTokenAmounts, outcomeTokenNetCost, uint(fees));
1294     }
1295 
1296     /// @dev Calculates fee to be paid to market maker
1297     /// @param outcomeTokenCost Cost for buying outcome tokens
1298     /// @return Fee for trade
1299     function calcMarketFee(uint outcomeTokenCost)
1300         public
1301         view
1302         returns (uint)
1303     {
1304         return outcomeTokenCost * fee / FEE_RANGE;
1305     }
1306 
1307     function onERC1155Received(address operator, address /*from*/, uint256 /*id*/, uint256 /*value*/, bytes calldata /*data*/) external returns(bytes4) {
1308         if (operator == address(this)) {
1309             return 0xf23a6e61;
1310         }
1311         return 0x0;
1312     }
1313 
1314     function onERC1155BatchReceived(address _operator, address /*from*/, uint256[] calldata /*ids*/, uint256[] calldata /*values*/, bytes calldata /*data*/) external returns(bytes4) {
1315         if (_operator == address(this)) {
1316             return 0xf23a6e61;
1317         }
1318         return 0x0;
1319     }
1320 
1321     function generateBasicPartition(bytes32 conditionId)
1322         private
1323         view
1324         returns (uint[] memory partition)
1325     {
1326         partition = new uint[](pmSystem.getOutcomeSlotCount(conditionId));
1327         for(uint i = 0; i < partition.length; i++) {
1328             partition[i] = 1 << i;
1329         }
1330     }
1331 
1332     function generateAtomicPositionId(uint i)
1333         internal
1334         view
1335         returns (uint)
1336     {
1337         uint collectionId = 0;
1338 
1339         for(uint k = 0; k < conditionIds.length; k++) {
1340             uint curOutcomeSlotCount = pmSystem.getOutcomeSlotCount(conditionIds[k]);
1341             collectionId += uint(keccak256(abi.encodePacked(
1342                 conditionIds[k],
1343                 1 << (i % curOutcomeSlotCount))));
1344             i /= curOutcomeSlotCount;
1345         }
1346         return uint(keccak256(abi.encodePacked(
1347             collateralToken,
1348             collectionId)));
1349     }
1350 
1351     function splitPositionThroughAllConditions(uint amount, uint conditionsLeft, uint parentCollectionId)
1352         private
1353     {
1354         if(conditionsLeft == 0) return;
1355         conditionsLeft--;
1356 
1357         uint[] memory partition = generateBasicPartition(conditionIds[conditionsLeft]);
1358         pmSystem.splitPosition(collateralToken, bytes32(parentCollectionId), conditionIds[conditionsLeft], partition, amount);
1359         for(uint i = 0; i < partition.length; i++) {
1360             splitPositionThroughAllConditions(
1361                 amount,
1362                 conditionsLeft,
1363                 parentCollectionId + uint(keccak256(abi.encodePacked(
1364                     conditionIds[conditionsLeft],
1365                     partition[i]))));
1366         }
1367     }
1368 
1369     function mergePositionsThroughAllConditions(uint amount, uint conditionsLeft, uint parentCollectionId)
1370         private
1371     {
1372         if(conditionsLeft == 0) return;
1373         conditionsLeft--;
1374 
1375         uint[] memory partition = generateBasicPartition(conditionIds[conditionsLeft]);
1376         for(uint i = 0; i < partition.length; i++) {
1377             mergePositionsThroughAllConditions(
1378                 amount,
1379                 conditionsLeft,
1380                 parentCollectionId + uint(keccak256(abi.encodePacked(
1381                     conditionIds[conditionsLeft],
1382                     partition[i]))));
1383         }
1384         pmSystem.mergePositions(collateralToken, bytes32(parentCollectionId), conditionIds[conditionsLeft], partition, amount);
1385     }
1386 }
1387 
1388 // File: @gnosis.pm/hg-market-makers/contracts/LMSRMarketMaker.sol
1389 
1390 pragma solidity ^0.5.1;
1391 
1392 
1393 
1394 
1395 
1396 /// @title LMSR market maker contract - Calculates share prices based on share distribution and initial funding
1397 /// @author Alan Lu - <alan.lu@gnosis.pm>
1398 contract LMSRMarketMaker is MarketMaker {
1399     using SafeMath for uint;
1400 
1401     /*
1402      *  Constants
1403      */
1404     uint constant ONE = 0x10000000000000000;
1405     int constant EXP_LIMIT = 3394200909562557497344;
1406 
1407     constructor(PredictionMarketSystem _pmSystem, IERC20 _collateralToken, bytes32[] memory _conditionIds, uint64 _fee, uint _funding, address marketOwner)
1408         public
1409         MarketMaker(_pmSystem, _collateralToken, _conditionIds, _fee, _funding, marketOwner) {}
1410 
1411 
1412     /// @dev Calculates the net cost for executing a given trade.
1413     /// @param outcomeTokenAmounts Amounts of outcome tokens to buy from the market. If an amount is negative, represents an amount to sell to the market.
1414     /// @return Net cost of trade. If positive, represents amount of collateral which would be paid to the market for the trade. If negative, represents amount of collateral which would be received from the market for the trade.
1415     function calcNetCost(int[] memory outcomeTokenAmounts)
1416         public
1417         view
1418         returns (int netCost)
1419     {
1420         require(outcomeTokenAmounts.length == atomicOutcomeSlotCount);
1421 
1422         int[] memory otExpNums = new int[](atomicOutcomeSlotCount);
1423         for (uint i = 0; i < atomicOutcomeSlotCount; i++) {
1424             int balance = int(pmSystem.balanceOf(address(this), generateAtomicPositionId(i)));
1425             require(balance >= 0);
1426             otExpNums[i] = outcomeTokenAmounts[i].sub(balance);
1427         }
1428 
1429         int log2N = Fixed192x64Math.binaryLog(atomicOutcomeSlotCount * ONE, Fixed192x64Math.EstimationMode.UpperBound);
1430 
1431         (uint sum, int offset, ) = sumExpOffset(log2N, otExpNums, 0, Fixed192x64Math.EstimationMode.UpperBound);
1432         netCost = Fixed192x64Math.binaryLog(sum, Fixed192x64Math.EstimationMode.UpperBound);
1433         netCost = netCost.add(offset);
1434         netCost = (netCost.mul(int(ONE)) / log2N).mul(int(funding));
1435 
1436         // Integer division for negative numbers already uses ceiling,
1437         // so only check boundary condition for positive numbers
1438         if(netCost <= 0 || netCost / int(ONE) * int(ONE) == netCost) {
1439             netCost /= int(ONE);
1440         } else {
1441             netCost = netCost / int(ONE) + 1;
1442         }
1443     }
1444 
1445     /// @dev Returns marginal price of an outcome
1446     /// @param outcomeTokenIndex Index of outcome to determine marginal price of
1447     /// @return Marginal price of an outcome as a fixed point number
1448     function calcMarginalPrice(uint8 outcomeTokenIndex)
1449         public
1450         view
1451         returns (uint price)
1452     {
1453         int[] memory negOutcomeTokenBalances = new int[](atomicOutcomeSlotCount);
1454         for (uint i = 0; i < atomicOutcomeSlotCount; i++) {
1455             int negBalance = -int(pmSystem.balanceOf(address(this), generateAtomicPositionId(i)));
1456             require(negBalance <= 0);
1457             negOutcomeTokenBalances[i] = negBalance;
1458         }
1459 
1460         int log2N = Fixed192x64Math.binaryLog(negOutcomeTokenBalances.length * ONE, Fixed192x64Math.EstimationMode.Midpoint);
1461         // The price function is exp(quantities[i]/b) / sum(exp(q/b) for q in quantities)
1462         // To avoid overflow, calculate with
1463         // exp(quantities[i]/b - offset) / sum(exp(q/b - offset) for q in quantities)
1464         (uint sum, , uint outcomeExpTerm) = sumExpOffset(log2N, negOutcomeTokenBalances, outcomeTokenIndex, Fixed192x64Math.EstimationMode.Midpoint);
1465         return outcomeExpTerm / (sum / ONE);
1466     }
1467 
1468     /*
1469      *  Private functions
1470      */
1471     /// @dev Calculates sum(exp(q/b - offset) for q in quantities), where offset is set
1472     ///      so that the sum fits in 248-256 bits
1473     /// @param log2N Binary logarithm of the number of outcomes
1474     /// @param otExpNums Numerators of the exponents, denoted as q in the aforementioned formula
1475     /// @param outcomeIndex Index of exponential term to extract (for use by marginal price function)
1476     /// @return A result structure composed of the sum, the offset used, and the summand associated with the supplied index
1477     function sumExpOffset(int log2N, int[] memory otExpNums, uint8 outcomeIndex, Fixed192x64Math.EstimationMode estimationMode)
1478         private
1479         view
1480         returns (uint sum, int offset, uint outcomeExpTerm)
1481     {
1482         // Naive calculation of this causes an overflow
1483         // since anything above a bit over 133*ONE supplied to exp will explode
1484         // as exp(133) just about fits into 192 bits of whole number data.
1485 
1486         // The choice of this offset is subject to another limit:
1487         // computing the inner sum successfully.
1488         // Since the index is 8 bits, there has to be 8 bits of headroom for
1489         // each summand, meaning q/b - offset <= exponential_limit,
1490         // where that limit can be found with `mp.floor(mp.log((2**248 - 1) / ONE) * ONE)`
1491         // That is what EXP_LIMIT is set to: it is about 127.5
1492 
1493         // finally, if the distribution looks like [BIG, tiny, tiny...], using a
1494         // BIG offset will cause the tiny quantities to go really negative
1495         // causing the associated exponentials to vanish.
1496 
1497         require(log2N >= 0 && int(funding) >= 0);
1498         offset = Fixed192x64Math.max(otExpNums);
1499         offset = offset.mul(log2N) / int(funding);
1500         offset = offset.sub(EXP_LIMIT);
1501         uint term;
1502         for (uint8 i = 0; i < otExpNums.length; i++) {
1503             term = Fixed192x64Math.pow2((otExpNums[i].mul(log2N) / int(funding)).sub(offset), estimationMode);
1504             if (i == outcomeIndex)
1505                 outcomeExpTerm = term;
1506             sum = sum.add(term);
1507         }
1508     }
1509 }
1510 
1511 // File: @gnosis.pm/hg-market-makers/contracts/LMSRMarketMakerFactory.sol
1512 
1513 pragma solidity ^0.5.1;
1514 
1515 
1516 contract LMSRMarketMakerFactory {
1517     event LMSRMarketMakerCreation(address indexed creator, LMSRMarketMaker lmsrMarketMaker, PredictionMarketSystem pmSystem, IERC20 collateralToken, bytes32[] conditionIds, uint64 fee, uint funding);
1518 
1519     function createLMSRMarketMaker(PredictionMarketSystem pmSystem, IERC20 collateralToken, bytes32[] memory conditionIds, uint64 fee, uint funding)
1520         public
1521         returns (LMSRMarketMaker lmsrMarketMaker)
1522     {
1523         lmsrMarketMaker = new LMSRMarketMaker(pmSystem, collateralToken, conditionIds, fee, funding, msg.sender);
1524         lmsrMarketMaker.transferOwnership(msg.sender);
1525         emit LMSRMarketMakerCreation(msg.sender, lmsrMarketMaker, pmSystem, collateralToken, conditionIds, fee, funding);
1526     }
1527 }