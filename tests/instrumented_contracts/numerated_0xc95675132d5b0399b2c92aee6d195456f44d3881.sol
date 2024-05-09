1 pragma solidity ^0.4.23;
2 
3 pragma solidity ^0.4.23;
4 
5 pragma solidity ^0.4.23;
6 
7 
8 pragma solidity ^0.4.23;
9 
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     emit OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49 }
50 
51 
52 
53 /**
54  * @title Pausable
55  * @dev Base contract which allows children to implement an emergency stop mechanism.
56  */
57 contract Pausable is Ownable {
58   event Pause();
59   event Unpause();
60 
61   bool public paused = false;
62 
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is not paused.
66    */
67   modifier whenNotPaused() {
68     require(!paused);
69     _;
70   }
71 
72   /**
73    * @dev Modifier to make a function callable only when the contract is paused.
74    */
75   modifier whenPaused() {
76     require(paused);
77     _;
78   }
79 
80   /**
81    * @dev called by the owner to pause, triggers stopped state
82    */
83   function pause() onlyOwner whenNotPaused public {
84     paused = true;
85     emit Pause();
86   }
87 
88   /**
89    * @dev called by the owner to unpause, returns to normal state
90    */
91   function unpause() onlyOwner whenPaused public {
92     paused = false;
93     emit Unpause();
94   }
95 }
96 
97 pragma solidity ^0.4.23;
98 
99 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
100 contract PluginInterface
101 {
102     /// @dev simply a boolean to indicate this is the contract we expect to be
103     function isPluginInterface() public pure returns (bool);
104 
105     function onRemove() public;
106 
107     /// @dev Begins new feature.
108     /// @param _cutieId - ID of token to auction, sender must be owner.
109     /// @param _parameter - arbitrary parameter
110     /// @param _seller - Old owner, if not the message sender
111     function run(
112         uint40 _cutieId,
113         uint256 _parameter,
114         address _seller
115     )
116     public
117     payable;
118 
119     /// @dev Begins new feature, approved and signed by COO.
120     /// @param _cutieId - ID of token to auction, sender must be owner.
121     /// @param _parameter - arbitrary parameter
122     function runSigned(
123         uint40 _cutieId,
124         uint256 _parameter,
125         address _owner
126     ) external payable;
127 
128     function withdraw() external;
129 }
130 
131 pragma solidity ^0.4.23;
132 
133 pragma solidity ^0.4.23;
134 
135 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
136 /// @author https://BlockChainArchitect.io
137 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
138 interface ConfigInterface
139 {
140     function isConfig() external pure returns (bool);
141 
142     function getCooldownIndexFromGeneration(uint16 _generation, uint40 _cutieId) external view returns (uint16);
143     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex, uint40 _cutieId) external view returns (uint40);
144     function getCooldownIndexFromGeneration(uint16 _generation) external view returns (uint16);
145     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) external view returns (uint40);
146 
147     function getCooldownIndexCount() external view returns (uint256);
148 
149     function getBabyGenFromId(uint40 _momId, uint40 _dadId) external view returns (uint16);
150     function getBabyGen(uint16 _momGen, uint16 _dadGen) external pure returns (uint16);
151 
152     function getTutorialBabyGen(uint16 _dadGen) external pure returns (uint16);
153 
154     function getBreedingFee(uint40 _momId, uint40 _dadId) external view returns (uint256);
155 }
156 
157 
158 contract CutieCoreInterface
159 {
160     function isCutieCore() pure public returns (bool);
161 
162     ConfigInterface public config;
163 
164     function transferFrom(address _from, address _to, uint256 _cutieId) external;
165     function transfer(address _to, uint256 _cutieId) external;
166 
167     function ownerOf(uint256 _cutieId)
168         external
169         view
170         returns (address owner);
171 
172     function getCutie(uint40 _id)
173         external
174         view
175         returns (
176         uint256 genes,
177         uint40 birthTime,
178         uint40 cooldownEndTime,
179         uint40 momId,
180         uint40 dadId,
181         uint16 cooldownIndex,
182         uint16 generation
183     );
184 
185     function getGenes(uint40 _id)
186         public
187         view
188         returns (
189         uint256 genes
190     );
191 
192 
193     function getCooldownEndTime(uint40 _id)
194         public
195         view
196         returns (
197         uint40 cooldownEndTime
198     );
199 
200     function getCooldownIndex(uint40 _id)
201         public
202         view
203         returns (
204         uint16 cooldownIndex
205     );
206 
207 
208     function getGeneration(uint40 _id)
209         public
210         view
211         returns (
212         uint16 generation
213     );
214 
215     function getOptional(uint40 _id)
216         public
217         view
218         returns (
219         uint64 optional
220     );
221 
222 
223     function changeGenes(
224         uint40 _cutieId,
225         uint256 _genes)
226         public;
227 
228     function changeCooldownEndTime(
229         uint40 _cutieId,
230         uint40 _cooldownEndTime)
231         public;
232 
233     function changeCooldownIndex(
234         uint40 _cutieId,
235         uint16 _cooldownIndex)
236         public;
237 
238     function changeOptional(
239         uint40 _cutieId,
240         uint64 _optional)
241         public;
242 
243     function changeGeneration(
244         uint40 _cutieId,
245         uint16 _generation)
246         public;
247 
248     function createSaleAuction(
249         uint40 _cutieId,
250         uint128 _startPrice,
251         uint128 _endPrice,
252         uint40 _duration
253     )
254     public;
255 
256     function getApproved(uint256 _tokenId) external returns (address);
257     function totalSupply() view external returns (uint256);
258     function createPromoCutie(uint256 _genes, address _owner) external;
259     function checkOwnerAndApprove(address _claimant, uint40 _cutieId, address _pluginsContract) external view;
260     function breedWith(uint40 _momId, uint40 _dadId) public payable returns (uint40);
261     function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);
262     function restoreCutieToAddress(uint40 _cutieId, address _recipient) external;
263     function createGen0Auction(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration) external;
264     function createGen0AuctionWithTokens(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration, address[] allowedTokens) external;
265     function createPromoCutieWithGeneration(uint256 _genes, address _owner, uint16 _generation) external;
266     function createPromoCutieBulk(uint256[] _genes, address _owner, uint16 _generation) external;
267 }
268 
269 pragma solidity ^0.4.23;
270 
271 
272 pragma solidity ^0.4.23;
273 
274 contract Operators
275 {
276     mapping (address=>bool) ownerAddress;
277     mapping (address=>bool) operatorAddress;
278 
279     constructor() public
280     {
281         ownerAddress[msg.sender] = true;
282     }
283 
284     modifier onlyOwner()
285     {
286         require(ownerAddress[msg.sender]);
287         _;
288     }
289 
290     function isOwner(address _addr) public view returns (bool) {
291         return ownerAddress[_addr];
292     }
293 
294     function addOwner(address _newOwner) external onlyOwner {
295         require(_newOwner != address(0));
296 
297         ownerAddress[_newOwner] = true;
298     }
299 
300     function removeOwner(address _oldOwner) external onlyOwner {
301         delete(ownerAddress[_oldOwner]);
302     }
303 
304     modifier onlyOperator() {
305         require(isOperator(msg.sender));
306         _;
307     }
308 
309     function isOperator(address _addr) public view returns (bool) {
310         return operatorAddress[_addr] || ownerAddress[_addr];
311     }
312 
313     function addOperator(address _newOperator) external onlyOwner {
314         require(_newOperator != address(0));
315 
316         operatorAddress[_newOperator] = true;
317     }
318 
319     function removeOperator(address _oldOperator) external onlyOwner {
320         delete(operatorAddress[_oldOperator]);
321     }
322 }
323 
324 
325 
326 /**
327  * @title Pausable
328  * @dev Base contract which allows children to implement an emergency stop mechanism.
329  */
330 contract PausableOperators is Operators {
331     event Pause();
332     event Unpause();
333 
334     bool public paused = false;
335 
336 
337     /**
338      * @dev Modifier to make a function callable only when the contract is not paused.
339      */
340     modifier whenNotPaused() {
341         require(!paused);
342         _;
343     }
344 
345     /**
346      * @dev Modifier to make a function callable only when the contract is paused.
347      */
348     modifier whenPaused() {
349         require(paused);
350         _;
351     }
352 
353     /**
354      * @dev called by the owner to pause, triggers stopped state
355      */
356     function pause() onlyOwner whenNotPaused public {
357         paused = true;
358         emit Pause();
359     }
360 
361     /**
362      * @dev called by the owner to unpause, returns to normal state
363      */
364     function unpause() onlyOwner whenPaused public {
365         paused = false;
366         emit Unpause();
367     }
368 }
369 
370 
371 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
372 contract CutiePluginBase is PluginInterface, PausableOperators
373 {
374     function isPluginInterface() public pure returns (bool)
375     {
376         return true;
377     }
378 
379     // Reference to contract tracking NFT ownership
380     CutieCoreInterface public coreContract;
381     address public pluginsContract;
382 
383     // @dev Throws if called by any account other than the owner.
384     modifier onlyCore() {
385         require(msg.sender == address(coreContract));
386         _;
387     }
388 
389     modifier onlyPlugins() {
390         require(msg.sender == pluginsContract);
391         _;
392     }
393 
394     /// @dev Constructor creates a reference to the NFT ownership contract
395     ///  and verifies the owner cut is in the valid range.
396     /// @param _coreAddress - address of a deployed contract implementing
397     ///  the Nonfungible Interface.
398     function setup(address _coreAddress, address _pluginsContract) public onlyOwner {
399         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
400         require(candidateContract.isCutieCore());
401         coreContract = candidateContract;
402 
403         pluginsContract = _pluginsContract;
404     }
405 
406     /// @dev Returns true if the claimant owns the token.
407     /// @param _claimant - Address claiming to own the token.
408     /// @param _cutieId - ID of token whose ownership to verify.
409     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {
410         return (coreContract.ownerOf(_cutieId) == _claimant);
411     }
412 
413     /// @dev Escrows the NFT, assigning ownership to this contract.
414     /// Throws if the escrow fails.
415     /// @param _owner - Current owner address of token to escrow.
416     /// @param _cutieId - ID of token whose approval to verify.
417     function _escrow(address _owner, uint40 _cutieId) internal {
418         // it will throw if transfer fails
419         coreContract.transferFrom(_owner, this, _cutieId);
420     }
421 
422     /// @dev Transfers an NFT owned by this contract to another address.
423     /// Returns true if the transfer succeeds.
424     /// @param _receiver - Address to transfer NFT to.
425     /// @param _cutieId - ID of token to transfer.
426     function _transfer(address _receiver, uint40 _cutieId) internal {
427         // it will throw if transfer fails
428         coreContract.transfer(_receiver, _cutieId);
429     }
430 
431     function withdraw() external
432     {
433         require(
434             isOwner(msg.sender) ||
435             msg.sender == address(coreContract)
436         );
437         _withdraw();
438     }
439 
440     function _withdraw() internal
441     {
442         if (address(this).balance > 0)
443         {
444             address(coreContract).transfer(address(this).balance);
445         }
446     }
447 
448     function onRemove() public onlyPlugins
449     {
450         _withdraw();
451     }
452 
453     function run(uint40, uint256, address) public payable onlyCore
454     {
455         revert();
456     }
457 
458     function runSigned(uint40, uint256, address) external payable onlyCore
459     {
460         revert();
461     }
462 }
463 
464 
465 /// @dev Receives payments for payd features from players for Blockchain Cuties
466 /// @author https://BlockChainArchitect.io
467 contract StoreFeaturing is CutiePluginBase
468 {
469     function run(
470         uint40,
471         uint256,
472         address
473     ) 
474         public
475         payable
476         onlyPlugins
477     {
478         revert();
479     }
480 
481     function runSigned(uint40, uint256, address)
482         external
483         payable
484         onlyPlugins
485     {
486         // just accept payments
487     }
488 }