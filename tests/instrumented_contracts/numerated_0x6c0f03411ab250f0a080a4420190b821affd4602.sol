1 pragma solidity ^0.4.20;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Gizer Items - ERC721(ish) contract
6 //
7 // ----------------------------------------------------------------------------
8 
9 
10 // ----------------------------------------------------------------------------
11 //
12 // SafeMath
13 //
14 // ----------------------------------------------------------------------------
15 
16 library SafeMath {
17 
18   function mul(uint a, uint b) internal pure returns (uint c) {
19     c = a * b;
20     require( a == 0 || c / a == b );
21   }
22 
23   function add(uint a, uint b) internal pure returns (uint c) {
24     c = a + b;
25     require( c >= a );
26   }
27 
28   function sub(uint a, uint b) internal pure returns (uint c) {
29     require( b <= a );
30     c = a - b;
31   }
32 
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 //
38 // Owned
39 //
40 // ----------------------------------------------------------------------------
41 
42 contract Owned {
43 
44   address public owner;
45   address public newOwner;
46 
47   mapping(address => bool) public isAdmin;
48 
49   // Events ---------------------------
50 
51   event OwnershipTransferProposed(address indexed _from, address indexed _to);
52   event OwnershipTransferred(address indexed _from, address indexed _to);
53   event AdminChange(address indexed _admin, bool _status);
54 
55   // Modifiers ------------------------
56 
57   modifier onlyOwner { require( msg.sender == owner ); _; }
58   modifier onlyAdmin { require( isAdmin[msg.sender] ); _; }
59 
60   // Functions ------------------------
61 
62   function Owned() public {
63     owner = msg.sender;
64     isAdmin[owner] = true;
65   }
66 
67   function transferOwnership(address _newOwner) public onlyOwner {
68     require( _newOwner != address(0x0) );
69     OwnershipTransferProposed(owner, _newOwner);
70     newOwner = _newOwner;
71   }
72 
73   function acceptOwnership() public {
74     require(msg.sender == newOwner);
75     OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78   
79   function addAdmin(address _a) public onlyOwner {
80     require( isAdmin[_a] == false );
81     isAdmin[_a] = true;
82     AdminChange(_a, true);
83   }
84 
85   function removeAdmin(address _a) public onlyOwner {
86     require( isAdmin[_a] == true );
87     isAdmin[_a] = false;
88     AdminChange(_a, false);
89   }
90   
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 //
96 // ERC721(ish) Token Interface 
97 //
98 // ----------------------------------------------------------------------------
99 
100 
101 interface ERC721Interface /* is ERC165 */ {
102 
103     event Transfer(address indexed _from, address indexed _to, uint256 _deedId);
104     event Approval(address indexed _owner, address indexed _approved, uint256 _deedId);
105     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
106 
107     function balanceOf(address _owner) external view returns (uint256 _balance);
108     function ownerOf(uint256 _deedId) external view returns (address _owner);
109     function transfer(address _to, uint256 _deedId) external;                    // removed payable
110     function transferFrom(address _from, address _to, uint256 _deedId) external; // removed payable
111     function approve(address _approved, uint256 _deedId) external;               // removed payable
112     // function setApprovalForAll(address _operateor, boolean _approved);        // removed payable
113     // function supportsInterface(bytes4 interfaceID) external view returns (bool);
114 }
115 
116 interface ERC721Metadata /* is ERC721 */ {
117     function name() external pure returns (string _name);
118     function symbol() external pure returns (string _symbol);
119     function deedUri(uint256 _deedId) external view returns (string _deedUri);
120 }
121 
122 interface ERC721Enumerable /* is ERC721 */ {
123     function totalSupply() external view returns (uint256 _count);
124     function deedByIndex(uint256 _index) external view returns (uint256 _deedId);
125     function countOfOwners() external view returns (uint256 _count);
126     // function ownerByIndex(uint256 _index) external view returns (address _owner);
127     // function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId);
128 }
129 
130 
131 // ----------------------------------------------------------------------------
132 //
133 // ERC721 Token
134 //
135 // ----------------------------------------------------------------------------
136 
137 contract ERC721Token is ERC721Interface, ERC721Metadata, ERC721Enumerable, Owned {
138   
139   using SafeMath for uint;
140 
141   uint public ownerCount = 0;
142   uint public deedCount = 0;
143   
144   mapping(address => uint) public balances;
145   mapping(uint => address) public mIdOwner;
146   mapping(uint => address) public mIdApproved;
147 
148   // Required Functions ------------------------
149 
150   /* Get the number of tokens held by an address */
151 
152   function balanceOf(address _owner) external view returns (uint balance) {
153     balance = balances[_owner];
154   }
155 
156   /* Get the owner of a certain token */
157 
158   function ownerOf(uint _id) external view returns (address owner) {
159     owner = mIdOwner[_id];
160     require( owner != address(0x0) );
161   }
162 
163   /* Transfer token */
164   
165   function transfer(address _to, uint _id) external {
166     // check ownership and address
167     require( msg.sender == mIdOwner[_id] );
168     require( _to != address(0x0) );
169 
170     // transfer ownership
171     mIdOwner[_id] = _to;
172     mIdApproved[_id] = address(0x0);
173 
174     // update balances
175     updateBalances(msg.sender, _to);
176 
177     // register event
178     Transfer(msg.sender, _to, _id);
179   }
180 
181   /* Transfer from */
182   
183   function transferFrom(address _from, address _to, uint _id) external {
184     // check if the sender has the right to transfer
185     require( _from == mIdOwner[_id] && mIdApproved[_id] == msg.sender );
186 
187     // transfer ownership and reset approval (if any)
188     mIdOwner[_id] = _to;
189     mIdApproved[_id] = address(0x0);
190 
191     // update balances
192     updateBalances(_from, _to);
193 
194     // register event
195     Transfer(_from, _to, _id);
196   }
197 
198   /* Approve token transfer (we do not make it payable) */
199   
200    function approve(address _approved, uint _id) external {
201        require( msg.sender == mIdOwner[_id] );
202        require( msg.sender != _approved );
203        mIdApproved[_id] = _approved;
204        Approval(msg.sender, _approved, _id);
205    }
206 
207   // Metadata Functions ---------------
208 
209 
210   // Enumeration Functions ------------
211   
212   function totalSupply() external view returns (uint count) {
213     count = deedCount;
214   }
215 
216   function deedByIndex(uint _index) external view returns (uint id) {
217     id = _index;
218     require( id < deedCount );
219   }  
220   
221   function countOfOwners() external view returns (uint count) {
222     count = ownerCount;
223   }
224   
225   // Internal functions ---------------
226   
227   function updateBalances(address _from, address _to) internal {
228     // process from (skip if minted)
229     if (_from != address(0x0)) {
230       balances[_from]--;
231       if (balances[_from] == 0) { ownerCount--; }
232     }
233     // process to
234     balances[_to]++;
235     if (balances[_to] == 1) { ownerCount++; }
236   }
237       
238 }
239 
240 
241 // ----------------------------------------------------------------------------
242 //
243 // ERC721 Token
244 //
245 // ----------------------------------------------------------------------------
246 
247 contract GizerItems is ERC721Token {
248 
249   /* Basic token data */
250   
251   string constant cName   = "Gizer Item";
252   string constant cSymbol = "GZR721";
253   
254   /* uuid information */
255 
256   bytes32[] public code;
257   uint[] public weight;
258   uint public sumOfWeights;
259   
260   mapping(bytes32 => uint) public mCodeIndexPlus; // index + 1
261 
262   /* Pseudo-randomisation variables */
263 
264   uint public nonce = 0;
265   uint public lastRandom = 0;
266   
267   /* mapping from item index to uuid */
268   
269   mapping(uint => bytes32) public mIdxUuid;
270   
271   // Events ---------------------------
272   
273   event MintToken(address indexed minter, address indexed _owner, bytes32 indexed _code, uint _input);
274   
275   event CodeUpdate(uint8 indexed _type, bytes32 indexed _code, uint _weight, uint _sumOfWeights);
276   
277   // Basic Functions ------------------
278   
279   function GizerItems() public { }
280   
281   function () public payable { revert(); }
282   
283   // Information functions ------------
284 
285   function name() external pure returns (string) {
286     return cName;
287   }
288   
289   function symbol() external pure returns (string) {
290     return cSymbol;
291   }
292   
293   function deedUri(uint _id) external view returns (string) {
294     return bytes32ToString(mIdxUuid[_id]);
295   }
296   
297   function getUuid(uint _id) external view returns (string) {
298     require( _id < code.length );
299     return bytes32ToString(code[_id]);  
300   }
301 
302   // Token Minting --------------------
303   
304   function mint(address _to) public onlyAdmin returns (uint idx) {
305     
306     // initial checks
307     require( sumOfWeights > 0 );
308     require( _to != address(0x0) );
309     require( _to != address(this) );
310 
311     // get random uuid
312     bytes32 uuid32 = getRandomUuid();
313 
314     // mint token
315     deedCount++;
316     idx = deedCount;
317     mIdxUuid[idx] = uuid32;
318 
319     // update balance and owner count
320     updateBalances(address(0x0), _to);
321     mIdOwner[idx] = _to;
322 
323     // log event and return
324     MintToken(msg.sender, _to, uuid32, idx);
325   }
326   
327   // Random
328   
329   function getRandomUuid() internal returns (bytes32) {
330     // case where there is only one item type
331     if (code.length == 1) return code[0];
332 
333     // more than one
334     updateRandom();
335     uint res = lastRandom % sumOfWeights;
336     uint cWeight = 0;
337     for (uint i = 0; i < code.length; i++) {
338       cWeight = cWeight + weight[i];
339       if (cWeight >= res) return code[i];
340     }
341 
342     // we should never get here
343     revert();
344   }
345 
346   function updateRandom() internal {
347     nonce++;
348     lastRandom = uint(keccak256(
349         nonce,
350         lastRandom,
351         block.blockhash(block.number - 1),
352         block.coinbase,
353         block.difficulty
354     ));
355   }
356   
357   // uuid functions -------------------
358   
359   /* add a new code + weight */
360   
361   function addCode(string _code, uint _weight) public onlyAdmin returns (bool success) {
362 
363     bytes32 uuid32 = stringToBytes32(_code);
364 
365     // weight posiitve & code not yet registered
366     require( _weight > 0 );
367     require( mCodeIndexPlus[uuid32] == 0 );
368 
369     // add to end of array
370     uint idx = code.length;
371     code.push(uuid32);
372     weight.push(_weight);
373     mCodeIndexPlus[uuid32] = idx + 1;
374 
375     // update sum of weights
376     sumOfWeights = sumOfWeights.add(_weight);
377 
378     // register event and return
379     CodeUpdate(1, uuid32, _weight, sumOfWeights);
380     return true;
381   }
382   
383   /* update the weight of an existing code */
384   
385   function updateCodeWeight(string _code, uint _weight) public onlyAdmin returns (bool success) {
386 
387     bytes32 uuid32 = stringToBytes32(_code);
388 
389     // weight positive & code must be registered
390     require( _weight > 0 );
391     require( mCodeIndexPlus[uuid32] > 0 );
392 
393     // update weight and sum of weights
394     uint idx = mCodeIndexPlus[uuid32] - 1;
395     uint oldWeight = weight[idx];
396     weight[idx] = _weight;
397     sumOfWeights = sumOfWeights.sub(oldWeight).add(_weight);
398 
399     // register event and return
400     CodeUpdate(2, uuid32, _weight, sumOfWeights);
401     return true;
402   }
403   
404   /* remove an existing code */
405   
406   function removeCode(string _code) public onlyAdmin returns (bool success) {
407 
408     bytes32 uuid32 = stringToBytes32(_code);
409 
410     // code must be registered
411     require( mCodeIndexPlus[uuid32] > 0 );
412 
413     // index of code to be deleted
414     uint idx = mCodeIndexPlus[uuid32] - 1;
415     uint idxLast = code.length - 1;
416 
417     // update sum of weights and remove mapping
418     sumOfWeights = sumOfWeights.sub(weight[idx]);
419     mCodeIndexPlus[uuid32] = 0;
420 
421     if (idx != idxLast) {
422       // if we are not deleting the last element:
423       // move last element to index of deleted element
424       code[idx] = code[idxLast];
425       weight[idx] = weight[idxLast];
426       mCodeIndexPlus[code[idxLast]] = idx;
427     }
428     // delete last element of arrays
429     delete code[idxLast];
430     code.length--;
431     delete weight[idxLast];
432     weight.length--;
433 
434     // register event and return
435     CodeUpdate(3, uuid32, 0, sumOfWeights);
436     return true;
437   }
438 
439   /* Transfer out any accidentally sent ERC20 tokens */
440 
441   function transferAnyERC20Token(address tokenAddress, uint amount) public onlyOwner returns (bool success) {
442       return ERC20Interface(tokenAddress).transfer(owner, amount);
443   }
444   
445   // Utility functions ----------------
446 
447   /* https://ethereum.stackexchange.com/questions/9142/how-to-convert-a-string-to-bytes32 */
448   
449   function stringToBytes32(string memory source) public pure returns (bytes32 result) {
450     bytes memory tempEmptyStringTest = bytes(source);
451     if (tempEmptyStringTest.length == 0) {
452         return 0x0;
453     }
454 
455     assembly {
456         result := mload(add(source, 32))
457     }
458   }
459   
460   /* https://ethereum.stackexchange.com/questions/2519/how-to-convert-a-bytes32-to-string */
461 
462   function bytes32ToString(bytes32 x) public pure returns (string) {
463     bytes memory bytesString = new bytes(32);
464     uint charCount = 0;
465     for (uint j = 0; j < 32; j++) {
466       byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
467       if (char != 0) {
468         bytesString[charCount] = char;
469         charCount++;
470       }
471     }
472     bytes memory bytesStringTrimmed = new bytes(charCount);
473     for (j = 0; j < charCount; j++) {
474       bytesStringTrimmed[j] = bytesString[j];
475     }
476     return string(bytesStringTrimmed);
477   }
478   
479 }
480 
481 // ----------------------------------------------------------------------------
482 //
483 // ERC Token Standard #20 Interface
484 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
485 //
486 // ----------------------------------------------------------------------------
487 
488 contract ERC20Interface {
489   function transfer(address _to, uint _value) public returns (bool success);
490 }