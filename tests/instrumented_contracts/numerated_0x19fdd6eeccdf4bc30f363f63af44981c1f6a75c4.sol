1 pragma solidity ^0.4.24;
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
90 pragma solidity ^0.4.24;
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
126 pragma solidity ^0.4.24;
127 
128 pragma solidity ^0.4.24;
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
143     function getBabyGen(uint16 _momGen, uint16 _dadGen) public pure returns (uint16);
144 
145     function getTutorialBabyGen(uint16 _dadGen) public pure returns (uint16);
146 
147     function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);
148 }
149 
150 
151 contract CutieCoreInterface
152 {
153     function isCutieCore() pure public returns (bool);
154 
155     ConfigInterface public config;
156 
157     function transferFrom(address _from, address _to, uint256 _cutieId) external;
158     function transfer(address _to, uint256 _cutieId) external;
159 
160     function ownerOf(uint256 _cutieId)
161         external
162         view
163         returns (address owner);
164 
165     function getCutie(uint40 _id)
166         external
167         view
168         returns (
169         uint256 genes,
170         uint40 birthTime,
171         uint40 cooldownEndTime,
172         uint40 momId,
173         uint40 dadId,
174         uint16 cooldownIndex,
175         uint16 generation
176     );
177 
178     function getGenes(uint40 _id)
179         public
180         view
181         returns (
182         uint256 genes
183     );
184 
185 
186     function getCooldownEndTime(uint40 _id)
187         public
188         view
189         returns (
190         uint40 cooldownEndTime
191     );
192 
193     function getCooldownIndex(uint40 _id)
194         public
195         view
196         returns (
197         uint16 cooldownIndex
198     );
199 
200 
201     function getGeneration(uint40 _id)
202         public
203         view
204         returns (
205         uint16 generation
206     );
207 
208     function getOptional(uint40 _id)
209         public
210         view
211         returns (
212         uint64 optional
213     );
214 
215 
216     function changeGenes(
217         uint40 _cutieId,
218         uint256 _genes)
219         public;
220 
221     function changeCooldownEndTime(
222         uint40 _cutieId,
223         uint40 _cooldownEndTime)
224         public;
225 
226     function changeCooldownIndex(
227         uint40 _cutieId,
228         uint16 _cooldownIndex)
229         public;
230 
231     function changeOptional(
232         uint40 _cutieId,
233         uint64 _optional)
234         public;
235 
236     function changeGeneration(
237         uint40 _cutieId,
238         uint16 _generation)
239         public;
240 
241     function createSaleAuction(
242         uint40 _cutieId,
243         uint128 _startPrice,
244         uint128 _endPrice,
245         uint40 _duration
246     )
247     public;
248 
249     function getApproved(uint256 _tokenId) external returns (address);
250 }
251 
252 
253 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
254 contract CutiePluginBase is PluginInterface, Pausable
255 {
256     function isPluginInterface() public pure returns (bool)
257     {
258         return true;
259     }
260 
261     // Reference to contract tracking NFT ownership
262     CutieCoreInterface public coreContract;
263 
264     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
265     // Values 0-10,000 map to 0%-100%
266     uint16 public ownerFee;
267 
268     // @dev Throws if called by any account other than the owner.
269     modifier onlyCore() {
270         require(msg.sender == address(coreContract));
271         _;
272     }
273 
274     /// @dev Constructor creates a reference to the NFT ownership contract
275     ///  and verifies the owner cut is in the valid range.
276     /// @param _coreAddress - address of a deployed contract implementing
277     ///  the Nonfungible Interface.
278     /// @param _fee - percent cut the owner takes on each auction, must be
279     ///  between 0-10,000.
280     function setup(address _coreAddress, uint16 _fee) public {
281         require(_fee <= 10000);
282         require(msg.sender == owner);
283         ownerFee = _fee;
284         
285         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
286         require(candidateContract.isCutieCore());
287         coreContract = candidateContract;
288     }
289 
290     // @dev Set the owner's fee.
291     //  @param fee should be between 0-10,000.
292     function setFee(uint16 _fee) public
293     {
294         require(_fee <= 10000);
295         require(msg.sender == owner);
296 
297         ownerFee = _fee;
298     }
299 
300     /// @dev Returns true if the claimant owns the token.
301     /// @param _claimant - Address claiming to own the token.
302     /// @param _cutieId - ID of token whose ownership to verify.
303     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {
304         return (coreContract.ownerOf(_cutieId) == _claimant);
305     }
306 
307     /// @dev Escrows the NFT, assigning ownership to this contract.
308     /// Throws if the escrow fails.
309     /// @param _owner - Current owner address of token to escrow.
310     /// @param _cutieId - ID of token whose approval to verify.
311     function _escrow(address _owner, uint40 _cutieId) internal {
312         // it will throw if transfer fails
313         coreContract.transferFrom(_owner, this, _cutieId);
314     }
315 
316     /// @dev Transfers an NFT owned by this contract to another address.
317     /// Returns true if the transfer succeeds.
318     /// @param _receiver - Address to transfer NFT to.
319     /// @param _cutieId - ID of token to transfer.
320     function _transfer(address _receiver, uint40 _cutieId) internal {
321         // it will throw if transfer fails
322         coreContract.transfer(_receiver, _cutieId);
323     }
324 
325     /// @dev Computes owner's cut of a sale.
326     /// @param _price - Sale price of NFT.
327     function _computeFee(uint128 _price) internal view returns (uint128) {
328         // NOTE: We don't use SafeMath (or similar) in this function because
329         //  all of our entry functions carefully cap the maximum values for
330         //  currency (at 128-bits), and ownerFee <= 10000 (see the require()
331         //  statement in the ClockAuction constructor). The result of this
332         //  function is always guaranteed to be <= _price.
333         return _price * ownerFee / 10000;
334     }
335 
336     function withdraw() public
337     {
338         require(
339             msg.sender == owner ||
340             msg.sender == address(coreContract)
341         );
342         if (address(this).balance > 0)
343         {
344             address(coreContract).transfer(address(this).balance);
345         }
346     }
347 
348     function onRemove() public onlyCore
349     {
350         withdraw();
351     }
352 
353     function run(
354         uint40,
355         uint256,
356         address
357     ) 
358         public
359         payable
360         onlyCore
361     {
362         revert();
363     }
364 }
365 
366 
367 /// @dev Receives payments for payd features from players for Blockchain Cuties
368 /// @author https://BlockChainArchitect.io
369 contract BuyEnergy is CutiePluginBase
370 {
371     function run(
372         uint40,
373         uint256,
374         address
375     )
376         public
377         payable
378         onlyCore
379     {
380         revert();
381     }
382 
383     function runSigned(uint40, uint256, address)
384         external
385         payable
386         onlyCore
387     {
388         // just accept payments
389     }
390 }