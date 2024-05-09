1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is paused.
66    */
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused public {
76     paused = true;
77     emit Pause();
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     emit Unpause();
86   }
87 }
88 
89 
90 
91 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
92 contract PluginInterface
93 {
94     /// @dev simply a boolean to indicate this is the contract we expect to be
95     function isPluginInterface() public pure returns (bool);
96 
97     function onRemove() public;
98 
99     /// @dev Begins new feature.
100     /// @param _cutieId - ID of token to auction, sender must be owner.
101     /// @param _parameter - arbitrary parameter
102     /// @param _seller - Old owner, if not the message sender
103     function run(
104         uint40 _cutieId,
105         uint256 _parameter,
106         address _seller
107     ) 
108     public
109     payable;
110 
111     /// @dev Begins new feature, approved and signed by COO.
112     /// @param _cutieId - ID of token to auction, sender must be owner.
113     /// @param _parameter - arbitrary parameter
114     function runSigned(
115         uint40 _cutieId,
116         uint256 _parameter,
117         address _owner
118     )
119     external
120     payable;
121 
122     function withdraw() public;
123 }
124 
125 
126 
127 contract CutieCoreInterface
128 {
129     function isCutieCore() pure public returns (bool);
130 
131     function transferFrom(address _from, address _to, uint256 _cutieId) external;
132     function transfer(address _to, uint256 _cutieId) external;
133 
134     function ownerOf(uint256 _cutieId)
135         external
136         view
137         returns (address owner);
138 
139     function getCutie(uint40 _id)
140         external
141         view
142         returns (
143         uint256 genes,
144         uint40 birthTime,
145         uint40 cooldownEndTime,
146         uint40 momId,
147         uint40 dadId,
148         uint16 cooldownIndex,
149         uint16 generation
150     );
151 
152      function getGenes(uint40 _id)
153         public
154         view
155         returns (
156         uint256 genes
157     );
158 
159 
160     function getCooldownEndTime(uint40 _id)
161         public
162         view
163         returns (
164         uint40 cooldownEndTime
165     );
166 
167     function getCooldownIndex(uint40 _id)
168         public
169         view
170         returns (
171         uint16 cooldownIndex
172     );
173 
174 
175     function getGeneration(uint40 _id)
176         public
177         view
178         returns (
179         uint16 generation
180     );
181 
182     function getOptional(uint40 _id)
183         public
184         view
185         returns (
186         uint64 optional
187     );
188 
189 
190     function changeGenes(
191         uint40 _cutieId,
192         uint256 _genes)
193         public;
194 
195     function changeCooldownEndTime(
196         uint40 _cutieId,
197         uint40 _cooldownEndTime)
198         public;
199 
200     function changeCooldownIndex(
201         uint40 _cutieId,
202         uint16 _cooldownIndex)
203         public;
204 
205     function changeOptional(
206         uint40 _cutieId,
207         uint64 _optional)
208         public;
209 
210     function changeGeneration(
211         uint40 _cutieId,
212         uint16 _generation)
213         public;
214 }
215 
216 
217 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
218 contract CutiePluginBase is PluginInterface, Pausable
219 {
220     function isPluginInterface() public pure returns (bool)
221     {
222         return true;
223     }
224 
225     // Reference to contract tracking NFT ownership
226     CutieCoreInterface public coreContract;
227 
228     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
229     // Values 0-10,000 map to 0%-100%
230     uint16 public ownerFee;
231 
232     // @dev Throws if called by any account other than the owner.
233     modifier onlyCore() {
234         require(msg.sender == address(coreContract));
235         _;
236     }
237 
238     /// @dev Constructor creates a reference to the NFT ownership contract
239     ///  and verifies the owner cut is in the valid range.
240     /// @param _coreAddress - address of a deployed contract implementing
241     ///  the Nonfungible Interface.
242     /// @param _fee - percent cut the owner takes on each auction, must be
243     ///  between 0-10,000.
244     function setup(address _coreAddress, uint16 _fee) public {
245         require(_fee <= 10000);
246         require(msg.sender == owner);
247         ownerFee = _fee;
248         
249         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
250         require(candidateContract.isCutieCore());
251         coreContract = candidateContract;
252     }
253 
254     // @dev Set the owner's fee.
255     //  @param fee should be between 0-10,000.
256     function setFee(uint16 _fee) public
257     {
258         require(_fee <= 10000);
259         require(msg.sender == owner);
260 
261         ownerFee = _fee;
262     }
263 
264     /// @dev Returns true if the claimant owns the token.
265     /// @param _claimant - Address claiming to own the token.
266     /// @param _cutieId - ID of token whose ownership to verify.
267     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {
268         return (coreContract.ownerOf(_cutieId) == _claimant);
269     }
270 
271     /// @dev Escrows the NFT, assigning ownership to this contract.
272     /// Throws if the escrow fails.
273     /// @param _owner - Current owner address of token to escrow.
274     /// @param _cutieId - ID of token whose approval to verify.
275     function _escrow(address _owner, uint40 _cutieId) internal {
276         // it will throw if transfer fails
277         coreContract.transferFrom(_owner, this, _cutieId);
278     }
279 
280     /// @dev Transfers an NFT owned by this contract to another address.
281     /// Returns true if the transfer succeeds.
282     /// @param _receiver - Address to transfer NFT to.
283     /// @param _cutieId - ID of token to transfer.
284     function _transfer(address _receiver, uint40 _cutieId) internal {
285         // it will throw if transfer fails
286         coreContract.transfer(_receiver, _cutieId);
287     }
288 
289     /// @dev Computes owner's cut of a sale.
290     /// @param _price - Sale price of NFT.
291     function _computeFee(uint128 _price) internal view returns (uint128) {
292         // NOTE: We don't use SafeMath (or similar) in this function because
293         //  all of our entry functions carefully cap the maximum values for
294         //  currency (at 128-bits), and ownerFee <= 10000 (see the require()
295         //  statement in the ClockAuction constructor). The result of this
296         //  function is always guaranteed to be <= _price.
297         return _price * ownerFee / 10000;
298     }
299 
300     function withdraw() public
301     {
302         require(
303             msg.sender == owner ||
304             msg.sender == address(coreContract)
305         );
306         if (address(this).balance > 0)
307         {
308             address(coreContract).transfer(address(this).balance);
309         }
310     }
311 
312     function onRemove() public onlyCore
313     {
314         withdraw();
315     }
316 }
317 
318 
319 /// @title Item effect for Blockchain Cuties
320 /// @author https://BlockChainArchitect.io
321 contract GenerationDecreaseEffect is CutiePluginBase
322 {
323     function run(
324         uint40,
325         uint256,
326         address
327     ) 
328         public
329         payable
330         onlyCore
331     {
332         revert();
333     }
334 
335     function runSigned(
336         uint40 _cutieId,
337         uint256 _parameter,
338         address /*_owner*/
339     ) 
340         external
341         onlyCore
342         whenNotPaused
343         payable
344     {
345         uint16 generation = coreContract.getGeneration(_cutieId);
346         require(generation > 0);
347         if (generation > _parameter)
348         {
349             generation -= uint16(_parameter);
350         }
351         else
352         {
353             generation = 0;
354         }
355         coreContract.changeGeneration(_cutieId, generation);
356     }
357 }