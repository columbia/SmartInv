1 pragma solidity ^0.5.4;
2 
3 /**
4  * @title Proxy
5  * @dev Basic proxy that delegates all calls to a fixed implementing contract.
6  * The implementing contract cannot be upgraded.
7  * @author Julien Niset - <julien@argent.im>
8  */
9 contract Proxy {
10 
11     address implementation;
12 
13     event Received(uint indexed value, address indexed sender, bytes data);
14 
15     constructor(address _implementation) public {
16         implementation = _implementation;
17     }
18 
19     function() external payable {
20 
21         if(msg.data.length == 0 && msg.value > 0) { 
22             emit Received(msg.value, msg.sender, msg.data); 
23         }
24         else {
25             // solium-disable-next-line security/no-inline-assembly
26             assembly {
27                 let target := sload(0)
28                 calldatacopy(0, 0, calldatasize())
29                 let result := delegatecall(gas, target, 0, calldatasize(), 0, 0)
30                 returndatacopy(0, 0, returndatasize())
31                 switch result 
32                 case 0 {revert(0, returndatasize())} 
33                 default {return (0, returndatasize())}
34             }
35         }
36     }
37 }
38 
39 /**
40  * @title Module
41  * @dev Interface for a module.
42  * A module MUST implement the addModule() method to ensure that a wallet with at least one module
43  * can never end up in a "frozen" state.
44  * @author Julien Niset - <julien@argent.xyz>
45  */
46 interface Module {
47 
48     /**
49      * @dev Inits a module for a wallet by e.g. setting some wallet specific parameters in storage.
50      * @param _wallet The wallet.
51      */
52     function init(BaseWallet _wallet) external;
53 
54     /**
55      * @dev Adds a module to a wallet.
56      * @param _wallet The target wallet.
57      * @param _module The modules to authorise.
58      */
59     function addModule(BaseWallet _wallet, Module _module) external;
60 
61     /**
62     * @dev Utility method to recover any ERC20 token that was sent to the
63     * module by mistake.
64     * @param _token The token to recover.
65     */
66     function recoverToken(address _token) external;
67 }
68 
69 /**
70  * @title BaseWallet
71  * @dev Simple modular wallet that authorises modules to call its invoke() method.
72  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
73  * @author Julien Niset - <julien@argent.im>
74  */
75 contract BaseWallet {
76 
77     // The implementation of the proxy
78     address public implementation;
79     // The owner 
80     address public owner;
81     // The authorised modules
82     mapping (address => bool) public authorised;
83     // The enabled static calls
84     mapping (bytes4 => address) public enabled;
85     // The number of modules
86     uint public modules;
87     
88     event AuthorisedModule(address indexed module, bool value);
89     event EnabledStaticCall(address indexed module, bytes4 indexed method);
90     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
91     event Received(uint indexed value, address indexed sender, bytes data);
92     event OwnerChanged(address owner);
93     
94     /**
95      * @dev Throws if the sender is not an authorised module.
96      */
97     modifier moduleOnly {
98         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
99         _;
100     }
101 
102     /**
103      * @dev Inits the wallet by setting the owner and authorising a list of modules.
104      * @param _owner The owner.
105      * @param _modules The modules to authorise.
106      */
107     function init(address _owner, address[] calldata _modules) external {
108         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
109         require(_modules.length > 0, "BW: construction requires at least 1 module");
110         owner = _owner;
111         modules = _modules.length;
112         for(uint256 i = 0; i < _modules.length; i++) {
113             require(authorised[_modules[i]] == false, "BW: module is already added");
114             authorised[_modules[i]] = true;
115             Module(_modules[i]).init(this);
116             emit AuthorisedModule(_modules[i], true);
117         }
118         if (address(this).balance > 0) {
119             emit Received(address(this).balance, address(0), "");
120         }
121     }
122     
123     /**
124      * @dev Enables/Disables a module.
125      * @param _module The target module.
126      * @param _value Set to true to authorise the module.
127      */
128     function authoriseModule(address _module, bool _value) external moduleOnly {
129         if (authorised[_module] != _value) {
130             emit AuthorisedModule(_module, _value);
131             if(_value == true) {
132                 modules += 1;
133                 authorised[_module] = true;
134                 Module(_module).init(this);
135             }
136             else {
137                 modules -= 1;
138                 require(modules > 0, "BW: wallet must have at least one module");
139                 delete authorised[_module];
140             }
141         }
142     }
143 
144     /**
145     * @dev Enables a static method by specifying the target module to which the call
146     * must be delegated.
147     * @param _module The target module.
148     * @param _method The static method signature.
149     */
150     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
151         require(authorised[_module], "BW: must be an authorised module for static call");
152         enabled[_method] = _module;
153         emit EnabledStaticCall(_module, _method);
154     }
155 
156     /**
157      * @dev Sets a new owner for the wallet.
158      * @param _newOwner The new owner.
159      */
160     function setOwner(address _newOwner) external moduleOnly {
161         require(_newOwner != address(0), "BW: address cannot be null");
162         owner = _newOwner;
163         emit OwnerChanged(_newOwner);
164     }
165     
166     /**
167      * @dev Performs a generic transaction.
168      * @param _target The address for the transaction.
169      * @param _value The value of the transaction.
170      * @param _data The data of the transaction.
171      */
172     function invoke(address _target, uint _value, bytes calldata _data) external moduleOnly returns (bytes memory _result) {
173         bool success;
174         // solium-disable-next-line security/no-call-value
175         (success, _result) = _target.call.value(_value)(_data);
176         if(!success) {
177             // solium-disable-next-line security/no-inline-assembly
178             assembly {
179                 returndatacopy(0, 0, returndatasize)
180                 revert(0, returndatasize)
181             }
182         }
183         emit Invoked(msg.sender, _target, _value, _data);
184     }
185 
186     /**
187      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
188      * implement specific static methods. It delegates the static call to a target contract if the data corresponds
189      * to an enabled method, or logs the call otherwise.
190      */
191     function() external payable {
192         if(msg.data.length > 0) { 
193             address module = enabled[msg.sig];
194             if(module == address(0)) {
195                 emit Received(msg.value, msg.sender, msg.data);
196             } 
197             else {
198                 require(authorised[module], "BW: must be an authorised module for static call");
199                 // solium-disable-next-line security/no-inline-assembly
200                 assembly {
201                     calldatacopy(0, 0, calldatasize())
202                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
203                     returndatacopy(0, 0, returndatasize())
204                     switch result 
205                     case 0 {revert(0, returndatasize())} 
206                     default {return (0, returndatasize())}
207                 }
208             }
209         }
210     }
211 }
212 
213 /**
214  * @title Owned
215  * @dev Basic contract to define an owner.
216  * @author Julien Niset - <julien@argent.im>
217  */
218 contract Owned {
219 
220     // The owner
221     address public owner;
222 
223     event OwnerChanged(address indexed _newOwner);
224 
225     /**
226      * @dev Throws if the sender is not the owner.
227      */
228     modifier onlyOwner {
229         require(msg.sender == owner, "Must be owner");
230         _;
231     }
232 
233     constructor() public {
234         owner = msg.sender;
235     }
236 
237     /**
238      * @dev Lets the owner transfer ownership of the contract to a new owner.
239      * @param _newOwner The new owner.
240      */
241     function changeOwner(address _newOwner) external onlyOwner {
242         require(_newOwner != address(0), "Address must not be null");
243         owner = _newOwner;
244         emit OwnerChanged(_newOwner);
245     }
246 }
247 
248 /**
249  * @title Managed
250  * @dev Basic contract that defines a set of managers. Only the owner can add/remove managers.
251  * @author Julien Niset - <julien@argent.im>
252  */
253 contract Managed is Owned {
254 
255     // The managers
256     mapping (address => bool) public managers;
257 
258     /**
259      * @dev Throws if the sender is not a manager.
260      */
261     modifier onlyManager {
262         require(managers[msg.sender] == true, "M: Must be manager");
263         _;
264     }
265 
266     event ManagerAdded(address indexed _manager);
267     event ManagerRevoked(address indexed _manager);
268 
269     /**
270     * @dev Adds a manager. 
271     * @param _manager The address of the manager.
272     */
273     function addManager(address _manager) external onlyOwner {
274         require(_manager != address(0), "M: Address must not be null");
275         if(managers[_manager] == false) {
276             managers[_manager] = true;
277             emit ManagerAdded(_manager);
278         }        
279     }
280 
281     /**
282     * @dev Revokes a manager.
283     * @param _manager The address of the manager.
284     */
285     function revokeManager(address _manager) external onlyOwner {
286         require(managers[_manager] == true, "M: Target must be an existing manager");
287         delete managers[_manager];
288         emit ManagerRevoked(_manager);
289     }
290 }
291 
292 /**
293  * ENS Registry interface.
294  */
295 contract ENSRegistry {
296     function owner(bytes32 _node) public view returns (address);
297     function resolver(bytes32 _node) public view returns (address);
298     function ttl(bytes32 _node) public view returns (uint64);
299     function setOwner(bytes32 _node, address _owner) public;
300     function setSubnodeOwner(bytes32 _node, bytes32 _label, address _owner) public;
301     function setResolver(bytes32 _node, address _resolver) public;
302     function setTTL(bytes32 _node, uint64 _ttl) public;
303 }
304 
305 /**
306  * ENS Resolver interface.
307  */
308 contract ENSResolver {
309     function addr(bytes32 _node) public view returns (address);
310     function setAddr(bytes32 _node, address _addr) public;
311     function name(bytes32 _node) public view returns (string memory);
312     function setName(bytes32 _node, string memory _name) public;
313 }
314 
315 /**
316  * ENS Reverse Registrar interface.
317  */
318 contract ENSReverseRegistrar {
319     function claim(address _owner) public returns (bytes32 _node);
320     function claimWithResolver(address _owner, address _resolver) public returns (bytes32);
321     function setName(string memory _name) public returns (bytes32);
322     function node(address _addr) public returns (bytes32);
323 }/*
324  * @title String & slice utility library for Solidity contracts.
325  * @author Nick Johnson <arachnid@notdot.net>
326  *
327  * @dev Functionality in this library is largely implemented using an
328  *      abstraction called a 'slice'. A slice represents a part of a string -
329  *      anything from the entire string to a single character, or even no
330  *      characters at all (a 0-length slice). Since a slice only has to specify
331  *      an offset and a length, copying and manipulating slices is a lot less
332  *      expensive than copying and manipulating the strings they reference.
333  *
334  *      To further reduce gas costs, most functions on slice that need to return
335  *      a slice modify the original one instead of allocating a new one; for
336  *      instance, `s.split(".")` will return the text up to the first '.',
337  *      modifying s to only contain the remainder of the string after the '.'.
338  *      In situations where you do not want to modify the original slice, you
339  *      can make a copy first with `.copy()`, for example:
340  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
341  *      Solidity has no memory management, it will result in allocating many
342  *      short-lived slices that are later discarded.
343  *
344  *      Functions that return two slices come in two versions: a non-allocating
345  *      version that takes the second slice as an argument, modifying it in
346  *      place, and an allocating version that allocates and returns the second
347  *      slice; see `nextRune` for example.
348  *
349  *      Functions that have to copy string data will return strings rather than
350  *      slices; these can be cast back to slices for further processing if
351  *      required.
352  *
353  *      For convenience, some functions are provided with non-modifying
354  *      variants that create a new slice and return both; for instance,
355  *      `s.splitNew('.')` leaves s unmodified, and returns two values
356  *      corresponding to the left and right parts of the string.
357  */
358 
359 // 
360 pragma solidity ^0.5.4;
361 
362 /* solium-disable */
363 library strings {
364     struct slice {
365         uint _len;
366         uint _ptr;
367     }
368 
369     function memcpy(uint dest, uint src, uint len) private pure {
370         // Copy word-length chunks while possible
371         for(; len >= 32; len -= 32) {
372             assembly {
373                 mstore(dest, mload(src))
374             }
375             dest += 32;
376             src += 32;
377         }
378 
379         // Copy remaining bytes
380         uint mask = 256 ** (32 - len) - 1;
381         assembly {
382             let srcpart := and(mload(src), not(mask))
383             let destpart := and(mload(dest), mask)
384             mstore(dest, or(destpart, srcpart))
385         }
386     }
387 
388     /*
389      * @dev Returns a slice containing the entire string.
390      * @param self The string to make a slice from.
391      * @return A newly allocated slice containing the entire string.
392      */
393     function toSlice(string memory self) internal pure returns (slice memory) {
394         uint ptr;
395         assembly {
396             ptr := add(self, 0x20)
397         }
398         return slice(bytes(self).length, ptr);
399     }
400 
401     /*
402      * @dev Returns the length of a null-terminated bytes32 string.
403      * @param self The value to find the length of.
404      * @return The length of the string, from 0 to 32.
405      */
406     function len(bytes32 self) internal pure returns (uint) {
407         uint ret;
408         if (self == 0)
409             return 0;
410         if (uint256(self) & 0xffffffffffffffffffffffffffffffff == 0) {
411             ret += 16;
412             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
413         }
414         if (uint256(self) & 0xffffffffffffffff == 0) {
415             ret += 8;
416             self = bytes32(uint(self) / 0x10000000000000000);
417         }
418         if (uint256(self) & 0xffffffff == 0) {
419             ret += 4;
420             self = bytes32(uint(self) / 0x100000000);
421         }
422         if (uint256(self) & 0xffff == 0) {
423             ret += 2;
424             self = bytes32(uint(self) / 0x10000);
425         }
426         if (uint256(self) & 0xff == 0) {
427             ret += 1;
428         }
429         return 32 - ret;
430     }
431 
432     /*
433      * @dev Returns a slice containing the entire bytes32, interpreted as a
434      *      null-terminated utf-8 string.
435      * @param self The bytes32 value to convert to a slice.
436      * @return A new slice containing the value of the input argument up to the
437      *         first null.
438      */
439     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
440         // Allocate space for `self` in memory, copy it there, and point ret at it
441         assembly {
442             let ptr := mload(0x40)
443             mstore(0x40, add(ptr, 0x20))
444             mstore(ptr, self)
445             mstore(add(ret, 0x20), ptr)
446         }
447         ret._len = len(self);
448     }
449 
450     /*
451      * @dev Returns a new slice containing the same data as the current slice.
452      * @param self The slice to copy.
453      * @return A new slice containing the same data as `self`.
454      */
455     function copy(slice memory self) internal pure returns (slice memory) {
456         return slice(self._len, self._ptr);
457     }
458 
459     /*
460      * @dev Copies a slice to a new string.
461      * @param self The slice to copy.
462      * @return A newly allocated string containing the slice's text.
463      */
464     function toString(slice memory self) internal pure returns (string memory) {
465         string memory ret = new string(self._len);
466         uint retptr;
467         assembly { retptr := add(ret, 32) }
468 
469         memcpy(retptr, self._ptr, self._len);
470         return ret;
471     }
472 
473     /*
474      * @dev Returns the length in runes of the slice. Note that this operation
475      *      takes time proportional to the length of the slice; avoid using it
476      *      in loops, and call `slice.empty()` if you only need to know whether
477      *      the slice is empty or not.
478      * @param self The slice to operate on.
479      * @return The length of the slice in runes.
480      */
481     function len(slice memory self) internal pure returns (uint l) {
482         // Starting at ptr-31 means the LSB will be the byte we care about
483         uint ptr = self._ptr - 31;
484         uint end = ptr + self._len;
485         for (l = 0; ptr < end; l++) {
486             uint8 b;
487             assembly { b := and(mload(ptr), 0xFF) }
488             if (b < 0x80) {
489                 ptr += 1;
490             } else if(b < 0xE0) {
491                 ptr += 2;
492             } else if(b < 0xF0) {
493                 ptr += 3;
494             } else if(b < 0xF8) {
495                 ptr += 4;
496             } else if(b < 0xFC) {
497                 ptr += 5;
498             } else {
499                 ptr += 6;
500             }
501         }
502     }
503 
504     /*
505      * @dev Returns true if the slice is empty (has a length of 0).
506      * @param self The slice to operate on.
507      * @return True if the slice is empty, False otherwise.
508      */
509     function empty(slice memory self) internal pure returns (bool) {
510         return self._len == 0;
511     }
512 
513     /*
514      * @dev Returns a positive number if `other` comes lexicographically after
515      *      `self`, a negative number if it comes before, or zero if the
516      *      contents of the two slices are equal. Comparison is done per-rune,
517      *      on unicode codepoints.
518      * @param self The first slice to compare.
519      * @param other The second slice to compare.
520      * @return The result of the comparison.
521      */
522     function compare(slice memory self, slice memory other) internal pure returns (int) {
523         uint shortest = self._len;
524         if (other._len < self._len)
525             shortest = other._len;
526 
527         uint selfptr = self._ptr;
528         uint otherptr = other._ptr;
529         for (uint idx = 0; idx < shortest; idx += 32) {
530             uint a;
531             uint b;
532             assembly {
533                 a := mload(selfptr)
534                 b := mload(otherptr)
535             }
536             if (a != b) {
537                 // Mask out irrelevant bytes and check again
538                 uint256 mask = uint256(-1); // 0xffff...
539                 if(shortest < 32) {
540                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
541                 }
542                 uint256 diff = (a & mask) - (b & mask);
543                 if (diff != 0)
544                     return int(diff);
545             }
546             selfptr += 32;
547             otherptr += 32;
548         }
549         return int(self._len) - int(other._len);
550     }
551 
552     /*
553      * @dev Returns true if the two slices contain the same text.
554      * @param self The first slice to compare.
555      * @param self The second slice to compare.
556      * @return True if the slices are equal, false otherwise.
557      */
558     function equals(slice memory self, slice memory other) internal pure returns (bool) {
559         return compare(self, other) == 0;
560     }
561 
562     /*
563      * @dev Extracts the first rune in the slice into `rune`, advancing the
564      *      slice to point to the next rune and returning `self`.
565      * @param self The slice to operate on.
566      * @param rune The slice that will contain the first rune.
567      * @return `rune`.
568      */
569     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
570         rune._ptr = self._ptr;
571 
572         if (self._len == 0) {
573             rune._len = 0;
574             return rune;
575         }
576 
577         uint l;
578         uint b;
579         // Load the first byte of the rune into the LSBs of b
580         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
581         if (b < 0x80) {
582             l = 1;
583         } else if(b < 0xE0) {
584             l = 2;
585         } else if(b < 0xF0) {
586             l = 3;
587         } else {
588             l = 4;
589         }
590 
591         // Check for truncated codepoints
592         if (l > self._len) {
593             rune._len = self._len;
594             self._ptr += self._len;
595             self._len = 0;
596             return rune;
597         }
598 
599         self._ptr += l;
600         self._len -= l;
601         rune._len = l;
602         return rune;
603     }
604 
605     /*
606      * @dev Returns the first rune in the slice, advancing the slice to point
607      *      to the next rune.
608      * @param self The slice to operate on.
609      * @return A slice containing only the first rune from `self`.
610      */
611     function nextRune(slice memory self) internal pure returns (slice memory ret) {
612         nextRune(self, ret);
613     }
614 
615     /*
616      * @dev Returns the number of the first codepoint in the slice.
617      * @param self The slice to operate on.
618      * @return The number of the first codepoint in the slice.
619      */
620     function ord(slice memory self) internal pure returns (uint ret) {
621         if (self._len == 0) {
622             return 0;
623         }
624 
625         uint word;
626         uint length;
627         uint divisor = 2 ** 248;
628 
629         // Load the rune into the MSBs of b
630         assembly { word:= mload(mload(add(self, 32))) }
631         uint b = word / divisor;
632         if (b < 0x80) {
633             ret = b;
634             length = 1;
635         } else if(b < 0xE0) {
636             ret = b & 0x1F;
637             length = 2;
638         } else if(b < 0xF0) {
639             ret = b & 0x0F;
640             length = 3;
641         } else {
642             ret = b & 0x07;
643             length = 4;
644         }
645 
646         // Check for truncated codepoints
647         if (length > self._len) {
648             return 0;
649         }
650 
651         for (uint i = 1; i < length; i++) {
652             divisor = divisor / 256;
653             b = (word / divisor) & 0xFF;
654             if (b & 0xC0 != 0x80) {
655                 // Invalid UTF-8 sequence
656                 return 0;
657             }
658             ret = (ret * 64) | (b & 0x3F);
659         }
660 
661         return ret;
662     }
663 
664     /*
665      * @dev Returns the keccak-256 hash of the slice.
666      * @param self The slice to hash.
667      * @return The hash of the slice.
668      */
669     function keccak(slice memory self) internal pure returns (bytes32 ret) {
670         assembly {
671             ret := keccak256(mload(add(self, 32)), mload(self))
672         }
673     }
674 
675     /*
676      * @dev Returns true if `self` starts with `needle`.
677      * @param self The slice to operate on.
678      * @param needle The slice to search for.
679      * @return True if the slice starts with the provided text, false otherwise.
680      */
681     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
682         if (self._len < needle._len) {
683             return false;
684         }
685 
686         if (self._ptr == needle._ptr) {
687             return true;
688         }
689 
690         bool equal;
691         assembly {
692             let length := mload(needle)
693             let selfptr := mload(add(self, 0x20))
694             let needleptr := mload(add(needle, 0x20))
695             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
696         }
697         return equal;
698     }
699 
700     /*
701      * @dev If `self` starts with `needle`, `needle` is removed from the
702      *      beginning of `self`. Otherwise, `self` is unmodified.
703      * @param self The slice to operate on.
704      * @param needle The slice to search for.
705      * @return `self`
706      */
707     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
708         if (self._len < needle._len) {
709             return self;
710         }
711 
712         bool equal = true;
713         if (self._ptr != needle._ptr) {
714             assembly {
715                 let length := mload(needle)
716                 let selfptr := mload(add(self, 0x20))
717                 let needleptr := mload(add(needle, 0x20))
718                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
719             }
720         }
721 
722         if (equal) {
723             self._len -= needle._len;
724             self._ptr += needle._len;
725         }
726 
727         return self;
728     }
729 
730     /*
731      * @dev Returns true if the slice ends with `needle`.
732      * @param self The slice to operate on.
733      * @param needle The slice to search for.
734      * @return True if the slice starts with the provided text, false otherwise.
735      */
736     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
737         if (self._len < needle._len) {
738             return false;
739         }
740 
741         uint selfptr = self._ptr + self._len - needle._len;
742 
743         if (selfptr == needle._ptr) {
744             return true;
745         }
746 
747         bool equal;
748         assembly {
749             let length := mload(needle)
750             let needleptr := mload(add(needle, 0x20))
751             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
752         }
753 
754         return equal;
755     }
756 
757     /*
758      * @dev If `self` ends with `needle`, `needle` is removed from the
759      *      end of `self`. Otherwise, `self` is unmodified.
760      * @param self The slice to operate on.
761      * @param needle The slice to search for.
762      * @return `self`
763      */
764     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
765         if (self._len < needle._len) {
766             return self;
767         }
768 
769         uint selfptr = self._ptr + self._len - needle._len;
770         bool equal = true;
771         if (selfptr != needle._ptr) {
772             assembly {
773                 let length := mload(needle)
774                 let needleptr := mload(add(needle, 0x20))
775                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
776             }
777         }
778 
779         if (equal) {
780             self._len -= needle._len;
781         }
782 
783         return self;
784     }
785 
786     // Returns the memory address of the first byte of the first occurrence of
787     // `needle` in `self`, or the first byte after `self` if not found.
788     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
789         uint ptr = selfptr;
790         uint idx;
791 
792         if (needlelen <= selflen) {
793             if (needlelen <= 32) {
794                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
795 
796                 bytes32 needledata;
797                 assembly { needledata := and(mload(needleptr), mask) }
798 
799                 uint end = selfptr + selflen - needlelen;
800                 bytes32 ptrdata;
801                 assembly { ptrdata := and(mload(ptr), mask) }
802 
803                 while (ptrdata != needledata) {
804                     if (ptr >= end)
805                         return selfptr + selflen;
806                     ptr++;
807                     assembly { ptrdata := and(mload(ptr), mask) }
808                 }
809                 return ptr;
810             } else {
811                 // For long needles, use hashing
812                 bytes32 hash;
813                 assembly { hash := keccak256(needleptr, needlelen) }
814 
815                 for (idx = 0; idx <= selflen - needlelen; idx++) {
816                     bytes32 testHash;
817                     assembly { testHash := keccak256(ptr, needlelen) }
818                     if (hash == testHash)
819                         return ptr;
820                     ptr += 1;
821                 }
822             }
823         }
824         return selfptr + selflen;
825     }
826 
827     // Returns the memory address of the first byte after the last occurrence of
828     // `needle` in `self`, or the address of `self` if not found.
829     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
830         uint ptr;
831 
832         if (needlelen <= selflen) {
833             if (needlelen <= 32) {
834                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
835 
836                 bytes32 needledata;
837                 assembly { needledata := and(mload(needleptr), mask) }
838 
839                 ptr = selfptr + selflen - needlelen;
840                 bytes32 ptrdata;
841                 assembly { ptrdata := and(mload(ptr), mask) }
842 
843                 while (ptrdata != needledata) {
844                     if (ptr <= selfptr)
845                         return selfptr;
846                     ptr--;
847                     assembly { ptrdata := and(mload(ptr), mask) }
848                 }
849                 return ptr + needlelen;
850             } else {
851                 // For long needles, use hashing
852                 bytes32 hash;
853                 assembly { hash := keccak256(needleptr, needlelen) }
854                 ptr = selfptr + (selflen - needlelen);
855                 while (ptr >= selfptr) {
856                     bytes32 testHash;
857                     assembly { testHash := keccak256(ptr, needlelen) }
858                     if (hash == testHash)
859                         return ptr + needlelen;
860                     ptr -= 1;
861                 }
862             }
863         }
864         return selfptr;
865     }
866 
867     /*
868      * @dev Modifies `self` to contain everything from the first occurrence of
869      *      `needle` to the end of the slice. `self` is set to the empty slice
870      *      if `needle` is not found.
871      * @param self The slice to search and modify.
872      * @param needle The text to search for.
873      * @return `self`.
874      */
875     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
876         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
877         self._len -= ptr - self._ptr;
878         self._ptr = ptr;
879         return self;
880     }
881 
882     /*
883      * @dev Modifies `self` to contain the part of the string from the start of
884      *      `self` to the end of the first occurrence of `needle`. If `needle`
885      *      is not found, `self` is set to the empty slice.
886      * @param self The slice to search and modify.
887      * @param needle The text to search for.
888      * @return `self`.
889      */
890     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
891         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
892         self._len = ptr - self._ptr;
893         return self;
894     }
895 
896     /*
897      * @dev Splits the slice, setting `self` to everything after the first
898      *      occurrence of `needle`, and `token` to everything before it. If
899      *      `needle` does not occur in `self`, `self` is set to the empty slice,
900      *      and `token` is set to the entirety of `self`.
901      * @param self The slice to split.
902      * @param needle The text to search for in `self`.
903      * @param token An output parameter to which the first token is written.
904      * @return `token`.
905      */
906     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
907         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
908         token._ptr = self._ptr;
909         token._len = ptr - self._ptr;
910         if (ptr == self._ptr + self._len) {
911             // Not found
912             self._len = 0;
913         } else {
914             self._len -= token._len + needle._len;
915             self._ptr = ptr + needle._len;
916         }
917         return token;
918     }
919 
920     /*
921      * @dev Splits the slice, setting `self` to everything after the first
922      *      occurrence of `needle`, and returning everything before it. If
923      *      `needle` does not occur in `self`, `self` is set to the empty slice,
924      *      and the entirety of `self` is returned.
925      * @param self The slice to split.
926      * @param needle The text to search for in `self`.
927      * @return The part of `self` up to the first occurrence of `delim`.
928      */
929     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
930         split(self, needle, token);
931     }
932 
933     /*
934      * @dev Splits the slice, setting `self` to everything before the last
935      *      occurrence of `needle`, and `token` to everything after it. If
936      *      `needle` does not occur in `self`, `self` is set to the empty slice,
937      *      and `token` is set to the entirety of `self`.
938      * @param self The slice to split.
939      * @param needle The text to search for in `self`.
940      * @param token An output parameter to which the first token is written.
941      * @return `token`.
942      */
943     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
944         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
945         token._ptr = ptr;
946         token._len = self._len - (ptr - self._ptr);
947         if (ptr == self._ptr) {
948             // Not found
949             self._len = 0;
950         } else {
951             self._len -= token._len + needle._len;
952         }
953         return token;
954     }
955 
956     /*
957      * @dev Splits the slice, setting `self` to everything before the last
958      *      occurrence of `needle`, and returning everything after it. If
959      *      `needle` does not occur in `self`, `self` is set to the empty slice,
960      *      and the entirety of `self` is returned.
961      * @param self The slice to split.
962      * @param needle The text to search for in `self`.
963      * @return The part of `self` after the last occurrence of `delim`.
964      */
965     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
966         rsplit(self, needle, token);
967     }
968 
969     /*
970      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
971      * @param self The slice to search.
972      * @param needle The text to search for in `self`.
973      * @return The number of occurrences of `needle` found in `self`.
974      */
975     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
976         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
977         while (ptr <= self._ptr + self._len) {
978             cnt++;
979             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
980         }
981     }
982 
983     /*
984      * @dev Returns True if `self` contains `needle`.
985      * @param self The slice to search.
986      * @param needle The text to search for in `self`.
987      * @return True if `needle` is found in `self`, false otherwise.
988      */
989     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
990         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
991     }
992 
993     /*
994      * @dev Returns a newly allocated string containing the concatenation of
995      *      `self` and `other`.
996      * @param self The first slice to concatenate.
997      * @param other The second slice to concatenate.
998      * @return The concatenation of the two strings.
999      */
1000     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1001         string memory ret = new string(self._len + other._len);
1002         uint retptr;
1003         assembly { retptr := add(ret, 32) }
1004         memcpy(retptr, self._ptr, self._len);
1005         memcpy(retptr + self._len, other._ptr, other._len);
1006         return ret;
1007     }
1008 
1009     /*
1010      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1011      *      newly allocated string.
1012      * @param self The delimiter to use.
1013      * @param parts A list of slices to join.
1014      * @return A newly allocated string containing all the slices in `parts`,
1015      *         joined with `self`.
1016      */
1017     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
1018         if (parts.length == 0)
1019             return "";
1020 
1021         uint length = self._len * (parts.length - 1);
1022         for(uint i = 0; i < parts.length; i++)
1023             length += parts[i]._len;
1024 
1025         string memory ret = new string(length);
1026         uint retptr;
1027         assembly { retptr := add(ret, 32) }
1028 
1029         for(uint i = 0; i < parts.length; i++) {
1030             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1031             retptr += parts[i]._len;
1032             if (i < parts.length - 1) {
1033                 memcpy(retptr, self._ptr, self._len);
1034                 retptr += self._len;
1035             }
1036         }
1037 
1038         return ret;
1039     }
1040 }
1041 
1042 
1043 /**
1044  * @title ENSConsumer
1045  * @dev Helper contract to resolve ENS names.
1046  * @author Julien Niset - <julien@argent.im>
1047  */
1048 contract ENSConsumer {
1049 
1050     using strings for *;
1051 
1052     // namehash('addr.reverse')
1053     bytes32 constant public ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
1054 
1055     // the address of the ENS registry
1056     address ensRegistry;
1057 
1058     /**
1059     * @dev No address should be provided when deploying on Mainnet to avoid storage cost. The 
1060     * contract will use the hardcoded value.
1061     */
1062     constructor(address _ensRegistry) public {
1063         ensRegistry = _ensRegistry;
1064     }
1065 
1066     /**
1067     * @dev Resolves an ENS name to an address.
1068     * @param _node The namehash of the ENS name. 
1069     */
1070     function resolveEns(bytes32 _node) public view returns (address) {
1071         address resolver = getENSRegistry().resolver(_node);
1072         return ENSResolver(resolver).addr(_node);
1073     }
1074 
1075     /**
1076     * @dev Gets the official ENS registry.
1077     */
1078     function getENSRegistry() public view returns (ENSRegistry) {
1079         return ENSRegistry(ensRegistry);
1080     }
1081 
1082     /**
1083     * @dev Gets the official ENS reverse registrar. 
1084     */
1085     function getENSReverseRegistrar() public view returns (ENSReverseRegistrar) {
1086         return ENSReverseRegistrar(getENSRegistry().owner(ADDR_REVERSE_NODE));
1087     }
1088 }
1089 
1090 
1091 
1092 
1093 /**
1094  * @dev Interface for an ENS Mananger.
1095  */
1096 interface IENSManager {
1097     function changeRootnodeOwner(address _newOwner) external;
1098     function register(string calldata _label, address _owner) external;
1099     function isAvailable(bytes32 _subnode) external view returns(bool);
1100 }
1101 
1102 /**
1103  * @title ArgentENSManager
1104  * @dev Implementation of an ENS manager that orchestrates the complete
1105  * registration of subdomains for a single root (e.g. argent.eth). 
1106  * The contract defines a manager role who is the only role that can trigger the registration of
1107  * a new subdomain.
1108  * @author Julien Niset - <julien@argent.im>
1109  */
1110 contract ArgentENSManager is IENSManager, Owned, Managed, ENSConsumer {
1111     
1112     using strings for *;
1113 
1114     // The managed root name
1115     string public rootName;
1116     // The managed root node
1117     bytes32 public rootNode;
1118     // The address of the ENS resolver
1119     address public ensResolver;
1120 
1121     // *************** Events *************************** //
1122 
1123     event RootnodeOwnerChange(bytes32 indexed _rootnode, address indexed _newOwner);
1124     event ENSResolverChanged(address addr);
1125     event Registered(address indexed _owner, string _ens);
1126     event Unregistered(string _ens);
1127 
1128     // *************** Constructor ********************** //
1129 
1130     /**
1131      * @dev Constructor that sets the ENS root name and root node to manage.
1132      * @param _rootName The root name (e.g. argentx.eth).
1133      * @param _rootNode The node of the root name (e.g. namehash(argentx.eth)).
1134      */
1135     constructor(string memory _rootName, bytes32 _rootNode, address _ensRegistry, address _ensResolver) ENSConsumer(_ensRegistry) public {
1136         rootName = _rootName;
1137         rootNode = _rootNode;
1138         ensResolver = _ensResolver;
1139     }
1140 
1141     // *************** External Functions ********************* //
1142 
1143     /**
1144      * @dev This function must be called when the ENS Manager contract is replaced
1145      * and the address of the new Manager should be provided.
1146      * @param _newOwner The address of the new ENS manager that will manage the root node.
1147      */
1148     function changeRootnodeOwner(address _newOwner) external onlyOwner {
1149         getENSRegistry().setOwner(rootNode, _newOwner);
1150         emit RootnodeOwnerChange(rootNode, _newOwner);
1151     }
1152 
1153     /**
1154      * @dev Lets the owner change the address of the ENS resolver contract.
1155      * @param _ensResolver The address of the ENS resolver contract.
1156      */
1157     function changeENSResolver(address _ensResolver) external onlyOwner {
1158         require(_ensResolver != address(0), "WF: address cannot be null");
1159         ensResolver = _ensResolver;
1160         emit ENSResolverChanged(_ensResolver);
1161     }
1162 
1163     /** 
1164     * @dev Lets the manager assign an ENS subdomain of the root node to a target address.
1165     * Registers both the forward and reverse ENS.
1166     * @param _label The subdomain label.
1167     * @param _owner The owner of the subdomain.
1168     */
1169     function register(string calldata _label, address _owner) external onlyManager {
1170         bytes32 labelNode = keccak256(abi.encodePacked(_label));
1171         bytes32 node = keccak256(abi.encodePacked(rootNode, labelNode));
1172         address currentOwner = getENSRegistry().owner(node);
1173         require(currentOwner == address(0), "AEM: _label is alrealdy owned");
1174 
1175         // Forward ENS
1176         getENSRegistry().setSubnodeOwner(rootNode, labelNode, address(this));
1177         getENSRegistry().setResolver(node, ensResolver);
1178         getENSRegistry().setOwner(node, _owner);
1179         ENSResolver(ensResolver).setAddr(node, _owner);
1180 
1181         // Reverse ENS
1182         strings.slice[] memory parts = new strings.slice[](2);
1183         parts[0] = _label.toSlice();
1184         parts[1] = rootName.toSlice();
1185         string memory name = ".".toSlice().join(parts);
1186         bytes32 reverseNode = getENSReverseRegistrar().node(_owner);
1187         ENSResolver(ensResolver).setName(reverseNode, name);
1188 
1189         emit Registered(_owner, name);
1190     }
1191 
1192     // *************** Public Functions ********************* //
1193 
1194     /**
1195      * @dev Returns true is a given subnode is available.
1196      * @param _subnode The target subnode.
1197      * @return true if the subnode is available.
1198      */
1199     function isAvailable(bytes32 _subnode) public view returns (bool) {
1200         bytes32 node = keccak256(abi.encodePacked(rootNode, _subnode));
1201         address currentOwner = getENSRegistry().owner(node);
1202         if(currentOwner == address(0)) {
1203             return true;
1204         }
1205         return false;
1206     }
1207 }
1208 
1209 
1210 /**
1211  * ERC20 contract interface.
1212  */
1213 contract ERC20 {
1214     function totalSupply() public view returns (uint);
1215     function decimals() public view returns (uint);
1216     function balanceOf(address tokenOwner) public view returns (uint balance);
1217     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
1218     function transfer(address to, uint tokens) public returns (bool success);
1219     function approve(address spender, uint tokens) public returns (bool success);
1220     function transferFrom(address from, address to, uint tokens) public returns (bool success);
1221 }
1222 
1223 
1224 
1225 /**
1226  * @title ModuleRegistry
1227  * @dev Registry of authorised modules. 
1228  * Modules must be registered before they can be authorised on a wallet.
1229  * @author Julien Niset - <julien@argent.im>
1230  */
1231 contract ModuleRegistry is Owned {
1232 
1233     mapping (address => Info) internal modules;
1234     mapping (address => Info) internal upgraders;
1235 
1236     event ModuleRegistered(address indexed module, bytes32 name);
1237     event ModuleDeRegistered(address module);
1238     event UpgraderRegistered(address indexed upgrader, bytes32 name);
1239     event UpgraderDeRegistered(address upgrader);
1240 
1241     struct Info {
1242         bool exists;
1243         bytes32 name;
1244     }
1245 
1246     /**
1247      * @dev Registers a module.
1248      * @param _module The module.
1249      * @param _name The unique name of the module.
1250      */
1251     function registerModule(address _module, bytes32 _name) external onlyOwner {
1252         require(!modules[_module].exists, "MR: module already exists");
1253         modules[_module] = Info({exists: true, name: _name});
1254         emit ModuleRegistered(_module, _name);
1255     }
1256 
1257     /**
1258      * @dev Deregisters a module.
1259      * @param _module The module.
1260      */
1261     function deregisterModule(address _module) external onlyOwner {
1262         require(modules[_module].exists, "MR: module does not exist");
1263         delete modules[_module];
1264         emit ModuleDeRegistered(_module);
1265     }
1266 
1267         /**
1268      * @dev Registers an upgrader.
1269      * @param _upgrader The upgrader.
1270      * @param _name The unique name of the upgrader.
1271      */
1272     function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
1273         require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
1274         upgraders[_upgrader] = Info({exists: true, name: _name});
1275         emit UpgraderRegistered(_upgrader, _name);
1276     }
1277 
1278     /**
1279      * @dev Deregisters an upgrader.
1280      * @param _upgrader The _upgrader.
1281      */
1282     function deregisterUpgrader(address _upgrader) external onlyOwner {
1283         require(upgraders[_upgrader].exists, "MR: upgrader does not exist");
1284         delete upgraders[_upgrader];
1285         emit UpgraderDeRegistered(_upgrader);
1286     }
1287 
1288     /**
1289     * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
1290     * registry.
1291     * @param _token The token to recover.
1292     */
1293     function recoverToken(address _token) external onlyOwner {
1294         uint total = ERC20(_token).balanceOf(address(this));
1295         ERC20(_token).transfer(msg.sender, total);
1296     } 
1297 
1298     /**
1299      * @dev Gets the name of a module from its address.
1300      * @param _module The module address.
1301      * @return the name.
1302      */
1303     function moduleInfo(address _module) external view returns (bytes32) {
1304         return modules[_module].name;
1305     }
1306 
1307     /**
1308      * @dev Gets the name of an upgrader from its address.
1309      * @param _upgrader The upgrader address.
1310      * @return the name.
1311      */
1312     function upgraderInfo(address _upgrader) external view returns (bytes32) {
1313         return upgraders[_upgrader].name;
1314     }
1315 
1316     /**
1317      * @dev Checks if a module is registered.
1318      * @param _module The module address.
1319      * @return true if the module is registered.
1320      */
1321     function isRegisteredModule(address _module) external view returns (bool) {
1322         return modules[_module].exists;
1323     }
1324 
1325     /**
1326      * @dev Checks if a list of modules are registered.
1327      * @param _modules The list of modules address.
1328      * @return true if all the modules are registered.
1329      */
1330     function isRegisteredModule(address[] calldata _modules) external view returns (bool) {
1331         for(uint i = 0; i < _modules.length; i++) {
1332             if (!modules[_modules[i]].exists) {
1333                 return false;
1334             }
1335         }
1336         return true;
1337     }  
1338 
1339     /**
1340      * @dev Checks if an upgrader is registered.
1341      * @param _upgrader The upgrader address.
1342      * @return true if the upgrader is registered.
1343      */
1344     function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
1345         return upgraders[_upgrader].exists;
1346     } 
1347 
1348 }
1349 
1350 
1351 
1352 
1353 
1354 
1355 
1356 /**
1357  * @title WalletFactory
1358  * @dev The WalletFactory contract creates and assigns wallets to accounts.
1359  * @author Julien Niset - <julien@argent.im>
1360  */
1361 contract WalletFactory is Owned, Managed, ENSConsumer {
1362 
1363     // The address of the module dregistry
1364     address public moduleRegistry;
1365     // The address of the base wallet implementation
1366     address public walletImplementation;
1367     // The address of the ENS manager
1368     address public ensManager;
1369     // The address of the ENS resolver
1370     address public ensResolver;
1371 
1372     // *************** Events *************************** //
1373 
1374     event ModuleRegistryChanged(address addr);
1375     event WalletImplementationChanged(address addr);
1376     event ENSManagerChanged(address addr);
1377     event ENSResolverChanged(address addr);
1378     event WalletCreated(address indexed _wallet, address indexed _owner);
1379 
1380     // *************** Constructor ********************** //
1381 
1382     /**
1383      * @dev Default constructor.
1384      */
1385     constructor(
1386         address _ensRegistry, 
1387         address _moduleRegistry,
1388         address _walletImplementation, 
1389         address _ensManager, 
1390         address _ensResolver
1391     ) 
1392         ENSConsumer(_ensRegistry) 
1393         public 
1394     {
1395         moduleRegistry = _moduleRegistry;
1396         walletImplementation = _walletImplementation;
1397         ensManager = _ensManager;
1398         ensResolver = _ensResolver;
1399     }
1400 
1401     // *************** External Functions ********************* //
1402 
1403     /**
1404      * @dev Lets the manager create a wallet for an account. The wallet is initialised with a list of modules.
1405      * @param _owner The account address.
1406      * @param _modules The list of modules.
1407      * @param _label Optional ENS label of the new wallet (e.g. franck).
1408      */
1409     function createWallet(
1410         address _owner,
1411         address[] calldata _modules,
1412         string calldata _label
1413     ) external onlyManager {
1414         _validateInputs(_owner, _modules);
1415         // create the proxy
1416         Proxy proxy = new Proxy(walletImplementation);
1417         address payable wallet = address(proxy);
1418         // check for ENS
1419         bytes memory labelBytes = bytes(_label);
1420         if (labelBytes.length != 0) {
1421             // add the factory to the modules so it can claim the reverse ENS
1422             address[] memory extendedModules = new address[](_modules.length + 1);
1423             extendedModules[0] = address(this);
1424             for(uint i = 0; i < _modules.length; i++) {
1425                 extendedModules[i + 1] = _modules[i];
1426             }
1427             // initialise the wallet with the owner and the extended modules
1428             BaseWallet(wallet).init(_owner, extendedModules);
1429             // register ENS
1430             registerWalletENS(wallet, _label);
1431             // remove the factory from the authorised modules
1432             BaseWallet(wallet).authoriseModule(address(this), false);
1433         } else {
1434             // initialise the wallet with the owner and the modules
1435             BaseWallet(wallet).init(_owner, _modules);
1436         }
1437         emit WalletCreated(wallet, _owner);
1438     }
1439 
1440     /**
1441      * @dev Gets the address of a counterfactual wallet.
1442      * @param _owner The account address.
1443      * @param _modules The list of modules.
1444      * @param _salt The salt.
1445      * @return the address that the wallet will have when created using CREATE2 and the same input parameters.
1446      */
1447     function getAddressForCounterfactualWallet(
1448         address _owner,
1449         address[] calldata _modules,
1450         bytes32 _salt
1451     )
1452         external
1453         view
1454         returns (address)
1455     {
1456         bytes32 newsalt = _newSalt(_salt, _owner, _modules);
1457         bytes memory code = abi.encodePacked(type(Proxy).creationCode, uint256(walletImplementation));
1458         bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), newsalt, keccak256(code)));
1459         return address(uint160(uint256(hash)));
1460     }
1461 
1462     /**
1463      * @dev Lets the manager create a wallet for an account at a specific address.
1464      * The wallet is initialised with a list of modules and salt.
1465      * The wallet is created using the CREATE2 opcode.
1466      * @param _owner The account address.
1467      * @param _modules The list of modules.
1468      * @param _label Optional ENS label of the new wallet (e.g. franck).
1469      * @param _salt The salt.
1470      */
1471     function createCounterfactualWallet(
1472         address _owner,
1473         address[] calldata _modules,
1474         string calldata _label,
1475         bytes32 _salt
1476     )
1477         external
1478         onlyManager
1479     {
1480         _validateInputs(_owner, _modules);
1481         // create the salt
1482         bytes32 newsalt = _newSalt(_salt, _owner, _modules);
1483         bytes memory code = abi.encodePacked(type(Proxy).creationCode, uint256(walletImplementation));
1484         address payable wallet;
1485         // solium-disable-next-line security/no-inline-assembly
1486         assembly {
1487             wallet := create2(0, add(code, 0x20), mload(code), newsalt)
1488             if iszero(extcodesize(wallet)) { revert(0, returndatasize) }
1489         }
1490         // check for ENS
1491         bytes memory labelBytes = bytes(_label);
1492         if (labelBytes.length != 0) {
1493             // add the factory to the modules so it can claim the reverse ENS
1494             address[] memory extendedModules = new address[](_modules.length + 1);
1495             extendedModules[0] = address(this);
1496             for(uint i = 0; i < _modules.length; i++) {
1497                 extendedModules[i + 1] = _modules[i];
1498             }
1499             // initialise the wallet with the owner and the extended modules
1500             BaseWallet(wallet).init(_owner, extendedModules);
1501             // register ENS
1502             registerWalletENS(wallet, _label);
1503             // remove the factory from the authorised modules
1504             BaseWallet(wallet).authoriseModule(address(this), false);
1505         } else {
1506             // initialise the wallet with the owner and the modules
1507             BaseWallet(wallet).init(_owner, _modules);
1508         }
1509         emit WalletCreated(wallet, _owner);
1510     }
1511 
1512     /**
1513      * @dev Throws if the owner and the modules are not valid.
1514      * @param _owner The owner address.
1515      * @param _modules The list of modules.
1516      */
1517     function _validateInputs(address _owner, address[] memory _modules) internal view {
1518         require(_owner != address(0), "WF: owner cannot be null");
1519         require(_modules.length > 0, "WF: cannot assign with less than 1 module");
1520         require(ModuleRegistry(moduleRegistry).isRegisteredModule(_modules), "WF: one or more modules are not registered");
1521     }
1522 
1523     /**
1524      * @dev Generates a new salt based on a provided salt, an owner and a list of modules.
1525      * @param _salt The slat provided.
1526      * @param _owner The owner address.
1527      * @param _modules The list of modules.
1528      */
1529     function _newSalt(bytes32 _salt, address _owner, address[] memory _modules) internal pure returns (bytes32) {
1530         return keccak256(abi.encodePacked(_salt, _owner, _modules));
1531     }
1532 
1533     /**
1534      * @dev Lets the owner change the address of the module registry contract.
1535      * @param _moduleRegistry The address of the module registry contract.
1536      */
1537     function changeModuleRegistry(address _moduleRegistry) external onlyOwner {
1538         require(_moduleRegistry != address(0), "WF: address cannot be null");
1539         moduleRegistry = _moduleRegistry;
1540         emit ModuleRegistryChanged(_moduleRegistry);
1541     }
1542 
1543     /**
1544      * @dev Lets the owner change the address of the implementing contract.
1545      * @param _walletImplementation The address of the implementing contract.
1546      */
1547     function changeWalletImplementation(address _walletImplementation) external onlyOwner {
1548         require(_walletImplementation != address(0), "WF: address cannot be null");
1549         walletImplementation = _walletImplementation;
1550         emit WalletImplementationChanged(_walletImplementation);
1551     }
1552 
1553     /**
1554      * @dev Lets the owner change the address of the ENS manager contract.
1555      * @param _ensManager The address of the ENS manager contract.
1556      */
1557     function changeENSManager(address _ensManager) external onlyOwner {
1558         require(_ensManager != address(0), "WF: address cannot be null");
1559         ensManager = _ensManager;
1560         emit ENSManagerChanged(_ensManager);
1561     }
1562 
1563     /**
1564      * @dev Lets the owner change the address of the ENS resolver contract.
1565      * @param _ensResolver The address of the ENS resolver contract.
1566      */
1567     function changeENSResolver(address _ensResolver) external onlyOwner {
1568         require(_ensResolver != address(0), "WF: address cannot be null");
1569         ensResolver = _ensResolver;
1570         emit ENSResolverChanged(_ensResolver);
1571     }
1572 
1573     /**
1574      * @dev Register an ENS subname to a wallet.
1575      * @param _wallet The wallet address.
1576      * @param _label ENS label of the new wallet (e.g. franck).
1577      */
1578     function registerWalletENS(address payable _wallet, string memory _label) internal {
1579         // claim reverse
1580         bytes memory methodData = abi.encodeWithSignature("claimWithResolver(address,address)", ensManager, ensResolver);
1581         BaseWallet(_wallet).invoke(address(getENSReverseRegistrar()), 0, methodData);
1582         // register with ENS manager
1583         IENSManager(ensManager).register(_label, _wallet);
1584     }
1585 
1586     /**
1587      * @dev Inits the module for a wallet by logging an event.
1588      * The method can only be called by the wallet itself.
1589      * @param _wallet The wallet.
1590      */
1591     function init(BaseWallet _wallet) external pure {
1592         //do nothing
1593     }
1594 }