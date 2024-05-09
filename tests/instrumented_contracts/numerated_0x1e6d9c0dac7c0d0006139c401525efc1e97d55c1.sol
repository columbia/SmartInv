1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Basic token
17  * @dev Basic version of StandardToken, with no allowances.
18  */
19 contract BasicToken is ERC20Basic {
20   using SafeMath for uint256;
21 
22   mapping(address => uint256) balances;
23 
24   uint256 totalSupply_;
25 
26   /**
27   * @dev Total number of tokens in existence
28   */
29   function totalSupply() public view returns (uint256) {
30     return totalSupply_;
31   }
32 
33   /**
34   * @dev Transfer token for a specified address
35   * @param _to The address to transfer to.
36   * @param _value The amount to be transferred.
37   */
38   function transfer(address _to, uint256 _value) public returns (bool) {
39     require(_to != address(0));
40     require(_value <= balances[msg.sender]);
41 
42     balances[msg.sender] = balances[msg.sender].sub(_value);
43     balances[_to] = balances[_to].add(_value);
44     emit Transfer(msg.sender, _to, _value);
45     return true;
46   }
47 
48   /**
49   * @dev Gets the balance of the specified address.
50   * @param _owner The address to query the the balance of.
51   * @return An uint256 representing the amount owned by the passed address.
52   */
53   function balanceOf(address _owner) public view returns (uint256) {
54     return balances[_owner];
55   }
56 
57 }
58 
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender)
66     public view returns (uint256);
67 
68   function transferFrom(address from, address to, uint256 value)
69     public returns (bool);
70 
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(
73     address indexed owner,
74     address indexed spender,
75     uint256 value
76   );
77 }
78 
79 
80 /**
81  * @title Standard ERC20 token
82  *
83  * @dev Implementation of the basic standard token.
84  * https://github.com/ethereum/EIPs/issues/20
85  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
86  */
87 contract StandardToken is ERC20, BasicToken {
88 
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91 
92   /**
93    * @dev Transfer tokens from one address to another
94    * @param _from address The address which you want to send tokens from
95    * @param _to address The address which you want to transfer to
96    * @param _value uint256 the amount of tokens to be transferred
97    */
98   function transferFrom(
99     address _from,
100     address _to,
101     uint256 _value
102   )
103     public
104     returns (bool)
105   {
106     require(_to != address(0));
107     require(_value <= balances[_from]);
108     require(_value <= allowed[_from][msg.sender]);
109 
110     balances[_from] = balances[_from].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113     emit Transfer(_from, _to, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
119    * Beware that changing an allowance with this method brings the risk that someone may use both the old
120    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
121    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
122    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) public returns (bool) {
127     allowed[msg.sender][_spender] = _value;
128     emit Approval(msg.sender, _spender, _value);
129     return true;
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param _owner address The address which owns the funds.
135    * @param _spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address _owner,
140     address _spender
141    )
142     public
143     view
144     returns (uint256)
145   {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150    * @dev Increase the amount of tokens that an owner allowed to a spender.
151    * approve should be called when allowed[_spender] == 0. To increment
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    * @param _spender The address which will spend the funds.
156    * @param _addedValue The amount of tokens to increase the allowance by.
157    */
158   function increaseApproval(
159     address _spender,
160     uint256 _addedValue
161   )
162     public
163     returns (bool)
164   {
165     allowed[msg.sender][_spender] = (
166       allowed[msg.sender][_spender].add(_addedValue));
167     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   /**
172    * @dev Decrease the amount of tokens that an owner allowed to a spender.
173    * approve should be called when allowed[_spender] == 0. To decrement
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _subtractedValue The amount of tokens to decrease the allowance by.
179    */
180   function decreaseApproval(
181     address _spender,
182     uint256 _subtractedValue
183   )
184     public
185     returns (bool)
186   {
187     uint256 oldValue = allowed[msg.sender][_spender];
188     if (_subtractedValue > oldValue) {
189       allowed[msg.sender][_spender] = 0;
190     } else {
191       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
192     }
193     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197 }
198 
199 
200 /**
201  * @title Ownable
202  * @dev The Ownable contract has an owner address, and provides basic authorization control
203  * functions, this simplifies the implementation of "user permissions".
204  */
205 contract Ownable {
206   address public owner;
207 
208 
209   event OwnershipRenounced(address indexed previousOwner);
210   event OwnershipTransferred(
211     address indexed previousOwner,
212     address indexed newOwner
213   );
214 
215 
216   /**
217    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
218    * account.
219    */
220   constructor() public {
221     owner = msg.sender;
222   }
223 
224   /**
225    * @dev Throws if called by any account other than the owner.
226    */
227   modifier onlyOwner() {
228     require(msg.sender == owner);
229     _;
230   }
231 
232   /**
233    * @dev Allows the current owner to relinquish control of the contract.
234    * @notice Renouncing to ownership will leave the contract without an owner.
235    * It will not be possible to call the functions with the `onlyOwner`
236    * modifier anymore.
237    */
238   function renounceOwnership() public onlyOwner {
239     emit OwnershipRenounced(owner);
240     owner = address(0);
241   }
242 
243   /**
244    * @dev Allows the current owner to transfer control of the contract to a newOwner.
245    * @param _newOwner The address to transfer ownership to.
246    */
247   function transferOwnership(address _newOwner) public onlyOwner {
248     _transferOwnership(_newOwner);
249   }
250 
251   /**
252    * @dev Transfers control of the contract to a newOwner.
253    * @param _newOwner The address to transfer ownership to.
254    */
255   function _transferOwnership(address _newOwner) internal {
256     require(_newOwner != address(0));
257     emit OwnershipTransferred(owner, _newOwner);
258     owner = _newOwner;
259   }
260 }
261 
262 
263 /*
264  * @title String & slice utility library for Solidity contracts.
265  * @author Nick Johnson <arachnid@notdot.net>
266  *
267  * @dev Functionality in this library is largely implemented using an
268  *      abstraction called a 'slice'. A slice represents a part of a string -
269  *      anything from the entire string to a single character, or even no
270  *      characters at all (a 0-length slice). Since a slice only has to specify
271  *      an offset and a length, copying and manipulating slices is a lot less
272  *      expensive than copying and manipulating the strings they reference.
273  *
274  *      To further reduce gas costs, most functions on slice that need to return
275  *      a slice modify the original one instead of allocating a new one; for
276  *      instance, `s.split(".")` will return the text up to the first '.',
277  *      modifying s to only contain the remainder of the string after the '.'.
278  *      In situations where you do not want to modify the original slice, you
279  *      can make a copy first with `.copy()`, for example:
280  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
281  *      Solidity has no memory management, it will result in allocating many
282  *      short-lived slices that are later discarded.
283  *
284  *      Functions that return two slices come in two versions: a non-allocating
285  *      version that takes the second slice as an argument, modifying it in
286  *      place, and an allocating version that allocates and returns the second
287  *      slice; see `nextRune` for example.
288  *
289  *      Functions that have to copy string data will return strings rather than
290  *      slices; these can be cast back to slices for further processing if
291  *      required.
292  *
293  *      For convenience, some functions are provided with non-modifying
294  *      variants that create a new slice and return both; for instance,
295  *      `s.splitNew('.')` leaves s unmodified, and returns two values
296  *      corresponding to the left and right parts of the string.
297  */
298 
299 library strings {
300     struct slice {
301         uint _len;
302         uint _ptr;
303     }
304 
305     function memcpy(uint dest, uint src, uint len) private pure {
306         // Copy word-length chunks while possible
307         for(; len >= 32; len -= 32) {
308             assembly {
309                 mstore(dest, mload(src))
310             }
311             dest += 32;
312             src += 32;
313         }
314 
315         // Copy remaining bytes
316         uint mask = 256 ** (32 - len) - 1;
317         assembly {
318             let srcpart := and(mload(src), not(mask))
319             let destpart := and(mload(dest), mask)
320             mstore(dest, or(destpart, srcpart))
321         }
322     }
323 
324     /*
325      * @dev Returns a slice containing the entire string.
326      * @param self The string to make a slice from.
327      * @return A newly allocated slice containing the entire string.
328      */
329     function toSlice(string self) internal pure returns (slice) {
330         uint ptr;
331         assembly {
332             ptr := add(self, 0x20)
333         }
334         return slice(bytes(self).length, ptr);
335     }
336 
337     /*
338      * @dev Returns the length of a null-terminated bytes32 string.
339      * @param self The value to find the length of.
340      * @return The length of the string, from 0 to 32.
341      */
342     function len(bytes32 self) internal pure returns (uint) {
343         uint ret;
344         if (self == 0)
345             return 0;
346         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
347             ret += 16;
348             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
349         }
350         if (self & 0xffffffffffffffff == 0) {
351             ret += 8;
352             self = bytes32(uint(self) / 0x10000000000000000);
353         }
354         if (self & 0xffffffff == 0) {
355             ret += 4;
356             self = bytes32(uint(self) / 0x100000000);
357         }
358         if (self & 0xffff == 0) {
359             ret += 2;
360             self = bytes32(uint(self) / 0x10000);
361         }
362         if (self & 0xff == 0) {
363             ret += 1;
364         }
365         return 32 - ret;
366     }
367 
368     /*
369      * @dev Returns a slice containing the entire bytes32, interpreted as a
370      *      null-terminated utf-8 string.
371      * @param self The bytes32 value to convert to a slice.
372      * @return A new slice containing the value of the input argument up to the
373      *         first null.
374      */
375     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
376         // Allocate space for `self` in memory, copy it there, and point ret at it
377         assembly {
378             let ptr := mload(0x40)
379             mstore(0x40, add(ptr, 0x20))
380             mstore(ptr, self)
381             mstore(add(ret, 0x20), ptr)
382         }
383         ret._len = len(self);
384     }
385 
386     /*
387      * @dev Returns a new slice containing the same data as the current slice.
388      * @param self The slice to copy.
389      * @return A new slice containing the same data as `self`.
390      */
391     function copy(slice self) internal pure returns (slice) {
392         return slice(self._len, self._ptr);
393     }
394 
395     /*
396      * @dev Copies a slice to a new string.
397      * @param self The slice to copy.
398      * @return A newly allocated string containing the slice's text.
399      */
400     function toString(slice self) internal pure returns (string) {
401         string memory ret = new string(self._len);
402         uint retptr;
403         assembly { retptr := add(ret, 32) }
404 
405         memcpy(retptr, self._ptr, self._len);
406         return ret;
407     }
408 
409     /*
410      * @dev Returns the length in runes of the slice. Note that this operation
411      *      takes time proportional to the length of the slice; avoid using it
412      *      in loops, and call `slice.empty()` if you only need to know whether
413      *      the slice is empty or not.
414      * @param self The slice to operate on.
415      * @return The length of the slice in runes.
416      */
417     function len(slice self) internal pure returns (uint l) {
418         // Starting at ptr-31 means the LSB will be the byte we care about
419         uint ptr = self._ptr - 31;
420         uint end = ptr + self._len;
421         for (l = 0; ptr < end; l++) {
422             uint8 b;
423             assembly { b := and(mload(ptr), 0xFF) }
424             if (b < 0x80) {
425                 ptr += 1;
426             } else if(b < 0xE0) {
427                 ptr += 2;
428             } else if(b < 0xF0) {
429                 ptr += 3;
430             } else if(b < 0xF8) {
431                 ptr += 4;
432             } else if(b < 0xFC) {
433                 ptr += 5;
434             } else {
435                 ptr += 6;
436             }
437         }
438     }
439 
440     /*
441      * @dev Returns true if the slice is empty (has a length of 0).
442      * @param self The slice to operate on.
443      * @return True if the slice is empty, False otherwise.
444      */
445     function empty(slice self) internal pure returns (bool) {
446         return self._len == 0;
447     }
448 
449     /*
450      * @dev Returns a positive number if `other` comes lexicographically after
451      *      `self`, a negative number if it comes before, or zero if the
452      *      contents of the two slices are equal. Comparison is done per-rune,
453      *      on unicode codepoints.
454      * @param self The first slice to compare.
455      * @param other The second slice to compare.
456      * @return The result of the comparison.
457      */
458     function compare(slice self, slice other) internal pure returns (int) {
459         uint shortest = self._len;
460         if (other._len < self._len)
461             shortest = other._len;
462 
463         uint selfptr = self._ptr;
464         uint otherptr = other._ptr;
465         for (uint idx = 0; idx < shortest; idx += 32) {
466             uint a;
467             uint b;
468             assembly {
469                 a := mload(selfptr)
470                 b := mload(otherptr)
471             }
472             if (a != b) {
473                 // Mask out irrelevant bytes and check again
474                 uint256 mask = uint256(-1); // 0xffff...
475                 if(shortest < 32) {
476                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
477                 }
478                 uint256 diff = (a & mask) - (b & mask);
479                 if (diff != 0)
480                     return int(diff);
481             }
482             selfptr += 32;
483             otherptr += 32;
484         }
485         return int(self._len) - int(other._len);
486     }
487 
488     /*
489      * @dev Returns true if the two slices contain the same text.
490      * @param self The first slice to compare.
491      * @param self The second slice to compare.
492      * @return True if the slices are equal, false otherwise.
493      */
494     function equals(slice self, slice other) internal pure returns (bool) {
495         return compare(self, other) == 0;
496     }
497 
498     /*
499      * @dev Extracts the first rune in the slice into `rune`, advancing the
500      *      slice to point to the next rune and returning `self`.
501      * @param self The slice to operate on.
502      * @param rune The slice that will contain the first rune.
503      * @return `rune`.
504      */
505     function nextRune(slice self, slice rune) internal pure returns (slice) {
506         rune._ptr = self._ptr;
507 
508         if (self._len == 0) {
509             rune._len = 0;
510             return rune;
511         }
512 
513         uint l;
514         uint b;
515         // Load the first byte of the rune into the LSBs of b
516         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
517         if (b < 0x80) {
518             l = 1;
519         } else if(b < 0xE0) {
520             l = 2;
521         } else if(b < 0xF0) {
522             l = 3;
523         } else {
524             l = 4;
525         }
526 
527         // Check for truncated codepoints
528         if (l > self._len) {
529             rune._len = self._len;
530             self._ptr += self._len;
531             self._len = 0;
532             return rune;
533         }
534 
535         self._ptr += l;
536         self._len -= l;
537         rune._len = l;
538         return rune;
539     }
540 
541     /*
542      * @dev Returns the first rune in the slice, advancing the slice to point
543      *      to the next rune.
544      * @param self The slice to operate on.
545      * @return A slice containing only the first rune from `self`.
546      */
547     function nextRune(slice self) internal pure returns (slice ret) {
548         nextRune(self, ret);
549     }
550 
551     /*
552      * @dev Returns the number of the first codepoint in the slice.
553      * @param self The slice to operate on.
554      * @return The number of the first codepoint in the slice.
555      */
556     function ord(slice self) internal pure returns (uint ret) {
557         if (self._len == 0) {
558             return 0;
559         }
560 
561         uint word;
562         uint length;
563         uint divisor = 2 ** 248;
564 
565         // Load the rune into the MSBs of b
566         assembly { word:= mload(mload(add(self, 32))) }
567         uint b = word / divisor;
568         if (b < 0x80) {
569             ret = b;
570             length = 1;
571         } else if(b < 0xE0) {
572             ret = b & 0x1F;
573             length = 2;
574         } else if(b < 0xF0) {
575             ret = b & 0x0F;
576             length = 3;
577         } else {
578             ret = b & 0x07;
579             length = 4;
580         }
581 
582         // Check for truncated codepoints
583         if (length > self._len) {
584             return 0;
585         }
586 
587         for (uint i = 1; i < length; i++) {
588             divisor = divisor / 256;
589             b = (word / divisor) & 0xFF;
590             if (b & 0xC0 != 0x80) {
591                 // Invalid UTF-8 sequence
592                 return 0;
593             }
594             ret = (ret * 64) | (b & 0x3F);
595         }
596 
597         return ret;
598     }
599 
600     /*
601      * @dev Returns the keccak-256 hash of the slice.
602      * @param self The slice to hash.
603      * @return The hash of the slice.
604      */
605     function keccak(slice self) internal pure returns (bytes32 ret) {
606         assembly {
607             ret := keccak256(mload(add(self, 32)), mload(self))
608         }
609     }
610 
611     /*
612      * @dev Returns true if `self` starts with `needle`.
613      * @param self The slice to operate on.
614      * @param needle The slice to search for.
615      * @return True if the slice starts with the provided text, false otherwise.
616      */
617     function startsWith(slice self, slice needle) internal pure returns (bool) {
618         if (self._len < needle._len) {
619             return false;
620         }
621 
622         if (self._ptr == needle._ptr) {
623             return true;
624         }
625 
626         bool equal;
627         assembly {
628             let length := mload(needle)
629             let selfptr := mload(add(self, 0x20))
630             let needleptr := mload(add(needle, 0x20))
631             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
632         }
633         return equal;
634     }
635 
636     /*
637      * @dev If `self` starts with `needle`, `needle` is removed from the
638      *      beginning of `self`. Otherwise, `self` is unmodified.
639      * @param self The slice to operate on.
640      * @param needle The slice to search for.
641      * @return `self`
642      */
643     function beyond(slice self, slice needle) internal pure returns (slice) {
644         if (self._len < needle._len) {
645             return self;
646         }
647 
648         bool equal = true;
649         if (self._ptr != needle._ptr) {
650             assembly {
651                 let length := mload(needle)
652                 let selfptr := mload(add(self, 0x20))
653                 let needleptr := mload(add(needle, 0x20))
654                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
655             }
656         }
657 
658         if (equal) {
659             self._len -= needle._len;
660             self._ptr += needle._len;
661         }
662 
663         return self;
664     }
665 
666     /*
667      * @dev Returns true if the slice ends with `needle`.
668      * @param self The slice to operate on.
669      * @param needle The slice to search for.
670      * @return True if the slice starts with the provided text, false otherwise.
671      */
672     function endsWith(slice self, slice needle) internal pure returns (bool) {
673         if (self._len < needle._len) {
674             return false;
675         }
676 
677         uint selfptr = self._ptr + self._len - needle._len;
678 
679         if (selfptr == needle._ptr) {
680             return true;
681         }
682 
683         bool equal;
684         assembly {
685             let length := mload(needle)
686             let needleptr := mload(add(needle, 0x20))
687             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
688         }
689 
690         return equal;
691     }
692 
693     /*
694      * @dev If `self` ends with `needle`, `needle` is removed from the
695      *      end of `self`. Otherwise, `self` is unmodified.
696      * @param self The slice to operate on.
697      * @param needle The slice to search for.
698      * @return `self`
699      */
700     function until(slice self, slice needle) internal pure returns (slice) {
701         if (self._len < needle._len) {
702             return self;
703         }
704 
705         uint selfptr = self._ptr + self._len - needle._len;
706         bool equal = true;
707         if (selfptr != needle._ptr) {
708             assembly {
709                 let length := mload(needle)
710                 let needleptr := mload(add(needle, 0x20))
711                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
712             }
713         }
714 
715         if (equal) {
716             self._len -= needle._len;
717         }
718 
719         return self;
720     }
721 
722     event log_bytemask(bytes32 mask);
723 
724     // Returns the memory address of the first byte of the first occurrence of
725     // `needle` in `self`, or the first byte after `self` if not found.
726     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
727         uint ptr = selfptr;
728         uint idx;
729 
730         if (needlelen <= selflen) {
731             if (needlelen <= 32) {
732                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
733 
734                 bytes32 needledata;
735                 assembly { needledata := and(mload(needleptr), mask) }
736 
737                 uint end = selfptr + selflen - needlelen;
738                 bytes32 ptrdata;
739                 assembly { ptrdata := and(mload(ptr), mask) }
740 
741                 while (ptrdata != needledata) {
742                     if (ptr >= end)
743                         return selfptr + selflen;
744                     ptr++;
745                     assembly { ptrdata := and(mload(ptr), mask) }
746                 }
747                 return ptr;
748             } else {
749                 // For long needles, use hashing
750                 bytes32 hash;
751                 assembly { hash := sha3(needleptr, needlelen) }
752 
753                 for (idx = 0; idx <= selflen - needlelen; idx++) {
754                     bytes32 testHash;
755                     assembly { testHash := sha3(ptr, needlelen) }
756                     if (hash == testHash)
757                         return ptr;
758                     ptr += 1;
759                 }
760             }
761         }
762         return selfptr + selflen;
763     }
764 
765     // Returns the memory address of the first byte after the last occurrence of
766     // `needle` in `self`, or the address of `self` if not found.
767     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
768         uint ptr;
769 
770         if (needlelen <= selflen) {
771             if (needlelen <= 32) {
772                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
773 
774                 bytes32 needledata;
775                 assembly { needledata := and(mload(needleptr), mask) }
776 
777                 ptr = selfptr + selflen - needlelen;
778                 bytes32 ptrdata;
779                 assembly { ptrdata := and(mload(ptr), mask) }
780 
781                 while (ptrdata != needledata) {
782                     if (ptr <= selfptr)
783                         return selfptr;
784                     ptr--;
785                     assembly { ptrdata := and(mload(ptr), mask) }
786                 }
787                 return ptr + needlelen;
788             } else {
789                 // For long needles, use hashing
790                 bytes32 hash;
791                 assembly { hash := sha3(needleptr, needlelen) }
792                 ptr = selfptr + (selflen - needlelen);
793                 while (ptr >= selfptr) {
794                     bytes32 testHash;
795                     assembly { testHash := sha3(ptr, needlelen) }
796                     if (hash == testHash)
797                         return ptr + needlelen;
798                     ptr -= 1;
799                 }
800             }
801         }
802         return selfptr;
803     }
804 
805     /*
806      * @dev Modifies `self` to contain everything from the first occurrence of
807      *      `needle` to the end of the slice. `self` is set to the empty slice
808      *      if `needle` is not found.
809      * @param self The slice to search and modify.
810      * @param needle The text to search for.
811      * @return `self`.
812      */
813     function find(slice self, slice needle) internal pure returns (slice) {
814         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
815         self._len -= ptr - self._ptr;
816         self._ptr = ptr;
817         return self;
818     }
819 
820     /*
821      * @dev Modifies `self` to contain the part of the string from the start of
822      *      `self` to the end of the first occurrence of `needle`. If `needle`
823      *      is not found, `self` is set to the empty slice.
824      * @param self The slice to search and modify.
825      * @param needle The text to search for.
826      * @return `self`.
827      */
828     function rfind(slice self, slice needle) internal pure returns (slice) {
829         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
830         self._len = ptr - self._ptr;
831         return self;
832     }
833 
834     /*
835      * @dev Splits the slice, setting `self` to everything after the first
836      *      occurrence of `needle`, and `token` to everything before it. If
837      *      `needle` does not occur in `self`, `self` is set to the empty slice,
838      *      and `token` is set to the entirety of `self`.
839      * @param self The slice to split.
840      * @param needle The text to search for in `self`.
841      * @param token An output parameter to which the first token is written.
842      * @return `token`.
843      */
844     function split(slice self, slice needle, slice token) internal pure returns (slice) {
845         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
846         token._ptr = self._ptr;
847         token._len = ptr - self._ptr;
848         if (ptr == self._ptr + self._len) {
849             // Not found
850             self._len = 0;
851         } else {
852             self._len -= token._len + needle._len;
853             self._ptr = ptr + needle._len;
854         }
855         return token;
856     }
857 
858     /*
859      * @dev Splits the slice, setting `self` to everything after the first
860      *      occurrence of `needle`, and returning everything before it. If
861      *      `needle` does not occur in `self`, `self` is set to the empty slice,
862      *      and the entirety of `self` is returned.
863      * @param self The slice to split.
864      * @param needle The text to search for in `self`.
865      * @return The part of `self` up to the first occurrence of `delim`.
866      */
867     function split(slice self, slice needle) internal pure returns (slice token) {
868         split(self, needle, token);
869     }
870 
871     /*
872      * @dev Splits the slice, setting `self` to everything before the last
873      *      occurrence of `needle`, and `token` to everything after it. If
874      *      `needle` does not occur in `self`, `self` is set to the empty slice,
875      *      and `token` is set to the entirety of `self`.
876      * @param self The slice to split.
877      * @param needle The text to search for in `self`.
878      * @param token An output parameter to which the first token is written.
879      * @return `token`.
880      */
881     function rsplit(slice self, slice needle, slice token) internal pure returns (slice) {
882         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
883         token._ptr = ptr;
884         token._len = self._len - (ptr - self._ptr);
885         if (ptr == self._ptr) {
886             // Not found
887             self._len = 0;
888         } else {
889             self._len -= token._len + needle._len;
890         }
891         return token;
892     }
893 
894     /*
895      * @dev Splits the slice, setting `self` to everything before the last
896      *      occurrence of `needle`, and returning everything after it. If
897      *      `needle` does not occur in `self`, `self` is set to the empty slice,
898      *      and the entirety of `self` is returned.
899      * @param self The slice to split.
900      * @param needle The text to search for in `self`.
901      * @return The part of `self` after the last occurrence of `delim`.
902      */
903     function rsplit(slice self, slice needle) internal pure returns (slice token) {
904         rsplit(self, needle, token);
905     }
906 
907     /*
908      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
909      * @param self The slice to search.
910      * @param needle The text to search for in `self`.
911      * @return The number of occurrences of `needle` found in `self`.
912      */
913     function count(slice self, slice needle) internal pure returns (uint cnt) {
914         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
915         while (ptr <= self._ptr + self._len) {
916             cnt++;
917             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
918         }
919     }
920 
921     /*
922      * @dev Returns True if `self` contains `needle`.
923      * @param self The slice to search.
924      * @param needle The text to search for in `self`.
925      * @return True if `needle` is found in `self`, false otherwise.
926      */
927     function contains(slice self, slice needle) internal pure returns (bool) {
928         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
929     }
930 
931     /*
932      * @dev Returns a newly allocated string containing the concatenation of
933      *      `self` and `other`.
934      * @param self The first slice to concatenate.
935      * @param other The second slice to concatenate.
936      * @return The concatenation of the two strings.
937      */
938     function concat(slice self, slice other) internal pure returns (string) {
939         string memory ret = new string(self._len + other._len);
940         uint retptr;
941         assembly { retptr := add(ret, 32) }
942         memcpy(retptr, self._ptr, self._len);
943         memcpy(retptr + self._len, other._ptr, other._len);
944         return ret;
945     }
946 
947     /*
948      * @dev Joins an array of slices, using `self` as a delimiter, returning a
949      *      newly allocated string.
950      * @param self The delimiter to use.
951      * @param parts A list of slices to join.
952      * @return A newly allocated string containing all the slices in `parts`,
953      *         joined with `self`.
954      */
955     function join(slice self, slice[] parts) internal pure returns (string) {
956         if (parts.length == 0)
957             return "";
958 
959         uint length = self._len * (parts.length - 1);
960         for(uint i = 0; i < parts.length; i++)
961             length += parts[i]._len;
962 
963         string memory ret = new string(length);
964         uint retptr;
965         assembly { retptr := add(ret, 32) }
966 
967         for(i = 0; i < parts.length; i++) {
968             memcpy(retptr, parts[i]._ptr, parts[i]._len);
969             retptr += parts[i]._len;
970             if (i < parts.length - 1) {
971                 memcpy(retptr, self._ptr, self._len);
972                 retptr += self._len;
973             }
974         }
975 
976         return ret;
977     }
978 }
979 
980 
981 /**
982  * @title SafeMath
983  * @dev Math operations with safety checks that throw on error
984  */
985 library SafeMath {
986 
987   /**
988   * @dev Multiplies two numbers, throws on overflow.
989   */
990   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
991     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
992     // benefit is lost if 'b' is also tested.
993     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
994     if (a == 0) {
995       return 0;
996     }
997 
998     c = a * b;
999     assert(c / a == b);
1000     return c;
1001   }
1002 
1003   /**
1004   * @dev Integer division of two numbers, truncating the quotient.
1005   */
1006   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1007     // assert(b > 0); // Solidity automatically throws when dividing by 0
1008     // uint256 c = a / b;
1009     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1010     return a / b;
1011   }
1012 
1013   /**
1014   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1015   */
1016   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1017     assert(b <= a);
1018     return a - b;
1019   }
1020 
1021   /**
1022   * @dev Adds two numbers, throws on overflow.
1023   */
1024   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1025     c = a + b;
1026     assert(c >= a);
1027     return c;
1028   }
1029 }
1030 
1031 
1032 pragma solidity 0.4.24;
1033 
1034 contract SparksterToken is StandardToken, Ownable{
1035 	using strings for *;
1036 	using SafeMath for uint256;
1037 	struct Member {
1038 		mapping(uint256 => uint256) weiBalance; // How much eth has this member contributed for this group?
1039 		mapping(uint256 => uint256) tokenBalance; // The member's token balance in a specific group.
1040 		int256 transferred; // The amount of tokens the member has transferred out or been transferred in. Sending tokens out will increase this value and accepting tokens in will decrease it. In other words, the more negative this value is, the more unlocked tokens the member holds.
1041 		bool exists; // A flag to see if we have a record of this member or not.
1042 	}
1043 
1044 	struct Group {
1045 		bool distributed; // Whether or not tokens in this group have been distributed.
1046 		bool distributing; // This flag is set when we first enter the distribute function and is there to prevent race conditions, since distribution might take a long time.
1047 		bool unlocked; // Whether or not tokens in this group have been unlocked.
1048 		uint256 ratio; // 1 eth:ratio tokens. This amount represents the decimal amount. ratio*10**decimal = ratio sparks.
1049 		uint256 startTime; // Epoch of crowdsale start time.
1050 		uint256 phase1endTime; // Epoch of phase1 end time.
1051 		uint256 phase2endTime; // Epoch of phase2 end time.
1052 		uint256 deadline; // No contributions allowed after this epoch.
1053 		uint256 max2; // cap of phase2
1054 		uint256 max3; // Total ether this group can collect in phase 3.
1055 		uint256 weiTotal; // How much ether has this group collected?
1056 		uint256 cap; // The hard ether cap.
1057 		uint256 howManyDistributed;
1058 		uint256 howManyTotal; // Total people in this group, set when distributing.
1059 	}
1060 
1061 	address oracleAddress = 0xCb3405Fd5212C8B6a16DeFf9eBa49E69478A61b8;
1062 	bool public transferLock = true; // A Global transfer lock. Set to lock down all tokens from all groups.
1063 	bool public allowedToSell = false;
1064 	bool public allowedToPurchase = false;
1065 	string public name;									 // name for display
1066 	string public symbol;								 //An identifier
1067 	uint8 public decimals;							//How many decimals to show.
1068 	uint256 public penalty;
1069 	uint256 public maxGasPrice; // The maximum allowed gas for the purchase function.
1070 	uint256 internal nextGroupNumber;
1071 	uint256 public sellPrice; // sellPrice wei:1 spark token; we won't allow to sell back parts of a token.
1072 	address[] internal allMembers;	
1073 	address[] internal allNonMembers;
1074 	mapping(address => bool) internal nonMemberTransfers;
1075 	mapping(address => Member) internal members;
1076 	mapping(uint256 => Group) internal groups;
1077 	uint256 public openGroupNumber;
1078 	event WantsToPurchase(address walletAddress, uint256 weiAmount, uint256 groupNumber, bool inPhase1);
1079 	event WantsToDistribute(uint256 groupNumber, uint256 startIndex, uint256 endIndex);
1080 	event NearingHardCap(uint256 groupNumber, uint256 remainder);
1081 	event ReachedHardCap(uint256 groupNumber);
1082 	event DistributeDone(uint256 groupNumber);
1083 	event UnlockDone(uint256 groupNumber);
1084 	event GroupCreated(uint256 groupNumber, uint256 startTime, uint256 phase1endTime, uint256 phase2endTime, uint256 deadline, uint256 phase2cap, uint256 phase3cap, uint256 cap, uint256 ratio);
1085 	event AddToGroup(address walletAddress, uint256 groupNumber);
1086 	event ChangedAllowedToSell(bool allowedToSell);
1087 	event ChangedAllowedToPurchase(bool allowedToPurchase);
1088 	event ChangedTransferLock(bool transferLock);
1089 	event SetSellPrice(uint256 sellPrice);
1090 	event SplitTokens(uint256 splitFactor);
1091 	event ReverseSplitTokens(uint256 splitFactor);
1092 	
1093 	modifier onlyOracleBackend() {
1094 		require(msg.sender == oracleAddress);
1095 		_;
1096 	}
1097 	
1098 	// Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
1099 	modifier onlyPayloadSize(uint size) {	 
1100 		require(msg.data.length == size + 4);
1101 		_;
1102 	}
1103 
1104 	modifier canTransfer() {
1105 		require(!transferLock);
1106 		_;
1107 	}
1108 
1109 	modifier canPurchase() {
1110 		require(allowedToPurchase);
1111 		_;
1112 	}
1113 
1114 	modifier canSell() {
1115 		require(allowedToSell);
1116 		_;
1117 	}
1118 
1119 	function() public payable {
1120 		purchase();
1121 	}
1122 
1123 	constructor() public {
1124 		name = "Sparkster";									// Set the name for display purposes
1125 		decimals = 18;					 // Amount of decimals for display purposes
1126 		symbol = "SPRK";							// Set the symbol for display purposes
1127 		setMaximumGasPrice(40);
1128 		// Give all the tokens to the owner to start with.
1129 		mintTokens(435000000);
1130 	}
1131 	
1132 	function setOracleAddress(address newAddress) public onlyOwner returns(bool success) {
1133 		oracleAddress = newAddress;
1134 		return true;
1135 	}
1136 	
1137 	function setMaximumGasPrice(uint256 gweiPrice) public onlyOwner returns(bool success) {
1138 		maxGasPrice = gweiPrice.mul(10**9); // Convert the gwei value to wei.
1139 		return true;
1140 	}
1141 	
1142 	function parseAddr(string _a) pure internal returns (address){ // From Oraclize
1143 		bytes memory tmp = bytes(_a);
1144 		uint160 iaddr = 0;
1145 		uint160 b1;
1146 		uint160 b2;
1147 		for (uint i=2; i<2+2*20; i+=2){
1148 			iaddr *= 256;
1149 			b1 = uint160(tmp[i]);
1150 			b2 = uint160(tmp[i+1]);
1151 			if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1152 			else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1153 			if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1154 			else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1155 			iaddr += (b1*16+b2);
1156 		}
1157 		return address(iaddr);
1158 	}
1159 
1160 	function parseInt(string _a, uint _b) pure internal returns (uint) {
1161 		bytes memory bresult = bytes(_a);
1162 		uint mint = 0;
1163 		bool decim = false;
1164 		for (uint i = 0; i < bresult.length; i++) {
1165 			if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
1166 				if (decim) {
1167 					if (_b == 0) break;
1168 						else _b--;
1169 				}
1170 				mint *= 10;
1171 				mint += uint(bresult[i]) - 48;
1172 			} else if (bresult[i] == 46) decim = true;
1173 		}
1174 		return mint;
1175 	}
1176 
1177 	function mintTokens(uint256 amount) public onlyOwner {
1178 		// Here, we'll consider amount to be the full token amount, so we have to get its decimal value.
1179 		uint256 decimalAmount = amount.mul(uint(10)**decimals);
1180 		totalSupply_ = totalSupply_.add(decimalAmount);
1181 		balances[msg.sender] = balances[msg.sender].add(decimalAmount);
1182 		emit Transfer(address(0), msg.sender, decimalAmount); // Per erc20 standards-compliance.
1183 	}
1184 	
1185 	function purchase() public canPurchase payable returns(bool success) {
1186 		require(msg.sender != address(0)); // Don't allow the 0 address.
1187 		Member storage memberRecord = members[msg.sender];
1188 		Group storage openGroup = groups[openGroupNumber];
1189 		require(openGroup.ratio > 0); // Group must be initialized.
1190 		uint256 currentTimestamp = block.timestamp;
1191 		require(currentTimestamp >= openGroup.startTime && currentTimestamp <= openGroup.deadline);																 //the timestamp must be greater than or equal to the start time and less than or equal to the deadline time
1192 		require(!openGroup.distributing && !openGroup.distributed); // member must exist; Don't allow to purchase if we're in the middle of distributing this group; Don't let someone buy tokens on the current group if that group is already distributed, unlocked or both; don't allow member to purchase if they're not part of the open group.
1193 		require(tx.gasprice <= maxGasPrice); // Restrict maximum gas this transaction is allowed to consume.
1194 		uint256 weiAmount = msg.value;																		// The amount purchased by the current member
1195 		require(weiAmount >= 0.1 ether);
1196 		uint256 weiTotal = openGroup.weiTotal.add(weiAmount); // Calculate total contribution of all members in this group.
1197 		require(weiTotal <= openGroup.cap);														// Check to see if accepting these funds will put us above the hard ether cap.
1198 		uint256 userWeiTotal = memberRecord.weiBalance[openGroupNumber].add(weiAmount);	// Calculate the total amount purchased by the current member
1199 		if(currentTimestamp <= openGroup.phase1endTime){																			 // whether the current timestamp is in the first phase
1200 			emit WantsToPurchase(msg.sender, weiAmount, openGroupNumber, true);
1201 			return true;
1202 		} else if (currentTimestamp <= openGroup.phase2endTime) { // Are we in phase 2?
1203 			require(userWeiTotal <= openGroup.max2); // Allow to contribute no more than max2 in phase 2.
1204 			emit WantsToPurchase(msg.sender, weiAmount, openGroupNumber, false);
1205 			return true;
1206 		} else { // We've passed both phases 1 and 2.
1207 			require(userWeiTotal <= openGroup.max3); // Don't allow to contribute more than max3 in phase 3.
1208 			emit WantsToPurchase(msg.sender, weiAmount, openGroupNumber, false);
1209 			return true;
1210 		}
1211 	}
1212 	
1213 	function purchaseCallback(string uploadedData) public onlyOracleBackend returns(bool success) {
1214 		// We'll separate records by a | and individual entries in the record by a :.
1215 		strings.slice memory uploadedSlice = uploadedData.toSlice();
1216 		strings.slice memory nextRecord = "".toSlice();
1217 		strings.slice memory nextDatum = "".toSlice();
1218 		strings.slice memory recordSeparator = "|".toSlice();
1219 		strings.slice memory datumSeparator = ":".toSlice();
1220 		uint256 amountForOwner = 0;
1221 		while (!uploadedSlice.empty()) {
1222 			nextRecord = uploadedSlice.split(recordSeparator);
1223 			nextDatum = nextRecord.split(datumSeparator);
1224 			uint256 accepted = parseInt(nextDatum.toString(), 0);
1225 			nextDatum = nextRecord.split(datumSeparator);
1226 			address theAddress = parseAddr(nextDatum.toString());
1227 			if (accepted > 0) {
1228 				Member storage memberRecord = members[theAddress];
1229 				nextDatum = nextRecord.split(datumSeparator);
1230 				uint256 weiAmount = parseInt(nextDatum.toString(), 0);
1231 				amountForOwner = amountForOwner.add(weiAmount);
1232 				nextDatum = nextRecord.split(datumSeparator);
1233 				uint256 groupNumber = parseInt(nextDatum.toString(), 0);
1234 				Group storage theGroup = groups[groupNumber];
1235 				uint256 tokenAmount = weiAmount.mul(theGroup.ratio);						 //calculate member token amount.
1236 				theGroup.weiTotal = theGroup.weiTotal.add(weiAmount);								 // Calculate the total amount purchased by all members in this group.
1237 				memberRecord.weiBalance[groupNumber] = memberRecord.weiBalance[groupNumber].add(weiAmount);														 // Record the total amount purchased by the current member
1238 				memberRecord.tokenBalance[groupNumber] = memberRecord.tokenBalance[groupNumber].add(tokenAmount); // Update the member's token amount.
1239 				balances[owner] = balances[owner].sub(tokenAmount); // Update the available number of tokens.
1240 				if (!memberRecord.exists) { // We're seeing this one for the first time.
1241 					allMembers.push(theAddress);
1242 					memberRecord.exists = true;
1243 					if (balances[theAddress] > 0) { // Don't inadvertently lock their previously held tokens before they became a member.
1244 						memberRecord.transferred = -int(balances[theAddress]);
1245 					}
1246 				}
1247 			} else {
1248 				if (penalty >= weiAmount) {
1249 					amountForOwner = amountForOwner.add(penalty);
1250 					weiAmount = weiAmount.sub(penalty);
1251 				}
1252 				if (address(this).balance >= weiAmount) {
1253 					theAddress.transfer(weiAmount);
1254 				}
1255 			}
1256 			if (internalGetHowMuchUntilHardCap(groupNumber) <= 100 ether) {
1257 				emit NearingHardCap(groupNumber, internalGetHowMuchUntilHardCap(groupNumber));
1258 			}
1259 			if (theGroup.weiTotal == theGroup.cap) {
1260 				emit ReachedHardCap(groupNumber);
1261 			}
1262 		}
1263 		if (address(this).balance >= amountForOwner) {
1264 			owner.transfer(amountForOwner);
1265 		}
1266 		return true;
1267 	}
1268 	
1269 	function drain() public onlyOwner {
1270 		owner.transfer(address(this).balance);
1271 	}
1272 	
1273 	function setPenalty(uint256 newPenalty) public onlyOwner returns(bool success) {
1274 		penalty = newPenalty;
1275 		return true;
1276 	}
1277 	
1278 	function sell(uint256 amount) public canSell { // Can't sell unless owner has allowed it.
1279 		uint256 decimalAmount = amount.mul(uint(10)**decimals); // convert the full token value to the smallest unit possible.
1280 		Member storage theMember = members[msg.sender];
1281 		if (theMember.exists) { // If this seller exists, they have an unlocked balance we need to take care of.
1282 			int256 sellValue = theMember.transferred + int(decimalAmount);
1283 			require(sellValue >= theMember.transferred); // Check for overflow.
1284 			require(sellValue <= int(getUnlockedBalanceLimit(msg.sender))); // Make sure they're not selling more than their unlocked amount.
1285 			theMember.transferred = sellValue;
1286 		}
1287 		balances[msg.sender] = balances[msg.sender].sub(decimalAmount); // Do this before transferring to avoid re-entrance attacks; will throw if result < 0.
1288 		// Amount is considered to be how many full tokens the user wants to sell.
1289 		uint256 totalCost = amount.mul(sellPrice); // sellPrice is the per-full-token value.
1290 		require(address(this).balance >= totalCost); // The contract must have enough funds to cover the selling.
1291 		balances[owner] = balances[owner].add(decimalAmount); // Put these tokens back into the available pile.
1292 		msg.sender.transfer(totalCost); // Pay the seller for their tokens.
1293 		emit Transfer(msg.sender, owner, decimalAmount); // Notify exchanges of the sell.
1294 	}
1295 
1296 	function fundContract() public onlyOwner payable { // For the owner to put funds into the contract.
1297 	}
1298 
1299 	function setSellPrice(uint256 thePrice) public onlyOwner {
1300 		sellPrice = thePrice;
1301 		emit SetSellPrice(sellPrice);
1302 	}
1303 	
1304 	function setAllowedToSell(bool value) public onlyOwner {
1305 		allowedToSell = value;
1306 		emit ChangedAllowedToSell(allowedToSell);
1307 	}
1308 
1309 	function setAllowedToPurchase(bool value) public onlyOwner {
1310 		allowedToPurchase = value;
1311 		emit ChangedAllowedToPurchase(allowedToPurchase);
1312 	}
1313 	
1314 	function createGroup(uint256 startEpoch, uint256 phase1endEpoch, uint256 phase2endEpoch, uint256 deadlineEpoch, uint256 phase2cap, uint256 phase3cap, uint256 etherCap, uint256 ratio) public onlyOwner returns (bool success, uint256 createdGroupNumber) {
1315 		Group storage theGroup = groups[nextGroupNumber];
1316 		theGroup.startTime = startEpoch;
1317 		theGroup.phase1endTime = phase1endEpoch;
1318 		theGroup.phase2endTime = phase2endEpoch;
1319 		theGroup.deadline = deadlineEpoch;
1320 		theGroup.max2 = phase2cap;
1321 		theGroup.max3 = phase3cap;
1322 		theGroup.cap = etherCap;
1323 		theGroup.ratio = ratio;
1324 		createdGroupNumber = nextGroupNumber;
1325 		nextGroupNumber++;
1326 		success = true;
1327 		emit GroupCreated(createdGroupNumber, startEpoch, phase1endEpoch, phase2endEpoch, deadlineEpoch, phase2cap, phase3cap, etherCap, ratio);
1328 	}
1329 
1330 	function createGroup() public onlyOwner returns (bool success, uint256 createdGroupNumber) {
1331 		return createGroup(0, 0, 0, 0, 0, 0, 0, 0);
1332 	}
1333 
1334 	function getGroup(uint256 groupNumber) public view returns(bool distributed, bool unlocked, uint256 phase2cap, uint256 phase3cap, uint256 cap, uint256 ratio, uint256 startTime, uint256 phase1endTime, uint256 phase2endTime, uint256 deadline, uint256 weiTotal, uint256 howManyDistributed) {
1335 		require(groupNumber < nextGroupNumber);
1336 		Group storage theGroup = groups[groupNumber];
1337 		distributed = theGroup.distributed;
1338 		unlocked = theGroup.unlocked;
1339 		phase2cap = theGroup.max2;
1340 		phase3cap = theGroup.max3;
1341 		cap = theGroup.cap;
1342 		ratio = theGroup.ratio;
1343 		startTime = theGroup.startTime;
1344 		phase1endTime = theGroup.phase1endTime;
1345 		phase2endTime = theGroup.phase2endTime;
1346 		deadline = theGroup.deadline;
1347 		weiTotal = theGroup.weiTotal;
1348 		howManyDistributed = theGroup.howManyDistributed;
1349 	}
1350 	
1351 	function internalGetHowMuchUntilHardCap(uint256 groupNumber) internal view returns(uint256 remainder) {
1352 		return groups[groupNumber].cap.sub(groups[groupNumber].weiTotal);
1353 	}
1354 	
1355 	function getHowMuchUntilHardCap() public view returns(uint256 remainder) {
1356 		return internalGetHowMuchUntilHardCap(openGroupNumber);
1357 	}
1358 
1359 	function getHowManyLeftToDistribute(uint256 groupNumber) public view returns(uint256 howManyLeftToDistribute) {
1360 		require(groupNumber < nextGroupNumber);
1361 		Group storage theGroup = groups[groupNumber];
1362 		howManyLeftToDistribute = theGroup.howManyTotal - theGroup.howManyDistributed; // No need to use SafeMath here since we're guaranteed to not underflow on this line.
1363 	}
1364 	
1365 	function addMemberToGroup(address walletAddress, uint256 groupNumber) public onlyOwner returns(bool success) {
1366 		emit AddToGroup(walletAddress, groupNumber);
1367 		return true;
1368 	}
1369 	
1370 	function distribute(uint256 groupNumber, uint256 howMany) public onlyOwner {
1371 		Group storage theGroup = groups[groupNumber];
1372 		require(groupNumber < nextGroupNumber && !theGroup.distributed); // can't have already distributed
1373 		emit WantsToDistribute(groupNumber, theGroup.howManyDistributed, theGroup.howManyDistributed + howMany);
1374 	}
1375 	
1376 	function distributeCallback(uint256 groupNumber, uint256 totalInGroup, address[] addresses) public onlyOracleBackend returns (bool success) {
1377 		Group storage theGroup = groups[groupNumber];
1378 		theGroup.distributing = true;
1379 		uint256 n = addresses.length;
1380 		theGroup.howManyTotal = totalInGroup;
1381 		for (uint256 i = 0; i < n; i++) { // This section might be expensive in terms of gas cost!
1382 			address memberAddress = addresses[i];
1383 			Member storage currentMember = members[memberAddress];
1384 			uint256 balance = currentMember.tokenBalance[groupNumber];
1385 			if (balance > 0) { // No need to waste ticks if they have no tokens to distribute
1386 				balances[memberAddress] = balances[memberAddress].add(balance);
1387 				emit Transfer(owner, memberAddress, balance); // Notify exchanges of the distribution.
1388 			}
1389 		}
1390 		theGroup.howManyDistributed = theGroup.howManyDistributed.add(n);
1391 		if (theGroup.howManyDistributed == theGroup.howManyTotal) { // Done distributing all members.
1392 			theGroup.distributed = true;
1393 			theGroup.distributing = false;
1394 			emit DistributeDone(groupNumber);
1395 		}
1396 		return true;
1397 	}
1398 
1399 	function getUnlockedBalanceLimit(address walletAddress) internal view returns(uint256 balance) {
1400 		Member storage theMember = members[walletAddress];
1401 		if (!theMember.exists) {
1402 			return balances[walletAddress];
1403 		}
1404 		for (uint256 i = 0; i < nextGroupNumber; i++) {
1405 			if (groups[i].unlocked) {
1406 				balance = balance.add(theMember.tokenBalance[i]);
1407 			}
1408 		}
1409 		return balance;
1410 	}
1411 
1412 	function getUnlockedTokens(address walletAddress) public view returns(uint256 balance) {
1413 		Member storage theMember = members[walletAddress];
1414 		if (!theMember.exists) {
1415 			return balances[walletAddress];
1416 		}
1417 		return uint256(int(getUnlockedBalanceLimit(walletAddress)) - theMember.transferred);
1418 	}
1419 
1420 	function unlock(uint256 groupNumber) public onlyOwner returns (bool success) {
1421 		Group storage theGroup = groups[groupNumber];
1422 		require(theGroup.distributed); // Distribution must have occurred first.
1423 		theGroup.unlocked = true;
1424 		emit UnlockDone(groupNumber);
1425 		return true;
1426 	}
1427 	
1428 	function setTransferLock(bool value) public onlyOwner {
1429 		transferLock = value;
1430 		emit ChangedTransferLock(transferLock);
1431 	}
1432 	
1433 	function burn(uint256 amount) public onlyOwner {
1434 		// Burns tokens from the owner's supply and doesn't touch allocated tokens.
1435 		// Decrease totalSupply and leftOver by the amount to burn so we can decrease the circulation.
1436 		balances[msg.sender] = balances[msg.sender].sub(amount); // Will throw if result < 0
1437 		totalSupply_ = totalSupply_.sub(amount); // Will throw if result < 0
1438 		emit Transfer(msg.sender, address(0), amount);
1439 	}
1440 	
1441 	function splitTokensBeforeDistribution(uint256 splitFactor) public onlyOwner returns (bool success) {
1442 		// SplitFactor is the multiplier per decimal of spark. splitFactor * 10**decimals = splitFactor sparks
1443 		uint256 n = allMembers.length;
1444 		uint256 ownerBalance = balances[msg.sender];
1445 		uint256 increaseSupplyBy = ownerBalance.mul(splitFactor).sub(ownerBalance); // We need to mint owner*splitFactor - owner additional tokens.
1446 		balances[msg.sender] = balances[msg.sender].mul(splitFactor);
1447 		totalSupply_ = totalSupply_.mul(splitFactor);
1448 		emit Transfer(address(0), msg.sender, increaseSupplyBy); // Notify exchange that we've minted tokens.
1449 		for (uint256 i = 0; i < n; i++) {
1450 			Member storage currentMember = members[allMembers[i]];
1451 			// Take care of transferred balance.
1452 			currentMember.transferred = currentMember.transferred * int(splitFactor);
1453 			// Iterate over all of this user's balances for all groups. If a user is not a part of a group their balance will be 0.
1454 			for (uint256 j = 0; j < nextGroupNumber; j++) {
1455 				uint256 memberBalance = currentMember.tokenBalance[j];
1456 				uint256 multiplier = memberBalance.mul(splitFactor);
1457 				currentMember.tokenBalance[j] = multiplier;
1458 			}
1459 		}
1460 		// Next, increase group ratios by splitFactor, so users will receive ratio + splitFactor tokens per ether.
1461 		n = nextGroupNumber;
1462 		require(n > 0); // Must have at least one group.
1463 		for (i = 0; i < n; i++) {
1464 			Group storage currentGroup = groups[i];
1465 			currentGroup.ratio = currentGroup.ratio.mul(splitFactor);
1466 		}
1467 		emit SplitTokens(splitFactor);
1468 		return true;
1469 	}
1470 	
1471 	function reverseSplitTokensBeforeDistribution(uint256 splitFactor) public onlyOwner returns (bool success) {
1472 		// SplitFactor is the multiplier per decimal of spark. splitFactor * 10**decimals = splitFactor sparks
1473 		uint256 n = allMembers.length;
1474 		uint256 ownerBalance = balances[msg.sender];
1475 		uint256 decreaseSupplyBy = ownerBalance.sub(ownerBalance.div(splitFactor));
1476 		// We don't use burnTokens here since the amount to subtract might be more than what the owner currently holds in their unallocated supply which will cause the function to throw.
1477 		totalSupply_ = totalSupply_.div(splitFactor);
1478 		balances[msg.sender] = ownerBalance.div(splitFactor);
1479 		// Notify the exchanges of how many tokens were burned.
1480 		emit Transfer(msg.sender, address(0), decreaseSupplyBy);
1481 		for (uint256 i = 0; i < n; i++) {
1482 			Member storage currentMember = members[allMembers[i]];
1483 			// Take care of the member's transferred balance.
1484 			currentMember.transferred = currentMember.transferred / int(splitFactor);
1485 			for (uint256 j = 0; j < nextGroupNumber; j++) {
1486 				uint256 memberBalance = currentMember.tokenBalance[j];
1487 				uint256 divier = memberBalance.div(splitFactor);
1488 				currentMember.tokenBalance[j] = divier;
1489 			}
1490 		}
1491 		// Next, decrease group ratios by splitFactor, so users will receive ratio - splitFactor tokens per ether.
1492 		n = nextGroupNumber;
1493 		require(n > 0); // Must have at least one group. Groups are 0-indexed.
1494 		for (i = 0; i < n; i++) {
1495 			Group storage currentGroup = groups[i];
1496 			currentGroup.ratio = currentGroup.ratio.div(splitFactor);
1497 		}
1498 		emit ReverseSplitTokens(splitFactor);
1499 		return true;
1500 	}
1501 
1502 	function splitTokensAfterDistribution(uint256 splitFactor) public onlyOwner returns (bool success) {
1503 		splitTokensBeforeDistribution(splitFactor);
1504 		uint256 n = allMembers.length;
1505 		for (uint256 i = 0; i < n; i++) {
1506 			address currentMember = allMembers[i];
1507 			uint256 memberBalance = balances[currentMember];
1508 			if (memberBalance > 0) {
1509 				uint256 multiplier1 = memberBalance.mul(splitFactor);
1510 				uint256 increaseMemberSupplyBy = multiplier1.sub(memberBalance);
1511 				balances[currentMember] = multiplier1;
1512 				emit Transfer(address(0), currentMember, increaseMemberSupplyBy);
1513 			}
1514 		}
1515 		n = allNonMembers.length;
1516 		for (i = 0; i < n; i++) {
1517 			address currentNonMember = allNonMembers[i];
1518 			// If this address started out as a nonmember and then became a member, we've seen them already in allMembers so don't grow or shrink them twice.
1519 			if (members[currentNonMember].exists) {
1520 				continue;
1521 			}
1522 			uint256 nonMemberBalance = balances[currentNonMember];
1523 			if (nonMemberBalance > 0) {
1524 				uint256 multiplier2 = nonMemberBalance.mul(splitFactor);
1525 				uint256 increaseNonMemberSupplyBy = multiplier2.sub(nonMemberBalance);
1526 				balances[currentNonMember] = multiplier2;
1527 				emit Transfer(address(0), currentNonMember, increaseNonMemberSupplyBy);
1528 			}
1529 		}
1530 		emit SplitTokens(splitFactor);
1531 		return true;
1532 	}
1533 
1534 	function reverseSplitTokensAfterDistribution(uint256 splitFactor) public onlyOwner returns (bool success) {
1535 		reverseSplitTokensBeforeDistribution(splitFactor);
1536 		uint256 n = allMembers.length;
1537 		for (uint256 i = 0; i < n; i++) {
1538 			address currentMember = allMembers[i];
1539 			uint256 memberBalance = balances[currentMember];
1540 			if (memberBalance > 0) {
1541 				uint256 divier1 = memberBalance.div(splitFactor);
1542 				uint256 decreaseMemberSupplyBy = memberBalance.sub(divier1);
1543 				balances[currentMember] = divier1;
1544 				emit Transfer(currentMember, address(0), decreaseMemberSupplyBy);
1545 			}
1546 		}
1547 		n = allNonMembers.length;
1548 		for (i = 0; i < n; i++) {
1549 			address currentNonMember = allNonMembers[i];
1550 			// If this address started out as a nonmember and then became a member, we've seen them already in allMembers so don't grow or shrink them twice.
1551 			if (members[currentNonMember].exists) {
1552 				continue;
1553 			}
1554 			uint256 nonMemberBalance = balances[currentNonMember];
1555 			if (nonMemberBalance > 0) {
1556 				uint256 divier2 = nonMemberBalance.div(splitFactor);
1557 				uint256 decreaseNonMemberSupplyBy = nonMemberBalance.sub(divier2);
1558 				balances[currentNonMember] = divier2;
1559 				emit Transfer(currentNonMember, address(0), decreaseNonMemberSupplyBy);
1560 			}
1561 		}
1562 		emit ReverseSplitTokens(splitFactor);
1563 		return true;
1564 	}
1565 
1566 	function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) canTransfer returns (bool success) {		
1567 		// If the transferrer has purchased tokens, they must be unlocked before they can be used.
1568 		Member storage fromMember = members[msg.sender];
1569 		if (fromMember.exists) { // If this is the owner, this check will be false so no need to check specifically for owner here.
1570 			int256 transferValue = fromMember.transferred + int(_value);
1571 			require(transferValue >= fromMember.transferred); // Check for overflow.
1572 			require(transferValue <= int(getUnlockedBalanceLimit(msg.sender))); // Make sure they don't transfer out more than their unlocked limit.
1573 			fromMember.transferred = transferValue;
1574 		}
1575 		// If any of the parties involved are not members, add them to the nonmembers list.
1576 		// Don't add the owner, since they're a special case.
1577 		if (!fromMember.exists && msg.sender != owner) {
1578 			bool fromTransferee = nonMemberTransfers[msg.sender];
1579 			if (!fromTransferee) { // If we haven't added this transferee before.
1580 				nonMemberTransfers[msg.sender] = true;
1581 				allNonMembers.push(msg.sender);
1582 			}
1583 		}
1584 		if (!members[_to].exists && _to != owner) {
1585 			bool toTransferee = nonMemberTransfers[_to];
1586 			if (!toTransferee) { // If we haven't added this transferee before.
1587 				nonMemberTransfers[_to] = true;
1588 				allNonMembers.push(_to);
1589 			}
1590 		} else if (members[_to].exists) { // Add this transfer to the unlocked balance
1591 			int256 transferInValue = members[_to].transferred - int(_value);
1592 			require(transferInValue <= members[_to].transferred); // Check for underflow.
1593 			members[_to].transferred = transferInValue;
1594 		}
1595 		return super.transfer(_to, _value);
1596 	}
1597 
1598 	function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) canTransfer returns (bool success) {
1599 		// If the transferrer has purchased tokens, they must be unlocked before they can be used.
1600 		Member storage fromMember = members[_from];
1601 		if (fromMember.exists) { // If _from is the owner, this check will always fail, so we don't need to check specifically for owner here.
1602 			int256 transferValue = fromMember.transferred + int(_value);
1603 			require(transferValue >= fromMember.transferred); // Check for overflow.
1604 			require(transferValue <= int(getUnlockedBalanceLimit(msg.sender))); // Make sure they don't transfer out more than their unlocked limit.
1605 			fromMember.transferred = transferValue;
1606 		}
1607 		// If any of the parties involved are not members, add them to the nonmembers list.
1608 		// Don't add the owner since they're a special case.
1609 		if (!fromMember.exists && _from != owner) {
1610 			bool fromTransferee = nonMemberTransfers[_from];
1611 			if (!fromTransferee) { // If we haven't added this transferee before.
1612 				nonMemberTransfers[_from] = true;
1613 				allNonMembers.push(_from);
1614 			}
1615 		}
1616 		if (!members[_to].exists && _to != owner) {
1617 			bool toTransferee = nonMemberTransfers[_to];
1618 			if (!toTransferee) { // If we haven't added this transferee before.
1619 				nonMemberTransfers[_to] = true;
1620 				allNonMembers.push(_to);
1621 			}
1622 		} else if (members[_to].exists) { // Add this transfer to the unlocked balance
1623 			int256 transferInValue = members[_to].transferred - int(_value);
1624 			require(transferInValue <= members[_to].transferred); // Check for underflow.
1625 			members[_to].transferred = transferInValue;
1626 		}
1627 		return super.transferFrom(_from, _to, _value);
1628 	}
1629 
1630 	function setOpenGroup(uint256 groupNumber) public onlyOwner returns (bool success) {
1631 		require(groupNumber < nextGroupNumber);
1632 		openGroupNumber = groupNumber;
1633 		return true;
1634 	}
1635 
1636 	function getUndistributedBalanceOf(address walletAddress, uint256 groupNumber) public view returns (uint256 balance) {
1637 		Member storage theMember = members[walletAddress];
1638 		require(theMember.exists);
1639 		if (groups[groupNumber].distributed) // Here, the group will be distributed but tokenBalance will still have a value, so that we know how many tokens to allocate to the unlocked balance.
1640 			return 0;
1641 		return theMember.tokenBalance[groupNumber];
1642 	}
1643 
1644 	function checkMyUndistributedBalance(uint256 groupNumber) public view returns (uint256 balance) {
1645 		return getUndistributedBalanceOf(msg.sender, groupNumber);
1646 	}
1647 
1648 	function transferRecovery(address _from, address _to, uint256 _value) public onlyOwner returns (bool success) {
1649 		// Will be used if someone sends tokens to an incorrect address by accident. This way, we have the ability to recover the tokens. For example, sometimes there's a problem of lost tokens if someone sends tokens to a contract address that can't utilize the tokens.
1650 		allowed[_from][msg.sender] = allowed[_from][msg.sender].add(_value); // Authorize the owner to spend on someone's behalf.
1651 		Member storage fromMember = members[_from];
1652 		if (fromMember.exists) {
1653 			int256 oldTransferred = fromMember.transferred;
1654 			fromMember.transferred -= int(_value); // Unlock this amount.
1655 			require(oldTransferred >= fromMember.transferred); // Check for underflow.
1656 		}
1657 		return transferFrom(_from, _to, _value);
1658 	}
1659 }