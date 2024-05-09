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
220         if (balance(_platform, _platformId, _token) <= 0) {
221             //add to the list of tokens for this platformId
222             uint tokenCount = getFundedTokenCount(_platform, _platformId);
223             db.setAddress(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, tokenCount)), _token);
224             db.setUint(keccak256(abi.encodePacked("funds.tokenCount", _platform, _platformId)), tokenCount.add(1));
225         }
226 
227         //add to the balance of this platformId for this token
228         db.setUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)), balance(_platform, _platformId, _token).add(_value));
229 
230         //add to the balance the user has funded for the request
231         db.setUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _from, _token)), amountFunded(_platform, _platformId, _from, _token).add(_value));
232 
233         //add the fact that the user has now funded this platformId
234         db.setBool(keccak256(abi.encodePacked("funds.userHasFunded", _platform, _platformId, _from)), true);
235     }
236 
237     function claimToken(bytes32 platform, string platformId, address _token) public onlyCaller returns (uint256) {
238         require(!issueResolved(platform, platformId), "Can't claim token, issue is already resolved.");
239         uint256 totalTokenBalance = balance(platform, platformId, _token);
240         db.deleteUint(keccak256(abi.encodePacked("funds.tokenBalance", platform, platformId, _token)));
241         return totalTokenBalance;
242     }
243 
244     function finishResolveFund(bytes32 platform, string platformId) public onlyCaller returns (bool) {
245         db.setBool(keccak256(abi.encodePacked("funds.issueResolved", platform, platformId)), true);
246         db.deleteUint(keccak256(abi.encodePacked("funds.funderCount", platform, platformId)));
247         return true;
248     }
249 
250     //constants
251     function getFundInfo(bytes32 _platform, string _platformId, address _funder, address _token) public view returns (uint256, uint256, uint256) {
252         return (
253         getFunderCount(_platform, _platformId),
254         balance(_platform, _platformId, _token),
255         amountFunded(_platform, _platformId, _funder, _token)
256         );
257     }
258 
259     function issueResolved(bytes32 _platform, string _platformId) public view returns (bool) {
260         return db.getBool(keccak256(abi.encodePacked("funds.issueResolved", _platform, _platformId)));
261     }
262 
263     function getFundedTokenCount(bytes32 _platform, string _platformId) public view returns (uint256) {
264         return db.getUint(keccak256(abi.encodePacked("funds.tokenCount", _platform, _platformId)));
265     }
266 
267     function getFundedTokensByIndex(bytes32 _platform, string _platformId, uint _index) public view returns (address) {
268         return db.getAddress(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _index)));
269     }
270 
271     function getFunderCount(bytes32 _platform, string _platformId) public view returns (uint) {
272         return db.getUint(keccak256(abi.encodePacked("funds.funderCount", _platform, _platformId)));
273     }
274 
275     function getFunderByIndex(bytes32 _platform, string _platformId, uint index) external view returns (address) {
276         return db.getAddress(keccak256(abi.encodePacked("funds.funders.address", _platform, _platformId, index)));
277     }
278 
279     function amountFunded(bytes32 _platform, string _platformId, address _funder, address _token) public view returns (uint256) {
280         return db.getUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _funder, _token)));
281     }
282 
283     function balance(bytes32 _platform, string _platformId, address _token) view public returns (uint256) {
284         return db.getUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)));
285     }
286 }
287 
288 contract ClaimRepository is Callable {
289     using SafeMath for uint256;
290 
291     EternalStorage public db;
292 
293     constructor(address _eternalStorage) public {
294         //constructor
295         require(_eternalStorage != address(0), "Eternal storage cannot be 0x0");
296         db = EternalStorage(_eternalStorage);
297     }
298 
299     function addClaim(address _solverAddress, bytes32 _platform, string _platformId, string _solver, address _token, uint256 _requestBalance) public onlyCaller returns (bool) {
300         if (db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId))) != address(0)) {
301             require(db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId))) == _solverAddress, "Adding a claim needs to happen with the same claimer as before");
302         } else {
303             db.setString(keccak256(abi.encodePacked("claims.solver", _platform, _platformId)), _solver);
304             db.setAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId)), _solverAddress);
305         }
306 
307         uint tokenCount = db.getUint(keccak256(abi.encodePacked("claims.tokenCount", _platform, _platformId)));
308         db.setUint(keccak256(abi.encodePacked("claims.tokenCount", _platform, _platformId)), tokenCount.add(1));
309         db.setUint(keccak256(abi.encodePacked("claims.token.amount", _platform, _platformId, _token)), _requestBalance);
310         db.setAddress(keccak256(abi.encodePacked("claims.token.address", _platform, _platformId, tokenCount)), _token);
311         return true;
312     }
313 
314     function isClaimed(bytes32 _platform, string _platformId) view external returns (bool claimed) {
315         return db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId))) != address(0);
316     }
317 
318     function getSolverAddress(bytes32 _platform, string _platformId) view external returns (address solverAddress) {
319         return db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId)));
320     }
321 
322     function getSolver(bytes32 _platform, string _platformId) view external returns (string){
323         return db.getString(keccak256(abi.encodePacked("claims.solver", _platform, _platformId)));
324     }
325 
326     function getTokenCount(bytes32 _platform, string _platformId) view external returns (uint count) {
327         return db.getUint(keccak256(abi.encodePacked("claims.tokenCount", _platform, _platformId)));
328     }
329 
330     function getTokenByIndex(bytes32 _platform, string _platformId, uint _index) view external returns (address token) {
331         return db.getAddress(keccak256(abi.encodePacked("claims.token.address", _platform, _platformId, _index)));
332     }
333 
334     function getAmountByToken(bytes32 _platform, string _platformId, address _token) view external returns (uint token) {
335         return db.getUint(keccak256(abi.encodePacked("claims.token.amount", _platform, _platformId, _token)));
336     }
337 }
338 
339 contract ApproveAndCallFallBack {
340   function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
341 }
342 
343 /*
344  * @title String & slice utility library for Solidity contracts.
345  * @author Nick Johnson <arachnid@notdot.net>
346  *
347  * @dev Functionality in this library is largely implemented using an
348  *      abstraction called a 'slice'. A slice represents a part of a string -
349  *      anything from the entire string to a single character, or even no
350  *      characters at all (a 0-length slice). Since a slice only has to specify
351  *      an offset and a length, copying and manipulating slices is a lot less
352  *      expensive than copying and manipulating the strings they reference.
353  *
354  *      To further reduce gas costs, most functions on slice that need to return
355  *      a slice modify the original one instead of allocating a new one; for
356  *      instance, `s.split(".")` will return the text up to the first '.',
357  *      modifying s to only contain the remainder of the string after the '.'.
358  *      In situations where you do not want to modify the original slice, you
359  *      can make a copy first with `.copy()`, for example:
360  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
361  *      Solidity has no memory management, it will result in allocating many
362  *      short-lived slices that are later discarded.
363  *
364  *      Functions that return two slices come in two versions: a non-allocating
365  *      version that takes the second slice as an argument, modifying it in
366  *      place, and an allocating version that allocates and returns the second
367  *      slice; see `nextRune` for example.
368  *
369  *      Functions that have to copy string data will return strings rather than
370  *      slices; these can be cast back to slices for further processing if
371  *      required.
372  *
373  *      For convenience, some functions are provided with non-modifying
374  *      variants that create a new slice and return both; for instance,
375  *      `s.splitNew('.')` leaves s unmodified, and returns two values
376  *      corresponding to the left and right parts of the string.
377  */
378 
379 
380 
381 library strings {
382     struct slice {
383         uint _len;
384         uint _ptr;
385     }
386 
387     function memcpy(uint dest, uint src, uint len) private pure {
388         // Copy word-length chunks while possible
389         for (; len >= 32; len -= 32) {
390             assembly {
391                 mstore(dest, mload(src))
392             }
393             dest += 32;
394             src += 32;
395         }
396 
397         // Copy remaining bytes
398         uint mask = 256 ** (32 - len) - 1;
399         assembly {
400             let srcpart := and(mload(src), not(mask))
401             let destpart := and(mload(dest), mask)
402             mstore(dest, or(destpart, srcpart))
403         }
404     }
405 
406     /*
407      * @dev Returns a slice containing the entire string.
408      * @param self The string to make a slice from.
409      * @return A newly allocated slice containing the entire string.
410      */
411     function toSlice(string self) internal pure returns (slice) {
412         uint ptr;
413         assembly {
414             ptr := add(self, 0x20)
415         }
416         return slice(bytes(self).length, ptr);
417     }
418 
419     /*
420      * @dev Returns the length of a null-terminated bytes32 string.
421      * @param self The value to find the length of.
422      * @return The length of the string, from 0 to 32.
423      */
424     function len(bytes32 self) internal pure returns (uint) {
425         uint ret;
426         if (self == 0)
427             return 0;
428         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
429             ret += 16;
430             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
431         }
432         if (self & 0xffffffffffffffff == 0) {
433             ret += 8;
434             self = bytes32(uint(self) / 0x10000000000000000);
435         }
436         if (self & 0xffffffff == 0) {
437             ret += 4;
438             self = bytes32(uint(self) / 0x100000000);
439         }
440         if (self & 0xffff == 0) {
441             ret += 2;
442             self = bytes32(uint(self) / 0x10000);
443         }
444         if (self & 0xff == 0) {
445             ret += 1;
446         }
447         return 32 - ret;
448     }
449 
450     /*
451      * @dev Returns a slice containing the entire bytes32, interpreted as a
452      *      null-termintaed utf-8 string.
453      * @param self The bytes32 value to convert to a slice.
454      * @return A new slice containing the value of the input argument up to the
455      *         first null.
456      */
457     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
458         // Allocate space for `self` in memory, copy it there, and point ret at it
459         assembly {
460             let ptr := mload(0x40)
461             mstore(0x40, add(ptr, 0x20))
462             mstore(ptr, self)
463             mstore(add(ret, 0x20), ptr)
464         }
465         ret._len = len(self);
466     }
467 
468     /*
469      * @dev Returns a new slice containing the same data as the current slice.
470      * @param self The slice to copy.
471      * @return A new slice containing the same data as `self`.
472      */
473     function copy(slice self) internal pure returns (slice) {
474         return slice(self._len, self._ptr);
475     }
476 
477     /*
478      * @dev Copies a slice to a new string.
479      * @param self The slice to copy.
480      * @return A newly allocated string containing the slice's text.
481      */
482     function toString(slice self) internal pure returns (string) {
483         string memory ret = new string(self._len);
484         uint retptr;
485         assembly {retptr := add(ret, 32)}
486 
487         memcpy(retptr, self._ptr, self._len);
488         return ret;
489     }
490 
491     /*
492      * @dev Returns the length in runes of the slice. Note that this operation
493      *      takes time proportional to the length of the slice; avoid using it
494      *      in loops, and call `slice.empty()` if you only need to know whether
495      *      the slice is empty or not.
496      * @param self The slice to operate on.
497      * @return The length of the slice in runes.
498      */
499     function len(slice self) internal pure returns (uint l) {
500         // Starting at ptr-31 means the LSB will be the byte we care about
501         uint ptr = self._ptr - 31;
502         uint end = ptr + self._len;
503         for (l = 0; ptr < end; l++) {
504             uint8 b;
505             assembly {b := and(mload(ptr), 0xFF)}
506             if (b < 0x80) {
507                 ptr += 1;
508             } else if (b < 0xE0) {
509                 ptr += 2;
510             } else if (b < 0xF0) {
511                 ptr += 3;
512             } else if (b < 0xF8) {
513                 ptr += 4;
514             } else if (b < 0xFC) {
515                 ptr += 5;
516             } else {
517                 ptr += 6;
518             }
519         }
520     }
521 
522     /*
523      * @dev Returns true if the slice is empty (has a length of 0).
524      * @param self The slice to operate on.
525      * @return True if the slice is empty, False otherwise.
526      */
527     function empty(slice self) internal pure returns (bool) {
528         return self._len == 0;
529     }
530 
531     /*
532      * @dev Returns a positive number if `other` comes lexicographically after
533      *      `self`, a negative number if it comes before, or zero if the
534      *      contents of the two slices are equal. Comparison is done per-rune,
535      *      on unicode codepoints.
536      * @param self The first slice to compare.
537      * @param other The second slice to compare.
538      * @return The result of the comparison.
539      */
540     function compare(slice self, slice other) internal pure returns (int) {
541         uint shortest = self._len;
542         if (other._len < self._len)
543             shortest = other._len;
544 
545         uint selfptr = self._ptr;
546         uint otherptr = other._ptr;
547         for (uint idx = 0; idx < shortest; idx += 32) {
548             uint a;
549             uint b;
550             assembly {
551                 a := mload(selfptr)
552                 b := mload(otherptr)
553             }
554             if (a != b) {
555                 // Mask out irrelevant bytes and check again
556                 uint256 mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
557                 uint256 diff = (a & mask) - (b & mask);
558                 if (diff != 0)
559                     return int(diff);
560             }
561             selfptr += 32;
562             otherptr += 32;
563         }
564         return int(self._len) - int(other._len);
565     }
566 
567     /*
568      * @dev Returns true if the two slices contain the same text.
569      * @param self The first slice to compare.
570      * @param self The second slice to compare.
571      * @return True if the slices are equal, false otherwise.
572      */
573     function equals(slice self, slice other) internal pure returns (bool) {
574         return compare(self, other) == 0;
575     }
576 
577     /*
578      * @dev Extracts the first rune in the slice into `rune`, advancing the
579      *      slice to point to the next rune and returning `self`.
580      * @param self The slice to operate on.
581      * @param rune The slice that will contain the first rune.
582      * @return `rune`.
583      */
584     function nextRune(slice self, slice rune) internal pure returns (slice) {
585         rune._ptr = self._ptr;
586 
587         if (self._len == 0) {
588             rune._len = 0;
589             return rune;
590         }
591 
592         uint l;
593         uint b;
594         // Load the first byte of the rune into the LSBs of b
595         assembly {b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF)}
596         if (b < 0x80) {
597             l = 1;
598         } else if (b < 0xE0) {
599             l = 2;
600         } else if (b < 0xF0) {
601             l = 3;
602         } else {
603             l = 4;
604         }
605 
606         // Check for truncated codepoints
607         if (l > self._len) {
608             rune._len = self._len;
609             self._ptr += self._len;
610             self._len = 0;
611             return rune;
612         }
613 
614         self._ptr += l;
615         self._len -= l;
616         rune._len = l;
617         return rune;
618     }
619 
620     /*
621      * @dev Returns the first rune in the slice, advancing the slice to point
622      *      to the next rune.
623      * @param self The slice to operate on.
624      * @return A slice containing only the first rune from `self`.
625      */
626     function nextRune(slice self) internal pure returns (slice ret) {
627         nextRune(self, ret);
628     }
629 
630     /*
631      * @dev Returns the number of the first codepoint in the slice.
632      * @param self The slice to operate on.
633      * @return The number of the first codepoint in the slice.
634      */
635     function ord(slice self) internal pure returns (uint ret) {
636         if (self._len == 0) {
637             return 0;
638         }
639 
640         uint word;
641         uint length;
642         uint divisor = 2 ** 248;
643 
644         // Load the rune into the MSBs of b
645         assembly {word := mload(mload(add(self, 32)))}
646         uint b = word / divisor;
647         if (b < 0x80) {
648             ret = b;
649             length = 1;
650         } else if (b < 0xE0) {
651             ret = b & 0x1F;
652             length = 2;
653         } else if (b < 0xF0) {
654             ret = b & 0x0F;
655             length = 3;
656         } else {
657             ret = b & 0x07;
658             length = 4;
659         }
660 
661         // Check for truncated codepoints
662         if (length > self._len) {
663             return 0;
664         }
665 
666         for (uint i = 1; i < length; i++) {
667             divisor = divisor / 256;
668             b = (word / divisor) & 0xFF;
669             if (b & 0xC0 != 0x80) {
670                 // Invalid UTF-8 sequence
671                 return 0;
672             }
673             ret = (ret * 64) | (b & 0x3F);
674         }
675 
676         return ret;
677     }
678 
679     /*
680      * @dev Returns the keccak-256 hash of the slice.
681      * @param self The slice to hash.
682      * @return The hash of the slice.
683      */
684     function keccak(slice self) internal pure returns (bytes32 ret) {
685         assembly {
686             ret := keccak256(mload(add(self, 32)), mload(self))
687         }
688     }
689 
690     /*
691      * @dev Returns true if `self` starts with `needle`.
692      * @param self The slice to operate on.
693      * @param needle The slice to search for.
694      * @return True if the slice starts with the provided text, false otherwise.
695      */
696     function startsWith(slice self, slice needle) internal pure returns (bool) {
697         if (self._len < needle._len) {
698             return false;
699         }
700 
701         if (self._ptr == needle._ptr) {
702             return true;
703         }
704 
705         bool equal;
706         assembly {
707             let length := mload(needle)
708             let selfptr := mload(add(self, 0x20))
709             let needleptr := mload(add(needle, 0x20))
710             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
711         }
712         return equal;
713     }
714 
715     /*
716      * @dev If `self` starts with `needle`, `needle` is removed from the
717      *      beginning of `self`. Otherwise, `self` is unmodified.
718      * @param self The slice to operate on.
719      * @param needle The slice to search for.
720      * @return `self`
721      */
722     function beyond(slice self, slice needle) internal pure returns (slice) {
723         if (self._len < needle._len) {
724             return self;
725         }
726 
727         bool equal = true;
728         if (self._ptr != needle._ptr) {
729             assembly {
730                 let length := mload(needle)
731                 let selfptr := mload(add(self, 0x20))
732                 let needleptr := mload(add(needle, 0x20))
733                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
734             }
735         }
736 
737         if (equal) {
738             self._len -= needle._len;
739             self._ptr += needle._len;
740         }
741 
742         return self;
743     }
744 
745     /*
746      * @dev Returns true if the slice ends with `needle`.
747      * @param self The slice to operate on.
748      * @param needle The slice to search for.
749      * @return True if the slice starts with the provided text, false otherwise.
750      */
751     function endsWith(slice self, slice needle) internal pure returns (bool) {
752         if (self._len < needle._len) {
753             return false;
754         }
755 
756         uint selfptr = self._ptr + self._len - needle._len;
757 
758         if (selfptr == needle._ptr) {
759             return true;
760         }
761 
762         bool equal;
763         assembly {
764             let length := mload(needle)
765             let needleptr := mload(add(needle, 0x20))
766             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
767         }
768 
769         return equal;
770     }
771 
772     /*
773      * @dev If `self` ends with `needle`, `needle` is removed from the
774      *      end of `self`. Otherwise, `self` is unmodified.
775      * @param self The slice to operate on.
776      * @param needle The slice to search for.
777      * @return `self`
778      */
779     function until(slice self, slice needle) internal pure returns (slice) {
780         if (self._len < needle._len) {
781             return self;
782         }
783 
784         uint selfptr = self._ptr + self._len - needle._len;
785         bool equal = true;
786         if (selfptr != needle._ptr) {
787             assembly {
788                 let length := mload(needle)
789                 let needleptr := mload(add(needle, 0x20))
790                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
791             }
792         }
793 
794         if (equal) {
795             self._len -= needle._len;
796         }
797 
798         return self;
799     }
800 
801     event log_bytemask(bytes32 mask);
802 
803     // Returns the memory address of the first byte of the first occurrence of
804     // `needle` in `self`, or the first byte after `self` if not found.
805     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
806         uint ptr = selfptr;
807         uint idx;
808 
809         if (needlelen <= selflen) {
810             if (needlelen <= 32) {
811                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
812 
813                 bytes32 needledata;
814                 assembly {needledata := and(mload(needleptr), mask)}
815 
816                 uint end = selfptr + selflen - needlelen;
817                 bytes32 ptrdata;
818                 assembly {ptrdata := and(mload(ptr), mask)}
819 
820                 while (ptrdata != needledata) {
821                     if (ptr >= end)
822                         return selfptr + selflen;
823                     ptr++;
824                     assembly {ptrdata := and(mload(ptr), mask)}
825                 }
826                 return ptr;
827             } else {
828                 // For long needles, use hashing
829                 bytes32 hash;
830                 assembly {hash := sha3(needleptr, needlelen)}
831 
832                 for (idx = 0; idx <= selflen - needlelen; idx++) {
833                     bytes32 testHash;
834                     assembly {testHash := sha3(ptr, needlelen)}
835                     if (hash == testHash)
836                         return ptr;
837                     ptr += 1;
838                 }
839             }
840         }
841         return selfptr + selflen;
842     }
843 
844     // Returns the memory address of the first byte after the last occurrence of
845     // `needle` in `self`, or the address of `self` if not found.
846     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
847         uint ptr;
848 
849         if (needlelen <= selflen) {
850             if (needlelen <= 32) {
851                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
852 
853                 bytes32 needledata;
854                 assembly {needledata := and(mload(needleptr), mask)}
855 
856                 ptr = selfptr + selflen - needlelen;
857                 bytes32 ptrdata;
858                 assembly {ptrdata := and(mload(ptr), mask)}
859 
860                 while (ptrdata != needledata) {
861                     if (ptr <= selfptr)
862                         return selfptr;
863                     ptr--;
864                     assembly {ptrdata := and(mload(ptr), mask)}
865                 }
866                 return ptr + needlelen;
867             } else {
868                 // For long needles, use hashing
869                 bytes32 hash;
870                 assembly {hash := sha3(needleptr, needlelen)}
871                 ptr = selfptr + (selflen - needlelen);
872                 while (ptr >= selfptr) {
873                     bytes32 testHash;
874                     assembly {testHash := sha3(ptr, needlelen)}
875                     if (hash == testHash)
876                         return ptr + needlelen;
877                     ptr -= 1;
878                 }
879             }
880         }
881         return selfptr;
882     }
883 
884     /*
885      * @dev Modifies `self` to contain everything from the first occurrence of
886      *      `needle` to the end of the slice. `self` is set to the empty slice
887      *      if `needle` is not found.
888      * @param self The slice to search and modify.
889      * @param needle The text to search for.
890      * @return `self`.
891      */
892     function find(slice self, slice needle) internal pure returns (slice) {
893         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
894         self._len -= ptr - self._ptr;
895         self._ptr = ptr;
896         return self;
897     }
898 
899     /*
900      * @dev Modifies `self` to contain the part of the string from the start of
901      *      `self` to the end of the first occurrence of `needle`. If `needle`
902      *      is not found, `self` is set to the empty slice.
903      * @param self The slice to search and modify.
904      * @param needle The text to search for.
905      * @return `self`.
906      */
907     function rfind(slice self, slice needle) internal pure returns (slice) {
908         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
909         self._len = ptr - self._ptr;
910         return self;
911     }
912 
913     /*
914      * @dev Splits the slice, setting `self` to everything after the first
915      *      occurrence of `needle`, and `token` to everything before it. If
916      *      `needle` does not occur in `self`, `self` is set to the empty slice,
917      *      and `token` is set to the entirety of `self`.
918      * @param self The slice to split.
919      * @param needle The text to search for in `self`.
920      * @param token An output parameter to which the first token is written.
921      * @return `token`.
922      */
923     function split(slice self, slice needle, slice token) internal pure returns (slice) {
924         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
925         token._ptr = self._ptr;
926         token._len = ptr - self._ptr;
927         if (ptr == self._ptr + self._len) {
928             // Not found
929             self._len = 0;
930         } else {
931             self._len -= token._len + needle._len;
932             self._ptr = ptr + needle._len;
933         }
934         return token;
935     }
936 
937     /*
938      * @dev Splits the slice, setting `self` to everything after the first
939      *      occurrence of `needle`, and returning everything before it. If
940      *      `needle` does not occur in `self`, `self` is set to the empty slice,
941      *      and the entirety of `self` is returned.
942      * @param self The slice to split.
943      * @param needle The text to search for in `self`.
944      * @return The part of `self` up to the first occurrence of `delim`.
945      */
946     function split(slice self, slice needle) internal pure returns (slice token) {
947         split(self, needle, token);
948     }
949 
950     /*
951      * @dev Splits the slice, setting `self` to everything before the last
952      *      occurrence of `needle`, and `token` to everything after it. If
953      *      `needle` does not occur in `self`, `self` is set to the empty slice,
954      *      and `token` is set to the entirety of `self`.
955      * @param self The slice to split.
956      * @param needle The text to search for in `self`.
957      * @param token An output parameter to which the first token is written.
958      * @return `token`.
959      */
960     function rsplit(slice self, slice needle, slice token) internal pure returns (slice) {
961         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
962         token._ptr = ptr;
963         token._len = self._len - (ptr - self._ptr);
964         if (ptr == self._ptr) {
965             // Not found
966             self._len = 0;
967         } else {
968             self._len -= token._len + needle._len;
969         }
970         return token;
971     }
972 
973     /*
974      * @dev Splits the slice, setting `self` to everything before the last
975      *      occurrence of `needle`, and returning everything after it. If
976      *      `needle` does not occur in `self`, `self` is set to the empty slice,
977      *      and the entirety of `self` is returned.
978      * @param self The slice to split.
979      * @param needle The text to search for in `self`.
980      * @return The part of `self` after the last occurrence of `delim`.
981      */
982     function rsplit(slice self, slice needle) internal pure returns (slice token) {
983         rsplit(self, needle, token);
984     }
985 
986     /*
987      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
988      * @param self The slice to search.
989      * @param needle The text to search for in `self`.
990      * @return The number of occurrences of `needle` found in `self`.
991      */
992     function count(slice self, slice needle) internal pure returns (uint cnt) {
993         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
994         while (ptr <= self._ptr + self._len) {
995             cnt++;
996             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
997         }
998     }
999 
1000     /*
1001      * @dev Returns True if `self` contains `needle`.
1002      * @param self The slice to search.
1003      * @param needle The text to search for in `self`.
1004      * @return True if `needle` is found in `self`, false otherwise.
1005      */
1006     function contains(slice self, slice needle) internal pure returns (bool) {
1007         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1008     }
1009 
1010     /*
1011      * @dev Returns a newly allocated string containing the concatenation of
1012      *      `self` and `other`.
1013      * @param self The first slice to concatenate.
1014      * @param other The second slice to concatenate.
1015      * @return The concatenation of the two strings.
1016      */
1017     function concat(slice self, slice other) internal pure returns (string) {
1018         string memory ret = new string(self._len + other._len);
1019         uint retptr;
1020         assembly {retptr := add(ret, 32)}
1021         memcpy(retptr, self._ptr, self._len);
1022         memcpy(retptr + self._len, other._ptr, other._len);
1023         return ret;
1024     }
1025 
1026     /*
1027      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1028      *      newly allocated string.
1029      * @param self The delimiter to use.
1030      * @param parts A list of slices to join.
1031      * @return A newly allocated string containing all the slices in `parts`,
1032      *         joined with `self`.
1033      */
1034     function join(slice self, slice[] parts) internal pure returns (string) {
1035         if (parts.length == 0)
1036             return "";
1037 
1038         uint length = self._len * (parts.length - 1);
1039         for (uint i = 0; i < parts.length; i++)
1040             length += parts[i]._len;
1041 
1042         string memory ret = new string(length);
1043         uint retptr;
1044         assembly {retptr := add(ret, 32)}
1045 
1046         for (i = 0; i < parts.length; i++) {
1047             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1048             retptr += parts[i]._len;
1049             if (i < parts.length - 1) {
1050                 memcpy(retptr, self._ptr, self._len);
1051                 retptr += self._len;
1052             }
1053         }
1054 
1055         return ret;
1056     }
1057 
1058     /*
1059     * Additions by the FundRequest Team
1060     */
1061 
1062     function toBytes32(slice self) internal pure returns (bytes32 result) {
1063         string memory source = toString(self);
1064         bytes memory tempEmptyStringTest = bytes(source);
1065         if (tempEmptyStringTest.length == 0) {
1066             return 0x0;
1067         }
1068 
1069         assembly {
1070             result := mload(add(source, 32))
1071         }
1072     }
1073 
1074     function strConcat(string _a, string _b, string _c, string _d, string _e) pure internal returns (string){
1075         bytes memory _ba = bytes(_a);
1076         bytes memory _bb = bytes(_b);
1077         bytes memory _bc = bytes(_c);
1078         bytes memory _bd = bytes(_d);
1079         bytes memory _be = bytes(_e);
1080         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1081         bytes memory babcde = bytes(abcde);
1082         uint k = 0;
1083         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1084         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1085         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1086         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1087         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1088         return string(babcde);
1089     }
1090 
1091     function strConcat(string _a, string _b, string _c, string _d) pure internal returns (string) {
1092         return strConcat(_a, _b, _c, _d, "");
1093     }
1094 
1095     function strConcat(string _a, string _b, string _c) pure internal returns (string) {
1096         return strConcat(_a, _b, _c, "", "");
1097     }
1098 
1099     function strConcat(string _a, string _b) pure internal returns (string) {
1100         return strConcat(_a, _b, "", "", "");
1101     }
1102 
1103     function addressToString(address x) internal pure returns (string) {
1104         bytes memory s = new bytes(40);
1105         for (uint i = 0; i < 20; i++) {
1106             byte b = byte(uint8(uint(x) / (2 ** (8 * (19 - i)))));
1107             byte hi = byte(uint8(b) / 16);
1108             byte lo = byte(uint8(b) - 16 * uint8(hi));
1109             s[2 * i] = charToByte(hi);
1110             s[2 * i + 1] = charToByte(lo);
1111         }
1112         return strConcat("0x", string(s));
1113     }
1114 
1115     function charToByte(byte b) internal pure returns (byte c) {
1116         if (b < 10) return byte(uint8(b) + 0x30);
1117         else return byte(uint8(b) + 0x57);
1118     }
1119 
1120     function bytes32ToString(bytes32 x) internal pure returns (string) {
1121         bytes memory bytesString = new bytes(32);
1122         uint charCount = 0;
1123         for (uint j = 0; j < 32; j++) {
1124             byte ch = byte(bytes32(uint(x) * 2 ** (8 * j)));
1125             if (ch != 0) {
1126                 bytesString[charCount] = ch;
1127                 charCount++;
1128             }
1129         }
1130         bytes memory bytesStringTrimmed = new bytes(charCount);
1131         for (j = 0; j < charCount; j++) {
1132             bytesStringTrimmed[j] = bytesString[j];
1133         }
1134         return string(bytesStringTrimmed);
1135     }
1136 }
1137 
1138 contract Precondition is Owned {
1139 
1140     string public name;
1141     uint public version;
1142     bool public active = false;
1143 
1144     constructor(string _name, uint _version, bool _active) public {
1145         name = _name;
1146         version = _version;
1147         active = _active;
1148     }
1149 
1150     function setActive(bool _active) external onlyOwner {
1151         active = _active;
1152     }
1153 
1154     function isValid(bytes32 _platform, string _platformId, address _token, uint256 _value, address _funder) external view returns (bool valid);
1155 }
1156 
1157 /*
1158  * Main FundRequest Contract
1159  * Davy Van Roy
1160  * Quinten De Swaef
1161  */
1162 contract FundRequestContract is Owned, ApproveAndCallFallBack {
1163 
1164     using SafeMath for uint256;
1165     using strings for *;
1166 
1167     event Funded(address indexed from, bytes32 platform, string platformId, address token, uint256 value);
1168 
1169     event Claimed(address indexed solverAddress, bytes32 platform, string platformId, string solver, address token, uint256 value);
1170 
1171     address public ETHER_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
1172 
1173     //repositories
1174     FundRepository public fundRepository;
1175 
1176     ClaimRepository public claimRepository;
1177 
1178     address public claimSignerAddress;
1179 
1180     Precondition[] public preconditions;
1181 
1182     modifier addressNotNull(address target) {
1183         require(target != address(0), "target address can not be 0x0");
1184         _;
1185     }
1186 
1187     constructor(address _fundRepository, address _claimRepository) public {
1188         setFundRepository(_fundRepository);
1189         setClaimRepository(_claimRepository);
1190     }
1191 
1192     //entrypoints
1193     function fund(bytes32 _platform, string _platformId, address _token, uint256 _value) external returns (bool success) {
1194         require(doFunding(_platform, _platformId, _token, _value, msg.sender), "funding with token failed");
1195         return true;
1196     }
1197 
1198     function etherFund(bytes32 _platform, string _platformId) payable external returns (bool success) {
1199         require(doFunding(_platform, _platformId, ETHER_ADDRESS, msg.value, msg.sender), "funding with ether failed");
1200         return true;
1201     }
1202 
1203     function receiveApproval(address _from, uint _amount, address _token, bytes _data) public {
1204         var sliced = string(_data).toSlice();
1205         var platform = sliced.split("|AAC|".toSlice());
1206         var platformId = sliced.split("|AAC|".toSlice());
1207         require(doFunding(platform.toBytes32(), platformId.toString(), _token, _amount, _from));
1208     }
1209 
1210     function doFunding(bytes32 _platform, string _platformId, address _token, uint256 _value, address _funder) internal returns (bool success) {
1211         if(_token == ETHER_ADDRESS) {
1212             //must check this, so we don't have people foefeling with the amounts
1213             require(msg.value == _value);
1214         }
1215         require(!fundRepository.issueResolved(_platform, _platformId), "Can't fund tokens, platformId already claimed");
1216         for (uint idx = 0; idx < preconditions.length; idx++) {
1217             if (address(preconditions[idx]) != address(0)) {
1218                 require(preconditions[idx].isValid(_platform, _platformId, _token, _value, _funder));
1219             }
1220         }
1221         require(_value > 0, "amount of tokens needs to be more than 0");
1222 
1223         if(_token != ETHER_ADDRESS) {
1224             require(ERC20(_token).transferFrom(_funder, address(this), _value), "Transfer of tokens to contract failed");
1225         }
1226 
1227         fundRepository.updateFunders(_funder, _platform, _platformId);
1228         fundRepository.updateBalances(_funder, _platform, _platformId, _token, _value);
1229         emit Funded(_funder, _platform, _platformId, _token, _value);
1230         return true;
1231     }
1232 
1233     function claim(bytes32 platform, string platformId, string solver, address solverAddress, bytes32 r, bytes32 s, uint8 v) public returns (bool) {
1234         require(validClaim(platform, platformId, solver, solverAddress, r, s, v), "Claimsignature was not valid");
1235         uint256 tokenCount = fundRepository.getFundedTokenCount(platform, platformId);
1236         for (uint i = 0; i < tokenCount; i++) {
1237             address token = fundRepository.getFundedTokensByIndex(platform, platformId, i);
1238             uint256 tokenAmount = fundRepository.claimToken(platform, platformId, token);
1239             if(token == ETHER_ADDRESS) {
1240                 solverAddress.transfer(tokenAmount);
1241             } else {
1242                 require(ERC20(token).transfer(solverAddress, tokenAmount), "transfer of tokens from contract failed");
1243             }
1244             require(claimRepository.addClaim(solverAddress, platform, platformId, solver, token, tokenAmount), "adding claim to repository failed");
1245             emit Claimed(solverAddress, platform, platformId, solver, token, tokenAmount);
1246         }
1247         require(fundRepository.finishResolveFund(platform, platformId), "Resolving the fund failed");
1248         return true;
1249     }
1250 
1251     function validClaim(bytes32 platform, string platformId, string solver, address solverAddress, bytes32 r, bytes32 s, uint8 v) internal view returns (bool) {
1252         bytes32 h = keccak256(abi.encodePacked(createClaimMsg(platform, platformId, solver, solverAddress)));
1253         address signerAddress = ecrecover(h, v, r, s);
1254         return claimSignerAddress == signerAddress;
1255     }
1256 
1257     function createClaimMsg(bytes32 platform, string platformId, string solver, address solverAddress) internal pure returns (string) {
1258         return strings.bytes32ToString(platform)
1259         .strConcat(prependUnderscore(platformId))
1260         .strConcat(prependUnderscore(solver))
1261         .strConcat(prependUnderscore(strings.addressToString(solverAddress)));
1262     }
1263 
1264     function addPrecondition(address _precondition) external onlyOwner {
1265         preconditions.push(Precondition(_precondition));
1266     }
1267 
1268     function removePrecondition(uint _index) external onlyOwner {
1269         if (_index >= preconditions.length) return;
1270 
1271         for (uint i = _index; i < preconditions.length-1; i++) {
1272             preconditions[i] = preconditions[i+1];
1273         }
1274 
1275         delete preconditions[preconditions.length-1];
1276         preconditions.length--;
1277     }
1278 
1279     function setFundRepository(address _repositoryAddress) public onlyOwner {
1280         fundRepository = FundRepository(_repositoryAddress);
1281     }
1282 
1283     function setClaimRepository(address _claimRepository) public onlyOwner {
1284         claimRepository = ClaimRepository(_claimRepository);
1285     }
1286 
1287     function setClaimSignerAddress(address _claimSignerAddress) addressNotNull(_claimSignerAddress) public onlyOwner {
1288         claimSignerAddress = _claimSignerAddress;
1289     }
1290 
1291     function prependUnderscore(string str) internal pure returns (string) {
1292         return "_".strConcat(str);
1293     }
1294 
1295     //required to be able to migrate to a new FundRequestContract
1296     function migrateTokens(address _token, address newContract) external onlyOwner {
1297         require(newContract != address(0));
1298         if(_token == ETHER_ADDRESS) {
1299             newContract.transfer(address(this).balance);
1300         } else {
1301             ERC20 token = ERC20(_token);
1302             token.transfer(newContract, token.balanceOf(address(this)));
1303         }
1304     }
1305 
1306     //required should there be an issue with available ether
1307     function deposit() external onlyOwner payable {
1308         require(msg.value > 0, "Should at least be 1 wei deposited");
1309     }
1310 }