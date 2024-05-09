1 pragma solidity ^0.4.13;
2 
3 contract ContractReceiver {
4     function tokenFallback(address _from, uint _value, bytes _data) public;
5 }
6 
7 contract PrivateSale is ContractReceiver {
8     using SafeMath for uint256;
9 
10     Token tokContract;
11     TimedEscrow escrow;
12     address owner;
13     // Conversion between wei and smallest unit of Token
14     // GNU and ETH have both 18 decimal places
15     // 1 ETH = 500 USD && 1 GNU = 0.025 USD ==> 1 ETH = 20000 GNU
16     // Then, in our case we have 1 wei = 20000 units
17     uint256 rate;
18 
19     // Timestamp for sale end
20     uint256 end;
21 
22     uint256 lockend1;
23 
24     uint256 lockend2;
25 
26     uint256 mincontrib;
27 
28     uint256 numerator;
29 
30     uint256 denominator;
31 
32     event Contribution(address from, uint256 eth, uint256 tokens);
33 
34     constructor(address _tokContract, address _escrowContract, uint256 _end, uint256 _lockend1, uint256 _lockend2, uint256 _numerator, uint256 _denominator, uint256 _mincontrib, uint256 _rate) public {
35         tokContract = Token(_tokContract);
36         escrow = TimedEscrow(_escrowContract);
37         owner = msg.sender;
38         end = _end;
39         require(_rate > 0);
40         rate = _rate;
41         numerator = _numerator;
42         require(_denominator > 0);
43         denominator = _denominator;
44         lockend1 = _lockend1;
45         lockend2 = _lockend2;
46         mincontrib = _mincontrib;
47     }
48 
49     function getMinContrib() public view returns (uint256){
50         return mincontrib;
51     }
52 
53     function setMinContrib(uint256 _mincontrib){
54         require(msg.sender == owner);
55         mincontrib = _mincontrib;
56     }
57 
58     function setLockend1(uint256 _lockend1){
59         require(msg.sender == owner);
60         require(_lockend1 <= lockend1);
61         lockend1 = _lockend1;
62     }
63 
64     function setLockend2(uint256 _lockend2){
65         require(msg.sender == owner);
66         require(_lockend2 <= lockend2);
67         lockend2 = _lockend2;
68     }
69 
70     function setLockRatio(uint256 _numerator, uint256 _denominator){
71         require(msg.sender == owner);
72         require(_denominator > 0);
73         numerator = _numerator;
74         denominator = _denominator;
75     }
76 
77     // Function to access remaining tokens allocated to this contract
78     function remaining() public view returns (uint) {
79         return tokContract.balanceOf(this);
80     }
81 
82     // Empties the contract of the remaining tokens
83     function withdrawTokens() public {
84         require(now > end);
85         require(msg.sender == owner);
86         tokContract.transfer(owner, tokContract.balanceOf(this));
87     }
88 
89     function tokenFallback(address _from, uint _value, bytes _data) public {
90         // Only the owner can send tokens to the SC
91         require(_from == owner, "Only owner can send tokens");
92     }
93 
94     // Fallback function to issue tokens when receiving ether
95     function() public payable {
96         require(now < end && msg.value >= mincontrib);
97         // Forward ether to owner, throws if error
98         owner.transfer(msg.value);
99 
100         uint256 toks = msg.value.mul(rate);
101 
102         emit Contribution(msg.sender, msg.value, toks);
103 
104         uint256 toks1 = toks.div(denominator).mul(numerator);
105 
106         uint256 toks2 = toks - toks1;
107 
108         bytes memory data = escrow.transactionRawToBytes(toks1, msg.sender, lockend1, true, false);
109 
110         bytes memory data2 = escrow.transactionRawToBytes(toks2, msg.sender, lockend2, true, false);
111 
112         // Transfer tokens to escrow
113         tokContract.transfer(
114             escrow,
115             toks1,
116             data
117         );
118 
119         tokContract.transfer(
120             escrow,
121             toks2,
122             data2
123         );
124     }
125 
126 }
127 
128 contract ERC20Interface {
129     //ERC20 with allowance
130     function allowance(address owner, address spender) public view returns (uint256);
131     function transferFrom(address from, address to, uint256 value) public returns (bool);
132     function approve(address spender, uint256 value) public returns (bool);
133     event Approval(
134         address indexed owner,
135         address indexed spender,
136         uint256 value
137     );
138 
139     // ERC20 Basic
140     function totalSupply() public view returns (uint256);
141     function balanceOf(address who) public view returns (uint256);
142     function transfer(address to, uint256 value) public returns (bool);
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 contract StandardERC20 is ERC20Interface {
147     using SafeMath for uint256;
148 
149     mapping(address => uint256) balances;
150     uint256 totalSupply_;
151 
152     /**
153     * @dev Total number of tokens in existence
154     */
155     function totalSupply() public view returns (uint256) {
156         return totalSupply_;
157     }
158 
159     /**
160     * @dev Transfer token for a specified address
161     * @param _to The address to transfer to.
162     * @param _value The amount to be transferred.
163     */
164     function transfer(address _to, uint256 _value) public returns (bool) {
165         require(_to != address(0));
166         require(_value <= balances[msg.sender]);
167 
168         balances[msg.sender] = balances[msg.sender].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         emit Transfer(msg.sender, _to, _value);
171         return true;
172     }
173 
174     /**
175     * @dev Gets the balance of the specified address.
176     * @param _owner The address to query the the balance of.
177     * @return An uint256 representing the amount owned by the passed address.
178     */
179     function balanceOf(address _owner) public view returns (uint256) {
180         return balances[_owner];
181     }
182 
183     /*
184         Allowance part
185     */
186 
187     mapping (address => mapping (address => uint256)) internal allowed;
188 
189 
190     /**
191     * @dev Transfer tokens from one address to another
192     * @param _from address The address which you want to send tokens from
193     * @param _to address The address which you want to transfer to
194     * @param _value uint256 the amount of tokens to be transferred
195     */
196     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197         require(_to != address(0));
198         require(_value <= balances[_from]);
199         require(_value <= allowed[_from][msg.sender]);
200 
201         balances[_from] = balances[_from].sub(_value);
202         balances[_to] = balances[_to].add(_value);
203         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204         emit Transfer(_from, _to, _value);
205         return true;
206     }
207 
208     /**
209     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210     * Beware that changing an allowance with this method brings the risk that someone may use both the old
211     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214     * @param _spender The address which will spend the funds.
215     * @param _value The amount of tokens to be spent.
216     */
217     function approve(address _spender, uint256 _value) public returns (bool) {
218         allowed[msg.sender][_spender] = _value;
219         emit Approval(msg.sender, _spender, _value);
220         return true;
221     }
222 
223     /**
224     * @dev Function to check the amount of tokens that an owner allowed to a spender.
225     * @param _owner address The address which owns the funds.
226     * @param _spender address The address which will spend the funds.
227     * @return A uint256 specifying the amount of tokens still available for the spender.
228     */
229     function allowance(address _owner, address _spender) public view returns (uint256) {
230         return allowed[_owner][_spender];
231     }
232 
233     /**
234     * @dev Increase the amount of tokens that an owner allowed to a spender.
235     * approve should be called when allowed[_spender] == 0. To increment
236     * allowed value is better to use this function to avoid 2 calls (and wait until
237     * the first transaction is mined)
238     * From MonolithDAO Token.sol
239     * @param _spender The address which will spend the funds.
240     * @param _addedValue The amount of tokens to increase the allowance by.
241     */
242     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
243         allowed[msg.sender][_spender] = (
244         allowed[msg.sender][_spender].add(_addedValue));
245         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246         return true;
247     }
248 
249     /**
250     * @dev Decrease the amount of tokens that an owner allowed to a spender.
251     * approve should be called when allowed[_spender] == 0. To decrement
252     * allowed value is better to use this function to avoid 2 calls (and wait until
253     * the first transaction is mined)
254     * From MonolithDAO Token.sol
255     * @param _spender The address which will spend the funds.
256     * @param _subtractedValue The amount of tokens to decrease the allowance by.
257     */
258     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
259         uint256 oldValue = allowed[msg.sender][_spender];
260         if (_subtractedValue > oldValue) {
261             allowed[msg.sender][_spender] = 0;
262         } else {
263             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264         }
265         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266         return true;
267     }
268 
269 
270 }
271 
272 contract Token is StandardERC20 {
273     
274     string public name    = "Genuine Token";
275     string public symbol  = "GNU";
276     uint8  public decimals = 18;
277 
278     address owner;
279 
280     bool burnable;
281 
282     event Transfer(address indexed from, address indexed to, uint value, bytes data);
283 
284     event Burn(address indexed burner, uint256 value);
285 
286 
287     constructor() public {
288         balances[msg.sender] = 340000000 * (uint(10) ** decimals);
289         totalSupply_ = balances[msg.sender];
290         owner = msg.sender;
291         burnable = false;
292     }
293 
294     function transferOwnership(address tbo) public {
295         require(msg.sender == owner, 'Unauthorized');
296         owner = tbo;
297     }
298        
299     // Function to access name of token .
300     function name() public view returns (string _name) {
301         return name;
302     }
303     
304     // Function to access symbol of token .
305     function symbol() public view returns (string _symbol) {
306         return symbol;
307     }
308     
309     // Function to access decimals of token .
310     function decimals() public view returns (uint8 _decimals) {
311         return decimals;
312     }
313     
314     // Function to access total supply of tokens .
315     function totalSupply() public view returns (uint256 _totalSupply) {
316         return totalSupply_;
317     }
318     
319     // Function that is called when a user or another contract wants to transfer funds .
320     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
321         require(_to != address(0));
322 
323         if (isContract(_to)) {
324             if (balanceOf(msg.sender) < _value) revert();
325             balances[msg.sender] = balanceOf(msg.sender).sub(_value);
326             balances[_to] = balanceOf(_to).add(_value);
327             assert(_to.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data));
328             emit Transfer(msg.sender, _to, _value, _data);
329             // ERC20 compliant transfer
330             emit Transfer(msg.sender, _to, _value);
331             return true;
332         } else {
333             return transferToAddress(_to, _value, _data);
334         }
335     }
336   
337 
338     // Function that is called when a user or another contract wants to transfer funds .
339     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
340         require(_to != address(0));
341         
342         if (isContract(_to)) {
343             return transferToContract(_to, _value, _data);
344         }
345         else {
346             return transferToAddress(_to, _value, _data);
347         }
348     }
349     
350     // Standard function transfer similar to ERC20 transfer with no _data .
351     // Added due to backwards compatibility reasons .
352     // Overrides the base transfer function of the standard ERC20 token
353     function transfer(address _to, uint _value) public returns (bool success) {
354         require(_to != address(0));
355         
356         //standard function transfer similar to ERC20 transfer with no _data
357         //added due to backwards compatibility reasons
358         bytes memory empty;
359         if (isContract(_to)) {
360             return transferToContract(_to, _value, empty);
361         }
362         else {
363             return transferToAddress(_to, _value, empty);
364         }
365     }
366 
367     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
368     function isContract(address _addr) private view returns (bool is_contract) {
369         uint length;
370         assembly {
371                 //retrieve the size of the code on target address, this needs assembly
372                 length := extcodesize(_addr)
373         }
374         return (length > 0);
375     }
376 
377     //function that is called when transaction target is an address
378     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
379         if (balanceOf(msg.sender) < _value) revert("Insufficient balance");
380         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
381         balances[_to] = balanceOf(_to).add(_value);
382         emit Transfer(msg.sender, _to, _value, _data);
383         // ERC20 compliant transfer
384         emit Transfer(msg.sender, _to, _value);
385         return true;
386     }
387     
388     //function that is called when transaction target is a contract
389     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
390         if (balanceOf(msg.sender) < _value) revert("Insufficient balance");
391         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
392         balances[_to] = balanceOf(_to).add(_value);
393         ContractReceiver receiver = ContractReceiver(_to);
394         receiver.tokenFallback(msg.sender, _value, _data);
395         emit Transfer(msg.sender, _to, _value, _data);
396         // ERC20 compliant transfer
397         emit Transfer(msg.sender, _to, _value);
398         return true;
399     }
400 
401     function setBurnable(bool _burnable) public {
402         require (msg.sender == owner);
403         burnable = _burnable;
404     }
405 
406     /**
407      * @dev Burns a specific amount of tokens.
408      * @param _value The amount of token to be burned.
409      */
410     function burn(uint256 _value) public {
411         _burn(msg.sender, _value);
412     }
413 
414     function _burn(address _who, uint256 _value) internal {
415 
416         require(burnable == true || _who == owner);
417 
418         require(_value <= balances[_who]);
419         // no need to require value <= totalSupply, since that would imply the
420         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
421 
422         balances[_who] = balances[_who].sub(_value);
423         totalSupply_ = totalSupply_.sub(_value);
424         emit Burn(_who, _value);
425         emit Transfer(_who, address(0), _value);
426     }
427 }
428 
429 library Array256Lib {
430 
431   /// @dev Sum vector
432   /// @param self Storage array containing uint256 type variables
433   /// @return sum The sum of all elements, does not check for overflow
434   function sumElements(uint256[] storage self) public view returns(uint256 sum) {
435     assembly {
436       mstore(0x60,self_slot)
437 
438       for { let i := 0 } lt(i, sload(self_slot)) { i := add(i, 1) } {
439         sum := add(sload(add(sha3(0x60,0x20),i)),sum)
440       }
441     }
442   }
443 
444   /// @dev Returns the max value in an array.
445   /// @param self Storage array containing uint256 type variables
446   /// @return maxValue The highest value in the array
447   function getMax(uint256[] storage self) public view returns(uint256 maxValue) {
448     assembly {
449       mstore(0x60,self_slot)
450       maxValue := sload(sha3(0x60,0x20))
451 
452       for { let i := 0 } lt(i, sload(self_slot)) { i := add(i, 1) } {
453         switch gt(sload(add(sha3(0x60,0x20),i)), maxValue)
454         case 1 {
455           maxValue := sload(add(sha3(0x60,0x20),i))
456         }
457       }
458     }
459   }
460 
461   /// @dev Returns the minimum value in an array.
462   /// @param self Storage array containing uint256 type variables
463   /// @return minValue The highest value in the array
464   function getMin(uint256[] storage self) public view returns(uint256 minValue) {
465     assembly {
466       mstore(0x60,self_slot)
467       minValue := sload(sha3(0x60,0x20))
468 
469       for { let i := 0 } lt(i, sload(self_slot)) { i := add(i, 1) } {
470         switch gt(sload(add(sha3(0x60,0x20),i)), minValue)
471         case 0 {
472           minValue := sload(add(sha3(0x60,0x20),i))
473         }
474       }
475     }
476   }
477 
478   /// @dev Finds the index of a given value in an array
479   /// @param self Storage array containing uint256 type variables
480   /// @param value The value to search for
481   /// @param isSorted True if the array is sorted, false otherwise
482   /// @return found True if the value was found, false otherwise
483   /// @return index The index of the given value, returns 0 if found is false
484   function indexOf(uint256[] storage self, uint256 value, bool isSorted)
485            public
486            view
487            returns(bool found, uint256 index) {
488     assembly{
489       mstore(0x60,self_slot)
490       switch isSorted
491       case 1 {
492         let high := sub(sload(self_slot),1)
493         let mid := 0
494         let low := 0
495         for { } iszero(gt(low, high)) { } {
496           mid := div(add(low,high),2)
497 
498           switch lt(sload(add(sha3(0x60,0x20),mid)),value)
499           case 1 {
500              low := add(mid,1)
501           }
502           case 0 {
503             switch gt(sload(add(sha3(0x60,0x20),mid)),value)
504             case 1 {
505               high := sub(mid,1)
506             }
507             case 0 {
508               found := 1
509               index := mid
510               low := add(high,1)
511             }
512           }
513         }
514       }
515       case 0 {
516         for { let low := 0 } lt(low, sload(self_slot)) { low := add(low, 1) } {
517           switch eq(sload(add(sha3(0x60,0x20),low)), value)
518           case 1 {
519             found := 1
520             index := low
521             low := sload(self_slot)
522           }
523         }
524       }
525     }
526   }
527 
528   /// @dev Utility function for heapSort
529   /// @param index The index of child node
530   /// @return pI The parent node index
531   function getParentI(uint256 index) private pure returns (uint256 pI) {
532     uint256 i = index - 1;
533     pI = i/2;
534   }
535 
536   /// @dev Utility function for heapSort
537   /// @param index The index of parent node
538   /// @return lcI The index of left child
539   function getLeftChildI(uint256 index) private pure returns (uint256 lcI) {
540     uint256 i = index * 2;
541     lcI = i + 1;
542   }
543 
544   /// @dev Sorts given array in place
545   /// @param self Storage array containing uint256 type variables
546   function heapSort(uint256[] storage self) public {
547     uint256 end = self.length - 1;
548     uint256 start = getParentI(end);
549     uint256 root = start;
550     uint256 lChild;
551     uint256 rChild;
552     uint256 swap;
553     uint256 temp;
554     while(start >= 0){
555       root = start;
556       lChild = getLeftChildI(start);
557       while(lChild <= end){
558         rChild = lChild + 1;
559         swap = root;
560         if(self[swap] < self[lChild])
561           swap = lChild;
562         if((rChild <= end) && (self[swap]<self[rChild]))
563           swap = rChild;
564         if(swap == root)
565           lChild = end+1;
566         else {
567           temp = self[swap];
568           self[swap] = self[root];
569           self[root] = temp;
570           root = swap;
571           lChild = getLeftChildI(root);
572         }
573       }
574       if(start == 0)
575         break;
576       else
577         start = start - 1;
578     }
579     while(end > 0){
580       temp = self[end];
581       self[end] = self[0];
582       self[0] = temp;
583       end = end - 1;
584       root = 0;
585       lChild = getLeftChildI(0);
586       while(lChild <= end){
587         rChild = lChild + 1;
588         swap = root;
589         if(self[swap] < self[lChild])
590           swap = lChild;
591         if((rChild <= end) && (self[swap]<self[rChild]))
592           swap = rChild;
593         if(swap == root)
594           lChild = end + 1;
595         else {
596           temp = self[swap];
597           self[swap] = self[root];
598           self[root] = temp;
599           root = swap;
600           lChild = getLeftChildI(root);
601         }
602       }
603     }
604   }
605 
606   /// @dev Removes duplicates from a given array.
607   /// @param self Storage array containing uint256 type variables
608   function uniq(uint256[] storage self) public returns (uint256 length) {
609     bool contains;
610     uint256 index;
611 
612     for (uint256 i = 0; i < self.length; i++) {
613       (contains, index) = indexOf(self, self[i], false);
614 
615       if (i > index) {
616         for (uint256 j = i; j < self.length - 1; j++){
617           self[j] = self[j + 1];
618         }
619 
620         delete self[self.length - 1];
621         self.length--;
622         i--;
623       }
624     }
625 
626     length = self.length;
627   }
628 }
629 
630 contract BytesToTypes {
631     
632 
633     function bytesToAddress(uint _offst, bytes memory _input) internal pure returns (address _output) {
634         
635         assembly {
636             _output := mload(add(_input, _offst))
637         }
638     } 
639     
640     function bytesToBool(uint _offst, bytes memory _input) internal pure returns (bool _output) {
641         
642         uint8 x;
643         assembly {
644             x := mload(add(_input, _offst))
645         }
646         x==0 ? _output = false : _output = true;
647     }   
648         
649     function getStringSize(uint _offst, bytes memory _input) internal pure returns(uint size){
650         
651         assembly{
652             
653             size := mload(add(_input,_offst))
654             let chunk_count := add(div(size,32),1) // chunk_count = size/32 + 1
655             
656             if gt(mod(size,32),0) {// if size%32 > 0
657                 chunk_count := add(chunk_count,1)
658             } 
659             
660              size := mul(chunk_count,32)// first 32 bytes reseves for size in strings
661         }
662     }
663 
664     function bytesToString(uint _offst, bytes memory _input, bytes memory _output) internal  {
665 
666         uint size = 32;
667         assembly {
668             let loop_index:= 0
669                   
670             let chunk_count
671             
672             size := mload(add(_input,_offst))
673             chunk_count := add(div(size,32),1) // chunk_count = size/32 + 1
674             
675             if gt(mod(size,32),0) {
676                 chunk_count := add(chunk_count,1)  // chunk_count++
677             }
678                 
679             
680             loop:
681                 mstore(add(_output,mul(loop_index,32)),mload(add(_input,_offst)))
682                 _offst := sub(_offst,32)           // _offst -= 32
683                 loop_index := add(loop_index,1)
684                 
685             jumpi(loop , lt(loop_index , chunk_count))
686             
687         }
688     }
689 
690     function bytesToBytes32(uint _offst, bytes memory  _input, bytes32 _output) internal pure {
691         
692         assembly {
693             mstore(_output , add(_input, _offst))
694             mstore(add(_output,32) , add(add(_input, _offst),32))
695         }
696     }
697     
698     function bytesToInt8(uint _offst, bytes memory  _input) internal pure returns (int8 _output) {
699         
700         assembly {
701             _output := mload(add(_input, _offst))
702         }
703     }
704     
705     function bytesToInt16(uint _offst, bytes memory _input) internal pure returns (int16 _output) {
706         
707         assembly {
708             _output := mload(add(_input, _offst))
709         }
710     }
711 
712     function bytesToInt24(uint _offst, bytes memory _input) internal pure returns (int24 _output) {
713         
714         assembly {
715             _output := mload(add(_input, _offst))
716         }
717     }
718 
719     function bytesToInt32(uint _offst, bytes memory _input) internal pure returns (int32 _output) {
720         
721         assembly {
722             _output := mload(add(_input, _offst))
723         }
724     }
725 
726     function bytesToInt40(uint _offst, bytes memory _input) internal pure returns (int40 _output) {
727         
728         assembly {
729             _output := mload(add(_input, _offst))
730         }
731     }
732 
733     function bytesToInt48(uint _offst, bytes memory _input) internal pure returns (int48 _output) {
734         
735         assembly {
736             _output := mload(add(_input, _offst))
737         }
738     }
739 
740     function bytesToInt56(uint _offst, bytes memory _input) internal pure returns (int56 _output) {
741         
742         assembly {
743             _output := mload(add(_input, _offst))
744         }
745     }
746 
747     function bytesToInt64(uint _offst, bytes memory _input) internal pure returns (int64 _output) {
748         
749         assembly {
750             _output := mload(add(_input, _offst))
751         }
752     }
753 
754     function bytesToInt72(uint _offst, bytes memory _input) internal pure returns (int72 _output) {
755         
756         assembly {
757             _output := mload(add(_input, _offst))
758         }
759     }
760 
761     function bytesToInt80(uint _offst, bytes memory _input) internal pure returns (int80 _output) {
762         
763         assembly {
764             _output := mload(add(_input, _offst))
765         }
766     }
767 
768     function bytesToInt88(uint _offst, bytes memory _input) internal pure returns (int88 _output) {
769         
770         assembly {
771             _output := mload(add(_input, _offst))
772         }
773     }
774 
775     function bytesToInt96(uint _offst, bytes memory _input) internal pure returns (int96 _output) {
776         
777         assembly {
778             _output := mload(add(_input, _offst))
779         }
780     }
781 	
782 	function bytesToInt104(uint _offst, bytes memory _input) internal pure returns (int104 _output) {
783         
784         assembly {
785             _output := mload(add(_input, _offst))
786         }
787     }
788     
789     function bytesToInt112(uint _offst, bytes memory _input) internal pure returns (int112 _output) {
790         
791         assembly {
792             _output := mload(add(_input, _offst))
793         }
794     }
795 
796     function bytesToInt120(uint _offst, bytes memory _input) internal pure returns (int120 _output) {
797         
798         assembly {
799             _output := mload(add(_input, _offst))
800         }
801     }
802 
803     function bytesToInt128(uint _offst, bytes memory _input) internal pure returns (int128 _output) {
804         
805         assembly {
806             _output := mload(add(_input, _offst))
807         }
808     }
809 
810     function bytesToInt136(uint _offst, bytes memory _input) internal pure returns (int136 _output) {
811         
812         assembly {
813             _output := mload(add(_input, _offst))
814         }
815     }
816 
817     function bytesToInt144(uint _offst, bytes memory _input) internal pure returns (int144 _output) {
818         
819         assembly {
820             _output := mload(add(_input, _offst))
821         }
822     }
823 
824     function bytesToInt152(uint _offst, bytes memory _input) internal pure returns (int152 _output) {
825         
826         assembly {
827             _output := mload(add(_input, _offst))
828         }
829     }
830 
831     function bytesToInt160(uint _offst, bytes memory _input) internal pure returns (int160 _output) {
832         
833         assembly {
834             _output := mload(add(_input, _offst))
835         }
836     }
837 
838     function bytesToInt168(uint _offst, bytes memory _input) internal pure returns (int168 _output) {
839         
840         assembly {
841             _output := mload(add(_input, _offst))
842         }
843     }
844 
845     function bytesToInt176(uint _offst, bytes memory _input) internal pure returns (int176 _output) {
846         
847         assembly {
848             _output := mload(add(_input, _offst))
849         }
850     }
851 
852     function bytesToInt184(uint _offst, bytes memory _input) internal pure returns (int184 _output) {
853         
854         assembly {
855             _output := mload(add(_input, _offst))
856         }
857     }
858 
859     function bytesToInt192(uint _offst, bytes memory _input) internal pure returns (int192 _output) {
860         
861         assembly {
862             _output := mload(add(_input, _offst))
863         }
864     }
865 
866     function bytesToInt200(uint _offst, bytes memory _input) internal pure returns (int200 _output) {
867         
868         assembly {
869             _output := mload(add(_input, _offst))
870         }
871     }
872 
873     function bytesToInt208(uint _offst, bytes memory _input) internal pure returns (int208 _output) {
874         
875         assembly {
876             _output := mload(add(_input, _offst))
877         }
878     }
879 
880     function bytesToInt216(uint _offst, bytes memory _input) internal pure returns (int216 _output) {
881         
882         assembly {
883             _output := mload(add(_input, _offst))
884         }
885     }
886 
887     function bytesToInt224(uint _offst, bytes memory _input) internal pure returns (int224 _output) {
888         
889         assembly {
890             _output := mload(add(_input, _offst))
891         }
892     }
893 
894     function bytesToInt232(uint _offst, bytes memory _input) internal pure returns (int232 _output) {
895         
896         assembly {
897             _output := mload(add(_input, _offst))
898         }
899     }
900 
901     function bytesToInt240(uint _offst, bytes memory _input) internal pure returns (int240 _output) {
902         
903         assembly {
904             _output := mload(add(_input, _offst))
905         }
906     }
907 
908     function bytesToInt248(uint _offst, bytes memory _input) internal pure returns (int248 _output) {
909         
910         assembly {
911             _output := mload(add(_input, _offst))
912         }
913     }
914 
915     function bytesToInt256(uint _offst, bytes memory _input) internal pure returns (int256 _output) {
916         
917         assembly {
918             _output := mload(add(_input, _offst))
919         }
920     }
921 
922 	function bytesToUint8(uint _offst, bytes memory _input) internal pure returns (uint8 _output) {
923         
924         assembly {
925             _output := mload(add(_input, _offst))
926         }
927     } 
928 
929 	function bytesToUint16(uint _offst, bytes memory _input) internal pure returns (uint16 _output) {
930         
931         assembly {
932             _output := mload(add(_input, _offst))
933         }
934     } 
935 
936 	function bytesToUint24(uint _offst, bytes memory _input) internal pure returns (uint24 _output) {
937         
938         assembly {
939             _output := mload(add(_input, _offst))
940         }
941     } 
942 
943 	function bytesToUint32(uint _offst, bytes memory _input) internal pure returns (uint32 _output) {
944         
945         assembly {
946             _output := mload(add(_input, _offst))
947         }
948     } 
949 
950 	function bytesToUint40(uint _offst, bytes memory _input) internal pure returns (uint40 _output) {
951         
952         assembly {
953             _output := mload(add(_input, _offst))
954         }
955     } 
956 
957 	function bytesToUint48(uint _offst, bytes memory _input) internal pure returns (uint48 _output) {
958         
959         assembly {
960             _output := mload(add(_input, _offst))
961         }
962     } 
963 
964 	function bytesToUint56(uint _offst, bytes memory _input) internal pure returns (uint56 _output) {
965         
966         assembly {
967             _output := mload(add(_input, _offst))
968         }
969     } 
970 
971 	function bytesToUint64(uint _offst, bytes memory _input) internal pure returns (uint64 _output) {
972         
973         assembly {
974             _output := mload(add(_input, _offst))
975         }
976     } 
977 
978 	function bytesToUint72(uint _offst, bytes memory _input) internal pure returns (uint72 _output) {
979         
980         assembly {
981             _output := mload(add(_input, _offst))
982         }
983     } 
984 
985 	function bytesToUint80(uint _offst, bytes memory _input) internal pure returns (uint80 _output) {
986         
987         assembly {
988             _output := mload(add(_input, _offst))
989         }
990     } 
991 
992 	function bytesToUint88(uint _offst, bytes memory _input) internal pure returns (uint88 _output) {
993         
994         assembly {
995             _output := mload(add(_input, _offst))
996         }
997     } 
998 
999 	function bytesToUint96(uint _offst, bytes memory _input) internal pure returns (uint96 _output) {
1000         
1001         assembly {
1002             _output := mload(add(_input, _offst))
1003         }
1004     } 
1005 	
1006 	function bytesToUint104(uint _offst, bytes memory _input) internal pure returns (uint104 _output) {
1007         
1008         assembly {
1009             _output := mload(add(_input, _offst))
1010         }
1011     } 
1012 
1013     function bytesToUint112(uint _offst, bytes memory _input) internal pure returns (uint112 _output) {
1014         
1015         assembly {
1016             _output := mload(add(_input, _offst))
1017         }
1018     } 
1019 
1020     function bytesToUint120(uint _offst, bytes memory _input) internal pure returns (uint120 _output) {
1021         
1022         assembly {
1023             _output := mload(add(_input, _offst))
1024         }
1025     } 
1026 
1027     function bytesToUint128(uint _offst, bytes memory _input) internal pure returns (uint128 _output) {
1028         
1029         assembly {
1030             _output := mload(add(_input, _offst))
1031         }
1032     } 
1033 
1034     function bytesToUint136(uint _offst, bytes memory _input) internal pure returns (uint136 _output) {
1035         
1036         assembly {
1037             _output := mload(add(_input, _offst))
1038         }
1039     } 
1040 
1041     function bytesToUint144(uint _offst, bytes memory _input) internal pure returns (uint144 _output) {
1042         
1043         assembly {
1044             _output := mload(add(_input, _offst))
1045         }
1046     } 
1047 
1048     function bytesToUint152(uint _offst, bytes memory _input) internal pure returns (uint152 _output) {
1049         
1050         assembly {
1051             _output := mload(add(_input, _offst))
1052         }
1053     } 
1054 
1055     function bytesToUint160(uint _offst, bytes memory _input) internal pure returns (uint160 _output) {
1056         
1057         assembly {
1058             _output := mload(add(_input, _offst))
1059         }
1060     } 
1061 
1062     function bytesToUint168(uint _offst, bytes memory _input) internal pure returns (uint168 _output) {
1063         
1064         assembly {
1065             _output := mload(add(_input, _offst))
1066         }
1067     } 
1068 
1069     function bytesToUint176(uint _offst, bytes memory _input) internal pure returns (uint176 _output) {
1070         
1071         assembly {
1072             _output := mload(add(_input, _offst))
1073         }
1074     } 
1075 
1076     function bytesToUint184(uint _offst, bytes memory _input) internal pure returns (uint184 _output) {
1077         
1078         assembly {
1079             _output := mload(add(_input, _offst))
1080         }
1081     } 
1082 
1083     function bytesToUint192(uint _offst, bytes memory _input) internal pure returns (uint192 _output) {
1084         
1085         assembly {
1086             _output := mload(add(_input, _offst))
1087         }
1088     } 
1089 
1090     function bytesToUint200(uint _offst, bytes memory _input) internal pure returns (uint200 _output) {
1091         
1092         assembly {
1093             _output := mload(add(_input, _offst))
1094         }
1095     } 
1096 
1097     function bytesToUint208(uint _offst, bytes memory _input) internal pure returns (uint208 _output) {
1098         
1099         assembly {
1100             _output := mload(add(_input, _offst))
1101         }
1102     } 
1103 
1104     function bytesToUint216(uint _offst, bytes memory _input) internal pure returns (uint216 _output) {
1105         
1106         assembly {
1107             _output := mload(add(_input, _offst))
1108         }
1109     } 
1110 
1111     function bytesToUint224(uint _offst, bytes memory _input) internal pure returns (uint224 _output) {
1112         
1113         assembly {
1114             _output := mload(add(_input, _offst))
1115         }
1116     } 
1117 
1118     function bytesToUint232(uint _offst, bytes memory _input) internal pure returns (uint232 _output) {
1119         
1120         assembly {
1121             _output := mload(add(_input, _offst))
1122         }
1123     } 
1124 
1125     function bytesToUint240(uint _offst, bytes memory _input) internal pure returns (uint240 _output) {
1126         
1127         assembly {
1128             _output := mload(add(_input, _offst))
1129         }
1130     } 
1131 
1132     function bytesToUint248(uint _offst, bytes memory _input) internal pure returns (uint248 _output) {
1133         
1134         assembly {
1135             _output := mload(add(_input, _offst))
1136         }
1137     } 
1138 
1139     function bytesToUint256(uint _offst, bytes memory _input) internal pure returns (uint256 _output) {
1140         
1141         assembly {
1142             _output := mload(add(_input, _offst))
1143         }
1144     } 
1145     
1146 }
1147 
1148 library SafeMath {
1149 
1150     /**
1151     * @dev Multiplies two numbers, throws on overflow.
1152     */
1153     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1154         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1155         // benefit is lost if 'b' is also tested.
1156         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1157         if (a == 0) {
1158             return 0;
1159         }
1160 
1161         c = a * b;
1162         assert(c / a == b);
1163         return c;
1164     }
1165 
1166     /**
1167     * @dev Integer division of two numbers, truncating the quotient.
1168     */
1169     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1170         // assert(b > 0); // Solidity automatically throws when dividing by 0
1171         // uint256 c = a / b;
1172         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1173         return a / b;
1174     }
1175 
1176     /**
1177     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1178     */
1179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1180         assert(b <= a);
1181         return a - b;
1182     }
1183 
1184     /**
1185     * @dev Adds two numbers, throws on overflow.
1186     */
1187     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1188         c = a + b;
1189         assert(c >= a);
1190         return c;
1191     }
1192 }
1193 
1194 contract  SizeOf {
1195     
1196     function sizeOfString(string _in) internal pure  returns(uint _size){
1197         _size = bytes(_in).length / 32;
1198          if(bytes(_in).length % 32 != 0) 
1199             _size++;
1200             
1201         _size++; // first 32 bytes is reserved for the size of the string     
1202         _size *= 32;
1203     }
1204 
1205     function sizeOfInt(uint16 _postfix) internal pure  returns(uint size){
1206 
1207         assembly{
1208             switch _postfix
1209                 case 8 { size := 1 }
1210                 case 16 { size := 2 }
1211                 case 24 { size := 3 }
1212                 case 32 { size := 4 }
1213                 case 40 { size := 5 }
1214                 case 48 { size := 6 }
1215                 case 56 { size := 7 }
1216                 case 64 { size := 8 }
1217                 case 72 { size := 9 }
1218                 case 80 { size := 10 }
1219                 case 88 { size := 11 }
1220                 case 96 { size := 12 }
1221                 case 104 { size := 13 }
1222                 case 112 { size := 14 }
1223                 case 120 { size := 15 }
1224                 case 128 { size := 16 }
1225                 case 136 { size := 17 }
1226                 case 144 { size := 18 }
1227                 case 152 { size := 19 }
1228                 case 160 { size := 20 }
1229                 case 168 { size := 21 }
1230                 case 176 { size := 22 }
1231                 case 184 { size := 23 }
1232                 case 192 { size := 24 }
1233                 case 200 { size := 25 }
1234                 case 208 { size := 26 }
1235                 case 216 { size := 27 }
1236                 case 224 { size := 28 }
1237                 case 232 { size := 29 }
1238                 case 240 { size := 30 }
1239                 case 248 { size := 31 }
1240                 case 256 { size := 32 }
1241                 default  { size := 32 }
1242         }
1243 
1244     }
1245     
1246     function sizeOfUint(uint16 _postfix) internal pure  returns(uint size){
1247         return sizeOfInt(_postfix);
1248     }
1249 
1250     function sizeOfAddress() internal pure  returns(uint8){
1251         return 20; 
1252     }
1253     
1254     function sizeOfBool() internal pure  returns(uint8){
1255         return 1; 
1256     }
1257     
1258 
1259 }
1260 
1261 contract TypesToBytes {
1262  
1263     function TypesToBytes() internal {
1264         
1265     }
1266     function addressToBytes(uint _offst, address _input, bytes memory _output) internal pure {
1267 
1268         assembly {
1269             mstore(add(_output, _offst), _input)
1270         }
1271     }
1272 
1273     function bytes32ToBytes(uint _offst, bytes32 _input, bytes memory _output) internal pure {
1274 
1275         assembly {
1276             mstore(add(_output, _offst), _input)
1277             mstore(add(add(_output, _offst),32), add(_input,32))
1278         }
1279     }
1280     
1281     function boolToBytes(uint _offst, bool _input, bytes memory _output) internal pure {
1282         uint8 x = _input == false ? 0 : 1;
1283         assembly {
1284             mstore(add(_output, _offst), x)
1285         }
1286     }
1287     
1288     function stringToBytes(uint _offst, bytes memory _input, bytes memory _output) internal {
1289         uint256 stack_size = _input.length / 32;
1290         if(_input.length % 32 > 0) stack_size++;
1291         
1292         assembly {
1293             let index := 0
1294             stack_size := add(stack_size,1)//adding because of 32 first bytes memory as the length
1295         loop:
1296             
1297             mstore(add(_output, _offst), mload(add(_input,mul(index,32))))
1298             _offst := sub(_offst , 32)
1299             index := add(index ,1)
1300             jumpi(loop , lt(index,stack_size))
1301         }
1302     }
1303 
1304     function intToBytes(uint _offst, int _input, bytes memory  _output) internal pure {
1305 
1306         assembly {
1307             mstore(add(_output, _offst), _input)
1308         }
1309     } 
1310     
1311     function uintToBytes(uint _offst, uint _input, bytes memory _output) internal pure {
1312 
1313         assembly {
1314             mstore(add(_output, _offst), _input)
1315         }
1316     }   
1317 
1318 }
1319 
1320 contract Seriality is BytesToTypes, TypesToBytes, SizeOf {
1321 
1322     function Seriality() public {
1323 
1324     }
1325 }
1326 
1327 contract TimedEscrow is ContractReceiver, Seriality {
1328 
1329     using Array256Lib for uint256[];
1330 
1331     struct Transaction {
1332         uint256 value;
1333         address to_address;
1334         uint256 time;
1335         bool valid; //we do not want to get rid of transactions that are cancelled, just void them
1336         bool executed; //we want to separate the concept of executed transactions from the invalid ones which should both be immutable
1337     }
1338 
1339     Token tokContract;
1340     address owner;
1341 
1342     Transaction[] transactions;
1343 
1344     mapping(address => uint256[]) transactions_of;
1345 
1346     // Events
1347     event addingTransaction(uint256 value, address addr, uint256 time, bool valid, bool executed, uint index);
1348     event voidingTransaction(uint256 index);
1349 
1350 
1351     constructor(address _tokContract) public {
1352         tokContract = Token(_tokContract);
1353         owner = msg.sender;
1354     }
1355 
1356     function addTransaction(Transaction transaction) private {
1357         transactions.push(transaction);
1358         transactions_of[transaction.to_address].push(transactions.length - 1);
1359         emit addingTransaction(transaction.value, transaction.to_address, transaction.time, transaction.valid, transaction.executed, transactions.length - 1);
1360     }
1361 
1362     function transferOwnership(address tbo){
1363         require(msg.sender == owner, 'Unauthorized');
1364         owner = tbo;
1365     }
1366 
1367     //ETH has been transfered so we should not be allowed to void transactions
1368     //Should we allow beneficiary to void his transaction? Maybe they have lost private key to hackers
1369 
1370     function voidTransaction(uint256 transaction_id){
1371         require(
1372             msg.sender == transactions[transaction_id].to_address
1373             && !transactions[transaction_id].executed
1374         && transactions[transaction_id].valid
1375         );
1376         transactions[transaction_id].valid = false;
1377         tokContract.transfer(owner, transactions[transaction_id].value);
1378         emit voidingTransaction(transaction_id);
1379     }
1380 
1381     function getTransactionIdsOf(address to_address) public view returns (uint[]){
1382         return transactions_of[to_address];
1383     }
1384 
1385     function getTransaction(uint256 transaction_id) public view returns (uint256 value, address to_address, uint256 time, bool valid, bool executed){
1386         Transaction memory t = transactions[transaction_id];
1387         value = t.value;
1388         to_address = t.to_address;
1389         time = t.time;
1390         valid = t.valid;
1391         executed = t.executed;
1392         return;
1393     }
1394 
1395     function performTransaction(uint256 transaction_id){
1396         Transaction tbp = transactions[transaction_id];
1397         require(now > tbp.time && tbp.valid && !tbp.executed, 'Invalid transaction data');
1398         tbp.executed = true;
1399         transactions[transaction_id] = tbp;
1400         tokContract.transfer(tbp.to_address, tbp.value);
1401     }
1402 
1403     function transactionStructFromBytesSeriality(bytes data) internal pure returns (Transaction){
1404         Transaction memory t;
1405         uint offset = 128;
1406         bytes memory buffer = new bytes(128);
1407 
1408         t.value = bytesToUint256(offset, data);
1409         offset -= sizeOfUint(256);
1410 
1411         t.to_address = bytesToAddress(offset, data);
1412         offset -= sizeOfAddress();
1413 
1414         t.time = bytesToUint256(offset, data);
1415         offset -= sizeOfUint(256);
1416 
1417         t.valid = bytesToBool(offset, data);
1418         offset -= sizeOfBool();
1419 
1420         t.executed = bytesToBool(offset, data);
1421         offset -= sizeOfBool();
1422         return t;
1423 
1424     }
1425 
1426     function transactionStructToBytesSeriality(Transaction t) private pure returns (bytes){
1427         bytes memory buffer = new bytes(128);
1428         uint offset = 128;
1429 
1430         uintToBytes(offset, t.value, buffer);
1431         offset -= sizeOfUint(256);
1432 
1433         addressToBytes(offset, t.to_address, buffer);
1434         offset -= sizeOfAddress();
1435 
1436         uintToBytes(offset, t.time, buffer);
1437         offset -= sizeOfUint(256);
1438 
1439         boolToBytes(offset, t.valid, buffer);
1440         offset -= sizeOfBool();
1441 
1442         boolToBytes(offset, t.executed, buffer);
1443         offset -= sizeOfBool();
1444         return buffer;
1445     }
1446 
1447     function transactionRawToBytes(uint256 value, address to_address, uint256 time, bool valid, bool executed) public pure returns (bytes){
1448         Transaction memory t;
1449         t.value = value;
1450         t.to_address = to_address;
1451         t.time = time;
1452         t.valid = valid;
1453         t.executed = executed;
1454         return transactionStructToBytesSeriality(t);
1455     }
1456 
1457     function tokenFallback(address _from, uint _value, bytes _data) public {
1458         require(_value > 0, 'No transaction was added because value was zero');
1459         Transaction memory transaction = transactionStructFromBytesSeriality(_data);
1460         require(transaction.value == _value, 'Token sent were not equal to token to store');
1461         require(transaction.time > now, 'Time was in the past');
1462         require(transaction.valid == true && transaction.executed == false, 'Transaction data is invalid');
1463         addTransaction(transaction);
1464     }
1465 
1466     function rescheduleTransaction(uint256 transaction_id, uint256 newtime) public {
1467         require(msg.sender == owner);
1468         require(!transactions[transaction_id].executed
1469         && transactions[transaction_id].valid
1470         && transactions[transaction_id].time > newtime);
1471         transactions[transaction_id].time = newtime;
1472     }
1473 
1474 }