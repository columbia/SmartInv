1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 /**
47  * @title Pausable
48  * @dev Base contract which allows children to implement an emergency stop mechanism.
49  */
50 contract Pausable is Ownable {
51   event Pause();
52   event Unpause();
53 
54   bool public paused = false;
55 
56 
57   /**
58    * @dev Modifier to make a function callable only when the contract is not paused.
59    */
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64 
65   /**
66    * @dev Modifier to make a function callable only when the contract is paused.
67    */
68   modifier whenPaused() {
69     require(paused);
70     _;
71   }
72 
73   /**
74    * @dev called by the owner to pause, triggers stopped state
75    */
76   function pause() onlyOwner whenNotPaused public {
77     paused = true;
78     emit Pause();
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused public {
85     paused = false;
86     emit Unpause();
87   }
88 }
89 
90 pragma solidity ^0.4.23;
91 
92 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
93 contract PluginInterface
94 {
95     /// @dev simply a boolean to indicate this is the contract we expect to be
96     function isPluginInterface() public pure returns (bool);
97 
98     function onRemove() public;
99 
100     /// @dev Begins new feature.
101     /// @param _cutieId - ID of token to auction, sender must be owner.
102     /// @param _parameter - arbitrary parameter
103     /// @param _seller - Old owner, if not the message sender
104     function run(
105         uint40 _cutieId,
106         uint256 _parameter,
107         address _seller
108     ) 
109     public
110     payable;
111 
112     /// @dev Begins new feature, approved and signed by COO.
113     /// @param _cutieId - ID of token to auction, sender must be owner.
114     /// @param _parameter - arbitrary parameter
115     function runSigned(
116         uint40 _cutieId,
117         uint256 _parameter,
118         address _owner
119     )
120     external
121     payable;
122 
123     function withdraw() public;
124 }
125 
126 pragma solidity ^0.4.23;
127 
128 pragma solidity ^0.4.23;
129 
130 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
131 /// @author https://BlockChainArchitect.io
132 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
133 contract ConfigInterface
134 {
135     function isConfig() public pure returns (bool);
136 
137     function getCooldownIndexFromGeneration(uint16 _generation) public view returns (uint16);
138     
139     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) public view returns (uint40);
140 
141     function getCooldownIndexCount() public view returns (uint256);
142 
143     function getBabyGenFromId(uint40 _momId, uint40 _dadId) public view returns (uint16);
144     function getBabyGen(uint16 _momGen, uint16 _dadGen) public pure returns (uint16);
145 
146     function getTutorialBabyGen(uint16 _dadGen) public pure returns (uint16);
147 
148     function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);
149 }
150 
151 
152 contract CutieCoreInterface
153 {
154     function isCutieCore() pure public returns (bool);
155 
156     ConfigInterface public config;
157 
158     function transferFrom(address _from, address _to, uint256 _cutieId) external;
159     function transfer(address _to, uint256 _cutieId) external;
160 
161     function ownerOf(uint256 _cutieId)
162         external
163         view
164         returns (address owner);
165 
166     function getCutie(uint40 _id)
167         external
168         view
169         returns (
170         uint256 genes,
171         uint40 birthTime,
172         uint40 cooldownEndTime,
173         uint40 momId,
174         uint40 dadId,
175         uint16 cooldownIndex,
176         uint16 generation
177     );
178 
179     function getGenes(uint40 _id)
180         public
181         view
182         returns (
183         uint256 genes
184     );
185 
186 
187     function getCooldownEndTime(uint40 _id)
188         public
189         view
190         returns (
191         uint40 cooldownEndTime
192     );
193 
194     function getCooldownIndex(uint40 _id)
195         public
196         view
197         returns (
198         uint16 cooldownIndex
199     );
200 
201 
202     function getGeneration(uint40 _id)
203         public
204         view
205         returns (
206         uint16 generation
207     );
208 
209     function getOptional(uint40 _id)
210         public
211         view
212         returns (
213         uint64 optional
214     );
215 
216 
217     function changeGenes(
218         uint40 _cutieId,
219         uint256 _genes)
220         public;
221 
222     function changeCooldownEndTime(
223         uint40 _cutieId,
224         uint40 _cooldownEndTime)
225         public;
226 
227     function changeCooldownIndex(
228         uint40 _cutieId,
229         uint16 _cooldownIndex)
230         public;
231 
232     function changeOptional(
233         uint40 _cutieId,
234         uint64 _optional)
235         public;
236 
237     function changeGeneration(
238         uint40 _cutieId,
239         uint16 _generation)
240         public;
241 
242     function createSaleAuction(
243         uint40 _cutieId,
244         uint128 _startPrice,
245         uint128 _endPrice,
246         uint40 _duration
247     )
248     public;
249 
250     function getApproved(uint256 _tokenId) external returns (address);
251 
252     function totalSupply() view returns (uint256);
253     function createPromoCutie(uint256 _genes, address _owner);
254 }
255 
256 
257 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
258 contract CutiePluginBase is PluginInterface, Pausable
259 {
260     function isPluginInterface() public pure returns (bool)
261     {
262         return true;
263     }
264 
265     // Reference to contract tracking NFT ownership
266     CutieCoreInterface public coreContract;
267 
268     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
269     // Values 0-10,000 map to 0%-100%
270     uint16 public ownerFee;
271 
272     // @dev Throws if called by any account other than the owner.
273     modifier onlyCore() {
274         require(msg.sender == address(coreContract));
275         _;
276     }
277 
278     /// @dev Constructor creates a reference to the NFT ownership contract
279     ///  and verifies the owner cut is in the valid range.
280     /// @param _coreAddress - address of a deployed contract implementing
281     ///  the Nonfungible Interface.
282     /// @param _fee - percent cut the owner takes on each auction, must be
283     ///  between 0-10,000.
284     function setup(address _coreAddress, uint16 _fee) public {
285         require(_fee <= 10000);
286         require(msg.sender == owner);
287         ownerFee = _fee;
288         
289         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
290         require(candidateContract.isCutieCore());
291         coreContract = candidateContract;
292     }
293 
294     // @dev Set the owner's fee.
295     //  @param fee should be between 0-10,000.
296     function setFee(uint16 _fee) public
297     {
298         require(_fee <= 10000);
299         require(msg.sender == owner);
300 
301         ownerFee = _fee;
302     }
303 
304     /// @dev Returns true if the claimant owns the token.
305     /// @param _claimant - Address claiming to own the token.
306     /// @param _cutieId - ID of token whose ownership to verify.
307     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {
308         return (coreContract.ownerOf(_cutieId) == _claimant);
309     }
310 
311     /// @dev Escrows the NFT, assigning ownership to this contract.
312     /// Throws if the escrow fails.
313     /// @param _owner - Current owner address of token to escrow.
314     /// @param _cutieId - ID of token whose approval to verify.
315     function _escrow(address _owner, uint40 _cutieId) internal {
316         // it will throw if transfer fails
317         coreContract.transferFrom(_owner, this, _cutieId);
318     }
319 
320     /// @dev Transfers an NFT owned by this contract to another address.
321     /// Returns true if the transfer succeeds.
322     /// @param _receiver - Address to transfer NFT to.
323     /// @param _cutieId - ID of token to transfer.
324     function _transfer(address _receiver, uint40 _cutieId) internal {
325         // it will throw if transfer fails
326         coreContract.transfer(_receiver, _cutieId);
327     }
328 
329     /// @dev Computes owner's cut of a sale.
330     /// @param _price - Sale price of NFT.
331     function _computeFee(uint128 _price) internal view returns (uint128) {
332         // NOTE: We don't use SafeMath (or similar) in this function because
333         //  all of our entry functions carefully cap the maximum values for
334         //  currency (at 128-bits), and ownerFee <= 10000 (see the require()
335         //  statement in the ClockAuction constructor). The result of this
336         //  function is always guaranteed to be <= _price.
337         return _price * ownerFee / 10000;
338     }
339 
340     function withdraw() public
341     {
342         require(
343             msg.sender == owner ||
344             msg.sender == address(coreContract)
345         );
346         if (address(this).balance > 0)
347         {
348             address(coreContract).transfer(address(this).balance);
349         }
350     }
351 
352     function onRemove() public onlyCore
353     {
354         withdraw();
355     }
356 
357     function run(
358         uint40,
359         uint256,
360         address
361     ) 
362         public
363         payable
364         onlyCore
365     {
366         revert();
367     }
368 }
369 
370 
371 /// @title Item effect for Blockchain Cuties
372 /// @author https://BlockChainArchitect.io
373 contract CutieReward is CutiePluginBase
374 {
375     address public operatorAddress;
376 
377     function runSigned(
378         uint40/* _cutieId*/,
379         uint256/* _parameter*/,
380         address/* _sender*/
381     )
382         external
383         onlyCore
384         whenNotPaused
385         payable
386     {
387         revert();
388     }
389 
390     function setOperator(address _newOperator) external onlyOwner
391     {
392         operatorAddress = _newOperator;
393     }
394 
395     function setupCutie(uint40 cutieId, uint16 generation)
396         external
397         whenNotPaused
398     {
399         require(msg.sender == operatorAddress);
400 
401         coreContract.changeGeneration(cutieId, generation);
402         ConfigInterface config = coreContract.config();
403         uint16 cooldownIndex = config.getCooldownIndexFromGeneration(generation);
404         coreContract.changeCooldownIndex(cutieId, cooldownIndex);
405     }
406 }