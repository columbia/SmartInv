1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20 interface
35  * @dev see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20 {
38   function totalSupply() constant public returns (uint);
39 
40   function balanceOf(address who) constant public returns (uint256);
41 
42   function transfer(address to, uint256 value) public returns (bool);
43 
44   function allowance(address owner, address spender) public constant returns (uint256);
45 
46   function transferFrom(address from, address to, uint256 value) public returns (bool);
47 
48   function approve(address spender, uint256 value) public returns (bool);
49 
50   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 
52   event Transfer(address indexed _from, address indexed _to, uint256 _value);
53 }
54 
55 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
56 ///  later changed
57 contract Owned {
58 
59     /// @dev `owner` is the only address that can call a function with this
60     /// modifier
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     address public owner;
67 
68     /// @notice The Constructor assigns the message sender to be `owner`
69     function Owned() public {owner = msg.sender;}
70 
71     /// @notice `owner` can step down and assign some other address to this role
72     /// @param _newOwner The address of the new owner. 0x0 can be used to create
73     ///  an unowned neutral vault, however that cannot be undone
74     function changeOwner(address _newOwner) public onlyOwner {
75         owner = _newOwner;
76     }
77 }
78 
79 contract Callable is Owned {
80 
81     //sender => _allowed
82     mapping(address => bool) public callers;
83 
84     //modifiers
85     modifier onlyCaller {
86         require(callers[msg.sender]);
87         _;
88     }
89 
90     //management of the repositories
91     function updateCaller(address _caller, bool allowed) public onlyOwner {
92         callers[_caller] = allowed;
93     }
94 }
95 
96 contract EternalStorage is Callable {
97 
98     mapping(bytes32 => uint) uIntStorage;
99     mapping(bytes32 => string) stringStorage;
100     mapping(bytes32 => address) addressStorage;
101     mapping(bytes32 => bytes) bytesStorage;
102     mapping(bytes32 => bool) boolStorage;
103     mapping(bytes32 => int) intStorage;
104 
105     // *** Getter Methods ***
106     function getUint(bytes32 _key) external view returns (uint) {
107         return uIntStorage[_key];
108     }
109 
110     function getString(bytes32 _key) external view returns (string) {
111         return stringStorage[_key];
112     }
113 
114     function getAddress(bytes32 _key) external view returns (address) {
115         return addressStorage[_key];
116     }
117 
118     function getBytes(bytes32 _key) external view returns (bytes) {
119         return bytesStorage[_key];
120     }
121 
122     function getBool(bytes32 _key) external view returns (bool) {
123         return boolStorage[_key];
124     }
125 
126     function getInt(bytes32 _key) external view returns (int) {
127         return intStorage[_key];
128     }
129 
130     // *** Setter Methods ***
131     function setUint(bytes32 _key, uint _value) onlyCaller external {
132         uIntStorage[_key] = _value;
133     }
134 
135     function setString(bytes32 _key, string _value) onlyCaller external {
136         stringStorage[_key] = _value;
137     }
138 
139     function setAddress(bytes32 _key, address _value) onlyCaller external {
140         addressStorage[_key] = _value;
141     }
142 
143     function setBytes(bytes32 _key, bytes _value) onlyCaller external {
144         bytesStorage[_key] = _value;
145     }
146 
147     function setBool(bytes32 _key, bool _value) onlyCaller external {
148         boolStorage[_key] = _value;
149     }
150 
151     function setInt(bytes32 _key, int _value) onlyCaller external {
152         intStorage[_key] = _value;
153     }
154 
155     // *** Delete Methods ***
156     function deleteUint(bytes32 _key) onlyCaller external {
157         delete uIntStorage[_key];
158     }
159 
160     function deleteString(bytes32 _key) onlyCaller external {
161         delete stringStorage[_key];
162     }
163 
164     function deleteAddress(bytes32 _key) onlyCaller external {
165         delete addressStorage[_key];
166     }
167 
168     function deleteBytes(bytes32 _key) onlyCaller external {
169         delete bytesStorage[_key];
170     }
171 
172     function deleteBool(bytes32 _key) onlyCaller external {
173         delete boolStorage[_key];
174     }
175 
176     function deleteInt(bytes32 _key) onlyCaller external {
177         delete intStorage[_key];
178     }
179 }
180 
181 /*
182  * Database Contract
183  * Davy Van Roy
184  * Quinten De Swaef
185  */
186 contract FundRepository is Callable {
187 
188     using SafeMath for uint256;
189 
190     EternalStorage public db;
191 
192     //platform -> platformId => _funding
193     mapping(bytes32 => mapping(string => Funding)) funds;
194 
195     struct Funding {
196         address[] funders; //funders that funded tokens
197         address[] tokens; //tokens that were funded
198         mapping(address => TokenFunding) tokenFunding;
199     }
200 
201     struct TokenFunding {
202         mapping(address => uint256) balance;
203         uint256 totalTokenBalance;
204     }
205 
206     constructor(address _eternalStorage) public {
207         db = EternalStorage(_eternalStorage);
208     }
209 
210     function updateFunders(address _from, bytes32 _platform, string _platformId) public onlyCaller {
211         bool existing = db.getBool(keccak256(abi.encodePacked("funds.userHasFunded", _platform, _platformId, _from)));
212         if (!existing) {
213             uint funderCount = getFunderCount(_platform, _platformId);
214             db.setAddress(keccak256(abi.encodePacked("funds.funders.address", _platform, _platformId, funderCount)), _from);
215             db.setUint(keccak256(abi.encodePacked("funds.funderCount", _platform, _platformId)), funderCount.add(1));
216         }
217     }
218 
219     function updateBalances(address _from, bytes32 _platform, string _platformId, address _token, uint256 _value) public onlyCaller {
220         if (db.getBool(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _token))) == false) {
221             db.setBool(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _token)), true);
222             //add to the list of tokens for this platformId
223             uint tokenCount = getFundedTokenCount(_platform, _platformId);
224             db.setAddress(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, tokenCount)), _token);
225             db.setUint(keccak256(abi.encodePacked("funds.tokenCount", _platform, _platformId)), tokenCount.add(1));
226         }
227 
228         //add to the balance of this platformId for this token
229         db.setUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)), balance(_platform, _platformId, _token).add(_value));
230 
231         //add to the balance the user has funded for the request
232         db.setUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _from, _token)), amountFunded(_platform, _platformId, _from, _token).add(_value));
233 
234         //add the fact that the user has now funded this platformId
235         db.setBool(keccak256(abi.encodePacked("funds.userHasFunded", _platform, _platformId, _from)), true);
236     }
237 
238     function claimToken(bytes32 platform, string platformId, address _token) public onlyCaller returns (uint256) {
239         require(!issueResolved(platform, platformId), "Can't claim token, issue is already resolved.");
240         uint256 totalTokenBalance = balance(platform, platformId, _token);
241         db.deleteUint(keccak256(abi.encodePacked("funds.tokenBalance", platform, platformId, _token)));
242         return totalTokenBalance;
243     }
244 
245     function refundToken(bytes32 _platform, string _platformId, address _owner, address _token) public onlyCaller returns (uint256) {
246         require(!issueResolved(_platform, _platformId), "Can't refund token, issue is already resolved.");
247 
248         //delete amount from user, so he can't refund again
249         uint256 userTokenBalance = amountFunded(_platform, _platformId, _owner, _token);
250         db.deleteUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _owner, _token)));
251 
252 
253         uint256 oldBalance = balance(_platform, _platformId, _token);
254         uint256 newBalance = oldBalance.sub(userTokenBalance);
255 
256         require(newBalance <= oldBalance);
257 
258         //subtract amount from tokenBalance
259         db.setUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)), newBalance);
260 
261         return userTokenBalance;
262     }
263 
264     function finishResolveFund(bytes32 platform, string platformId) public onlyCaller returns (bool) {
265         db.setBool(keccak256(abi.encodePacked("funds.issueResolved", platform, platformId)), true);
266         db.deleteUint(keccak256(abi.encodePacked("funds.funderCount", platform, platformId)));
267         return true;
268     }
269 
270     //constants
271     function getFundInfo(bytes32 _platform, string _platformId, address _funder, address _token) public view returns (uint256, uint256, uint256) {
272         return (
273         getFunderCount(_platform, _platformId),
274         balance(_platform, _platformId, _token),
275         amountFunded(_platform, _platformId, _funder, _token)
276         );
277     }
278 
279     function issueResolved(bytes32 _platform, string _platformId) public view returns (bool) {
280         return db.getBool(keccak256(abi.encodePacked("funds.issueResolved", _platform, _platformId)));
281     }
282 
283     function getFundedTokenCount(bytes32 _platform, string _platformId) public view returns (uint256) {
284         return db.getUint(keccak256(abi.encodePacked("funds.tokenCount", _platform, _platformId)));
285     }
286 
287     function getFundedTokensByIndex(bytes32 _platform, string _platformId, uint _index) public view returns (address) {
288         return db.getAddress(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _index)));
289     }
290 
291     function getFunderCount(bytes32 _platform, string _platformId) public view returns (uint) {
292         return db.getUint(keccak256(abi.encodePacked("funds.funderCount", _platform, _platformId)));
293     }
294 
295     function getFunderByIndex(bytes32 _platform, string _platformId, uint index) external view returns (address) {
296         return db.getAddress(keccak256(abi.encodePacked("funds.funders.address", _platform, _platformId, index)));
297     }
298 
299     function amountFunded(bytes32 _platform, string _platformId, address _funder, address _token) public view returns (uint256) {
300         return db.getUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _funder, _token)));
301     }
302 
303     function balance(bytes32 _platform, string _platformId, address _token) view public returns (uint256) {
304         return db.getUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)));
305     }
306 }
307 
308 contract ClaimRepository is Callable {
309     using SafeMath for uint256;
310 
311     EternalStorage public db;
312 
313     constructor(address _eternalStorage) public {
314         //constructor
315         require(_eternalStorage != address(0), "Eternal storage cannot be 0x0");
316         db = EternalStorage(_eternalStorage);
317     }
318 
319     function addClaim(address _solverAddress, bytes32 _platform, string _platformId, string _solver, address _token, uint256 _requestBalance) public onlyCaller returns (bool) {
320         if (db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId))) != address(0)) {
321             require(db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId))) == _solverAddress, "Adding a claim needs to happen with the same claimer as before");
322         } else {
323             db.setString(keccak256(abi.encodePacked("claims.solver", _platform, _platformId)), _solver);
324             db.setAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId)), _solverAddress);
325         }
326 
327         uint tokenCount = db.getUint(keccak256(abi.encodePacked("claims.tokenCount", _platform, _platformId)));
328         db.setUint(keccak256(abi.encodePacked("claims.tokenCount", _platform, _platformId)), tokenCount.add(1));
329         db.setUint(keccak256(abi.encodePacked("claims.token.amount", _platform, _platformId, _token)), _requestBalance);
330         db.setAddress(keccak256(abi.encodePacked("claims.token.address", _platform, _platformId, tokenCount)), _token);
331         return true;
332     }
333 
334     function isClaimed(bytes32 _platform, string _platformId) view external returns (bool claimed) {
335         return db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId))) != address(0);
336     }
337 
338     function getSolverAddress(bytes32 _platform, string _platformId) view external returns (address solverAddress) {
339         return db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId)));
340     }
341 
342     function getSolver(bytes32 _platform, string _platformId) view external returns (string){
343         return db.getString(keccak256(abi.encodePacked("claims.solver", _platform, _platformId)));
344     }
345 
346     function getTokenCount(bytes32 _platform, string _platformId) view external returns (uint count) {
347         return db.getUint(keccak256(abi.encodePacked("claims.tokenCount", _platform, _platformId)));
348     }
349 
350     function getTokenByIndex(bytes32 _platform, string _platformId, uint _index) view external returns (address token) {
351         return db.getAddress(keccak256(abi.encodePacked("claims.token.address", _platform, _platformId, _index)));
352     }
353 
354     function getAmountByToken(bytes32 _platform, string _platformId, address _token) view external returns (uint token) {
355         return db.getUint(keccak256(abi.encodePacked("claims.token.amount", _platform, _platformId, _token)));
356     }
357 }
358 
359 contract ApproveAndCallFallBack {
360   function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
361 }
362 
363 /*
364  * @title String & slice utility library for Solidity contracts.
365  * @author Nick Johnson <arachnid@notdot.net>
366  *
367  * @dev Functionality in this library is largely implemented using an
368  *      abstraction called a 'slice'. A slice represents a part of a string -
369  *      anything from the entire string to a single character, or even no
370  *      characters at all (a 0-length slice). Since a slice only has to specify
371  *      an offset and a length, copying and manipulating slices is a lot less
372  *      expensive than copying and manipulating the strings they reference.
373  *
374  *      To further reduce gas costs, most functions on slice that need to return
375  *      a slice modify the original one instead of allocating a new one; for
376  *      instance, `s.split(".")` will return the text up to the first '.',
377  *      modifying s to only contain the remainder of the string after the '.'.
378  *      In situations where you do not want to modify the original slice, you
379  *      can make a copy first with `.copy()`, for example:
380  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
381  *      Solidity has no memory management, it will result in allocating many
382  *      short-lived slices that are later discarded.
383  *
384  *      Functions that return two slices come in two versions: a non-allocating
385  *      version that takes the second slice as an argument, modifying it in
386  *      place, and an allocating version that allocates and returns the second
387  *      slice; see `nextRune` for example.
388  *
389  *      Functions that have to copy string data will return strings rather than
390  *      slices; these can be cast back to slices for further processing if
391  *      required.
392  *
393  *      For convenience, some functions are provided with non-modifying
394  *      variants that create a new slice and return both; for instance,
395  *      `s.splitNew('.')` leaves s unmodified, and returns two values
396  *      corresponding to the left and right parts of the string.
397  */
398 
399 
400 
401 library strings {
402     struct slice {
403         uint _len;
404         uint _ptr;
405     }
406 
407     function memcpy(uint dest, uint src, uint len) private pure {
408         // Copy word-length chunks while possible
409         for (; len >= 32; len -= 32) {
410             assembly {
411                 mstore(dest, mload(src))
412             }
413             dest += 32;
414             src += 32;
415         }
416 
417         // Copy remaining bytes
418         uint mask = 256 ** (32 - len) - 1;
419         assembly {
420             let srcpart := and(mload(src), not(mask))
421             let destpart := and(mload(dest), mask)
422             mstore(dest, or(destpart, srcpart))
423         }
424     }
425 
426     /*
427      * @dev Returns a slice containing the entire string.
428      * @param self The string to make a slice from.
429      * @return A newly allocated slice containing the entire string.
430      */
431     function toSlice(string self) internal pure returns (slice) {
432         uint ptr;
433         assembly {
434             ptr := add(self, 0x20)
435         }
436         return slice(bytes(self).length, ptr);
437     }
438 
439     /*
440      * @dev Returns the length of a null-terminated bytes32 string.
441      * @param self The value to find the length of.
442      * @return The length of the string, from 0 to 32.
443      */
444     function len(bytes32 self) internal pure returns (uint) {
445         uint ret;
446         if (self == 0)
447             return 0;
448         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
449             ret += 16;
450             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
451         }
452         if (self & 0xffffffffffffffff == 0) {
453             ret += 8;
454             self = bytes32(uint(self) / 0x10000000000000000);
455         }
456         if (self & 0xffffffff == 0) {
457             ret += 4;
458             self = bytes32(uint(self) / 0x100000000);
459         }
460         if (self & 0xffff == 0) {
461             ret += 2;
462             self = bytes32(uint(self) / 0x10000);
463         }
464         if (self & 0xff == 0) {
465             ret += 1;
466         }
467         return 32 - ret;
468     }
469 
470     /*
471      * @dev Returns a slice containing the entire bytes32, interpreted as a
472      *      null-termintaed utf-8 string.
473      * @param self The bytes32 value to convert to a slice.
474      * @return A new slice containing the value of the input argument up to the
475      *         first null.
476      */
477     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
478         // Allocate space for `self` in memory, copy it there, and point ret at it
479         assembly {
480             let ptr := mload(0x40)
481             mstore(0x40, add(ptr, 0x20))
482             mstore(ptr, self)
483             mstore(add(ret, 0x20), ptr)
484         }
485         ret._len = len(self);
486     }
487 
488     /*
489      * @dev Returns a new slice containing the same data as the current slice.
490      * @param self The slice to copy.
491      * @return A new slice containing the same data as `self`.
492      */
493     function copy(slice self) internal pure returns (slice) {
494         return slice(self._len, self._ptr);
495     }
496 
497     /*
498      * @dev Copies a slice to a new string.
499      * @param self The slice to copy.
500      * @return A newly allocated string containing the slice's text.
501      */
502     function toString(slice self) internal pure returns (string) {
503         string memory ret = new string(self._len);
504         uint retptr;
505         assembly {retptr := add(ret, 32)}
506 
507         memcpy(retptr, self._ptr, self._len);
508         return ret;
509     }
510 
511     /*
512      * @dev Returns the length in runes of the slice. Note that this operation
513      *      takes time proportional to the length of the slice; avoid using it
514      *      in loops, and call `slice.empty()` if you only need to know whether
515      *      the slice is empty or not.
516      * @param self The slice to operate on.
517      * @return The length of the slice in runes.
518      */
519     function len(slice self) internal pure returns (uint l) {
520         // Starting at ptr-31 means the LSB will be the byte we care about
521         uint ptr = self._ptr - 31;
522         uint end = ptr + self._len;
523         for (l = 0; ptr < end; l++) {
524             uint8 b;
525             assembly {b := and(mload(ptr), 0xFF)}
526             if (b < 0x80) {
527                 ptr += 1;
528             } else if (b < 0xE0) {
529                 ptr += 2;
530             } else if (b < 0xF0) {
531                 ptr += 3;
532             } else if (b < 0xF8) {
533                 ptr += 4;
534             } else if (b < 0xFC) {
535                 ptr += 5;
536             } else {
537                 ptr += 6;
538             }
539         }
540     }
541 
542     /*
543      * @dev Returns true if the slice is empty (has a length of 0).
544      * @param self The slice to operate on.
545      * @return True if the slice is empty, False otherwise.
546      */
547     function empty(slice self) internal pure returns (bool) {
548         return self._len == 0;
549     }
550 
551     /*
552      * @dev Returns a positive number if `other` comes lexicographically after
553      *      `self`, a negative number if it comes before, or zero if the
554      *      contents of the two slices are equal. Comparison is done per-rune,
555      *      on unicode codepoints.
556      * @param self The first slice to compare.
557      * @param other The second slice to compare.
558      * @return The result of the comparison.
559      */
560     function compare(slice self, slice other) internal pure returns (int) {
561         uint shortest = self._len;
562         if (other._len < self._len)
563             shortest = other._len;
564 
565         uint selfptr = self._ptr;
566         uint otherptr = other._ptr;
567         for (uint idx = 0; idx < shortest; idx += 32) {
568             uint a;
569             uint b;
570             assembly {
571                 a := mload(selfptr)
572                 b := mload(otherptr)
573             }
574             if (a != b) {
575                 // Mask out irrelevant bytes and check again
576                 uint256 mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
577                 uint256 diff = (a & mask) - (b & mask);
578                 if (diff != 0)
579                     return int(diff);
580             }
581             selfptr += 32;
582             otherptr += 32;
583         }
584         return int(self._len) - int(other._len);
585     }
586 
587     /*
588      * @dev Returns true if the two slices contain the same text.
589      * @param self The first slice to compare.
590      * @param self The second slice to compare.
591      * @return True if the slices are equal, false otherwise.
592      */
593     function equals(slice self, slice other) internal pure returns (bool) {
594         return compare(self, other) == 0;
595     }
596 
597     /*
598      * @dev Extracts the first rune in the slice into `rune`, advancing the
599      *      slice to point to the next rune and returning `self`.
600      * @param self The slice to operate on.
601      * @param rune The slice that will contain the first rune.
602      * @return `rune`.
603      */
604     function nextRune(slice self, slice rune) internal pure returns (slice) {
605         rune._ptr = self._ptr;
606 
607         if (self._len == 0) {
608             rune._len = 0;
609             return rune;
610         }
611 
612         uint l;
613         uint b;
614         // Load the first byte of the rune into the LSBs of b
615         assembly {b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF)}
616         if (b < 0x80) {
617             l = 1;
618         } else if (b < 0xE0) {
619             l = 2;
620         } else if (b < 0xF0) {
621             l = 3;
622         } else {
623             l = 4;
624         }
625 
626         // Check for truncated codepoints
627         if (l > self._len) {
628             rune._len = self._len;
629             self._ptr += self._len;
630             self._len = 0;
631             return rune;
632         }
633 
634         self._ptr += l;
635         self._len -= l;
636         rune._len = l;
637         return rune;
638     }
639 
640     /*
641      * @dev Returns the first rune in the slice, advancing the slice to point
642      *      to the next rune.
643      * @param self The slice to operate on.
644      * @return A slice containing only the first rune from `self`.
645      */
646     function nextRune(slice self) internal pure returns (slice ret) {
647         nextRune(self, ret);
648     }
649 
650     /*
651      * @dev Returns the number of the first codepoint in the slice.
652      * @param self The slice to operate on.
653      * @return The number of the first codepoint in the slice.
654      */
655     function ord(slice self) internal pure returns (uint ret) {
656         if (self._len == 0) {
657             return 0;
658         }
659 
660         uint word;
661         uint length;
662         uint divisor = 2 ** 248;
663 
664         // Load the rune into the MSBs of b
665         assembly {word := mload(mload(add(self, 32)))}
666         uint b = word / divisor;
667         if (b < 0x80) {
668             ret = b;
669             length = 1;
670         } else if (b < 0xE0) {
671             ret = b & 0x1F;
672             length = 2;
673         } else if (b < 0xF0) {
674             ret = b & 0x0F;
675             length = 3;
676         } else {
677             ret = b & 0x07;
678             length = 4;
679         }
680 
681         // Check for truncated codepoints
682         if (length > self._len) {
683             return 0;
684         }
685 
686         for (uint i = 1; i < length; i++) {
687             divisor = divisor / 256;
688             b = (word / divisor) & 0xFF;
689             if (b & 0xC0 != 0x80) {
690                 // Invalid UTF-8 sequence
691                 return 0;
692             }
693             ret = (ret * 64) | (b & 0x3F);
694         }
695 
696         return ret;
697     }
698 
699     /*
700      * @dev Returns the keccak-256 hash of the slice.
701      * @param self The slice to hash.
702      * @return The hash of the slice.
703      */
704     function keccak(slice self) internal pure returns (bytes32 ret) {
705         assembly {
706             ret := keccak256(mload(add(self, 32)), mload(self))
707         }
708     }
709 
710     /*
711      * @dev Returns true if `self` starts with `needle`.
712      * @param self The slice to operate on.
713      * @param needle The slice to search for.
714      * @return True if the slice starts with the provided text, false otherwise.
715      */
716     function startsWith(slice self, slice needle) internal pure returns (bool) {
717         if (self._len < needle._len) {
718             return false;
719         }
720 
721         if (self._ptr == needle._ptr) {
722             return true;
723         }
724 
725         bool equal;
726         assembly {
727             let length := mload(needle)
728             let selfptr := mload(add(self, 0x20))
729             let needleptr := mload(add(needle, 0x20))
730             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
731         }
732         return equal;
733     }
734 
735     /*
736      * @dev If `self` starts with `needle`, `needle` is removed from the
737      *      beginning of `self`. Otherwise, `self` is unmodified.
738      * @param self The slice to operate on.
739      * @param needle The slice to search for.
740      * @return `self`
741      */
742     function beyond(slice self, slice needle) internal pure returns (slice) {
743         if (self._len < needle._len) {
744             return self;
745         }
746 
747         bool equal = true;
748         if (self._ptr != needle._ptr) {
749             assembly {
750                 let length := mload(needle)
751                 let selfptr := mload(add(self, 0x20))
752                 let needleptr := mload(add(needle, 0x20))
753                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
754             }
755         }
756 
757         if (equal) {
758             self._len -= needle._len;
759             self._ptr += needle._len;
760         }
761 
762         return self;
763     }
764 
765     /*
766      * @dev Returns true if the slice ends with `needle`.
767      * @param self The slice to operate on.
768      * @param needle The slice to search for.
769      * @return True if the slice starts with the provided text, false otherwise.
770      */
771     function endsWith(slice self, slice needle) internal pure returns (bool) {
772         if (self._len < needle._len) {
773             return false;
774         }
775 
776         uint selfptr = self._ptr + self._len - needle._len;
777 
778         if (selfptr == needle._ptr) {
779             return true;
780         }
781 
782         bool equal;
783         assembly {
784             let length := mload(needle)
785             let needleptr := mload(add(needle, 0x20))
786             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
787         }
788 
789         return equal;
790     }
791 
792     /*
793      * @dev If `self` ends with `needle`, `needle` is removed from the
794      *      end of `self`. Otherwise, `self` is unmodified.
795      * @param self The slice to operate on.
796      * @param needle The slice to search for.
797      * @return `self`
798      */
799     function until(slice self, slice needle) internal pure returns (slice) {
800         if (self._len < needle._len) {
801             return self;
802         }
803 
804         uint selfptr = self._ptr + self._len - needle._len;
805         bool equal = true;
806         if (selfptr != needle._ptr) {
807             assembly {
808                 let length := mload(needle)
809                 let needleptr := mload(add(needle, 0x20))
810                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
811             }
812         }
813 
814         if (equal) {
815             self._len -= needle._len;
816         }
817 
818         return self;
819     }
820 
821     event log_bytemask(bytes32 mask);
822 
823     // Returns the memory address of the first byte of the first occurrence of
824     // `needle` in `self`, or the first byte after `self` if not found.
825     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
826         uint ptr = selfptr;
827         uint idx;
828 
829         if (needlelen <= selflen) {
830             if (needlelen <= 32) {
831                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
832 
833                 bytes32 needledata;
834                 assembly {needledata := and(mload(needleptr), mask)}
835 
836                 uint end = selfptr + selflen - needlelen;
837                 bytes32 ptrdata;
838                 assembly {ptrdata := and(mload(ptr), mask)}
839 
840                 while (ptrdata != needledata) {
841                     if (ptr >= end)
842                         return selfptr + selflen;
843                     ptr++;
844                     assembly {ptrdata := and(mload(ptr), mask)}
845                 }
846                 return ptr;
847             } else {
848                 // For long needles, use hashing
849                 bytes32 hash;
850                 assembly {hash := sha3(needleptr, needlelen)}
851 
852                 for (idx = 0; idx <= selflen - needlelen; idx++) {
853                     bytes32 testHash;
854                     assembly {testHash := sha3(ptr, needlelen)}
855                     if (hash == testHash)
856                         return ptr;
857                     ptr += 1;
858                 }
859             }
860         }
861         return selfptr + selflen;
862     }
863 
864     // Returns the memory address of the first byte after the last occurrence of
865     // `needle` in `self`, or the address of `self` if not found.
866     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
867         uint ptr;
868 
869         if (needlelen <= selflen) {
870             if (needlelen <= 32) {
871                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
872 
873                 bytes32 needledata;
874                 assembly {needledata := and(mload(needleptr), mask)}
875 
876                 ptr = selfptr + selflen - needlelen;
877                 bytes32 ptrdata;
878                 assembly {ptrdata := and(mload(ptr), mask)}
879 
880                 while (ptrdata != needledata) {
881                     if (ptr <= selfptr)
882                         return selfptr;
883                     ptr--;
884                     assembly {ptrdata := and(mload(ptr), mask)}
885                 }
886                 return ptr + needlelen;
887             } else {
888                 // For long needles, use hashing
889                 bytes32 hash;
890                 assembly {hash := sha3(needleptr, needlelen)}
891                 ptr = selfptr + (selflen - needlelen);
892                 while (ptr >= selfptr) {
893                     bytes32 testHash;
894                     assembly {testHash := sha3(ptr, needlelen)}
895                     if (hash == testHash)
896                         return ptr + needlelen;
897                     ptr -= 1;
898                 }
899             }
900         }
901         return selfptr;
902     }
903 
904     /*
905      * @dev Modifies `self` to contain everything from the first occurrence of
906      *      `needle` to the end of the slice. `self` is set to the empty slice
907      *      if `needle` is not found.
908      * @param self The slice to search and modify.
909      * @param needle The text to search for.
910      * @return `self`.
911      */
912     function find(slice self, slice needle) internal pure returns (slice) {
913         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
914         self._len -= ptr - self._ptr;
915         self._ptr = ptr;
916         return self;
917     }
918 
919     /*
920      * @dev Modifies `self` to contain the part of the string from the start of
921      *      `self` to the end of the first occurrence of `needle`. If `needle`
922      *      is not found, `self` is set to the empty slice.
923      * @param self The slice to search and modify.
924      * @param needle The text to search for.
925      * @return `self`.
926      */
927     function rfind(slice self, slice needle) internal pure returns (slice) {
928         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
929         self._len = ptr - self._ptr;
930         return self;
931     }
932 
933     /*
934      * @dev Splits the slice, setting `self` to everything after the first
935      *      occurrence of `needle`, and `token` to everything before it. If
936      *      `needle` does not occur in `self`, `self` is set to the empty slice,
937      *      and `token` is set to the entirety of `self`.
938      * @param self The slice to split.
939      * @param needle The text to search for in `self`.
940      * @param token An output parameter to which the first token is written.
941      * @return `token`.
942      */
943     function split(slice self, slice needle, slice token) internal pure returns (slice) {
944         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
945         token._ptr = self._ptr;
946         token._len = ptr - self._ptr;
947         if (ptr == self._ptr + self._len) {
948             // Not found
949             self._len = 0;
950         } else {
951             self._len -= token._len + needle._len;
952             self._ptr = ptr + needle._len;
953         }
954         return token;
955     }
956 
957     /*
958      * @dev Splits the slice, setting `self` to everything after the first
959      *      occurrence of `needle`, and returning everything before it. If
960      *      `needle` does not occur in `self`, `self` is set to the empty slice,
961      *      and the entirety of `self` is returned.
962      * @param self The slice to split.
963      * @param needle The text to search for in `self`.
964      * @return The part of `self` up to the first occurrence of `delim`.
965      */
966     function split(slice self, slice needle) internal pure returns (slice token) {
967         split(self, needle, token);
968     }
969 
970     /*
971      * @dev Splits the slice, setting `self` to everything before the last
972      *      occurrence of `needle`, and `token` to everything after it. If
973      *      `needle` does not occur in `self`, `self` is set to the empty slice,
974      *      and `token` is set to the entirety of `self`.
975      * @param self The slice to split.
976      * @param needle The text to search for in `self`.
977      * @param token An output parameter to which the first token is written.
978      * @return `token`.
979      */
980     function rsplit(slice self, slice needle, slice token) internal pure returns (slice) {
981         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
982         token._ptr = ptr;
983         token._len = self._len - (ptr - self._ptr);
984         if (ptr == self._ptr) {
985             // Not found
986             self._len = 0;
987         } else {
988             self._len -= token._len + needle._len;
989         }
990         return token;
991     }
992 
993     /*
994      * @dev Splits the slice, setting `self` to everything before the last
995      *      occurrence of `needle`, and returning everything after it. If
996      *      `needle` does not occur in `self`, `self` is set to the empty slice,
997      *      and the entirety of `self` is returned.
998      * @param self The slice to split.
999      * @param needle The text to search for in `self`.
1000      * @return The part of `self` after the last occurrence of `delim`.
1001      */
1002     function rsplit(slice self, slice needle) internal pure returns (slice token) {
1003         rsplit(self, needle, token);
1004     }
1005 
1006     /*
1007      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1008      * @param self The slice to search.
1009      * @param needle The text to search for in `self`.
1010      * @return The number of occurrences of `needle` found in `self`.
1011      */
1012     function count(slice self, slice needle) internal pure returns (uint cnt) {
1013         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1014         while (ptr <= self._ptr + self._len) {
1015             cnt++;
1016             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1017         }
1018     }
1019 
1020     /*
1021      * @dev Returns True if `self` contains `needle`.
1022      * @param self The slice to search.
1023      * @param needle The text to search for in `self`.
1024      * @return True if `needle` is found in `self`, false otherwise.
1025      */
1026     function contains(slice self, slice needle) internal pure returns (bool) {
1027         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1028     }
1029 
1030     /*
1031      * @dev Returns a newly allocated string containing the concatenation of
1032      *      `self` and `other`.
1033      * @param self The first slice to concatenate.
1034      * @param other The second slice to concatenate.
1035      * @return The concatenation of the two strings.
1036      */
1037     function concat(slice self, slice other) internal pure returns (string) {
1038         string memory ret = new string(self._len + other._len);
1039         uint retptr;
1040         assembly {retptr := add(ret, 32)}
1041         memcpy(retptr, self._ptr, self._len);
1042         memcpy(retptr + self._len, other._ptr, other._len);
1043         return ret;
1044     }
1045 
1046     /*
1047      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1048      *      newly allocated string.
1049      * @param self The delimiter to use.
1050      * @param parts A list of slices to join.
1051      * @return A newly allocated string containing all the slices in `parts`,
1052      *         joined with `self`.
1053      */
1054     function join(slice self, slice[] parts) internal pure returns (string) {
1055         if (parts.length == 0)
1056             return "";
1057 
1058         uint length = self._len * (parts.length - 1);
1059         for (uint i = 0; i < parts.length; i++)
1060             length += parts[i]._len;
1061 
1062         string memory ret = new string(length);
1063         uint retptr;
1064         assembly {retptr := add(ret, 32)}
1065 
1066         for (i = 0; i < parts.length; i++) {
1067             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1068             retptr += parts[i]._len;
1069             if (i < parts.length - 1) {
1070                 memcpy(retptr, self._ptr, self._len);
1071                 retptr += self._len;
1072             }
1073         }
1074 
1075         return ret;
1076     }
1077 
1078     /*
1079     * Additions by the FundRequest Team
1080     */
1081 
1082     function toBytes32(slice self) internal pure returns (bytes32 result) {
1083         string memory source = toString(self);
1084         bytes memory tempEmptyStringTest = bytes(source);
1085         if (tempEmptyStringTest.length == 0) {
1086             return 0x0;
1087         }
1088 
1089         assembly {
1090             result := mload(add(source, 32))
1091         }
1092     }
1093 
1094     function strConcat(string _a, string _b, string _c, string _d, string _e) pure internal returns (string){
1095         bytes memory _ba = bytes(_a);
1096         bytes memory _bb = bytes(_b);
1097         bytes memory _bc = bytes(_c);
1098         bytes memory _bd = bytes(_d);
1099         bytes memory _be = bytes(_e);
1100         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1101         bytes memory babcde = bytes(abcde);
1102         uint k = 0;
1103         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1104         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1105         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1106         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1107         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1108         return string(babcde);
1109     }
1110 
1111     function strConcat(string _a, string _b, string _c, string _d) pure internal returns (string) {
1112         return strConcat(_a, _b, _c, _d, "");
1113     }
1114 
1115     function strConcat(string _a, string _b, string _c) pure internal returns (string) {
1116         return strConcat(_a, _b, _c, "", "");
1117     }
1118 
1119     function strConcat(string _a, string _b) pure internal returns (string) {
1120         return strConcat(_a, _b, "", "", "");
1121     }
1122 
1123     function addressToString(address x) internal pure returns (string) {
1124         bytes memory s = new bytes(40);
1125         for (uint i = 0; i < 20; i++) {
1126             byte b = byte(uint8(uint(x) / (2 ** (8 * (19 - i)))));
1127             byte hi = byte(uint8(b) / 16);
1128             byte lo = byte(uint8(b) - 16 * uint8(hi));
1129             s[2 * i] = charToByte(hi);
1130             s[2 * i + 1] = charToByte(lo);
1131         }
1132         return strConcat("0x", string(s));
1133     }
1134 
1135     function charToByte(byte b) internal pure returns (byte c) {
1136         if (b < 10) return byte(uint8(b) + 0x30);
1137         else return byte(uint8(b) + 0x57);
1138     }
1139 
1140     function bytes32ToString(bytes32 x) internal pure returns (string) {
1141         bytes memory bytesString = new bytes(32);
1142         uint charCount = 0;
1143         for (uint j = 0; j < 32; j++) {
1144             byte ch = byte(bytes32(uint(x) * 2 ** (8 * j)));
1145             if (ch != 0) {
1146                 bytesString[charCount] = ch;
1147                 charCount++;
1148             }
1149         }
1150         bytes memory bytesStringTrimmed = new bytes(charCount);
1151         for (j = 0; j < charCount; j++) {
1152             bytesStringTrimmed[j] = bytesString[j];
1153         }
1154         return string(bytesStringTrimmed);
1155     }
1156 }
1157 
1158 contract Precondition is Owned {
1159 
1160     string public name;
1161     uint public version;
1162     bool public active = false;
1163 
1164     constructor(string _name, uint _version, bool _active) public {
1165         name = _name;
1166         version = _version;
1167         active = _active;
1168     }
1169 
1170     function setActive(bool _active) external onlyOwner {
1171         active = _active;
1172     }
1173 
1174     function isValid(bytes32 _platform, string _platformId, address _token, uint256 _value, address _funder) external view returns (bool valid);
1175 }
1176 
1177 /*
1178  * Main FundRequest Contract. The entrypoint for every claim/refund
1179  * Davy Van Roy
1180  * Quinten De Swaef
1181  */
1182 contract FundRequestContract is Callable, ApproveAndCallFallBack {
1183 
1184     using SafeMath for uint256;
1185     using strings for *;
1186 
1187     event Funded(address indexed from, bytes32 platform, string platformId, address token, uint256 value);
1188 
1189     event Claimed(address indexed solverAddress, bytes32 platform, string platformId, string solver, address token, uint256 value);
1190 
1191     event Refund(address indexed owner, bytes32 platform, string platformId, address token, uint256 value);
1192 
1193     address constant public ETHER_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
1194 
1195     //repositories
1196     FundRepository public fundRepository;
1197 
1198     ClaimRepository public claimRepository;
1199 
1200     address public claimSignerAddress;
1201 
1202     Precondition[] public preconditions;
1203 
1204     constructor(address _fundRepository, address _claimRepository) public {
1205         setFundRepository(_fundRepository);
1206         setClaimRepository(_claimRepository);
1207     }
1208 
1209     //ENTRYPOINTS
1210 
1211     /*
1212      * Public function, can only be called from the outside.
1213      * Fund an issue, providing a token and value.
1214      * Requires an allowance > _value of the token.
1215      */
1216     function fund(bytes32 _platform, string _platformId, address _token, uint256 _value) external returns (bool success) {
1217         require(doFunding(_platform, _platformId, _token, _value, msg.sender), "funding with token failed");
1218         return true;
1219     }
1220 
1221     /*
1222      * Public function, can only be called from the outside.
1223      * Fund an issue, ether as value of the transaction.
1224      * Requires ether to be whitelisted in a precondition.
1225      */
1226     function etherFund(bytes32 _platform, string _platformId) payable external returns (bool success) {
1227         require(doFunding(_platform, _platformId, ETHER_ADDRESS, msg.value, msg.sender), "funding with ether failed");
1228         return true;
1229     }
1230 
1231     /*
1232      * Public function, supposed to be called from another contract, after receiving approval
1233      * Funds an issue, expects platform, platformid to be concatted with |AAC| as delimiter and provided as _data
1234      * Only used with the FundRequest approveAndCall function at the moment. Might be removed later in favor of 2 calls.
1235      */
1236     function receiveApproval(address _from, uint _amount, address _token, bytes _data) public {
1237         var sliced = string(_data).toSlice();
1238         var platform = sliced.split("|AAC|".toSlice());
1239         var platformId = sliced.split("|AAC|".toSlice());
1240         require(doFunding(platform.toBytes32(), platformId.toString(), _token, _amount, _from));
1241     }
1242 
1243     /*
1244      * Claim: Public function, only supposed to be called from the outside
1245      * Anyone can call this function, but a valid signature from FundRequest is required
1246      */
1247     function claim(bytes32 platform, string platformId, string solver, address solverAddress, bytes32 r, bytes32 s, uint8 v) public returns (bool) {
1248         require(validClaim(platform, platformId, solver, solverAddress, r, s, v), "Claimsignature was not valid");
1249         uint256 tokenCount = fundRepository.getFundedTokenCount(platform, platformId);
1250         for (uint i = 0; i < tokenCount; i++) {
1251             address token = fundRepository.getFundedTokensByIndex(platform, platformId, i);
1252             uint256 tokenAmount = fundRepository.claimToken(platform, platformId, token);
1253             if (token == ETHER_ADDRESS) {
1254                 solverAddress.transfer(tokenAmount);
1255             } else {
1256                 require(ERC20(token).transfer(solverAddress, tokenAmount), "transfer of tokens from contract failed");
1257             }
1258             require(claimRepository.addClaim(solverAddress, platform, platformId, solver, token, tokenAmount), "adding claim to repository failed");
1259             emit Claimed(solverAddress, platform, platformId, solver, token, tokenAmount);
1260         }
1261         require(fundRepository.finishResolveFund(platform, platformId), "Resolving the fund failed");
1262         return true;
1263     }
1264 
1265     /*
1266      * Claim: Public function, only supposed to be called from the outside
1267      * Only FundRequest can call this function for now, which will refund a user for a specific issue.
1268      */
1269     function refund(bytes32 _platform, string _platformId, address _funder) external onlyCaller returns (bool) {
1270         uint256 tokenCount = fundRepository.getFundedTokenCount(_platform, _platformId);
1271         for (uint i = 0; i < tokenCount; i++) {
1272             address token = fundRepository.getFundedTokensByIndex(_platform, _platformId, i);
1273             uint256 tokenAmount = fundRepository.refundToken(_platform, _platformId, _funder, token);
1274             if (tokenAmount > 0) {
1275                 if (token == ETHER_ADDRESS) {
1276                     _funder.transfer(tokenAmount);
1277                 } else {
1278                     require(ERC20(token).transfer(_funder, tokenAmount), "transfer of tokens from contract failed");
1279                 }
1280             }
1281             emit Refund(_funder, _platform, _platformId, token, tokenAmount);
1282         }
1283     }
1284 
1285     /*
1286      * only called from within the this contract itself, will actually do the funding
1287      */
1288     function doFunding(bytes32 _platform, string _platformId, address _token, uint256 _value, address _funder) internal returns (bool success) {
1289         if (_token == ETHER_ADDRESS) {
1290             //must check this, so we don't have people foefeling with the amounts
1291             require(msg.value == _value);
1292         }
1293         require(!fundRepository.issueResolved(_platform, _platformId), "Can't fund tokens, platformId already claimed");
1294         for (uint idx = 0; idx < preconditions.length; idx++) {
1295             if (address(preconditions[idx]) != address(0)) {
1296                 require(preconditions[idx].isValid(_platform, _platformId, _token, _value, _funder));
1297             }
1298         }
1299         require(_value > 0, "amount of tokens needs to be more than 0");
1300 
1301         if (_token != ETHER_ADDRESS) {
1302             require(ERC20(_token).transferFrom(_funder, address(this), _value), "Transfer of tokens to contract failed");
1303         }
1304 
1305         fundRepository.updateFunders(_funder, _platform, _platformId);
1306         fundRepository.updateBalances(_funder, _platform, _platformId, _token, _value);
1307         emit Funded(_funder, _platform, _platformId, _token, _value);
1308         return true;
1309     }
1310 
1311     /*
1312      * checks if a claim is valid, by checking the signature
1313      */
1314     function validClaim(bytes32 platform, string platformId, string solver, address solverAddress, bytes32 r, bytes32 s, uint8 v) internal view returns (bool) {
1315         bytes32 h = keccak256(abi.encodePacked(createClaimMsg(platform, platformId, solver, solverAddress)));
1316         address signerAddress = ecrecover(h, v, r, s);
1317         return claimSignerAddress == signerAddress;
1318     }
1319 
1320     function createClaimMsg(bytes32 platform, string platformId, string solver, address solverAddress) internal pure returns (string) {
1321         return strings.bytes32ToString(platform)
1322         .strConcat(prependUnderscore(platformId))
1323         .strConcat(prependUnderscore(solver))
1324         .strConcat(prependUnderscore(strings.addressToString(solverAddress)));
1325     }
1326 
1327     function addPrecondition(address _precondition) external onlyOwner {
1328         preconditions.push(Precondition(_precondition));
1329     }
1330 
1331     function removePrecondition(uint _index) external onlyOwner {
1332         if (_index >= preconditions.length) return;
1333 
1334         for (uint i = _index; i < preconditions.length - 1; i++) {
1335             preconditions[i] = preconditions[i + 1];
1336         }
1337 
1338         delete preconditions[preconditions.length - 1];
1339         preconditions.length--;
1340     }
1341 
1342     function setFundRepository(address _repositoryAddress) public onlyOwner {
1343         fundRepository = FundRepository(_repositoryAddress);
1344     }
1345 
1346     function setClaimRepository(address _claimRepository) public onlyOwner {
1347         claimRepository = ClaimRepository(_claimRepository);
1348     }
1349 
1350     function setClaimSignerAddress(address _claimSignerAddress) addressNotNull(_claimSignerAddress) public onlyOwner {
1351         claimSignerAddress = _claimSignerAddress;
1352     }
1353 
1354     function prependUnderscore(string str) internal pure returns (string) {
1355         return "_".strConcat(str);
1356     }
1357 
1358     //required to be able to migrate to a new FundRequestContract
1359     function migrateTokens(address _token, address newContract) external onlyOwner {
1360         require(newContract != address(0));
1361         if (_token == ETHER_ADDRESS) {
1362             newContract.transfer(address(this).balance);
1363         } else {
1364             ERC20 token = ERC20(_token);
1365             token.transfer(newContract, token.balanceOf(address(this)));
1366         }
1367     }
1368 
1369     modifier addressNotNull(address target) {
1370         require(target != address(0), "target address can not be 0x0");
1371         _;
1372     }
1373 
1374     //required should there be an issue with available ether
1375     function deposit() external onlyOwner payable {
1376         require(msg.value > 0, "Should at least be 1 wei deposited");
1377     }
1378 }