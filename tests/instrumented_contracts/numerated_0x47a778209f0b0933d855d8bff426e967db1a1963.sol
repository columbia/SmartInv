1 pragma solidity ^0.4.23;
2 
3 pragma solidity ^0.4.23;
4 
5 pragma solidity ^0.4.23;
6 
7 pragma solidity ^0.4.23;
8 
9 
10 pragma solidity ^0.4.23;
11 
12 
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20 
21 
22   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   constructor() public {
30     owner = msg.sender;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) public onlyOwner {
46     require(newOwner != address(0));
47     emit OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 
54 
55 /**
56  * @title Pausable
57  * @dev Base contract which allows children to implement an emergency stop mechanism.
58  */
59 contract Pausable is Ownable {
60   event Pause();
61   event Unpause();
62 
63   bool public paused = false;
64 
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is not paused.
68    */
69   modifier whenNotPaused() {
70     require(!paused);
71     _;
72   }
73 
74   /**
75    * @dev Modifier to make a function callable only when the contract is paused.
76    */
77   modifier whenPaused() {
78     require(paused);
79     _;
80   }
81 
82   /**
83    * @dev called by the owner to pause, triggers stopped state
84    */
85   function pause() onlyOwner whenNotPaused public {
86     paused = true;
87     emit Pause();
88   }
89 
90   /**
91    * @dev called by the owner to unpause, returns to normal state
92    */
93   function unpause() onlyOwner whenPaused public {
94     paused = false;
95     emit Unpause();
96   }
97 }
98 
99 pragma solidity ^0.4.23;
100 
101 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
102 contract PluginInterface
103 {
104     /// @dev simply a boolean to indicate this is the contract we expect to be
105     function isPluginInterface() public pure returns (bool);
106 
107     function onRemove() public;
108 
109     /// @dev Begins new feature.
110     /// @param _cutieId - ID of token to auction, sender must be owner.
111     /// @param _parameter - arbitrary parameter
112     /// @param _seller - Old owner, if not the message sender
113     function run(
114         uint40 _cutieId,
115         uint256 _parameter,
116         address _seller
117     )
118     public
119     payable;
120 
121     /// @dev Begins new feature, approved and signed by COO.
122     /// @param _cutieId - ID of token to auction, sender must be owner.
123     /// @param _parameter - arbitrary parameter
124     function runSigned(
125         uint40 _cutieId,
126         uint256 _parameter,
127         address _owner
128     ) external payable;
129 
130     function withdraw() external;
131 }
132 
133 pragma solidity ^0.4.23;
134 
135 pragma solidity ^0.4.23;
136 
137 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
138 /// @author https://BlockChainArchitect.io
139 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
140 interface ConfigInterface
141 {
142     function isConfig() external pure returns (bool);
143 
144     function getCooldownIndexFromGeneration(uint16 _generation, uint40 _cutieId) external view returns (uint16);
145     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex, uint40 _cutieId) external view returns (uint40);
146     function getCooldownIndexFromGeneration(uint16 _generation) external view returns (uint16);
147     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) external view returns (uint40);
148 
149     function getCooldownIndexCount() external view returns (uint256);
150 
151     function getBabyGenFromId(uint40 _momId, uint40 _dadId) external view returns (uint16);
152     function getBabyGen(uint16 _momGen, uint16 _dadGen) external pure returns (uint16);
153 
154     function getTutorialBabyGen(uint16 _dadGen) external pure returns (uint16);
155 
156     function getBreedingFee(uint40 _momId, uint40 _dadId) external view returns (uint256);
157 }
158 
159 
160 contract CutieCoreInterface
161 {
162     function isCutieCore() pure public returns (bool);
163 
164     ConfigInterface public config;
165 
166     function transferFrom(address _from, address _to, uint256 _cutieId) external;
167     function transfer(address _to, uint256 _cutieId) external;
168 
169     function ownerOf(uint256 _cutieId)
170         external
171         view
172         returns (address owner);
173 
174     function getCutie(uint40 _id)
175         external
176         view
177         returns (
178         uint256 genes,
179         uint40 birthTime,
180         uint40 cooldownEndTime,
181         uint40 momId,
182         uint40 dadId,
183         uint16 cooldownIndex,
184         uint16 generation
185     );
186 
187     function getGenes(uint40 _id)
188         public
189         view
190         returns (
191         uint256 genes
192     );
193 
194 
195     function getCooldownEndTime(uint40 _id)
196         public
197         view
198         returns (
199         uint40 cooldownEndTime
200     );
201 
202     function getCooldownIndex(uint40 _id)
203         public
204         view
205         returns (
206         uint16 cooldownIndex
207     );
208 
209 
210     function getGeneration(uint40 _id)
211         public
212         view
213         returns (
214         uint16 generation
215     );
216 
217     function getOptional(uint40 _id)
218         public
219         view
220         returns (
221         uint64 optional
222     );
223 
224 
225     function changeGenes(
226         uint40 _cutieId,
227         uint256 _genes)
228         public;
229 
230     function changeCooldownEndTime(
231         uint40 _cutieId,
232         uint40 _cooldownEndTime)
233         public;
234 
235     function changeCooldownIndex(
236         uint40 _cutieId,
237         uint16 _cooldownIndex)
238         public;
239 
240     function changeOptional(
241         uint40 _cutieId,
242         uint64 _optional)
243         public;
244 
245     function changeGeneration(
246         uint40 _cutieId,
247         uint16 _generation)
248         public;
249 
250     function createSaleAuction(
251         uint40 _cutieId,
252         uint128 _startPrice,
253         uint128 _endPrice,
254         uint40 _duration
255     )
256     public;
257 
258     function getApproved(uint256 _tokenId) external returns (address);
259     function totalSupply() view external returns (uint256);
260     function createPromoCutie(uint256 _genes, address _owner) external;
261     function checkOwnerAndApprove(address _claimant, uint40 _cutieId, address _pluginsContract) external view;
262     function breedWith(uint40 _momId, uint40 _dadId) public payable returns (uint40);
263     function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);
264     function restoreCutieToAddress(uint40 _cutieId, address _recipient) external;
265     function createGen0Auction(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration) external;
266     function createGen0AuctionWithTokens(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration, address[] allowedTokens) external;
267     function createPromoCutieWithGeneration(uint256 _genes, address _owner, uint16 _generation) external;
268     function createPromoCutieBulk(uint256[] _genes, address _owner, uint16 _generation) external;
269 }
270 
271 pragma solidity ^0.4.23;
272 
273 
274 pragma solidity ^0.4.23;
275 
276 contract Operators
277 {
278     mapping (address=>bool) ownerAddress;
279     mapping (address=>bool) operatorAddress;
280 
281     constructor() public
282     {
283         ownerAddress[msg.sender] = true;
284     }
285 
286     modifier onlyOwner()
287     {
288         require(ownerAddress[msg.sender]);
289         _;
290     }
291 
292     function isOwner(address _addr) public view returns (bool) {
293         return ownerAddress[_addr];
294     }
295 
296     function addOwner(address _newOwner) external onlyOwner {
297         require(_newOwner != address(0));
298 
299         ownerAddress[_newOwner] = true;
300     }
301 
302     function removeOwner(address _oldOwner) external onlyOwner {
303         delete(ownerAddress[_oldOwner]);
304     }
305 
306     modifier onlyOperator() {
307         require(isOperator(msg.sender));
308         _;
309     }
310 
311     function isOperator(address _addr) public view returns (bool) {
312         return operatorAddress[_addr] || ownerAddress[_addr];
313     }
314 
315     function addOperator(address _newOperator) external onlyOwner {
316         require(_newOperator != address(0));
317 
318         operatorAddress[_newOperator] = true;
319     }
320 
321     function removeOperator(address _oldOperator) external onlyOwner {
322         delete(operatorAddress[_oldOperator]);
323     }
324 }
325 
326 
327 
328 /**
329  * @title Pausable
330  * @dev Base contract which allows children to implement an emergency stop mechanism.
331  */
332 contract PausableOperators is Operators {
333     event Pause();
334     event Unpause();
335 
336     bool public paused = false;
337 
338 
339     /**
340      * @dev Modifier to make a function callable only when the contract is not paused.
341      */
342     modifier whenNotPaused() {
343         require(!paused);
344         _;
345     }
346 
347     /**
348      * @dev Modifier to make a function callable only when the contract is paused.
349      */
350     modifier whenPaused() {
351         require(paused);
352         _;
353     }
354 
355     /**
356      * @dev called by the owner to pause, triggers stopped state
357      */
358     function pause() onlyOwner whenNotPaused public {
359         paused = true;
360         emit Pause();
361     }
362 
363     /**
364      * @dev called by the owner to unpause, returns to normal state
365      */
366     function unpause() onlyOwner whenPaused public {
367         paused = false;
368         emit Unpause();
369     }
370 }
371 
372 
373 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
374 contract CutiePluginBase is PluginInterface, PausableOperators
375 {
376     function isPluginInterface() public pure returns (bool)
377     {
378         return true;
379     }
380 
381     // Reference to contract tracking NFT ownership
382     CutieCoreInterface public coreContract;
383     address public pluginsContract;
384 
385     // @dev Throws if called by any account other than the owner.
386     modifier onlyCore() {
387         require(msg.sender == address(coreContract));
388         _;
389     }
390 
391     modifier onlyPlugins() {
392         require(msg.sender == pluginsContract);
393         _;
394     }
395 
396     /// @dev Constructor creates a reference to the NFT ownership contract
397     ///  and verifies the owner cut is in the valid range.
398     /// @param _coreAddress - address of a deployed contract implementing
399     ///  the Nonfungible Interface.
400     function setup(address _coreAddress, address _pluginsContract) public onlyOwner {
401         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
402         require(candidateContract.isCutieCore());
403         coreContract = candidateContract;
404 
405         pluginsContract = _pluginsContract;
406     }
407 
408     /// @dev Returns true if the claimant owns the token.
409     /// @param _claimant - Address claiming to own the token.
410     /// @param _cutieId - ID of token whose ownership to verify.
411     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {
412         return (coreContract.ownerOf(_cutieId) == _claimant);
413     }
414 
415     /// @dev Escrows the NFT, assigning ownership to this contract.
416     /// Throws if the escrow fails.
417     /// @param _owner - Current owner address of token to escrow.
418     /// @param _cutieId - ID of token whose approval to verify.
419     function _escrow(address _owner, uint40 _cutieId) internal {
420         // it will throw if transfer fails
421         coreContract.transferFrom(_owner, this, _cutieId);
422     }
423 
424     /// @dev Transfers an NFT owned by this contract to another address.
425     /// Returns true if the transfer succeeds.
426     /// @param _receiver - Address to transfer NFT to.
427     /// @param _cutieId - ID of token to transfer.
428     function _transfer(address _receiver, uint40 _cutieId) internal {
429         // it will throw if transfer fails
430         coreContract.transfer(_receiver, _cutieId);
431     }
432 
433     function withdraw() external
434     {
435         require(
436             isOwner(msg.sender) ||
437             msg.sender == address(coreContract)
438         );
439         _withdraw();
440     }
441 
442     function _withdraw() internal
443     {
444         if (address(this).balance > 0)
445         {
446             address(coreContract).transfer(address(this).balance);
447         }
448     }
449 
450     function onRemove() public onlyPlugins
451     {
452         _withdraw();
453     }
454 
455     function run(uint40, uint256, address) public payable onlyCore
456     {
457         revert();
458     }
459 
460     function runSigned(uint40, uint256, address) external payable onlyCore
461     {
462         revert();
463     }
464 }
465 
466 
467 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
468 contract CutiePluginBaseFee is CutiePluginBase
469 {
470     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
471     // Values 0-10,000 map to 0%-100%
472     uint16 public ownerFee;
473 
474     /// @dev Constructor creates a reference to the NFT ownership contract
475     ///  and verifies the owner cut is in the valid range.
476     /// @param _coreAddress - address of a deployed contract implementing
477     ///  the Nonfungible Interface.
478     /// @param _fee - percent cut the owner takes on each auction, must be
479     ///  between 0-10,000.
480     function setup(address _coreAddress, address _pluginsContract, uint16 _fee) external onlyOwner {
481         require(_fee <= 10000);
482         ownerFee = _fee;
483 
484         super.setup(_coreAddress, _pluginsContract);
485     }
486 
487     // @dev Set the owner's fee.
488     //  @param fee should be between 0-10,000.
489     function setFee(uint16 _fee) external onlyOwner
490     {
491         require(_fee <= 10000);
492 
493         ownerFee = _fee;
494     }
495 
496     /// @dev Computes owner's cut of a sale.
497     /// @param _price - Sale price of NFT.
498     function _computeFee(uint128 _price) internal view returns (uint128) {
499         // NOTE: We don't use SafeMath (or similar) in this function because
500         //  all of our entry functions carefully cap the maximum values for
501         //  currency (at 128-bits), and ownerFee <= 10000 (see the require()
502         //  statement in the ClockAuction constructor). The result of this
503         //  function is always guaranteed to be <= _price.
504         return _price * ownerFee / 10000;
505     }
506 }
507 
508 
509 /// @dev Receives and transfers money from item buyer to seller for Blockchain Cuties
510 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
511 contract ItemMarket is CutiePluginBaseFee
512 {
513     event Transfer(address from, address to, uint128 value);
514 
515     function run(
516         uint40,
517         uint256,
518         address
519     ) 
520         public
521         payable
522         onlyPlugins
523     {
524         revert();
525     }
526 
527     function runSigned(uint40, uint256 _parameter, address /*_buyer*/)
528         external
529         payable
530         onlyPlugins
531     {
532         // first 160 bits - not working on TRON. Cast to address is used instead of it.
533         //address seller = address(_parameter % 0x0010000000000000000000000000000000000000000);
534         // next 40 bits (shift right by 160 bits)
535         uint40 endTime = uint40(_parameter/0x0010000000000000000000000000000000000000000);
536         // check if auction is ended
537         require(now <= endTime);
538         //uint128 fee = _computeFee(uint128(msg.value));
539         //uint256 sellerValue = msg.value - fee;
540 
541         uint256 sellerValue = 96*msg.value / 100;
542 
543         // take first 160 bits and use it as seller address
544         address(_parameter).transfer(sellerValue);
545     }
546 }