1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 library AddressUtils {
56 
57   /**
58    * Returns whether the target address is a contract
59    * @dev This function will return false if invoked during the constructor of a contract,
60    *  as the code is not actually created until after the constructor finishes.
61    * @param addr address to check
62    * @return whether the target address is a contract
63    */
64   function isContract(address addr) internal view returns (bool) {
65     uint256 size;
66     // XXX Currently there is no better way to check if there is a contract in an address
67     // than to check the size of the code at that address.
68     // See https://ethereum.stackexchange.com/a/14016/36603
69     // for more details about how this works.
70     // TODO Check this again before the Serenity release, because all addresses will be
71     // contracts then.
72     // solium-disable-next-line security/no-inline-assembly
73     assembly { size := extcodesize(addr) }
74     return size > 0;
75   }
76 
77 }
78 
79 /**
80  * Strings Library
81  * 
82  * In summary this is a simple library of string functions which make simple 
83  * string operations less tedious in solidity.
84  * 
85  * Please be aware these functions can be quite gas heavy so use them only when
86  * necessary not to clog the blockchain with expensive transactions.
87  * 
88  * @author James Lockhart <james@n3tw0rk.co.uk>
89  */
90 library Strings {
91 
92     /**
93      * Concat (High gas cost)
94      * 
95      * Appends two strings together and returns a new value
96      * 
97      * @param _base When being used for a data type this is the extended object
98      *              otherwise this is the string which will be the concatenated
99      *              prefix
100      * @param _value The value to be the concatenated suffix
101      * @return string The resulting string from combinging the base and value
102      */
103     function concat(string _base, string _value)
104         internal
105         returns (string) {
106         bytes memory _baseBytes = bytes(_base);
107         bytes memory _valueBytes = bytes(_value);
108 
109         assert(_valueBytes.length > 0);
110 
111         string memory _tmpValue = new string(_baseBytes.length + 
112             _valueBytes.length);
113         bytes memory _newValue = bytes(_tmpValue);
114 
115         uint i;
116         uint j;
117 
118         for(i = 0; i < _baseBytes.length; i++) {
119             _newValue[j++] = _baseBytes[i];
120         }
121 
122         for(i = 0; i<_valueBytes.length; i++) {
123             _newValue[j++] = _valueBytes[i];
124         }
125 
126         return string(_newValue);
127     }
128 
129     /**
130      * Index Of
131      *
132      * Locates and returns the position of a character within a string
133      * 
134      * @param _base When being used for a data type this is the extended object
135      *              otherwise this is the string acting as the haystack to be
136      *              searched
137      * @param _value The needle to search for, at present this is currently
138      *               limited to one character
139      * @return int The position of the needle starting from 0 and returning -1
140      *             in the case of no matches found
141      */
142     function indexOf(string _base, string _value)
143         internal
144         returns (int) {
145         return _indexOf(_base, _value, 0);
146     }
147 
148     /**
149      * Index Of
150      *
151      * Locates and returns the position of a character within a string starting
152      * from a defined offset
153      * 
154      * @param _base When being used for a data type this is the extended object
155      *              otherwise this is the string acting as the haystack to be
156      *              searched
157      * @param _value The needle to search for, at present this is currently
158      *               limited to one character
159      * @param _offset The starting point to start searching from which can start
160      *                from 0, but must not exceed the length of the string
161      * @return int The position of the needle starting from 0 and returning -1
162      *             in the case of no matches found
163      */
164     function _indexOf(string _base, string _value, uint _offset)
165         internal
166         returns (int) {
167         bytes memory _baseBytes = bytes(_base);
168         bytes memory _valueBytes = bytes(_value);
169 
170         assert(_valueBytes.length == 1);
171 
172         for(uint i = _offset; i < _baseBytes.length; i++) {
173             if (_baseBytes[i] == _valueBytes[0]) {
174                 return int(i);
175             }
176         }
177 
178         return -1;
179     }
180 
181     /**
182      * Length
183      * 
184      * Returns the length of the specified string
185      * 
186      * @param _base When being used for a data type this is the extended object
187      *              otherwise this is the string to be measured
188      * @return uint The length of the passed string
189      */
190     function length(string _base)
191         internal
192         returns (uint) {
193         bytes memory _baseBytes = bytes(_base);
194         return _baseBytes.length;
195     }
196 
197     /**
198      * Sub String
199      * 
200      * Extracts the beginning part of a string based on the desired length
201      * 
202      * @param _base When being used for a data type this is the extended object
203      *              otherwise this is the string that will be used for 
204      *              extracting the sub string from
205      * @param _length The length of the sub string to be extracted from the base
206      * @return string The extracted sub string
207      */
208     function substring(string _base, int _length)
209         internal
210         returns (string) {
211         return _substring(_base, _length, 0);
212     }
213 
214     /**
215      * Sub String
216      * 
217      * Extracts the part of a string based on the desired length and offset. The
218      * offset and length must not exceed the lenth of the base string.
219      * 
220      * @param _base When being used for a data type this is the extended object
221      *              otherwise this is the string that will be used for 
222      *              extracting the sub string from
223      * @param _length The length of the sub string to be extracted from the base
224      * @param _offset The starting point to extract the sub string from
225      * @return string The extracted sub string
226      */
227     function _substring(string _base, int _length, int _offset)
228         internal
229         returns (string) {
230         bytes memory _baseBytes = bytes(_base);
231 
232         assert(uint(_offset+_length) <= _baseBytes.length);
233 
234         string memory _tmp = new string(uint(_length));
235         bytes memory _tmpBytes = bytes(_tmp);
236 
237         uint j = 0;
238         for(uint i = uint(_offset); i < uint(_offset+_length); i++) {
239           _tmpBytes[j++] = _baseBytes[i];
240         }
241 
242         return string(_tmpBytes);
243     }
244 
245     /**
246      * String Split (Very high gas cost)
247      *
248      * Splits a string into an array of strings based off the delimiter value.
249      * Please note this can be quite a gas expensive function due to the use of
250      * storage so only use if really required.
251      *
252      * @param _base When being used for a data type this is the extended object
253      *               otherwise this is the string value to be split.
254      * @param _value The delimiter to split the string on which must be a single
255      *               character
256      * @return string[] An array of values split based off the delimiter, but
257      *                  do not container the delimiter.
258      */
259     function split(string _base, string _value)
260         internal
261         returns (string[] storage splitArr) {
262         bytes memory _baseBytes = bytes(_base);
263         uint _offset = 0;
264 
265         while(_offset < _baseBytes.length-1) {
266 
267             int _limit = _indexOf(_base, _value, _offset);
268             if (_limit == -1) {
269                 _limit = int(_baseBytes.length);
270             }
271 
272             string memory _tmp = new string(uint(_limit)-_offset);
273             bytes memory _tmpBytes = bytes(_tmp);
274 
275             uint j = 0;
276             for(uint i = _offset; i < uint(_limit); i++) {
277                 _tmpBytes[j++] = _baseBytes[i];
278             }
279             _offset = uint(_limit) + 1;
280             splitArr.push(string(_tmpBytes));
281         }
282         return splitArr;
283     }
284 
285     /**
286      * Compare To
287      * 
288      * Compares the characters of two strings, to ensure that they have an 
289      * identical footprint
290      * 
291      * @param _base When being used for a data type this is the extended object
292      *               otherwise this is the string base to compare against
293      * @param _value The string the base is being compared to
294      * @return bool Simply notates if the two string have an equivalent
295      */
296     function compareTo(string _base, string _value) 
297         internal 
298         returns (bool) {
299         bytes memory _baseBytes = bytes(_base);
300         bytes memory _valueBytes = bytes(_value);
301 
302         if (_baseBytes.length != _valueBytes.length) {
303             return false;
304         }
305 
306         for(uint i = 0; i < _baseBytes.length; i++) {
307             if (_baseBytes[i] != _valueBytes[i]) {
308                 return false;
309             }
310         }
311 
312         return true;
313     }
314 
315     /**
316      * Compare To Ignore Case (High gas cost)
317      * 
318      * Compares the characters of two strings, converting them to the same case
319      * where applicable to alphabetic characters to distinguish if the values
320      * match.
321      * 
322      * @param _base When being used for a data type this is the extended object
323      *               otherwise this is the string base to compare against
324      * @param _value The string the base is being compared to
325      * @return bool Simply notates if the two string have an equivalent value
326      *              discarding case
327      */
328     function compareToIgnoreCase(string _base, string _value)
329         internal
330         returns (bool) {
331         bytes memory _baseBytes = bytes(_base);
332         bytes memory _valueBytes = bytes(_value);
333 
334         if (_baseBytes.length != _valueBytes.length) {
335             return false;
336         }
337 
338         for(uint i = 0; i < _baseBytes.length; i++) {
339             if (_baseBytes[i] != _valueBytes[i] && 
340                 _upper(_baseBytes[i]) != _upper(_valueBytes[i])) {
341                 return false;
342             }
343         }
344 
345         return true;
346     }
347 
348     /**
349      * Upper
350      * 
351      * Converts all the values of a string to their corresponding upper case
352      * value.
353      * 
354      * @param _base When being used for a data type this is the extended object
355      *              otherwise this is the string base to convert to upper case
356      * @return string 
357      */
358     function upper(string _base) 
359         internal 
360         returns (string) {
361         bytes memory _baseBytes = bytes(_base);
362         for (uint i = 0; i < _baseBytes.length; i++) {
363             _baseBytes[i] = _upper(_baseBytes[i]);
364         }
365         return string(_baseBytes);
366     }
367 
368     /**
369      * Lower
370      * 
371      * Converts all the values of a string to their corresponding lower case
372      * value.
373      * 
374      * @param _base When being used for a data type this is the extended object
375      *              otherwise this is the string base to convert to lower case
376      * @return string 
377      */
378     function lower(string _base) 
379         internal 
380         returns (string) {
381         bytes memory _baseBytes = bytes(_base);
382         for (uint i = 0; i < _baseBytes.length; i++) {
383             _baseBytes[i] = _lower(_baseBytes[i]);
384         }
385         return string(_baseBytes);
386     }
387 
388     /**
389      * Upper
390      * 
391      * Convert an alphabetic character to upper case and return the original
392      * value when not alphabetic
393      * 
394      * @param _b1 The byte to be converted to upper case
395      * @return bytes1 The converted value if the passed value was alphabetic
396      *                and in a lower case otherwise returns the original value
397      */
398     function _upper(bytes1 _b1)
399         private
400         constant
401         returns (bytes1) {
402 
403         if (_b1 >= 0x61 && _b1 <= 0x7A) {
404             return bytes1(uint8(_b1)-32);
405         }
406 
407         return _b1;
408     }
409 
410     /**
411      * Lower
412      * 
413      * Convert an alphabetic character to lower case and return the original
414      * value when not alphabetic
415      * 
416      * @param _b1 The byte to be converted to lower case
417      * @return bytes1 The converted value if the passed value was alphabetic
418      *                and in a upper case otherwise returns the original value
419      */
420     function _lower(bytes1 _b1)
421         private
422         constant
423         returns (bytes1) {
424 
425         if (_b1 >= 0x41 && _b1 <= 0x5A) {
426             return bytes1(uint8(_b1)+32);
427         }
428         
429         return _b1;
430     }
431 }
432 
433 
434 /**
435  * Integers Library
436  * 
437  * In summary this is a simple library of integer functions which allow a simple
438  * conversion to and from strings
439  * 
440  * @author James Lockhart <james@n3tw0rk.co.uk>
441  */
442 library Integers {
443     /**
444      * Parse Int
445      * 
446      * Converts an ASCII string value into an uint as long as the string 
447      * its self is a valid unsigned integer
448      * 
449      * @param _value The ASCII string to be converted to an unsigned integer
450      * @return uint The unsigned value of the ASCII string
451      */
452     function parseInt(string _value) 
453         public
454         pure
455         returns (uint _ret) {
456         bytes memory _bytesValue = bytes(_value);
457         uint j = 1;
458         for(uint i = _bytesValue.length-1; i >= 0 && i < _bytesValue.length; i--) {
459             assert(_bytesValue[i] >= 48 && _bytesValue[i] <= 57);
460             _ret += (uint(_bytesValue[i]) - 48)*j;
461             j*=10;
462         }
463     }
464     
465     /**
466      * To String
467      * 
468      * Converts an unsigned integer to the ASCII string equivalent value
469      * 
470      * @param _base The unsigned integer to be converted to a string
471      * @return string The resulting ASCII string value
472      */
473     function toString(uint _base) 
474         internal
475         pure
476         returns (string) {
477         bytes memory _tmp = new bytes(32);
478         uint i;
479         for(i = 0;_base > 0;i++) {
480             _tmp[i] = byte((_base % 10) + 48);
481             _base /= 10;
482         }
483         bytes memory _real = new bytes(i--);
484         for(uint j = 0; j < _real.length; j++) {
485             _real[j] = _tmp[i--];
486         }
487         return string(_real);
488     }
489 
490     /**
491      * To Byte
492      *
493      * Convert an 8 bit unsigned integer to a byte
494      *
495      * @param _base The 8 bit unsigned integer
496      * @return byte The byte equivalent
497      */
498     function toByte(uint8 _base) 
499         public
500         pure
501         returns (byte _ret) {
502         assembly {
503             let m_alloc := add(msize(),0x1)
504             mstore8(m_alloc, _base)
505             _ret := mload(m_alloc)
506         }
507     }
508 
509     /**
510      * To Bytes
511      *
512      * Converts an unsigned integer to bytes
513      *
514      * @param _base The integer to be converted to bytes
515      * @return bytes The bytes equivalent 
516      */
517     function toBytes(uint _base) 
518         internal
519         pure
520         returns (bytes _ret) {
521         assembly {
522             let m_alloc := add(msize(),0x1)
523             _ret := mload(m_alloc)
524             mstore(_ret, 0x20)
525             mstore(add(_ret, 0x20), _base)
526         }
527     }
528 }
529 
530 contract HEROES {
531 
532   using SafeMath for uint256;
533   using AddressUtils for address;
534   using Strings for string;
535   using Integers for uint;
536 
537 
538   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
539   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
540   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
541   event Lock(uint256 lockedTo, uint16 lockId);
542   event LevelUp(uint32 level);
543 
544 
545   struct Character {
546     uint256 genes;
547 
548     uint256 mintedAt;
549     uint256 godfather;
550     uint256 mentor;
551 
552     uint32 wins;
553     uint32 losses;
554     uint32 level;
555 
556     uint256 lockedTo;
557     uint16 lockId;
558   }
559 
560 
561   string internal constant name_ = "⚔ CRYPTOHEROES GAME ⚔";
562   string internal constant symbol_ = "CRYPTOHEROES";
563   string internal baseURI_;
564 
565   address internal admin;
566   mapping(address => bool) internal agents;
567 
568   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
569 
570   mapping(uint256 => address) internal tokenOwner;
571   mapping(address => uint256[]) internal ownedTokens;
572   mapping(uint256 => uint256) internal ownedTokensIndex;
573   mapping(address => uint256) internal ownedTokensCount;
574 
575   mapping(uint256 => address) internal tokenApprovals;
576   mapping(address => mapping(address => bool)) internal operatorApprovals;
577 
578   uint256[] internal allTokens;
579   mapping(uint256 => uint256) internal allTokensIndex;
580 
581   Character[] characters;
582   mapping(uint256 => uint256) tokenCharacters; // tokenId => characterId
583 
584 
585   modifier onlyOwnerOf(uint256 _tokenId) {
586     require(ownerOf(_tokenId) == msg.sender ||
587             (ownerOf(_tokenId) == tx.origin && isAgent(msg.sender)) ||
588             msg.sender == admin);
589     _;
590   }
591 
592   modifier canTransfer(uint256 _tokenId) {
593     require(isLocked(_tokenId) &&
594             (isApprovedOrOwned(msg.sender, _tokenId) ||
595              (isApprovedOrOwned(tx.origin, _tokenId) && isAgent(msg.sender)) ||
596              msg.sender == admin));
597     _;
598   }
599 
600   modifier onlyAdmin() {
601     require(msg.sender == admin);
602     _;
603   }
604 
605   modifier onlyAgent() {
606     require(isAgent(msg.sender));
607     _;
608   }
609 
610   /* CONTRACT METHODS */
611 
612   constructor(string _baseURI) public {
613     baseURI_ = _baseURI;
614     admin = msg.sender;
615     addAgent(msg.sender);
616   }
617 
618   function name() external pure returns (string) {
619     return name_;
620   }
621 
622   function symbol() external pure returns (string) {
623     return symbol_;
624   }
625 
626   /* METADATA METHODS */
627 
628   function setBaseURI(string _baseURI) external onlyAdmin {
629     baseURI_ = _baseURI;
630   }
631 
632   function tokenURI(uint256 _tokenId) public view returns (string) {
633     require(exists(_tokenId));
634     return baseURI_.concat(_tokenId.toString());
635   }
636 
637   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
638     require(_index < balanceOf(_owner));
639     return ownedTokens[_owner][_index];
640   }
641 
642   function totalSupply() public view returns (uint256) {
643     return allTokens.length;
644   }
645 
646   /* TOKEN METHODS */
647 
648   function tokenByIndex(uint256 _index) public view returns (uint256) {
649     require(_index < totalSupply());
650     return allTokens[_index];
651   }
652 
653   function exists(uint256 _tokenId) public view returns (bool) {
654     address owner = tokenOwner[_tokenId];
655     return owner != address(0);
656   }
657 
658   function balanceOf(address _owner) public view returns (uint256) {
659     require(_owner != address(0));
660     return ownedTokensCount[_owner];
661   }
662 
663   function ownerOf(uint256 _tokenId) public view returns (address) {
664     address owner = tokenOwner[_tokenId];
665     require(owner != address(0));
666     return owner;
667   }
668 
669   function approve(address _to, uint256 _tokenId) public {
670     address owner = ownerOf(_tokenId);
671     require(_to != owner);
672     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
673 
674     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
675       tokenApprovals[_tokenId] = _to;
676       emit Approval(owner, _to, _tokenId);
677     }
678   }
679 
680   function getApproved(uint256 _tokenId) public view returns (address) {
681     return tokenApprovals[_tokenId];
682   }
683 
684   function setApprovalForAll(address _to, bool _approved) public {
685     require(_to != msg.sender);
686     operatorApprovals[msg.sender][_to] = _approved;
687     emit ApprovalForAll(msg.sender, _to, _approved);
688   }
689 
690   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
691     return operatorApprovals[_owner][_operator];
692   }
693 
694   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
695     require(_from != address(0));
696     require(_to != address(0));
697 
698     clearApproval(_from, _tokenId);
699     removeTokenFrom(_from, _tokenId);
700     addTokenTo(_to, _tokenId);
701 
702     emit Transfer(_from, _to, _tokenId);
703   }
704 
705   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
706     safeTransferFrom(_from, _to, _tokenId, "");
707   }
708 
709   function safeTransferFrom(address _from,
710                             address _to,
711                             uint256 _tokenId,
712                             bytes _data)
713     public
714     canTransfer(_tokenId)
715   {
716     transferFrom(_from, _to, _tokenId);
717     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
718   }
719 
720   function isApprovedOrOwned(address _spender, uint256 _tokenId) internal view returns (bool) {
721 
722     address owner = ownerOf(_tokenId);
723 
724     return (_spender == owner ||
725             getApproved(_tokenId) == _spender ||
726             isApprovedForAll(owner, _spender));
727   }
728 
729   function clearApproval(address _owner, uint256 _tokenId) internal {
730     require(ownerOf(_tokenId) == _owner);
731     if (tokenApprovals[_tokenId] != address(0)) {
732       tokenApprovals[_tokenId] = address(0);
733       emit Approval(_owner, address(0), _tokenId);
734     }
735   }
736 
737   function _mint(address _to, uint256 _tokenId) internal {
738     require(_to != address(0));
739     addTokenTo(_to, _tokenId);
740     emit Transfer(address(0), _to, _tokenId);
741 
742     allTokensIndex[_tokenId] = allTokens.length;
743     allTokens.push(_tokenId);
744   }
745 
746   function addTokenTo(address _to, uint256 _tokenId) internal {
747     require(tokenOwner[_tokenId] == address(0));
748     tokenOwner[_tokenId] = _to;
749     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
750 
751     uint256 length = ownedTokens[_to].length;
752     ownedTokens[_to].push(_tokenId);
753     ownedTokensIndex[_tokenId] = length;
754   }
755 
756   function removeTokenFrom(address _from, uint256 _tokenId) internal {
757     require(ownerOf(_tokenId) == _from);
758     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
759     tokenOwner[_tokenId] = address(0);
760 
761     uint256 tokenIndex = ownedTokensIndex[_tokenId];
762     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
763     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
764 
765     ownedTokens[_from][tokenIndex] = lastToken;
766     ownedTokens[_from][lastTokenIndex] = 0;
767 
768     ownedTokens[_from].length--;
769     ownedTokensIndex[_tokenId] = 0;
770     ownedTokensIndex[lastToken] = tokenIndex;
771   }
772 
773   function checkAndCallSafeTransfer(address _from,
774                                     address _to,
775                                     uint256 _tokenId,
776                                     bytes _data)
777     internal
778     returns(bool)
779   {
780     return true;
781   }
782 
783   /* AGENT ROLE */
784 
785   function addAgent(address _agent) public onlyAdmin {
786     agents[_agent] = true;
787   }
788 
789   function removeAgent(address _agent) external onlyAdmin {
790     agents[_agent] = false;
791   }
792 
793   function isAgent(address _agent) public view returns (bool) {
794     return agents[_agent];
795   }
796 
797   /* CHARACTER LOGIC */
798 
799   function getCharacter(uint256 _tokenId)
800     external view returns
801     (uint256 genes,
802      uint256 mintedAt,
803      uint256 godfather,
804      uint256 mentor,
805      uint32 wins,
806      uint32 losses,
807      uint32 level,
808      uint256 lockedTo,
809      uint16 lockId) {
810 
811     require(exists(_tokenId));
812 
813     Character memory c = characters[tokenCharacters[_tokenId]];
814 
815     genes = c.genes;
816     mintedAt = c.mintedAt;
817     godfather = c.godfather;
818     mentor = c.mentor;
819     wins = c.wins;
820     losses = c.losses;
821     level = c.level;
822     lockedTo = c.lockedTo;
823     lockId = c.lockId;
824   }
825 
826   function addWin(uint256 _tokenId) external onlyAgent {
827 
828     require(exists(_tokenId));
829 
830     Character storage character = characters[tokenCharacters[_tokenId]];
831     character.wins++;
832     character.level++;
833 
834     emit LevelUp(character.level);
835   }
836 
837   function addLoss(uint256 _tokenId) external onlyAgent {
838 
839     require(exists(_tokenId));
840 
841     Character storage character = characters[tokenCharacters[_tokenId]];
842     character.losses++;
843     if (character.level > 1) {
844       character.level--;
845 
846       emit LevelUp(character.level);
847     }
848   }
849 
850   /* MINTING */
851 
852   function mintTo(address _to,
853                   uint256 _genes,
854                   uint256 _godfather,
855                   uint256 _mentor,
856                   uint32 _level)
857     external
858     onlyAgent
859     returns (uint256)
860   {
861     uint256 newTokenId = totalSupply().add(1);
862     _mint(_to, newTokenId);
863     _mintCharacter(newTokenId, _genes, _godfather, _mentor, _level);
864 
865     return newTokenId;
866   }
867 
868   function _mintCharacter(uint256 _tokenId,
869                           uint256 _genes,
870                           uint256 _godfather,
871                           uint256 _mentor,
872                           uint32 _level)
873     internal
874   {
875 
876     require(exists(_tokenId));
877 
878     Character memory character = Character({
879       genes: _genes,
880 
881           mintedAt: now,
882           mentor: _mentor,
883           godfather: _godfather,
884 
885           wins: 0,
886           losses: 0,
887           level: _level,
888 
889           lockedTo: 0,
890           lockId: 0
891           });
892 
893     uint256 characterId = characters.push(character) - 1;
894     tokenCharacters[_tokenId] = characterId;
895   }
896 
897   /* LOCKS */
898 
899   function lock(uint256 _tokenId, uint256 _lockedTo, uint16 _lockId)
900     external onlyAgent returns (bool) {
901 
902     require(exists(_tokenId));
903 
904     Character storage character = characters[tokenCharacters[_tokenId]];
905 
906     if (character.lockId == 0) {
907       character.lockedTo = _lockedTo;
908       character.lockId = _lockId;
909 
910       emit Lock(character.lockedTo, character.lockId);
911 
912       return true;
913     }
914 
915     return false;
916   }
917 
918   function unlock(uint256 _tokenId, uint16 _lockId)
919     external onlyAgent returns (bool) {
920 
921     require(exists(_tokenId));
922 
923     Character storage character = characters[tokenCharacters[_tokenId]];
924 
925     if (character.lockId == _lockId) {
926       character.lockedTo = 0;
927       character.lockId = 0;
928 
929       emit Lock(character.lockedTo, character.lockId);
930 
931       return true;
932     }
933 
934     return false;
935   }
936 
937   function getLock(uint256 _tokenId)
938     external view returns (uint256 lockedTo, uint16 lockId) {
939 
940     require(exists(_tokenId));
941 
942     lockedTo = characters[tokenCharacters[_tokenId]].lockedTo;
943     lockId = characters[tokenCharacters[_tokenId]].lockId;
944   }
945 
946   function isLocked(uint _tokenId) public view returns (bool) {
947     require(exists(_tokenId));
948     //isLocked workaround: lockedTo должен быть =1 для блокировки трансфер
949     return ((characters[tokenCharacters[_tokenId]].lockedTo == 0 &&
950              characters[tokenCharacters[_tokenId]].lockId != 0) ||
951             now <= characters[tokenCharacters[_tokenId]].lockedTo);
952   }
953 
954   function test(uint256 _x) returns (bool) {
955     return now <= _x;
956   }
957 }