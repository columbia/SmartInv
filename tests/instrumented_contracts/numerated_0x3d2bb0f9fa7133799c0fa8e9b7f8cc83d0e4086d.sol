1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90 
91 pragma solidity ^0.4.20;
92 
93 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
94 contract PluginInterface
95 {
96     /// @dev simply a boolean to indicate this is the contract we expect to be
97     function isPluginInterface() public pure returns (bool);
98 
99     function onRemove() public;
100 
101     /// @dev Begins new feature.
102     /// @param _cutieId - ID of token to auction, sender must be owner.
103     /// @param _parameter - arbitrary parameter
104     /// @param _seller - Old owner, if not the message sender
105     function run(
106         uint40 _cutieId,
107         uint256 _parameter,
108         address _seller
109     ) 
110     public
111     payable;
112 
113     /// @dev Begins new feature, approved and signed by COO.
114     /// @param _cutieId - ID of token to auction, sender must be owner.
115     /// @param _parameter - arbitrary parameter
116     function runSigned(
117         uint40 _cutieId,
118         uint256 _parameter,
119         address _owner
120     )
121     external
122     payable;
123 
124     function withdraw() public;
125 }
126 
127 pragma solidity ^0.4.20;
128 
129 contract CutieCoreInterface
130 {
131     function isCutieCore() pure public returns (bool);
132 
133     function transferFrom(address _from, address _to, uint256 _cutieId) external;
134     function transfer(address _to, uint256 _cutieId) external;
135 
136     function ownerOf(uint256 _cutieId)
137         external
138         view
139         returns (address owner);
140 
141     function getCutie(uint40 _id)
142         external
143         view
144         returns (
145         uint256 genes,
146         uint40 birthTime,
147         uint40 cooldownEndTime,
148         uint40 momId,
149         uint40 dadId,
150         uint16 cooldownIndex,
151         uint16 generation
152     );
153 
154     function getGenes(uint40 _id)
155         public
156         view
157         returns (
158         uint256 genes
159     );
160 
161 
162     function getCooldownEndTime(uint40 _id)
163         public
164         view
165         returns (
166         uint40 cooldownEndTime
167     );
168 
169     function getCooldownIndex(uint40 _id)
170         public
171         view
172         returns (
173         uint16 cooldownIndex
174     );
175 
176 
177     function getGeneration(uint40 _id)
178         public
179         view
180         returns (
181         uint16 generation
182     );
183 
184     function getOptional(uint40 _id)
185         public
186         view
187         returns (
188         uint64 optional
189     );
190 
191 
192     function changeGenes(
193         uint40 _cutieId,
194         uint256 _genes)
195         public;
196 
197     function changeCooldownEndTime(
198         uint40 _cutieId,
199         uint40 _cooldownEndTime)
200         public;
201 
202     function changeCooldownIndex(
203         uint40 _cutieId,
204         uint16 _cooldownIndex)
205         public;
206 
207     function changeOptional(
208         uint40 _cutieId,
209         uint64 _optional)
210         public;
211 
212     function changeGeneration(
213         uint40 _cutieId,
214         uint16 _generation)
215         public;
216 }
217 
218 
219 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
220 contract CutiePluginBase is PluginInterface, Pausable
221 {
222     function isPluginInterface() public pure returns (bool)
223     {
224         return true;
225     }
226 
227     // Reference to contract tracking NFT ownership
228     CutieCoreInterface public coreContract;
229 
230     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
231     // Values 0-10,000 map to 0%-100%
232     uint16 public ownerFee;
233 
234     // @dev Throws if called by any account other than the owner.
235     modifier onlyCore() {
236         require(msg.sender == address(coreContract));
237         _;
238     }
239 
240     /// @dev Constructor creates a reference to the NFT ownership contract
241     ///  and verifies the owner cut is in the valid range.
242     /// @param _coreAddress - address of a deployed contract implementing
243     ///  the Nonfungible Interface.
244     /// @param _fee - percent cut the owner takes on each auction, must be
245     ///  between 0-10,000.
246     function setup(address _coreAddress, uint16 _fee) public {
247         require(_fee <= 10000);
248         require(msg.sender == owner);
249         ownerFee = _fee;
250         
251         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
252         require(candidateContract.isCutieCore());
253         coreContract = candidateContract;
254     }
255 
256     // @dev Set the owner's fee.
257     //  @param fee should be between 0-10,000.
258     function setFee(uint16 _fee) public
259     {
260         require(_fee <= 10000);
261         require(msg.sender == owner);
262 
263         ownerFee = _fee;
264     }
265 
266     /// @dev Returns true if the claimant owns the token.
267     /// @param _claimant - Address claiming to own the token.
268     /// @param _cutieId - ID of token whose ownership to verify.
269     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {
270         return (coreContract.ownerOf(_cutieId) == _claimant);
271     }
272 
273     /// @dev Escrows the NFT, assigning ownership to this contract.
274     /// Throws if the escrow fails.
275     /// @param _owner - Current owner address of token to escrow.
276     /// @param _cutieId - ID of token whose approval to verify.
277     function _escrow(address _owner, uint40 _cutieId) internal {
278         // it will throw if transfer fails
279         coreContract.transferFrom(_owner, this, _cutieId);
280     }
281 
282     /// @dev Transfers an NFT owned by this contract to another address.
283     /// Returns true if the transfer succeeds.
284     /// @param _receiver - Address to transfer NFT to.
285     /// @param _cutieId - ID of token to transfer.
286     function _transfer(address _receiver, uint40 _cutieId) internal {
287         // it will throw if transfer fails
288         coreContract.transfer(_receiver, _cutieId);
289     }
290 
291     /// @dev Computes owner's cut of a sale.
292     /// @param _price - Sale price of NFT.
293     function _computeFee(uint128 _price) internal view returns (uint128) {
294         // NOTE: We don't use SafeMath (or similar) in this function because
295         //  all of our entry functions carefully cap the maximum values for
296         //  currency (at 128-bits), and ownerFee <= 10000 (see the require()
297         //  statement in the ClockAuction constructor). The result of this
298         //  function is always guaranteed to be <= _price.
299         return _price * ownerFee / 10000;
300     }
301 
302     function withdraw() public
303     {
304         require(
305             msg.sender == owner ||
306             msg.sender == address(coreContract)
307         );
308         if (address(this).balance > 0)
309         {
310             address(coreContract).transfer(address(this).balance);
311         }
312     }
313 
314     function onRemove() public onlyCore
315     {
316         withdraw();
317     }
318 
319     function run(
320         uint40,
321         uint256,
322         address
323     ) 
324         public
325         payable
326         onlyCore
327     {
328         revert();
329     }
330 }
331 
332 
333 /// @dev Receives payments for payd features from players for Blockchain Cuties
334 /// @author https://BlockChainArchitect.io
335 contract Lottery is CutiePluginBase
336 {
337     function run(
338         uint40,
339         uint256,
340         address
341     )
342     public
343     payable
344     onlyCore
345     {
346         // just accept bid
347     }
348 
349     function runSigned(uint40, uint256, address)
350     external
351     payable
352     onlyCore
353     {
354         // just accept bid
355     }
356 }