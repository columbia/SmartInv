1 pragma solidity ^0.4.23;
2 
3 pragma solidity ^0.4.23;
4 
5 
6 pragma solidity ^0.4.23;
7 
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 
50 
51 /**
52  * @title Pausable
53  * @dev Base contract which allows children to implement an emergency stop mechanism.
54  */
55 contract Pausable is Ownable {
56   event Pause();
57   event Unpause();
58 
59   bool public paused = false;
60 
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is not paused.
64    */
65   modifier whenNotPaused() {
66     require(!paused);
67     _;
68   }
69 
70   /**
71    * @dev Modifier to make a function callable only when the contract is paused.
72    */
73   modifier whenPaused() {
74     require(paused);
75     _;
76   }
77 
78   /**
79    * @dev called by the owner to pause, triggers stopped state
80    */
81   function pause() onlyOwner whenNotPaused public {
82     paused = true;
83     emit Pause();
84   }
85 
86   /**
87    * @dev called by the owner to unpause, returns to normal state
88    */
89   function unpause() onlyOwner whenPaused public {
90     paused = false;
91     emit Unpause();
92   }
93 }
94 
95 pragma solidity ^0.4.23;
96 
97 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
98 /// @author https://BlockChainArchitect.io
99 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
100 interface ConfigInterface
101 {
102     function isConfig() external pure returns (bool);
103 
104     function getCooldownIndexFromGeneration(uint16 _generation, uint40 _cutieId) external view returns (uint16);
105     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex, uint40 _cutieId) external view returns (uint40);
106     function getCooldownIndexFromGeneration(uint16 _generation) external view returns (uint16);
107     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) external view returns (uint40);
108 
109     function getCooldownIndexCount() external view returns (uint256);
110 
111     function getBabyGenFromId(uint40 _momId, uint40 _dadId) external view returns (uint16);
112     function getBabyGen(uint16 _momGen, uint16 _dadGen) external pure returns (uint16);
113 
114     function getTutorialBabyGen(uint16 _dadGen) external pure returns (uint16);
115 
116     function getBreedingFee(uint40 _momId, uint40 _dadId) external view returns (uint256);
117 }
118 
119 pragma solidity ^0.4.23;
120 
121 
122 
123 contract CutieCoreInterface
124 {
125     function isCutieCore() pure public returns (bool);
126 
127     ConfigInterface public config;
128 
129     function transferFrom(address _from, address _to, uint256 _cutieId) external;
130     function transfer(address _to, uint256 _cutieId) external;
131 
132     function ownerOf(uint256 _cutieId)
133         external
134         view
135         returns (address owner);
136 
137     function getCutie(uint40 _id)
138         external
139         view
140         returns (
141         uint256 genes,
142         uint40 birthTime,
143         uint40 cooldownEndTime,
144         uint40 momId,
145         uint40 dadId,
146         uint16 cooldownIndex,
147         uint16 generation
148     );
149 
150     function getGenes(uint40 _id)
151         public
152         view
153         returns (
154         uint256 genes
155     );
156 
157 
158     function getCooldownEndTime(uint40 _id)
159         public
160         view
161         returns (
162         uint40 cooldownEndTime
163     );
164 
165     function getCooldownIndex(uint40 _id)
166         public
167         view
168         returns (
169         uint16 cooldownIndex
170     );
171 
172 
173     function getGeneration(uint40 _id)
174         public
175         view
176         returns (
177         uint16 generation
178     );
179 
180     function getOptional(uint40 _id)
181         public
182         view
183         returns (
184         uint64 optional
185     );
186 
187 
188     function changeGenes(
189         uint40 _cutieId,
190         uint256 _genes)
191         public;
192 
193     function changeCooldownEndTime(
194         uint40 _cutieId,
195         uint40 _cooldownEndTime)
196         public;
197 
198     function changeCooldownIndex(
199         uint40 _cutieId,
200         uint16 _cooldownIndex)
201         public;
202 
203     function changeOptional(
204         uint40 _cutieId,
205         uint64 _optional)
206         public;
207 
208     function changeGeneration(
209         uint40 _cutieId,
210         uint16 _generation)
211         public;
212 
213     function createSaleAuction(
214         uint40 _cutieId,
215         uint128 _startPrice,
216         uint128 _endPrice,
217         uint40 _duration
218     )
219     public;
220 
221     function getApproved(uint256 _tokenId) external returns (address);
222     function totalSupply() view external returns (uint256);
223     function createPromoCutie(uint256 _genes, address _owner) external;
224     function checkOwnerAndApprove(address _claimant, uint40 _cutieId, address _pluginsContract) external view;
225     function breedWith(uint40 _momId, uint40 _dadId) public payable returns (uint40);
226     function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);
227 }
228 
229 
230 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
231 /// @author https://BlockChainArchitect.io
232 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
233 
234 contract Config is Ownable, ConfigInterface
235 {
236     mapping(uint40 => bool) public freeBreeding;
237 
238 	function isConfig() external pure returns (bool)
239 	{
240 		return true;
241 	}
242 
243     /// @dev A lookup table that shows the cooldown duration after a successful
244     ///  breeding action, called "breeding cooldown". The cooldown roughly doubles each time
245     /// a cutie is bred, so that owners don't breed the same cutie continuously. Maximum cooldown is seven days.
246     uint32[14] public cooldowns = [
247         uint32(1 minutes),
248         uint32(2 minutes),
249         uint32(5 minutes),
250         uint32(10 minutes),
251         uint32(30 minutes),
252         uint32(1 hours),
253         uint32(2 hours),
254         uint32(4 hours),
255         uint32(8 hours),
256         uint32(16 hours),
257         uint32(1 days),
258         uint32(2 days),
259         uint32(4 days),
260         uint32(7 days)
261     ];
262 
263 /*    function setCooldown(uint16 index, uint32 newCooldown) public onlyOwner
264     {
265         cooldowns[index] = newCooldown;
266     }*/
267 
268     CutieCoreInterface public coreContract;
269 
270     function setup(address _coreAddress) external onlyOwner
271     {
272         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
273         require(candidateContract.isCutieCore());
274         coreContract = candidateContract;
275     }
276 
277     function getCooldownIndexFromGeneration(uint16 _generation, uint40 /*_cutieId*/) external view returns (uint16)
278     {
279         return getCooldownIndexFromGeneration(_generation);
280     }
281 
282     function getCooldownIndexFromGeneration(uint16 _generation) public view returns (uint16)
283     {
284         uint16 result = _generation;
285         if (result >= cooldowns.length) {
286             result = uint16(cooldowns.length - 1);
287         }
288         return result;
289     }
290 
291     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) public view returns (uint40)
292     {
293         return uint40(now + cooldowns[_cooldownIndex]);
294     }
295 
296     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex, uint40 /*_cutieId*/) external view returns (uint40)
297     {
298         return getCooldownEndTimeFromIndex(_cooldownIndex);
299     }
300 
301     function getCooldownIndexCount() public view returns (uint256)
302     {
303         return cooldowns.length;
304     }
305 
306     function getBabyGenFromId(uint40 _momId, uint40 _dadId) external view returns (uint16)
307     {
308         uint16 momGen = coreContract.getGeneration(_momId);
309         uint16 dadGen = coreContract.getGeneration(_dadId);
310 
311         return getBabyGen(momGen, dadGen);
312     }
313 
314     function getBabyGen(uint16 _momGen, uint16 _dadGen) public pure returns (uint16)
315     {
316         uint16 babyGen = _momGen;
317         if (_dadGen > _momGen) {
318             babyGen = _dadGen;
319         }
320         babyGen = babyGen + 1;
321         return babyGen;
322     }
323 
324     function getTutorialBabyGen(uint16 _dadGen) external pure returns (uint16)
325     {
326         // Tutorial pet gen is 1
327         return getBabyGen(1, _dadGen);
328     }
329 
330     function getBreedingFee(uint40 _momId, uint40 _dadId)
331         external
332         view
333         returns (uint256)
334     {
335         if (freeBreeding[_momId] || freeBreeding[_dadId])
336         {
337             return 0;
338         }
339 
340         uint16 momGen = coreContract.getGeneration(_momId);
341         uint16 dadGen = coreContract.getGeneration(_dadId);
342         uint16 momCooldown = coreContract.getCooldownIndex(_momId);
343         uint16 dadCooldown = coreContract.getCooldownIndex(_dadId);
344 
345         uint256 sum = uint256(momCooldown) + dadCooldown - momGen - dadGen;
346         return 1 finney + 3 szabo*sum*sum;
347     }
348 
349     function setFreeBreeding(uint40 _cutieId) external onlyOwner
350     {
351         freeBreeding[_cutieId] = true;
352     }
353 
354     function removeFreeBreeding(uint40 _cutieId) external onlyOwner
355     {
356         delete freeBreeding[_cutieId];
357     }
358 }