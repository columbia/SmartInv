1 pragma solidity ^0.4.20;
2 
3 
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     emit OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 
48 /**
49  * @title Pausable
50  * @dev Base contract which allows children to implement an emergency stop mechanism.
51  */
52 contract Pausable is Ownable {
53   event Pause();
54   event Unpause();
55 
56   bool public paused = false;
57 
58 
59   /**
60    * @dev Modifier to make a function callable only when the contract is not paused.
61    */
62   modifier whenNotPaused() {
63     require(!paused);
64     _;
65   }
66 
67   /**
68    * @dev Modifier to make a function callable only when the contract is paused.
69    */
70   modifier whenPaused() {
71     require(paused);
72     _;
73   }
74 
75   /**
76    * @dev called by the owner to pause, triggers stopped state
77    */
78   function pause() onlyOwner whenNotPaused public {
79     paused = true;
80     emit Pause();
81   }
82 
83   /**
84    * @dev called by the owner to unpause, returns to normal state
85    */
86   function unpause() onlyOwner whenPaused public {
87     paused = false;
88     emit Unpause();
89   }
90 }
91 
92 
93 
94 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
95 contract PluginInterface
96 {
97     /// @dev simply a boolean to indicate this is the contract we expect to be
98     function isPluginInterface() public pure returns (bool);
99 
100     function onRemove() public;
101 
102     /// @dev Begins new feature.
103     /// @param _cutieId - ID of token to auction, sender must be owner.
104     /// @param _parameter - arbitrary parameter
105     /// @param _seller - Old owner, if not the message sender
106     function run(
107         uint40 _cutieId,
108         uint256 _parameter,
109         address _seller
110     ) 
111     public
112     payable;
113 
114     /// @dev Begins new feature, approved and signed by COO.
115     /// @param _cutieId - ID of token to auction, sender must be owner.
116     /// @param _parameter - arbitrary parameter
117     function runSigned(
118         uint40 _cutieId,
119         uint256 _parameter,
120         address _owner
121     )
122     external
123     payable;
124 
125     function withdraw() public;
126 }
127 
128 
129 
130 contract CutieCoreInterface
131 {
132     function isCutieCore() pure public returns (bool);
133 
134     function transferFrom(address _from, address _to, uint256 _cutieId) external;
135     function transfer(address _to, uint256 _cutieId) external;
136 
137     function ownerOf(uint256 _cutieId)
138         external
139         view
140         returns (address owner);
141 
142     function getCutie(uint40 _id)
143         external
144         view
145         returns (
146         uint256 genes,
147         uint40 birthTime,
148         uint40 cooldownEndTime,
149         uint40 momId,
150         uint40 dadId,
151         uint16 cooldownIndex,
152         uint16 generation
153     );
154 
155     function getGenes(uint40 _id)
156         public
157         view
158         returns (
159         uint256 genes
160     );
161 
162 
163     function getCooldownEndTime(uint40 _id)
164         public
165         view
166         returns (
167         uint40 cooldownEndTime
168     );
169 
170     function getCooldownIndex(uint40 _id)
171         public
172         view
173         returns (
174         uint16 cooldownIndex
175     );
176 
177 
178     function getGeneration(uint40 _id)
179         public
180         view
181         returns (
182         uint16 generation
183     );
184 
185     function getOptional(uint40 _id)
186         public
187         view
188         returns (
189         uint64 optional
190     );
191 
192 
193     function changeGenes(
194         uint40 _cutieId,
195         uint256 _genes)
196         public;
197 
198     function changeCooldownEndTime(
199         uint40 _cutieId,
200         uint40 _cooldownEndTime)
201         public;
202 
203     function changeCooldownIndex(
204         uint40 _cutieId,
205         uint16 _cooldownIndex)
206         public;
207 
208     function changeOptional(
209         uint40 _cutieId,
210         uint64 _optional)
211         public;
212 
213     function changeGeneration(
214         uint40 _cutieId,
215         uint16 _generation)
216         public;
217 }
218 
219 
220 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
221 contract CutiePluginBase is PluginInterface, Pausable
222 {
223     function isPluginInterface() public pure returns (bool)
224     {
225         return true;
226     }
227 
228     // Reference to contract tracking NFT ownership
229     CutieCoreInterface public coreContract;
230 
231     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
232     // Values 0-10,000 map to 0%-100%
233     uint16 public ownerFee;
234 
235     // @dev Throws if called by any account other than the owner.
236     modifier onlyCore() {
237         require(msg.sender == address(coreContract));
238         _;
239     }
240 
241     /// @dev Constructor creates a reference to the NFT ownership contract
242     ///  and verifies the owner cut is in the valid range.
243     /// @param _coreAddress - address of a deployed contract implementing
244     ///  the Nonfungible Interface.
245     /// @param _fee - percent cut the owner takes on each auction, must be
246     ///  between 0-10,000.
247     function setup(address _coreAddress, uint16 _fee) public {
248         require(_fee <= 10000);
249         require(msg.sender == owner);
250         ownerFee = _fee;
251         
252         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
253         require(candidateContract.isCutieCore());
254         coreContract = candidateContract;
255     }
256 
257     // @dev Set the owner's fee.
258     //  @param fee should be between 0-10,000.
259     function setFee(uint16 _fee) public
260     {
261         require(_fee <= 10000);
262         require(msg.sender == owner);
263 
264         ownerFee = _fee;
265     }
266 
267     /// @dev Returns true if the claimant owns the token.
268     /// @param _claimant - Address claiming to own the token.
269     /// @param _cutieId - ID of token whose ownership to verify.
270     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {
271         return (coreContract.ownerOf(_cutieId) == _claimant);
272     }
273 
274     /// @dev Escrows the NFT, assigning ownership to this contract.
275     /// Throws if the escrow fails.
276     /// @param _owner - Current owner address of token to escrow.
277     /// @param _cutieId - ID of token whose approval to verify.
278     function _escrow(address _owner, uint40 _cutieId) internal {
279         // it will throw if transfer fails
280         coreContract.transferFrom(_owner, this, _cutieId);
281     }
282 
283     /// @dev Transfers an NFT owned by this contract to another address.
284     /// Returns true if the transfer succeeds.
285     /// @param _receiver - Address to transfer NFT to.
286     /// @param _cutieId - ID of token to transfer.
287     function _transfer(address _receiver, uint40 _cutieId) internal {
288         // it will throw if transfer fails
289         coreContract.transfer(_receiver, _cutieId);
290     }
291 
292     /// @dev Computes owner's cut of a sale.
293     /// @param _price - Sale price of NFT.
294     function _computeFee(uint128 _price) internal view returns (uint128) {
295         // NOTE: We don't use SafeMath (or similar) in this function because
296         //  all of our entry functions carefully cap the maximum values for
297         //  currency (at 128-bits), and ownerFee <= 10000 (see the require()
298         //  statement in the ClockAuction constructor). The result of this
299         //  function is always guaranteed to be <= _price.
300         return _price * ownerFee / 10000;
301     }
302 
303     function withdraw() public
304     {
305         require(
306             msg.sender == owner ||
307             msg.sender == address(coreContract)
308         );
309         if (address(this).balance > 0)
310         {
311             address(coreContract).transfer(address(this).balance);
312         }
313     }
314 
315     function onRemove() public onlyCore
316     {
317         withdraw();
318     }
319 }
320 
321 
322 /// @title Item effect for Blockchain Cuties
323 /// @author https://BlockChainArchitect.io
324 contract CooldownDecreaseEffect is CutiePluginBase
325 {
326     function run(
327         uint40,
328         uint256,
329         address
330     ) 
331         public
332         payable
333         onlyCore
334     {
335         revert();
336     }
337 
338     function runSigned(
339         uint40 _cutieId,
340         uint256 _parameter,
341         address /*_owner*/
342     ) 
343         external
344         onlyCore
345         whenNotPaused
346         payable
347     {
348         uint16 cooldownIndex = coreContract.getCooldownIndex(_cutieId);
349         require(cooldownIndex > 0);
350         if (cooldownIndex > _parameter)
351         {
352             cooldownIndex -= uint16(_parameter);
353         }
354         else
355         {
356             cooldownIndex = 0;
357         }
358         coreContract.changeCooldownIndex(_cutieId, cooldownIndex);
359     }
360 }