1 pragma solidity ^0.4.20;
2 
3 
4 
5 
6 
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
25   function Ownable() public {
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
95 
96 
97 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
98 /// @author https://BlockChainArchitect.io
99 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
100 contract ConfigInterface
101 {
102     function isConfig() public pure returns (bool);
103 
104     function getCooldownIndexFromGeneration(uint16 _generation) public view returns (uint16);
105     
106     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) public view returns (uint40);
107 
108     function getCooldownIndexCount() public view returns (uint256);
109     
110     function getBabyGen(uint16 _momGen, uint16 _dadGen) public pure returns (uint16);
111 
112     function getTutorialBabyGen(uint16 _dadGen) public pure returns (uint16);
113 
114     function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);
115 }
116 
117 
118 
119 contract CutieCoreInterface
120 {
121     function isCutieCore() pure public returns (bool);
122 
123     function transferFrom(address _from, address _to, uint256 _cutieId) external;
124     function transfer(address _to, uint256 _cutieId) external;
125 
126     function ownerOf(uint256 _cutieId)
127         external
128         view
129         returns (address owner);
130 
131     function getCutie(uint40 _id)
132         external
133         view
134         returns (
135         uint256 genes,
136         uint40 birthTime,
137         uint40 cooldownEndTime,
138         uint40 momId,
139         uint40 dadId,
140         uint16 cooldownIndex,
141         uint16 generation
142     );
143 
144     function getGenes(uint40 _id)
145         public
146         view
147         returns (
148         uint256 genes
149     );
150 
151 
152     function getCooldownEndTime(uint40 _id)
153         public
154         view
155         returns (
156         uint40 cooldownEndTime
157     );
158 
159     function getCooldownIndex(uint40 _id)
160         public
161         view
162         returns (
163         uint16 cooldownIndex
164     );
165 
166 
167     function getGeneration(uint40 _id)
168         public
169         view
170         returns (
171         uint16 generation
172     );
173 
174     function getOptional(uint40 _id)
175         public
176         view
177         returns (
178         uint64 optional
179     );
180 
181 
182     function changeGenes(
183         uint40 _cutieId,
184         uint256 _genes)
185         public;
186 
187     function changeCooldownEndTime(
188         uint40 _cutieId,
189         uint40 _cooldownEndTime)
190         public;
191 
192     function changeCooldownIndex(
193         uint40 _cutieId,
194         uint16 _cooldownIndex)
195         public;
196 
197     function changeOptional(
198         uint40 _cutieId,
199         uint64 _optional)
200         public;
201 
202     function changeGeneration(
203         uint40 _cutieId,
204         uint16 _generation)
205         public;
206 }
207 
208 
209 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
210 /// @author https://BlockChainArchitect.io
211 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
212 
213 contract Config is Ownable, ConfigInterface
214 {
215 	function isConfig() public pure returns (bool)
216 	{
217 		return true;
218 	}
219 
220     /// @dev A lookup table that shows the cooldown duration after a successful
221     ///  breeding action, called "breeding cooldown". The cooldown roughly doubles each time
222     /// a cutie is bred, so that owners don't breed the same cutie continuously. Maximum cooldown is seven days.
223     uint32[14] public cooldowns = [
224         uint32(1 minutes),
225         uint32(2 minutes),
226         uint32(5 minutes),
227         uint32(10 minutes),
228         uint32(30 minutes),
229         uint32(1 hours),
230         uint32(2 hours),
231         uint32(4 hours),
232         uint32(8 hours),
233         uint32(16 hours),
234         uint32(1 days),
235         uint32(2 days),
236         uint32(4 days),
237         uint32(7 days)
238     ];
239 
240 /*    function setCooldown(uint16 index, uint32 newCooldown) public onlyOwner
241     {
242         cooldowns[index] = newCooldown;
243     }*/
244 
245     CutieCoreInterface public coreContract;
246 
247     function setup(address _coreAddress) public onlyOwner
248     {
249         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
250         require(candidateContract.isCutieCore());
251         coreContract = candidateContract;
252     }
253 
254     function getCooldownIndexFromGeneration(uint16 _generation) public view returns (uint16)
255     {
256         uint16 result = _generation;
257         if (result >= getCooldownIndexCount()) {
258             result = uint16(getCooldownIndexCount() - 1);
259         }
260         return result;
261     }
262 
263     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) public view returns (uint40)
264     {
265         return uint40(now + cooldowns[_cooldownIndex]);
266     }
267 
268     function getCooldownIndexCount() public view returns (uint256)
269     {
270         return cooldowns.length;
271     }
272 
273     function getBabyGen(uint16 _momGen, uint16 _dadGen) public pure returns (uint16)
274     {
275         uint16 babyGen = _momGen;
276         if (_dadGen > _momGen) {
277             babyGen = _dadGen;
278         }
279         babyGen = babyGen + 1;
280         return babyGen;
281     }
282 
283     function getTutorialBabyGen(uint16 _dadGen) public pure returns (uint16)
284     {
285         // Tutorial pet gen is 0
286         return getBabyGen(0, _dadGen);
287     }
288 
289     function getBreedingFee(uint40 _momId, uint40 _dadId)
290         public
291         view
292         returns (uint256)
293     {
294         uint16 momGen = coreContract.getGeneration(_momId);
295         uint16 dadGen = coreContract.getGeneration(_dadId);
296         uint16 momCooldown = coreContract.getCooldownIndex(_momId);
297         uint16 dadCooldown = coreContract.getCooldownIndex(_dadId);
298 
299         uint256 sum = uint256(momCooldown) + dadCooldown - momGen - dadGen;
300         return 1 finney + 3 szabo*sum*sum;
301     }
302 }