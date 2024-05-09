1 pragma solidity ^0.4.21;
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
20   function Ownable() public {
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
90 pragma solidity ^0.4.20;
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
126 pragma solidity ^0.4.20;
127 
128 contract CutieCoreInterface
129 {
130     function isCutieCore() pure public returns (bool);
131 
132     function transferFrom(address _from, address _to, uint256 _cutieId) external;
133     function transfer(address _to, uint256 _cutieId) external;
134 
135     function ownerOf(uint256 _cutieId)
136         external
137         view
138         returns (address owner);
139 
140     function getCutie(uint40 _id)
141         external
142         view
143         returns (
144         uint256 genes,
145         uint40 birthTime,
146         uint40 cooldownEndTime,
147         uint40 momId,
148         uint40 dadId,
149         uint16 cooldownIndex,
150         uint16 generation
151     );
152 
153     function getGenes(uint40 _id)
154         public
155         view
156         returns (
157         uint256 genes
158     );
159 
160 
161     function getCooldownEndTime(uint40 _id)
162         public
163         view
164         returns (
165         uint40 cooldownEndTime
166     );
167 
168     function getCooldownIndex(uint40 _id)
169         public
170         view
171         returns (
172         uint16 cooldownIndex
173     );
174 
175 
176     function getGeneration(uint40 _id)
177         public
178         view
179         returns (
180         uint16 generation
181     );
182 
183     function getOptional(uint40 _id)
184         public
185         view
186         returns (
187         uint64 optional
188     );
189 
190 
191     function changeGenes(
192         uint40 _cutieId,
193         uint256 _genes)
194         public;
195 
196     function changeCooldownEndTime(
197         uint40 _cutieId,
198         uint40 _cooldownEndTime)
199         public;
200 
201     function changeCooldownIndex(
202         uint40 _cutieId,
203         uint16 _cooldownIndex)
204         public;
205 
206     function changeOptional(
207         uint40 _cutieId,
208         uint64 _optional)
209         public;
210 
211     function changeGeneration(
212         uint40 _cutieId,
213         uint16 _generation)
214         public;
215 }
216 
217 
218 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
219 contract CutiePluginBase is PluginInterface, Pausable
220 {
221     function isPluginInterface() public pure returns (bool)
222     {
223         return true;
224     }
225 
226     // Reference to contract tracking NFT ownership
227     CutieCoreInterface public coreContract;
228 
229     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
230     // Values 0-10,000 map to 0%-100%
231     uint16 public ownerFee;
232 
233     // @dev Throws if called by any account other than the owner.
234     modifier onlyCore() {
235         require(msg.sender == address(coreContract));
236         _;
237     }
238 
239     /// @dev Constructor creates a reference to the NFT ownership contract
240     ///  and verifies the owner cut is in the valid range.
241     /// @param _coreAddress - address of a deployed contract implementing
242     ///  the Nonfungible Interface.
243     /// @param _fee - percent cut the owner takes on each auction, must be
244     ///  between 0-10,000.
245     function setup(address _coreAddress, uint16 _fee) public {
246         require(_fee <= 10000);
247         require(msg.sender == owner);
248         ownerFee = _fee;
249         
250         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
251         require(candidateContract.isCutieCore());
252         coreContract = candidateContract;
253     }
254 
255     // @dev Set the owner's fee.
256     //  @param fee should be between 0-10,000.
257     function setFee(uint16 _fee) public
258     {
259         require(_fee <= 10000);
260         require(msg.sender == owner);
261 
262         ownerFee = _fee;
263     }
264 
265     /// @dev Returns true if the claimant owns the token.
266     /// @param _claimant - Address claiming to own the token.
267     /// @param _cutieId - ID of token whose ownership to verify.
268     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {
269         return (coreContract.ownerOf(_cutieId) == _claimant);
270     }
271 
272     /// @dev Escrows the NFT, assigning ownership to this contract.
273     /// Throws if the escrow fails.
274     /// @param _owner - Current owner address of token to escrow.
275     /// @param _cutieId - ID of token whose approval to verify.
276     function _escrow(address _owner, uint40 _cutieId) internal {
277         // it will throw if transfer fails
278         coreContract.transferFrom(_owner, this, _cutieId);
279     }
280 
281     /// @dev Transfers an NFT owned by this contract to another address.
282     /// Returns true if the transfer succeeds.
283     /// @param _receiver - Address to transfer NFT to.
284     /// @param _cutieId - ID of token to transfer.
285     function _transfer(address _receiver, uint40 _cutieId) internal {
286         // it will throw if transfer fails
287         coreContract.transfer(_receiver, _cutieId);
288     }
289 
290     /// @dev Computes owner's cut of a sale.
291     /// @param _price - Sale price of NFT.
292     function _computeFee(uint128 _price) internal view returns (uint128) {
293         // NOTE: We don't use SafeMath (or similar) in this function because
294         //  all of our entry functions carefully cap the maximum values for
295         //  currency (at 128-bits), and ownerFee <= 10000 (see the require()
296         //  statement in the ClockAuction constructor). The result of this
297         //  function is always guaranteed to be <= _price.
298         return _price * ownerFee / 10000;
299     }
300 
301     function withdraw() public
302     {
303         require(
304             msg.sender == owner ||
305             msg.sender == address(coreContract)
306         );
307         if (address(this).balance > 0)
308         {
309             address(coreContract).transfer(address(this).balance);
310         }
311     }
312 
313     function onRemove() public onlyCore
314     {
315         withdraw();
316     }
317 
318     function run(
319         uint40,
320         uint256,
321         address
322     ) 
323         public
324         payable
325         onlyCore
326     {
327         revert();
328     }
329 }
330 
331 
332 /// @title Item effect for Blockchain Cuties
333 /// @author https://BlockChainArchitect.io
334 contract CutieReward is CutiePluginBase
335 {
336     address public operatorAddress;
337 
338     function runSigned(
339         uint40/* _cutieId*/,
340         uint256/* _parameter*/,
341         address/* _sender*/
342     )
343         external
344         onlyCore
345         whenNotPaused
346         payable
347     {
348         revert();
349     }
350 
351     function setOperator(address _newOperator) external onlyOwner
352     {
353         operatorAddress = _newOperator;
354     }
355 
356     function setupCutie(uint40 cutieId, uint16 generation)
357         external
358         whenNotPaused
359     {
360         require(msg.sender == operatorAddress);
361 
362         coreContract.changeGeneration(cutieId, generation);
363         coreContract.changeCooldownIndex(cutieId, generation);
364     }
365 }