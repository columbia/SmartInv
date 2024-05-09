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
126     )
127     external
128     payable;
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
264 }
265 
266 pragma solidity ^0.4.23;
267 
268 
269 pragma solidity ^0.4.23;
270 
271 contract Operators
272 {
273     mapping (address=>bool) ownerAddress;
274     mapping (address=>bool) operatorAddress;
275 
276     constructor() public
277     {
278         ownerAddress[msg.sender] = true;
279     }
280 
281     modifier onlyOwner()
282     {
283         require(ownerAddress[msg.sender]);
284         _;
285     }
286 
287     function isOwner(address _addr) public view returns (bool) {
288         return ownerAddress[_addr];
289     }
290 
291     function addOwner(address _newOwner) external onlyOwner {
292         require(_newOwner != address(0));
293 
294         ownerAddress[_newOwner] = true;
295     }
296 
297     function removeOwner(address _oldOwner) external onlyOwner {
298         delete(ownerAddress[_oldOwner]);
299     }
300 
301     modifier onlyOperator() {
302         require(isOperator(msg.sender));
303         _;
304     }
305 
306     function isOperator(address _addr) public view returns (bool) {
307         return operatorAddress[_addr] || ownerAddress[_addr];
308     }
309 
310     function addOperator(address _newOperator) external onlyOwner {
311         require(_newOperator != address(0));
312 
313         operatorAddress[_newOperator] = true;
314     }
315 
316     function removeOperator(address _oldOperator) external onlyOwner {
317         delete(operatorAddress[_oldOperator]);
318     }
319 }
320 
321 
322 
323 /**
324  * @title Pausable
325  * @dev Base contract which allows children to implement an emergency stop mechanism.
326  */
327 contract PausableOperators is Operators {
328     event Pause();
329     event Unpause();
330 
331     bool public paused = false;
332 
333 
334     /**
335      * @dev Modifier to make a function callable only when the contract is not paused.
336      */
337     modifier whenNotPaused() {
338         require(!paused);
339         _;
340     }
341 
342     /**
343      * @dev Modifier to make a function callable only when the contract is paused.
344      */
345     modifier whenPaused() {
346         require(paused);
347         _;
348     }
349 
350     /**
351      * @dev called by the owner to pause, triggers stopped state
352      */
353     function pause() onlyOwner whenNotPaused public {
354         paused = true;
355         emit Pause();
356     }
357 
358     /**
359      * @dev called by the owner to unpause, returns to normal state
360      */
361     function unpause() onlyOwner whenPaused public {
362         paused = false;
363         emit Unpause();
364     }
365 }
366 
367 
368 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
369 contract CutiePluginBase is PluginInterface, PausableOperators
370 {
371     function isPluginInterface() public pure returns (bool)
372     {
373         return true;
374     }
375 
376     // Reference to contract tracking NFT ownership
377     CutieCoreInterface public coreContract;
378     address public pluginsContract;
379 
380     // @dev Throws if called by any account other than the owner.
381     modifier onlyCore() {
382         require(msg.sender == address(coreContract));
383         _;
384     }
385 
386     modifier onlyPlugins() {
387         require(msg.sender == pluginsContract);
388         _;
389     }
390 
391     /// @dev Constructor creates a reference to the NFT ownership contract
392     ///  and verifies the owner cut is in the valid range.
393     /// @param _coreAddress - address of a deployed contract implementing
394     ///  the Nonfungible Interface.
395     function setup(address _coreAddress, address _pluginsContract) public onlyOwner {
396         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
397         require(candidateContract.isCutieCore());
398         coreContract = candidateContract;
399 
400         pluginsContract = _pluginsContract;
401     }
402 
403     /// @dev Returns true if the claimant owns the token.
404     /// @param _claimant - Address claiming to own the token.
405     /// @param _cutieId - ID of token whose ownership to verify.
406     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {
407         return (coreContract.ownerOf(_cutieId) == _claimant);
408     }
409 
410     /// @dev Escrows the NFT, assigning ownership to this contract.
411     /// Throws if the escrow fails.
412     /// @param _owner - Current owner address of token to escrow.
413     /// @param _cutieId - ID of token whose approval to verify.
414     function _escrow(address _owner, uint40 _cutieId) internal {
415         // it will throw if transfer fails
416         coreContract.transferFrom(_owner, this, _cutieId);
417     }
418 
419     /// @dev Transfers an NFT owned by this contract to another address.
420     /// Returns true if the transfer succeeds.
421     /// @param _receiver - Address to transfer NFT to.
422     /// @param _cutieId - ID of token to transfer.
423     function _transfer(address _receiver, uint40 _cutieId) internal {
424         // it will throw if transfer fails
425         coreContract.transfer(_receiver, _cutieId);
426     }
427 
428     function withdraw() external
429     {
430         require(
431             isOwner(msg.sender) ||
432             msg.sender == address(coreContract)
433         );
434         _withdraw();
435     }
436 
437     function _withdraw() internal
438     {
439         if (address(this).balance > 0)
440         {
441             address(coreContract).transfer(address(this).balance);
442         }
443     }
444 
445     function onRemove() public onlyPlugins
446     {
447         _withdraw();
448     }
449 
450     function run(uint40, uint256, address) public payable onlyCore
451     {
452         revert();
453     }
454 
455     function runSigned(uint40, uint256, address) external payable onlyCore
456     {
457         revert();
458     }
459 }
460 
461 
462 /// @dev Receives payments for payd features from players for Blockchain Cuties
463 /// @author https://BlockChainArchitect.io
464 contract CutieGenerator is CutiePluginBase
465 {
466     uint40 public momId;
467     uint40 public dadId;
468 
469     function setupGenerator(uint40 _momId, uint40 _dadId) external onlyOwner
470     {
471         momId = _momId;
472         dadId = _dadId;
473     }
474 
475     function generateSingle(uint _genome, uint16 _generation, address _target) external onlyOperator returns (uint40 babyId)
476     {
477         return _generate(_genome, _generation, _target);
478     }
479 
480     function generate(uint _genome, uint16 _generation, address[] _target) external onlyOperator
481     {
482         for (uint i = 0; i < _target.length; i++)
483         {
484             _generate(_genome, _generation, _target[i]);
485         }
486     }
487 
488     function _generate(uint _genome, uint16 _generation, address _target) internal returns (uint40 babyId)
489     {
490         coreContract.changeCooldownEndTime(momId, 0);
491         coreContract.changeCooldownEndTime(dadId, 0);
492         coreContract.changeCooldownIndex(momId, 0);
493         coreContract.changeCooldownIndex(dadId, 0);
494 
495         babyId = coreContract.breedWith(momId, dadId);
496 
497         coreContract.changeCooldownIndex(babyId, _generation);
498         coreContract.changeGeneration(babyId, _generation);
499 
500         coreContract.changeGenes(babyId, _genome);
501 
502         coreContract.transfer(_target, babyId);
503 
504         return babyId;
505     }
506 
507     function recoverCutie(uint40 _cutieId) external onlyOwner
508     {
509         coreContract.transfer(msg.sender, _cutieId);
510     }
511 }