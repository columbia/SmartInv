1 pragma solidity ^0.4.21;
2 
3 
4 library strings {
5     
6     struct slice {
7         uint _len;
8         uint _ptr;
9     }
10 
11     /*
12      * @dev Returns a slice containing the entire string.
13      * @param self The string to make a slice from.
14      * @return A newly allocated slice containing the entire string.
15      */
16     function toSlice(string self) internal pure returns (slice) {
17         uint ptr;
18         assembly {
19             ptr := add(self, 0x20)
20         }
21         return slice(bytes(self).length, ptr);
22     }
23 
24     function memcpy(uint dest, uint src, uint len) private pure {
25         // Copy word-length chunks while possible
26         for(; len >= 32; len -= 32) {
27             assembly {
28                 mstore(dest, mload(src))
29             }
30             dest += 32;
31             src += 32;
32         }
33 
34         // Copy remaining bytes
35         uint mask = 256 ** (32 - len) - 1;
36         assembly {
37             let srcpart := and(mload(src), not(mask))
38             let destpart := and(mload(dest), mask)
39             mstore(dest, or(destpart, srcpart))
40         }
41     }
42 
43     
44     function concat(slice self, slice other) internal returns (string) {
45         var ret = new string(self._len + other._len);
46         uint retptr;
47         assembly { retptr := add(ret, 32) }
48         memcpy(retptr, self._ptr, self._len);
49         memcpy(retptr + self._len, other._ptr, other._len);
50         return ret;
51     }
52 
53     /*
54      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
55      * @param self The slice to search.
56      * @param needle The text to search for in `self`.
57      * @return The number of occurrences of `needle` found in `self`.
58      */
59     function count(slice self, slice needle) internal returns (uint cnt) {
60         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
61         while (ptr <= self._ptr + self._len) {
62             cnt++;
63             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
64         }
65     }
66 
67     // Returns the memory address of the first byte of the first occurrence of
68     // `needle` in `self`, or the first byte after `self` if not found.
69     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
70         uint ptr;
71         uint idx;
72 
73         if (needlelen <= selflen) {
74             if (needlelen <= 32) {
75                 // Optimized assembly for 68 gas per byte on short strings
76                 assembly {
77                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
78                     let needledata := and(mload(needleptr), mask)
79                     let end := add(selfptr, sub(selflen, needlelen))
80                     ptr := selfptr
81                     loop:
82                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
83                     ptr := add(ptr, 1)
84                     jumpi(loop, lt(sub(ptr, 1), end))
85                     ptr := add(selfptr, selflen)
86                     exit:
87                 }
88                 return ptr;
89             } else {
90                 // For long needles, use hashing
91                 bytes32 hash;
92                 assembly { hash := sha3(needleptr, needlelen) }
93                 ptr = selfptr;
94                 for (idx = 0; idx <= selflen - needlelen; idx++) {
95                     bytes32 testHash;
96                     assembly { testHash := sha3(ptr, needlelen) }
97                     if (hash == testHash)
98                         return ptr;
99                     ptr += 1;
100                 }
101             }
102         }
103         return selfptr + selflen;
104     }
105 
106     /*
107      * @dev Splits the slice, setting `self` to everything after the first
108      *      occurrence of `needle`, and `token` to everything before it. If
109      *      `needle` does not occur in `self`, `self` is set to the empty slice,
110      *      and `token` is set to the entirety of `self`.
111      * @param self The slice to split.
112      * @param needle The text to search for in `self`.
113      * @param token An output parameter to which the first token is written.
114      * @return `token`.
115      */
116     function split(slice self, slice needle, slice token) internal returns (slice) {
117         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
118         token._ptr = self._ptr;
119         token._len = ptr - self._ptr;
120         if (ptr == self._ptr + self._len) {
121             // Not found
122             self._len = 0;
123         } else {
124             self._len -= token._len + needle._len;
125             self._ptr = ptr + needle._len;
126         }
127         return token;
128     }
129 
130      /*
131      * @dev Splits the slice, setting `self` to everything after the first
132      *      occurrence of `needle`, and returning everything before it. If
133      *      `needle` does not occur in `self`, `self` is set to the empty slice,
134      *      and the entirety of `self` is returned.
135      * @param self The slice to split.
136      * @param needle The text to search for in `self`.
137      * @return The part of `self` up to the first occurrence of `delim`.
138      */
139     function split(slice self, slice needle) internal returns (slice token) {
140         split(self, needle, token);
141     }
142 
143     /*
144      * @dev Copies a slice to a new string.
145      * @param self The slice to copy.
146      * @return A newly allocated string containing the slice's text.
147      */
148     function toString(slice self) internal pure returns (string) {
149         var ret = new string(self._len);
150         uint retptr;
151         assembly { retptr := add(ret, 32) }
152 
153         memcpy(retptr, self._ptr, self._len);
154         return ret;
155     }
156 
157 }
158 
159 /* Helper String Functions for Game Manager Contract
160  * @title String Healpers
161  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
162  */
163 contract StringHelpers {
164     using strings for *;
165     
166     function stringToBytes32(string memory source) internal returns (bytes32 result) {
167         bytes memory tempEmptyStringTest = bytes(source);
168         if (tempEmptyStringTest.length == 0) {
169             return 0x0;
170         }
171     
172         assembly {
173             result := mload(add(source, 32))
174         }
175     }
176 
177     function bytes32ToString(bytes32 x) constant internal returns (string) {
178         bytes memory bytesString = new bytes(32);
179         uint charCount = 0;
180         for (uint j = 0; j < 32; j++) {
181             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
182             if (char != 0) {
183                 bytesString[charCount] = char;
184                 charCount++;
185             }
186         }
187         bytes memory bytesStringTrimmed = new bytes(charCount);
188         for (j = 0; j < charCount; j++) {
189             bytesStringTrimmed[j] = bytesString[j];
190         }
191         return string(bytesStringTrimmed);
192     }
193 }
194 
195 
196 /* Controls state and access rights for contract functions
197  * @title Operational Control
198  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
199  * Inspired and adapted from contract created by OpenZeppelin
200  * Ref: https://github.com/OpenZeppelin/zeppelin-solidity/
201  */
202 contract OperationalControl {
203     // Facilitates access & control for the game.
204     // Roles:
205     //  -The Managers (Primary/Secondary): Has universal control of all elements (No ability to withdraw)
206     //  -The Banker: The Bank can withdraw funds and adjust fees / prices.
207     //  -otherManagers: Contracts that need access to functions for gameplay
208 
209     /// @dev Emited when contract is upgraded
210     event ContractUpgrade(address newContract);
211 
212     // The addresses of the accounts (or contracts) that can execute actions within each roles.
213     address public managerPrimary;
214     address public managerSecondary;
215     address public bankManager;
216 
217     // Contracts that require access for gameplay
218     mapping(address => uint8) public otherManagers;
219 
220     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
221     bool public paused = false;
222 
223     // @dev Keeps track whether the contract erroredOut. When that is true, most actions are blocked & refund can be claimed
224     bool public error = false;
225 
226     /// @dev Operation modifiers for limiting access
227     modifier onlyManager() {
228         require(msg.sender == managerPrimary || msg.sender == managerSecondary);
229         _;
230     }
231 
232     modifier onlyBanker() {
233         require(msg.sender == bankManager);
234         _;
235     }
236 
237     modifier onlyOtherManagers() {
238         require(otherManagers[msg.sender] == 1);
239         _;
240     }
241 
242 
243     modifier anyOperator() {
244         require(
245             msg.sender == managerPrimary ||
246             msg.sender == managerSecondary ||
247             msg.sender == bankManager ||
248             otherManagers[msg.sender] == 1
249         );
250         _;
251     }
252 
253     /// @dev Assigns a new address to act as the Other Manager. (State = 1 is active, 0 is disabled)
254     function setOtherManager(address _newOp, uint8 _state) external onlyManager {
255         require(_newOp != address(0));
256 
257         otherManagers[_newOp] = _state;
258     }
259 
260     /// @dev Assigns a new address to act as the Primary Manager.
261     function setPrimaryManager(address _newGM) external onlyManager {
262         require(_newGM != address(0));
263 
264         managerPrimary = _newGM;
265     }
266 
267     /// @dev Assigns a new address to act as the Secondary Manager.
268     function setSecondaryManager(address _newGM) external onlyManager {
269         require(_newGM != address(0));
270 
271         managerSecondary = _newGM;
272     }
273 
274     /// @dev Assigns a new address to act as the Banker.
275     function setBanker(address _newBK) external onlyManager {
276         require(_newBK != address(0));
277 
278         bankManager = _newBK;
279     }
280 
281     /*** Pausable functionality adapted from OpenZeppelin ***/
282 
283     /// @dev Modifier to allow actions only when the contract IS NOT paused
284     modifier whenNotPaused() {
285         require(!paused);
286         _;
287     }
288 
289     /// @dev Modifier to allow actions only when the contract IS paused
290     modifier whenPaused {
291         require(paused);
292         _;
293     }
294 
295     /// @dev Modifier to allow actions only when the contract has Error
296     modifier whenError {
297         require(error);
298         _;
299     }
300 
301     /// @dev Called by any Operator role to pause the contract.
302     /// Used only if a bug or exploit is discovered (Here to limit losses / damage)
303     function pause() external onlyManager whenNotPaused {
304         paused = true;
305     }
306 
307     /// @dev Unpauses the smart contract. Can only be called by the Game Master
308     /// @notice This is public rather than external so it can be called by derived contracts. 
309     function unpause() public onlyManager whenPaused {
310         // can't unpause if contract was upgraded
311         paused = false;
312     }
313 
314     /// @dev Unpauses the smart contract. Can only be called by the Game Master
315     /// @notice This is public rather than external so it can be called by derived contracts. 
316     function hasError() public onlyManager whenPaused {
317         error = true;
318     }
319 
320     /// @dev Unpauses the smart contract. Can only be called by the Game Master
321     /// @notice This is public rather than external so it can be called by derived contracts. 
322     function noError() public onlyManager whenPaused {
323         error = false;
324     }
325 }
326 
327 /**
328  * @title SafeMath
329  * @dev Math operations with safety checks that throw on error
330  */
331 library SafeMath {
332 
333   /**
334   * @dev Multiplies two numbers, throws on overflow.
335   */
336   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
337     if (a == 0) {
338       return 0;
339     }
340     c = a * b;
341     assert(c / a == b);
342     return c;
343   }
344 
345   /**
346   * @dev Integer division of two numbers, truncating the quotient.
347   */
348   function div(uint256 a, uint256 b) internal pure returns (uint256) {
349     // assert(b > 0); // Solidity automatically throws when dividing by 0
350     // uint256 c = a / b;
351     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
352     return a / b;
353   }
354 
355   /**
356   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
357   */
358   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
359     assert(b <= a);
360     return a - b;
361   }
362 
363   /**
364   * @dev Adds two numbers, throws on overflow.
365   */
366   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
367     c = a + b;
368     assert(c >= a);
369     return c;
370   }
371 }
372 
373 /**
374  * @title ERC20Basic
375  * @dev Simpler version of ERC20 interface
376  * @dev see https://github.com/ethereum/EIPs/issues/179
377  */
378 contract ERC20Basic {
379   function totalSupply() public view returns (uint256);
380   function balanceOf(address who) public view returns (uint256);
381   function transfer(address to, uint256 value) public returns (bool);
382   event Transfer(address indexed from, address indexed to, uint256 value);
383 }
384 
385 /**
386  * @title Basic token
387  * @dev Basic version of StandardToken, with no allowances.
388  */
389 contract BasicToken is ERC20Basic {
390   using SafeMath for uint256;
391 
392   mapping(address => uint256) balances;
393 
394   uint256 totalSupply_;
395 
396   /**
397   * @dev total number of tokens in existence
398   */
399   function totalSupply() public view returns (uint256) {
400     return totalSupply_;
401   }
402 
403   /**
404   * @dev transfer token for a specified address
405   * @param _to The address to transfer to.
406   * @param _value The amount to be transferred.
407   */
408   function transfer(address _to, uint256 _value) public returns (bool) {
409     require(_to != address(0));
410     require(_value <= balances[msg.sender]);
411 
412     balances[msg.sender] = balances[msg.sender].sub(_value);
413     balances[_to] = balances[_to].add(_value);
414     emit Transfer(msg.sender, _to, _value);
415     return true;
416   }
417 
418   /**
419   * @dev Gets the balance of the specified address.
420   * @param _owner The address to query the the balance of.
421   * @return An uint256 representing the amount owned by the passed address.
422   */
423   function balanceOf(address _owner) public view returns (uint256) {
424     return balances[_owner];
425   }
426 
427 }
428 
429 
430 /**
431  * @title ERC20 interface
432  * @dev see https://github.com/ethereum/EIPs/issues/20
433  */
434 contract ERC20 is ERC20Basic {
435   function allowance(address owner, address spender) public view returns (uint256);
436   function transferFrom(address from, address to, uint256 value) public returns (bool);
437   function approve(address spender, uint256 value) public returns (bool);
438   event Approval(address indexed owner, address indexed spender, uint256 value);
439 }
440 
441 
442 /**
443  * @title ERC827 interface, an extension of ERC20 token standard
444  *
445  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
446  * @dev methods to transfer value and data and execute calls in transfers and
447  * @dev approvals.
448  */
449 contract ERC827 is ERC20 {
450   function approveAndCall( address _spender, uint256 _value, bytes _data) public payable returns (bool);
451   function transferAndCall( address _to, uint256 _value, bytes _data) public payable returns (bool);
452   function transferFromAndCall(
453     address _from,
454     address _to,
455     uint256 _value,
456     bytes _data
457   )
458     public
459     payable
460     returns (bool);
461 }
462 
463 /**
464  * @title Standard ERC20 token
465  *
466  * @dev Implementation of the basic standard token.
467  * @dev https://github.com/ethereum/EIPs/issues/20
468  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
469  */
470 contract StandardToken is ERC20, BasicToken {
471 
472   mapping (address => mapping (address => uint256)) internal allowed;
473 
474 
475   /**
476    * @dev Transfer tokens from one address to another
477    * @param _from address The address which you want to send tokens from
478    * @param _to address The address which you want to transfer to
479    * @param _value uint256 the amount of tokens to be transferred
480    */
481   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
482     require(_to != address(0));
483     require(_value <= balances[_from]);
484     require(_value <= allowed[_from][msg.sender]);
485 
486     balances[_from] = balances[_from].sub(_value);
487     balances[_to] = balances[_to].add(_value);
488     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
489     emit Transfer(_from, _to, _value);
490     return true;
491   }
492 
493   /**
494    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
495    *
496    * Beware that changing an allowance with this method brings the risk that someone may use both the old
497    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
498    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
499    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
500    * @param _spender The address which will spend the funds.
501    * @param _value The amount of tokens to be spent.
502    */
503   function approve(address _spender, uint256 _value) public returns (bool) {
504     allowed[msg.sender][_spender] = _value;
505     emit Approval(msg.sender, _spender, _value);
506     return true;
507   }
508 
509   /**
510    * @dev Function to check the amount of tokens that an owner allowed to a spender.
511    * @param _owner address The address which owns the funds.
512    * @param _spender address The address which will spend the funds.
513    * @return A uint256 specifying the amount of tokens still available for the spender.
514    */
515   function allowance(address _owner, address _spender) public view returns (uint256) {
516     return allowed[_owner][_spender];
517   }
518 
519   /**
520    * @dev Increase the amount of tokens that an owner allowed to a spender.
521    *
522    * approve should be called when allowed[_spender] == 0. To increment
523    * allowed value is better to use this function to avoid 2 calls (and wait until
524    * the first transaction is mined)
525    * From MonolithDAO Token.sol
526    * @param _spender The address which will spend the funds.
527    * @param _addedValue The amount of tokens to increase the allowance by.
528    */
529   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
530     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
531     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
532     return true;
533   }
534 
535   /**
536    * @dev Decrease the amount of tokens that an owner allowed to a spender.
537    *
538    * approve should be called when allowed[_spender] == 0. To decrement
539    * allowed value is better to use this function to avoid 2 calls (and wait until
540    * the first transaction is mined)
541    * From MonolithDAO Token.sol
542    * @param _spender The address which will spend the funds.
543    * @param _subtractedValue The amount of tokens to decrease the allowance by.
544    */
545   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
546     uint oldValue = allowed[msg.sender][_spender];
547     if (_subtractedValue > oldValue) {
548       allowed[msg.sender][_spender] = 0;
549     } else {
550       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
551     }
552     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
553     return true;
554   }
555 
556 }
557 
558 
559 /* solium-disable security/no-low-level-calls */
560 /**
561  * @title ERC827, an extension of ERC20 token standard
562  *
563  * @dev Implementation the ERC827, following the ERC20 standard with extra
564  * @dev methods to transfer value and data and execute calls in transfers and
565  * @dev approvals.
566  *
567  * @dev Uses OpenZeppelin StandardToken.
568  */
569 contract ERC827Token is ERC827, StandardToken {
570 
571   /**
572    * @dev Addition to ERC20 token methods. It allows to
573    * @dev approve the transfer of value and execute a call with the sent data.
574    *
575    * @dev Beware that changing an allowance with this method brings the risk that
576    * @dev someone may use both the old and the new allowance by unfortunate
577    * @dev transaction ordering. One possible solution to mitigate this race condition
578    * @dev is to first reduce the spender's allowance to 0 and set the desired value
579    * @dev afterwards:
580    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
581    *
582    * @param _spender The address that will spend the funds.
583    * @param _value The amount of tokens to be spent.
584    * @param _data ABI-encoded contract call to call `_to` address.
585    *
586    * @return true if the call function was executed successfully
587    */
588   function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
589     require(_spender != address(this));
590 
591     super.approve(_spender, _value);
592 
593     // solium-disable-next-line security/no-call-value
594     require(_spender.call.value(msg.value)(_data));
595 
596     return true;
597   }
598 
599   /**
600    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
601    * @dev address and execute a call with the sent data on the same transaction
602    *
603    * @param _to address The address which you want to transfer to
604    * @param _value uint256 the amout of tokens to be transfered
605    * @param _data ABI-encoded contract call to call `_to` address.
606    *
607    * @return true if the call function was executed successfully
608    */
609   function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
610     require(_to != address(this));
611 
612     super.transfer(_to, _value);
613 
614     // solium-disable-next-line security/no-call-value
615     require(_to.call.value(msg.value)(_data));
616     return true;
617   }
618 
619   /**
620    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
621    * @dev another and make a contract call on the same transaction
622    *
623    * @param _from The address which you want to send tokens from
624    * @param _to The address which you want to transfer to
625    * @param _value The amout of tokens to be transferred
626    * @param _data ABI-encoded contract call to call `_to` address.
627    *
628    * @return true if the call function was executed successfully
629    */
630   function transferFromAndCall(
631     address _from,
632     address _to,
633     uint256 _value,
634     bytes _data
635   )
636     public payable returns (bool)
637   {
638     require(_to != address(this));
639 
640     super.transferFrom(_from, _to, _value);
641 
642     // solium-disable-next-line security/no-call-value
643     require(_to.call.value(msg.value)(_data));
644     return true;
645   }
646 
647   /**
648    * @dev Addition to StandardToken methods. Increase the amount of tokens that
649    * @dev an owner allowed to a spender and execute a call with the sent data.
650    *
651    * @dev approve should be called when allowed[_spender] == 0. To increment
652    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
653    * @dev the first transaction is mined)
654    * @dev From MonolithDAO Token.sol
655    *
656    * @param _spender The address which will spend the funds.
657    * @param _addedValue The amount of tokens to increase the allowance by.
658    * @param _data ABI-encoded contract call to call `_spender` address.
659    */
660   function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
661     require(_spender != address(this));
662 
663     super.increaseApproval(_spender, _addedValue);
664 
665     // solium-disable-next-line security/no-call-value
666     require(_spender.call.value(msg.value)(_data));
667 
668     return true;
669   }
670 
671   /**
672    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
673    * @dev an owner allowed to a spender and execute a call with the sent data.
674    *
675    * @dev approve should be called when allowed[_spender] == 0. To decrement
676    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
677    * @dev the first transaction is mined)
678    * @dev From MonolithDAO Token.sol
679    *
680    * @param _spender The address which will spend the funds.
681    * @param _subtractedValue The amount of tokens to decrease the allowance by.
682    * @param _data ABI-encoded contract call to call `_spender` address.
683    */
684   function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
685     require(_spender != address(this));
686 
687     super.decreaseApproval(_spender, _subtractedValue);
688 
689     // solium-disable-next-line security/no-call-value
690     require(_spender.call.value(msg.value)(_data));
691 
692     return true;
693   }
694 
695 }
696 
697 
698  /**
699  * @title Mintable token
700  * @title Burnable Token
701  * @dev Token that can be irreversibly burned (destroyed).
702  * @dev Simple ERC20 Token example, with mintable token creation
703  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
704  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
705  */
706 
707 contract CSCResource is ERC827Token, OperationalControl {
708 
709   event Burn(address indexed burner, uint256 value);
710   event Mint(address indexed to, uint256 amount);
711 
712   // Token Name
713   string public NAME;
714 
715   // Token Symbol
716   string public SYMBOL;
717 
718   // Token decimals
719   uint public constant DECIMALS = 0;
720 
721   /**
722    * Construct the token.
723    *
724    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
725    *
726    */
727   function CSCResource(string _name, string _symbol, uint _initialSupply) public {
728 
729     // Create any address, can be transferred
730     managerPrimary = msg.sender;
731     managerSecondary = msg.sender;
732     bankManager = msg.sender;
733 
734     NAME = _name;
735     SYMBOL = _symbol;
736     
737     // Create initial supply
738     totalSupply_ = totalSupply_.add(_initialSupply);
739     balances[msg.sender] = balances[msg.sender].add(_initialSupply);
740 
741     emit Mint(msg.sender, _initialSupply);
742     emit Transfer(address(0), msg.sender, _initialSupply);
743 
744   }
745 
746   /**
747    * @dev Burns a specific amount of tokens.
748    * @param _value The amount of token to be burned.
749    */
750   function burn(uint256 _value) public {
751     _burn(msg.sender, _value);
752   }
753 
754   function _burn(address _who, uint256 _value) internal {
755     require(_value <= balances[_who]);
756     // no need to require value <= totalSupply, since that would imply the
757     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
758 
759     balances[_who] = balances[_who].sub(_value);
760     totalSupply_ = totalSupply_.sub(_value);
761     emit Burn(_who, _value);
762     emit Transfer(_who, address(0), _value);
763   }  
764 
765   /**
766    * @dev Function to mint tokens
767    * @param _to The address that will receive the minted tokens.
768    * @param _amount The amount of tokens to mint.
769    * @return A boolean that indicates if the operation was successful.
770    */
771     function mint(address _to, uint256 _amount)  public anyOperator returns (bool) {
772         totalSupply_ = totalSupply_.add(_amount);
773         balances[_to] = balances[_to].add(_amount);
774         emit Mint(_to, _amount);
775         emit Transfer(address(0), _to, _amount);
776         return true;
777     }
778 
779 }
780 
781 contract CSCResourceFactory is OperationalControl, StringHelpers {
782 
783     event CSCResourceCreated(string resourceContract, address contractAddress, uint256 amount); 
784 
785     mapping(uint16 => address) public resourceIdToAddress; 
786     mapping(bytes32 => address) public resourceNameToAddress; 
787     mapping(uint16 => bytes32) public resourceIdToName; 
788 
789     uint16 resourceTypeCount;
790 
791     function CSCResourceFactory() public {
792         managerPrimary = msg.sender;
793         managerSecondary = msg.sender;
794         bankManager = msg.sender;
795 
796     }
797 
798     function createNewCSCResource(string _name, string _symbol, uint _initialSupply) public anyOperator {
799 
800         require(resourceNameToAddress[stringToBytes32(_name)] == 0x0);
801 
802         address resourceContract = new CSCResource(_name, _symbol, _initialSupply);
803 
804         
805         resourceIdToAddress[resourceTypeCount] = resourceContract;
806         resourceNameToAddress[stringToBytes32(_name)] = resourceContract;
807         resourceIdToName[resourceTypeCount] = stringToBytes32(_name);
808         
809         emit CSCResourceCreated(_name, resourceContract, _initialSupply);
810 
811         //Inc. for next resource
812         resourceTypeCount += 1;
813 
814     }
815 
816     function setResourcesPrimaryManager(address _op) public onlyManager {
817         
818         require(_op != address(0));
819 
820         uint16 totalResources = getResourceCount();
821 
822         for(uint16 i = 0; i < totalResources; i++) {
823             CSCResource resContract = CSCResource(resourceIdToAddress[i]);
824             resContract.setPrimaryManager(_op);
825         }
826 
827     }
828 
829     function setResourcesSecondaryManager(address _op) public onlyManager {
830 
831         require(_op != address(0));
832 
833         uint16 totalResources = getResourceCount();
834 
835         for(uint16 i = 0; i < totalResources; i++) {
836             CSCResource resContract = CSCResource(resourceIdToAddress[i]);
837             resContract.setSecondaryManager(_op);
838         }
839 
840     }
841 
842     function setResourcesBanker(address _op) public onlyManager {
843 
844         require(_op != address(0));
845 
846         uint16 totalResources = getResourceCount();
847 
848         for(uint16 i = 0; i < totalResources; i++) {
849             CSCResource resContract = CSCResource(resourceIdToAddress[i]);
850             resContract.setBanker(_op);
851         }
852 
853     }
854 
855     function setResourcesOtherManager(address _op, uint8 _state) public anyOperator {
856 
857         require(_op != address(0));
858 
859         uint16 totalResources = getResourceCount();
860 
861         for(uint16 i = 0; i < totalResources; i++) {
862             CSCResource resContract = CSCResource(resourceIdToAddress[i]);
863             resContract.setOtherManager(_op, _state);
864         }
865 
866     }
867 
868     function withdrawFactoryResourceBalance(uint16 _resId) public onlyBanker {
869 
870         require(resourceIdToAddress[_resId] != 0);
871 
872         CSCResource resContract = CSCResource(resourceIdToAddress[_resId]);
873         uint256 resBalance = resContract.balanceOf(this);
874         resContract.transfer(bankManager, resBalance);
875 
876     }
877 
878     function transferFactoryResourceAmount(uint16 _resId, address _to, uint256 _amount) public onlyBanker {
879 
880         require(resourceIdToAddress[_resId] != 0);
881         require(_to != address(0));
882 
883         CSCResource resContract = CSCResource(resourceIdToAddress[_resId]);
884         uint256 resBalance = resContract.balanceOf(this);
885         require(resBalance >= _amount);
886 
887         resContract.transfer(_to, _amount);
888     }
889 
890     function mintResource(uint16 _resId, uint256 _amount) public onlyBanker {
891 
892         require(resourceIdToAddress[_resId] != 0);
893         CSCResource resContract = CSCResource(resourceIdToAddress[_resId]);
894         resContract.mint(this, _amount);
895     }
896 
897     function burnResource(uint16 _resId, uint256 _amount) public onlyBanker {
898 
899         require(resourceIdToAddress[_resId] != 0);
900         CSCResource resContract = CSCResource(resourceIdToAddress[_resId]);
901         resContract.burn(_amount);
902     }
903 
904     function getResourceName(uint16 _resId) public view returns (bytes32 name) {
905         return resourceIdToName[_resId];
906     }
907 
908     function getResourceCount() public view returns (uint16 resourceTotal) {
909         return resourceTypeCount;
910     }
911 
912     function getResourceBalance(uint16 _resId, address _wallet) public view returns (uint256 amt) {
913 
914         require(resourceIdToAddress[_resId] != 0);
915 
916         CSCResource resContract = CSCResource(resourceIdToAddress[_resId]);
917         return resContract.balanceOf(_wallet);
918 
919     }
920 
921     /**
922     * @dev helps in fetching the wallet resouce balance
923     * @param _wallet The wallet address
924     */
925     function getWalletResourceBalance(address _wallet) external view returns(uint256[] resourceBalance){
926         require(_wallet != address(0));
927         
928         uint16 totalResources = getResourceCount();
929         
930         uint256[] memory result = new uint256[](totalResources);
931         
932         for(uint16 i = 0; i < totalResources; i++) {
933             CSCResource resContract = CSCResource(resourceIdToAddress[i]);
934             result[i] = resContract.balanceOf(_wallet);
935         }
936         
937         return result;
938     }
939 
940 }