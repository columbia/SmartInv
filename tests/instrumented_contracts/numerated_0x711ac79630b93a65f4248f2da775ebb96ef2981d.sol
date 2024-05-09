1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 
7 
8 
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
97 
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
130     function withdraw() public;
131 }
132 
133 
134 
135 
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
266 
267 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
268 contract CutiePluginBase is PluginInterface, Pausable
269 {
270     function isPluginInterface() public pure returns (bool)
271     {
272         return true;
273     }
274 
275     // Reference to contract tracking NFT ownership
276     CutieCoreInterface public coreContract;
277     address public pluginsContract;
278 
279     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
280     // Values 0-10,000 map to 0%-100%
281     uint16 public ownerFee;
282 
283     // @dev Throws if called by any account other than the owner.
284     modifier onlyCore() {
285         require(msg.sender == address(coreContract));
286         _;
287     }
288 
289     modifier onlyPlugins() {
290         require(msg.sender == pluginsContract);
291         _;
292     }
293 
294     /// @dev Constructor creates a reference to the NFT ownership contract
295     ///  and verifies the owner cut is in the valid range.
296     /// @param _coreAddress - address of a deployed contract implementing
297     ///  the Nonfungible Interface.
298     /// @param _fee - percent cut the owner takes on each auction, must be
299     ///  between 0-10,000.
300     function setup(address _coreAddress, address _pluginsContract, uint16 _fee) public {
301         require(_fee <= 10000);
302         require(msg.sender == owner);
303         ownerFee = _fee;
304         
305         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
306         require(candidateContract.isCutieCore());
307         coreContract = candidateContract;
308 
309         pluginsContract = _pluginsContract;
310     }
311 
312     // @dev Set the owner's fee.
313     //  @param fee should be between 0-10,000.
314     function setFee(uint16 _fee) public
315     {
316         require(_fee <= 10000);
317         require(msg.sender == owner);
318 
319         ownerFee = _fee;
320     }
321 
322     /// @dev Returns true if the claimant owns the token.
323     /// @param _claimant - Address claiming to own the token.
324     /// @param _cutieId - ID of token whose ownership to verify.
325     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {
326         return (coreContract.ownerOf(_cutieId) == _claimant);
327     }
328 
329     /// @dev Escrows the NFT, assigning ownership to this contract.
330     /// Throws if the escrow fails.
331     /// @param _owner - Current owner address of token to escrow.
332     /// @param _cutieId - ID of token whose approval to verify.
333     function _escrow(address _owner, uint40 _cutieId) internal {
334         // it will throw if transfer fails
335         coreContract.transferFrom(_owner, this, _cutieId);
336     }
337 
338     /// @dev Transfers an NFT owned by this contract to another address.
339     /// Returns true if the transfer succeeds.
340     /// @param _receiver - Address to transfer NFT to.
341     /// @param _cutieId - ID of token to transfer.
342     function _transfer(address _receiver, uint40 _cutieId) internal {
343         // it will throw if transfer fails
344         coreContract.transfer(_receiver, _cutieId);
345     }
346 
347     /// @dev Computes owner's cut of a sale.
348     /// @param _price - Sale price of NFT.
349     function _computeFee(uint128 _price) internal view returns (uint128) {
350         // NOTE: We don't use SafeMath (or similar) in this function because
351         //  all of our entry functions carefully cap the maximum values for
352         //  currency (at 128-bits), and ownerFee <= 10000 (see the require()
353         //  statement in the ClockAuction constructor). The result of this
354         //  function is always guaranteed to be <= _price.
355         return _price * ownerFee / 10000;
356     }
357 
358     function withdraw() public
359     {
360         require(
361             msg.sender == owner ||
362             msg.sender == address(coreContract)
363         );
364         _withdraw();
365     }
366 
367     function _withdraw() internal
368     {
369         if (address(this).balance > 0)
370         {
371             address(coreContract).transfer(address(this).balance);
372         }
373     }
374 
375     function onRemove() public onlyPlugins
376     {
377         _withdraw();
378     }
379 
380     function run(
381         uint40,
382         uint256,
383         address
384     ) 
385         public
386         payable
387         onlyCore
388     {
389         revert();
390     }
391 }
392 
393 
394 /// @dev Receives payments for payd features from players for Blockchain Cuties
395 /// @author https://BlockChainArchitect.io
396 contract PawShop is CutiePluginBase
397 {
398     function run(
399         uint40,
400         uint256,
401         address
402     )
403     public
404     payable
405     onlyPlugins
406     {
407         revert();
408     }
409 
410     function runSigned(uint40, uint256, address)
411     external
412     payable
413     onlyPlugins
414     {
415         // just accept payments
416     }
417 }