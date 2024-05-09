1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     //Variables
11     address public owner;
12 
13     address public newOwner;
14 
15     //    Modifiers
16     /**
17      * @dev Throws if called by any account other than the owner.
18      */
19     modifier onlyOwner() {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     /**
25      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26      * account.
27      */
28     function Ownable() public {
29         owner = msg.sender;
30     }
31 
32     /**
33      * @dev Allows the current owner to transfer control of the contract to a newOwner.
34      * @param _newOwner The address to transfer ownership to.
35      */
36     function transferOwnership(address _newOwner) public onlyOwner {
37         require(_newOwner != address(0));
38         newOwner = _newOwner;
39     }
40 
41     function acceptOwnership() public {
42         if (msg.sender == newOwner) {
43             owner = newOwner;
44         }
45     }
46 }
47 
48 
49 
50 
51 
52 
53 
54 
55 
56 
57 
58 
59 contract TokenRecipient {
60     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
61 }
62 
63 
64 contract ERC20 is Ownable {
65 
66     using SafeMath for uint256;
67 
68     /* Public variables of the token */
69     string public standard;
70 
71     string public name;
72 
73     string public symbol;
74 
75     uint8 public decimals;
76 
77     uint256 public initialSupply;
78 
79     bool public locked;
80 
81     uint256 public creationBlock;
82 
83     mapping (address => uint256) public balances;
84 
85     mapping (address => mapping (address => uint256)) public allowance;
86 
87     /* This generates a public event on the blockchain that will notify clients */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     event Approval(address indexed _owner, address indexed _spender, uint _value);
91 
92     modifier onlyPayloadSize(uint numwords) {
93         assert(msg.data.length == numwords.mul(32).add(4));
94         _;
95     }
96 
97     /* Initializes contract with initial supply tokens to the creator of the contract */
98     function ERC20(
99         uint256 _initialSupply,
100         string _tokenName,
101         uint8 _decimalUnits,
102         string _tokenSymbol,
103         bool _transferAllSupplyToOwner,
104         bool _locked
105     ) {
106         standard = "ERC20 0.1";
107 
108         initialSupply = _initialSupply;
109 
110         if (_transferAllSupplyToOwner) {
111             setBalance(msg.sender, initialSupply);
112         } else {
113             setBalance(this, initialSupply);
114         }
115 
116         name = _tokenName;
117         // Set the name for display purposes
118         symbol = _tokenSymbol;
119         // Set the symbol for display purposes
120         decimals = _decimalUnits;
121         // Amount of decimals for display purposes
122         locked = _locked;
123         creationBlock = block.number;
124     }
125 
126     /* public methods */
127     function totalSupply() public constant returns (uint256) {
128         return initialSupply;
129     }
130 
131     function balanceOf(address _address) public constant returns (uint256) {
132         return balances[_address];
133     }
134 
135     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
136         require(locked == false);
137 
138         bool status = transferInternal(msg.sender, _to, _value);
139 
140         require(status == true);
141 
142         return true;
143     }
144 
145     function approve(address _spender, uint256 _value) public returns (bool success) {
146         if (locked) {
147             return false;
148         }
149 
150         allowance[msg.sender][_spender] = _value;
151         Approval(msg.sender, _spender, _value);
152 
153         return true;
154     }
155 
156     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
157         if (locked) {
158             return false;
159         }
160 
161         TokenRecipient spender = TokenRecipient(_spender);
162 
163         if (approve(_spender, _value)) {
164             spender.receiveApproval(msg.sender, _value, this, _extraData);
165             return true;
166         }
167     }
168 
169     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
170         if (locked) {
171             return false;
172         }
173 
174         if (allowance[_from][msg.sender] < _value) {
175             return false;
176         }
177 
178         bool _success = transferInternal(_from, _to, _value);
179 
180         if (_success) {
181             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
182         }
183 
184         return _success;
185     }
186 
187     /* internal balances */
188     function setBalance(address _holder, uint256 _amount) internal {
189         balances[_holder] = _amount;
190     }
191 
192     function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
193         if (_value == 0) {
194             Transfer(_from, _to, 0);
195             return true;
196         }
197 
198         if (balances[_from] < _value) {
199             return false;
200         }
201 
202         setBalance(_from, balances[_from].sub(_value));
203         setBalance(_to, balances[_to].add(_value));
204 
205         Transfer(_from, _to, _value);
206 
207         return true;
208     }
209 
210 }
211 
212 
213 
214 /*
215 This contract manages the minters and the modifier to allow mint to happen only if called by minters
216 This contract contains basic minting functionality though
217 */
218 contract MintingERC20 is ERC20 {
219 
220     using SafeMath for uint256;
221 
222     uint256 public maxSupply;
223 
224     mapping (address => bool) public minters;
225 
226     modifier onlyMinters () {
227         require(true == minters[msg.sender]);
228         _;
229     }
230 
231     function MintingERC20(
232         uint256 _initialSupply,
233         uint256 _maxSupply,
234         string _tokenName,
235         uint8 _decimals,
236         string _symbol,
237         bool _transferAllSupplyToOwner,
238         bool _locked
239     )
240         ERC20(_initialSupply, _tokenName, _decimals, _symbol, _transferAllSupplyToOwner, _locked)
241     {
242         minters[msg.sender] = true;
243         maxSupply = _maxSupply;
244     }
245 
246     function addMinter(address _newMinter) public onlyOwner {
247         minters[_newMinter] = true;
248     }
249 
250     function removeMinter(address _minter) public onlyOwner {
251         minters[_minter] = false;
252     }
253 
254     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
255         if (_amount == uint256(0)) {
256             return uint256(0);
257         }
258 
259         if (totalSupply().add(_amount) > maxSupply) {
260             return uint256(0);
261         }
262 
263         initialSupply = initialSupply.add(_amount);
264         balances[_addr] = balances[_addr].add(_amount);
265         Transfer(0, _addr, _amount);
266 
267         return _amount;
268     }
269 }
270 
271 
272 
273 
274 
275 
276 
277 
278 
279 contract Node is MintingERC20 {
280 
281     using SafeMath for uint256;
282 
283     NodePhases public nodePhases;
284 
285     // Block token transfers till ICO end.
286     bool public transferFrozen = true;
287 
288     function Node(
289         uint256 _maxSupply,
290         string _tokenName,
291         string _tokenSymbol,
292         uint8 _precision,
293         bool _locked
294     ) MintingERC20(0, _maxSupply, _tokenName, _precision, _tokenSymbol, false, _locked) {
295         standard = "Node 0.1";
296     }
297 
298     function setLocked(bool _locked) public onlyOwner {
299         locked = _locked;
300     }
301 
302     function setNodePhases(address _nodePhases) public onlyOwner {
303         nodePhases = NodePhases(_nodePhases);
304     }
305 
306     function unfreeze() public onlyOwner {
307         if (nodePhases != address(0) && nodePhases.isFinished(1)) {
308             transferFrozen = false;
309         }
310     }
311 
312     function buyBack(address _address) public onlyMinters returns (uint256) {
313         require(address(_address) != address(0));
314 
315         uint256 balance = balanceOf(_address);
316         setBalance(_address, 0);
317         setBalance(this, balanceOf(this).add(balance));
318         Transfer(_address, this, balance);
319 
320         return balance;
321     }
322 
323     function transfer(address _to, uint _value) public returns (bool) {
324         require(!transferFrozen);
325 
326         return super.transfer(_to, _value);
327     }
328 
329     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
330         require(!transferFrozen);
331 
332         return super.transferFrom(_from, _to, _value);
333     }
334 
335 }
336 
337 
338 
339 
340 
341 
342 contract NodeAllocation is Ownable {
343 
344     using SafeMath for uint256;
345 
346     PreICOAllocation[] public preIcoAllocation;
347 
348     ICOAllocation[] public icoAllocation;
349 
350     uint256[] public distributionThresholds;
351 
352     address public bountyAddress;
353 
354     struct PreICOAllocation {
355         uint8 percentage;
356         address destAddress;
357     }
358 
359     struct ICOAllocation {
360         uint8 percentage;
361         address destAddress;
362     }
363 
364     function NodeAllocation(
365         address _bountyAddress, //2%
366         address[] _preICOAddresses, //according - 3% and 97%
367         address[] _icoAddresses, //according - 3% 47% and 50%
368         uint256[] _distributionThresholds
369     ) {
370         require((address(_bountyAddress) != address(0)) && _distributionThresholds.length > 0);
371 
372         bountyAddress = _bountyAddress;
373         distributionThresholds = _distributionThresholds;
374 
375         require(setPreICOAllocation(_preICOAddresses) == true);
376         require(setICOAllocation(_icoAddresses) == true);
377     }
378 
379     function getPreICOAddress(uint8 _id) public returns (address) {
380         PreICOAllocation storage allocation = preIcoAllocation[_id];
381 
382         return allocation.destAddress;
383     }
384 
385     function getPreICOPercentage(uint8 _id) public returns (uint8) {
386         PreICOAllocation storage allocation = preIcoAllocation[_id];
387 
388         return allocation.percentage;
389     }
390 
391     function getPreICOLength() public returns (uint8) {
392         return uint8(preIcoAllocation.length);
393     }
394 
395     function getICOAddress(uint8 _id) public returns (address) {
396         ICOAllocation storage allocation = icoAllocation[_id];
397 
398         return allocation.destAddress;
399     }
400 
401     function getICOPercentage(uint8 _id) public returns (uint8) {
402         ICOAllocation storage allocation = icoAllocation[_id];
403 
404         return allocation.percentage;
405     }
406 
407     function getICOLength() public returns (uint8) {
408         return uint8(icoAllocation.length);
409     }
410 
411     function getThreshold(uint8 _id) public returns (uint256) {
412         return uint256(distributionThresholds[_id]);
413     }
414 
415     function getThresholdsLength() public returns (uint8) {
416         return uint8(distributionThresholds.length);
417     }
418 
419     function setPreICOAllocation(address[] _addresses) internal returns (bool) {
420         if (_addresses.length < 2) {
421             return false;
422         }
423         preIcoAllocation.push(PreICOAllocation(3, _addresses[0]));
424         preIcoAllocation.push(PreICOAllocation(97, _addresses[1]));
425 
426         return true;
427     }
428 
429     function setICOAllocation(address[] _addresses) internal returns (bool) {
430         if (_addresses.length < 3) {
431             return false;
432         }
433         icoAllocation.push(ICOAllocation(3, _addresses[0]));
434         icoAllocation.push(ICOAllocation(47, _addresses[1]));
435         icoAllocation.push(ICOAllocation(50, _addresses[2]));
436 
437         return true;
438     }
439 }
440 
441 
442 
443 /**
444  * @title SafeMath
445  * @dev Math operations with safety checks that throw on error
446  */
447 library SafeMath {
448     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
449         uint256 c = a * b;
450         assert(a == 0 || c / a == b);
451         return c;
452     }
453 
454     function div(uint256 a, uint256 b) internal constant returns (uint256) {
455         // assert(b > 0); // Solidity automatically throws when dividing by 0
456         uint256 c = a / b;
457         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
458         return c;
459     }
460 
461     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
462         assert(b <= a);
463         return a - b;
464     }
465 
466     function add(uint256 a, uint256 b) internal constant returns (uint256) {
467         uint256 c = a + b;
468         assert(c >= a);
469         return c;
470     }
471 }
472 /* solhint-disable */
473 // <ORACLIZE_API>
474 /*
475 Copyright (c) 2015-2016 Oraclize SRL
476 Copyright (c) 2016 Oraclize LTD
477 
478 
479 
480 Permission is hereby granted, free of charge, to any person obtaining a copy
481 of this software and associated documentation files (the "Software"), to deal
482 in the Software without restriction, including without limitation the rights
483 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
484 copies of the Software, and to permit persons to whom the Software is
485 furnished to do so, subject to the following conditions:
486 
487 
488 
489 The above copyright notice and this permission notice shall be included in
490 all copies or substantial portions of the Software.
491 
492 
493 
494 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
495 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
496 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
497 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
498 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
499 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
500 THE SOFTWARE.
501 */
502 
503 //please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
504 
505 contract OraclizeI {
506     address public cbAddress;
507     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
508     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
509     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
510     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
511     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
512     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
513     function getPrice(string _datasource) returns (uint _dsprice);
514     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
515     function useCoupon(string _coupon);
516     function setProofType(byte _proofType);
517     function setConfig(bytes32 _config);
518     function setCustomGasPrice(uint _gasPrice);
519     function randomDS_getSessionPubKeyHash() returns(bytes32);
520 }
521 contract OraclizeAddrResolverI {
522     function getAddress() returns (address _addr);
523 }
524 contract usingOraclize {
525     uint constant day = 60*60*24;
526     uint constant week = 60*60*24*7;
527     uint constant month = 60*60*24*30;
528     byte constant proofType_NONE = 0x00;
529     byte constant proofType_TLSNotary = 0x10;
530     byte constant proofType_Android = 0x20;
531     byte constant proofType_Ledger = 0x30;
532     byte constant proofType_Native = 0xF0;
533     byte constant proofStorage_IPFS = 0x01;
534     uint8 constant networkID_auto = 0;
535     uint8 constant networkID_mainnet = 1;
536     uint8 constant networkID_testnet = 2;
537     uint8 constant networkID_morden = 2;
538     uint8 constant networkID_consensys = 161;
539 
540     OraclizeAddrResolverI OAR;
541 
542     OraclizeI oraclize;
543     modifier oraclizeAPI {
544         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
545         oraclize = OraclizeI(OAR.getAddress());
546         _;
547     }
548     modifier coupon(string code){
549         oraclize = OraclizeI(OAR.getAddress());
550         oraclize.useCoupon(code);
551         _;
552     }
553 
554     function oraclize_setNetwork(uint8) internal returns(bool){
555 //    function oraclize_setNetwork(uint8 networkID) internal returns(bool){
556         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
557             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
558             oraclize_setNetworkName("eth_mainnet");
559             return true;
560         }
561         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
562             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
563             oraclize_setNetworkName("eth_ropsten3");
564             return true;
565         }
566         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
567             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
568             oraclize_setNetworkName("eth_kovan");
569             return true;
570         }
571         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
572             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
573             oraclize_setNetworkName("eth_rinkeby");
574             return true;
575         }
576         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
577             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
578             return true;
579         }
580         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
581             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
582             return true;
583         }
584         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
585             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
586             return true;
587         }
588         return false;
589     }
590 
591     function __callback(bytes32 myid, string result) {
592         __callback(myid, result, new bytes(0));
593     }
594     function __callback(bytes32, string, bytes) {
595 //    function __callback(bytes32 myid, string result, bytes proof) {
596     }
597 
598     function oraclize_useCoupon(string code) oraclizeAPI internal {
599         oraclize.useCoupon(code);
600     }
601 
602     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
603         return oraclize.getPrice(datasource);
604     }
605 
606     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
607         return oraclize.getPrice(datasource, gaslimit);
608     }
609 
610     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
611         uint price = oraclize.getPrice(datasource);
612         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
613         return oraclize.query.value(price)(0, datasource, arg);
614     }
615     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
616         uint price = oraclize.getPrice(datasource);
617         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
618         return oraclize.query.value(price)(timestamp, datasource, arg);
619     }
620     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
621         uint price = oraclize.getPrice(datasource, gaslimit);
622         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
623         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
624     }
625     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
626         uint price = oraclize.getPrice(datasource, gaslimit);
627         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
628         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
629     }
630     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
631         uint price = oraclize.getPrice(datasource);
632         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
633         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
634     }
635     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
636         uint price = oraclize.getPrice(datasource);
637         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
638         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
639     }
640     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
641         uint price = oraclize.getPrice(datasource, gaslimit);
642         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
643         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
644     }
645     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
646         uint price = oraclize.getPrice(datasource, gaslimit);
647         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
648         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
649     }
650     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
651         uint price = oraclize.getPrice(datasource);
652         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
653         bytes memory args = stra2cbor(argN);
654         return oraclize.queryN.value(price)(0, datasource, args);
655     }
656     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
657         uint price = oraclize.getPrice(datasource);
658         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
659         bytes memory args = stra2cbor(argN);
660         return oraclize.queryN.value(price)(timestamp, datasource, args);
661     }
662     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
663         uint price = oraclize.getPrice(datasource, gaslimit);
664         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
665         bytes memory args = stra2cbor(argN);
666         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
667     }
668     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
669         uint price = oraclize.getPrice(datasource, gaslimit);
670         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
671         bytes memory args = stra2cbor(argN);
672         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
673     }
674     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
675         string[] memory dynargs = new string[](1);
676         dynargs[0] = args[0];
677         return oraclize_query(datasource, dynargs);
678     }
679     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
680         string[] memory dynargs = new string[](1);
681         dynargs[0] = args[0];
682         return oraclize_query(timestamp, datasource, dynargs);
683     }
684     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
685         string[] memory dynargs = new string[](1);
686         dynargs[0] = args[0];
687         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
688     }
689     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
690         string[] memory dynargs = new string[](1);
691         dynargs[0] = args[0];
692         return oraclize_query(datasource, dynargs, gaslimit);
693     }
694 
695     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
696         string[] memory dynargs = new string[](2);
697         dynargs[0] = args[0];
698         dynargs[1] = args[1];
699         return oraclize_query(datasource, dynargs);
700     }
701     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
702         string[] memory dynargs = new string[](2);
703         dynargs[0] = args[0];
704         dynargs[1] = args[1];
705         return oraclize_query(timestamp, datasource, dynargs);
706     }
707     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
708         string[] memory dynargs = new string[](2);
709         dynargs[0] = args[0];
710         dynargs[1] = args[1];
711         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
712     }
713     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
714         string[] memory dynargs = new string[](2);
715         dynargs[0] = args[0];
716         dynargs[1] = args[1];
717         return oraclize_query(datasource, dynargs, gaslimit);
718     }
719     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
720         string[] memory dynargs = new string[](3);
721         dynargs[0] = args[0];
722         dynargs[1] = args[1];
723         dynargs[2] = args[2];
724         return oraclize_query(datasource, dynargs);
725     }
726     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
727         string[] memory dynargs = new string[](3);
728         dynargs[0] = args[0];
729         dynargs[1] = args[1];
730         dynargs[2] = args[2];
731         return oraclize_query(timestamp, datasource, dynargs);
732     }
733     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
734         string[] memory dynargs = new string[](3);
735         dynargs[0] = args[0];
736         dynargs[1] = args[1];
737         dynargs[2] = args[2];
738         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
739     }
740     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
741         string[] memory dynargs = new string[](3);
742         dynargs[0] = args[0];
743         dynargs[1] = args[1];
744         dynargs[2] = args[2];
745         return oraclize_query(datasource, dynargs, gaslimit);
746     }
747 
748     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
749         string[] memory dynargs = new string[](4);
750         dynargs[0] = args[0];
751         dynargs[1] = args[1];
752         dynargs[2] = args[2];
753         dynargs[3] = args[3];
754         return oraclize_query(datasource, dynargs);
755     }
756     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
757         string[] memory dynargs = new string[](4);
758         dynargs[0] = args[0];
759         dynargs[1] = args[1];
760         dynargs[2] = args[2];
761         dynargs[3] = args[3];
762         return oraclize_query(timestamp, datasource, dynargs);
763     }
764     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
765         string[] memory dynargs = new string[](4);
766         dynargs[0] = args[0];
767         dynargs[1] = args[1];
768         dynargs[2] = args[2];
769         dynargs[3] = args[3];
770         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
771     }
772     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
773         string[] memory dynargs = new string[](4);
774         dynargs[0] = args[0];
775         dynargs[1] = args[1];
776         dynargs[2] = args[2];
777         dynargs[3] = args[3];
778         return oraclize_query(datasource, dynargs, gaslimit);
779     }
780     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
781         string[] memory dynargs = new string[](5);
782         dynargs[0] = args[0];
783         dynargs[1] = args[1];
784         dynargs[2] = args[2];
785         dynargs[3] = args[3];
786         dynargs[4] = args[4];
787         return oraclize_query(datasource, dynargs);
788     }
789     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
790         string[] memory dynargs = new string[](5);
791         dynargs[0] = args[0];
792         dynargs[1] = args[1];
793         dynargs[2] = args[2];
794         dynargs[3] = args[3];
795         dynargs[4] = args[4];
796         return oraclize_query(timestamp, datasource, dynargs);
797     }
798     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
799         string[] memory dynargs = new string[](5);
800         dynargs[0] = args[0];
801         dynargs[1] = args[1];
802         dynargs[2] = args[2];
803         dynargs[3] = args[3];
804         dynargs[4] = args[4];
805         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
806     }
807     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
808         string[] memory dynargs = new string[](5);
809         dynargs[0] = args[0];
810         dynargs[1] = args[1];
811         dynargs[2] = args[2];
812         dynargs[3] = args[3];
813         dynargs[4] = args[4];
814         return oraclize_query(datasource, dynargs, gaslimit);
815     }
816     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
817         uint price = oraclize.getPrice(datasource);
818         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
819         bytes memory args = ba2cbor(argN);
820         return oraclize.queryN.value(price)(0, datasource, args);
821     }
822     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
823         uint price = oraclize.getPrice(datasource);
824         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
825         bytes memory args = ba2cbor(argN);
826         return oraclize.queryN.value(price)(timestamp, datasource, args);
827     }
828     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
829         uint price = oraclize.getPrice(datasource, gaslimit);
830         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
831         bytes memory args = ba2cbor(argN);
832         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
833     }
834     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
835         uint price = oraclize.getPrice(datasource, gaslimit);
836         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
837         bytes memory args = ba2cbor(argN);
838         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
839     }
840     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
841         bytes[] memory dynargs = new bytes[](1);
842         dynargs[0] = args[0];
843         return oraclize_query(datasource, dynargs);
844     }
845     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
846         bytes[] memory dynargs = new bytes[](1);
847         dynargs[0] = args[0];
848         return oraclize_query(timestamp, datasource, dynargs);
849     }
850     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
851         bytes[] memory dynargs = new bytes[](1);
852         dynargs[0] = args[0];
853         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
854     }
855     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
856         bytes[] memory dynargs = new bytes[](1);
857         dynargs[0] = args[0];
858         return oraclize_query(datasource, dynargs, gaslimit);
859     }
860 
861     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
862         bytes[] memory dynargs = new bytes[](2);
863         dynargs[0] = args[0];
864         dynargs[1] = args[1];
865         return oraclize_query(datasource, dynargs);
866     }
867     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
868         bytes[] memory dynargs = new bytes[](2);
869         dynargs[0] = args[0];
870         dynargs[1] = args[1];
871         return oraclize_query(timestamp, datasource, dynargs);
872     }
873     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
874         bytes[] memory dynargs = new bytes[](2);
875         dynargs[0] = args[0];
876         dynargs[1] = args[1];
877         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
878     }
879     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
880         bytes[] memory dynargs = new bytes[](2);
881         dynargs[0] = args[0];
882         dynargs[1] = args[1];
883         return oraclize_query(datasource, dynargs, gaslimit);
884     }
885     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
886         bytes[] memory dynargs = new bytes[](3);
887         dynargs[0] = args[0];
888         dynargs[1] = args[1];
889         dynargs[2] = args[2];
890         return oraclize_query(datasource, dynargs);
891     }
892     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
893         bytes[] memory dynargs = new bytes[](3);
894         dynargs[0] = args[0];
895         dynargs[1] = args[1];
896         dynargs[2] = args[2];
897         return oraclize_query(timestamp, datasource, dynargs);
898     }
899     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
900         bytes[] memory dynargs = new bytes[](3);
901         dynargs[0] = args[0];
902         dynargs[1] = args[1];
903         dynargs[2] = args[2];
904         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
905     }
906     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
907         bytes[] memory dynargs = new bytes[](3);
908         dynargs[0] = args[0];
909         dynargs[1] = args[1];
910         dynargs[2] = args[2];
911         return oraclize_query(datasource, dynargs, gaslimit);
912     }
913 
914     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
915         bytes[] memory dynargs = new bytes[](4);
916         dynargs[0] = args[0];
917         dynargs[1] = args[1];
918         dynargs[2] = args[2];
919         dynargs[3] = args[3];
920         return oraclize_query(datasource, dynargs);
921     }
922     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
923         bytes[] memory dynargs = new bytes[](4);
924         dynargs[0] = args[0];
925         dynargs[1] = args[1];
926         dynargs[2] = args[2];
927         dynargs[3] = args[3];
928         return oraclize_query(timestamp, datasource, dynargs);
929     }
930     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
931         bytes[] memory dynargs = new bytes[](4);
932         dynargs[0] = args[0];
933         dynargs[1] = args[1];
934         dynargs[2] = args[2];
935         dynargs[3] = args[3];
936         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
937     }
938     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
939         bytes[] memory dynargs = new bytes[](4);
940         dynargs[0] = args[0];
941         dynargs[1] = args[1];
942         dynargs[2] = args[2];
943         dynargs[3] = args[3];
944         return oraclize_query(datasource, dynargs, gaslimit);
945     }
946     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
947         bytes[] memory dynargs = new bytes[](5);
948         dynargs[0] = args[0];
949         dynargs[1] = args[1];
950         dynargs[2] = args[2];
951         dynargs[3] = args[3];
952         dynargs[4] = args[4];
953         return oraclize_query(datasource, dynargs);
954     }
955     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
956         bytes[] memory dynargs = new bytes[](5);
957         dynargs[0] = args[0];
958         dynargs[1] = args[1];
959         dynargs[2] = args[2];
960         dynargs[3] = args[3];
961         dynargs[4] = args[4];
962         return oraclize_query(timestamp, datasource, dynargs);
963     }
964     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
965         bytes[] memory dynargs = new bytes[](5);
966         dynargs[0] = args[0];
967         dynargs[1] = args[1];
968         dynargs[2] = args[2];
969         dynargs[3] = args[3];
970         dynargs[4] = args[4];
971         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
972     }
973     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
974         bytes[] memory dynargs = new bytes[](5);
975         dynargs[0] = args[0];
976         dynargs[1] = args[1];
977         dynargs[2] = args[2];
978         dynargs[3] = args[3];
979         dynargs[4] = args[4];
980         return oraclize_query(datasource, dynargs, gaslimit);
981     }
982 
983     function oraclize_cbAddress() oraclizeAPI internal returns (address){
984         return oraclize.cbAddress();
985     }
986     function oraclize_setProof(byte proofP) oraclizeAPI internal {
987         return oraclize.setProofType(proofP);
988     }
989     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
990         return oraclize.setCustomGasPrice(gasPrice);
991     }
992     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
993         return oraclize.setConfig(config);
994     }
995 
996     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
997         return oraclize.randomDS_getSessionPubKeyHash();
998     }
999 
1000     function getCodeSize(address _addr) constant internal returns(uint _size) {
1001         assembly {
1002         _size := extcodesize(_addr)
1003         }
1004     }
1005 
1006     function parseAddr(string _a) internal returns (address){
1007         bytes memory tmp = bytes(_a);
1008         uint160 iaddr = 0;
1009         uint160 b1;
1010         uint160 b2;
1011         for (uint i=2; i<2+2*20; i+=2){
1012             iaddr *= 256;
1013             b1 = uint160(tmp[i]);
1014             b2 = uint160(tmp[i+1]);
1015             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1016             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1017             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1018             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1019             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1020             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1021             iaddr += (b1*16+b2);
1022         }
1023         return address(iaddr);
1024     }
1025 
1026     function strCompare(string _a, string _b) internal returns (int) {
1027         bytes memory a = bytes(_a);
1028         bytes memory b = bytes(_b);
1029         uint minLength = a.length;
1030         if (b.length < minLength) minLength = b.length;
1031         for (uint i = 0; i < minLength; i ++)
1032         if (a[i] < b[i])
1033         return -1;
1034         else if (a[i] > b[i])
1035         return 1;
1036         if (a.length < b.length)
1037         return -1;
1038         else if (a.length > b.length)
1039         return 1;
1040         else
1041         return 0;
1042     }
1043 
1044     function indexOf(string _haystack, string _needle) internal returns (int) {
1045         bytes memory h = bytes(_haystack);
1046         bytes memory n = bytes(_needle);
1047         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1048         return -1;
1049         else if(h.length > (2**128 -1))
1050         return -1;
1051         else
1052         {
1053             uint subindex = 0;
1054             for (uint i = 0; i < h.length; i ++)
1055             {
1056                 if (h[i] == n[0])
1057                 {
1058                     subindex = 1;
1059                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1060                     {
1061                         subindex++;
1062                     }
1063                     if(subindex == n.length)
1064                     return int(i);
1065                 }
1066             }
1067             return -1;
1068         }
1069     }
1070 
1071     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1072         bytes memory _ba = bytes(_a);
1073         bytes memory _bb = bytes(_b);
1074         bytes memory _bc = bytes(_c);
1075         bytes memory _bd = bytes(_d);
1076         bytes memory _be = bytes(_e);
1077         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1078         bytes memory babcde = bytes(abcde);
1079         uint k = 0;
1080         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1081         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1082         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1083         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1084         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1085         return string(babcde);
1086     }
1087 
1088     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1089         return strConcat(_a, _b, _c, _d, "");
1090     }
1091 
1092     function strConcat(string _a, string _b, string _c) internal returns (string) {
1093         return strConcat(_a, _b, _c, "", "");
1094     }
1095 
1096     function strConcat(string _a, string _b) internal returns (string) {
1097         return strConcat(_a, _b, "", "", "");
1098     }
1099 
1100     // parseInt
1101     function parseInt(string _a) internal returns (uint) {
1102         return parseInt(_a, 0);
1103     }
1104 
1105     // parseInt(parseFloat*10^_b)
1106     function parseInt(string _a, uint _b) internal returns (uint) {
1107         bytes memory bresult = bytes(_a);
1108         uint mint = 0;
1109         bool decimals = false;
1110         for (uint i=0; i<bresult.length; i++){
1111             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1112                 if (decimals){
1113                     if (_b == 0) break;
1114                     else _b--;
1115                 }
1116                 mint *= 10;
1117                 mint += uint(bresult[i]) - 48;
1118             } else if (bresult[i] == 46) decimals = true;
1119         }
1120         if (_b > 0) mint *= 10**_b;
1121         return mint;
1122     }
1123 
1124     function uint2str(uint i) internal returns (string){
1125         if (i == 0) return "0";
1126         uint j = i;
1127         uint len;
1128         while (j != 0){
1129             len++;
1130             j /= 10;
1131         }
1132         bytes memory bstr = new bytes(len);
1133         uint k = len - 1;
1134         while (i != 0){
1135             bstr[k--] = byte(48 + i % 10);
1136             i /= 10;
1137         }
1138         return string(bstr);
1139     }
1140 
1141     function stra2cbor(string[] arr) internal returns (bytes) {
1142         uint arrlen = arr.length;
1143 
1144         // get correct cbor output length
1145         uint outputlen = 0;
1146         bytes[] memory elemArray = new bytes[](arrlen);
1147         for (uint i = 0; i < arrlen; i++) {
1148             elemArray[i] = (bytes(arr[i]));
1149             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1150         }
1151         uint ctr = 0;
1152         uint cborlen = arrlen + 0x80;
1153         outputlen += byte(cborlen).length;
1154         bytes memory res = new bytes(outputlen);
1155 
1156         while (byte(cborlen).length > ctr) {
1157             res[ctr] = byte(cborlen)[ctr];
1158             ctr++;
1159         }
1160         for (i = 0; i < arrlen; i++) {
1161             res[ctr] = 0x5F;
1162             ctr++;
1163             for (uint x = 0; x < elemArray[i].length; x++) {
1164                 // if there's a bug with larger strings, this may be the culprit
1165                 if (x % 23 == 0) {
1166                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1167                     elemcborlen += 0x40;
1168                     uint lctr = ctr;
1169                     while (byte(elemcborlen).length > ctr - lctr) {
1170                         res[ctr] = byte(elemcborlen)[ctr - lctr];
1171                         ctr++;
1172                     }
1173                 }
1174                 res[ctr] = elemArray[i][x];
1175                 ctr++;
1176             }
1177             res[ctr] = 0xFF;
1178             ctr++;
1179         }
1180         return res;
1181     }
1182 
1183     function ba2cbor(bytes[] arr) internal returns (bytes) {
1184         uint arrlen = arr.length;
1185 
1186         // get correct cbor output length
1187         uint outputlen = 0;
1188         bytes[] memory elemArray = new bytes[](arrlen);
1189         for (uint i = 0; i < arrlen; i++) {
1190             elemArray[i] = (bytes(arr[i]));
1191             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1192         }
1193         uint ctr = 0;
1194         uint cborlen = arrlen + 0x80;
1195         outputlen += byte(cborlen).length;
1196         bytes memory res = new bytes(outputlen);
1197 
1198         while (byte(cborlen).length > ctr) {
1199             res[ctr] = byte(cborlen)[ctr];
1200             ctr++;
1201         }
1202         for (i = 0; i < arrlen; i++) {
1203             res[ctr] = 0x5F;
1204             ctr++;
1205             for (uint x = 0; x < elemArray[i].length; x++) {
1206                 // if there's a bug with larger strings, this may be the culprit
1207                 if (x % 23 == 0) {
1208                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1209                     elemcborlen += 0x40;
1210                     uint lctr = ctr;
1211                     while (byte(elemcborlen).length > ctr - lctr) {
1212                         res[ctr] = byte(elemcborlen)[ctr - lctr];
1213                         ctr++;
1214                     }
1215                 }
1216                 res[ctr] = elemArray[i][x];
1217                 ctr++;
1218             }
1219             res[ctr] = 0xFF;
1220             ctr++;
1221         }
1222         return res;
1223     }
1224 
1225 
1226     string oraclize_network_name;
1227     function oraclize_setNetworkName(string _network_name) internal {
1228         oraclize_network_name = _network_name;
1229     }
1230 
1231     function oraclize_getNetworkName() internal returns (string) {
1232         return oraclize_network_name;
1233     }
1234 
1235     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1236 //        if ((_nbytes == 0)||(_nbytes > 32)) throw;
1237         require(_nbytes != 0 && _nbytes < 32);
1238         bytes memory nbytes = new bytes(1);
1239         nbytes[0] = byte(_nbytes);
1240         bytes memory unonce = new bytes(32);
1241         bytes memory sessionKeyHash = new bytes(32);
1242         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1243         assembly {
1244         mstore(unonce, 0x20)
1245         mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1246         mstore(sessionKeyHash, 0x20)
1247         mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1248         }
1249         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
1250         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
1251         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
1252         return queryId;
1253     }
1254 
1255     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1256         oraclize_randomDS_args[queryId] = commitment;
1257     }
1258 
1259     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1260     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1261 
1262     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1263         bool sigok;
1264         address signer;
1265 
1266         bytes32 sigr;
1267         bytes32 sigs;
1268 
1269         bytes memory sigr_ = new bytes(32);
1270         uint offset = 4+(uint(dersig[3]) - 0x20);
1271         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1272         bytes memory sigs_ = new bytes(32);
1273         offset += 32 + 2;
1274         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1275 
1276         assembly {
1277         sigr := mload(add(sigr_, 32))
1278         sigs := mload(add(sigs_, 32))
1279         }
1280 
1281 
1282         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1283         if (address(sha3(pubkey)) == signer) return true;
1284         else {
1285             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1286             return (address(sha3(pubkey)) == signer);
1287         }
1288     }
1289 
1290     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1291         bool sigok;
1292 
1293         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1294         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1295         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1296 
1297         bytes memory appkey1_pubkey = new bytes(64);
1298         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1299 
1300         bytes memory tosign2 = new bytes(1+65+32);
1301 //        tosign2[0] = 1; //role
1302         tosign2[0] = 0x1; //role
1303         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1304         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1305         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1306         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1307 
1308         if (sigok == false) return false;
1309 
1310 
1311         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1312         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1313 
1314         bytes memory tosign3 = new bytes(1+65);
1315         tosign3[0] = 0xFE;
1316         copyBytes(proof, 3, 65, tosign3, 1);
1317 
1318         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1319         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1320 
1321         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1322 
1323         return sigok;
1324     }
1325 
1326     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1327         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1328 //        if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1329         require(_proof[0] == "L" && _proof[1] == "P" && _proof[2] == 1);
1330 
1331         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1332 //        if (proofVerified == false) throw;
1333         require(proofVerified == true);
1334 
1335         _;
1336     }
1337 
1338     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1339         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1340         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1341 
1342         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1343         if (proofVerified == false) return 2;
1344 
1345         return 0;
1346     }
1347 
1348     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
1349         bool match_ = true;
1350 
1351 //        for (var i=0; i<prefix.length; i++){
1352         for (var i=uint8(0); i<prefix.length; i++){
1353             if (content[i] != prefix[i]) match_ = false;
1354         }
1355 
1356         return match_;
1357     }
1358 
1359     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1360         bool checkok;
1361 
1362 
1363         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1364         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1365         bytes memory keyhash = new bytes(32);
1366         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1367         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
1368         if (checkok == false) return false;
1369 
1370         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1371         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1372 
1373 
1374         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1375         checkok = matchBytes32Prefix(sha256(sig1), result);
1376         if (checkok == false) return false;
1377 
1378 
1379         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1380         // This is to verify that the computed args match with the ones specified in the query.
1381         bytes memory commitmentSlice1 = new bytes(8+1+32);
1382         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1383 
1384         bytes memory sessionPubkey = new bytes(64);
1385         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1386         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1387 
1388         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1389         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1390             delete oraclize_randomDS_args[queryId];
1391         } else return false;
1392 
1393 
1394         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1395         bytes memory tosign1 = new bytes(32+8+1+32);
1396         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1397         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
1398         if (checkok == false) return false;
1399 
1400         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1401         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1402             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1403         }
1404 
1405         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1406     }
1407 
1408 
1409     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1410     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1411         uint minLength = length + toOffset;
1412 
1413 //        if (to.length < minLength) {
1414             // Buffer too small
1415 //            throw; // Should be a better way?
1416 //        }
1417         require(to.length > minLength);
1418 
1419         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1420         uint i = 32 + fromOffset;
1421         uint j = 32 + toOffset;
1422 
1423         while (i < (32 + fromOffset + length)) {
1424             assembly {
1425             let tmp := mload(add(from, i))
1426             mstore(add(to, j), tmp)
1427             }
1428             i += 32;
1429             j += 32;
1430         }
1431 
1432         return to;
1433     }
1434 
1435     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1436     // Duplicate Solidity's ecrecover, but catching the CALL return value
1437     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1438         // We do our own memory management here. Solidity uses memory offset
1439         // 0x40 to store the current end of memory. We write past it (as
1440         // writes are memory extensions), but don't update the offset so
1441         // Solidity will reuse it. The memory used here is only needed for
1442         // this context.
1443 
1444         // FIXME: inline assembly can't access return values
1445         bool ret;
1446         address addr;
1447 
1448         assembly {
1449         let size := mload(0x40)
1450         mstore(size, hash)
1451         mstore(add(size, 32), v)
1452         mstore(add(size, 64), r)
1453         mstore(add(size, 96), s)
1454 
1455         // NOTE: we can reuse the request memory because we deal with
1456         //       the return code
1457         ret := call(3000, 1, 0, size, 128, size, 32)
1458         addr := mload(size)
1459         }
1460 
1461         return (ret, addr);
1462     }
1463 
1464     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1465     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1466         bytes32 r;
1467         bytes32 s;
1468         uint8 v;
1469 
1470         if (sig.length != 65)
1471         return (false, 0);
1472 
1473         // The signature format is a compact form of:
1474         //   {bytes32 r}{bytes32 s}{uint8 v}
1475         // Compact means, uint8 is not padded to 32 bytes.
1476         assembly {
1477         r := mload(add(sig, 32))
1478         s := mload(add(sig, 64))
1479 
1480         // Here we are loading the last 32 bytes. We exploit the fact that
1481         // 'mload' will pad with zeroes if we overread.
1482         // There is no 'mload8' to do this, but that would be nicer.
1483         v := byte(0, mload(add(sig, 96)))
1484 
1485         // Alternative solution:
1486         // 'byte' is not working due to the Solidity parser, so lets
1487         // use the second best option, 'and'
1488         // v := and(mload(add(sig, 65)), 255)
1489     }
1490 
1491 // albeit non-transactional signatures are not specified by the YP, one would expect it
1492 // to match the YP range of [27, 28]
1493 //
1494 // geth uses [0, 1] and some clients have followed. This might change, see:
1495 //  https://github.com/ethereum/go-ethereum/issues/2053
1496 if (v < 27)
1497 v += 27;
1498 
1499 if (v != 27 && v != 28)
1500 return (false, 0);
1501 
1502 return safer_ecrecover(hash, v, r, s);
1503 }
1504 
1505 }
1506 // </ORACLIZE_API>
1507 /* solhint-enable */
1508 
1509 
1510 contract NodePhases is usingOraclize, Ownable {
1511 
1512     using SafeMath for uint256;
1513 
1514     Node public node;
1515 
1516     NodeAllocation public nodeAllocation;
1517 
1518     Phase[] public phases;
1519 
1520     uint256 public constant HOUR = 3600;
1521 
1522     uint256 public constant DAY = 86400;
1523 
1524     uint256 public collectedEthers;
1525 
1526     uint256 public soldTokens;
1527 
1528     uint256 public priceUpdateAt;
1529 
1530     uint256 public investorsCount;
1531 
1532     uint256 public lastDistributedAmount;
1533 
1534     mapping (address => uint256) public icoEtherBalances;
1535 
1536     mapping (address => bool) private investors;
1537 
1538     event NewOraclizeQuery(string description);
1539 
1540     event NewNodePriceTicker(string price);
1541 
1542     event Refund(address holder, uint256 ethers, uint256 tokens);
1543 
1544     struct Phase {
1545         uint256 price;
1546         uint256 minInvest;
1547         uint256 softCap;
1548         uint256 hardCap;
1549         uint256 since;
1550         uint256 till;
1551         bool isSucceed;
1552     }
1553 
1554     function NodePhases(
1555         address _node,
1556         uint256 _minInvest,
1557         uint256 _tokenPrice, //0.0032835596 ethers
1558         uint256 _preIcoMaxCap,
1559         uint256 _preIcoSince,
1560         uint256 _preIcoTill,
1561         uint256 _icoMinCap,
1562         uint256 _icoMaxCap,
1563         uint256 _icoSince,
1564         uint256 _icoTill
1565     ) {
1566         require(address(_node) != address(0));
1567         node = Node(address(_node));
1568 
1569         require((_preIcoSince < _preIcoTill) && (_icoSince < _icoTill) && (_preIcoTill <= _icoSince));
1570 
1571         require((_preIcoMaxCap < _icoMaxCap) && (_icoMaxCap < node.maxSupply()));
1572 
1573         phases.push(Phase(_tokenPrice, _minInvest, 0, _preIcoMaxCap, _preIcoSince, _preIcoTill, false));
1574         phases.push(Phase(_tokenPrice, _minInvest, _icoMinCap, _icoMaxCap, _icoSince, _icoTill, false));
1575 
1576         priceUpdateAt = now;
1577 
1578         oraclize_setNetwork(networkID_auto);
1579         oraclize = OraclizeI(OAR.getAddress());
1580     }
1581 
1582     function() public payable {
1583         require(buy(msg.sender, msg.value) == true);
1584     }
1585 
1586     function __callback(bytes32, string _result, bytes) public {
1587         require(msg.sender == oraclize_cbAddress());
1588 
1589         uint256 price = uint256(10 ** 23).div(parseInt(_result, 5));
1590 
1591         require(price > 0);
1592 
1593         for (uint i = 0; i < phases.length; i++) {
1594             Phase storage phase = phases[i];
1595             phase.price = price;
1596         }
1597 
1598         NewNodePriceTicker(_result);
1599     }
1600 
1601     function setCurrentRate(uint256 _rate) public onlyOwner {
1602         require(_rate > 0);
1603         for (uint i = 0; i < phases.length; i++) {
1604             Phase storage phase = phases[i];
1605             phase.price = _rate;
1606         }
1607         priceUpdateAt = now;
1608     }
1609 
1610     function setNode(address _node) public onlyOwner {
1611         require(address(_node) != address(0));
1612         node = Node(_node);
1613     }
1614 
1615     function setNodeAllocation(address _nodeAllocation) public onlyOwner {
1616         require(address(_nodeAllocation) != address(0));
1617         nodeAllocation = NodeAllocation(_nodeAllocation);
1618     }
1619 
1620     function setPhase(
1621         uint8 _phaseId,
1622         uint256 _since,
1623         uint256 _till,
1624         uint256 _price,
1625         uint256 _softCap,
1626         uint256 _hardCap
1627     ) public onlyOwner returns (bool) {
1628         require((phases.length > _phaseId) && (_price > 0));
1629         require((_till > _since) && (_since > 0));
1630         require((node.maxSupply() > _hardCap) && (_hardCap > _softCap) && (_softCap >= 0));
1631 
1632         Phase storage phase = phases[_phaseId];
1633 
1634         if (phase.isSucceed == true) {
1635             return false;
1636         }
1637         phase.since = _since;
1638         phase.till = _till;
1639         phase.price = _price;
1640         phase.softCap = _softCap;
1641         phase.hardCap = _hardCap;
1642 
1643         return true;
1644     }
1645 
1646     function sendToAddress(address _address, uint256 _tokens) public onlyOwner returns (bool) {
1647         return sendToAddressWithTime(_address, _tokens, now);
1648     }
1649 
1650     function sendToAddressWithTime(
1651         address _address,
1652         uint256 _tokens,
1653         uint256 _time
1654     ) public onlyOwner returns (bool) {
1655         if (_tokens == 0 || address(_address) == address(0) || _time == 0) {
1656             return false;
1657         }
1658 
1659         return sendToAddressWithBonus(_address, _tokens, getBonusAmount(_tokens, _time));
1660     }
1661 
1662     function sendToAddressWithBonus(
1663         address _address,
1664         uint256 _tokens,
1665         uint256 _bonus
1666     ) public onlyOwner returns (bool) {
1667         if (_tokens == 0 || address(_address) == address(0) || _bonus == 0) {
1668             return false;
1669         }
1670 
1671         uint256 totalAmount = _tokens.add(_bonus);
1672 
1673         if (getTokens().add(totalAmount) > node.maxSupply()) {
1674             return false;
1675         }
1676 
1677         require(totalAmount == node.mint(_address, totalAmount));
1678 
1679         onSuccessfulBuy(_address, 0, totalAmount, 0);
1680 
1681         return true;
1682     }
1683 
1684     function getTokens() public constant returns (uint256) {
1685         return node.totalSupply();
1686     }
1687 
1688     function getSoldToken() public constant returns (uint256) {
1689         return soldTokens;
1690     }
1691 
1692     function getAllInvestors() public constant returns (uint256) {
1693         return investorsCount;
1694     }
1695 
1696     function getBalanceContract() public constant returns (uint256) {
1697         return collectedEthers;
1698     }
1699 
1700     function isSucceed(uint8 phaseId) public returns (bool) {
1701         if (phases.length <= phaseId) {
1702             return false;
1703         }
1704         Phase storage phase = phases[phaseId];
1705         if (phase.isSucceed == true) {
1706             return true;
1707         }
1708         if (phase.till > now) {
1709             return false;
1710         }
1711         if (phase.softCap != 0 && phase.softCap > getTokens()) {
1712             return false;
1713         }
1714         phase.isSucceed = true;
1715         if (phaseId == 1) {
1716             allocateBounty();
1717         }
1718 
1719         return true;
1720     }
1721 
1722     function refund() public returns (bool) {
1723         Phase storage icoPhase = phases[1];
1724         if (icoPhase.till > now) {
1725             return false;
1726         }
1727         if (icoPhase.softCap < getTokens()) {
1728             return false;
1729         }
1730         if (icoEtherBalances[msg.sender] == 0) {
1731             return false;
1732         }
1733 
1734         uint256 refundAmount = icoEtherBalances[msg.sender];
1735         uint256 tokens = node.buyBack(msg.sender);
1736         icoEtherBalances[msg.sender] = 0;
1737         msg.sender.transfer(refundAmount);
1738         Refund(msg.sender, refundAmount, tokens);
1739 
1740         return true;
1741     }
1742 
1743     function isFinished(uint8 phaseId) public constant returns (bool) {
1744         if (phases.length <= phaseId) {
1745             return false;
1746         }
1747         Phase storage phase = phases[phaseId];
1748 
1749         return (phase.isSucceed || now > phase.till);
1750     }
1751 
1752     function getCurrentPhase(uint256 _time) public constant returns (uint8) {
1753         if (_time == 0) {
1754             return uint8(phases.length);
1755         }
1756         for (uint8 i = 0; i < phases.length; i++) {
1757             Phase storage phase = phases[i];
1758             if (phase.since > _time) {
1759                 continue;
1760             }
1761 
1762             if (phase.till < _time) {
1763                 continue;
1764             }
1765 
1766             return i;
1767         }
1768 
1769         return uint8(phases.length);
1770     }
1771 
1772     function getICOBonusAmount(uint256 _amount, uint256 _time) public returns (uint256) {
1773         Phase storage ico = phases[1];
1774         if (_time.sub(ico.since) < 11 * DAY) {// 11d since ico => reward 30%;
1775             return _amount.mul(30).div(100);
1776         }
1777         if (_time.sub(ico.since) < 21 * DAY) {// 21d since ico => reward 20%
1778             return _amount.mul(20).div(100);
1779         }
1780         if (_time.sub(ico.since) < 31 * DAY) {// 31d since ico => reward 15%
1781             return _amount.mul(15).div(100);
1782         }
1783         if (_time.sub(ico.since) < 41 * DAY) {// 41d since ico => reward 10%
1784             return _amount.mul(10).div(100);
1785         }
1786 
1787         return 0;
1788     }
1789 
1790     function update() internal {
1791         if (oraclize_getPrice("URL") > this.balance) {
1792             NewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1793         } else {
1794             NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1795             oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1796         }
1797     }
1798 
1799     function buy(address _address, uint256 _value) internal returns (bool) {
1800         if (_value == 0) {
1801             return false;
1802         }
1803 
1804         uint8 currentPhase = getCurrentPhase(now);
1805 
1806         if (phases.length <= currentPhase) {
1807             return false;
1808         }
1809 
1810         if (priceUpdateAt.add(HOUR) < now) {
1811             update();
1812             priceUpdateAt = now;
1813         }
1814 
1815         uint256 amount = getTokensAmount(_value, currentPhase);
1816 
1817         if (amount == 0) {
1818             return false;
1819         }
1820 
1821         amount = amount.add(getBonusAmount(amount, now));
1822 
1823         require(amount == node.mint(_address, amount));
1824 
1825         onSuccessfulBuy(_address, _value, amount, currentPhase);
1826         allocate(currentPhase);
1827 
1828         return true;
1829     }
1830 
1831     function onSuccessfulBuy(address _address, uint256 _value, uint256 _amount, uint8 _currentPhase) internal {
1832         collectedEthers = collectedEthers.add(_value);
1833         soldTokens = soldTokens.add(_amount);
1834         increaseInvestorsCount(_address);
1835 
1836         if (_currentPhase == 1) {
1837             icoEtherBalances[_address] = icoEtherBalances[_address].add(_value);
1838         }
1839     }
1840 
1841     function increaseInvestorsCount(address _address) internal {
1842         if (address(_address) != address(0) && investors[_address] == false) {
1843             investors[_address] = true;
1844             investorsCount = investorsCount.add(1);
1845         }
1846     }
1847 
1848     function getTokensAmount(uint256 _value, uint8 _currentPhase) internal returns (uint256) {
1849         if (_value == 0 || phases.length <= _currentPhase) {
1850             return 0;
1851         }
1852 
1853         Phase storage phase = phases[_currentPhase];
1854 
1855         uint256 amount = _value.mul(uint256(10) ** node.decimals()).div(phase.price);
1856 
1857         if (amount < phase.minInvest) {
1858             return 0;
1859         }
1860 
1861         if (getTokens().add(amount) > phase.hardCap) {
1862             return 0;
1863         }
1864 
1865         return amount;
1866     }
1867 
1868     function getBonusAmount(uint256 _amount, uint256 _time) internal returns (uint256) {
1869         uint8 currentPhase = getCurrentPhase(_time);
1870         if (_amount == 0 || _time == 0 || phases.length <= currentPhase) {
1871             return 0;
1872         }
1873 
1874         if (currentPhase == 0) {
1875             return _amount.mul(50).div(100);
1876         }
1877 
1878         if (currentPhase == 1) {
1879             return getICOBonusAmount(_amount, _time);
1880         }
1881 
1882         return 0;
1883     }
1884 
1885     function allocateICOEthers() internal returns (bool) {
1886         uint8 length = nodeAllocation.getICOLength();
1887         require(length > 0);
1888 
1889         uint256 totalAmount = this.balance;
1890         for (uint8 i = 0; i < length; i++) {
1891             uint256 amount = totalAmount.mul(nodeAllocation.getICOPercentage(i)).div(100);
1892             if ((i + 1) == length) {
1893                 amount = this.balance;
1894             }
1895             if (amount > 0) {
1896                 nodeAllocation.getICOAddress(i).transfer(amount);
1897             }
1898         }
1899 
1900         return true;
1901     }
1902 
1903     function allocatePreICOEthers() internal returns (bool) {
1904         uint8 length = nodeAllocation.getPreICOLength();
1905         require(length > 0);
1906 
1907         uint256 totalAmount = this.balance;
1908         for (uint8 i = 0; i < length; i++) {
1909             uint256 amount = totalAmount.mul(nodeAllocation.getPreICOPercentage(i)).div(100);
1910             if ((i + 1) == length) {
1911                 amount = this.balance;
1912             }
1913             if (amount > 0) {
1914                 nodeAllocation.getPreICOAddress(i).transfer(amount);
1915             }
1916         }
1917 
1918         return true;
1919     }
1920 
1921     function allocate(uint8 _currentPhase) internal {
1922         if (_currentPhase == 0) {
1923             allocatePreICOEthers();
1924         }
1925         if (_currentPhase == 1) {
1926             uint8 length = nodeAllocation.getThresholdsLength();
1927             require(uint8(length) > 0);
1928 
1929             for (uint8 j = 0; j < length; j++) {
1930                 uint256 threshold = nodeAllocation.getThreshold(j);
1931 
1932                 if ((threshold > lastDistributedAmount) && (soldTokens >= threshold)) {
1933                     allocateICOEthers();
1934                     lastDistributedAmount = threshold;
1935                 }
1936             }
1937         }
1938     }
1939 
1940     function allocateBounty() internal {
1941         if (isFinished(1)) {
1942             allocateICOEthers();
1943             uint256 amount = node.maxSupply().mul(2).div(100);
1944             uint256 mintedAmount = node.mint(nodeAllocation.bountyAddress(), amount);
1945             require(mintedAmount == amount);
1946         }
1947     }
1948 
1949 }