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
1038 		address walletAddress;
1039 		mapping(uint256 => bool) groupMemberships; // What groups does this member belong to?
1040 		mapping(uint256 => uint256) ethBalance; // How much eth has this member contributed for this group?
1041 		mapping(uint256 => uint256) tokenBalance; // The member's token balance in a specific group.
1042 		uint256 max1; // Maximum amount this user can contribute for phase1.
1043 		int256 transferred; // The amount of tokens the member has transferred out or been transferred in. Sending tokens out will increase this value and accepting tokens in will decrease it. In other words, the more negative this value is, the more unlocked tokens the member holds.
1044 		bool exists; // A flag to see if we have a record of this member or not. If we don't, they won't be allowed to purchase.
1045 	}
1046 
1047 	struct Group {
1048 		bool distributed; // Whether or not tokens in this group have been distributed.
1049 		bool distributing; // This flag is set when we first enter the distribute function and is there to prevent race conditions, since distribution might take a long time.
1050 		bool unlocked; // Whether or not tokens in this group have been unlocked.
1051 		uint256 groupNumber; // This group's number
1052 		uint256 ratio; // 1 eth:ratio tokens. This amount represents the decimal amount. ratio*10**decimal = ratio sparks.
1053 		uint256 startTime; // Epoch of crowdsale start time.
1054 		uint256 phase1endTime; // Epoch of phase1 end time.
1055 		uint256 phase2endTime; // Epoch of phase2 end time.
1056 		uint256 deadline; // No contributions allowed after this epoch.
1057 		uint256 max2; // cap of phase2
1058 		uint256 max3; // Total ether this group can collect in phase 3.
1059 		uint256 ethTotal; // How much ether has this group collected?
1060 		uint256 cap; // The hard ether cap.
1061 		uint256 howManyDistributed;
1062 	}
1063 
1064 	bool internal transferLock = true; // A Global transfer lock. Set to lock down all tokens from all groups.
1065 	bool internal allowedToSell = false;
1066 	bool internal allowedToPurchase = false;
1067 	string public name;									 // name for display
1068 	string public symbol;								 //An identifier
1069 	uint8 public decimals;							//How many decimals to show.
1070 	uint256 internal maxGasPrice; // The maximum allowed gas for the purchase function.
1071 	uint256 internal nextGroupNumber;
1072 	uint256 public sellPrice; // sellPrice wei:1 spark token; we won't allow to sell back parts of a token.
1073 	address[] internal allMembers;	
1074 	address[] internal allNonMembers;
1075 	mapping(address => bool) internal nonMemberTransfers;
1076 	mapping(address => Member) internal members;
1077 	mapping(uint256 => Group) internal groups;
1078 	mapping(uint256 => address[]) internal associations; // Will hold a record of which addresses belong to which group.
1079 	uint256 internal openGroupNumber;
1080 	event PurchaseSuccess(address indexed _addr, uint256 _weiAmount,uint256 _totalEthBalance,uint256 _totalTokenBalance);
1081 	event DistributeDone(uint256 groupNumber);
1082 	event UnlockDone(uint256 groupNumber);
1083 	event GroupCreated(uint256 groupNumber, uint256 startTime, uint256 phase1endTime, uint256 phase2endTime, uint256 deadline, uint256 phase2cap, uint256 phase3cap, uint256 cap, uint256 ratio);
1084 	event ChangedAllowedToSell(bool allowedToSell);
1085 	event ChangedAllowedToPurchase(bool allowedToPurchase);
1086 	event ChangedTransferLock(bool transferLock);
1087 	event SetSellPrice(uint256 sellPrice);
1088 	event Added(address walletAddress, uint256 group, uint256 tokens, uint256 maxContribution1);
1089 	event SplitTokens(uint256 splitFactor);
1090 	event ReverseSplitTokens(uint256 splitFactor);
1091 	
1092 	// Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
1093 	modifier onlyPayloadSize(uint size) {	 
1094 		require(msg.data.length == size + 4);
1095 		_;
1096 	}
1097 
1098 	modifier canTransfer() {
1099 		require(!transferLock);
1100 		_;
1101 	}
1102 
1103 	modifier canPurchase() {
1104 		require(allowedToPurchase);
1105 		_;
1106 	}
1107 
1108 	modifier canSell() {
1109 		require(allowedToSell);
1110 		_;
1111 	}
1112 
1113 	function() public payable {
1114 		purchase();
1115 	}
1116 
1117 	constructor() public {
1118 		name = "Sparkster";									// Set the name for display purposes
1119 		decimals = 18;					 // Amount of decimals for display purposes
1120 		symbol = "SPRK";							// Set the symbol for display purposes
1121 		setMaximumGasPrice(40);
1122 		// Give all the tokens to the owner to start with.
1123 		mintTokens(435000000);
1124 	}
1125 	
1126 	function setMaximumGasPrice(uint256 gweiPrice) public onlyOwner returns(bool success) {
1127 		maxGasPrice = gweiPrice.mul(10**9); // Convert the gwei value to wei.
1128 		return true;
1129 	}
1130 	
1131 	function parseAddr(string _a) pure internal returns (address){ // From Oraclize
1132 		bytes memory tmp = bytes(_a);
1133 		uint160 iaddr = 0;
1134 		uint160 b1;
1135 		uint160 b2;
1136 		for (uint i=2; i<2+2*20; i+=2){
1137 			iaddr *= 256;
1138 			b1 = uint160(tmp[i]);
1139 			b2 = uint160(tmp[i+1]);
1140 			if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1141 			else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1142 			if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1143 			else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1144 			iaddr += (b1*16+b2);
1145 		}
1146 		return address(iaddr);
1147 	}
1148 
1149 	function parseInt(string _a, uint _b) pure internal returns (uint) {
1150 		bytes memory bresult = bytes(_a);
1151 		uint mint = 0;
1152 		bool decim = false;
1153 		for (uint i = 0; i < bresult.length; i++) {
1154 			if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
1155 				if (decim) {
1156 					if (_b == 0) break;
1157 						else _b--;
1158 				}
1159 				mint *= 10;
1160 				mint += uint(bresult[i]) - 48;
1161 			} else if (bresult[i] == 46) decim = true;
1162 		}
1163 		return mint;
1164 	}
1165 
1166 	function mintTokens(uint256 amount) public onlyOwner {
1167 		// Here, we'll consider amount to be the full token amount, so we have to get its decimal value.
1168 		uint256 decimalAmount = amount.mul(uint(10)**decimals);
1169 		totalSupply_ = totalSupply_.add(decimalAmount);
1170 		balances[msg.sender] = balances[msg.sender].add(decimalAmount);
1171 		emit Transfer(address(0), msg.sender, decimalAmount); // Per erc20 standards-compliance.
1172 	}
1173 	
1174 	function purchase() public canPurchase payable{
1175 		require(msg.sender != address(0)); // Don't allow the 0 address.
1176 		Member storage memberRecord = members[msg.sender];
1177 		Group storage openGroup = groups[openGroupNumber];
1178 		require(openGroup.ratio > 0); // Group must be initialized.
1179 		require(memberRecord.exists && memberRecord.groupMemberships[openGroup.groupNumber] && !openGroup.distributing && !openGroup.distributed && !openGroup.unlocked); // member must exist; Don't allow to purchase if we're in the middle of distributing this group; Don't let someone buy tokens on the current group if that group is already distributed, unlocked or both; don't allow member to purchase if they're not part of the open group.
1180 		uint256 currentTimestamp = block.timestamp;
1181 		require(currentTimestamp >= openGroup.startTime && currentTimestamp <= openGroup.deadline);																 //the timestamp must be greater than or equal to the start time and less than or equal to the deadline time
1182 		require(tx.gasprice <= maxGasPrice); // Restrict maximum gas this transaction is allowed to consume.
1183 		uint256 weiAmount = msg.value;																		// The amount purchased by the current member
1184 		require(weiAmount >= 0.1 ether);
1185 		uint256 ethTotal = openGroup.ethTotal.add(weiAmount); // Calculate total contribution of all members in this group.
1186 		require(ethTotal <= openGroup.cap);														// Check to see if accepting these funds will put us above the hard ether cap.
1187 		uint256 userETHTotal = memberRecord.ethBalance[openGroup.groupNumber].add(weiAmount);	// Calculate the total amount purchased by the current member
1188 		if(currentTimestamp <= openGroup.phase1endTime){																			 // whether the current timestamp is in the first phase
1189 			require(userETHTotal <= memberRecord.max1);														 // Will these new funds put the member over their first phase contribution limit?
1190 		} else if (currentTimestamp <= openGroup.phase2endTime) { // Are we in phase 2?
1191 			require(userETHTotal <= openGroup.max2); // Allow to contribute no more than max2 in phase 2.
1192 		} else { // We've passed both phases 1 and 2.
1193 			require(userETHTotal <= openGroup.max3); // Don't allow to contribute more than max3 in phase 3.
1194 		}
1195 		uint256 tokenAmount = weiAmount.mul(openGroup.ratio);						 //calculate member token amount.
1196 		uint256 newLeftOver = balances[owner].sub(tokenAmount); // Won't pass if result is < 0.
1197 		openGroup.ethTotal = ethTotal;								 // Calculate the total amount purchased by all members in this group.
1198 		memberRecord.ethBalance[openGroup.groupNumber] = userETHTotal;														 // Record the total amount purchased by the current member
1199 		memberRecord.tokenBalance[openGroup.groupNumber] = memberRecord.tokenBalance[openGroup.groupNumber].add(tokenAmount); // Update the member's token amount.
1200 		balances[owner] = newLeftOver; // Update the available number of tokens.
1201 		owner.transfer(weiAmount); // Transfer to owner, don't keep funds in the contract.
1202 		emit PurchaseSuccess(msg.sender,weiAmount,memberRecord.ethBalance[openGroup.groupNumber],memberRecord.tokenBalance[openGroup.groupNumber]); 
1203 	}
1204 	
1205 	function sell(uint256 amount) public canSell { // Can't sell unless owner has allowed it.
1206 		uint256 decimalAmount = amount.mul(uint(10)**decimals); // convert the full token value to the smallest unit possible.
1207 		if (members[msg.sender].exists) { // If this seller exists, they have an unlocked balance we need to take care of.
1208 			int256 sellValue = members[msg.sender].transferred + int(decimalAmount);
1209 			require(sellValue >= members[msg.sender].transferred); // Check for overflow.
1210 			require(sellValue <= int(getUnlockedBalanceLimit(msg.sender))); // Make sure they're not selling more than their unlocked amount.
1211 			members[msg.sender].transferred = sellValue;
1212 		}
1213 		balances[msg.sender] = balances[msg.sender].sub(decimalAmount); // Do this before transferring to avoid re-entrance attacks; will throw if result < 0.
1214 		// Amount is considered to be how many full tokens the user wants to sell.
1215 		uint256 totalCost = amount.mul(sellPrice); // sellPrice is the per-full-token value.
1216 		require(address(this).balance >= totalCost); // The contract must have enough funds to cover the selling.
1217 		balances[owner] = balances[owner].add(decimalAmount); // Put these tokens back into the available pile.
1218 		msg.sender.transfer(totalCost); // Pay the seller for their tokens.
1219 		emit Transfer(msg.sender, owner, decimalAmount); // Notify exchanges of the sell.
1220 	}
1221 
1222 	function fundContract() public onlyOwner payable { // For the owner to put funds into the contract.
1223 	}
1224 
1225 	function setSellPrice(uint256 thePrice) public onlyOwner {
1226 		sellPrice = thePrice;
1227 		emit SetSellPrice(sellPrice);
1228 	}
1229 	
1230 	function setAllowedToSell(bool value) public onlyOwner {
1231 		allowedToSell = value;
1232 		emit ChangedAllowedToSell(allowedToSell);
1233 	}
1234 
1235 	function setAllowedToPurchase(bool value) public onlyOwner {
1236 		allowedToPurchase = value;
1237 		emit ChangedAllowedToPurchase(allowedToPurchase);
1238 	}
1239 	
1240 	function createGroup(uint256 startEpoch, uint256 phase1endEpoch, uint256 phase2endEpoch, uint256 deadlineEpoch, uint256 phase2cap, uint256 phase3cap, uint256 etherCap, uint256 ratio) public onlyOwner returns (bool success, uint256 createdGroupNumber) {
1241 		Group storage theGroup = groups[nextGroupNumber];
1242 		theGroup.groupNumber = nextGroupNumber;
1243 		theGroup.startTime = startEpoch;
1244 		theGroup.phase1endTime = phase1endEpoch;
1245 		theGroup.phase2endTime = phase2endEpoch;
1246 		theGroup.deadline = deadlineEpoch;
1247 		theGroup.max2 = phase2cap;
1248 		theGroup.max3 = phase3cap;
1249 		theGroup.cap = etherCap;
1250 		theGroup.ratio = ratio;
1251 		createdGroupNumber = nextGroupNumber;
1252 		nextGroupNumber++;
1253 		success = true;
1254 		emit GroupCreated(createdGroupNumber, startEpoch, phase1endEpoch, phase2endEpoch, deadlineEpoch, phase2cap, phase3cap, etherCap, ratio);
1255 	}
1256 
1257 	function createGroup() public onlyOwner returns (bool success, uint256 createdGroupNumber) {
1258 		return createGroup(0, 0, 0, 0, 0, 0, 0, 0);
1259 	}
1260 
1261 	function getGroup(uint256 groupNumber) public view onlyOwner returns(bool distributed, bool unlocked, uint256 phase2cap, uint256 phase3cap, uint256 cap, uint256 ratio, uint256 startTime, uint256 phase1endTime, uint256 phase2endTime, uint256 deadline, uint256 ethTotal, uint256 howManyDistributed) {
1262 		require(groupNumber < nextGroupNumber);
1263 		Group storage theGroup = groups[groupNumber];
1264 		distributed = theGroup.distributed;
1265 		unlocked = theGroup.unlocked;
1266 		phase2cap = theGroup.max2;
1267 		phase3cap = theGroup.max3;
1268 		cap = theGroup.cap;
1269 		ratio = theGroup.ratio;
1270 		startTime = theGroup.startTime;
1271 		phase1endTime = theGroup.phase1endTime;
1272 		phase2endTime = theGroup.phase2endTime;
1273 		deadline = theGroup.deadline;
1274 		ethTotal = theGroup.ethTotal;
1275 		howManyDistributed = theGroup.howManyDistributed;
1276 	}
1277 
1278 	function getHowManyLeftToDistribute(uint256 groupNumber) public view returns(uint256 howManyLeftToDistribute) {
1279 		require(groupNumber < nextGroupNumber);
1280 		Group storage theGroup = groups[groupNumber];
1281 		howManyLeftToDistribute = associations[groupNumber].length - theGroup.howManyDistributed; // No need to use SafeMath here since we're guaranteed to not underflow on this line.
1282 	}
1283 	
1284 	function getMembersInGroup(uint256 groupNumber) public view returns (address[]) {
1285 		require(groupNumber < nextGroupNumber); // Check for nonexistent group
1286 		return associations[groupNumber];
1287 	}
1288 
1289 	function addMember(address walletAddress, uint256 groupNumber, uint256 tokens, uint256 maxContribution1) public onlyOwner returns (bool success) {
1290 		Member storage theMember = members[walletAddress];
1291 		Group storage theGroup = groups[groupNumber];
1292 		require(groupNumber < nextGroupNumber); // Don't let the owner assign to a group that doesn't exist, protect against mistypes.
1293 		require(!theGroup.distributed && !theGroup.distributing && !theGroup.unlocked); // Don't let us add to a distributed group, a group that's distributing right now, or a group that's already been unlocked.
1294 		require(!theMember.exists); // Don't let the owner re-add a member.
1295 		theMember.walletAddress = walletAddress;
1296 		theMember.groupMemberships[groupNumber] = true;
1297 		balances[owner] = balances[owner].sub(tokens);
1298 		theMember.tokenBalance[groupNumber] = tokens;
1299 		theMember.max1 = maxContribution1;
1300 		theMember.transferred = -int(balances[walletAddress]); // Don't lock the tokens they come in with if they already hold a balance.
1301 		theMember.exists = true;
1302 		associations[groupNumber].push(walletAddress); // Push this user's address to the associations array so we can easily keep track of which users belong to which group...
1303 		// ... Solidity doesn't allow to iterate over a map.
1304 		allMembers.push(walletAddress); // Push this address to allMembers array so we can easily loop through all addresses...
1305 		// Used for splitTokens and reverseSplitTokens.
1306 		emit Added(walletAddress, groupNumber, tokens, maxContribution1);
1307 		return true;
1308 	}
1309 
1310 	function addMemberToGroup(address walletAddress, uint256 groupNumber) public onlyOwner returns(bool success) {
1311 		Member storage memberRecord = members[walletAddress];
1312 		require(memberRecord.exists && groupNumber < nextGroupNumber && !memberRecord.groupMemberships[groupNumber]); // Don't add this user to a group if they already exist in that group.
1313 		memberRecord.groupMemberships[groupNumber] = true;
1314 		associations[groupNumber].push(walletAddress);
1315 		return true;
1316 	}
1317 	function upload(string uploadedData) public onlyOwner returns (bool success) {
1318 		// We'll separate records by a | and individual entries in the record by a :.
1319 		strings.slice memory uploadedSlice = uploadedData.toSlice();
1320 		strings.slice memory nextRecord = "".toSlice();
1321 		strings.slice memory nextDatum = "".toSlice();
1322 		strings.slice memory recordSeparator = "|".toSlice();
1323 		strings.slice memory datumSeparator = ":".toSlice();
1324 		while (!uploadedSlice.empty()) {
1325 			nextRecord = uploadedSlice.split(recordSeparator);
1326 			nextDatum = nextRecord.split(datumSeparator);
1327 			address memberAddress = parseAddr(nextDatum.toString());
1328 			nextDatum = nextRecord.split(datumSeparator);
1329 			uint256 memberGroup = parseInt(nextDatum.toString(), 0);
1330 			nextDatum = nextRecord.split(datumSeparator);
1331 			uint256 memberTokens = parseInt(nextDatum.toString(), 0);
1332 			nextDatum = nextRecord.split(datumSeparator);
1333 			uint256 memberMaxContribution1 = parseInt(nextDatum.toString(), 0);
1334 			addMember(memberAddress, memberGroup, memberTokens, memberMaxContribution1);
1335 		}
1336 		return true;
1337 	}
1338 	
1339 	function distribute(uint256 groupNumber, uint256 howMany) public onlyOwner returns (bool success) {
1340 		Group storage theGroup = groups[groupNumber];
1341 		require(groupNumber < nextGroupNumber && !theGroup.distributed ); // can't have already distributed
1342 		uint256 inclusiveStartIndex = theGroup.howManyDistributed;
1343 		uint256 exclusiveEndIndex = inclusiveStartIndex.add(howMany);
1344 		theGroup.distributing = true;
1345 		uint256 n = associations[groupNumber].length;
1346 		require(n > 0 ); // We must have more than 0 members in this group
1347 		if (exclusiveEndIndex > n) { // This batch will overrun the array.
1348 			exclusiveEndIndex = n;
1349 		}
1350 		for (uint256 i = inclusiveStartIndex; i < exclusiveEndIndex; i++) { // This section might be expensive in terms of gas cost!
1351 			address memberAddress = associations[groupNumber][i];
1352 			Member storage currentMember = members[memberAddress];
1353 			uint256 balance = currentMember.tokenBalance[groupNumber];
1354 			if (balance > 0) { // No need to waste ticks if they have no tokens to distribute
1355 				balances[memberAddress] = balances[memberAddress].add(balance);
1356 				emit Transfer(owner, memberAddress, balance); // Notify exchanges of the distribution.
1357 			}
1358 			theGroup.howManyDistributed++;
1359 		}
1360 		if (theGroup.howManyDistributed == n) { // Done distributing all members.
1361 			theGroup.distributed = true;
1362 			theGroup.distributing = false;
1363 			emit DistributeDone(groupNumber);
1364 		}
1365 		return true;
1366 	}
1367 
1368 	function getUnlockedBalanceLimit(address walletAddress) internal view returns(uint256 balance) {
1369 		Member storage theMember = members[walletAddress];
1370 		if (!theMember.exists) {
1371 			return balances[walletAddress];
1372 		}
1373 		for (uint256 i = 0; i < nextGroupNumber; i++) {
1374 			if (groups[i].unlocked) {
1375 				balance = balance.add(theMember.tokenBalance[i]);
1376 			}
1377 		}
1378 		return balance;
1379 	}
1380 
1381 	function getUnlockedTokens(address walletAddress) public view returns(uint256 balance) {
1382 		Member storage theMember = members[walletAddress];
1383 		if (!theMember.exists) {
1384 			return balances[walletAddress];
1385 		}
1386 		return uint256(int(getUnlockedBalanceLimit(walletAddress)) - theMember.transferred);
1387 	}
1388 
1389 	function unlock(uint256 groupNumber) public onlyOwner returns (bool success) {
1390 		Group storage theGroup = groups[groupNumber];
1391 		require(theGroup.distributed && !theGroup.unlocked); // Distribution must have occurred first.
1392 		theGroup.unlocked = true;
1393 		emit UnlockDone(groupNumber);
1394 		return true;
1395 	}
1396 	
1397 	function setTransferLock(bool value) public onlyOwner {
1398 		transferLock = value;
1399 		emit ChangedTransferLock(transferLock);
1400 	}
1401 	
1402 	function burn(uint256 amount) public onlyOwner {
1403 		// Burns tokens from the owner's supply and doesn't touch allocated tokens.
1404 		// Decrease totalSupply and leftOver by the amount to burn so we can decrease the circulation.
1405 		balances[msg.sender] = balances[msg.sender].sub(amount); // Will throw if result < 0
1406 		totalSupply_ = totalSupply_.sub(amount); // Will throw if result < 0
1407 		emit Transfer(msg.sender, address(0), amount);
1408 	}
1409 	
1410 	function splitTokensBeforeDistribution(uint256 splitFactor) public onlyOwner returns (bool success) {
1411 		// SplitFactor is the multiplier per decimal of spark. splitFactor * 10**decimals = splitFactor sparks
1412 		uint256 n = allMembers.length;
1413 		uint256 ownerBalance = balances[msg.sender];
1414 		uint256 increaseSupplyBy = ownerBalance.mul(splitFactor).sub(ownerBalance); // We need to mint owner*splitFactor - owner additional tokens.
1415 		balances[msg.sender] = balances[msg.sender].mul(splitFactor);
1416 		totalSupply_ = totalSupply_.mul(splitFactor);
1417 		emit Transfer(address(0), msg.sender, increaseSupplyBy); // Notify exchange that we've minted tokens.
1418 		for (uint256 i = 0; i < n; i++) {
1419 			Member storage currentMember = members[allMembers[i]];
1420 			// Take care of transferred balance.
1421 			currentMember.transferred = currentMember.transferred * int(splitFactor);
1422 			// Iterate over all of this user's balances for all groups. If a user is not a part of a group their balance will be 0.
1423 			for (uint256 j = 0; j < nextGroupNumber; j++) {
1424 				uint256 memberBalance = currentMember.tokenBalance[j];
1425 				uint256 multiplier = memberBalance.mul(splitFactor);
1426 				currentMember.tokenBalance[j] = multiplier;
1427 			}
1428 		}
1429 		// Next, increase group ratios by splitFactor, so users will receive ratio + splitFactor tokens per ether.
1430 		n = nextGroupNumber;
1431 		require(n > 0); // Must have at least one group.
1432 		for (i = 0; i < n; i++) {
1433 			Group storage currentGroup = groups[i];
1434 			currentGroup.ratio = currentGroup.ratio.mul(splitFactor);
1435 		}
1436 		emit SplitTokens(splitFactor);
1437 		return true;
1438 	}
1439 	
1440 	function reverseSplitTokensBeforeDistribution(uint256 splitFactor) public onlyOwner returns (bool success) {
1441 		// SplitFactor is the multiplier per decimal of spark. splitFactor * 10**decimals = splitFactor sparks
1442 		uint256 n = allMembers.length;
1443 		uint256 ownerBalance = balances[msg.sender];
1444 		uint256 decreaseSupplyBy = ownerBalance.sub(ownerBalance.div(splitFactor));
1445 		// We don't use burnTokens here since the amount to subtract might be more than what the owner currently holds in their unallocated supply which will cause the function to throw.
1446 		totalSupply_ = totalSupply_.div(splitFactor);
1447 		balances[msg.sender] = ownerBalance.div(splitFactor);
1448 		// Notify the exchanges of how many tokens were burned.
1449 		emit Transfer(msg.sender, address(0), decreaseSupplyBy);
1450 		for (uint256 i = 0; i < n; i++) {
1451 			Member storage currentMember = members[allMembers[i]];
1452 			// Take care of the member's transferred balance.
1453 			currentMember.transferred = currentMember.transferred / int(splitFactor);
1454 			for (uint256 j = 0; j < nextGroupNumber; j++) {
1455 				uint256 memberBalance = currentMember.tokenBalance[j];
1456 				uint256 divier = memberBalance.div(splitFactor);
1457 				currentMember.tokenBalance[j] = divier;
1458 			}
1459 		}
1460 		// Next, decrease group ratios by splitFactor, so users will receive ratio - splitFactor tokens per ether.
1461 		n = nextGroupNumber;
1462 		require(n > 0); // Must have at least one group. Groups are 0-indexed.
1463 		for (i = 0; i < n; i++) {
1464 			Group storage currentGroup = groups[i];
1465 			currentGroup.ratio = currentGroup.ratio.div(splitFactor);
1466 		}
1467 		emit ReverseSplitTokens(splitFactor);
1468 		return true;
1469 	}
1470 
1471 	function splitTokensAfterDistribution(uint256 splitFactor) public onlyOwner returns (bool success) {
1472 		splitTokensBeforeDistribution(splitFactor);
1473 		uint256 n = allMembers.length;
1474 		for (uint256 i = 0; i < n; i++) {
1475 			address currentMember = allMembers[i];
1476 			uint256 memberBalance = balances[currentMember];
1477 			if (memberBalance > 0) {
1478 				uint256 multiplier1 = memberBalance.mul(splitFactor);
1479 				uint256 increaseMemberSupplyBy = multiplier1.sub(memberBalance);
1480 				balances[currentMember] = multiplier1;
1481 				emit Transfer(address(0), currentMember, increaseMemberSupplyBy);
1482 			}
1483 		}
1484 		n = allNonMembers.length;
1485 		for (i = 0; i < n; i++) {
1486 			address currentNonMember = allNonMembers[i];
1487 			// If this address started out as a nonmember and then became a member, we've seen them already in allMembers so don't grow or shrink them twice.
1488 			if (members[currentNonMember].exists) {
1489 				continue;
1490 			}
1491 			uint256 nonMemberBalance = balances[currentNonMember];
1492 			if (nonMemberBalance > 0) {
1493 				uint256 multiplier2 = nonMemberBalance.mul(splitFactor);
1494 				uint256 increaseNonMemberSupplyBy = multiplier2.sub(nonMemberBalance);
1495 				balances[currentNonMember] = multiplier2;
1496 				emit Transfer(address(0), currentNonMember, increaseNonMemberSupplyBy);
1497 			}
1498 		}
1499 		emit SplitTokens(splitFactor);
1500 		return true;
1501 	}
1502 
1503 	function reverseSplitTokensAfterDistribution(uint256 splitFactor) public onlyOwner returns (bool success) {
1504 		reverseSplitTokensBeforeDistribution(splitFactor);
1505 		uint256 n = allMembers.length;
1506 		for (uint256 i = 0; i < n; i++) {
1507 			address currentMember = allMembers[i];
1508 			uint256 memberBalance = balances[currentMember];
1509 			if (memberBalance > 0) {
1510 				uint256 divier1 = memberBalance.div(splitFactor);
1511 				uint256 decreaseMemberSupplyBy = memberBalance.sub(divier1);
1512 				balances[currentMember] = divier1;
1513 				emit Transfer(currentMember, address(0), decreaseMemberSupplyBy);
1514 			}
1515 		}
1516 		n = allNonMembers.length;
1517 		for (i = 0; i < n; i++) {
1518 			address currentNonMember = allNonMembers[i];
1519 			// If this address started out as a nonmember and then became a member, we've seen them already in allMembers so don't grow or shrink them twice.
1520 			if (members[currentNonMember].exists) {
1521 				continue;
1522 			}
1523 			uint256 nonMemberBalance = balances[currentNonMember];
1524 			if (nonMemberBalance > 0) {
1525 				uint256 divier2 = nonMemberBalance.div(splitFactor);
1526 				uint256 decreaseNonMemberSupplyBy = nonMemberBalance.sub(divier2);
1527 				balances[currentNonMember] = divier2;
1528 				emit Transfer(currentNonMember, address(0), decreaseNonMemberSupplyBy);
1529 			}
1530 		}
1531 		emit ReverseSplitTokens(splitFactor);
1532 		return true;
1533 	}
1534 
1535 	function changeMaxContribution(address memberAddress, uint256 newMax1) public onlyOwner {
1536 		// Allows to change a member's maximum contribution for phase 1.
1537 		Member storage theMember = members[memberAddress];
1538 		require(theMember.exists); // Don't allow to change for a nonexistent member.
1539 		theMember.max1 = newMax1;
1540 	}
1541 	
1542 	function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) canTransfer returns (bool success) {		
1543 		// If the transferrer has purchased tokens, they must be unlocked before they can be used.
1544 		Member storage fromMember = members[msg.sender];
1545 		if (fromMember.exists) { // If this is the owner, this check will be false so no need to check specifically for owner here.
1546 			int256 transferValue = fromMember.transferred + int(_value);
1547 			require(transferValue >= fromMember.transferred); // Check for overflow.
1548 			require(transferValue <= int(getUnlockedBalanceLimit(msg.sender))); // Make sure they don't transfer out more than their unlocked limit.
1549 			fromMember.transferred = transferValue;
1550 		}
1551 		// If any of the parties involved are not members, add them to the nonmembers list.
1552 		// Don't add the owner, since they're a special case.
1553 		if (!fromMember.exists && msg.sender != owner) {
1554 			bool fromTransferee = nonMemberTransfers[msg.sender];
1555 			if (!fromTransferee) { // If we haven't added this transferee before.
1556 				nonMemberTransfers[msg.sender] = true;
1557 				allNonMembers.push(msg.sender);
1558 			}
1559 		}
1560 		if (!members[_to].exists && _to != owner) {
1561 			bool toTransferee = nonMemberTransfers[_to];
1562 			if (!toTransferee) { // If we haven't added this transferee before.
1563 				nonMemberTransfers[_to] = true;
1564 				allNonMembers.push(_to);
1565 			}
1566 		} else if (members[_to].exists) { // Add this transfer to the unlocked balance
1567 			int256 transferInValue = members[_to].transferred - int(_value);
1568 			require(transferInValue <= members[_to].transferred); // Check for underflow.
1569 			members[_to].transferred = transferInValue;
1570 		}
1571 		return super.transfer(_to, _value);
1572 	}
1573 
1574 	function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) canTransfer returns (bool success) {
1575 		// If the transferrer has purchased tokens, they must be unlocked before they can be used.
1576 		Member storage fromMember = members[_from];
1577 		if (fromMember.exists) { // If _from is the owner, this check will always fail, so we don't need to check specifically for owner here.
1578 			int256 transferValue = fromMember.transferred + int(_value);
1579 			require(transferValue >= fromMember.transferred); // Check for overflow.
1580 			require(transferValue <= int(getUnlockedBalanceLimit(msg.sender))); // Make sure they don't transfer out more than their unlocked limit.
1581 			fromMember.transferred = transferValue;
1582 		}
1583 		// If any of the parties involved are not members, add them to the nonmembers list.
1584 		// Don't add the owner since they're a special case.
1585 		if (!fromMember.exists && _from != owner) {
1586 			bool fromTransferee = nonMemberTransfers[_from];
1587 			if (!fromTransferee) { // If we haven't added this transferee before.
1588 				nonMemberTransfers[_from] = true;
1589 				allNonMembers.push(_from);
1590 			}
1591 		}
1592 		if (!members[_to].exists && _to != owner) {
1593 			bool toTransferee = nonMemberTransfers[_to];
1594 			if (!toTransferee) { // If we haven't added this transferee before.
1595 				nonMemberTransfers[_to] = true;
1596 				allNonMembers.push(_to);
1597 			}
1598 		} else if (members[_to].exists) { // Add this transfer to the unlocked balance
1599 			int256 transferInValue = members[_to].transferred - int(_value);
1600 			require(transferInValue <= members[_to].transferred); // Check for underflow.
1601 			members[_to].transferred = transferInValue;
1602 		}
1603 		return super.transferFrom(_from, _to, _value);
1604 	}
1605 
1606 	function setOpenGroup(uint256 groupNumber) public onlyOwner returns (bool success) {
1607 		require(groupNumber < nextGroupNumber);
1608 		openGroupNumber = groupNumber;
1609 		return true;
1610 	}
1611 
1612 	function getUndistributedBalanceOf(address walletAddress, uint256 groupNumber) public view returns (uint256 balance) {
1613 		Member storage theMember = members[walletAddress];
1614 		require(theMember.exists);
1615 		if (groups[groupNumber].distributed) // Here, the group will be distributed but tokenBalance will still have a value, so that we know how many tokens to allocate to the unlocked balance.
1616 			return 0;
1617 		return theMember.tokenBalance[groupNumber];
1618 	}
1619 
1620 	function checkMyUndistributedBalance(uint256 groupNumber) public view returns (uint256 balance) {
1621 		return getUndistributedBalanceOf(msg.sender, groupNumber);
1622 	}
1623 
1624 	function transferRecovery(address _from, address _to, uint256 _value) public onlyOwner returns (bool success) {
1625 		// Will be used if someone sends tokens to an incorrect address by accident. This way, we have the ability to recover the tokens. For example, sometimes there's a problem of lost tokens if someone sends tokens to a contract address that can't utilize the tokens.
1626 		allowed[_from][msg.sender] = allowed[_from][msg.sender].add(_value); // Authorize the owner to spend on someone's behalf.
1627 		Member storage fromMember = members[_from];
1628 		if (fromMember.exists) {
1629 			int256 oldTransferred = fromMember.transferred;
1630 			fromMember.transferred -= int(_value); // Unlock this amount.
1631 			require(oldTransferred >= fromMember.transferred); // Check for underflow.
1632 		}
1633 		return transferFrom(_from, _to, _value);
1634 	}
1635 }